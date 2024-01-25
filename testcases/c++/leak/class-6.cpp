#include <cstdio>
#include <string.h>

class SimpleNameClass {
private:
  char *name;

public:
  SimpleNameClass();
  ~SimpleNameClass();
  void setName(char *str);
};

SimpleNameClass::SimpleNameClass() {}

SimpleNameClass::~SimpleNameClass() { delete[] name; }

void SimpleNameClass::setName(char *str) {
  size_t len;

  len = strlen(str);
  name = new char[len + 1];

  if (name != NULL) {
    strcpy(name, str);
  }
}

int main(void) {
  SimpleNameClass *c = new SimpleNameClass();

  for (size_t i = 0; i < 10000; i++) {
    c->setName("AAAAA");
  }
}