#include "llvm/Transforms/Instrumentation/PreciseLeakSanitizer.h"

#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/IntrinsicInst.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

#include <vector>

using namespace llvm;

PreciseLeakSanitizer *Plsan;

PreciseLeakSanVisitor::PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan)
    : Plsan(Plsan), LocalVarListStack() {}

void PreciseLeakSanVisitor::visitAllocaInst(AllocaInst &I) {
  IRBuilder<> Builder(&I);
  Value *Zero = ConstantInt::get(Type::getInt8Ty(Plsan.Ctx), 0);
  Value *TrueValue = ConstantInt::getTrue(Plsan.Ctx);
  Value *FalseValue = ConstantInt::getFalse(Plsan.Ctx);
  Type *AllocatedType = I.getAllocatedType();
  const DataLayout &DL = Plsan.Mod.getDataLayout();

  Builder.SetInsertPoint(I.getNextNode());
  std::optional<TypeSize> Size = I.getAllocationSize(DL);
  Type *Ty = I.getAllocatedType();

  Value *SizeValue;

  // XXX: Optimize by removing unnecessary instrumentations
  if (I.isArrayAllocation()) {
    if (Ty->isArrayTy()) {
      Type *ElementType = Ty->getArrayElementType();
      if (ElementType->isIntegerTy() || ElementType->isFloatingPointTy())
        return;
    }
    Value *TypeSize = ConstantInt::get(Type::getInt64Ty(Plsan.Ctx),
                                       DL.getTypeAllocSize(AllocatedType));
    SizeValue = Builder.CreateMul(TypeSize, I.getArraySize());
  } else if (Size.has_value()) {
    if (Ty->isIntegerTy() || Ty->isFloatingPointTy())
      return;
    if (Ty->isArrayTy()) {
      Type *ElementType = Ty->getArrayElementType();
      if (ElementType->isIntegerTy() || ElementType->isFloatingPointTy())
        return;
    }
    SizeValue = ConstantInt::get(Type::getInt64Ty(Plsan.Ctx),
                                 DL.getTypeAllocSize(AllocatedType));
  } else {
    report_fatal_error(
        "PreciseLeakSanitizer: Can't get the size of an alloca inst");
  }

  // if is builtin alloca
  if (!I.getParent()->isEntryBlock()) {
    IRBuilder<> BuilderForParentFunction(CurrentFunctionEntryBlock,
                                         CurrentFunctionEntryBlock->begin());

    AllocaInst *IsExecuted =
        BuilderForParentFunction.CreateAlloca(Plsan.BoolTy);
    IsExecuted->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    StoreInst *StoreFalse =
        BuilderForParentFunction.CreateStore(FalseValue, IsExecuted);
    StoreFalse->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);

    CallInst *InstrumentedInst =
        Builder.CreateMemSet(&I, Zero, SizeValue, MaybeAlign());
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    StoreInst *StoreTrue = Builder.CreateStore(TrueValue, IsExecuted);
    StoreTrue->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);

    BuiltinAllocaStack.top().push_back({&I, SizeValue, IsExecuted});
  } else {
    CallInst *InstrumentedInst =
        Builder.CreateMemSet(&I, Zero, SizeValue, MaybeAlign());
    InstrumentedInst->setMetadata(Plsan.PlsanMDName, Plsan.PlsanMD);
    LocalVarListStack.top().push_back({&I, SizeValue});
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
  if (ReturnValue == NULL || !ReturnValue->getType()->isPointerTy())
    ReturnValue = ConstantPointerNull::get(Plsan.VoidPtrTy);

  std::vector<VarAddrSizeInfo> TopLocalVarList = LocalVarListStack.top();
  std::vector<VarAddrSizeInfoForBuiltinAlloca> TopBuiltinAllocaList =
      BuiltinAllocaStack.top();

  // Call __plsan_lazy_check
  // if (isVLAExist)
  //   Plsan.CreateCallWithMetaData(Builder, Plsan.LazyCheckFn, {ReturnValue});

  // Call __plsan_free_stack_array, non-variable length array
  for (VarAddrSizeInfo AddrAndSize : TopLocalVarList) {
    Value *ArrAddr = std::get<0>(AddrAndSize);
    Value *Size = std::get<1>(AddrAndSize);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.FreeLocalVariableFn,
        {ArrAddr, Size, ReturnValue, TrueValue, TrueValue});
  }

  for (VarAddrSizeInfoForBuiltinAlloca AddrAndSize : TopBuiltinAllocaList) {
    Value *ArrAddr = std::get<0>(AddrAndSize);
    Value *Size = std::get<1>(AddrAndSize);
    Value *IsExecuted = std::get<2>(AddrAndSize);
    LoadInst *IsExecutedLoad = Builder.CreateLoad(Plsan.BoolTy, IsExecuted);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.FreeLocalVariableFn,
        {ArrAddr, Size, ReturnValue, TrueValue, IsExecutedLoad});
  }

  // Stack pointer restored, then pop local variable stack.
  LocalVarListStack.pop();

  BuiltinAllocaStack.pop();
}

