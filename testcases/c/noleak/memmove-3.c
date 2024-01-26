#include <stdlib.h>

int main(void) {
  void *ptr = malloc(sizeof(void *));
  void *ptr2 = NULL;

  memmove(&ptr2, &ptr, sizeof(void *));

  free(ptr2); // free() destination!
}