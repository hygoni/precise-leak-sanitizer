#include "plsan_handler.h"
#include <cstdlib>

namespace __plsan {

void PlsanHandler::exception_check(RefCountAnalysis ref_count_analysis) {
  AddrType addrType;
  ExceptionType exceptionType;
  std::tie(addrType, exceptionType) = ref_count_analysis;
  print_stack_trace(NULL, 0, std::cerr);
  exit(EXIT_FAILURE);
}

} // namespace __plsan
