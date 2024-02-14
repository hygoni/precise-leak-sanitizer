#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_handler.h"
#include "plsan_thread.h"
#if SANITIZER_POSIX
#include "plsan_posix.h"
#endif

#include "plsan_internal.h"
#include "sanitizer_common/sanitizer_flags.h"
#include "sanitizer_common/sanitizer_stacktrace.h"
namespace __plsan {

class Plsan {
public:
  Plsan();
  ~Plsan();

  // Instrumentation function

  void reference_count(void **lhs, void *rhs);
  __sanitizer::Vector<void *> *free_local_variable(void **arr_addr, size_t size,
                                                   void *ret_addr,
                                                   bool is_return);
  void check_returned_or_stored_value(void *ret_ptr_addr,
                                      void *compare_ptr_addr);
  void check_memory_leak(void *addr);
  void check_memory_leak(RefCountAnalysis analysis_result);
  RefCountAnalysis leak_analysis(const void *ptr);
  void *memset_wrapper(void *ptr, int value, size_t num);

  void *plsan_memset(void *ptr, int value, size_t num);
  void *plsan_memcpy(void *dest, void *src, size_t count);
  void *plsan_memmove(void *dest, void *src, size_t num);

private:
  PlsanHandler *handler;
  void *ptr_array_value(void *array_start_addr, size_t index);
};

extern bool plsan_inited;
extern bool plsan_init_is_running;

void PlsanAllocatorInit();
void PlsanAllocatorLock();
void PlsanAllocatorUnlock();
void UpdateReference(void **lhs, void *rhs);
bool PtrIsAllocatedFromPlsan(const void *p);
bool IsSameObject(const void *p, const void *q);
void IncRefCount(const void *p);
void DecRefCount(const void *p);
uint8_t GetRefCount(const void *p);

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
