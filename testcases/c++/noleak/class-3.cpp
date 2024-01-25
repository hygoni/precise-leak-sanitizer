#include <cstdio>

class CommonClass {
private:
  char *str;

public:
  CommonClass();
  ~CommonClass();
};

CommonClass::CommonClass() { str = new char[100]; }

CommonClass::~CommonClass() {
  delete[] str;
  str = NULL;
}

int main(void) { CommonClass c; }