#ifndef PLSAN_STORAGE_H
#define PLSAN_STORAGE_H

#include <stack>

namespace __plsan {

using LocalDynAllocStorage = std::stack<std::stack<void *>>;

class PlsanStorage {
public:
  PlsanStorage();
  void push_function();
  void pop_function();
  void add_mem_addr(void *addr);
  LocalDynAllocStorage get_function_stack();

private:
  LocalDynAllocStorage function_stack;
};

} // namespace __plsan

#endif
