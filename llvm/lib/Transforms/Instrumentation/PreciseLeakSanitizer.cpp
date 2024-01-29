#include "llvm/Transforms/Instrumentation/PreciseLeakSanitizer.h"

#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

#include <regex>

using namespace llvm;

PreciseLeakSanitizer *Plsan;

PreciseLeakSanVisitor::PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan)
    : Plsan(Plsan), LocalPtrVarListStack(), LocalPtrArrListStack() {}

void PreciseLeakSanVisitor::visitAllocaInst(AllocaInst &I) {
  IRBuilder<> Builder(&I);
  Type *AllocatedType = I.getAllocatedType();
  Value *NullPtr = ConstantPointerNull::get(Plsan.VoidPtrTy);
  bool IsPointerTy = AllocatedType->isPointerTy();

  Builder.SetInsertPoint(I.getNextNode());

  if (I.isArrayAllocation()) {
    if (IsPointerTy) {
      LocalPtrArrListStack.top().push_back(
          std::make_tuple(&I, I.getArraySize()));
      CallInst *InstrumentedInst =
          Builder.CreateMemSet(&I, NullPtr, I.getArraySize(), MaybeAlign());
      InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    }
  } else if (ArrayType *Arr = dyn_cast<ArrayType>(AllocatedType)) {
    ConstantInt *ArrSize = Builder.getInt64(Arr->getNumElements());
    LocalPtrArrListStack.top().push_back(std::make_tuple(&I, ArrSize));
    CallInst *InstrumentedInst =
        Builder.CreateMemSet(&I, NullPtr, ArrSize, MaybeAlign());
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
  } else if (IsPointerTy) {
    LocalPtrVarListStack.top().push_back(&I);
    StoreInst *InstrumentedInst = Builder.CreateStore(NullPtr, &I);
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
  }
}

void PreciseLeakSanVisitor::visitStoreInst(StoreInst &I) {
  Value *rhs = I.getValueOperand();
  if (rhs->getType()->isPointerTy()) {
    IRBuilder<> Builder(&I);
    Value *lhs = I.getPointerOperand();
    Plsan.CreateCallWithMetaData(Builder, Plsan.StoreFn, {lhs, rhs});
  }
}

void PreciseLeakSanVisitor::visitReturnInst(ReturnInst &I) {
  IRBuilder<> Builder(&I);
  Value *ReturnValue = I.getReturnValue();
  Value *TrueValue = ConstantInt::getTrue(Plsan.Ctx);

  // if return value is void
  if (ReturnValue == NULL)
    ReturnValue = ConstantPointerNull::get(Plsan.VoidPtrTy);

  std::vector<Value *> TopLocalPtrVarList = LocalPtrVarListStack.top();
  std::vector<ArrayAddrInfo> TopLocalPtrArrList = LocalPtrArrListStack.top();

  // Call __plsan_lazy_check
  while (!LazyCheckInfoStack.empty()) {
    Plsan.CreateCallWithMetaData(Builder, Plsan.LazyCheckFn,
                                 {LazyCheckInfoStack.top(), ReturnValue});
    LazyCheckInfoStack.pop();
  }

  // Call __plsan_free_stack_variables
  ConstantInt *VarCount = Builder.getInt64(TopLocalPtrVarList.size());
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), TrueValue);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), ReturnValue);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), VarCount);
  ArrayRef<Value *> VarArgs = ArrayRef<Value *>(TopLocalPtrVarList);
  Plsan.CreateCallWithMetaData(Builder, Plsan.FreeStackVariablesFn, VarArgs);

  // Stack pointer restored, then pop local variable stack.
  LocalPtrVarListStack.pop();

  // Call __plsan_free_stack_array, non-variable length array
  for (ArrayAddrInfo ArrAddrAndSize : TopLocalPtrArrList) {
    Value *ArrAddr = std::get<0>(ArrAddrAndSize);
    Value *Size = std::get<1>(ArrAddrAndSize);
    Plsan.CreateCallWithMetaData(Builder, Plsan.FreeStackArrayFn,
                                 {ArrAddr, Size, ReturnValue, TrueValue});
  }

  // Stack pointer restored, then pop local variable stack.
  LocalPtrArrListStack.pop();
}

