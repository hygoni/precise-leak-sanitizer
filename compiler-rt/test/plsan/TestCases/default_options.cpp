// RUN: %clangxx_lsan -O2 %s -o %t && %run %t 2>&1 | FileCheck %s

extern "C"
const char *__lsan_default_options() {
  // CHECK: Available flags for PreciseLeakSanitizer:
  return "verbosity=1 help=1";
}

int main() {
  return 0;
}
