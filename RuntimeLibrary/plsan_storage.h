#ifndef PLSAN_STORAGE_H
#define PLSAN_STORAGE_H

#include <stack>

using LocalDynAllocStorage = std::stack<std::stack<void *>>;

class PlsanStorage {
public:
  void push_function();
  void pop_function();
  void add_mem_addr();
  LocalDynAllocStorage get_function_stack();

private:
  LocalDynAllocStorage function_stack;
};

#endif
