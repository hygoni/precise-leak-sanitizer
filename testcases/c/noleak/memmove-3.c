#include <stdlib.h>

int main(void) {
  void *ptr = malloc(sizeof(void *));
  void *ptr2 = malloc(sizeof(void *));

  memmove(ptr2, ptr, sizeof(void *));

  free(ptr);  // free() source!
  free(ptr2); // free() destination!
}