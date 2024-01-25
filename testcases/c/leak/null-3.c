#include <stdio.h>
#include <stdlib.h>

float func() {
  char *ptr = (char *)malloc(sizeof(char) * 10);

  ptr = NULL;
  return -1.0f;
}

int main(void) { func(); }