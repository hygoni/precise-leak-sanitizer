#include <stdlib.h>

int main(void) {
  int len = 3;
  void *arr[len];

  arr[0] = malloc(30);
  arr[1] = malloc(30);
  arr[2] = malloc(30);

  free(arr[0]);
  free(arr[1]);
}