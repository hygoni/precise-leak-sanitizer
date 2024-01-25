#include <stdlib.h>

int func() {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  free(ptr);
}

int main(void) {
  func();
  int *ptr = (int *)malloc(sizeof(int) * 10);
}