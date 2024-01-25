#include <stdio.h>
#include <stdlib.h>

int func() {
  int *ptr = malloc(1000000);
  return -1;
}

int main() { func(); }