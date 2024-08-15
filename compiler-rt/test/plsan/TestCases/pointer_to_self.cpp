// Regression test: pointers to self should not confuse LSan into thinking the
// object is indirectly leaked. Only external pointers count.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts="" not %run %t 2>&1 | FileCheck %s

#include "sanitizer_common/print_address.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  void *p = malloc(1337);
  *reinterpret_cast<void **>(p) = p;
  print_address("Test alloc: ", 1, p);
}
// CHECK: Last reference to the object(s) lost at
// CHECK: pointer_to_self.cpp:13
