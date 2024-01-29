include_directories(..)
include_directories(../../include)

set(PLSAN_SOURCES
    plsan.cpp
    plsan_handler.cpp
    plsan_shadow.cpp
)

set(PLSAN_HEADERS
    plsan.h
    plsan_handler.h
    plsan_shadow.h
    lib/backward.h
)

set(PLSAN_LINK_FLAGS
    ${SANITIZER_COMMON_LINK_FLAGS}
    ${WEAK_SYMBOL_LINNK_FLAGS})
set(PLSAN_LINK_LIBS
#    ${SANITIZER_COMMON_LINK_LIBS}
    ${COMPILER_RT_CXX_LINK_LIBS})
set(PLSAN_CFLAGS
#    ${COMPILER_RT_COMMON_CFLAGS}
    ${COMPILER_RT_CXX_CFLAGS}
#    ${SANITIZER_COMMON_CFLAGS}
    -fexceptions
)

# Allow the PLSAN runtime to reference LLVM headers.
foreach (DIR ${LLVM_INCLUDE_DIR} ${LLVM_MAIN_INCLUDE_DIR})
  list(APPEND PLSAN_CFLAGS -I${DIR})
endforeach()

# PLSAN uses C++ standard library headers.
if (TARGET cxx-headers OR HAVE_LIBCXX)
  set(PLSAN_DEPS cxx-headers)
endif()

if(COMPILER_RT_HAS_PLSAN)
  add_compiler_rt_component(plsan)

  add_compiler_rt_object_libraries(PLSAN_main
    OS ${PLSAN_SUPPORTED_OS}
    ARCHS ${PLSAN_SUPPORTED_ARCH}
    SOURCES ${PLSAN_SOURCES}
    ADDITIONAL_HEADERS ${PLSAN_HEADERS}
    CFLAGS ${PLSAN_CFLAGS}
    DEPS ${PLSAN_DEPS})

  foreach(arch ${PLSAN_SUPPORTED_ARCH})
    add_compiler_rt_runtime(clang_rt.plsan
      STATIC
      OS ${PROFILE_SUPPORTED_OS}
      ARCHS ${arch}
      CFLAGS ${PLSAN_CFLAGS}
      OBJECT_LIBS PLSAN_main
      LINK_FLAGS ${PLSAN_LINK_FLAGS}
      LINK_LIBS ${PLSAN_LINK_LIBS}
      PARENT_TARGET plsan)
  endforeach()
endif()