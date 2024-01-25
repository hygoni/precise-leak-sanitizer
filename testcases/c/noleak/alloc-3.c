#include <stdlib.h>

int main(void) {
  int *ptr = calloc(3, sizeof(int));
  int *ptr2 = calloc(3, sizeof(int));
  free(ptr);
  free(ptr2);
}
