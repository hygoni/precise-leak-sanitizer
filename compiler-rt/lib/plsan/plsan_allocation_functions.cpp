#include "interception/interception.h"
#include "plsan.h"
#include "plsan_allocator.h"
#include "sanitizer_common/sanitizer_allocator_dlsym.h"
#include "sanitizer_common/sanitizer_allocator_interface.h"
#include "sanitizer_common/sanitizer_mallinfo.h"
#include "sanitizer_common/sanitizer_tls_get_addr.h"

using namespace __plsan;

struct DlsymAlloc : public DlSymAllocator<DlsymAlloc> {
  static bool UseImpl() { return !plsan_inited; }
  static void OnAllocate(const void *ptr, uptr size) {
    // Suppress leaks from dlerror(). Previously dlsym hack on global array was
    // used by leak sanitizer as a root region.
    __lsan_register_root_region(ptr, size);
  }
  static void OnFree(const void *ptr, uptr size) {
    __lsan_unregister_root_region(ptr, size);
  }
};

extern "C" {

SANITIZER_INTERFACE_ATTRIBUTE
int __sanitizer_posix_memalign(void **memptr, uptr alignment, uptr size) {
  GET_MALLOC_STACK_TRACE;
  CHECK_NE(memptr, 0);
  int res = plsan_posix_memalign(memptr, alignment, size, &stack);
  return res;
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_memalign(uptr alignment, uptr size) {
  GET_MALLOC_STACK_TRACE;
  return plsan_memalign(alignment, size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_aligned_alloc(uptr alignment, uptr size) {
  GET_MALLOC_STACK_TRACE;
  return plsan_aligned_alloc(alignment, size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer___libc_memalign(uptr alignment, uptr size) {
  GET_MALLOC_STACK_TRACE;
  void *ptr = plsan_memalign(alignment, size, &stack);
  if (ptr)
    DTLS_on_libc_memalign(ptr, size);
  return ptr;
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_valloc(uptr size) {
  GET_MALLOC_STACK_TRACE;
  return plsan_valloc(size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_pvalloc(uptr size) {
  GET_MALLOC_STACK_TRACE;
  return plsan_pvalloc(size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void __sanitizer_free(void *ptr) {
  if (!ptr)
    return;
  if (DlsymAlloc::PointerIsMine(ptr))
    return DlsymAlloc::Free(ptr);
  plsan_free(ptr);
}

SANITIZER_INTERFACE_ATTRIBUTE
void __sanitizer_cfree(void *ptr) {
  if (!ptr)
    return;
  if (DlsymAlloc::PointerIsMine(ptr))
    return DlsymAlloc::Free(ptr);
  GET_MALLOC_STACK_TRACE;
  plsan_free(ptr);
}

SANITIZER_INTERFACE_ATTRIBUTE
uptr __sanitizer_malloc_usable_size(const void *ptr) {
  return __sanitizer_get_allocated_size(ptr);
}

struct fake_mallinfo {
  int x[10];
};

SANITIZER_INTERFACE_ATTRIBUTE
struct fake_mallinfo __sanitizer_mallinfo() {
  fake_mallinfo sret;
  internal_memset(&sret, 0, sizeof(sret));
  return sret;
}

SANITIZER_INTERFACE_ATTRIBUTE
int __sanitizer_mallopt(int cmd, int value) { return 0; }

SANITIZER_INTERFACE_ATTRIBUTE
void __sanitizer_malloc_stats(void) {
  // FIXME: implement, but don't call REAL(malloc_stats)!
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_calloc(uptr nmemb, uptr size) {
  if (DlsymAlloc::Use())
    return DlsymAlloc::Callocate(nmemb, size);
  GET_MALLOC_STACK_TRACE;
  return plsan_calloc(nmemb, size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_realloc(void *ptr, uptr size) {
  if (DlsymAlloc::Use() || DlsymAlloc::PointerIsMine(ptr))
    return DlsymAlloc::Realloc(ptr, size);
  GET_MALLOC_STACK_TRACE;
  return plsan_realloc(ptr, size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_reallocarray(void *ptr, uptr nmemb, uptr size) {
  GET_MALLOC_STACK_TRACE;
  return plsan_reallocarray(ptr, nmemb, size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
void *__sanitizer_malloc(uptr size) {
  if (UNLIKELY(!plsan_init_is_running))
    ENSURE_PLSAN_INITED();
  if (DlsymAlloc::Use())
    return DlsymAlloc::Allocate(size);
  GET_MALLOC_STACK_TRACE;
  return plsan_malloc(size, &stack);
}

SANITIZER_INTERFACE_ATTRIBUTE
uptr __sanitizer_get_allocated_size(const void *p) {
  return GetMallocUsableSize(p);
}

} // extern "C"

#define INTERCEPTOR_ALIAS(RET, FN, ARGS...)                                    \
  extern "C" SANITIZER_INTERFACE_ATTRIBUTE RET WRAP(FN)(ARGS)                  \
      ALIAS(__sanitizer_##FN);                                                 \
  extern "C" SANITIZER_INTERFACE_ATTRIBUTE SANITIZER_WEAK_ATTRIBUTE RET FN(    \
      ARGS) ALIAS(__sanitizer_##FN)

INTERCEPTOR_ALIAS(int, posix_memalign, void **memptr, SIZE_T alignment,
                  SIZE_T size);
INTERCEPTOR_ALIAS(void *, aligned_alloc, SIZE_T alignment, SIZE_T size);
INTERCEPTOR_ALIAS(void *, __libc_memalign, SIZE_T alignment, SIZE_T size);
INTERCEPTOR_ALIAS(void *, valloc, SIZE_T size);
INTERCEPTOR_ALIAS(void, free, void *ptr);
INTERCEPTOR_ALIAS(uptr, malloc_usable_size, const void *ptr);
INTERCEPTOR_ALIAS(void *, calloc, SIZE_T nmemb, SIZE_T size);
INTERCEPTOR_ALIAS(void *, realloc, void *ptr, SIZE_T size);
INTERCEPTOR_ALIAS(void *, reallocarray, void *ptr, SIZE_T nmemb, SIZE_T size);
INTERCEPTOR_ALIAS(void *, malloc, SIZE_T size);

#if !SANITIZER_FREEBSD && !SANITIZER_NETBSD
INTERCEPTOR_ALIAS(void *, memalign, SIZE_T alignment, SIZE_T size);
INTERCEPTOR_ALIAS(void *, pvalloc, SIZE_T size);
INTERCEPTOR_ALIAS(void, cfree, void *ptr);
INTERCEPTOR_ALIAS(fake_mallinfo, mallinfo);
INTERCEPTOR_ALIAS(int, mallopt, int cmd, int value);
INTERCEPTOR_ALIAS(void, malloc_stats, void);
#endif