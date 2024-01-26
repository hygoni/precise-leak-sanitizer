#include "plsan.h"

#include <cstdarg>
#include <cstddef>
#include <cstring>

__plsan::Plsan *plsan;

namespace {
using LazyCheckInfo = std::tuple</*RefCountZeroAddrs=*/std::vector<void *> *,
                                 /*ProgramCounterAddr=*/void *>;
}

/* Initialization routines called before main() */
__attribute__((constructor)) void __plsan_init() {
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

  // This return will be changed. It have to contain stack trace data.
  // __builtin_return_address(0) will return program counter
  return new std::tuple(ref_count_zero_addrs, __builtin_return_address(0));
}

extern "C" std::tuple<std::vector<void *> *, void *> *
__plsan_free_stack_array(void **arr_start_addr, size_t size, void *ret_addr,
                         bool is_return) {
  std::vector<void *> *ref_count_zero_addrs =
      plsan->free_stack_array(arr_start_addr, size, ret_addr, is_return);

  // This return will be changed. It have to contain stack trace data.
  // __builtin_return_address(0) will return program counter
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

extern "C" void __plsan_memcpy_refcnt(void *dest, void *src, size_t count) {
  plsan->memcpy_refcnt(dest, src, count);
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

size_t Plsan::align_size(size_t size) {
  // Align size with multiples of MIN_DYN_ALLOC_SIZE (defined in plsan_shadow.h)
  return (size + MIN_DYN_ALLOC_SIZE - 1) & ~(MIN_DYN_ALLOC_SIZE - 1);
}

void Plsan::init_refcnt(void *addr, size_t size) {
  // Initialize not only shadow memory but dynamic allocated memory.
  // https://github.com/hygoni/precise-leak-sanitizer/issues/29

  int8_t initialize_value = '\0';
  memset(addr, initialize_value, size);

  shadow->alloc_shadow(addr, size);
}

void Plsan::fini_refcnt(void *addr) { shadow->free_shadow(addr); }

void Plsan::reference_count(void **lhs, void *rhs) {
  // Ref count with Shadow class update_shadow method.
  // When there is update in ref count, we should check there is any memory
  // leak. update_shadow method only decrease lhs's ref count, no problem with
  // checking only lhs.

  shadow->update_shadow(*lhs, rhs);
  check_memory_leak(*lhs);
}

std::vector<void *> *
Plsan::free_stack_variables(void *ret_addr, bool is_return,
                            std::vector<void **> var_addrs) {
  // free_stack_variables method calls above return instruction or some method
  // that pop(restore) stack.
  // 1. If free_stack_variables calls above return instruction, then "is_return"
  //    arg is true and decrease stack variables ref count. We have to check
  //    memory leak in this case. If stack address is same with ret_addr, then
  //    do not check memory leak. (See Documentation 4.3.1)
  // 2. If free_stack_variables calls above some method that restore stack, then
  //    "is_return" arg is false and decrease stack variables ref count. We do
  //    not check memory leak (lazy check). -> There is some cases that return
  //    restored stack value.
  // "var_addrs" arg stores all stack variable addresses.
  // If is_return is falsem, then this method return target address that check
  // leak lazily.

  std::vector<void *> *ref_count_zero_addrs = new std::vector<void *>();

  for (void **var_addr : var_addrs) {
    shadow->add_shadow(*var_addr, 1);
    if (!is_return) {
      RefCountAnalysis analysis_result = shadow->shadow_analysis(*var_addr);
      if (std::get<1>(analysis_result) == RefCountZero)
        ref_count_zero_addrs->push_back(*var_addr);
    } else if (*var_addr != ret_addr) {
      check_memory_leak(*var_addr);
    }
  }

  if (!is_return)
    return ref_count_zero_addrs;
  else
    return nullptr;
}

std::vector<void *> *Plsan::free_stack_array(void **arr_addr, size_t size,
                                             void *ret_addr, bool is_return) {
  // This method almost same with free_stack_variables method, but it is for
  // arrays in stack. "arr_addr" arg has array start address "size" arg has
  // array size

  std::vector<void *> *ref_count_zero_addrs = new std::vector<void *>();

  for (int i = 0; i < size; i++) {
    void *ptr_value = ptr_array_value(arr_addr, i);
    shadow->add_shadow(ptr_value, 1);
    if (!is_return) {
      RefCountAnalysis analysis_result = shadow->shadow_analysis(ptr_value);
      if (std::get<1>(analysis_result) == RefCountZero)
        ref_count_zero_addrs->push_back(ptr_value);
    } else if (ptr_value != ret_addr) {
      check_memory_leak(ptr_value);
    }
  }

  if (!is_return)
    return ref_count_zero_addrs;
  else
    return nullptr;
}

void Plsan::check_returned_or_stored_value(void *ret_ptr_addr,
                                           void *compare_ptr_addr) {
  // This method will be called after function call instruction and above store
  // and return instruction. If some function call return pointer type value, we
  // have to check if return pointer point dyn alloc memory and ref count is 0.
  // For more information, see doumentation 4.3.1 When a function exits

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

void Plsan::memcpy_refcnt(void *dest, void *src, size_t count) {
  for (int i = 0; i < count; i++) {
    void *src_i = plsan->ptr_array_value(src, i);
    void *dest_i = plsan->ptr_array_value(dest, i);
    plsan->reference_count(&dest_i, src_i);
  }
}

void *Plsan::ptr_array_value(void *array_start_addr, size_t index) {
  // void * type cannot add with integer. So casting to int *.
  int64_t *array_addr = (int64_t *)array_start_addr;
  return (void *)(*(array_addr + index));
}

} // namespace __plsan
