int func() {
  int *arr = new int[100];
  delete[] arr;
}

int main(void) { func(); }