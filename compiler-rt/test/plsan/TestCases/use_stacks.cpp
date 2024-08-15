// Test that stack of main thread is included in the root set.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts="report_objects=1:use_registers=0:use_stacks=0" not %run %t 2>&1 | FileCheck %s
// RUN: %env_lsan_opts="report_objects=1:use_registers=0:use_stacks=1" %run %t 2>&1
// RUN: %env_lsan_opts="" %run %t 2>&1

#include "sanitizer_common/print_address.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  void *stack_var = malloc(1337);
  print_address("Test alloc: ", 1, stack_var);
  // Do not return from main to prevent the pointer from going out of scope.
  exit(0);
}
// CHECK: Last reference to the object(s) lost at
// CHECK: use_stacks.cpp
