// RUN: %clangxx_lsan %s -o %t

// RUN: rm -f %t.supp
// RUN: touch %t.supp
// RUN: %push_to_device %t.supp %device_rundir/%t.supp
// RUN: %env_lsan_opts="use_registers=0:use_stacks=0:suppressions='%device_rundir/%t.supp'" not %run %t 2>&1 | FileCheck %s --check-prefix=NOSUPP

// RUN: echo "leak:*LSanTestLeakingFunc*" > %t.supp
// RUN: %push_to_device  %t.supp %device_rundir/%t.supp
// RUN: %env_lsan_opts="use_registers=0:use_stacks=0:suppressions='%device_rundir/%t.supp'" not %run %t 2>&1 | FileCheck %s
//
// RUN: echo "leak:%t" > %t.supp
// RUN: %push_to_device  %t.supp %device_rundir/%t.supp
// RUN: %env_lsan_opts="use_registers=0:use_stacks=0:suppressions='%device_rundir/%t.supp':symbolize=false" %run %t

#include <stdio.h>
#include <stdlib.h>

void *LSanTestLeakingFunc() {
  void *p = malloc(666);
  fprintf(stderr, "Test alloc: %p.\n", p);
  return p;
}

void LSanTestUnsuppressedLeakingFunc() {
  void **p = (void **)LSanTestLeakingFunc();
  *p = malloc(777);
  fprintf(stderr, "Test alloc: %p.\n", *p);
}

int main() {
  LSanTestUnsuppressedLeakingFunc();
  void *q = malloc(1337);
  fprintf(stderr, "Test alloc: %p.\n", q);
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: suppressions_file.cpp:35:3
// CHECK: Suppressions used:
// CHECK: 1 1024 *LSanTestLeakingFunc*
// CHECK: SUMMARY: {{.*}}Sanitizer: 2048 byte(s) leaked in 1 allocation(s)

// NOSUPP: suppressions_file.cpp:35:3
// NOSUPP: suppressions_file.cpp:32:3
// NOSUPP: suppressions_file.cpp:28
