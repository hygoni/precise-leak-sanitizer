#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i = 0;
  while (i < 1000) {
    float *ptr = (float *)malloc(10 * sizeof(float));
    i++;
  }
}
