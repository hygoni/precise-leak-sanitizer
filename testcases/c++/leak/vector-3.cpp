#include <vector>

class Test {
private:
  char *str;

public:
  Test();
  ~Test();
};

Test::Test() { str = new char[100]; }

Test::~Test() { delete[] str; }

int main(void) {
  std::vector<Test> *vec = new std::vector<Test>();
  Test *t = new Test();
  vec->push_back(*t);
  delete vec;
  return 0;
}