#include <stdlib.h>

int func() {
  int *ptr = malloc(100000);
  int *ptr2 = malloc(100000);
  return -1;
}

int main() { func(); }