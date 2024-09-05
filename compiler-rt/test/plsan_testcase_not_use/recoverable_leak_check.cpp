// Test for on-demand leak checking.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts= %run %t foo 2>&1 | FileCheck %s
// RUN: %env_lsan_opts= %run %t 2>&1 | FileCheck %s

// UNSUPPORTED: darwin

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sanitizer/lsan_interface.h>

void *p;

int main(int argc, char *argv[]) {
  p = malloc(23);

  assert(__lsan_do_recoverable_leak_check() == 0);

  fprintf(stderr, "Test alloc: %p.\n", malloc(1337));
// CHECK: Test alloc:

  assert(__lsan_do_recoverable_leak_check() == 1);
// CHECK: recoverable_leak_check.cpp:21:3

  // Test that we correctly reset chunk tags.
  p = 0;
  assert(__lsan_do_recoverable_leak_check() == 1);
// CHECK: recoverable_leak_check.cpp:21:3
// CHECK: recoverable_leak_check.cpp:28:5

  _exit(0);
}
