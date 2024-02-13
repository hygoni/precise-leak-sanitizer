#ifndef PRECISE_LEAK_SANITIZER_H
#define PRECISE_LEAK_SANITIZER_H

#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Pass.h"

#include <stack>
#include <tuple>
#include <vector>

using namespace llvm;

using VarAddrSizeInfo =
    std::tuple</*StartPointer=*/Value *, /*SizeInBytes*/ Value *>;

class PreciseLeakSanitizer {
private:
  friend class PreciseLeakSanVisitor;

  Module &Mod;
  LLVMContext &Ctx;

  // PreciseLeakSanitizer instrumented metadata
  StringRef PlsanMDName = "plsan.instrument";
  MDNode *PlsanMD;

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
  FunctionType *FreeLocalVariableFnTy;
  FunctionType *LazyCheckFnTy;
  FunctionType *CheckReturnedOrStoredValueFnTy;
  FunctionType *CheckMemoryLeakFnTy;
  FunctionType *MemcpyRefcntFnTy;
  FunctionType *ReallocInstrumentFnTy;
  FunctionType *MemsetWrapperFnTy;
  FunctionCallee StoreFn;
  FunctionCallee FreeLocalVariableFn;
  FunctionCallee LazyCheckFn;
  FunctionCallee CheckReturnedOrStoredValueFn;
  FunctionCallee CheckMemoryLeakFn;
  FunctionCallee MemcpyRefcntFn;
  FunctionCallee MemsetWrapperFn;
  StringRef StoreFnName = "__plsan_store";
  StringRef FreeLocalVariableFnName = "__plsan_free_local_variable";
  StringRef LazyCheckFnName = "__plsan_lazy_check";
  StringRef CheckReturnedOrStoredValueFnName =
      "__plsan_check_returned_or_stored_value";
  StringRef CheckMemoryLeakFnName = "__plsan_check_memory_leak";
  StringRef MemcpyRefcntFnName = "__plsan_memcpy_refcnt";
  StringRef MemsetWrapperFnName = "__plsan_memset_wrapper";

  bool initializeModule();
  CallInst *CreateCallWithMetaData(IRBuilder<> &Builder, FunctionCallee Fn,
                                   ArrayRef<Value *> Args);

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
  void pushNewLocalVarListStack();

private:
  PreciseLeakSanitizer &Plsan;
  std::stack<std::vector<VarAddrSizeInfo>> LocalVarListStack;
  std::stack<CallInst *> LazyCheckInfoStack;
  Instruction *InstructionTraceTopDown(Instruction *I);
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
