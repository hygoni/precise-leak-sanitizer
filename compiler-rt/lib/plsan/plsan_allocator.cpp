//===-- plsan_allocator.cpp ------------------------ ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer.
//
// PreciseLeakSanitizer allocator.
//===----------------------------------------------------------------------===//

#include "plsan_allocator.h"
#include "lsan/lsan_common.h"
#include "plsan.h"
#include "sanitizer_common/sanitizer_allocator.h"
#include "sanitizer_common/sanitizer_allocator_checks.h"
#include "sanitizer_common/sanitizer_allocator_report.h"
#include "sanitizer_common/sanitizer_atomic.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_errno.h"
#include "sanitizer_common/sanitizer_errno_codes.h"
#include "sanitizer_common/sanitizer_internal_defs.h"
#include "sanitizer_common/sanitizer_stackdepot.h"

using namespace __sanitizer;

namespace __plsan {
static Allocator allocator;
static SpinMutex fallback_mutex;
static uptr max_malloc_size;

void GetAllocatorCacheRange(uptr *begin, uptr *end) {
  *begin = (uptr)GetAllocatorCache();
  *end = *begin + sizeof(AllocatorCache);
}

void IncRefCount(Metadata *metadata) {
  if (!metadata)
    return;

  metadata->IncRefCount();
}

void DecRefCount(Metadata *metadata) {
  if (!metadata)
    return;

  metadata->DecRefCount();
}

bool PtrIsAllocatedFromPlsan(Metadata *metadata) {
  if (!metadata)
    return false;
  return metadata->IsAllocated();
}

bool IsSameObject(Metadata *metadata, const void *x, const void *y) {
  if (!metadata || !y)
    return false;

  if (x == y)
    return true;

  uptr size = metadata->GetRequestedSize();
  if (size <= (1 << 15)) {
    // size is always power of two if allocated from the primary
    uptr a = reinterpret_cast<uptr>(x) & ~(size - 1);
    uptr b = reinterpret_cast<uptr>(y) & ~(size - 1);
    return a == b;
  }

  void *begin = allocator.GetBlockBegin(x);
  if (!begin)
    return false;

  return begin <= y && (uptr)y < (uptr)begin + metadata->GetRequestedSize();
}

u32 GetRefCount(Metadata *metadata) { return metadata->GetRefCount(); }

bool IsAllocated(Metadata *metadata) { return metadata->IsAllocated(); }

u32 GetAllocTraceID(Metadata *metadata) { return metadata->GetAllocTraceId(); }

inline void Metadata::SetAllocated(u32 stack, u64 size) {
  requested_size = size;
  alloc_trace_id = stack;
  u32 s = (1 << 31);
  atomic_store(&state, s, memory_order_relaxed);
}

inline void Metadata::SetLsanTag(__lsan::ChunkTag tag) { lsan_tag = tag; }

inline __lsan::ChunkTag Metadata::GetLsanTag() const { return lsan_tag; }

inline void Metadata::SetUnallocated() {
  u32 s = 0;
  requested_size = 0;
  alloc_trace_id = 0;
  atomic_store(&state, s, memory_order_relaxed);
}

bool Metadata::IsAllocated() const {
  u32 s = atomic_load_relaxed(&state);
  return s >> (sizeof(state) * 8 - 1);
}

inline u64 Metadata::GetRequestedSize() const { return requested_size; }

u32 Metadata::GetAllocTraceId() const { return alloc_trace_id; }

inline u32 Metadata::GetRefCount() const {
  u32 s = atomic_load_relaxed(&state);
  return s & ~(1 << 31);
}

inline void Metadata::SetRefCount(u32 val) {
  atomic_store(&state, val, memory_order_relaxed);
}

inline void Metadata::IncRefCount() {
  u32 s;
  do {
    s = atomic_load_relaxed(&state);
    CHECK(s != (PLSAN_ALLOCATED|PLSAN_REFCOUNT_MAX));
  } while (!atomic_compare_exchange_strong(
      &state, &s, s + 1,
      memory_order_relaxed));
}

inline void Metadata::DecRefCount() {
  u32 s;
  do {
    s = atomic_load_relaxed(&state);
    // reference count should not be zero when decrementing
    CHECK(s != (PLSAN_ALLOCATED|PLSAN_REFCOUNT_MIN));
    CHECK(s != 0);
  } while (!atomic_compare_exchange_strong(
      &state, &s, s - 1,
      memory_order_relaxed));
}

void PlsanAllocatorLock() { allocator.ForceLock(); }

void PlsanAllocatorUnlock() { allocator.ForceUnlock(); }

void AllocatorThreadStart(AllocatorCache *cache) { allocator.InitCache(cache); }

void AllocatorThreadFinish(AllocatorCache *cache) {
  allocator.SwallowCache(cache);
  allocator.DestroyCache(cache);
}

void PlsanAllocatorInit() {
  SetAllocatorMayReturnNull(common_flags()->allocator_may_return_null);
  allocator.InitLinkerInitialized(
      common_flags()->allocator_release_to_os_interval_ms);
  if (common_flags()->max_allocation_size_mb) {
    max_malloc_size = common_flags()->max_allocation_size_mb << 20;
    max_malloc_size = Min(max_malloc_size, kMaxAllowedMallocSize);
  } else {
    max_malloc_size = kMaxAllowedMallocSize;
  }
}

static void RegisterAllocation(const StackTrace *stack, void *p, uptr size) {
  if (!p)
    return;

  Metadata *m = reinterpret_cast<Metadata *>(allocator.GetMetaData(p));
  m->SetAllocated(StackDepotPut(*stack), size);
  m->SetLsanTag(__lsan::DisabledInThisThread() ? __lsan::kIgnored
                                               : __lsan::kDirectlyLeaked);
  RunMallocHooks(p, size);
  if (!allocator.FromPrimary(p)) {
    __plsan_set_metabase(reinterpret_cast<uptr>(p), reinterpret_cast<uptr>(m),
                         size);
  }
}

static void RegisterDeallocation(void *p) {
  if (!p)
    return;
  Metadata *m = GetMetadata(p);
  if (!allocator.FromPrimary(p)) {
    __plsan_reset_metabase(reinterpret_cast<uptr>(p), m->GetRequestedSize());
  }
  RunFreeHooks(p);
  m->SetUnallocated();
}

static void *Allocate(StackTrace *stack, uptr size, uptr alignment) {
  // size should always be greater than or equal to 16
  if (UNLIKELY(size < 16))
    size = 16;
  // and should be power of two for metadata lookup for primary allocator.
  // XXX: this is a workaround - because SizeClassMap does not support
  // power-of-two-only size classes.
  const uptr kBitsPerByte = 8;
  if ((size <= (1 << 15)) && ((size & (size - 1)) != 0))
    size = 1LL << ((sizeof(unsigned int) * kBitsPerByte - __builtin_clz(size)));

  if (UNLIKELY(size > max_malloc_size)) {
    if (AllocatorMayReturnNull()) {
      Report("WARNING: PreciseLeakSanitizer failed to allocate 0x%zx bytes\n",
             size);
      return nullptr;
    }
    ReportAllocationSizeTooBig(size, max_malloc_size, stack);
  }
  if (UNLIKELY(IsRssLimitExceeded())) {
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportRssLimitExceeded(stack);
  }

  AllocatorCache *cache = GetAllocatorCache();
  void *p = allocator.Allocate(cache, size, alignment);

  // PLSAN needs the memory to be always zeroed
  if (allocator.FromPrimary(p))
    internal_memset(p, 0, size);
  RegisterAllocation(stack, p, size);
  return p;
}

static void Deallocate(void *p) {
  Metadata *m = GetMetadata(p);
  CHECK(m != nullptr);
  uptr size = m->GetRequestedSize();
  CHECK(allocator.GetBlockBegin(p) == p);

  if (size >= sizeof(void *)) {
    void **ptr = reinterpret_cast<void **>(p);
    while ((uptr)ptr < (uptr)p + size) {
      Metadata *n = GetMetadata(*ptr);
      DecRefCount(n);
      __plsan_check_memory_leak(*ptr);
      ptr++;
    }
  }

  RegisterDeallocation(p);
  allocator.Deallocate(GetAllocatorCache(), p);
}

static void *ReportAllocationSizeTooBig(uptr size, const StackTrace *stack) {
  if (AllocatorMayReturnNull()) {
    Report("WARNING: PreciseLeakSanitizer failed to allocate 0x%zx bytes\n",
           size);
    return nullptr;
  }
  ReportAllocationSizeTooBig(size, max_malloc_size, stack);
}

static void *Reallocate(const StackTrace *stack, void *p, uptr new_size,
                        uptr alignment) {
  if (new_size > max_malloc_size) {
    ReportAllocationSizeTooBig(new_size, stack);
    return nullptr;
  }
  RegisterDeallocation(p);

  void *new_p =
      allocator.Reallocate(GetAllocatorCache(), p, new_size, alignment);
  if (new_p)
    RegisterAllocation(stack, new_p, new_size);
  else if (new_size != 0)
    RegisterAllocation(stack, p, new_size);

  if (new_p && new_p == p) {
    struct Metadata *m = GetMetadata(p);
    struct Metadata *new_m = GetMetadata(new_p);

    CHECK(m && new_m);
    new_m->SetRefCount(m->GetRefCount());
  }

  return new_p;
}

uptr *metadata_table;
/*
 * Metabase is stored in the metadata table when new page is allocated,
 * not when an object is allocated or freed.
 */
void __plsan_set_metabase(uptr userbase, uptr metabase, uptr size) {
  uptr page_size = GetPageSizeCached();
  uptr page_shift = __builtin_ctz(page_size);
  uptr page_idx = userbase >> page_shift;
  uptr end = (userbase + size) >> page_shift;
  while (page_idx < end) {
    metadata_table[page_idx++] = metabase;
  }
}

void __plsan_set_metabase(uptr user_chunk_begin, uptr user_map_size,
                          uptr meta_chunk_begin, uptr object_size) {
  uptr page_size = GetPageSizeCached();
  uptr page_shift = __builtin_ctz(page_size);
  uptr page_idx = user_chunk_begin >> page_shift;
  uptr end = (user_chunk_begin + user_map_size) >> page_shift;
  while (page_idx < end) {
    uptr entry = meta_chunk_begin | object_size;
    metadata_table[page_idx++] = entry;
  }
}

void __plsan_reset_metabase(uptr userbase, uptr size) {
  uptr page_shift = __builtin_ctz(GetPageSizeCached());
  uptr page_idx = userbase >> page_shift;
  uptr end = (userbase + size) >> page_shift;
  while (page_idx < end) {
    metadata_table[page_idx++] = 0;
  }
}

void *plsan_malloc(uptr size, StackTrace *stack) {
  return SetErrnoOnNull(Allocate(stack, size, sizeof(u64)));
}

void *plsan_calloc(uptr nmemb, uptr size, StackTrace *stack) {
  if (UNLIKELY(CheckForCallocOverflow(size, nmemb))) {
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportCallocOverflow(nmemb, size, stack);
  }
  // PLSan already zeroes the memory
  return SetErrnoOnNull(Allocate(stack, nmemb * size, sizeof(u64)));
}

void *plsan_realloc(void *p, uptr size, StackTrace *stack) {
  if (!p)
    SetErrnoOnNull(Allocate(stack, size, sizeof(u64)));
  if (size == 0) {
    Deallocate(p);
    return nullptr;
  }
  return SetErrnoOnNull(Reallocate(stack, p, size, 1));
}

void *plsan_reallocarray(void *p, uptr n, uptr size, StackTrace *stack) {
  if (UNLIKELY(CheckForCallocOverflow(size, n))) {
    errno = errno_ENOMEM;
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportReallocArrayOverflow(n, size, stack);
  }
  return plsan_realloc(p, n * size, stack);
}

void *plsan_valloc(uptr size, StackTrace *stack) {
  return SetErrnoOnNull(Allocate(stack, size, GetPageSizeCached()));
}

void *plsan_pvalloc(uptr size, StackTrace *stack) {
  uptr PageSize = GetPageSizeCached();

  if (UNLIKELY(CheckForPvallocOverflow(size, PageSize))) {
    errno = errno_ENOMEM;
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportPvallocOverflow(size, stack);
  }

  size = size ? RoundUpTo(size, PageSize) : PageSize;
  return SetErrnoOnNull(Allocate(stack, size, PageSize));
}

void *plsan_aligned_alloc(uptr alignment, uptr size, StackTrace *stack) {
  if (UNLIKELY(!CheckAlignedAllocAlignmentAndSize(alignment, size))) {
    errno = errno_EINVAL;
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportInvalidAllocationAlignment(alignment, stack);
  }
  return SetErrnoOnNull(Allocate(stack, size, alignment));
}

void *plsan_memalign(uptr alignment, uptr size, StackTrace *stack) {
  if (UNLIKELY(!IsPowerOfTwo(alignment))) {
    errno = errno_EINVAL;
    if (AllocatorMayReturnNull())
      return nullptr;
    ReportInvalidAllocationAlignment(alignment, stack);
  }
  return SetErrnoOnNull(Allocate(stack, size, alignment));
}

int plsan_posix_memalign(void **memptr, uptr alignment, uptr size,
                         StackTrace *stack) {
  if (UNLIKELY(!CheckPosixMemalignAlignment(alignment))) {
    if (AllocatorMayReturnNull())
      return errno_EINVAL;
    ReportInvalidPosixMemalignAlignment(alignment, stack);
  }
  void *ptr = Allocate(stack, size, alignment);
  if (UNLIKELY(!ptr))
    return errno_ENOMEM;
  CHECK(IsAligned((uptr)ptr, alignment));
  *memptr = ptr;
  return 0;
}

void plsan_free(void *ptr) { return Deallocate(ptr); }

uptr GetMallocUsableSize(const void *p) {
  if (!p)
    return 0;
  Metadata *m = GetMetadata(p);
  if (!m)
    return 0;
  return m->GetRequestedSize();
}

uptr GetMallocUsableFast(const void *p) {
  return GetMetadata(p)->GetRequestedSize();
}
} // namespace __plsan

