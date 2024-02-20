//===-- plsan_allocator.h --------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer.
//
//===----------------------------------------------------------------------===//

#ifndef PLSAN_ALLOCATOR_H
#define PLSAN_ALLOCATOR_H
#include "lsan/lsan_common.h"
#include "plsan_internal.h"
#include "sanitizer_common/sanitizer_allocator.h"
#include "sanitizer_common/sanitizer_allocator_checks.h"
#include "sanitizer_common/sanitizer_allocator_interface.h"
#include "sanitizer_common/sanitizer_allocator_report.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_internal_defs.h"
#include "sanitizer_common/sanitizer_ring_buffer.h"
#include <cstdint>

#if !defined(__aarch64__) && !defined(__x86_64__)
#error Unsupported platform
#endif

namespace __plsan {
struct Metadata {
private:
  // msb: allocated, remaining bits: refcount
  u8 state;
  __lsan::ChunkTag lsan_tag : 2;
#if SANITIZER_WORDSIZE == 64
  uptr requested_size : 54;
#else
  uptr requested_size : 32;
  uptr padding : 22;
#endif
  u32 alloc_trace_id;

public:
  inline void SetAllocated(u32 stack, u64 size);
  inline void SetUnallocated();

  inline bool IsAllocated() const;
  inline u64 GetRequestedSize() const;
  u32 GetAllocTraceId() const;
  inline u32 GetAllocThreadId() const;
  inline void SetLsanTag(__lsan::ChunkTag tag);
  inline __lsan::ChunkTag GetLsanTag() const;
  inline uint8_t GetRefCount() const;
  inline void SetRefCount(uint8_t val);
  inline void IncRefCount();
  inline void DecRefCount();
};

Metadata *GetMetadata(const void *p);

static const uptr kMaxAllowedMallocSize = 1UL << 40;

// XXX: What should map/unmap callback do in PLSan?
struct PlsanMapUnmapCallback {
  void OnMap(uptr p, uptr size) const {}
  void OnMapSecondary(uptr p, uptr size, uptr user_begin,
                      uptr user_size) const {}
  void OnUnmap(uptr p, uptr size) const {}
};

#if SANITIZER_APPLE
const uptr kAllocatorSpace = 0x600000000000ULL;
const uptr kAllocatorSize  = 0x40000000000ULL;  // 4T.
#else
const uptr kAllocatorSpace = 0x500000000000ULL;
const uptr kAllocatorSize = 0x40000000000ULL;  // 4T.
#endif
const uptr kAllocatorEnd = kAllocatorSpace + kAllocatorSize;

struct AP64 {
  static const uptr kSpaceBeg = kAllocatorSpace;
  static const uptr kSpaceSize = kAllocatorSize; // 4T.
  typedef __sanitizer::DefaultSizeClassMap SizeClassMap;
  static const uptr kMetadataSize = sizeof(Metadata);
  using AddressSpaceView = LocalAddressSpaceView;
  static const uptr kFlags = 0;
  typedef PlsanMapUnmapCallback MapUnmapCallback;
};

bool inline PointerIsFromPrimary(uptr ptr) {
  return (kAllocatorSpace <= ptr && ptr < kAllocatorEnd);
}

typedef SizeClassAllocator64<AP64> PrimaryAllocator;
typedef CombinedAllocator<PrimaryAllocator> Allocator;
typedef Allocator::AllocatorCache AllocatorCache;

Allocator::AllocatorCache *GetAllocatorCache();
void GetAllocatorCacheRange(uptr *begin, uptr *end);

uptr GetMallocUsableSize(const void *p);
uptr GetMallocUsableFast(const void *p);

void GetAllocatorGlobalRange(uptr *begin, uptr *end);
void AllocatorThreadStart(AllocatorCache *cache);
void AllocatorThreadFinish(AllocatorCache *cache);

} // namespace __plsan

#endif // PLSAN_ALLOCATOR_H