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

/* finialization routines called after main()*/
__attribute__((destructor)) void __plsan_fini() { delete plsan; }

void __plsan_align(long size) {}

void __plsan_alloc(void *addr, size_t size) {
  /* TODO: initialize references */
}

void __plsan_store(void **lhs, void *rhs) { /* TODO: update references */
}

void __plsan_enter_func() {}

void __plsan_exit_func() {
  /*
   *  TODO: check if
   *  1) the address of lost meomry is written back to memory before
   *     returning the function
   *  2) or the address of a buffer is return value
   */
}

namespace __plsan {

Plsan::Plsan() {
  shadow = new PlsanShadow();
  handler = new PlsanHandler();
}

long Plsan::align_size(long size) { return 0; }

void Plsan::init_refcnt(void *addr, size_t size) {}

void Plsan::reference_count(void **lhs, void *rhs) {}

void Plsan::enter_func() {
  // enter_func
}

void Plsan::exit_func() {
  // exit_func
}

} // namespace __plsan
