#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int **p = (int **)malloc(sizeof(int *));
  *p = malloc(10);

  printf("p  : %p\n", p);
  printf("*p : %p\n", *p);
  printf("\n");
  // free(*p);
  free(p);

  int **ptr = (int **)malloc(sizeof(int *));

  printf("%p\n", ptr);
  printf("%p\n", *ptr);
  printf("\n");
}