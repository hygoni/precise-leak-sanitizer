#include <stdlib.h>
#include <time.h>

int main(void) {
  srand(time(NULL));

  for (size_t i = 0; i < 10000; i++) {
    void *ptr = malloc(100);
  }
}