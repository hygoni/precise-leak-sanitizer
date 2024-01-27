// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -target-feature +zfh \
// RUN:   -target-feature +zvfh -disable-O0-optnone  \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | \
// RUN:   FileCheck --check-prefix=CHECK-RV64 %s

#include <riscv_vector.h>

// CHECK-RV64-LABEL: define dso_local { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } @test_vlseg3e8ff_v_i8mf8x3_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv1i8.i64(<vscale x 1 x i8> poison, <vscale x 1 x i8> poison, <vscale x 1 x i8> poison, ptr [[BASE]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } poison, <vscale x 1 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP2]], <vscale x 1 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP4]], <vscale x 1 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP6]]
//
vint8mf8x3_t test_vlseg3e8ff_v_i8mf8x3_m(vbool64_t mask, const int8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } @test_vlseg3e8ff_v_i8mf4x3_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv2i8.i64(<vscale x 2 x i8> poison, <vscale x 2 x i8> poison, <vscale x 2 x i8> poison, ptr [[BASE]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } poison, <vscale x 2 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP2]], <vscale x 2 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP4]], <vscale x 2 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP6]]
//
vint8mf4x3_t test_vlseg3e8ff_v_i8mf4x3_m(vbool32_t mask, const int8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } @test_vlseg3e8ff_v_i8mf2x3_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv4i8.i64(<vscale x 4 x i8> poison, <vscale x 4 x i8> poison, <vscale x 4 x i8> poison, ptr [[BASE]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } poison, <vscale x 4 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP2]], <vscale x 4 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP4]], <vscale x 4 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP6]]
//
vint8mf2x3_t test_vlseg3e8ff_v_i8mf2x3_m(vbool16_t mask, const int8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } @test_vlseg3e8ff_v_i8m1x3_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv8i8.i64(<vscale x 8 x i8> poison, <vscale x 8 x i8> poison, <vscale x 8 x i8> poison, ptr [[BASE]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } poison, <vscale x 8 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP2]], <vscale x 8 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP4]], <vscale x 8 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP6]]
//
vint8m1x3_t test_vlseg3e8ff_v_i8m1x3_m(vbool8_t mask, const int8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } @test_vlseg3e8ff_v_i8m2x3_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv16i8.i64(<vscale x 16 x i8> poison, <vscale x 16 x i8> poison, <vscale x 16 x i8> poison, ptr [[BASE]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } poison, <vscale x 16 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP2]], <vscale x 16 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP4]], <vscale x 16 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP6]]
//
vint8m2x3_t test_vlseg3e8ff_v_i8m2x3_m(vbool4_t mask, const int8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } @test_vlseg3e8ff_v_u8mf8x3_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv1i8.i64(<vscale x 1 x i8> poison, <vscale x 1 x i8> poison, <vscale x 1 x i8> poison, ptr [[BASE]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } poison, <vscale x 1 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP2]], <vscale x 1 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP4]], <vscale x 1 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 1 x i8>, <vscale x 1 x i8>, <vscale x 1 x i8> } [[TMP6]]
//
vuint8mf8x3_t test_vlseg3e8ff_v_u8mf8x3_m(vbool64_t mask, const uint8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } @test_vlseg3e8ff_v_u8mf4x3_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv2i8.i64(<vscale x 2 x i8> poison, <vscale x 2 x i8> poison, <vscale x 2 x i8> poison, ptr [[BASE]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } poison, <vscale x 2 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP2]], <vscale x 2 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP4]], <vscale x 2 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 2 x i8>, <vscale x 2 x i8>, <vscale x 2 x i8> } [[TMP6]]
//
vuint8mf4x3_t test_vlseg3e8ff_v_u8mf4x3_m(vbool32_t mask, const uint8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } @test_vlseg3e8ff_v_u8mf2x3_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv4i8.i64(<vscale x 4 x i8> poison, <vscale x 4 x i8> poison, <vscale x 4 x i8> poison, ptr [[BASE]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } poison, <vscale x 4 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP2]], <vscale x 4 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP4]], <vscale x 4 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 4 x i8>, <vscale x 4 x i8>, <vscale x 4 x i8> } [[TMP6]]
//
vuint8mf2x3_t test_vlseg3e8ff_v_u8mf2x3_m(vbool16_t mask, const uint8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } @test_vlseg3e8ff_v_u8m1x3_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv8i8.i64(<vscale x 8 x i8> poison, <vscale x 8 x i8> poison, <vscale x 8 x i8> poison, ptr [[BASE]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } poison, <vscale x 8 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP2]], <vscale x 8 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP4]], <vscale x 8 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 8 x i8>, <vscale x 8 x i8>, <vscale x 8 x i8> } [[TMP6]]
//
vuint8m1x3_t test_vlseg3e8ff_v_u8m1x3_m(vbool8_t mask, const uint8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

// CHECK-RV64-LABEL: define dso_local { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } @test_vlseg3e8ff_v_u8m2x3_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], ptr noundef [[BASE:%.*]], ptr noundef [[NEW_VL:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } @llvm.riscv.vlseg3ff.mask.nxv16i8.i64(<vscale x 16 x i8> poison, <vscale x 16 x i8> poison, <vscale x 16 x i8> poison, ptr [[BASE]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    [[TMP1:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 0
// CHECK-RV64-NEXT:    [[TMP2:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } poison, <vscale x 16 x i8> [[TMP1]], 0
// CHECK-RV64-NEXT:    [[TMP3:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 1
// CHECK-RV64-NEXT:    [[TMP4:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP2]], <vscale x 16 x i8> [[TMP3]], 1
// CHECK-RV64-NEXT:    [[TMP5:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 2
// CHECK-RV64-NEXT:    [[TMP6:%.*]] = insertvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP4]], <vscale x 16 x i8> [[TMP5]], 2
// CHECK-RV64-NEXT:    [[TMP7:%.*]] = extractvalue { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8>, i64 } [[TMP0]], 3
// CHECK-RV64-NEXT:    store i64 [[TMP7]], ptr [[NEW_VL]], align 8
// CHECK-RV64-NEXT:    ret { <vscale x 16 x i8>, <vscale x 16 x i8>, <vscale x 16 x i8> } [[TMP6]]
//
vuint8m2x3_t test_vlseg3e8ff_v_u8m2x3_m(vbool4_t mask, const uint8_t *base, size_t *new_vl, size_t vl) {
  return __riscv_vlseg3e8ff(mask, base, new_vl, vl);
}

