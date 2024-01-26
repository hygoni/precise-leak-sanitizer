#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int **p = (int **)malloc(sizeof(int *));
  *p = malloc(10);

  free(*p);
  free(p);

  int **ptr = (int **)malloc(sizeof(int *));
  *ptr = malloc(10);

  free(*ptr);
  free(ptr);

  int **ptr2 = (int **)malloc(sizeof(int *));
  free(ptr2);
}