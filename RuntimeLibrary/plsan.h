#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_handler.h"
#include "plsan_shadow.h"

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
  std::vector<void *> *free_stack_variables(void *ret_addr, bool is_return,
                                            std::vector<void **> var_addrs);
  std::vector<void *> *free_stack_array(void **arr_addr, size_t size,
                                        void *ret_addr, bool is_return);
  void check_returned_or_stored_value(void *ret_ptr_addr,
                                      void *compare_ptr_addr);
  void check_memory_leak(void *addr);
  void check_memory_leak(RefCountAnalysis analysis_result);
  void memcpy_refcnt(void *dest, void *src, size_t count);

private:
  PlsanShadow *shadow;
  PlsanHandler *handler;
  void *ptr_array_value(void *array_start_addr, size_t index);
};

} // namespace __plsan

#endif
