#include <stdio.h>
#include <stdlib.h>

double func() {
  char *ptr = (char *)malloc(sizeof(char) * 10);

  return -1.0f;
}

int main(void) { func(); }