#include "plsan_shadow.h"

#include <algorithm>
#include <sys/mman.h>

namespace __plsan {

PlsanShadow::PlsanShadow() {
  void *mmap_addr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
                         MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
  if (mmap_addr == MAP_FAILED)
    throw "mmap failed\n";
  else
    shadow_addr = static_cast<ShadowBlockSize *>(mmap_addr);
}

PlsanShadow::~PlsanShadow() { munmap(shadow_addr, MMAP_SIZE); }

void PlsanShadow::alloc_shadow(void *addr, size_t size) {
  ShadowBlockSize *shadow_addr = addr_to_shadow_addr(addr);
  // Have never been initialized
  if (*shadow_addr <= 0) {
    for (int i = 1; i < size / MIN_DYN_ALLOC_SIZE; i++)
      *(shadow_addr + i) = std::max(-i, -SHADOW_INIT_VALUE - 1);
  }
  *shadow_addr = SHADOW_INIT_VALUE;
}

void PlsanShadow::free_shadow(void *addr) {
  ShadowBlockSize *shadow_addr = addr_to_shadow_addr(addr);
  if (*shadow_addr > 0) {
    *shadow_addr = 0;
    while (*(++shadow_addr) < 0)
      *shadow_addr = 0;
  }
}

void PlsanShadow::add_shadow(void *addr, int value) {
  ShadowBlockSize *shadow_addr = addr_to_shadow_addr(addr);
  // Have been initialized
  if (*shadow_addr > 0) {
    *shadow_addr = std::min(*shadow_addr + value, SHADOW_INIT_VALUE);
  }
}

// Shadow class no need to know this logic, but remain this function for
// convenience.
void PlsanShadow::update_shadow(void *lhs, void *rhs) {
  add_shadow(lhs, 1);  // decreasing ref count
  add_shadow(rhs, -1); // increasing ref count
}

bool PlsanShadow::shadow_value_is_equal(void *a, void *b) {
  ShadowBlockSize *a_shadow_addr = addr_to_shadow_addr(a);
  ShadowBlockSize *b_shadow_addr = addr_to_shadow_addr(b);
  return *a_shadow_addr == *b_shadow_addr;
}

RefCountAnalysis PlsanShadow::shadow_analysis(void *addr) {
  ShadowBlockSize *shadow_addr = addr_to_shadow_addr(addr);
  AddrType addr_type;
  ExceptionType exception_type;
  if (*shadow_addr > 0) {
    addr_type = DynAlloc;
    if (*shadow_addr == SHADOW_INIT_VALUE)
      exception_type = RefCountZero;
    else
      exception_type = None;
  } else {
    addr_type = NonDynAlloc;
    exception_type = None;
  }

  RefCountAnalysis result = std::make_tuple(addr_type, exception_type);
  return result;
}

ShadowBlockSize *PlsanShadow::addr_to_shadow_addr(void *addr) {
  intptr_t int_address = reinterpret_cast<intptr_t>(addr);
  ShadowBlockSize *refcnt_addr = shadow_addr + int_address / MIN_DYN_ALLOC_SIZE;
  while (*refcnt_addr < 0)
    refcnt_addr += *refcnt_addr;
  return refcnt_addr;
}

} // namespace __plsan
