#include <stdlib.h>

void *malloc_wrapper(size_t size) { return malloc(size); }

void foo() { void *foo = malloc_wrapper(10); }

int main(void) { foo(); }