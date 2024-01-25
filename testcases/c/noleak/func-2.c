#include <stdlib.h>

int func() {
  int *ptr = calloc(3, sizeof(int));
  free(ptr);
}

int main(void) { func(); }