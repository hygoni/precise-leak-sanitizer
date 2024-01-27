// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --version 2
// REQUIRES: riscv-registered-target
// RUN: %clang_cc1 -triple riscv64 -target-feature +v -disable-O0-optnone \
// RUN:   -emit-llvm %s -o - | opt -S -passes=mem2reg | \
// RUN:   FileCheck --check-prefix=CHECK-RV64 %s

#include <riscv_vector.h>

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i8> @test_vnsra_wv_i8mf8
// CHECK-RV64-SAME: (<vscale x 1 x i16> [[OP1:%.*]], <vscale x 1 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i8> @llvm.riscv.vnsra.nxv1i8.nxv1i16.nxv1i8.i64(<vscale x 1 x i8> poison, <vscale x 1 x i16> [[OP1]], <vscale x 1 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i8> [[TMP0]]
//
vint8mf8_t test_vnsra_wv_i8mf8(vint16mf4_t op1, vuint8mf8_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i8> @test_vnsra_wx_i8mf8
// CHECK-RV64-SAME: (<vscale x 1 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i8> @llvm.riscv.vnsra.nxv1i8.nxv1i16.i64.i64(<vscale x 1 x i8> poison, <vscale x 1 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i8> [[TMP0]]
//
vint8mf8_t test_vnsra_wx_i8mf8(vint16mf4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i8> @test_vnsra_wv_i8mf4
// CHECK-RV64-SAME: (<vscale x 2 x i16> [[OP1:%.*]], <vscale x 2 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i8> @llvm.riscv.vnsra.nxv2i8.nxv2i16.nxv2i8.i64(<vscale x 2 x i8> poison, <vscale x 2 x i16> [[OP1]], <vscale x 2 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i8> [[TMP0]]
//
vint8mf4_t test_vnsra_wv_i8mf4(vint16mf2_t op1, vuint8mf4_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i8> @test_vnsra_wx_i8mf4
// CHECK-RV64-SAME: (<vscale x 2 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i8> @llvm.riscv.vnsra.nxv2i8.nxv2i16.i64.i64(<vscale x 2 x i8> poison, <vscale x 2 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i8> [[TMP0]]
//
vint8mf4_t test_vnsra_wx_i8mf4(vint16mf2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i8> @test_vnsra_wv_i8mf2
// CHECK-RV64-SAME: (<vscale x 4 x i16> [[OP1:%.*]], <vscale x 4 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i8> @llvm.riscv.vnsra.nxv4i8.nxv4i16.nxv4i8.i64(<vscale x 4 x i8> poison, <vscale x 4 x i16> [[OP1]], <vscale x 4 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i8> [[TMP0]]
//
vint8mf2_t test_vnsra_wv_i8mf2(vint16m1_t op1, vuint8mf2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i8> @test_vnsra_wx_i8mf2
// CHECK-RV64-SAME: (<vscale x 4 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i8> @llvm.riscv.vnsra.nxv4i8.nxv4i16.i64.i64(<vscale x 4 x i8> poison, <vscale x 4 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i8> [[TMP0]]
//
vint8mf2_t test_vnsra_wx_i8mf2(vint16m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i8> @test_vnsra_wv_i8m1
// CHECK-RV64-SAME: (<vscale x 8 x i16> [[OP1:%.*]], <vscale x 8 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i8> @llvm.riscv.vnsra.nxv8i8.nxv8i16.nxv8i8.i64(<vscale x 8 x i8> poison, <vscale x 8 x i16> [[OP1]], <vscale x 8 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i8> [[TMP0]]
//
vint8m1_t test_vnsra_wv_i8m1(vint16m2_t op1, vuint8m1_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i8> @test_vnsra_wx_i8m1
// CHECK-RV64-SAME: (<vscale x 8 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i8> @llvm.riscv.vnsra.nxv8i8.nxv8i16.i64.i64(<vscale x 8 x i8> poison, <vscale x 8 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i8> [[TMP0]]
//
vint8m1_t test_vnsra_wx_i8m1(vint16m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i8> @test_vnsra_wv_i8m2
// CHECK-RV64-SAME: (<vscale x 16 x i16> [[OP1:%.*]], <vscale x 16 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.riscv.vnsra.nxv16i8.nxv16i16.nxv16i8.i64(<vscale x 16 x i8> poison, <vscale x 16 x i16> [[OP1]], <vscale x 16 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
vint8m2_t test_vnsra_wv_i8m2(vint16m4_t op1, vuint8m2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i8> @test_vnsra_wx_i8m2
// CHECK-RV64-SAME: (<vscale x 16 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.riscv.vnsra.nxv16i8.nxv16i16.i64.i64(<vscale x 16 x i8> poison, <vscale x 16 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
vint8m2_t test_vnsra_wx_i8m2(vint16m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 32 x i8> @test_vnsra_wv_i8m4
// CHECK-RV64-SAME: (<vscale x 32 x i16> [[OP1:%.*]], <vscale x 32 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 32 x i8> @llvm.riscv.vnsra.nxv32i8.nxv32i16.nxv32i8.i64(<vscale x 32 x i8> poison, <vscale x 32 x i16> [[OP1]], <vscale x 32 x i8> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 32 x i8> [[TMP0]]
//
vint8m4_t test_vnsra_wv_i8m4(vint16m8_t op1, vuint8m4_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 32 x i8> @test_vnsra_wx_i8m4
// CHECK-RV64-SAME: (<vscale x 32 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 32 x i8> @llvm.riscv.vnsra.nxv32i8.nxv32i16.i64.i64(<vscale x 32 x i8> poison, <vscale x 32 x i16> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 32 x i8> [[TMP0]]
//
vint8m4_t test_vnsra_wx_i8m4(vint16m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i16> @test_vnsra_wv_i16mf4
// CHECK-RV64-SAME: (<vscale x 1 x i32> [[OP1:%.*]], <vscale x 1 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i16> @llvm.riscv.vnsra.nxv1i16.nxv1i32.nxv1i16.i64(<vscale x 1 x i16> poison, <vscale x 1 x i32> [[OP1]], <vscale x 1 x i16> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i16> [[TMP0]]
//
vint16mf4_t test_vnsra_wv_i16mf4(vint32mf2_t op1, vuint16mf4_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i16> @test_vnsra_wx_i16mf4
// CHECK-RV64-SAME: (<vscale x 1 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i16> @llvm.riscv.vnsra.nxv1i16.nxv1i32.i64.i64(<vscale x 1 x i16> poison, <vscale x 1 x i32> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i16> [[TMP0]]
//
vint16mf4_t test_vnsra_wx_i16mf4(vint32mf2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i16> @test_vnsra_wv_i16mf2
// CHECK-RV64-SAME: (<vscale x 2 x i32> [[OP1:%.*]], <vscale x 2 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i16> @llvm.riscv.vnsra.nxv2i16.nxv2i32.nxv2i16.i64(<vscale x 2 x i16> poison, <vscale x 2 x i32> [[OP1]], <vscale x 2 x i16> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i16> [[TMP0]]
//
vint16mf2_t test_vnsra_wv_i16mf2(vint32m1_t op1, vuint16mf2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i16> @test_vnsra_wx_i16mf2
// CHECK-RV64-SAME: (<vscale x 2 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i16> @llvm.riscv.vnsra.nxv2i16.nxv2i32.i64.i64(<vscale x 2 x i16> poison, <vscale x 2 x i32> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i16> [[TMP0]]
//
vint16mf2_t test_vnsra_wx_i16mf2(vint32m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i16> @test_vnsra_wv_i16m1
// CHECK-RV64-SAME: (<vscale x 4 x i32> [[OP1:%.*]], <vscale x 4 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i16> @llvm.riscv.vnsra.nxv4i16.nxv4i32.nxv4i16.i64(<vscale x 4 x i16> poison, <vscale x 4 x i32> [[OP1]], <vscale x 4 x i16> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i16> [[TMP0]]
//
vint16m1_t test_vnsra_wv_i16m1(vint32m2_t op1, vuint16m1_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i16> @test_vnsra_wx_i16m1
// CHECK-RV64-SAME: (<vscale x 4 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i16> @llvm.riscv.vnsra.nxv4i16.nxv4i32.i64.i64(<vscale x 4 x i16> poison, <vscale x 4 x i32> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i16> [[TMP0]]
//
vint16m1_t test_vnsra_wx_i16m1(vint32m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i16> @test_vnsra_wv_i16m2
// CHECK-RV64-SAME: (<vscale x 8 x i32> [[OP1:%.*]], <vscale x 8 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.riscv.vnsra.nxv8i16.nxv8i32.nxv8i16.i64(<vscale x 8 x i16> poison, <vscale x 8 x i32> [[OP1]], <vscale x 8 x i16> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
vint16m2_t test_vnsra_wv_i16m2(vint32m4_t op1, vuint16m2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i16> @test_vnsra_wx_i16m2
// CHECK-RV64-SAME: (<vscale x 8 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.riscv.vnsra.nxv8i16.nxv8i32.i64.i64(<vscale x 8 x i16> poison, <vscale x 8 x i32> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
vint16m2_t test_vnsra_wx_i16m2(vint32m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i16> @test_vnsra_wv_i16m4
// CHECK-RV64-SAME: (<vscale x 16 x i32> [[OP1:%.*]], <vscale x 16 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i16> @llvm.riscv.vnsra.nxv16i16.nxv16i32.nxv16i16.i64(<vscale x 16 x i16> poison, <vscale x 16 x i32> [[OP1]], <vscale x 16 x i16> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 16 x i16> [[TMP0]]
//
vint16m4_t test_vnsra_wv_i16m4(vint32m8_t op1, vuint16m4_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i16> @test_vnsra_wx_i16m4
// CHECK-RV64-SAME: (<vscale x 16 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i16> @llvm.riscv.vnsra.nxv16i16.nxv16i32.i64.i64(<vscale x 16 x i16> poison, <vscale x 16 x i32> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 16 x i16> [[TMP0]]
//
vint16m4_t test_vnsra_wx_i16m4(vint32m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i32> @test_vnsra_wv_i32mf2
// CHECK-RV64-SAME: (<vscale x 1 x i64> [[OP1:%.*]], <vscale x 1 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i32> @llvm.riscv.vnsra.nxv1i32.nxv1i64.nxv1i32.i64(<vscale x 1 x i32> poison, <vscale x 1 x i64> [[OP1]], <vscale x 1 x i32> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i32> [[TMP0]]
//
vint32mf2_t test_vnsra_wv_i32mf2(vint64m1_t op1, vuint32mf2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i32> @test_vnsra_wx_i32mf2
// CHECK-RV64-SAME: (<vscale x 1 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i32> @llvm.riscv.vnsra.nxv1i32.nxv1i64.i64.i64(<vscale x 1 x i32> poison, <vscale x 1 x i64> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 1 x i32> [[TMP0]]
//
vint32mf2_t test_vnsra_wx_i32mf2(vint64m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i32> @test_vnsra_wv_i32m1
// CHECK-RV64-SAME: (<vscale x 2 x i64> [[OP1:%.*]], <vscale x 2 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i32> @llvm.riscv.vnsra.nxv2i32.nxv2i64.nxv2i32.i64(<vscale x 2 x i32> poison, <vscale x 2 x i64> [[OP1]], <vscale x 2 x i32> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i32> [[TMP0]]
//
vint32m1_t test_vnsra_wv_i32m1(vint64m2_t op1, vuint32m1_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i32> @test_vnsra_wx_i32m1
// CHECK-RV64-SAME: (<vscale x 2 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i32> @llvm.riscv.vnsra.nxv2i32.nxv2i64.i64.i64(<vscale x 2 x i32> poison, <vscale x 2 x i64> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 2 x i32> [[TMP0]]
//
vint32m1_t test_vnsra_wx_i32m1(vint64m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i32> @test_vnsra_wv_i32m2
// CHECK-RV64-SAME: (<vscale x 4 x i64> [[OP1:%.*]], <vscale x 4 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.riscv.vnsra.nxv4i32.nxv4i64.nxv4i32.i64(<vscale x 4 x i32> poison, <vscale x 4 x i64> [[OP1]], <vscale x 4 x i32> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
vint32m2_t test_vnsra_wv_i32m2(vint64m4_t op1, vuint32m2_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i32> @test_vnsra_wx_i32m2
// CHECK-RV64-SAME: (<vscale x 4 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.riscv.vnsra.nxv4i32.nxv4i64.i64.i64(<vscale x 4 x i32> poison, <vscale x 4 x i64> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
vint32m2_t test_vnsra_wx_i32m2(vint64m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i32> @test_vnsra_wv_i32m4
// CHECK-RV64-SAME: (<vscale x 8 x i64> [[OP1:%.*]], <vscale x 8 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i32> @llvm.riscv.vnsra.nxv8i32.nxv8i64.nxv8i32.i64(<vscale x 8 x i32> poison, <vscale x 8 x i64> [[OP1]], <vscale x 8 x i32> [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i32> [[TMP0]]
//
vint32m4_t test_vnsra_wv_i32m4(vint64m8_t op1, vuint32m4_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i32> @test_vnsra_wx_i32m4
// CHECK-RV64-SAME: (<vscale x 8 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i32> @llvm.riscv.vnsra.nxv8i32.nxv8i64.i64.i64(<vscale x 8 x i32> poison, <vscale x 8 x i64> [[OP1]], i64 [[SHIFT]], i64 [[VL]])
// CHECK-RV64-NEXT:    ret <vscale x 8 x i32> [[TMP0]]
//
vint32m4_t test_vnsra_wx_i32m4(vint64m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i8> @test_vnsra_wv_i8mf8_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i16> [[OP1:%.*]], <vscale x 1 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i8> @llvm.riscv.vnsra.mask.nxv1i8.nxv1i16.nxv1i8.i64(<vscale x 1 x i8> poison, <vscale x 1 x i16> [[OP1]], <vscale x 1 x i8> [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i8> [[TMP0]]
//
vint8mf8_t test_vnsra_wv_i8mf8_m(vbool64_t mask, vint16mf4_t op1, vuint8mf8_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i8> @test_vnsra_wx_i8mf8_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i8> @llvm.riscv.vnsra.mask.nxv1i8.nxv1i16.i64.i64(<vscale x 1 x i8> poison, <vscale x 1 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i8> [[TMP0]]
//
vint8mf8_t test_vnsra_wx_i8mf8_m(vbool64_t mask, vint16mf4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i8> @test_vnsra_wv_i8mf4_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i16> [[OP1:%.*]], <vscale x 2 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i8> @llvm.riscv.vnsra.mask.nxv2i8.nxv2i16.nxv2i8.i64(<vscale x 2 x i8> poison, <vscale x 2 x i16> [[OP1]], <vscale x 2 x i8> [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i8> [[TMP0]]
//
vint8mf4_t test_vnsra_wv_i8mf4_m(vbool32_t mask, vint16mf2_t op1, vuint8mf4_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i8> @test_vnsra_wx_i8mf4_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i8> @llvm.riscv.vnsra.mask.nxv2i8.nxv2i16.i64.i64(<vscale x 2 x i8> poison, <vscale x 2 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i8> [[TMP0]]
//
vint8mf4_t test_vnsra_wx_i8mf4_m(vbool32_t mask, vint16mf2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i8> @test_vnsra_wv_i8mf2_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i16> [[OP1:%.*]], <vscale x 4 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i8> @llvm.riscv.vnsra.mask.nxv4i8.nxv4i16.nxv4i8.i64(<vscale x 4 x i8> poison, <vscale x 4 x i16> [[OP1]], <vscale x 4 x i8> [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i8> [[TMP0]]
//
vint8mf2_t test_vnsra_wv_i8mf2_m(vbool16_t mask, vint16m1_t op1, vuint8mf2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i8> @test_vnsra_wx_i8mf2_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i8> @llvm.riscv.vnsra.mask.nxv4i8.nxv4i16.i64.i64(<vscale x 4 x i8> poison, <vscale x 4 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i8> [[TMP0]]
//
vint8mf2_t test_vnsra_wx_i8mf2_m(vbool16_t mask, vint16m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i8> @test_vnsra_wv_i8m1_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i16> [[OP1:%.*]], <vscale x 8 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i8> @llvm.riscv.vnsra.mask.nxv8i8.nxv8i16.nxv8i8.i64(<vscale x 8 x i8> poison, <vscale x 8 x i16> [[OP1]], <vscale x 8 x i8> [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i8> [[TMP0]]
//
vint8m1_t test_vnsra_wv_i8m1_m(vbool8_t mask, vint16m2_t op1, vuint8m1_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i8> @test_vnsra_wx_i8m1_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i8> @llvm.riscv.vnsra.mask.nxv8i8.nxv8i16.i64.i64(<vscale x 8 x i8> poison, <vscale x 8 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i8> [[TMP0]]
//
vint8m1_t test_vnsra_wx_i8m1_m(vbool8_t mask, vint16m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i8> @test_vnsra_wv_i8m2_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], <vscale x 16 x i16> [[OP1:%.*]], <vscale x 16 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.riscv.vnsra.mask.nxv16i8.nxv16i16.nxv16i8.i64(<vscale x 16 x i8> poison, <vscale x 16 x i16> [[OP1]], <vscale x 16 x i8> [[SHIFT]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
vint8m2_t test_vnsra_wv_i8m2_m(vbool4_t mask, vint16m4_t op1, vuint8m2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i8> @test_vnsra_wx_i8m2_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], <vscale x 16 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i8> @llvm.riscv.vnsra.mask.nxv16i8.nxv16i16.i64.i64(<vscale x 16 x i8> poison, <vscale x 16 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 16 x i8> [[TMP0]]
//
vint8m2_t test_vnsra_wx_i8m2_m(vbool4_t mask, vint16m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 32 x i8> @test_vnsra_wv_i8m4_m
// CHECK-RV64-SAME: (<vscale x 32 x i1> [[MASK:%.*]], <vscale x 32 x i16> [[OP1:%.*]], <vscale x 32 x i8> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 32 x i8> @llvm.riscv.vnsra.mask.nxv32i8.nxv32i16.nxv32i8.i64(<vscale x 32 x i8> poison, <vscale x 32 x i16> [[OP1]], <vscale x 32 x i8> [[SHIFT]], <vscale x 32 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 32 x i8> [[TMP0]]
//
vint8m4_t test_vnsra_wv_i8m4_m(vbool2_t mask, vint16m8_t op1, vuint8m4_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 32 x i8> @test_vnsra_wx_i8m4_m
// CHECK-RV64-SAME: (<vscale x 32 x i1> [[MASK:%.*]], <vscale x 32 x i16> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 32 x i8> @llvm.riscv.vnsra.mask.nxv32i8.nxv32i16.i64.i64(<vscale x 32 x i8> poison, <vscale x 32 x i16> [[OP1]], i64 [[SHIFT]], <vscale x 32 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 32 x i8> [[TMP0]]
//
vint8m4_t test_vnsra_wx_i8m4_m(vbool2_t mask, vint16m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i16> @test_vnsra_wv_i16mf4_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i32> [[OP1:%.*]], <vscale x 1 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i16> @llvm.riscv.vnsra.mask.nxv1i16.nxv1i32.nxv1i16.i64(<vscale x 1 x i16> poison, <vscale x 1 x i32> [[OP1]], <vscale x 1 x i16> [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i16> [[TMP0]]
//
vint16mf4_t test_vnsra_wv_i16mf4_m(vbool64_t mask, vint32mf2_t op1, vuint16mf4_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i16> @test_vnsra_wx_i16mf4_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i16> @llvm.riscv.vnsra.mask.nxv1i16.nxv1i32.i64.i64(<vscale x 1 x i16> poison, <vscale x 1 x i32> [[OP1]], i64 [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i16> [[TMP0]]
//
vint16mf4_t test_vnsra_wx_i16mf4_m(vbool64_t mask, vint32mf2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i16> @test_vnsra_wv_i16mf2_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i32> [[OP1:%.*]], <vscale x 2 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i16> @llvm.riscv.vnsra.mask.nxv2i16.nxv2i32.nxv2i16.i64(<vscale x 2 x i16> poison, <vscale x 2 x i32> [[OP1]], <vscale x 2 x i16> [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i16> [[TMP0]]
//
vint16mf2_t test_vnsra_wv_i16mf2_m(vbool32_t mask, vint32m1_t op1, vuint16mf2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i16> @test_vnsra_wx_i16mf2_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i16> @llvm.riscv.vnsra.mask.nxv2i16.nxv2i32.i64.i64(<vscale x 2 x i16> poison, <vscale x 2 x i32> [[OP1]], i64 [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i16> [[TMP0]]
//
vint16mf2_t test_vnsra_wx_i16mf2_m(vbool32_t mask, vint32m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i16> @test_vnsra_wv_i16m1_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i32> [[OP1:%.*]], <vscale x 4 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i16> @llvm.riscv.vnsra.mask.nxv4i16.nxv4i32.nxv4i16.i64(<vscale x 4 x i16> poison, <vscale x 4 x i32> [[OP1]], <vscale x 4 x i16> [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i16> [[TMP0]]
//
vint16m1_t test_vnsra_wv_i16m1_m(vbool16_t mask, vint32m2_t op1, vuint16m1_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i16> @test_vnsra_wx_i16m1_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i16> @llvm.riscv.vnsra.mask.nxv4i16.nxv4i32.i64.i64(<vscale x 4 x i16> poison, <vscale x 4 x i32> [[OP1]], i64 [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i16> [[TMP0]]
//
vint16m1_t test_vnsra_wx_i16m1_m(vbool16_t mask, vint32m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i16> @test_vnsra_wv_i16m2_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i32> [[OP1:%.*]], <vscale x 8 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.riscv.vnsra.mask.nxv8i16.nxv8i32.nxv8i16.i64(<vscale x 8 x i16> poison, <vscale x 8 x i32> [[OP1]], <vscale x 8 x i16> [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
vint16m2_t test_vnsra_wv_i16m2_m(vbool8_t mask, vint32m4_t op1, vuint16m2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i16> @test_vnsra_wx_i16m2_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i16> @llvm.riscv.vnsra.mask.nxv8i16.nxv8i32.i64.i64(<vscale x 8 x i16> poison, <vscale x 8 x i32> [[OP1]], i64 [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i16> [[TMP0]]
//
vint16m2_t test_vnsra_wx_i16m2_m(vbool8_t mask, vint32m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i16> @test_vnsra_wv_i16m4_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], <vscale x 16 x i32> [[OP1:%.*]], <vscale x 16 x i16> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i16> @llvm.riscv.vnsra.mask.nxv16i16.nxv16i32.nxv16i16.i64(<vscale x 16 x i16> poison, <vscale x 16 x i32> [[OP1]], <vscale x 16 x i16> [[SHIFT]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 16 x i16> [[TMP0]]
//
vint16m4_t test_vnsra_wv_i16m4_m(vbool4_t mask, vint32m8_t op1, vuint16m4_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 16 x i16> @test_vnsra_wx_i16m4_m
// CHECK-RV64-SAME: (<vscale x 16 x i1> [[MASK:%.*]], <vscale x 16 x i32> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 16 x i16> @llvm.riscv.vnsra.mask.nxv16i16.nxv16i32.i64.i64(<vscale x 16 x i16> poison, <vscale x 16 x i32> [[OP1]], i64 [[SHIFT]], <vscale x 16 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 16 x i16> [[TMP0]]
//
vint16m4_t test_vnsra_wx_i16m4_m(vbool4_t mask, vint32m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i32> @test_vnsra_wv_i32mf2_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i64> [[OP1:%.*]], <vscale x 1 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i32> @llvm.riscv.vnsra.mask.nxv1i32.nxv1i64.nxv1i32.i64(<vscale x 1 x i32> poison, <vscale x 1 x i64> [[OP1]], <vscale x 1 x i32> [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i32> [[TMP0]]
//
vint32mf2_t test_vnsra_wv_i32mf2_m(vbool64_t mask, vint64m1_t op1, vuint32mf2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 1 x i32> @test_vnsra_wx_i32mf2_m
// CHECK-RV64-SAME: (<vscale x 1 x i1> [[MASK:%.*]], <vscale x 1 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 1 x i32> @llvm.riscv.vnsra.mask.nxv1i32.nxv1i64.i64.i64(<vscale x 1 x i32> poison, <vscale x 1 x i64> [[OP1]], i64 [[SHIFT]], <vscale x 1 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 1 x i32> [[TMP0]]
//
vint32mf2_t test_vnsra_wx_i32mf2_m(vbool64_t mask, vint64m1_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i32> @test_vnsra_wv_i32m1_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i64> [[OP1:%.*]], <vscale x 2 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i32> @llvm.riscv.vnsra.mask.nxv2i32.nxv2i64.nxv2i32.i64(<vscale x 2 x i32> poison, <vscale x 2 x i64> [[OP1]], <vscale x 2 x i32> [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i32> [[TMP0]]
//
vint32m1_t test_vnsra_wv_i32m1_m(vbool32_t mask, vint64m2_t op1, vuint32m1_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 2 x i32> @test_vnsra_wx_i32m1_m
// CHECK-RV64-SAME: (<vscale x 2 x i1> [[MASK:%.*]], <vscale x 2 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 2 x i32> @llvm.riscv.vnsra.mask.nxv2i32.nxv2i64.i64.i64(<vscale x 2 x i32> poison, <vscale x 2 x i64> [[OP1]], i64 [[SHIFT]], <vscale x 2 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 2 x i32> [[TMP0]]
//
vint32m1_t test_vnsra_wx_i32m1_m(vbool32_t mask, vint64m2_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i32> @test_vnsra_wv_i32m2_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i64> [[OP1:%.*]], <vscale x 4 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.riscv.vnsra.mask.nxv4i32.nxv4i64.nxv4i32.i64(<vscale x 4 x i32> poison, <vscale x 4 x i64> [[OP1]], <vscale x 4 x i32> [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
vint32m2_t test_vnsra_wv_i32m2_m(vbool16_t mask, vint64m4_t op1, vuint32m2_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 4 x i32> @test_vnsra_wx_i32m2_m
// CHECK-RV64-SAME: (<vscale x 4 x i1> [[MASK:%.*]], <vscale x 4 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 4 x i32> @llvm.riscv.vnsra.mask.nxv4i32.nxv4i64.i64.i64(<vscale x 4 x i32> poison, <vscale x 4 x i64> [[OP1]], i64 [[SHIFT]], <vscale x 4 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
vint32m2_t test_vnsra_wx_i32m2_m(vbool16_t mask, vint64m4_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i32> @test_vnsra_wv_i32m4_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i64> [[OP1:%.*]], <vscale x 8 x i32> [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i32> @llvm.riscv.vnsra.mask.nxv8i32.nxv8i64.nxv8i32.i64(<vscale x 8 x i32> poison, <vscale x 8 x i64> [[OP1]], <vscale x 8 x i32> [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i32> [[TMP0]]
//
vint32m4_t test_vnsra_wv_i32m4_m(vbool8_t mask, vint64m8_t op1, vuint32m4_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

// CHECK-RV64-LABEL: define dso_local <vscale x 8 x i32> @test_vnsra_wx_i32m4_m
// CHECK-RV64-SAME: (<vscale x 8 x i1> [[MASK:%.*]], <vscale x 8 x i64> [[OP1:%.*]], i64 noundef [[SHIFT:%.*]], i64 noundef [[VL:%.*]]) #[[ATTR0]] {
// CHECK-RV64-NEXT:  entry:
// CHECK-RV64-NEXT:    [[TMP0:%.*]] = call <vscale x 8 x i32> @llvm.riscv.vnsra.mask.nxv8i32.nxv8i64.i64.i64(<vscale x 8 x i32> poison, <vscale x 8 x i64> [[OP1]], i64 [[SHIFT]], <vscale x 8 x i1> [[MASK]], i64 [[VL]], i64 3)
// CHECK-RV64-NEXT:    ret <vscale x 8 x i32> [[TMP0]]
//
vint32m4_t test_vnsra_wx_i32m4_m(vbool8_t mask, vint64m8_t op1, size_t shift, size_t vl) {
  return __riscv_vnsra(mask, op1, shift, vl);
}