Instruction *PreciseLeakSanVisitor::InstructionTraceTopDown(Instruction *I) {
  if (I->user_begin() == I->user_end()) {
    return I;
  } else {
    auto UI = I->user_begin();
    Value *user = *UI;
    if (Instruction *userInst = dyn_cast<Instruction>(user)) {
      return InstructionTraceTopDown(userInst);
    }
    return NULL;
  }
}

void PreciseLeakSanVisitor::visitCallInst(CallInst &I) {
  StringRef FuncName;
  Function *CallFunc = I.getCalledFunction();
  if (CallFunc)
    FuncName = CallFunc->getName();
  else
    return;

  if (I.getType()->isPointerTy()) {
    Value *RetAddr = &I;
    Instruction *LastInst = InstructionTraceTopDown(&I);
    IRBuilder<> Builder(LastInst);
    if (StoreInst *Inst = dyn_cast<StoreInst>(LastInst)) {
      Value *CompareAddr = Inst->getValueOperand();
      Plsan.CreateCallWithMetaData(Builder, Plsan.CheckReturnedOrStoredValueFn,
                                   {RetAddr, CompareAddr});
    } else if (ReturnInst *Inst = dyn_cast<ReturnInst>(LastInst)) {
      Value *CompareAddr = Inst->getReturnValue();
      // if return value is void
      if (CompareAddr == NULL)
        CompareAddr = ConstantPointerNull::get(Plsan.VoidPtrTy);
      Plsan.CreateCallWithMetaData(Builder, Plsan.CheckReturnedOrStoredValueFn,
                                   {RetAddr, CompareAddr});
    } else {
      Builder.SetInsertPoint(I.getNextNode());
      Plsan.CreateCallWithMetaData(Builder, Plsan.CheckMemoryLeakFn, {RetAddr});
    }
  }

  if (FuncName == "malloc")
    visitCallMalloc(I);
  if (FuncName == "calloc")
    visitCallCalloc(I);
  if (std::regex_match(FuncName.str(),
                       std::regex("^llvm\\.memcpy\\.[a-zA-Z0-9\\.\\*]*")))
    visitCallMemcpy(I);
  if (FuncName == "free")
    visitCallFree(I);
  if (FuncName == "llvm.stacksave")
    visitLLVMStacksave(I);
  if (FuncName == "llvm.stackrestore")
    visitLLVMStackrestore(I);
}

void PreciseLeakSanVisitor::visitCallMalloc(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *MallocSizeArg = I.getArgOperand(0);
  Value *AlignedMallocSizeArg =
      Plsan.CreateCallWithMetaData(Builder, Plsan.AlignFn, {MallocSizeArg});
  I.setArgOperand(0, AlignedMallocSizeArg);
  Builder.SetInsertPoint(I.getNextNode());
  Plsan.CreateCallWithMetaData(Builder, Plsan.AllocFn,
                               {&I, AlignedMallocSizeArg});
}

void PreciseLeakSanVisitor::visitCallCalloc(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *CallocNumArg = I.getArgOperand(0);
  Value *CallocSizeArg = I.getArgOperand(1);
  Value *AllocSize = Builder.CreateMul(CallocNumArg, CallocSizeArg);
  ConstantInt *AlignedCallocNumArg =
      ConstantInt::get(Type::getInt64Ty(Plsan.Ctx), 1);
  Value *AlignedCallocSizeArg =
      Plsan.CreateCallWithMetaData(Builder, Plsan.AlignFn, {AllocSize});
  I.setArgOperand(0, AlignedCallocNumArg);
  I.setArgOperand(1, AlignedCallocSizeArg);
  Builder.SetInsertPoint(I.getNextNode());
  Plsan.CreateCallWithMetaData(Builder, Plsan.AllocFn,
                               {&I, AlignedCallocSizeArg});
}

void PreciseLeakSanVisitor::visitCallRealloc(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *ReallocOriginPtrArg = I.getArgOperand(0);
  Builder.SetInsertPoint(I.getNextNode());
  Plsan.CreateCallWithMetaData(Builder, Plsan.ReallocInstrumentFn,
                               {ReallocOriginPtrArg, &I});
}

