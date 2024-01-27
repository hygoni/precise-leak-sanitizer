// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +zfh \
// RUN:   -target-feature +zvfh -disable-O0-optnone  \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | \
// RUN:   FileCheck --check-prefix=CHECK-RV64 %s

#include <riscv_vector.h>

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_f32mf2x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } poison, <vscale x 1 x float> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP0]], <vscale x 1 x float> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP1]], <vscale x 1 x float> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP2]], <vscale x 1 x float> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP3]], <vscale x 1 x float> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv1f32.i64(<vscale x 1 x float> [[TMP5]], <vscale x 1 x float> [[TMP6]], <vscale x 1 x float> [[TMP7]], <vscale x 1 x float> [[TMP8]], <vscale x 1 x float> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_f32mf2x5(float *base, ptrdiff_t bstride, vfloat32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_f32m1x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } poison, <vscale x 2 x float> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP0]], <vscale x 2 x float> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP1]], <vscale x 2 x float> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP2]], <vscale x 2 x float> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP3]], <vscale x 2 x float> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv2f32.i64(<vscale x 2 x float> [[TMP5]], <vscale x 2 x float> [[TMP6]], <vscale x 2 x float> [[TMP7]], <vscale x 2 x float> [[TMP8]], <vscale x 2 x float> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_f32m1x5(float *base, ptrdiff_t bstride, vfloat32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_i32mf2x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } poison, <vscale x 1 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP0]], <vscale x 1 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP1]], <vscale x 1 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP2]], <vscale x 1 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP3]], <vscale x 1 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv1i32.i64(<vscale x 1 x i32> [[TMP5]], <vscale x 1 x i32> [[TMP6]], <vscale x 1 x i32> [[TMP7]], <vscale x 1 x i32> [[TMP8]], <vscale x 1 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_i32mf2x5(int32_t *base, ptrdiff_t bstride, vint32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_i32m1x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } poison, <vscale x 2 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]], <vscale x 2 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP1]], <vscale x 2 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP2]], <vscale x 2 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP3]], <vscale x 2 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv2i32.i64(<vscale x 2 x i32> [[TMP5]], <vscale x 2 x i32> [[TMP6]], <vscale x 2 x i32> [[TMP7]], <vscale x 2 x i32> [[TMP8]], <vscale x 2 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_i32m1x5(int32_t *base, ptrdiff_t bstride, vint32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_u32mf2x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } poison, <vscale x 1 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP0]], <vscale x 1 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP1]], <vscale x 1 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP2]], <vscale x 1 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP3]], <vscale x 1 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv1i32.i64(<vscale x 1 x i32> [[TMP5]], <vscale x 1 x i32> [[TMP6]], <vscale x 1 x i32> [[TMP7]], <vscale x 1 x i32> [[TMP8]], <vscale x 1 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_u32mf2x5(uint32_t *base, ptrdiff_t bstride, vuint32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_u32m1x5
// CHECK-RV64-SAME: (ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } poison, <vscale x 2 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]], <vscale x 2 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP1]], <vscale x 2 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP2]], <vscale x 2 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP3]], <vscale x 2 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.nxv2i32.i64(<vscale x 2 x i32> [[TMP5]], <vscale x 2 x i32> [[TMP6]], <vscale x 2 x i32> [[TMP7]], <vscale x 2 x i32> [[TMP8]], <vscale x 2 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_u32m1x5(uint32_t *base, ptrdiff_t bstride, vuint32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_f32mf2x5_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x float> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } poison, <vscale x 1 x float> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP0]], <vscale x 1 x float> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP1]], <vscale x 1 x float> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP2]], <vscale x 1 x float> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP3]], <vscale x 1 x float> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv1f32.i64(<vscale x 1 x float> [[TMP5]], <vscale x 1 x float> [[TMP6]], <vscale x 1 x float> [[TMP7]], <vscale x 1 x float> [[TMP8]], <vscale x 1 x float> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 1 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_f32mf2x5_m(vbool64_t mask, float *base, ptrdiff_t bstride, vfloat32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_f32m1x5_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x float> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } poison, <vscale x 2 x float> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP0]], <vscale x 2 x float> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP1]], <vscale x 2 x float> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP2]], <vscale x 2 x float> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP3]], <vscale x 2 x float> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv2f32.i64(<vscale x 2 x float> [[TMP5]], <vscale x 2 x float> [[TMP6]], <vscale x 2 x float> [[TMP7]], <vscale x 2 x float> [[TMP8]], <vscale x 2 x float> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 2 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_f32m1x5_m(vbool32_t mask, float *base, ptrdiff_t bstride, vfloat32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_i32mf2x5_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } poison, <vscale x 1 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP0]], <vscale x 1 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP1]], <vscale x 1 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP2]], <vscale x 1 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP3]], <vscale x 1 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv1i32.i64(<vscale x 1 x i32> [[TMP5]], <vscale x 1 x i32> [[TMP6]], <vscale x 1 x i32> [[TMP7]], <vscale x 1 x i32> [[TMP8]], <vscale x 1 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 1 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_i32mf2x5_m(vbool64_t mask, int32_t *base, ptrdiff_t bstride, vint32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_i32m1x5_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } poison, <vscale x 2 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]], <vscale x 2 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP1]], <vscale x 2 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP2]], <vscale x 2 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP3]], <vscale x 2 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv2i32.i64(<vscale x 2 x i32> [[TMP5]], <vscale x 2 x i32> [[TMP6]], <vscale x 2 x i32> [[TMP7]], <vscale x 2 x i32> [[TMP8]], <vscale x 2 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 2 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_i32m1x5_m(vbool32_t mask, int32_t *base, ptrdiff_t bstride, vint32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_u32mf2x5_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 1 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } poison, <vscale x 1 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP0]], <vscale x 1 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP1]], <vscale x 1 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP2]], <vscale x 1 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP3]], <vscale x 1 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32>, <vscale x 1 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv1i32.i64(<vscale x 1 x i32> [[TMP5]], <vscale x 1 x i32> [[TMP6]], <vscale x 1 x i32> [[TMP7]], <vscale x 1 x i32> [[TMP8]], <vscale x 1 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 1 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_u32mf2x5_m(vbool64_t mask, uint32_t *base, ptrdiff_t bstride, vuint32mf2x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

// CHECK-RV64-LABEL: define dso_local void @test_vssseg5e32_v_u32m1x5_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], i64 noundef [[BSTRIDE:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE0:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE1:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE2:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE3:%.*]], <vscale x 2 x i32> [[V_TUPLE_COERCE4:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } poison, <vscale x 2 x i32> [[V_TUPLE_COERCE0]], 0
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP0]], <vscale x 2 x i32> [[V_TUPLE_COERCE1]], 1
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP1]], <vscale x 2 x i32> [[V_TUPLE_COERCE2]], 2
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP2]], <vscale x 2 x i32> [[V_TUPLE_COERCE3]], 3
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP3]], <vscale x 2 x i32> [[V_TUPLE_COERCE4]], 4
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 0
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 1
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 2
// CHECK-RV64-NEXT:    [[TMP8:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 3
// CHECK-RV64-NEXT:    [[TMP9:%.*]] = extractvalue { <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32>, <vscale x 2 x i32> } [[TMP4]], 4
// CHECK-RV64-NEXT:    call void @llvm.riscv.vssseg5.mask.nxv2i32.i64(<vscale x 2 x i32> [[TMP5]], <vscale x 2 x i32> [[TMP6]], <vscale x 2 x i32> [[TMP7]], <vscale x 2 x i32> [[TMP8]], <vscale x 2 x i32> [[TMP9]], ptr [[BASE]], i64 [[BSTRIDE]], <vscale x 2 x i1> [[MASK]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret void
//
void test_vssseg5e32_v_u32m1x5_m(vbool32_t mask, uint32_t *base, ptrdiff_t bstride, vuint32m1x5_t v_tuple, size_t vl) {
  return __riscv_vssseg5e32(mask, base, bstride, v_tuple, vl);
}

