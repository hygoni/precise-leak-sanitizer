#include <stdio.h>
#include <stdlib.h>

char func() {
  char *ptr = (char *)malloc(sizeof(char) * 10);

  return -1;
}

int main(void) { func(); }