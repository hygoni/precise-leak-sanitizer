// Test for __lsan_ignore_object().
// RUN: %clang_lsan %s -o %t
// RUN: %env_lsan_opts= not %run %t 2>&1 | FileCheck %s

// Investigate why it does not fail with use_stack=0
// UNSUPPORTED: arm-linux || armhf-linux

#include <stdio.h>
#include <stdlib.h>

#include "sanitizer/lsan_interface.h"

int main() {
  // Explicitly ignored object.
  void **p = malloc(sizeof(void *));
  // Transitively ignored object.
  *p = malloc(666);
  // Non-ignored object.
  volatile void *q = malloc(1337);
  fprintf(stderr, "Test alloc: %p.\n", p);
  __lsan_ignore_object(p);
  return 0;
}
// CHECK: Test alloc: [[ADDR:.*]].
// CHECK: Last reference to the object(s) lost at
// CHECK: ignore_object.c:22:3
