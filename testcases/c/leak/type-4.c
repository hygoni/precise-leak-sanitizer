#include <stdio.h>
#include <stdlib.h>

int func() {
  float *ptr = (float *)malloc(sizeof(float) * 10);

  return -1;
}

int main(void) { func(); }