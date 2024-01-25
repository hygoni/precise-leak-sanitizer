#include <stdio.h>
#include <stdlib.h>

int main(void) {
  void *ptr = malloc(10);
  ptr = realloc(ptr, 30);
  ptr = realloc(ptr, 31);
  ptr = realloc(ptr, 32);
  free(ptr);
}