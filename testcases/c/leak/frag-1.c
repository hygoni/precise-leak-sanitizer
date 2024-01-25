#include <stdlib.h>
#include <time.h>

int main(void) {
  srand(time(NULL));

  for (size_t i = 0; i < 10000; i++) {
    size_t sz = (rand() % 10000) + 1;
    void *ptr = malloc(sz);
  }
}