// Test that statically allocated thread-specific storage is included in the root set.
// RUN: %clangxx_lsan %s -o %t
// RUN: %env_lsan_opts="" %run %t 2>&1

#include "sanitizer_common/print_address.h"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

// From glibc: this many keys are stored in the thread descriptor directly.
const unsigned PTHREAD_KEY_2NDLEVEL_SIZE = 32;

int main() {
  pthread_key_t key;
  int res;
  res = pthread_key_create(&key, NULL);
  assert(res == 0);
#if !defined(__ANDROID__) && !defined(__BIONIC__)
  // Bionic doesn't have specific limit.
  assert(key < PTHREAD_KEY_2NDLEVEL_SIZE);
#endif
  void *p = malloc(1337);
  res = pthread_setspecific(key, p);
  assert(res == 0);
  print_address("Test alloc: ", 1, p);
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: use_tls_pthread_specific_static.cpp:29:3
