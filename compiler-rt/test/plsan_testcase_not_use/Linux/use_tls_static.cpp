// Test that statically allocated TLS space is included in the root set.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts="" %run %t 2>&1

#include "sanitizer_common/print_address.h"
#include <stdio.h>
#include <stdlib.h>

__thread void *tls_var;

int main() {
  tls_var = malloc(1337);
  print_address("Test alloc: ", 1, tls_var);
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: use_tls_static.cpp:16:3