// Instruction *PreciseLeakSanVisitor::InstructionTraceTopDown(Instruction *I) {
//   if (I->user_begin() == I->user_end()) {
//     return I;
//   } else {
//     auto UI = I->user_begin();
//     Value *user = *UI;
//     if (Instruction *userInst = dyn_cast<Instruction>(user)) {
//       return InstructionTraceTopDown(userInst);
//     }
//     return NULL;
//   }
// }

void PreciseLeakSanVisitor::visitCallInst(CallInst &I) {
  StringRef FuncName;
  Function *CallFunc = I.getCalledFunction();
  if (CallFunc)
    FuncName = CallFunc->getName();
  else
    return;

  // if (I.getType()->isPointerTy()) {
  //   Value *RetAddr = &I;
  //   Instruction *LastInst = InstructionTraceTopDown(&I);
  //   IRBuilder<> Builder(LastInst);
  //   if (StoreInst *Inst = dyn_cast<StoreInst>(LastInst)) {
  //     Value *CompareAddr = Inst->getValueOperand();
  //     Plsan.CreateCallWithMetaData(Builder, Plsan.CheckReturnedOrStoredValueFn,
  //                                  {RetAddr, CompareAddr});
  //   } else if (ReturnInst *Inst = dyn_cast<ReturnInst>(LastInst)) {
  //     Value *CompareAddr = Inst->getReturnValue();
  //     // if return value is void
  //     if (CompareAddr == NULL)
  //       CompareAddr = ConstantPointerNull::get(Plsan.VoidPtrTy);
  //     Plsan.CreateCallWithMetaData(Builder, Plsan.CheckReturnedOrStoredValueFn,
  //                                  {RetAddr, CompareAddr});
  //   } else {
  //     Builder.SetInsertPoint(I.getNextNode());
  //     Plsan.CreateCallWithMetaData(Builder, Plsan.CheckMemoryLeakFn, {RetAddr});
  //   }
  // }

  if (FuncName == "llvm.stacksave")
    visitLLVMStacksave(I);
  if (FuncName == "llvm.stackrestore")
    visitLLVMStackrestore(I);

  if (MemIntrinsic *MI = dyn_cast<MemIntrinsic>(&I))
    IntrinToInstrument.push_back(MI);
}

void PreciseLeakSanVisitor::visitMemIntrinsics(MemIntrinsic &I) {
  IRBuilder<> Builder(&I);
  if (MemSetInst *Inst = dyn_cast<MemSetInst>(&I)) {
    Value *MemsetPtrArg = I.getArgOperand(0);
    Value *MemsetValueArg = I.getArgOperand(1);
    Value *MemsetNumArg = I.getArgOperand(2);
    Plsan.CreateCallWithMetaData(Builder, Plsan.MemsetFn,
                                 {MemsetPtrArg, MemsetValueArg, MemsetNumArg});
  } else if (MemCpyInst *Inst = dyn_cast<MemCpyInst>(&I)) {
    Value *MemcpyDestPtrArg = I.getArgOperand(0);
    Value *MemcpySrcPtrArg = I.getArgOperand(1);
    Value *MemcpyCountArg = I.getArgOperand(2);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.MemcpyFn,
        {MemcpyDestPtrArg, MemcpySrcPtrArg, MemcpyCountArg});
  } else if (MemMoveInst *Inst = dyn_cast<MemMoveInst>(&I)) {
    Value *MemmoveDestPtrArg = I.getArgOperand(0);
    Value *MemmoveSrcPtrArg = I.getArgOperand(1);
    Value *MemmoveNumArg = I.getArgOperand(2);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.MemmoveFn,
        {MemmoveDestPtrArg, MemmoveSrcPtrArg, MemmoveNumArg});
  }
  I.eraseFromParent();
}

void PreciseLeakSanVisitor::visitCallBzero(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitLLVMStacksave(CallInst &I) {
  LocalVarListStack.push(std::vector<VarAddrSizeInfo>());
  BuiltinAllocaStack.push(std::vector<VarAddrSizeInfoForBuiltinAlloca>());
}

void PreciseLeakSanVisitor::visitLLVMStackrestore(CallInst &I) {
  // Call __plsan_free_stack_array, variable length array
  // LocalPtrVLAListStack size and LocalStackrestoreStack size are always same.
  IRBuilder<> Builder(&I);
  Value *NullPtr = ConstantPointerNull::get(Plsan.VoidPtrTy);
  Value *TrueValue = ConstantInt::getTrue(Plsan.Ctx);
  Value *FalseValue = ConstantInt::getFalse(Plsan.Ctx);

  std::vector<VarAddrSizeInfo> TopLocalVarList = LocalVarListStack.top();
  std::vector<VarAddrSizeInfoForBuiltinAlloca> TopBuiltinAllocaList =
      BuiltinAllocaStack.top();

  for (VarAddrSizeInfo T : TopLocalVarList) {
    Value *ArrAddr = std::get<0>(T);
    Value *Size = std::get<1>(T);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.FreeLocalVariableFn,
        {ArrAddr, Size, NullPtr, FalseValue, TrueValue});
  }

  for (VarAddrSizeInfoForBuiltinAlloca AddrAndSize : TopBuiltinAllocaList) {
    Value *ArrAddr = std::get<0>(AddrAndSize);
    Value *Size = std::get<1>(AddrAndSize);
    Value *IsExecuted = std::get<2>(AddrAndSize);
    LoadInst *IsExecutedLoad = Builder.CreateLoad(Plsan.BoolTy, IsExecuted);
    Plsan.CreateCallWithMetaData(
        Builder, Plsan.FreeLocalVariableFn,
        {ArrAddr, Size, NullPtr, FalseValue, IsExecutedLoad});
  }

  isVLAExist = true;

  // Stack pointer restored, then pop local variable stack.
  LocalVarListStack.pop();

  BuiltinAllocaStack.pop();
}

