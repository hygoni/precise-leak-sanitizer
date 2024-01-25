#include <stdlib.h>

int main(void) {
  void *ptr = NULL;
  void *ptr2 = malloc(10);

  __builtin_memmove(&ptr, &ptr2, sizeof(void *));

  free(ptr);
}