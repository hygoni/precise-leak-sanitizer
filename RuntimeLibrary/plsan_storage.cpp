#include "plsan_storage.h"

namespace __plsan {

PlsanStorage::PlsanStorage() {}

void PlsanStorage::push_function() {}

void PlsanStorage::pop_function() {}

// Not shadow memmory address, but origin address is needed.
void PlsanStorage::add_mem_addr(void *addr) {}

LocalDynAllocStorage PlsanStorage::get_function_stack() {
  return function_stack;
}

} // namespace __plsan
