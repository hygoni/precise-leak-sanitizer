// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// REQUIRES: aarch64-registered-target

// RUN: %clang_cc1 -target-feature +i8mm -triple aarch64-none-linux-gnu -target-feature +sve -S -disable-O0-optnone -Werror -Wall -emit-llvm -o - %s | opt -S -passes=mem2reg,tailcallelim | FileCheck %s
// RUN: %clang_cc1 -target-feature +i8mm -triple aarch64-none-linux-gnu -target-feature +sve -S -disable-O0-optnone -Werror -Wall -emit-llvm -o - -x c++ %s | opt -S -passes=mem2reg,tailcallelim | FileCheck %s -check-prefix=CPP-CHECK
// RUN: %clang_cc1 -target-feature +i8mm -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve -S -disable-O0-optnone -Werror -Wall -emit-llvm -o - %s | opt -S -passes=mem2reg,tailcallelim | FileCheck %s
// RUN: %clang_cc1 -target-feature +i8mm -DSVE_OVERLOADED_FORMS -triple aarch64-none-linux-gnu -target-feature +sve -S -disable-O0-optnone -Werror -Wall -emit-llvm -o - -x c++ %s | opt -S -passes=mem2reg,tailcallelim | FileCheck %s -check-prefix=CPP-CHECK

#include <arm_sve.h>

#ifdef SVE_OVERLOADED_FORMS
// A simple used,unused... macro, long enough to represent any SVE builtin.
#define SVE_ACLE_FUNC(A1, A2_UNUSED, A3, A4_UNUSED) A1##A3
#else
#define SVE_ACLE_FUNC(A1, A2, A3, A4) A1##A2##A3##A4
#endif

// CHECK-LABEL: @test_svusdot_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]])
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z16test_svusdot_s32u11__SVInt32_tu11__SVUint8_tu10__SVInt8_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]])
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_s32(svint32_t x, svuint8_t y, svint8_t z) {
  return SVE_ACLE_FUNC(svusdot, _s32, , )(x, y, z);
}

// CHECK-LABEL: @test_svusdot_n_s32(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 16 x i8> poison, i8 [[Z:%.*]], i64 0
// CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 16 x i8> [[DOTSPLATINSERT]], <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[DOTSPLAT]])
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z18test_svusdot_n_s32u11__SVInt32_tu11__SVUint8_ta(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <vscale x 16 x i8> poison, i8 [[Z:%.*]], i64 0
// CPP-CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <vscale x 16 x i8> [[DOTSPLATINSERT]], <vscale x 16 x i8> poison, <vscale x 16 x i32> zeroinitializer
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[DOTSPLAT]])
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_n_s32(svint32_t x, svuint8_t y, int8_t z) {
  return SVE_ACLE_FUNC(svusdot, _n_s32, , )(x, y, z);
}

// CHECK-LABEL: @test_svusdot_lane_s32_0(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 0)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z23test_svusdot_lane_s32_0u11__SVInt32_tu11__SVUint8_tu10__SVInt8_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 0)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_lane_s32_0(svint32_t x, svuint8_t y, svint8_t z) {
  return SVE_ACLE_FUNC(svusdot_lane, _s32, , )(x, y, z, 0);
}

// CHECK-LABEL: @test_svusdot_lane_s32_1(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 1)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z23test_svusdot_lane_s32_1u11__SVInt32_tu11__SVUint8_tu10__SVInt8_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 1)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_lane_s32_1(svint32_t x, svuint8_t y, svint8_t z) {
  return SVE_ACLE_FUNC(svusdot_lane, _s32, , )(x, y, z, 1);
}

// CHECK-LABEL: @test_svusdot_lane_s32_2(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 2)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z23test_svusdot_lane_s32_2u11__SVInt32_tu11__SVUint8_tu10__SVInt8_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 2)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_lane_s32_2(svint32_t x, svuint8_t y, svint8_t z) {
  return SVE_ACLE_FUNC(svusdot_lane, _s32, , )(x, y, z, 2);
}

// CHECK-LABEL: @test_svusdot_lane_s32_3(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 3)
// CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
// CPP-CHECK-LABEL: @_Z23test_svusdot_lane_s32_3u11__SVInt32_tu11__SVUint8_tu10__SVInt8_t(
// CPP-CHECK-NEXT:  entry:
// CPP-CHECK-NEXT:    [[TMP0:%.*]] = tail call <vscale x 4 x i32> @llvm.aarch64.sve.usdot.lane.nxv4i32(<vscale x 4 x i32> [[X:%.*]], <vscale x 16 x i8> [[Y:%.*]], <vscale x 16 x i8> [[Z:%.*]], i32 3)
// CPP-CHECK-NEXT:    ret <vscale x 4 x i32> [[TMP0]]
//
svint32_t test_svusdot_lane_s32_3(svint32_t x, svuint8_t y, svint8_t z) {
  return SVE_ACLE_FUNC(svusdot_lane, _s32, , )(x, y, z, 3);
}
