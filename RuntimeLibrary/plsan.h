#ifndef PLSAN_H
#define PLSAN_H

#include "plsan_handler.h"
#include "plsan_shadow.h"
#include "plsan_storage.h"

namespace __plsan {

class Plsan {
public:
  Plsan();
  // long align_size(long size);

  void enter_func();
  void exit_func();

private:
  PlsanShadow *shadow;
  PlsanStorage *storage;
  PlsanHandler *handler;
};

} // namespace __plsan

#endif
