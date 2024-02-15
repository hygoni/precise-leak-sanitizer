int func() {
  int *arr = new int[100];
  delete[] arr;
  return 0;
}

int main(void) { func(); }