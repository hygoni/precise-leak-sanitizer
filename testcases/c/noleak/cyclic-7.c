#include <stdlib.h>

struct Node {
  char data[10];
  struct Node *next;
};

int main(void) {
  struct Node *n1 = (struct Node *)malloc(sizeof(struct Node));
  struct Node *n2 = (struct Node *)malloc(sizeof(struct Node));
  struct Node *n3 = (struct Node *)malloc(sizeof(struct Node));
  struct Node *n4 = (struct Node *)malloc(sizeof(struct Node));

  n1->next = n2;
  n2->next = n3;
  n3->next = n4;
  n4->next = n1;

  free(n1);
  free(n2);
  free(n3);
  free(n4);
}