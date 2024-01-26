#ifndef PRECISE_LEAK_SANITIZER_H
#define PRECISE_LEAK_SANITIZER_H

#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

#include <stack>
#include <tuple>
#include <vector>

using namespace llvm;

using ArrayAddrInfo =
    std::tuple</*ArrayStartPointer=*/Value *, /*ArraySize*/ Value *>;

class PreciseLeakSanitizer {
private:
  friend class PreciseLeakSanVisitor;

  Module &Mod;
  LLVMContext &Ctx;

  // RT library functions
  Type *VoidTy;
  Type *BoolTy;
  PointerType *VoidPtrTy;
  PointerType *VoidPtrPtrTy;
  IntegerType *Int32Ty;
  IntegerType *Int64Ty;
  FunctionType *AlignFnTy;
  FunctionType *AllocFnTy;
  FunctionType *FreeFnTy;
  FunctionType *StoreFnTy;
  FunctionType *FreeStackVariablesFnTy;
  FunctionType *FreeStackArrayFnTy;
  FunctionType *LazyCheckFnTy;
  FunctionType *CheckReturnedOrStoredValueFnTy;
  FunctionType *CheckMemoryLeakFnTy;
  FunctionType *MemcpyRefcntFnTy;
  FunctionCallee AlignFn;
  FunctionCallee AllocFn;
  FunctionCallee FreeFn;
  FunctionCallee StoreFn;
  FunctionCallee FreeStackVariablesFn;
  FunctionCallee FreeStackArrayFn;
  FunctionCallee LazyCheckFn;
  FunctionCallee CheckReturnedOrStoredValueFn;
  FunctionCallee CheckMemoryLeakFn;
  FunctionCallee MemcpyRefcntFn;
  StringRef AlignFnName = "__plsan_align";
  StringRef AllocFnName = "__plsan_alloc";
  StringRef FreeFnName = "__plsan_free";
  StringRef StoreFnName = "__plsan_store";
  StringRef FreeStackVariablesFnName = "__plsan_free_stack_variables";
  StringRef FreeStackArrayFnName = "__plsan_free_stack_array";
  StringRef LazyCheckFnName = "__plsan_lazy_check";
  StringRef CheckReturnedOrStoredValueFnName =
      "__plsan_check_returned_or_stored_value";
  StringRef CheckMemoryLeakFnName = "__plsan_check_memory_leak";
  StringRef MemcpyRefcntFnName = "__plsan_memcpy_refcnt";

  bool initializeModule();

public:
  PreciseLeakSanitizer(Module &Mod, LLVMContext &Ctx);
  bool run();
};

class PreciseLeakSanVisitor : public InstVisitor<PreciseLeakSanVisitor> {
public:
  PreciseLeakSanVisitor(PreciseLeakSanitizer &Plsan);
  void visitAllocaInst(AllocaInst &I);
  void visitStoreInst(StoreInst &I);
  void visitReturnInst(ReturnInst &I);
  void visitCallInst(CallInst &I);
  void pushNewLocalPtrVarListStack();
  void pushNewLocalPtrArrListStack();

private:
  PreciseLeakSanitizer &Plsan;
  std::stack<std::vector<Value *>> LocalPtrVarListStack;
  std::stack<std::vector<ArrayAddrInfo>> LocalPtrArrListStack;
  std::stack<CallInst *> LazyCheckInfoStack;
  Instruction *InstructionTraceTopDown(Instruction *I);
  void visitCallMalloc(CallInst &I);
  void visitCallCalloc(CallInst &I);
  void visitCallNew(CallInst &I);
  void visitCallArrTyNew(CallInst &I);
  void visitCallFree(CallInst &I);
  void visitCallMemset(CallInst &I);
  void visitCallMemcpy(CallInst &I);
  void visitCallMemmove(CallInst &I);
  void visitCallBzero(CallInst &I);
  void visitLLVMStacksave(CallInst &I);
  void visitLLVMStackrestore(CallInst &I);
};

struct PreciseLeakSanitizerPass
    : public PassInfoMixin<PreciseLeakSanitizerPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &);
};

#endif