bool PreciseLeakSanitizer::initializeModule() {

  PlsanMD = MDNode::get(Ctx, MDString::get(Ctx, "instrumented by plsan"));

  VoidTy = Type::getVoidTy(Ctx);
  VoidPtrTy = PointerType::getUnqual(Type::getInt8Ty(Ctx));
  VoidPtrPtrTy = PointerType::getUnqual(VoidPtrTy);
  Int32Ty = Type::getInt32Ty(Ctx);
  Int64Ty = Type::getInt64Ty(Ctx);
  BoolTy = Type::getInt1Ty(Ctx);

  StoreFnTy = FunctionType::get(VoidTy, {VoidPtrPtrTy, VoidPtrTy}, false);
  StoreFn = Mod.getOrInsertFunction(StoreFnName, StoreFnTy);

  FreeLocalVariableFnTy = FunctionType::get(
      VoidTy, {VoidPtrPtrTy, Int64Ty, VoidPtrTy, BoolTy, BoolTy}, false);
  FreeLocalVariableFn =
      Mod.getOrInsertFunction(FreeLocalVariableFnName, FreeLocalVariableFnTy);

  LazyCheckFnTy = FunctionType::get(VoidTy, {VoidPtrTy, VoidPtrTy}, false);
  LazyCheckFn = Mod.getOrInsertFunction(LazyCheckFnName, LazyCheckFnTy);

  CheckReturnedOrStoredValueFnTy =
      FunctionType::get(VoidTy, {VoidPtrTy, VoidPtrTy}, false);
  CheckReturnedOrStoredValueFn = Mod.getOrInsertFunction(
      CheckReturnedOrStoredValueFnName, CheckReturnedOrStoredValueFnTy);

  CheckMemoryLeakFnTy = FunctionType::get(VoidTy, {VoidPtrTy}, false);
  CheckMemoryLeakFn =
      Mod.getOrInsertFunction(CheckMemoryLeakFnName, CheckMemoryLeakFnTy);

  MemsetFnTy =
      FunctionType::get(VoidPtrTy, {VoidPtrTy, Int32Ty, Int64Ty}, false);
  MemsetFn = Mod.getOrInsertFunction(MemsetFnName, MemsetFnTy);

  MemcpyFnTy =
      FunctionType::get(VoidPtrTy, {VoidPtrTy, VoidPtrTy, Int64Ty}, false);
  MemcpyFn = Mod.getOrInsertFunction(MemcpyFnName, MemcpyFnTy);

  MemmoveFnTy =
      FunctionType::get(VoidPtrTy, {VoidPtrTy, VoidPtrTy, Int64Ty}, false);
  MemmoveFn = Mod.getOrInsertFunction(MemmoveFnName, MemmoveFnTy);

  return true;
}

void PreciseLeakSanVisitor::pushNewLocalVarListStack() {
  LocalVarListStack.push(std::vector<VarAddrSizeInfo>());
}

void PreciseLeakSanVisitor::pushNewBuiltinAllocaStack() {
  BuiltinAllocaStack.push(std::vector<VarAddrSizeInfoForBuiltinAlloca>());
}

void PreciseLeakSanVisitor::setCurrentFunctionEntryBlock(BasicBlock &BB) {
  CurrentFunctionEntryBlock = &BB;
}

std::vector<MemIntrinsic *> PreciseLeakSanVisitor::getIntrinToInstrument() {
  return IntrinToInstrument;
}

PreciseLeakSanitizer::PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx)
    : Mod(Mod), Ctx(Ctx) {}

bool PreciseLeakSanitizer::run() {
  Plsan->initializeModule();
  PreciseLeakSanVisitor visitor(*Plsan);

  for (Function &F : Mod) {
    // Stack pointer saved, then push local variable stack.
    visitor.pushNewLocalVarListStack();
    visitor.pushNewBuiltinAllocaStack();

    if (!F.isDeclaration())
      visitor.setCurrentFunctionEntryBlock(F.getEntryBlock());

    for (BasicBlock &BB : F) {
      visitor.isVLAExist = false;

      for (Instruction &I : BB) {
        if (I.getMetadata(Plsan->PlsanMDName))
          continue;
        visitor.visit(I);
      }
    }
  }

  for (auto *Inst : visitor.getIntrinToInstrument())
    visitor.visitMemIntrinsics(*Inst);

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
