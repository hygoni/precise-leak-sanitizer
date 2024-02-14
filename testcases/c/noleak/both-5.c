#include <stdlib.h>

int func() {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  free(ptr);
  int *ptr2 = (int *)malloc(sizeof(int) * 10);
  free(ptr2);
}

int main(void) {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  free(ptr);
  int *ptr2 = (int *)malloc(sizeof(int) * 10);
  func();
  free(ptr2);
}