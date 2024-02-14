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
#include <cstring>

using namespace __sanitizer;

namespace __plsan {
static Allocator allocator;
static SpinMutex fallback_mutex;
static uptr max_malloc_size;

void GetAllocatorCacheRange(uptr *begin, uptr *end) {
  *begin = (uptr)GetAllocatorCache();
  *end = *begin + sizeof(AllocatorCache);
}

static Metadata *GetMetadata(const void *p) {
  if (!allocator.PointerIsMine(p))
    return nullptr;

  if (allocator.FromPrimary(p))
    return reinterpret_cast<struct Metadata *>(allocator.GetMetaData(p));

  void *aligned_p = (void *)((uptr)p & ~(GetPageSizeCached() - 1));
  return reinterpret_cast<struct Metadata *>(allocator.GetMetaData(aligned_p));
}

void IncRefCount(const void *p) {
  struct Metadata *m = GetMetadata(p);

  if (!m)
    return;

  m->IncRefCount();
}

void DecRefCount(const void *p) {
  struct Metadata *m = GetMetadata(p);

  if (!m)
    return;

  m->DecRefCount();
}

bool PtrIsAllocatedFromPlsan(const void *p) {
  if (!allocator.PointerIsMine(p))
    return false;

  struct Metadata *m = GetMetadata(p);

  if (!m)
    return false;
  return m->IsAllocated();
}

bool IsSameObject(const void *x, const void *y) {
  return GetMetadata(x) == GetMetadata(y);
}

uint8_t GetRefCount(const void *p) {
  struct Metadata *m = GetMetadata(p);

  if (!m)
    return 0;

  return m->GetRefCount();
}

void UpdateReference(void **lhs, void *rhs) {
  if (PtrIsAllocatedFromPlsan(*lhs))
    DecRefCount(*lhs);
  if (PtrIsAllocatedFromPlsan(rhs))
    IncRefCount(rhs);
}

inline void Metadata::SetAllocated(u32 stack, u64 size) {
  requested_size = size;
  alloc_trace_id = stack;
  state = (1 << 7);
}

inline void Metadata::SetLsanTag(__lsan::ChunkTag tag) { lsan_tag = tag; }

inline __lsan::ChunkTag Metadata::GetLsanTag() const { return lsan_tag; }

inline void Metadata::SetUnallocated() {
  requested_size = 0;
  alloc_trace_id = 0;
  state = 0;
}

bool Metadata::IsAllocated() const { return state >> 7; }

inline u64 Metadata::GetRequestedSize() const { return requested_size; }

inline u32 Metadata::GetAllocTraceId() const { return alloc_trace_id; }

inline uint8_t Metadata::GetRefCount() const { return state & ~(1 << 7); }

inline void Metadata::SetRefCount(uint8_t val) {
  atomic_store(reinterpret_cast<atomic_uint8_t *>(&state), val,
               memory_order_relaxed);
}

inline void Metadata::IncRefCount() {
  uint8_t s = state;

  do {
    if (state == UINT8_MAX) {
      return;
    }

  } while (!atomic_compare_exchange_strong(
      reinterpret_cast<atomic_uint8_t *>(&state), &s, s + 1,
      memory_order_relaxed));
}

inline void Metadata::DecRefCount() {
  uint8_t s = state;

  do {
    if (GetRefCount() == 0) {
      return;
    }

  } while (!atomic_compare_exchange_strong(
      reinterpret_cast<atomic_uint8_t *>(&state), &s, s - 1,
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
  Metadata *m = GetMetadata(p);
  m->SetAllocated(StackDepotPut(*stack), size);
  m->SetLsanTag(__lsan::DisabledInThisThread() ? __lsan::kIgnored
                                               : __lsan::kDirectlyLeaked);

  RunMallocHooks(p, size);
}

static void RegisterDeallocation(void *p) {
  if (!p)
    return;
  Metadata *m = GetMetadata(p);
  RunFreeHooks(p);
  m->SetUnallocated();
}

static void *Allocate(StackTrace *stack, uptr size, uptr alignment) {
  if (UNLIKELY(size == 0))
    size = 1;
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
  internal_memset(p, 0, size);
  RegisterAllocation(stack, p, size);
  return p;
}

static void Deallocate(void *p) {
  Metadata *m = GetMetadata(p);

  CHECK(allocator.GetBlockBegin(p) == p);
  void **ptr = reinterpret_cast<void **>(p);
  while ((uintptr_t)ptr < (uintptr_t)p + m->GetRequestedSize()) {
    if (allocator.PointerIsMine(*ptr)) {
      DecRefCount(*ptr);
      __plsan_check_memory_leak(*ptr);
    }
    ptr++;
  }

  m->SetUnallocated();
  RegisterDeallocation(p);
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
  __plsan::Metadata *m =
      reinterpret_cast<__plsan::Metadata *>(__plsan::allocator.GetMetaData(p));
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
