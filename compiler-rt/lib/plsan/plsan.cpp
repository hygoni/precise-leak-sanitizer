#include "plsan.h"
#include "sanitizer_common/sanitizer_libc.h"

#include <cstdarg>
#include <cstddef>
#include <cstring>
#include <pthread.h>

#include "lsan/lsan_common.h"
#include "sanitizer_common/sanitizer_atomic.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_flag_parser.h"
#include "sanitizer_common/sanitizer_flags.h"
#include "sanitizer_common/sanitizer_interface_internal.h"
#include "sanitizer_common/sanitizer_libc.h"
#include "sanitizer_common/sanitizer_procmaps.h"
#include "sanitizer_common/sanitizer_stackdepot.h"
#include "sanitizer_common/sanitizer_stacktrace.h"
#include "sanitizer_common/sanitizer_symbolizer.h"

__plsan::Plsan *plsan;

namespace {
struct LazyCheckInfo {
  __sanitizer::Vector<void *> *RefCountZeroAddrs;
  void *ProgramCounterAddr;
};
}

/* Initialization routines called before main() */
__attribute__((constructor)) void __plsan_init() {
  plsan = new __plsan::Plsan();
}

/* finialization routines called after main() */
__attribute__((destructor)) void __plsan_fini() { delete plsan; }

extern "C" size_t __plsan_align(size_t size) { return plsan->align_size(size); }

extern "C" void __plsan_alloc(void *addr, size_t size) {
  plsan->init_refcnt(addr, size);
}

extern "C" void __plsan_free(void *addr) { plsan->fini_refcnt(addr); }

extern "C" void __plsan_store(void **lhs, void *rhs) {
  plsan->reference_count(lhs, rhs);
}

extern "C" LazyCheckInfo *
__plsan_free_stack_variables(size_t count, void *ret_addr, int is_return, ...) {
  // We cannot use C++ style variable arguments, because extern keyword for
  // compatiable with C.

  __sanitizer::Vector<void **> args;

  va_list var_addrs;
  va_start(var_addrs, is_return);

  for (int i = 0; i < count; i++)
    args.PushBack(va_arg(var_addrs, void **));

  va_end(var_addrs);

  __sanitizer::Vector<void *> *ref_count_zero_addrs =
      plsan->free_stack_variables(ret_addr, is_return, args);

  // This return will be changed. It have to contain stack trace data.
  // __builtin_return_address(0) will return program counter
  LazyCheckInfo *lazy_check_info = new LazyCheckInfo();
  lazy_check_info->RefCountZeroAddrs = ref_count_zero_addrs;
  lazy_check_info->ProgramCounterAddr = __builtin_return_address(0);
  return lazy_check_info;
}

extern "C" LazyCheckInfo *__plsan_free_stack_array(void **arr_start_addr,
                                                   size_t size, void *ret_addr,
                                                   bool is_return) {
  __sanitizer::Vector<void *> *ref_count_zero_addrs =
      plsan->free_stack_array(arr_start_addr, size, ret_addr, is_return);

  // This return will be changed. It have to contain stack trace data.
  // __builtin_return_address(0) will return program counter
  LazyCheckInfo *lazy_check_info = new LazyCheckInfo();
  lazy_check_info->RefCountZeroAddrs = ref_count_zero_addrs;
  lazy_check_info->ProgramCounterAddr = __builtin_return_address(0);
  return lazy_check_info;
}

extern "C" void __plsan_lazy_check(LazyCheckInfo *lazy_check_info,
                                   void *ret_addr) {
  __sanitizer::Vector<void *> *lazy_check_addr_list =
      lazy_check_info->RefCountZeroAddrs;
  void *program_counter = lazy_check_info->ProgramCounterAddr;

  for (int i = 0; i < lazy_check_addr_list->Size(); i++) {
    if ((*lazy_check_addr_list)[i] != ret_addr)
      throw ret_addr;
  }

  delete lazy_check_addr_list;
  delete lazy_check_info;
}

