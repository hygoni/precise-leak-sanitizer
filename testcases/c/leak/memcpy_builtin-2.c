#include <string.h>

int main(void) {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  int *ptr2 = (int *)malloc(sizeof(int) * 10);

  for (size_t i = 10; i > 0; i--) {
    ptr2[i - 1] = i;
  }

  __builtin_memcpy(&ptr2, &ptr, sizeof(void *));
  free(ptr2);
}