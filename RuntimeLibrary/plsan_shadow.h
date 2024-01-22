#ifndef PLSAN_SHADOW_H
#define PLSAN_SHADOW_H

#include <cstddef>

namespace __plsan {

#define MIN_DYN_ALLOC_SIZE 16
#define MMAP_SIZE ((1L << 48) / MIN_DYN_ALLOC_SIZE)

class PlsanShadow {
public:
  PlsanShadow();
  ~PlsanShadow();
  void alloc_shadow(void *addr, size_t size);
  void update_reference(void **lhs, void *rhs);

private:
  void *shadow_addr;
  void *addr_to_shadow_addr(void *addr);
};

} // namespace __plsan

#endif
