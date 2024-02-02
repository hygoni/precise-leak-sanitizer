#ifndef PLSAN_HANDLER_H
#define PLSAN_HANDLER_H

#include "lsan/lsan_common.h"

#include "lib/backward.h"

using namespace backward;

namespace __plsan {

enum AddrType { NonDynAlloc, DynAlloc };
enum ExceptionType { None, RefCountZero };
// Something stack trace data structure here.

struct RefCountAnalysis {
  AddrType addrTy;
  ExceptionType exceptTy;
};

class PlsanHandler {
public:
  void exception_check(RefCountAnalysis ref_count_analysis);
  void print_stack_trace(void *alloc_addr, size_t alloc_size, std::ostream &os);
  void stack_trace(void *addr, std::ostream &os);
};

} // namespace __plsan

#endif
