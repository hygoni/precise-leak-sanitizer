#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_handler.h"
#include "plsan_shadow.h"

#include <initializer_list>
#include <tuple>

namespace __plsan {

class Plsan {
public:
  Plsan();
  ~Plsan();

  // Instrumentation function
  size_t align_size(size_t size);
  void init_refcnt(void *addr, size_t size);
  void fini_refcnt(void *addr);
  void reference_count(void **lhs, void *rhs);
  void free_stack_variables(std::initializer_list<void *> var_addrs);
  void free_stack_arrays(
      std::initializer_list<std::tuple<void *, size_t>> arr_addrs_and_lens);
  void check_returned_or_stored_value(void *ret_ptr_addr,
                                      void *compare_ptr_addr);

private:
  PlsanShadow *shadow;
  PlsanHandler *handler;
  void check_memory_leak(void *addr);
  void check_memory_leak(RefCountAnalysis analysis_result);
  void *ptr_array_value(void *array_start_addr, size_t index);
};

} // namespace __plsan

#endif