namespace __lsan {
void LockAllocator() { __plsan::PlsanAllocatorLock(); }

void UnlockAllocator() { __plsan::PlsanAllocatorUnlock(); }

void GetAllocatorGlobalRange(uptr *begin, uptr *end) {
  *begin = (uptr)&__plsan::allocator;
  *end = *begin + sizeof(__plsan::allocator);
}

uptr PointsIntoChunk(void *p) {
  uptr addr = reinterpret_cast<uptr>(p);
  uptr chunk =
      reinterpret_cast<uptr>(__plsan::allocator.GetBlockBeginFastLocked(p));
  if (!chunk)
    return 0;
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(
      __plsan::allocator.GetMetaData(reinterpret_cast<void *>(chunk)));
  if (!m || !m->IsAllocated())
    return 0;
  if (addr < chunk + m->GetRequestedSize())
    return chunk;
  if (IsSpecialCaseOfOperatorNew0(chunk, m->GetRequestedSize(), addr))
    return chunk;
  return 0;
}

uptr GetUserBegin(uptr chunk) {
  void *block = __plsan::allocator.GetBlockBeginFastLocked(
      reinterpret_cast<void *>(chunk));
  if (!block)
    return 0;
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(
      __plsan::allocator.GetMetaData(block));
  if (!m || !m->IsAllocated())
    return 0;

  return reinterpret_cast<uptr>(block);
}

uptr GetUserAddr(uptr chunk) { return chunk; }

LsanMetadata::LsanMetadata(uptr chunk) {
  metadata_ =
      chunk ? __plsan::allocator.GetMetaData(reinterpret_cast<void *>(chunk))
            : nullptr;
}

bool LsanMetadata::allocated() const {
  if (!metadata_)
    return false;
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(metadata_);
  return m->IsAllocated();
}

ChunkTag LsanMetadata::tag() const {
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(metadata_);
  return m->GetLsanTag();
}

void LsanMetadata::set_tag(ChunkTag value) {
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(metadata_);
  m->SetLsanTag(value);
}

uptr LsanMetadata::requested_size() const {
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(metadata_);
  return m->GetRequestedSize();
}

u32 LsanMetadata::stack_trace_id() const {
  return reinterpret_cast<__plsan::Metadata *>(metadata_)->GetAllocTraceId();
}

IgnoreObjectResult IgnoreObject(const void *p) {
  uptr addr = reinterpret_cast<uptr>(p);
  uptr chunk = reinterpret_cast<uptr>(__plsan::allocator.GetBlockBegin(p));
  if (!chunk)
    return kIgnoreObjectInvalid;
  __plsan::Metadata *m = reinterpret_cast<__plsan::Metadata *>(
      __plsan::allocator.GetMetaData(reinterpret_cast<void *>(chunk)));
  if (!m || !m->IsAllocated())
    return kIgnoreObjectInvalid;
  if (addr >= chunk + m->GetRequestedSize())
    return kIgnoreObjectInvalid;

  m->SetLsanTag(kIgnored);
  return kIgnoreObjectSuccess;
}

void ForEachChunk(ForEachChunkCallback callback, void *arg) {
  __plsan::allocator.ForEachChunk(callback, arg);
}

bool WordIsPoisoned(uptr addr) { return false; }
} // namespace __lsan
