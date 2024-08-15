set(PLSAN_LIT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})

set(PLSAN_TESTSUITES)

set(PLSAN_TEST_ARCH ${PLSAN_SUPPORTED_ARCH})
if(APPLE)
  darwin_filter_host_archs(PLSAN_SUPPORTED_ARCH PLSAN_TEST_ARCH)
endif()

foreach(arch ${PLSAN_TEST_ARCH})
  set(PLSAN_TEST_TARGET_ARCH ${arch})
  string(TOLOWER "-${arch}" PLSAN_TEST_CONFIG_SUFFIX)
  get_test_cc_for_arch(${arch} PLSAN_TEST_TARGET_CC LSAN_TEST_TARGET_CFLAGS)
  string(TOUPPER ${arch} ARCH_UPPER_CASE)

  set(PLSAN_LIT_TEST_MODE "Standalone")
  set(CONFIG_NAME ${ARCH_UPPER_CASE}PLsanConfig)
  configure_lit_site_cfg(
    ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
    ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}/lit.site.cfg.py)
  list(APPEND PLSAN_TESTSUITES ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME})

  # list(FIND ASAN_SUPPORTED_ARCH ${arch} _found)
  # if(NOT _found EQUAL -1)
  #   set(CONFIG_NAME ${ARCH_UPPER_CASE}AsanConfig)
  #   set(PLSAN_LIT_TEST_MODE "AddressSanitizer")
  #   configure_lit_site_cfg(
  #     ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
  #     ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}/lit.site.cfg.py)
  #   list(APPEND PLSAN_TESTSUITES ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME})
  # endif()

  # list(FIND HWASAN_SUPPORTED_ARCH ${arch} _found)
  # if(NOT _found EQUAL -1)
  #   set(CONFIG_NAME ${ARCH_UPPER_CASE}HWAsanConfig)
  #   set(PLSAN_LIT_TEST_MODE "HWAddressSanitizer")
  #   configure_lit_site_cfg(
  #     ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
  #     ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME}/lit.site.cfg.py)
  #   list(APPEND PLSAN_TESTSUITES ${CMAKE_CURRENT_BINARY_DIR}/${CONFIG_NAME})
  # endif()
endforeach()

set(PLSAN_TEST_DEPS ${SANITIZER_COMMON_LIT_TEST_DEPS})
if(NOT COMPILER_RT_STANDALONE_BUILD)
  list(APPEND PLSAN_TEST_DEPS plsan)
  append_list_if(COMPILER_RT_HAS_ASAN asan PLSAN_TEST_DEPS)
  append_list_if(COMPILER_RT_HAS_HWASAN hwasan PLSAN_TEST_DEPS)
endif()
add_lit_testsuite(check-plsan "Running the PreciseLeakSanitizer tests"
  ${PLSAN_TESTSUITES}
  DEPENDS ${PLSAN_TEST_DEPS})
set_target_properties(check-plsan PROPERTIES FOLDER "Compiler-RT Misc")
