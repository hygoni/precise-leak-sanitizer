//===-- plsan_new_delete.cpp ---------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is a part of PreciseLeakSanitizer.
//
// Interceptors for operators new and delete.
//===----------------------------------------------------------------------===//

#include "interception/interception.h"
#include "plsan.h"
#include "sanitizer_common/sanitizer_allocator.h"
#include "sanitizer_common/sanitizer_allocator_report.h"

#include <stddef.h>
#include <stdlib.h>

// TODO(alekseys): throw std::bad_alloc instead of dying on OOM.
#define OPERATOR_NEW_BODY(nothrow)                                             \
  GET_MALLOC_STACK_TRACE;                                                      \
  void *res = plsan_malloc(size, &stack);                                      \
  if (!nothrow && UNLIKELY(!res))                                              \
    ReportOutOfMemory(size, &stack);                                           \
  return res

#define OPERATOR_DELETE_BODY                                                   \
  if (ptr)                                                                     \
  plsan_free(ptr)

using namespace __plsan;

// Fake std::nothrow_t to avoid including <new>.
namespace std {
struct nothrow_t {};
} // namespace std

INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void *operator new(size_t size) {
  OPERATOR_NEW_BODY(false /*nothrow*/);
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void *
operator new[](size_t size) {
  OPERATOR_NEW_BODY(false /*nothrow*/);
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void *
operator new(size_t size, std::nothrow_t const &) {
  OPERATOR_NEW_BODY(true /*nothrow*/);
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void *
operator new[](size_t size, std::nothrow_t const &) {
  OPERATOR_NEW_BODY(true /*nothrow*/);
}

INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete(void *ptr) NOEXCEPT {
  OPERATOR_DELETE_BODY;
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete[](void *ptr) NOEXCEPT {
  OPERATOR_DELETE_BODY;
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete(void *ptr, std::nothrow_t const &) {
  OPERATOR_DELETE_BODY;
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete[](void *ptr, std::nothrow_t const &) {
  OPERATOR_DELETE_BODY;
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete(void *ptr, size_t) NOEXCEPT {
  OPERATOR_DELETE_BODY;
}
INTERCEPTOR_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE void
operator delete[](void *ptr, size_t) NOEXCEPT {
  OPERATOR_DELETE_BODY;
}