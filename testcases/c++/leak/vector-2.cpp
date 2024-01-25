#include <vector>

int main(void) {
  std::vector<int> *vec = new std::vector<int>();
  int *int_pointer = new int(1);
  vec->push_back(*int_pointer);
  delete vec;
  return 0;
}