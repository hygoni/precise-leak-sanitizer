#include <stdlib.h>

int main(void) {
  int *ptr = NULL;
  int *ptr2 = (int *)malloc(sizeof(int) * 10);

  for (size_t i = 10; i > 0; i--) {
    ptr2[i - 1] = i;
  }

  memcpy(&ptr, &ptr2, sizeof(void *));

  free(ptr2);
}