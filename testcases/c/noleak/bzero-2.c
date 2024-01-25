#include <stdlib.h>
#include <string.h>

int main(void) {
  void *ptr = malloc(30);

  bzero(ptr, 30);

  free(ptr);
}