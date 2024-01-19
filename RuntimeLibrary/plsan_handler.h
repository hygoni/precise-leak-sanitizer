#ifndef PLSAN_HANDLER_H
#define PLSAN_HANDLER_H

#include <tuple>

namespace __plsan {

enum AddrType { NonDynAlloc, DynAlloc };
enum ExceptionType { None, RefCountZero };
// Something stack trace data structure here.

using RefCountAnalysis = std::tuple<AddrType, ExceptionType /*, StackTrace*/>;

class PlsanHandler {
public:
  void exception_check(RefCountAnalysis ref_count_analysis);
};

} // namespace __plsan

#endif
