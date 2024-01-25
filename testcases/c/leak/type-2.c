#include <stdio.h>
#include <stdlib.h>

int func() {
  int *ptr = (int *)malloc(sizeof(int) * 10);

  return -1;
}

int main(void) { func(); }