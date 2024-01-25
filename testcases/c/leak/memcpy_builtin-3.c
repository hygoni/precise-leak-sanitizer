#include <string.h>

int main(void) {
  void *ptr = NULL;

  __builtin_memcpy(&ptr, malloc(sizeof(int) * 10), sizeof(void *));

  free(ptr);
}