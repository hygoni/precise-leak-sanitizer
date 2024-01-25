#include <stdlib.h>

void *malloc_wrapper(size_t size) {
  void *ptr = malloc(size);
  return ptr;
}

void foo() { void *ptr = malloc_wrapper(1000); }

int main(void) { foo(); }