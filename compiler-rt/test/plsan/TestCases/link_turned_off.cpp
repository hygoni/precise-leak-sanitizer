// Test for disabling LSan at link-time.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts= %run %t
// RUN: %env_lsan_opts= not %run %t foo 2>&1 | FileCheck %s
//
// UNSUPPORTED: darwin

#include <sanitizer/lsan_interface.h>

int argc_copy;

extern "C" {
int __attribute__((used)) __lsan_is_turned_off() {
  return (argc_copy == 1);
}
}

int main(int argc, char *argv[]) {
  volatile int *x = new int;
  *x = 42;
  argc_copy = argc;
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: link_turned_off.cpp:22:3
