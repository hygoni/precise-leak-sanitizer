int main(void) {
  int *p = new int;
  delete p;

  int *q = new int;

  int *r = new int;
  delete q;
  delete r;
}