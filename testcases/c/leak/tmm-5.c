#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i = 0;
  while (i < 1000) {
    long long *ptr = (long long *)malloc(10 * sizeof(long long));
    i++;
  }
}
