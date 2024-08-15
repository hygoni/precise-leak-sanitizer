// Test for __lsan_ignore_object().
// RUN: %clang_lsan %s -o %t
// RUN: %env_lsan_opts=report_objects=1:use_registers=0:use_stacks=0 not %run %t 2>&1 | FileCheck --check-prefixes=CHECK-a,CHECK-b,CHECK-c,CHECK-ap,CHECK-bp,CHECK-cp %s

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
// CHECK-a: ignore_object.c:15:14
// CHECK-b: ignore_object.c:17:8
// CHECK-c: ignore_object.c:19:22
// CHECK-ap: ignore_object.c:15:10
// CHECK-bp: ignore_object.c:22:3
// CHECK-cp: ignore_object.c:22:3
