#include <cstdio>

class LeakClass {
private:
  char *str;

public:
  LeakClass();
  ~LeakClass();
};

LeakClass::LeakClass() { str = new char[100]; }

LeakClass::~LeakClass() {}

class CommonClass {
private:
  char *str;

public:
  CommonClass();
  ~CommonClass();
};

CommonClass::CommonClass() { str = new char[100]; }

CommonClass::~CommonClass() {
  delete str;
  str = NULL;
}

int main(void) {
  LeakClass l;
  CommonClass c;
}