void PreciseLeakSanVisitor::visitCallNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallArrTyNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallFree(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *FreeAddrArg = I.getArgOperand(0);
  Builder.SetInsertPoint(I.getNextNode());
  Plsan.CreateCallWithMetaData(Builder, Plsan.FreeFn, {FreeAddrArg});
}

void PreciseLeakSanVisitor::visitCallMemset(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMemcpy(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *MemcpyDestPtrArg = I.getArgOperand(0);
  Value *MemcpySrcPtrArg = I.getArgOperand(1);
  Value *MemcpyCountArg = I.getArgOperand(2);
  Plsan.CreateCallWithMetaData(
      Builder, Plsan.MemcpyRefcntFn,
      {MemcpyDestPtrArg, MemcpySrcPtrArg, MemcpyCountArg});
}

void PreciseLeakSanVisitor::visitCallMemmove(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallBzero(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitLLVMStacksave(CallInst &I) {
  LocalPtrVarListStack.push(std::vector<Value *>());
  LocalPtrArrListStack.push(std::vector<ArrayAddrInfo>());
}

void PreciseLeakSanVisitor::visitLLVMStackrestore(CallInst &I) {
  // Call __plsan_free_stack_array, variable length array
  // LocalPtrVLAListStack size and LocalStackrestoreStack size are always same.
  IRBuilder<> Builder(&I);
  Value *NullPtr = ConstantPointerNull::get(Plsan.VoidPtrTy);
  Value *FalseValue = ConstantInt::getFalse(Plsan.Ctx);

  std::vector<Value *> TopLocalPtrVarList = LocalPtrVarListStack.top();
  std::vector<ArrayAddrInfo> TopLocalPtrArrList = LocalPtrArrListStack.top();

  ConstantInt *VarCount = Builder.getInt64(TopLocalPtrVarList.size());
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), FalseValue);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), NullPtr);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), VarCount);
  ArrayRef<Value *> VarArgs = ArrayRef<Value *>(TopLocalPtrVarList);
  CallInst *FreeStackVariablesFnCall = Plsan.CreateCallWithMetaData(
      Builder, Plsan.FreeStackVariablesFn, VarArgs);
  LazyCheckInfoStack.push(FreeStackVariablesFnCall);

  // Stack pointer restored, then pop local variable stack.
  LocalPtrVarListStack.pop();

  for (ArrayAddrInfo ArrAddrAndSize : TopLocalPtrArrList) {
    Value *ArrAddr = std::get<0>(ArrAddrAndSize);
    Value *Size = std::get<1>(ArrAddrAndSize);
    CallInst *FreeStackArrayFnCall = Plsan.CreateCallWithMetaData(
        Builder, Plsan.FreeStackArrayFn, {ArrAddr, Size, NullPtr, FalseValue});
    LazyCheckInfoStack.push(FreeStackArrayFnCall);
  }

  // Stack pointer restored, then pop local variable stack.
  LocalPtrArrListStack.pop();
}

