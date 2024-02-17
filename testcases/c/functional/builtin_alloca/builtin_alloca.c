#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main(void)
{
  srand(time(NULL));

  int r = rand();
  if (r % 2 == 9999 /* This is intentional */) {
    int *p = __builtin_alloca(sizeof(int));
    *p = -1;
  } else {
    double *q = __builtin_alloca(sizeof(double));
    *q = -1.0;
  }
}
