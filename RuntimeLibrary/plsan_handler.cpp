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

// =================================================================
// ==<Process Number>==ERROR: PreciseLeakSanitizer: detected memory leaks

// Leak of 10 byte(s) in an object (<address of the object>) allocated from:
//     #1 0x401137 in main /home/hyeyoo/precise-leak-sanitizer/main.c:5
//     #2 0x7fd7dd83feaf in __libc_start_call_main (/lib64/libc.so.6+0x3feaf)

// Last reference to the object (<address of the object>) lost at:
//     #1 0x401150 in main /home/hyeyoo/precise-leak-sanitizer/main.c:7
//     #2 0x7fd7dd83feaf in __libc_start_call_main (/lib64/libc.so.6+0x3feaf)

void PlsanHandler::print_stack_trace(void *alloc_addr, size_t alloc_size,
                                     std::ostream &os) {
  os << "=================================================================\n";

  os << "==<" << getpid()
     << ">==ERROR: PreciseLeakSanitizer: detected memory leaks\n";

  os << "\n";
  os << "Leak of " << alloc_size << " byte(s) in an object (<" << alloc_addr
     << ">) allocated from:\n";
  stack_trace(alloc_addr, os);

  StackTrace st;
  TraceResolver tr;
  st.load_here();
  tr.load_stacktrace(st);

  void *leak_addr = tr.resolve(st[0]).addr;

  os << "\n";
  os << "Last reference to the object (<" << leak_addr << ">) lost at:\n";
  stack_trace(leak_addr, os);
}

void PlsanHandler::stack_trace(void *addr, std::ostream &os) {
  StackTrace st;
  TraceResolver tr;

  addr == NULL ? st.load_here() : st.load_from(addr);
  tr.load_stacktrace(st);

  for (size_t i = 0; i < st.size(); ++i) {
    ResolvedTrace trace = tr.resolve(st[i]);

    os << "    #" << i << " " << trace.addr << " in " << trace.object_function
       << " " << trace.object_filename << ":" << trace.source.line << "\n";
  }
}

} // namespace __plsan
