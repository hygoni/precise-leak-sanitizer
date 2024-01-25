#include <stdio.h>
#include <stdlib.h>

long long func() {
  char *ptr = (char *)malloc(sizeof(char) * 10);

  return -1;
}

int main(void) { func(); }