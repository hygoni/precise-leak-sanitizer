#include "plsan_handler.h"

namespace __plsan {

void PlsanHandler::exception_check(RefCountAnalysis ref_count_analysis) {
  AddrType addrType;
  ExceptionType exceptionType;
  std::tie(addrType, exceptionType) = ref_count_analysis;
}

} // namespace __plsan
