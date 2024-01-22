#ifndef PRECISE_LEAK_SANITIZER_H
#define PRECISE_LEAK_SANITIZER_H

#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

using namespace llvm;

class PreciseLeakSanitizer {
private:
  friend class PreciseLeakSanVisitor;

  Module *Mod;
  LLVMContext *Ctx;

  // RT library functions
  FunctionType *RefCountFnTy;
  FunctionType *AllocSizeAlignFnTy;
  FunctionType *InitDynAllocShadowMemFnTy;
  FunctionCallee RefCountFn;
  FunctionCallee AllocSizeAlignFn;
  FunctionCallee InitDynAllocShadowMemFn;
  StringRef RefCountFnName = "refCount";
  StringRef AllocSizeAlignFnName = "allocSizeAlign";
  StringRef InitDynAllocShadowMemFnName = "initDynAllocShadowMem";

  bool initializeModule(Module &M);

public:
  bool run(Module &M);
};

class PreciseLeakSanVisitor : public InstVisitor<PreciseLeakSanVisitor> {
public:
  void visitStoreInst(StoreInst &I);
  void visitReturnInst(ReturnInst &I);
  void visitCallInst(CallInst &I);

private:
  void visitCallMalloc(CallInst &I);
  void visitCallCalloc(CallInst &I);
  void visitCallNew(CallInst &I);
  void visitCallArrTyNew(CallInst &I);
  void visitCallFree(CallInst &I);
  void visitCallMemset(CallInst &I);
  void visitCallMemcpy(CallInst &I);
  void visitCallMemmove(CallInst &I);
  void visitCallBzero(CallInst &I);
};

struct PreciseLeakSanitizerPass
    : public PassInfoMixin<PreciseLeakSanitizerPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &);
};

#endif
