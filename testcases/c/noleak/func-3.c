#include <stdlib.h>

int func() {
  int *ptr = calloc(3, sizeof(int));
  int *ptr2 = calloc(3, sizeof(int));
  free(ptr);
  free(ptr2);
}

int main(void) { func(); }