int main(void) {
  for (int i = 0; i < 1000; i++) {
    int *ptr = new int[10];

    delete[] ptr;
  }
}
