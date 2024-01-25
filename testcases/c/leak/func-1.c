#include <stdlib.h>

int func() { int *ptr = calloc(3, sizeof(int)); }

int main(void) { func(); }
