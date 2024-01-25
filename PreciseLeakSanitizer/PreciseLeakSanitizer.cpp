#include "PreciseLeakSanitizer.h"

#include "llvm/IR/IRBuilder.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

using namespace llvm;

PreciseLeakSanitizer *Plsan;

PreciseLeakSanVisitor::PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan)
    : Plsan(Plsan), LocalPtrVarListStack(), LocalPtrArrListStack() {}

void PreciseLeakSanVisitor::visitAllocaInst(AllocaInst &I) { return; }

void PreciseLeakSanVisitor::visitStoreInst(StoreInst &I) { return; }

void PreciseLeakSanVisitor::visitReturnInst(ReturnInst &I) { return; }

Instruction *PreciseLeakSanVisitor::InstructionTraceTopDown(Instruction *I) {
  return NULL;
}

void PreciseLeakSanVisitor::visitCallInst(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMalloc(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallCalloc(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallArrTyNew(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallFree(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMemset(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMemcpy(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallMemmove(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitCallBzero(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitLLVMStacksave(CallInst &I) { return; }

void PreciseLeakSanVisitor::visitLLVMStackrestore(CallInst &I) { return; }

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

  return true;
}

void PreciseLeakSanVisitor::pushNewLocalPtrVarListStack() { return; }

void PreciseLeakSanVisitor::pushNewLocalPtrArrListStack() { return; }

PreciseLeakSanitizer::PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx)
    : Mod(Mod), Ctx(Ctx) {}

bool PreciseLeakSanitizer::run() {
  Plsan->initializeModule();

  for (Function &F : Mod) {
    for (BasicBlock &BB : F) {
      for (Instruction &I : BB) {
        PreciseLeakSanVisitor(*Plsan).visit(I);
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
