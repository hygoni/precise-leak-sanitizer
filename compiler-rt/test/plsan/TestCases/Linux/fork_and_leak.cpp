// Test that leaks detected after forking without exec().
// RUN: %clangxx_lsan %s -o %t && not %run %t 2>&1 | FileCheck %s

/// Fails on clang-cmake-aarch64-full (glibc 2.27-3ubuntu1.4).
// UNSUPPORTED: target=aarch64{{.*}}

#include <assert.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  pid_t pid = fork();
  assert(pid >= 0);
  if (pid > 0) {
    int status = 0;
    waitpid(pid, &status, 0);
    assert(WIFEXITED(status));
    return WEXITSTATUS(status);
  } else {
    for (int i = 0; i < 10; ++i)
      malloc(1337);
  }
  return 0;
}
// CHECK: Last reference to the object(s) lost at
// CHECK: fork_and_leak.cpp:22:7