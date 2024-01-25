#include <stdlib.h>

int main(void) {
  void *ptr = (int *)malloc(100000);
  void *ptr2 = (int *)malloc(100000);

  __builtin_memmove(&ptr2, &ptr, sizeof(void *));

  free(ptr2); // free() source!
}