// Test for the leak_check_at_exit flag.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts= not %run %t 2>&1 | FileCheck %s --check-prefix=CHECK-do

#include <sanitizer/lsan_interface.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  fprintf(stderr, "Test alloc: %p.\n", malloc(1337));
  if (argc > 1)
    __lsan_do_leak_check();
  return 0;
}

// CHECK-do: Last reference to the object(s) lost at
// CHECK-do: leak_check_at_exit.cpp:10:3
// CHECK-do: SUMMARY: {{.*}}Sanitizer:
// CHECK-dont-NOT: SUMMARY: {{.*}}Sanitizer:
