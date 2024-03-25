//===-- plsan_interceptors.cpp --------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer.
//
// Interceptors for standard library functions.
//
// FIXME: move as many interceptors as possible into
// sanitizer_common/sanitizer_common_interceptors.h
//===----------------------------------------------------------------------===//

#include "plsan_internal.h"
#include "sanitizer_common/sanitizer_thread_arg_retval.h"
#define SANITIZER_COMMON_NO_REDEFINE_BUILTINS

#include "interception/interception.h"
#include "lsan/lsan_common.h"
#include "plsan.h"
#include "plsan_allocator.h"
#include "sanitizer_common/sanitizer_errno.h"
#include "sanitizer_common/sanitizer_linux.h"
#include "sanitizer_common/sanitizer_stackdepot.h"

using namespace __plsan;

extern "C" {
int pthread_attr_init(void *attr);
int pthread_attr_destroy(void *attr);
int pthread_attr_getdetachstate(void *attr, int *v);
int pthread_key_create(unsigned *key, void (*destructor)(void *v));
int pthread_setspecific(unsigned key, const void *v);
}

struct ThreadStartArg {
  __sanitizer_sigset_t starting_sigset_;
};

static void *ThreadStartFunc(void *arg) {
  SetSigProcMask(&reinterpret_cast<ThreadStartArg *>(arg)->starting_sigset_,
                 nullptr);
  InternalFree(arg);
  InitializeLocalVariableTLS();
  auto self = GetThreadSelf();
  auto args = GetThreadArgRetval().GetArgs(self);
  void *retval = (*args.routine)(args.arg_retval);
  GetThreadArgRetval().Finish(self, retval);
  return retval;
}

extern "C" {
int pthread_attr_getdetachstate(void *attr, int *v);
}

INTERCEPTOR(int, pthread_create, void *thread, void *attr,
            void *(*callback)(void *), void *param) {
  EnsureMainThreadIDIsCorrect();
  bool detached = [attr]() {
    int d = 0;
    return attr && !pthread_attr_getdetachstate(attr, &d) && IsStateDetached(d);
  }();
  ThreadStartArg *A = (ThreadStartArg *)InternalAlloc(sizeof(ThreadStartArg));
  ScopedBlockSignals block(&A->starting_sigset_);
  // ASAN uses the same approach to disable leaks from pthread_create.
  __lsan::ScopedInterceptorDisabler lsan_disabler;

  int result;
  GetThreadArgRetval().Create(detached, {callback, param}, [&]() -> uptr {
    result = REAL(pthread_create)(thread, attr, &ThreadStartFunc, A);
    return result ? 0 : *(uptr *)(thread);
  });
  if (result != 0)
    InternalFree(A);
  return result;
  return result;
}

INTERCEPTOR(int, pthread_join, void *thread, void **retval) {
  int result;
  GetThreadArgRetval().Join((uptr)thread, [&]() {
    result = REAL(pthread_join)(thread, retval);
    return !result;
  });
  return result;
}

INTERCEPTOR(int, pthread_detach, void *thread) {
  int result;
  GetThreadArgRetval().Detach((uptr)thread, [&]() {
    result = REAL(pthread_detach)(thread);
    return !result;
  });
  return result;
}

INTERCEPTOR(int, pthread_exit, void *retval) {
  GetThreadArgRetval().Finish(GetThreadSelf(), retval);
  DeleteLocalVariableTLS();
  return REAL(pthread_exit)(retval);
}

#if SANITIZER_GLIBC
INTERCEPTOR(int, pthread_tryjoin_np, void *thread, void **ret) {
  int result;
  GetThreadArgRetval().Join((uptr)thread, [&]() {
    result = REAL(pthread_tryjoin_np)(thread, ret);
    return !result;
  });
  return result;
}

INTERCEPTOR(int, pthread_timedjoin_np, void *thread, void **ret,
            const struct timespec *abstime) {
  int result;
  GetThreadArgRetval().Join((uptr)thread, [&]() {
    result = REAL(pthread_timedjoin_np)(thread, ret, abstime);
    return !result;
  });
  return result;
}
#endif

DEFINE_REAL_PTHREAD_FUNCTIONS

DEFINE_REAL(int, vfork)
DECLARE_EXTERN_INTERCEPTOR_AND_WRAPPER(int, vfork)

namespace __plsan {

int OnExit() {
  if (CAN_SANITIZE_LEAKS && common_flags()->detect_leaks &&
      __lsan::HasReportedLeaks()) {
    return common_flags()->exitcode;
  }
  // FIXME: ask frontend whether we need to return failure.
  return 0;
}

void InitializeInterceptors() {
  static int inited = 0;
  CHECK_EQ(inited, 0);

  // InitializeCommonInterceptors();

  INTERCEPT_FUNCTION(pthread_create);
  INTERCEPT_FUNCTION(pthread_join);
  INTERCEPT_FUNCTION(pthread_detach);
  INTERCEPT_FUNCTION(pthread_exit);
#if SANITIZER_GLIBC
  INTERCEPT_FUNCTION(pthread_tryjoin_np);
  INTERCEPT_FUNCTION(pthread_timedjoin_np);
#endif
  inited = 1;
}

} // namespace __plsan