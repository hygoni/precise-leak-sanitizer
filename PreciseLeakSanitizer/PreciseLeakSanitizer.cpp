#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct PreciseLeakSanitizer : public PassInfoMixin<PreciseLeakSanitizer> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    bool transformed = false;
    for (auto &F : M) {
      for (auto &BB : F) {
        for (auto &I : BB) {
          if (auto *CI = dyn_cast<CallInst>(&I)) {
            IRBuilder builder(CI);

            if (CI->getName() == "malloc") {

            } else if (CI->getName() == "calloc") {

            } else if (CI->getName() == "realloc") {

            } else if (CI->getName() == "new") {

            } else if (CI->getName() == "new[]") {

            } else if (CI->getName() == "free") {

            } else if (CI->getName() == "memset") {

            } else if (CI->getName() == "memcpy") {

            } else if (CI->getName() == "memmove") {

            } else if (CI->getName() == "bzero") {
            }
          } else if (auto *SI = dyn_cast<StoreInst>(&I)) {

          } else if (auto *RI = dyn_cast<ReturnInst>(&I)) {
          }
        }
      }
    }
    return (transformed ? PreservedAnalyses::none() : PreservedAnalyses::all());
  };
};

} // namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {.APIVersion = LLVM_PLUGIN_API_VERSION,
          .PluginName = "PreciseLeakSanitizer",
          .PluginVersion = "v0.1",
          .RegisterPassBuilderCallbacks = [](PassBuilder &PB) {
            PB.registerPipelineStartEPCallback(
                [](ModulePassManager &MPM, OptimizationLevel Level) {
                  MPM.addPass(PreciseLeakSanitizer());
                });
          }};
}
