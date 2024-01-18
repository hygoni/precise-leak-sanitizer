#include "PreciseLeakSanitizer.h"

#include "llvm/IR/IRBuilder.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Transforms/Utils/ModuleUtils.h"

using namespace llvm;

void PreciseLeakSanVisitor::visitStoreInst(StoreInst &I) { return; }

void PreciseLeakSanVisitor::visitReturnInst(ReturnInst &I) { return; }

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

bool PreciseLeakSanitizer::initializeModule(Module &M) { return false; }

bool PreciseLeakSanitizer::run(Module &M) {
  for (Function &F : M) {
    for (BasicBlock &BB : F) {
      for (Instruction &I : BB) {
        PreciseLeakSanVisitor().visit(I);
      }
    }
  }
  return false;
}

PreservedAnalyses PreciseLeakSanitizerPass::run(Module &M,
                                                ModuleAnalysisManager &) {
  return (PreciseLeakSanitizer().run(M) ? PreservedAnalyses::none()
                                        : PreservedAnalyses::all());
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
