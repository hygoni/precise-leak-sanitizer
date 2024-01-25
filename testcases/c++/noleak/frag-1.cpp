#include <cstdlib>
#include <ctime>
#include <random>

int main(void) {
  std::srand(time(NULL));

  for (int i = 0; i < 10000000; i++) {
    int *ptr = new int[rand() % 10000 + 1];

    delete[] ptr;
  }
}