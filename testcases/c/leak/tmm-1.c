#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i = 0;
  while (i < 10000000) {
    char *ptr = (char *)malloc(10 * sizeof(char));
    i++;
  }
}