#include "plsan_shadow.h"

namespace __plsan {

void PlsanShadow::alloc_shadow(void *addr) {
  ShadowBlockSize *refcnt_addr = addr_to_refcnt(addr);
  *refcnt_addr = SHADOW_INIT_VALUE;
}

void PlsanShadow::free_shadow(void *addr) {
  ShadowBlockSize *refcnt_addr = addr_to_refcnt(addr);
  *refcnt_addr = SHADOW_FREE_VALUE;
}

void PlsanShadow::add_shadow(void *addr, int value) {
  ShadowBlockSize *shadow_addr = addr_to_refcnt(addr);
  // If address is dynamic allocated memory
  if (*shadow_addr > 0) {
    if (*shadow_addr + value < SHADOW_INIT_VALUE)
      *shadow_addr = *shadow_addr + value;
    else
      *shadow_addr = SHADOW_INIT_VALUE;
  }
}

// Shadow class no need to know this logic, but remain this function for
// convenience.
void PlsanShadow::update_shadow(void *lhs, void *rhs) {
  add_shadow(lhs, -1); // Decreasing ref count
  add_shadow(rhs, 1);  // Increasing ref count
}

bool PlsanShadow::shadow_value_is_equal(void *a, void *b) {
  ShadowBlockSize *a_shadow_addr = addr_to_refcnt(a);
  ShadowBlockSize *b_shadow_addr = addr_to_refcnt(b);
  return *a_shadow_addr == *b_shadow_addr;
}

RefCountAnalysis PlsanShadow::shadow_analysis(void *addr) {
  ShadowBlockSize *shadow_addr = addr_to_refcnt(addr);
  AddrType addr_type;
  ExceptionType exception_type;
  // If address is dynamic allocated memory
  if (*shadow_addr > 0) {
    addr_type = DynAlloc;
    // Address value equal to SHADOW_INIT_VALUE means ref count is 0.
    if (*shadow_addr == SHADOW_INIT_VALUE)
      exception_type = RefCountZero;
    else
      exception_type = None;
  } else {
    addr_type = NonDynAlloc;
    exception_type = None;
  }

  RefCountAnalysis result = {addr_type, exception_type};
  return result;
}

ShadowBlockSize *PlsanShadow::addr_to_refcnt(void *addr) { return nullptr; }

bool PlsanShadow::addr_is_dyn_allocated(void *addr) { return true; }

} // namespace __plsan
