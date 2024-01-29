#ifndef PLSAN_SHADOW_H
#define PLSAN_SHADOW_H

#include "plsan_handler.h"

#include <cstddef>
#include <stdint.h>

namespace __plsan {

#define MIN_DYN_ALLOC_SIZE 16
#define SHADOW_INIT_VALUE 127
#define MMAP_SIZE ((1L << 48) / MIN_DYN_ALLOC_SIZE)

using ShadowBlockSize = int8_t; // Shadow memory block size is 1byte.

class PlsanShadow {
public:
  PlsanShadow();
  ~PlsanShadow();
  void alloc_shadow(void *addr, size_t size);
  void free_shadow(void *addr);
  void add_shadow(void *addr, int value);
  void update_shadow(void *lhs, void *rhs);
  bool shadow_value_is_equal(void *a, void *b);
  RefCountAnalysis shadow_analysis(void *addr);

private:
  ShadowBlockSize *shadow_addr;
  ShadowBlockSize *addr_to_shadow_addr(void *addr);
};

} // namespace __plsan

#endif
