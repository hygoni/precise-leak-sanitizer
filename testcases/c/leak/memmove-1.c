#include <stdlib.h>

int main(void) {
  void *ptr = malloc(10);
  void *ptr2 = malloc(10);

  memmove(&ptr2, &ptr, sizeof(void *));
  free(ptr2); // free() destination!
}