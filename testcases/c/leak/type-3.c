#include <stdio.h>
#include <stdlib.h>

int func() {
  double *ptr = (int *)malloc(sizeof(double) * 10);

  return -1;
}

int main(void) { func(); }