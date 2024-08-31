// Test that fake stack (introduced by ASan's use-after-return mode) is included
// in the root set.
// RUN: %clangxx_lsan %s -O2 -o %t
// RUN: env ASAN_OPTIONS=detect_stack_use_after_return=1 %env_lsan_opts="" %run %t 2>&1

// Investigate why it does not fail with use_stack=0
// UNSUPPORTED: arm-linux || armhf-linux

#include "sanitizer_common/print_address.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  void *stack_var = malloc(1337);
  print_address("Test alloc: ", 1, stack_var);
  // Take pointer to variable, to ensure it's not optimized into a register.
  print_address("Stack var at: ", 1, &stack_var);
  // Do not return from main to prevent the pointer from going out of scope.
  exit(0);
}
// CHECK: Last reference to the object(s) lost at
// CHECK: use_after_return.cpp:21:3
