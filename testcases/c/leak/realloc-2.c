#include <stdlib.h>

int main(void) {
  void *ptr = malloc(10);
  ptr = realloc(ptr, 30);
}