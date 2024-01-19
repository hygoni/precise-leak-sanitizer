#include "plsan_storage.h"

void PlsanStorage::push_function() {}

void PlsanStorage::pop_function() {}

void PlsanStorage::add_mem_addr() {}

LocalDynAllocStorage PlsanStorage::get_function_stack() {
  return function_stack;
}
