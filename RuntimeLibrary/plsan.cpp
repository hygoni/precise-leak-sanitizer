/* READ THIS:
 * The name of a function here must start with double underscores to avoid
 * collisons with the program. For example: __foo(), __bar(), etc.
 */

#include "plsan.h"

#include <cstdarg>
#include <cstddef>

__plsan::Plsan *plsan;

namespace {
using LazyCheckInfo = std::tuple</*RefCountZeroAddrs=*/std::vector<void *> *,
                                 /*ProgramCounterAddr=*/void *>;
}

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

extern "C" std::tuple<std::vector<void *> *, void *> *
__plsan_free_stack_variables(size_t count, void *ret_addr, int is_return, ...) {
  // We cannot use C++ style variable arguments, because extern keyword for
  // compatiable with C.

  std::vector<void **> args;

  va_list var_addrs;
  va_start(var_addrs, is_return);

  for (int i = 0; i < count; i++)
    args.push_back(va_arg(var_addrs, void **));

  va_end(var_addrs);

  std::vector<void *> *ref_count_zero_addrs =
      plsan->free_stack_variables(ret_addr, is_return, args);
  return new std::tuple(ref_count_zero_addrs, __builtin_return_address(0));
}

extern "C" std::tuple<std::vector<void *> *, void *> *
__plsan_free_stack_array(void **arr_start_addr, size_t size, void *ret_addr,
                         bool is_return) {
  std::vector<void *> *ref_count_zero_addrs =
      plsan->free_stack_array(arr_start_addr, size, ret_addr, is_return);
  return new std::tuple(ref_count_zero_addrs, __builtin_return_address(0));
}

extern "C" void __plsan_lazy_check(LazyCheckInfo *lazy_check_info,
                                   void *ret_addr) {
  std::vector<void *> *lazy_check_addr_list = std::get<0>(*lazy_check_info);
  void *program_counter = std::get<1>(*lazy_check_info);

  for (void *lazy_check_addr : *lazy_check_addr_list) {
    if (lazy_check_addr != ret_addr)
      throw ret_addr;
  }

  delete lazy_check_addr_list;
  delete lazy_check_info;
}

extern "C" void __plsan_check_returned_or_stored_value(void *ret_ptr_addr,
                                                       void *compare_ptr_addr) {
  plsan->check_returned_or_stored_value(ret_ptr_addr, compare_ptr_addr);
}

extern "C" void __plsan_check_memory_leak(void *addr) {
  plsan->check_memory_leak(addr);
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

std::vector<void *> *
Plsan::free_stack_variables(void *ret_addr, bool is_return,
                            std::vector<void **> var_addrs) {
  return NULL;
}

std::vector<void *> *Plsan::free_stack_array(void **arr_addr, size_t size,
                                             void *ret_addr, bool is_return) {
  return NULL;
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
