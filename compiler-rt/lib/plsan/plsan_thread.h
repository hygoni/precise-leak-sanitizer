//=-- lsan_thread.h -------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of LeakSanitizer.
// Thread registry for standalone LSan.
//
//===----------------------------------------------------------------------===//

#ifndef PLSAN_THREAD_H
#define PLSAN_THREAD_H

#include "plsan_internal.h"
#include "sanitizer_common/sanitizer_thread_arg_retval.h"
#include "sanitizer_common/sanitizer_thread_registry.h"

namespace __plsan {

class ThreadContextPlsanBase : public ThreadContextBase {
public:
  explicit ThreadContextPlsanBase(int tid);
  void OnStarted(void *arg) override;
  void OnFinished() override;
  uptr stack_begin() { return stack_begin_; }
  uptr stack_end() { return stack_end_; }
  uptr cache_begin() { return cache_begin_; }
  uptr cache_end() { return cache_end_; }

  // The argument is passed on to the subclass's OnStarted member function.
  static void ThreadStart(u32 tid, tid_t os_id, ThreadType thread_type,
                          void *onstarted_arg);

protected:
  ~ThreadContextPlsanBase() {}
  uptr stack_begin_ = 0;
  uptr stack_end_ = 0;
  uptr cache_begin_ = 0;
  uptr cache_end_ = 0;
};

// This subclass of ThreadContextPlsanBase is declared in an OS-specific header.
class ThreadContext;

void InitializeThreads();
void InitializeMainThread();

ThreadRegistry *GetPlsanThreadRegistryLocked();
ThreadArgRetval &GetThreadArgRetval();

u32 ThreadCreate(u32 tid, bool detached, void *arg = nullptr);
void ThreadFinish();

ThreadContextPlsanBase *GetCurrentThread();
inline u32 GetCurrentThreadId() {
  ThreadContextPlsanBase *ctx = GetCurrentThread();
  return ctx ? ctx->tid : kInvalidTid;
}
void SetCurrentThread(ThreadContextPlsanBase *tctx);
void EnsureMainThreadIDIsCorrect();

} // namespace __plsan

#endif // PLSAN_THREAD_H
