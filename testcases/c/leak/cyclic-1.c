#include <stdlib.h>

int main(void) {
  int *ptr = (int *)malloc(sizeof(int) * 10);
  int *ptr2 = (int *)malloc(sizeof(int) * 10);

  ptr = &ptr2;
  ptr2 = &ptr;
}