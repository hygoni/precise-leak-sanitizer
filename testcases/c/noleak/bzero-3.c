#include <stdlib.h>
#include <string.h>

int main(void) {
  void *ptr = malloc(30);
  void *ptr2 = malloc(30);

  free(ptr);
  bzero(ptr, 30);
  bzero(ptr2, 30);
  free(ptr2);
}