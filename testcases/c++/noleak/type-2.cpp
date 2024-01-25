int main(void) {
  int *p = new int;
  delete p;

  int *q = new int;
  delete q;
}