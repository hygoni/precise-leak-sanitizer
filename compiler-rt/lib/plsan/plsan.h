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

extern uptr *metadata_table;

enum AddrType { NonDynAlloc, DynAlloc };
enum ExceptionType { None, RefCountZero };

void check_returned_or_stored_value(void *ret_ptr_addr, void *compare_ptr_addr);
void check_memory_leak(Metadata *metadata);

extern bool plsan_inited;
extern bool plsan_init_is_running;

void LsanOnDeadlySignal(int signo, void *siginfo, void *context);

void PlsanAllocatorInit();
void PlsanAllocatorLock();
void PlsanAllocatorUnlock();
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
void InitializeMetadataTable();
void DeleteLocalVariableTLS();

// minimum size for mmap()
const uptr kUserMapSize = 1 << 16;
const uptr kMetaMapSize = 1 << 16;
const uptr kMetadataSize = sizeof(struct Metadata);
extern uptr *metadata_table;
const uptr page_shift = 12;
const uptr table_size = 1LL << (48 - page_shift);

inline struct Metadata *GetMetadata(const void *p) {
  uptr addr = reinterpret_cast<uptr>(p);
  uptr page_idx = addr >> page_shift;
  if (page_idx >= table_size)
    return nullptr;

  uptr entry = *reinterpret_cast<uptr *>(metadata_table + page_idx);
  // If there's no entry, it's not on heap
  if (!entry)
    return nullptr;

  if (kAllocatorSpace <= addr && addr < kAllocatorEnd) {
    uptr metabase = entry & ~(kUserMapSize - 1);
    __sanitizer::u32 object_size = entry & (kUserMapSize - 1);
    // XXX: integer division is costly
    __sanitizer::u32 chunk_idx =
        (addr % ((object_size / kMetadataSize) * kUserMapSize)) / object_size;
    struct Metadata *m = reinterpret_cast<Metadata *>(
        metabase - (1 + chunk_idx) * kMetadataSize);
    return m;
  }

  return reinterpret_cast<Metadata *>(entry);
}

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
