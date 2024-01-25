int main(void) {
  for (int i = 0; i < 10000000; i++) {
    int *ptr = new int[10];

    delete[] ptr;
  }
}