#ifndef PRECISE_LEAK_SANITIZER_H
#define PRECISE_LEAK_SANITIZER_H

#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

using namespace llvm;

class PreciseLeakSanitizer {
private:
  friend class PreciseLeakSanVisitor;

  Module &Mod;
  LLVMContext &Ctx;

  // RT library functions
  Type *VoidTy;
  PointerType *VoidPtrTy;
  PointerType *VoidPtrPtrTy;
  IntegerType *Int64Ty;
  FunctionType *AlignFnTy;
  FunctionType *AllocFnTy;
  FunctionType *FreeFnTy;
  FunctionType *StoreFnTy;
  FunctionType *FreeStackVariablesFnTy;
  FunctionType *FreeStackArraysFnTy;
  FunctionType *CheckReturnedOrStoredValueFnTy;
  FunctionCallee AlignFn;
  FunctionCallee AllocFn;
  FunctionCallee FreeFn;
  FunctionCallee StoreFn;
  FunctionCallee FreeStackVariablesFn;
  FunctionCallee FreeStackArraysFn;
  FunctionCallee CheckReturnedOrStoredValueFn;
  StringRef AlignFnName = "__plsan_align";
  StringRef AllocFnName = "__plsan_alloc";
  StringRef FreeFnName = "__plsan_free";
  StringRef StoreFnName = "__plsan_store";
  StringRef FreeStackVariablesFnName = "__plsan_free_stack_variables";
  StringRef FreeStackArraysFnName = "__plsan_free_stack_arrays";
  StringRef CheckReturnedOrStoredValueFnName =
      "__plsan_check_returned_or_stored_value";

  bool initializeModule();

public:
  PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx);
  bool run();
};

class PreciseLeakSanVisitor : public InstVisitor<PreciseLeakSanVisitor> {
public:
  PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan);
  void visitStoreInst(StoreInst &I);
  void visitReturnInst(ReturnInst &I);
  void visitCallInst(CallInst &I);

private:
  PreciseLeakSanitizer &Plsan;
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
