//=-- plsan_thread.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer.
// See plsan_thread.h for details.
//
//===----------------------------------------------------------------------===//

#include "plsan_thread.h"

#include "lsan/lsan_common.h"
#include "plsan.h"
#include "plsan_allocator.h"
#include "sanitizer_common/sanitizer_common.h"
#include "sanitizer_common/sanitizer_placement_new.h"
#include "sanitizer_common/sanitizer_thread_registry.h"
#include "sanitizer_common/sanitizer_tls_get_addr.h"

namespace __plsan {

static ThreadRegistry *thread_registry;
static ThreadArgRetval *thread_arg_retval;

static Mutex mu_for_thread_context;
static LowLevelAllocator allocator_for_thread_context;

static ThreadContextBase *CreateThreadContext(u32 tid) {
  Lock lock(&mu_for_thread_context);
  return new (allocator_for_thread_context) ThreadContext(tid);
}

void InitializeThreads() {
  static ALIGNED(alignof(
      ThreadRegistry)) char thread_registry_placeholder[sizeof(ThreadRegistry)];
  thread_registry =
      new (thread_registry_placeholder) ThreadRegistry(CreateThreadContext);

  static ALIGNED(alignof(ThreadArgRetval)) char
      thread_arg_retval_placeholder[sizeof(ThreadArgRetval)];
  thread_arg_retval = new (thread_arg_retval_placeholder) ThreadArgRetval();
}

ThreadArgRetval &GetThreadArgRetval() { return *thread_arg_retval; }

ThreadContextPlsanBase::ThreadContextPlsanBase(int tid)
    : ThreadContextBase(tid) {}

void ThreadContextPlsanBase::OnStarted(void *arg) {
  SetCurrentThread(this);
  AllocatorThreadStart(GetAllocatorCache());
}

void ThreadContextPlsanBase::OnFinished() {
  AllocatorThreadFinish(GetAllocatorCache());
  DTLS_Destroy();
  SetCurrentThread(nullptr);
}

u32 ThreadCreate(u32 parent_tid, bool detached, void *arg) {
  return thread_registry->CreateThread(0, detached, parent_tid, arg);
}

void ThreadContextPlsanBase::ThreadStart(u32 tid, tid_t os_id,
                                         ThreadType thread_type, void *arg) {
  thread_registry->StartThread(tid, os_id, thread_type, arg);
}

void ThreadFinish() { thread_registry->FinishThread(GetCurrentThreadId()); }

void EnsureMainThreadIDIsCorrect() {
  if (GetCurrentThreadId() == kMainTid)
    GetCurrentThread()->os_id = GetTid();
}

///// Interface to the common LSan module. /////

void GetThreadExtraStackRangesLocked(tid_t os_id,
                                     InternalMmapVector<Range> *ranges) {}
void GetThreadExtraStackRangesLocked(InternalMmapVector<Range> *ranges) {}

ThreadRegistry *GetPlsanThreadRegistryLocked() {
  thread_registry->CheckLocked();
  return thread_registry;
}

void GetRunningThreadsLocked(InternalMmapVector<tid_t> *threads) {
  GetPlsanThreadRegistryLocked()->RunCallbackForEachThreadLocked(
      [](ThreadContextBase *tctx, void *threads) {
        if (tctx->status == ThreadStatusRunning) {
          reinterpret_cast<InternalMmapVector<tid_t> *>(threads)->push_back(
              tctx->os_id);
        }
      },
      threads);
}

void GetAdditionalThreadContextPtrsLocked(InternalMmapVector<uptr> *ptrs) {
  GetThreadArgRetval().GetAllPtrsLocked(ptrs);
}

ThreadRegistry &plsanThreadRegistry() {
  InitializeThreads();
  return *thread_registry;
}

ThreadArgRetval &plsanThreadArgRetval() {
  InitializeThreads();
  return *thread_arg_retval;
}

} // namespace __plsan

namespace __lsan {
void LockThreads() {
  __plsan::plsanThreadRegistry().Lock();
  __plsan::plsanThreadArgRetval().Lock();
}

void UnlockThreads() {
  __plsan::plsanThreadRegistry().Unlock();
  __plsan::plsanThreadArgRetval().Unlock();
}

void EnsureMainThreadIDIsCorrect() { __plsan::EnsureMainThreadIDIsCorrect(); }

bool GetThreadRangesLocked(tid_t os_id, uptr *stack_begin, uptr *stack_end,
                           uptr *tls_begin, uptr *tls_end, uptr *cache_begin,
                           uptr *cache_end, DTLS **dtls) {
  __plsan::ThreadContext *t = static_cast<__plsan::ThreadContext *>(
      __plsan::GetPlsanThreadRegistryLocked()->FindThreadContextByOsIDLocked(
          os_id));
  if (!t)
    return false;
  *stack_begin = t->stack_begin();
  *stack_end = t->stack_end();
  *tls_begin = t->tls_begin();
  *tls_end = t->tls_end();
  __plsan::GetAllocatorCacheRange(cache_begin, cache_end);
  *dtls = t->dtls();
  return true;
}

void GetAllThreadAllocatorCachesLocked(InternalMmapVector<uptr> *caches) {}

void GetThreadExtraStackRangesLocked(tid_t os_id,
                                     InternalMmapVector<Range> *ranges) {}
void GetThreadExtraStackRangesLocked(InternalMmapVector<Range> *ranges) {}

void GetAdditionalThreadContextPtrsLocked(InternalMmapVector<uptr> *ptrs) {
  __plsan::plsanThreadArgRetval().GetAllPtrsLocked(ptrs);
}

void GetRunningThreadsLocked(InternalMmapVector<tid_t> *threads) {}

} // namespace __lsan