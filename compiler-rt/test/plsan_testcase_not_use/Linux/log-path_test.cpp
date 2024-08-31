// RUN: %clangxx_lsan %s -o %t
// The globs below do not work in the lit shell.

// Regular run.
// RUN: %env_lsan_opts="use_stacks=0" not %run %t > %t.out 2>&1
// RUN: FileCheck %s --check-prefix=CHECK-ERROR < %t.out

// Good log_path.
// RUN: rm -f %t.log.* %t.log
// RUN: %adb_shell 'rm -f %t.log.*'
// RUN: %env_lsan_opts="use_stacks=0:log_path='"%device_rundir/%t.log"'" not %run %t > %t.out 2>&1
// adb-pull doesn't support wild cards so we need to rename the log file.
// RUN: cat %device_rundir/%t.log.* >> %t.log
// RUN: %adb_shell 'cat %device_rundir/%t.log.*' >> %t.log
// RUN: FileCheck %s --check-prefix=CHECK-ERROR < %t.log.*

#include "sanitizer_common/print_address.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
  void *stack_var = malloc(1337);
  print_address("Test alloc: ", 1, stack_var);
  // Do not return from main to prevent the pointer from going out of scope.
  exit(0);
}

// CHECK-ERROR: Last reference to the object(s) lost at
// CHECK-ERROR: log-path_test.cpp:25:3
