#include "plsan_shadow.h"

#include <sys/mman.h>

namespace __plsan {

PlsanShadow::PlsanShadow() {
  shadow_addr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE,
                     MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
  if (shadow_addr == MAP_FAILED)
    throw "mmap failed\n";
}

void PlsanShadow::alloc_shadow(void *addr, size_t size) {}

void PlsanShadow::update_reference(void **lhs, void *rhs) {}

void *PlsanShadow::addr_to_shadow_addr(void *addr) { return 0; }

} // namespace __plsan
