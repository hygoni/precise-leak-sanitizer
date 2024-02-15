#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i = 0;
  while (i < 1000) {
    double *ptr = (double *)malloc(10 * sizeof(double));
    i++;
  }
}
