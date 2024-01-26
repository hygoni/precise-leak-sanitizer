#include "PreciseLeakSanitizer.h"

#include "llvm/IR/IRBuilder.h"
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
  bool IsPointerTy = AllocatedType->isPointerTy();
  if (I.isArrayAllocation()) {
    if (IsPointerTy) {
      LocalPtrArrListStack.top().push_back(
          std::make_tuple(&I, I.getArraySize()));
    }
  } else if (ArrayType *Arr = dyn_cast<ArrayType>(AllocatedType)) {
    ConstantInt *ArrSize = Builder.getInt64(Arr->getNumElements());
    LocalPtrArrListStack.top().push_back(std::make_tuple(&I, ArrSize));
  } else if (IsPointerTy) {
    LocalPtrVarListStack.top().push_back(&I);
  }
}

void PreciseLeakSanVisitor::visitStoreInst(StoreInst &I) {
  Value *rhs = I.getValueOperand();
  if (rhs->getType()->isPointerTy()) {
    IRBuilder<> Builder(&I);
    Value *lhs = I.getPointerOperand();
    Builder.CreateCall(Plsan.StoreFn, {lhs, rhs});
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
    Builder.CreateCall(Plsan.LazyCheckFn,
                       {LazyCheckInfoStack.top(), ReturnValue});
    LazyCheckInfoStack.pop();
  }

  // Call __plsan_free_stack_variables
  ConstantInt *VarCount = Builder.getInt64(TopLocalPtrVarList.size());
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), TrueValue);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), ReturnValue);
  TopLocalPtrVarList.insert(TopLocalPtrVarList.begin(), VarCount);
  ArrayRef<Value *> VarArgs = ArrayRef<Value *>(TopLocalPtrVarList);
  Builder.CreateCall(Plsan.FreeStackVariablesFn, VarArgs);

  // Stack pointer restored, then pop local variable stack.
  LocalPtrVarListStack.pop();

  // Call __plsan_free_stack_array, non-variable length array
  for (ArrayAddrInfo ArrAddrAndSize : TopLocalPtrArrList) {
    Value *ArrAddr = std::get<0>(ArrAddrAndSize);
    Value *Size = std::get<1>(ArrAddrAndSize);
    Builder.CreateCall(Plsan.FreeStackArrayFn,
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

  if (FuncName == Plsan.AlignFnName || FuncName == Plsan.AllocFnName ||
      FuncName == Plsan.FreeFnName || FuncName == Plsan.StoreFnName ||
      FuncName == Plsan.FreeStackVariablesFnName ||
      FuncName == Plsan.FreeStackArrayFnName ||
      FuncName == Plsan.LazyCheckFnName ||
      FuncName == Plsan.CheckReturnedOrStoredValueFnName ||
      FuncName == Plsan.CheckMemoryLeakFnName ||
      FuncName == Plsan.MemcpyRefcntFnName)
    return;

  if (I.getType()->isPointerTy()) {
    Value *RetAddr = &I;
    Instruction *LastInst = InstructionTraceTopDown(&I);
    IRBuilder<> Builder(LastInst);
    if (StoreInst *Inst = dyn_cast<StoreInst>(LastInst)) {
      Value *CompareAddr = Inst->getValueOperand();
      Builder.CreateCall(Plsan.CheckReturnedOrStoredValueFn,
                         {RetAddr, CompareAddr});
    } else if (ReturnInst *Inst = dyn_cast<ReturnInst>(LastInst)) {
      Value *CompareAddr = Inst->getReturnValue();
      // if return value is void
      if (CompareAddr == NULL)
        CompareAddr = ConstantPointerNull::get(Plsan.VoidPtrTy);
      Builder.CreateCall(Plsan.CheckReturnedOrStoredValueFn,
                         {RetAddr, CompareAddr});
    } else {
      Builder.SetInsertPoint(I.getNextNode());
      Builder.CreateCall(Plsan.CheckMemoryLeakFn, {RetAddr});
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
      Builder.CreateCall(Plsan.AlignFn, {MallocSizeArg});
  I.setArgOperand(0, AlignedMallocSizeArg);
  Builder.SetInsertPoint(I.getNextNode());
  Builder.CreateCall(Plsan.AllocFn, {&I, AlignedMallocSizeArg});
}

void PreciseLeakSanVisitor::visitCallCalloc(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *CallocNumArg = I.getArgOperand(0);
  Value *CallocSizeArg = I.getArgOperand(1);
  Value *AllocSize = Builder.CreateMul(CallocNumArg, CallocSizeArg);
  ConstantInt *AlignedCallocNumArg =
      ConstantInt::get(Type::getInt64Ty(Plsan.Ctx), 1);
  Value *AlignedCallocSizeArg = Builder.CreateCall(Plsan.AlignFn, {AllocSize});
  I.setArgOperand(0, AlignedCallocNumArg);
  I.setArgOperand(1, AlignedCallocSizeArg);
  Builder.SetInsertPoint(I.getNextNode());
  Builder.CreateCall(Plsan.AllocFn, {&I, AlignedCallocSizeArg});
}

void PreciseLeakSanVisitor::visitCallNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallArrTyNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallFree(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *FreeAddrArg = I.getArgOperand(0);
  Builder.SetInsertPoint(I.getNextNode());
  Builder.CreateCall(Plsan.FreeFn, {FreeAddrArg});
}

void PreciseLeakSanVisitor::visitCallMemset(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMemcpy(CallInst &I) {
  IRBuilder<> Builder(&I);
  Value *MemcpyDestPtrArg = I.getArgOperand(0);
  Value *MemcpySrcPtrArg = I.getArgOperand(1);
  Value *MemcpyCountArg = I.getArgOperand(2);
  Builder.CreateCall(Plsan.MemcpyRefcntFn,
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
  CallInst *FreeStackVariablesFnCall =
      Builder.CreateCall(Plsan.FreeStackVariablesFn, VarArgs);
  LazyCheckInfoStack.push(FreeStackVariablesFnCall);

  // Stack pointer restored, then pop local variable stack.
  LocalPtrVarListStack.pop();

  for (ArrayAddrInfo ArrAddrAndSize : TopLocalPtrArrList) {
    Value *ArrAddr = std::get<0>(ArrAddrAndSize);
    Value *Size = std::get<1>(ArrAddrAndSize);
    CallInst *FreeStackArrayFnCall = Builder.CreateCall(
        Plsan.FreeStackArrayFn, {ArrAddr, Size, NullPtr, FalseValue});
    LazyCheckInfoStack.push(FreeStackArrayFnCall);
  }

  // Stack pointer restored, then pop local variable stack.
  LocalPtrArrListStack.pop();
}

bool PreciseLeakSanitizer::initializeModule() {

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
        visitor.visit(I);
      }
    }
  }
  return false;
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
