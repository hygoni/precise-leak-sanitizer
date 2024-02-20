#include "plsan.h"
#include "sanitizer_common/sanitizer_allocator_internal.h"
#include "sanitizer_common/sanitizer_libc.h"

#include <cstdarg>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <new>
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
};
}

/* Initialization routines called before main() */
__attribute__((constructor)) void __plsan_init() {
  void *mem = __sanitizer::InternalAlloc(sizeof(__plsan::Plsan));
  plsan = new (mem) __plsan::Plsan();
}

/* finialization routines called after main() */
__attribute__((destructor)) void __plsan_fini() {
  __sanitizer::InternalFree(plsan);
}

extern "C" void __plsan_store(void **lhs, void *rhs) {
  plsan->reference_count(lhs, rhs);
}

extern "C" LazyCheckInfo *__plsan_free_local_variable(void **arr_start_addr,
                                                      size_t size,
                                                      void *ret_addr,
                                                      bool is_return) {
  __sanitizer::Vector<void *> *ref_count_zero_addrs =
      plsan->free_local_variable(arr_start_addr, size, ret_addr, is_return);

  // This return will be changed. It have to contain stack trace data.
  // __builtin_return_address(0) will return program counter
  LazyCheckInfo *lazy_check_info =
      (LazyCheckInfo *)__sanitizer::InternalAlloc(sizeof(LazyCheckInfo));
  CHECK(lazy_check_info);
  lazy_check_info->RefCountZeroAddrs = ref_count_zero_addrs;
  if (is_return) {
    __sanitizer::InternalFree(lazy_check_info);
    return nullptr;
  } else {
    return lazy_check_info;
  }
}

extern "C" void __plsan_lazy_check(LazyCheckInfo *lazy_check_info,
                                   void *ret_addr) {
  __sanitizer::Vector<void *> *lazy_check_addr_list =
      lazy_check_info->RefCountZeroAddrs;

  for (int i = 0; i < lazy_check_addr_list->Size(); i++) {
    if ((*lazy_check_addr_list)[i] != ret_addr) {
      __lsan::setLeakedLoc(
          __plsan::GetAllocTraceID((*lazy_check_addr_list)[i]));
    }
  }

  __sanitizer::InternalFree(lazy_check_addr_list);
  __sanitizer::InternalFree(lazy_check_info);
}

extern "C" void __plsan_check_returned_or_stored_value(void *ret_ptr_addr,
                                                       void *compare_ptr_addr) {
  plsan->check_returned_or_stored_value(ret_ptr_addr, compare_ptr_addr);
}

extern "C" void __plsan_check_memory_leak(void *addr) {
  plsan->check_memory_leak(addr);
}

extern "C" void *__plsan_memset(void *ptr, int value, size_t num) {
  return plsan->plsan_memset(ptr, value, num);
}

extern "C" void *__plsan_memcpy(void *dest, void *src, size_t count) {
  return plsan->plsan_memcpy(dest, src, count);
}

extern "C" void *__plsan_memmove(void *dest, void *src, size_t num) {
  return plsan->plsan_memmove(dest, src, num);
}

