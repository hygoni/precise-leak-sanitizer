#include <stdlib.h>

void **func() {
  int len = 3;
  void *arr[len];

  arr[0] = malloc(30);
  arr[1] = malloc(30);
  arr[2] = malloc(30);

  return arr;
}

int main(void) { func(); }