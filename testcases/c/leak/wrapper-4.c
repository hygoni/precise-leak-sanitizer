#include <stdlib.h>
// interesting case
// ASan can't detect memory leak in this case
// it looks weird,,, ;(

void *malloc_wrapper(size_t size) {
  void *ptr = malloc(size);
  return ptr;
}

void foo() { void *ptr = malloc_wrapper(1000); }

int main(void) { foo(); }