namespace __plsan {

Plsan::Plsan() {}

Plsan::~Plsan() {}

void Plsan::reference_count(void **lhs, void *rhs) {
  // Ref count with Shadow class update_shadow method.
  // When there is update in ref count, we should check there is any memory
  // leak. update_shadow method only decrease lhs's ref count, no problem with
  // checking only lhs.

  UpdateReference(lhs, rhs);
  check_memory_leak(*lhs);
}

// addr: address of the variable
// size: size of a variable in bytes
__sanitizer::Vector<void *> *Plsan::free_local_variable(void **addr,
                                                        size_t size,
                                                        void *ret_addr,
                                                        bool is_return) {
  // free_local_variable() method is called just before return instruction
  // or some method that pops(restore) stack.
  // 1. If free_local_variable() is called just before return instruction,
  //    then "is_return" arg is true and decrease local variables' ref count.
  //    We have to check memory leak in this case. If stack address is same with
  //    ret_addr, then it is not a memory leak. (See Documentation 4.3.1)
  // 2. If free_local_variable() is called just before some method that restore
  //    stack, then "is_return" arg is false and decrease stack variables ref
  //    count. We do not check memory leak (lazy check). -> There is some cases
  //    that return restored stack value.

  __sanitizer::Vector<void *> *ref_count_zero_addrs = nullptr;
  if (is_return == false) {
    void *mem = (__sanitizer::Vector<void *> *)__sanitizer::InternalAlloc(
        sizeof(__sanitizer::Vector<void *>));
    CHECK(mem);
    ref_count_zero_addrs = new (mem) __sanitizer::Vector<void *>();
  }

  void **pp = addr;
  while (pp + 1 <= addr + size / (sizeof(void *))) {
    void *ptr = *pp;
    DecRefCount(ptr);
    if (is_return == false) {
      RefCountAnalysis analysis_result = leak_analysis(ptr);
      if (analysis_result.exceptTy == RefCountZero)
        ref_count_zero_addrs->PushBack(ptr);
    } else if (!IsSameObject(ptr, ret_addr)){
      check_memory_leak(ptr);
    }
    pp++;
  }

  if (is_return == false) {
    return ref_count_zero_addrs;
  } else {
    return nullptr;
  }
}

void Plsan::check_returned_or_stored_value(void *ret_ptr_addr,
                                           void *compare_ptr_addr) {
  // This method will be called after function call instruction and above store
  // and return instruction. If some function call return pointer type value, we
  // have to check if return pointer point dyn alloc memory and ref count is 0.
  // For more information, see doumentation 4.3.1 When a function exits

  RefCountAnalysis analysis_result = leak_analysis(ret_ptr_addr);
  // check address type
  if (analysis_result.addrTy == NonDynAlloc) {
    return;
  } else if (!IsSameObject(ret_ptr_addr, compare_ptr_addr)) {
    check_memory_leak(analysis_result);
  }
}

void Plsan::check_memory_leak(void *addr) {
  RefCountAnalysis analysis_result = leak_analysis(addr);
  // check exception type
  if (analysis_result.exceptTy == RefCountZero) {
    __lsan::setLeakedLoc(analysis_result.stack_trace_id);
  }
}

void Plsan::check_memory_leak(RefCountAnalysis analysis_result) {
  // check exception type
  if (analysis_result.exceptTy == RefCountZero) {
    __lsan::setLeakedLoc(analysis_result.stack_trace_id);
  }
}

void *Plsan::plsan_memset(void *ptr, int value, size_t num) {
  uptr *ptr_t = (uptr *)ptr;
  uptr *next_ptr = ptr_t;
  uptr *end_ptr = ptr_t + (num / 8);
  while (next_ptr < end_ptr) {
    plsan->reference_count((void **)next_ptr, nullptr);
    next_ptr++;
  }
  return internal_memset(ptr, value, num);
}

void *Plsan::plsan_memcpy(void *dest, void *src, size_t count) {
  int i = 0;
  int j = 0;
  int end = count / sizeof(void *);
  uptr **dest_t = (uptr **)dest;
  uptr **src_t = (uptr **)src;
  while (i < end) {
    void **dest_i = (void **)(dest_t + i);
    void **src_i = (void **)(src_t + j);
    if (src_i == (void **)dest_t) {
      j = 0;
      src_i = (void **)src_t;
    }
    plsan->reference_count(dest_i, *src_i);
    i++;
    j++;
  }
  return internal_memcpy(dest, src, count);
}

void *Plsan::plsan_memmove(void *dest, void *src, size_t num) {
  int i = 0;
  int end = num / sizeof(void *);
  uptr **dest_t = (uptr **)dest;
  uptr **src_t = (uptr **)src;
  while (i < end) {
    void **dest_i = (void **)(dest_t + i);
    void **src_i = (void **)(src_t + i);
    plsan->reference_count(dest_i, *src_i);
    i++;
  }
  return internal_memmove(dest, src, num);
}

void *Plsan::ptr_array_value(void *array_start_addr, size_t index) {
  // void * type cannot add with integer. So casting to int *.
  int64_t *array_addr = (int64_t *)array_start_addr;
  return (void *)(*(array_addr + index));
}

RefCountAnalysis Plsan::leak_analysis(const void *ptr) {
  AddrType addr_type = NonDynAlloc;
  ExceptionType exception_type = None;
  u32 stack_trace_id = 0;
  // If address is dynamic allocated memory
  if (PtrIsAllocatedFromPlsan(ptr)) {
    addr_type = DynAlloc;
    if (GetRefCount(ptr) == 0) {
      exception_type = RefCountZero;
      stack_trace_id = GetAllocTraceID(ptr);
    }
  }

  RefCountAnalysis result = {addr_type, exception_type, stack_trace_id};
  return result;
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

static void InitializeFlags() {
  // Set all the default values.
  SetCommonFlagsDefaults();
  {
    CommonFlags cf;
    cf.CopyFrom(*common_flags());
    cf.external_symbolizer_path = GetEnv("PLSAN_SYMBOLIZER_PATH");
    cf.malloc_context_size = 30;
    cf.intercept_tls_get_addr = true;
    cf.detect_leaks = true;
    cf.exitcode = 23;
    OverrideCommonFlags(cf);
  }

  __lsan::Flags *f = __lsan::flags();
  f->SetDefaults();

  FlagParser parser;
  RegisterLsanFlags(&parser, f);
  RegisterCommonFlags(&parser);

  // Override from user-specified string.
  const char *plsan_default_options = __lsan_default_options();
  parser.ParseString(plsan_default_options);
  parser.ParseStringFromEnv("PLSAN_OPTIONS");

  InitializeCommonFlags();

  if (Verbosity())
    ReportUnrecognizedFlags();

  if (common_flags()->help)
    parser.PrintFlagDescriptions();

  __sanitizer_set_report_path(common_flags()->log_path);
}

__attribute__((constructor(0))) void __plsan_init() {
  CHECK(!plsan_init_is_running);
  if (plsan_inited)
    return;
  plsan_init_is_running = true;
  SanitizerToolName = "PreciseLeakSanitizer";

  CacheBinaryName();
  AvoidCVE_2016_2143();
  InitializeFlags();
  __lsan::InitCommonLsan();
  PlsanAllocatorInit();
  InitTlsSize();
  InitializeInterceptors();
  InitializeThreads();
  InstallDeadlySignalHandlers(LsanOnDeadlySignal);
  InitializeMainThread();
  InstallAtExitCheckLeaks();

  InitializeCoverage(common_flags()->coverage, common_flags()->coverage_dir);

  if (common_flags()->detect_leaks) {
    __lsan::ScopedInterceptorDisabler disabler;
    Symbolizer::LateInitialize();
  }

  VPrintf(1, "PreciseLeakSanitizer init done\n");

  plsan_init_is_running = false;
  plsan_inited = true;
}

void __plsan_check_memory_leak(void *addr) { plsan->check_memory_leak(addr); }

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
  Unwind(max_depth, pc, bp, nullptr, t->stack_end(), t->stack_begin(), true);
}

int __plsan_is_turned_on() { return 1; }
