#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i = 0;
  while (i < 1000) {
    int *ptr = (int *)malloc(10 * sizeof(int));
    i++;
  }
}
