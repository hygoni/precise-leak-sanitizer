// RUN: %clang_lsan %s -o %t
// RUN: %env_lsan_opts= not %run %t 2>&1 | FileCheck %s

/// Fails when only leak sanitizer is enabled
// UNSUPPORTED: arm-linux, armhf-linux

#include <stdio.h>
#include <stdlib.h>

// CHECK: Last reference to the object(s) lost at
// CHECK: malloc_zero.c:17:5

int main() {
  // The behavior of malloc(0) is implementation-defined.
  char *p = malloc(0);
  fprintf(stderr, "zero: %p\n", p);
  p = 0;
}
