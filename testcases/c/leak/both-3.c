#include <stdlib.h>

int func() {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  free(ptr);
  int *ptr2 = (int *)malloc(sizeof(int) * 10);
}

int main(void) {
  func();
  int *ptr = (int *)malloc(sizeof(int) * 10);
  free(ptr);
}