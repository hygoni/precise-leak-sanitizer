#include <stdlib.h>

int main(void) {
  void *ptr = malloc(10);
  void *ptr2 = malloc(10);

  __builtin_memmove(&ptr2, &ptr, sizeof(int *));

  free(ptr2); // free() destination!
}