bool PreciseLeakSanitizer::initializeModule() {

  PlsanMD = MDNode::get(Ctx, MDString::get(Ctx, "instrumented by plsan"));

  VoidTy = Type::getVoidTy(Ctx);
  VoidPtrTy = PointerType::getUnqual(VoidTy);
  VoidPtrPtrTy = PointerType::getUnqual(VoidPtrTy);
  Int32Ty = Type::getInt32Ty(Ctx);
  Int64Ty = Type::getInt64Ty(Ctx);
  BoolTy = Type::getInt1Ty(Ctx);

  AlignFnTy = FunctionType::get(Int64Ty, {Int64Ty}, false);
  AlignFn = Mod.getOrInsertFunction(AlignFnName, AlignFnTy);

  AllocFnTy = FunctionType::get(VoidTy, {VoidPtrTy, Int64Ty}, false);
  AllocFn = Mod.getOrInsertFunction(AllocFnName, AllocFnTy);

  FreeFnTy = FunctionType::get(VoidTy, {VoidPtrTy}, false);
  FreeFn = Mod.getOrInsertFunction(FreeFnName, FreeFnTy);

  StoreFnTy = FunctionType::get(VoidTy, {VoidPtrPtrTy, VoidPtrTy}, false);
  StoreFn = Mod.getOrInsertFunction(StoreFnName, StoreFnTy);

  FreeStackVariablesFnTy =
      FunctionType::get(VoidPtrTy, {Int64Ty, VoidPtrTy, Int32Ty}, true);
  FreeStackVariablesFn =
      Mod.getOrInsertFunction(FreeStackVariablesFnName, FreeStackVariablesFnTy);

  FreeStackArrayFnTy = FunctionType::get(
      VoidPtrTy, {VoidPtrPtrTy, Int64Ty, VoidPtrTy, BoolTy}, false);
  FreeStackArrayFn =
      Mod.getOrInsertFunction(FreeStackArrayFnName, FreeStackArrayFnTy);

  LazyCheckFnTy = FunctionType::get(VoidPtrTy, {VoidPtrTy, VoidPtrTy}, false);
  LazyCheckFn = Mod.getOrInsertFunction(LazyCheckFnName, LazyCheckFnTy);

  CheckReturnedOrStoredValueFnTy =
      FunctionType::get(VoidTy, {VoidPtrTy, VoidPtrTy}, false);
  CheckReturnedOrStoredValueFn = Mod.getOrInsertFunction(
      CheckReturnedOrStoredValueFnName, CheckReturnedOrStoredValueFnTy);

  CheckMemoryLeakFnTy = FunctionType::get(VoidTy, {VoidPtrTy}, false);
  CheckMemoryLeakFn =
      Mod.getOrInsertFunction(CheckMemoryLeakFnName, CheckMemoryLeakFnTy);

  MemcpyRefcntFnTy =
      FunctionType::get(VoidTy, {VoidPtrTy, VoidPtrTy, Int64Ty}, false);
  MemcpyRefcntFn =
      Mod.getOrInsertFunction(MemcpyRefcntFnName, MemcpyRefcntFnTy);

  ReallocInstrumentFnTy =
      FunctionType::get(VoidTy, {VoidPtrTy, VoidPtrTy}, false);
  ReallocInstrumentFn =
      Mod.getOrInsertFunction(ReallocInstrumentFnName, ReallocInstrumentFnTy);

  return true;
}

void PreciseLeakSanVisitor::pushNewLocalPtrVarListStack() {
  LocalPtrVarListStack.push(std::vector<Value *>());
}

void PreciseLeakSanVisitor::pushNewLocalPtrArrListStack() {
  LocalPtrArrListStack.push(std::vector<ArrayAddrInfo>());
}

PreciseLeakSanitizer::PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx)
    : Mod(Mod), Ctx(Ctx) {}

bool PreciseLeakSanitizer::run() {
  Plsan->initializeModule();
  PreciseLeakSanVisitor visitor(*Plsan);

  for (Function &F : Mod) {
    // Stack pointer saved, then push local variable stack.
    visitor.pushNewLocalPtrVarListStack();
    visitor.pushNewLocalPtrArrListStack();
    for (BasicBlock &BB : F) {
      for (Instruction &I : BB) {
        if (I.getMetadata(Plsan->PlsanMDName))
          continue;
        visitor.visit(I);
      }
    }
  }
  return false;
}

CallInst *PreciseLeakSanitizer::CreateCallWithMetaData(IRBuilder<> &Builder,
                                                       FunctionCallee Fn,
                                                       ArrayRef<Value *> Args) {
  CallInst *InstrumentedInst = Builder.CreateCall(Fn, Args);
  InstrumentedInst->setMetadata(PlsanMDName, PlsanMD);
  return InstrumentedInst;
}

PreservedAnalyses PreciseLeakSanitizerPass::run(Module &M,
                                                ModuleAnalysisManager &) {
  Plsan = new PreciseLeakSanitizer(M, M.getContext());
  return (Plsan->run() ? PreservedAnalyses::none() : PreservedAnalyses::all());
}

llvm::PassPluginLibraryInfo getPreciseLeakSanitizerPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "precise-leak-sanitizer",
          LLVM_VERSION_STRING, [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &MPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "precise-leak-sanitizer") {
                    MPM.addPass(PreciseLeakSanitizerPass());
                    return true;
                  }
                  return false;
                });
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel Level) {
                  MPM.addPass(PreciseLeakSanitizerPass());
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getPreciseLeakSanitizerPluginInfo();
}
