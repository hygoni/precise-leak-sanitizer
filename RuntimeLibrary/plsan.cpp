/* READ THIS:
 * The name of a function here must start with double underscores to avoid
 * collisons with the program. For example: __foo(), __bar(), etc.
 */

#include "plsan.h"

#include <cstddef>

__plsan::Plsan *plsan;

/* Initialization routines called before main() */
__attribute__((constructor)) void __plsan_init() { /* TODO: */
  plsan = new __plsan::Plsan();
}

/* finialization routines called after main() */
__attribute__((destructor)) void __plsan_fini() { delete plsan; }

extern "C" size_t __plsan_align(size_t size) { return plsan->align_size(size); }

extern "C" void __plsan_alloc(void *addr, size_t size) {
  plsan->init_refcnt(addr, size);
}

extern "C" void __plsan_free(void *addr) { plsan->fini_refcnt(addr); }

extern "C" void __plsan_store(void **lhs, void *rhs) {
  plsan->reference_count(lhs, rhs);
}

extern "C" void
__plsan_free_stack_variables(std::initializer_list<void *> var_addrs) {
  plsan->free_stack_variables(var_addrs);
}

extern "C" void __plsan_free_stack_arrays(
    std::initializer_list<std::tuple<void *, size_t>> arr_addrs_and_lens) {
  plsan->free_stack_arrays(arr_addrs_and_lens);
}

extern "C" void __plsan_check_returned_or_stored_value(void *ret_ptr_addr,
                                                       void *compare_ptr_addr) {
  plsan->check_returned_or_stored_value(ret_ptr_addr, compare_ptr_addr);
}

namespace __plsan {

Plsan::Plsan() {
  shadow = new PlsanShadow();
  handler = new PlsanHandler();
}

Plsan::~Plsan() {
  delete shadow;
  delete handler;
}

size_t Plsan::align_size(size_t size) { return (size + 15) & ~15; }

void Plsan::init_refcnt(void *addr, size_t size) {
  shadow->alloc_shadow(addr, size);
}

void Plsan::fini_refcnt(void *addr) { shadow->free_shadow(addr); }

void Plsan::reference_count(void **lhs, void *rhs) {
  shadow->update_shadow(*lhs, rhs);
  check_memory_leak(*lhs);
}

void Plsan::free_stack_variables(std::initializer_list<void *> var_addrs) {
  for (void *var_addr : var_addrs) {
    shadow->add_shadow(var_addr, 1);
    check_memory_leak(var_addr);
  }
}

void Plsan::free_stack_arrays(
    std::initializer_list<std::tuple<void *, size_t>> arr_addrs_and_lens) {
  for (std::tuple<void *, size_t> arr_tuple : arr_addrs_and_lens) {
    void *array_start_addr = std::get<0>(arr_tuple);
    size_t size = std::get<1>(arr_tuple);
    for (int i = 0; i < size; i++) {
      void *ptr_value = ptr_array_value(array_start_addr, i);
      shadow->add_shadow(ptr_value, 1);
      check_memory_leak(ptr_value);
    }
  }
}

void Plsan::check_returned_or_stored_value(void *ret_ptr_addr,
                                           void *compare_ptr_addr) {
  RefCountAnalysis analysis_result = shadow->shadow_analysis(ret_ptr_addr);
  // check address type
  if (std::get<0>(analysis_result) == NonDynAlloc) {
    return;
  } else if (!shadow->shadow_value_is_equal(ret_ptr_addr, compare_ptr_addr)) {
    check_memory_leak(analysis_result);
  }
}

void Plsan::check_memory_leak(void *addr) {
  RefCountAnalysis analysis_result = shadow->shadow_analysis(addr);
  // check exception type
  if (std::get<1>(analysis_result) == RefCountZero) {
    handler->exception_check(analysis_result);
  }
}

void Plsan::check_memory_leak(RefCountAnalysis analysis_result) {
  // check exception type
  if (std::get<1>(analysis_result) == RefCountZero) {
    handler->exception_check(analysis_result);
  }
}

void *Plsan::ptr_array_value(void *array_start_addr, size_t index) {
  int64_t *array_addr = (int64_t *)array_start_addr;
  return (void *)(*(array_addr + index));
}

} // namespace __plsan
