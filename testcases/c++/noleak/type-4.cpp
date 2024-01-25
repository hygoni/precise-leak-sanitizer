int main(void) {
  int *p = new int[100];
  delete[] p;

  int *q = new int[100];
  delete[] q;
}