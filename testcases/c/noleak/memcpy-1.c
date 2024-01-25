#include <stdlib.h>

int main(void) {
  void *ptr = NULL;
  void *ptr2 = (int *)malloc(10);

  memcpy(&ptr, &ptr2, sizeof(void *));

  free(ptr2);
}