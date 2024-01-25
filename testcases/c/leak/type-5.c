#include <stdio.h>
#include <stdlib.h>

int func() {
  long long *ptr = (long long *)malloc(sizeof(long long) * 10);

  return -1;
}

int main(void) { func(); }