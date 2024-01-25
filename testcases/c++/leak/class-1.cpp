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

int main(void) { LeakClass l; }