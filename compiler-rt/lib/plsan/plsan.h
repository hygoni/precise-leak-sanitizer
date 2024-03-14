#ifndef PLSAN_H
#define PLSAN_H

#include "lsan/lsan_common.h"
#include "plsan_thread.h"
#if SANITIZER_POSIX
#include "plsan_posix.h"
#endif

#include "plsan_allocator.h"
#include "plsan_internal.h"
#include "sanitizer_common/sanitizer_flags.h"
#include "sanitizer_common/sanitizer_stacktrace.h"
namespace __plsan {

static thread_local __sanitizer::Vector<void *> *local_var_ref_count_zero_list;

enum AddrType { NonDynAlloc, DynAlloc };
enum ExceptionType { None, RefCountZero };

struct RefCountAnalysis {
  AddrType addrTy;
  ExceptionType exceptTy;
  u32 stack_trace_id;
};

void reference_count(void **lhs, void *rhs);
__sanitizer::Vector<void *> *
free_local_variable(void **arr_addr, uptr size, void *ret_addr, bool is_return);
void check_returned_or_stored_value(void *ret_ptr_addr, void *compare_ptr_addr);
void check_memory_leak(Metadata *metadata);
void check_memory_leak(RefCountAnalysis analysis_result);
RefCountAnalysis leak_analysis(Metadata *metadata);

void *plsan_memset(void *ptr, int value, uptr num);
void *plsan_memcpy(void *dest, void *src, uptr count);
void *plsan_memmove(void *dest, void *src, uptr num);

extern bool plsan_inited;
extern bool plsan_init_is_running;

void LsanOnDeadlySignal(int signo, void *siginfo, void *context);

void PlsanAllocatorInit();
void PlsanAllocatorLock();
void PlsanAllocatorUnlock();
void UpdateReference(Metadata *lhs_metadata, Metadata *rhs_metadata);
bool PtrIsAllocatedFromPlsan(Metadata *metadata);
bool IsSameObject(Metadata *metadata, const void *p, const void *q);
void IncRefCount(Metadata *metadata);
void DecRefCount(Metadata *metadata);
u8 GetRefCount(Metadata *metadata);
u32 GetAllocTraceID(Metadata *metadata);

void *plsan_malloc(uptr size, StackTrace *stack);
void *plsan_calloc(uptr nmemb, uptr size, StackTrace *stack);
void *plsan_realloc(void *ptr, uptr size, StackTrace *stack);
void *plsan_reallocarray(void *ptr, uptr nmemb, uptr size, StackTrace *stack);
void *plsan_valloc(uptr size, StackTrace *stack);
void *plsan_pvalloc(uptr size, StackTrace *stack);
void *plsan_aligned_alloc(uptr alignment, uptr size, StackTrace *stack);
void *plsan_memalign(uptr alignment, uptr size, StackTrace *stack);
int plsan_posix_memalign(void **memptr, uptr alignment, uptr size,
                         StackTrace *stack);
void plsan_free(void *ptr);
void __plsan_init();
void __plsan_check_memory_leak(void *addr);
void InitializeInterceptors();
void InstallAtExitCheckLeaks();
void InitializeLocalVariableTLS();
void DeleteLocalVariableTLS();

} // namespace __plsan

#define ENSURE_PLSAN_INITED()                                                  \
  do {                                                                         \
    CHECK(!plsan_init_is_running);                                             \
    if (!plsan_inited) {                                                       \
      __plsan_init();                                                          \
    }                                                                          \
  } while (0);

#define GET_MALLOC_STACK_TRACE                                                 \
  BufferedStackTrace stack;                                                    \
  if (plsan_inited)                                                            \
  stack.Unwind(StackTrace::GetCurrentPc(), GET_CURRENT_FRAME(), nullptr,       \
               common_flags()->fast_unwind_on_malloc,                          \
               common_flags()->malloc_context_size)

#define GET_FATAL_STACK_TRACE_PC_BP(pc, bp)                                    \
  BufferedStackTrace stack;                                                    \
  if (plsan_inited)                                                            \
  stack.Unwind(pc, bp, nullptr, common_flags()->fast_unwind_on_fatal)

#endif // PLSAN_H
