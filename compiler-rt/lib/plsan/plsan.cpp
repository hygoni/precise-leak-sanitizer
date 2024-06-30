#include "plsan.h"
#include "plsan_allocator.h"
#include "sanitizer_common/sanitizer_allocator_internal.h"
#include "sanitizer_common/sanitizer_libc.h"

#include "sanitizer_common/sanitizer_placement_new.h"
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

#define PLSAN_REPORT_COUNT_THRESHOLD 100
// this counter is intentionally not atomic
// because it doesn't needs to be precise.
// for performance, use it in a relaxed way.
int report_count = 0;

struct LazyCheckInfo {
  __sanitizer::Vector<void *> *RefCountZeroAddrs;
};

struct LazyCheckMetadataInfo {
  __sanitizer::Vector<__plsan::Metadata> *RefCountZeroMetadataList;
};

extern "C" void __plsan_store(void **lhs, void *rhs) {
  // Ref count with Shadow class update_shadow method.
  // When there is update in ref count, we should check there is any memory
  // leak. update_shadow method only decrease lhs's ref count, no problem with
  // checking only lhs.

  __plsan::Metadata *lhs_metadata = __plsan::GetMetadata(*lhs);
  __plsan::Metadata *rhs_metadata = __plsan::GetMetadata(rhs);
  if (!lhs_metadata && !rhs_metadata)
    return;

  __plsan::DecRefCount(lhs_metadata);
  __plsan::IncRefCount(rhs_metadata);
  __plsan::check_memory_leak(lhs_metadata);
}

extern "C" void __plsan_free_local_variable(void **addr, uptr size,
                                            void *ret_addr, bool is_return,
                                            bool is_allocated) {

  if (!is_allocated)
    return;

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

  void **pp = addr;
  while (pp + 1 <= addr + size / (sizeof(void *))) {
    void *ptr = *pp;

    __plsan::Metadata *metadata = __plsan::GetMetadata(ptr);
    if (!metadata || !__plsan::IsAllocated(metadata)) {
      pp++;
      continue;
    }

    __plsan::DecRefCount(metadata);
    if (is_return == false) {
      if (__plsan::GetRefCount(metadata) == 0)
        __plsan::local_var_ref_count_zero_list->PushBack(ptr);
    } else if (!__plsan::IsSameObject(metadata, ptr, ret_addr)) {
      __plsan::check_memory_leak(metadata);
    }
    pp++;
  }
}

extern "C" void __plsan_lazy_check(void *ret_addr) {
  if (report_count > PLSAN_REPORT_COUNT_THRESHOLD)
    return;

  __sanitizer::Vector<void *> *lazy_check_addr_list =
      __plsan::local_var_ref_count_zero_list;

  for (int i = lazy_check_addr_list->Size() - 1; i >= 0; i--) {
    if ((*lazy_check_addr_list)[i] != ret_addr) {
      __plsan::Metadata *metadata =
          __plsan::GetMetadata((*lazy_check_addr_list)[i]);
      __lsan::setLeakedLoc(metadata->GetAllocTraceId());
      report_count++;
      lazy_check_addr_list->PopBack();
    }
  }
}

extern "C" void __plsan_check_returned_or_stored_value(void *ret_ptr_addr,
                                                       void *compare_ptr_addr) {
  __plsan::check_returned_or_stored_value(ret_ptr_addr, compare_ptr_addr);
}

extern "C" void __plsan_check_memory_leak(void *addr) {
  __plsan::Metadata *metadata = __plsan::GetMetadata(addr);
  check_memory_leak(metadata);
}

extern "C" void *__plsan_memset(void *ptr, int value, uptr num) {
  uptr *ptr_t = (uptr *)ptr;
  uptr *next_ptr = ptr_t;
  uptr *end_ptr = ptr_t + (num / 8);
  while (next_ptr < end_ptr) {
    if (*(void **)next_ptr == nullptr) {
      next_ptr++;
      continue;
    }
    __plsan::Metadata *metadata = __plsan::GetMetadata(next_ptr);
    if (metadata)
      __plsan::DecRefCount(metadata);
    next_ptr++;
  }
  return __sanitizer::internal_memset(ptr, value, num);
}

extern "C" void *__plsan_memcpy(void *dest, void *src, uptr count) {
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
    __plsan_store(dest_i, *src_i);
    i++;
    j++;
  }
  return __sanitizer::internal_memcpy(dest, src, count);
}

extern "C" void *__plsan_memmove(void *dest, void *src, uptr num) {
  int i = 0;
  int end = num / sizeof(void *);
  uptr **dest_t = (uptr **)dest;
  uptr **src_t = (uptr **)src;
  while (i < end) {
    void **dest_i = (void **)(dest_t + i);
    void **src_i = (void **)(src_t + i);
    __plsan_store(dest_i, *src_i);
    i++;
  }
  return __sanitizer::internal_memmove(dest, src, num);
}

namespace __plsan {

void check_returned_or_stored_value(void *ret_ptr_addr,
                                    void *compare_ptr_addr) {
  // This method will be called after function call instruction and above store
  // and return instruction. If some function call return pointer type value, we
  // have to check if return pointer point dyn alloc memory and ref count is 0.
  // For more information, see doumentation 4.3.1 When a function exits

  Metadata *metadata = GetMetadata(ret_ptr_addr);
  if (!metadata)
    return;
  // check address type
  if (!IsSameObject(metadata, ret_ptr_addr, compare_ptr_addr)) {
    check_memory_leak(metadata);
  }
}

void check_memory_leak(Metadata *metadata) {
  if (report_count > PLSAN_REPORT_COUNT_THRESHOLD)
    return;

  if (metadata && GetRefCount(metadata) == 0) {
    __lsan::setLeakedLoc(metadata->GetAllocTraceId());
    report_count++;
  }
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

void InitializeMetadataTable() {
  // get page size
  uptr page_size = GetPageSizeCached();

  // assume 48 bits of virtual address space
  uptr table_size = 1LL << (48 - __builtin_ctz(page_size));
  metadata_table =
      (uptr *)MmapNoReserveOrDie(table_size * sizeof(void *), "Metadata table");
}

void InitializeLocalVariableTLS() {
  __plsan::local_var_ref_count_zero_list =
      (__sanitizer::Vector<void *> *)__sanitizer::InternalAlloc(
          sizeof(__sanitizer::Vector<void *>));
  CHECK(__plsan::local_var_ref_count_zero_list);
  new (__plsan::local_var_ref_count_zero_list) __sanitizer::Vector<void *>();
}

void DeleteLocalVariableTLS() {
  CHECK(__plsan::local_var_ref_count_zero_list);
  __sanitizer::InternalFree(__plsan::local_var_ref_count_zero_list);
}

__attribute__((constructor(0))) void __plsan_init() {
  CHECK(!plsan_init_is_running);
  if (plsan_inited)
    return;
  plsan_init_is_running = true;
  SanitizerToolName = "PreciseLeakSanitizer";

  InitializeMetadataTable();
  InitializeLocalVariableTLS();
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

void __plsan_check_memory_leak(void *addr) {
  Metadata *metadata = GetMetadata(addr);
  check_memory_leak(metadata);
}

__attribute__((destructor(0))) void __plsan_exit() { DeleteLocalVariableTLS(); }

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
