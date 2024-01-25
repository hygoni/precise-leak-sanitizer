#include <stdlib.h>

int foo(int *addr) { addr = (int *)malloc(100); }

int main(void) {
  int *ptr = (int *)malloc(100);

  foo(ptr);
  foo(NULL);
}