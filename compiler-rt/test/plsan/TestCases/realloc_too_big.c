// RUN: %clang_lsan %s -o %t
// RUN: %env_lsan_opts=allocator_may_return_null=1:max_allocation_size_mb=1 not %run %t 2>&1 | FileCheck %s

/// Fails when only leak sanitizer is enabled
// UNSUPPORTED: arm-linux, armhf-linux

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

// CHECK: Last reference to the object(s) lost at
// CHECK: realloc_too_big.c:18:5

int main() {
  char *p = malloc(9);
  fprintf(stderr, "nine: %p\n", p);
  assert(realloc(p, 0x100001) == NULL); // 1MiB+1
  p = 0;
}
