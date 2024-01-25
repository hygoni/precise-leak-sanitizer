#include <stdlib.h>

int foo(int *addr) { addr = NULL; }

int main(void) {
  int *ptr = (int *)malloc(100);

  foo(ptr);
  foo(NULL);
}