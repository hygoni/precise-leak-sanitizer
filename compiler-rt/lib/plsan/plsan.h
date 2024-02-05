#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_thread.h"
#if SANITIZER_POSIX
#include "plsan_posix.h"
#endif

#include "plsan_internal.h"
#include "plsan_shadow.h"

#include "sanitizer_common/sanitizer_flags.h"
#include "sanitizer_common/sanitizer_stacktrace.h"
namespace __plsan {

class Plsan {
public:
  Plsan();
  ~Plsan();

  // Instrumentation function
  size_t align_size(size_t size);
  void init_refcnt(void *addr, size_t size);
  void fini_refcnt(void *addr);
  void reference_count(void **lhs, void *rhs);
  __sanitizer::Vector<void *> *
  free_stack_variables(void *ret_addr, bool is_return,
                       __sanitizer::Vector<void **> &var_addrs);
  __sanitizer::Vector<void *> *free_stack_array(void **arr_addr, size_t size,
                                                void *ret_addr, bool is_return);
  void check_returned_or_stored_value(void *ret_ptr_addr,
                                      void *compare_ptr_addr);
  void check_memory_leak(void *addr);
  void check_memory_leak(RefCountAnalysis analysis_result);
  void memcpy_refcnt(void *dest, void *src, size_t count);
  void realloc_instrument(void *origin_addr, void *realloc_addr);

private:
  PlsanShadow *shadow;
  PlsanHandler *handler;
  void *ptr_array_value(void *array_start_addr, size_t index);
};

extern bool plsan_inited;
extern bool plsan_init_is_running;

void PlsanAllocatorInit();
void PlsanAllocatorLock();
void PlsanAllocatorUnlock();

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
void InitializeInterceptors();
void InstallAtExitCheckLeaks();

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