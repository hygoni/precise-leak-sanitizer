#include <stdlib.h>

int func(void) {}

int main(void) {
  int *ptr = malloc(sizeof(int) * 10);
  func();
  int *ptr2 = malloc(sizeof(int) * 10);
  func();
  free(ptr);
  func();
  free(ptr2);
}