extern "C" void __plsan_check_returned_or_stored_value(void *ret_ptr_addr,
                                                       void *compare_ptr_addr) {
  plsan->check_returned_or_stored_value(ret_ptr_addr, compare_ptr_addr);
}

extern "C" void __plsan_check_memory_leak(void *addr) {
  plsan->check_memory_leak(addr);
}

extern "C" void __plsan_memcpy_refcnt(void *dest, void *src, size_t count) {
  plsan->memcpy_refcnt(dest, src, count);
}

extern "C" void __plsan_realloc_instrument(void *origin_addr,
                                           void *realloc_addr) {
  plsan->realloc_instrument(origin_addr, realloc_addr);
}

namespace __plsan {

Plsan::Plsan() {
  shadow = new PlsanShadow();
  handler = new PlsanHandler();
}

Plsan::~Plsan() {
  delete shadow;
  delete handler;
}

size_t Plsan::align_size(size_t size) {
  // Align size with multiples of MIN_DYN_ALLOC_SIZE (defined in plsan_shadow.h)
  return (size + MIN_DYN_ALLOC_SIZE - 1) & ~(MIN_DYN_ALLOC_SIZE - 1);
}

void Plsan::init_refcnt(void *addr, size_t size) {
  // Initialize not only shadow memory but dynamic allocated memory.
  // https://github.com/hygoni/precise-leak-sanitizer/issues/29

  int8_t initialize_value = '\0';
  __sanitizer::__sanitizer_internal_memset(addr, initialize_value, size);

  shadow->alloc_shadow(addr, size);
}

void Plsan::fini_refcnt(void *addr) { shadow->free_shadow(addr); }

void Plsan::reference_count(void **lhs, void *rhs) {
  // Ref count with Shadow class update_shadow method.
  // When there is update in ref count, we should check there is any memory
  // leak. update_shadow method only decrease lhs's ref count, no problem with
  // checking only lhs.

  shadow->update_shadow(*lhs, rhs);
  check_memory_leak(*lhs);
}

__sanitizer::Vector<void *> *
Plsan::free_stack_variables(void *ret_addr, bool is_return,
                            __sanitizer::Vector<void **> &var_addrs) {
  // free_stack_variables method calls above return instruction or some method
  // that pop(restore) stack.
  // 1. If free_stack_variables calls above return instruction, then "is_return"
  //    arg is true and decrease stack variables ref count. We have to check
  //    memory leak in this case. If stack address is same with ret_addr, then
  //    do not check memory leak. (See Documentation 4.3.1)
  // 2. If free_stack_variables calls above some method that restore stack, then
  //    "is_return" arg is false and decrease stack variables ref count. We do
  //    not check memory leak (lazy check). -> There is some cases that return
  //    restored stack value.
  // "var_addrs" arg stores all stack variable addresses.
  // If is_return is falsem, then this method return target address that check
  // leak lazily.

  __sanitizer::Vector<void *> *ref_count_zero_addrs =
      new __sanitizer::Vector<void *>();

  for (int i = 0; i < var_addrs.Size(); i++) {
    void **var_addr = var_addrs[i];
    shadow->add_shadow(*var_addr, 1);
    if (!is_return) {
      RefCountAnalysis analysis_result = shadow->shadow_analysis(*var_addr);
      if (analysis_result.exceptTy == RefCountZero)
        ref_count_zero_addrs->PushBack(*var_addr);
    } else if (*var_addr != ret_addr) {
      check_memory_leak(*var_addr);
    }
  }

  if (!is_return)
    return ref_count_zero_addrs;
  else
    return nullptr;
}

__sanitizer::Vector<void *> *Plsan::free_stack_array(void **arr_addr,
                                                     size_t size,
                                                     void *ret_addr,
                                                     bool is_return) {
  // This method almost same with free_stack_variables method, but it is for
  // arrays in stack. "arr_addr" arg has array start address "size" arg has
  // array size

  __sanitizer::Vector<void *> *ref_count_zero_addrs =
      new __sanitizer::Vector<void *>();

  for (int i = 0; i < size; i++) {
    void *ptr_value = ptr_array_value(arr_addr, i);
    shadow->add_shadow(ptr_value, 1);
    if (!is_return) {
      RefCountAnalysis analysis_result = shadow->shadow_analysis(ptr_value);
      if (analysis_result.exceptTy == RefCountZero)
        ref_count_zero_addrs->PushBack(ptr_value);
    } else if (ptr_value != ret_addr) {
      check_memory_leak(ptr_value);
    }
  }

  if (!is_return)
    return ref_count_zero_addrs;
  else
    return nullptr;
}

void Plsan::check_returned_or_stored_value(void *ret_ptr_addr,
                                           void *compare_ptr_addr) {
  // This method will be called after function call instruction and above store
  // and return instruction. If some function call return pointer type value, we
  // have to check if return pointer point dyn alloc memory and ref count is 0.
  // For more information, see doumentation 4.3.1 When a function exits

  RefCountAnalysis analysis_result = shadow->shadow_analysis(ret_ptr_addr);
  // check address type
  if (analysis_result.addrTy == NonDynAlloc) {
    return;
  } else if (!shadow->shadow_value_is_equal(ret_ptr_addr, compare_ptr_addr)) {
    check_memory_leak(analysis_result);
  }
}

void Plsan::check_memory_leak(void *addr) {
  RefCountAnalysis analysis_result = shadow->shadow_analysis(addr);
  // check exception type
  if (analysis_result.exceptTy == RefCountZero) {
    handler->exception_check(analysis_result);
  }
}

void Plsan::check_memory_leak(RefCountAnalysis analysis_result) {
  // check exception type
  if (analysis_result.exceptTy == RefCountZero) {
    handler->exception_check(analysis_result);
  }
}

void Plsan::memcpy_refcnt(void *dest, void *src, size_t count) {
  for (int i = 0; i < count / 8; i++) {
    void *src_i = plsan->ptr_array_value(src, i * 8);
    void *dest_i = plsan->ptr_array_value(dest, i * 8);
    plsan->reference_count(&dest_i, src_i);
  }
}

void Plsan::realloc_instrument(void *origin_addr, void *realloc_addr) {
  if (origin_addr != realloc_addr)
    plsan->fini_refcnt(origin_addr);
}

void *Plsan::ptr_array_value(void *array_start_addr, size_t index) {
  // void * type cannot add with integer. So casting to int *.
  int64_t *array_addr = (int64_t *)array_start_addr;
  return (void *)(*(array_addr + index));
}

void PlsanInstallAtForkHandler() {
  auto before = []() {
    PlsanAllocatorLock();
    StackDepotLockAll();
  };
  auto after = []() {
    StackDepotUnlockAll();
    PlsanAllocatorUnlock();
  };
  pthread_atfork(before, after, after);
}

bool plsan_init_is_running;
bool plsan_inited;

__attribute__((constructor(0))) void __plsan_init() {
  CHECK(!plsan_init_is_running);
  if (plsan_inited)
    return;
  plsan_init_is_running = true;
  SanitizerToolName = "PreciseLeakSanitizer";

  InitializeInterceptors();
  PlsanAllocatorInit();

  InitializeThreads();
  InitializeMainThread();

  __lsan::InitCommonLsan();
  InstallAtExitCheckLeaks();

  if (common_flags()->detect_leaks) {
    __lsan::ScopedInterceptorDisabler disabler;
    Symbolizer::LateInitialize();
  }

  VPrintf(1, "PreciseLeakSanitizer init done\n");

  plsan_init_is_running = false;
  plsan_inited = true;
}

} // namespace __plsan

void __sanitizer::BufferedStackTrace::UnwindImpl(uptr pc, uptr bp,
                                                 void *context,
                                                 bool request_fast,
                                                 u32 max_depth) {
  using namespace __plsan;
  ThreadContextPlsanBase *t = GetCurrentThread();
  if (!t || !StackTrace::WillUseFastUnwind(request_fast)) {
    return Unwind(max_depth, pc, bp, context, 0, 0, false);
  }
  Unwind(max_depth, pc, bp, nullptr, t->stack_begin(), t->stack_end(), true);
}
