#include <vector>

class SimpleClass {
private:
  char *str;

public:
  SimpleClass();
  ~SimpleClass();
};

SimpleClass::SimpleClass() { str = new char[100]; }

SimpleClass::~SimpleClass() {}

int main(void) { std::vector<SimpleClass> *v = new std::vector<SimpleClass>(); }