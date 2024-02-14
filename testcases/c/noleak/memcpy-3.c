#include <stdlib.h>

int main(void) {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  int *ptr2 = NULL;

  for (size_t i = 10; i > 0; i--) {
    ptr[i] = i;
  }

  memcpy(&ptr2, &ptr, sizeof(void *));

  free(ptr2);
}
