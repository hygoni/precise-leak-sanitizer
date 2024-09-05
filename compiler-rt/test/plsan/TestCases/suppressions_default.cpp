// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts= not %run %t 2>&1 | FileCheck %s

#include <stdio.h>
#include <stdlib.h>

#include "sanitizer/lsan_interface.h"

extern "C"
const char *__lsan_default_suppressions() {
  return "leak:*LSanTestLeakingFunc*";
}

void LSanTestLeakingFunc() {
  void *p = malloc(666);
  fprintf(stderr, "Test alloc: %p.\n", p);
}

int main() {
  LSanTestLeakingFunc();
  void *q = malloc(1337);
  fprintf(stderr, "Test alloc: %p.\n", q);
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: suppressions_default.cpp:23:3
// CHECK: Suppressions used: