#include "llvm/Transforms/Instrumentation/PreciseLeakSanitizer.h"

#include "llvm/IR/DataLayout.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

#include <regex>

using namespace llvm;

PreciseLeakSanitizer *Plsan;

PreciseLeakSanVisitor::PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan)
    : Plsan(Plsan), LocalVarListStack() {}

void PreciseLeakSanVisitor::visitAllocaInst(AllocaInst &I) {
  IRBuilder<> Builder(&I);
  Value *Zero = ConstantInt::get(Type::getInt8Ty(Plsan.Ctx), 0);
  Type *AllocatedType = I.getAllocatedType();
  const DataLayout &DL = Plsan.Mod.getDataLayout();

  Builder.SetInsertPoint(I.getNextNode());
  std::optional<TypeSize> Size = I.getAllocationSize(DL);

  // XXX: Optimize by removing unnecessary instrumentations
  if (Size.has_value()) {
    CallInst *InstrumentedInst =
        Builder.CreateMemSet(&I, Zero, Size.value(), MaybeAlign());
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    Value *SizeValue = ConstantInt::get(Type::getInt64Ty(Plsan.Ctx),
                                        DL.getTypeAllocSize(AllocatedType));
    LocalVarListStack.top().push_back({&I, SizeValue});
  } else if (I.isArrayAllocation()) {
    Value *TypeSize = ConstantInt::get(Type::getInt64Ty(Plsan.Ctx),
                                       DL.getTypeAllocSize(AllocatedType));
    Value *SizeValue = Builder.CreateMul(TypeSize, I.getArraySize());
    CallInst *InstrumentedInst =
        Builder.CreateMemSet(&I, Zero, SizeValue, MaybeAlign());
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    LocalVarListStack.top().push_back({&I, SizeValue});
  } else {
    report_fatal_error(
        "PreciseLeakSanitizer: Can't get the size of an alloca inst");
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

  std::vector<VarAddrSizeInfo> TopLocalVarList = LocalVarListStack.top();

  // Call __plsan_lazy_check
  while (!LazyCheckInfoStack.empty()) {
    Plsan.CreateCallWithMetaData(Builder, Plsan.LazyCheckFn,
                                 {LazyCheckInfoStack.top(), ReturnValue});
    LazyCheckInfoStack.pop();
  }

  // Call __plsan_free_stack_array, non-variable length array
  for (VarAddrSizeInfo AddrAndSize : TopLocalVarList) {
    Value *ArrAddr = std::get<0>(AddrAndSize);
    Value *Size = std::get<1>(AddrAndSize);
    Plsan.CreateCallWithMetaData(Builder, Plsan.FreeLocalVariableFn,
                                 {ArrAddr, Size, ReturnValue, TrueValue});
  }

  // Stack pointer restored, then pop local variable stack.
  LocalVarListStack.pop();
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

  if (std::regex_match(FuncName.str(),
                       std::regex("^llvm\\.memcpy\\.[a-zA-Z0-9\\.\\*]*")))
    visitCallMemcpy(I);
  if (FuncName == "llvm.stacksave")
    visitLLVMStacksave(I);
  if (FuncName == "llvm.stackrestore")
    visitLLVMStackrestore(I);
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
  LocalVarListStack.push(std::vector<VarAddrSizeInfo>());
}

void PreciseLeakSanVisitor::visitLLVMStackrestore(CallInst &I) {
  // Call __plsan_free_stack_array, variable length array
  // LocalPtrVLAListStack size and LocalStackrestoreStack size are always same.
  IRBuilder<> Builder(&I);
  Value *NullPtr = ConstantPointerNull::get(Plsan.VoidPtrTy);
  Value *FalseValue = ConstantInt::getFalse(Plsan.Ctx);

  std::vector<VarAddrSizeInfo> TopLocalVarList = LocalVarListStack.top();

  for (VarAddrSizeInfo T : TopLocalVarList) {
    Value *ArrAddr = std::get<0>(T);
    Value *Size = std::get<1>(T);
    CallInst *FreeLocalVariableFnCall =
        Plsan.CreateCallWithMetaData(Builder, Plsan.FreeLocalVariableFn,
                                     {ArrAddr, Size, NullPtr, FalseValue});
    LazyCheckInfoStack.push(FreeLocalVariableFnCall);
  }

  // Stack pointer restored, then pop local variable stack.
  LocalVarListStack.pop();
}

bool PreciseLeakSanitizer::initializeModule() {

  PlsanMD = MDNode::get(Ctx, MDString::get(Ctx, "instrumented by plsan"));

  VoidTy = Type::getVoidTy(Ctx);
  VoidPtrTy = PointerType::getUnqual(VoidTy);
  VoidPtrPtrTy = PointerType::getUnqual(VoidPtrTy);
  Int32Ty = Type::getInt32Ty(Ctx);
  Int64Ty = Type::getInt64Ty(Ctx);
  BoolTy = Type::getInt1Ty(Ctx);

  StoreFnTy = FunctionType::get(VoidTy, {VoidPtrPtrTy, VoidPtrTy}, false);
  StoreFn = Mod.getOrInsertFunction(StoreFnName, StoreFnTy);

  FreeLocalVariableFnTy = FunctionType::get(
      VoidPtrTy, {VoidPtrPtrTy, Int64Ty, VoidPtrTy, BoolTy}, false);
  FreeLocalVariableFn =
      Mod.getOrInsertFunction(FreeLocalVariableFnName, FreeLocalVariableFnTy);

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

void PreciseLeakSanVisitor::pushNewLocalVarListStack() {
  LocalVarListStack.push(std::vector<VarAddrSizeInfo>());
}

PreciseLeakSanitizer::PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx)
    : Mod(Mod), Ctx(Ctx) {}

bool PreciseLeakSanitizer::run() {
  Plsan->initializeModule();
  PreciseLeakSanVisitor visitor(*Plsan);

  for (Function &F : Mod) {
    // Stack pointer saved, then push local variable stack.
    visitor.pushNewLocalVarListStack();
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
