#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_handler.h"
#include "plsan_shadow.h"

namespace __plsan {

class Plsan {
public:
  Plsan();

  // Instrumentation function
  long align_size(long size);
  void init_refcnt(void *addr, size_t size);
  void reference_count(void **lhs, void *rhs);
  void enter_func();
  void exit_func();

private:
  PlsanShadow *shadow;
  PlsanHandler *handler;
};

} // namespace __plsan

#endif
