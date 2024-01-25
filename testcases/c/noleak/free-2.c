#include <stdlib.h>

int func(void) {}

int main(void) {
  int *ptr = malloc(sizeof(int) * 10);
  func();
  int *ptr2 = malloc(sizeof(int) * 10);
  func();
  int *ptr3 = malloc(sizeof(int) * 10);
  free(ptr);
  free(ptr3);
  func();
  free(ptr2);
}