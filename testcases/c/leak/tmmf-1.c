#include <stdlib.h>

int func() {
  int i = 0;
  while (i < 10000000) {
    char *ptr = (char *)malloc(10 * sizeof(char));
    i++;
  }
}

int main(void) { func(); }