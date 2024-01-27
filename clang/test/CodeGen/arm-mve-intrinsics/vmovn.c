// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck --check-prefix=LE %s
// RUN: %clang_cc1 -triple thumbebv8.1m.main-arm-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck --check-prefix=BE %s
// RUN: %clang_cc1 -triple thumbv8.1m.main-none-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck --check-prefix=LE %s
// RUN: %clang_cc1 -triple thumbebv8.1m.main-arm-none-eabi -target-feature +mve -mfloat-abi hard -O0 -disable-O0-optnone -DPOLYMORPHIC -S -emit-llvm -o - %s | opt -S -passes=mem2reg | FileCheck --check-prefix=BE %s

// REQUIRES: aarch64-registered-target || arm-registered-target

#include <arm_mve.h>

// LE-LABEL: @test_vmovnbq_s16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> poison, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
// LE-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[TMP0]] to <8 x i16>
// LE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[B:%.*]], <8 x i16> [[TMP1]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// LE-NEXT:    [[TMP3:%.*]] = trunc <16 x i16> [[TMP2]] to <16 x i8>
// LE-NEXT:    ret <16 x i8> [[TMP3]]
//
// BE-LABEL: @test_vmovnbq_s16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> poison, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.arm.mve.vreinterpretq.v8i16.v16i8(<16 x i8> [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[B:%.*]], <8 x i16> [[TMP1]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// BE-NEXT:    [[TMP3:%.*]] = trunc <16 x i16> [[TMP2]] to <16 x i8>
// BE-NEXT:    ret <16 x i8> [[TMP3]]
//
int8x16_t test_vmovnbq_s16(int8x16_t a, int16x8_t b)
{
#ifdef POLYMORPHIC
    return vmovnbq(a, b);
#else /* POLYMORPHIC */
    return vmovnbq_s16(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_s32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
// LE-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[TMP0]] to <4 x i32>
// LE-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> [[TMP1]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// LE-NEXT:    [[TMP3:%.*]] = trunc <8 x i32> [[TMP2]] to <8 x i16>
// LE-NEXT:    ret <8 x i16> [[TMP3]]
//
// BE-LABEL: @test_vmovnbq_s32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.arm.mve.vreinterpretq.v4i32.v8i16(<8 x i16> [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> [[TMP1]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// BE-NEXT:    [[TMP3:%.*]] = trunc <8 x i32> [[TMP2]] to <8 x i16>
// BE-NEXT:    ret <8 x i16> [[TMP3]]
//
int16x8_t test_vmovnbq_s32(int16x8_t a, int32x4_t b)
{
#ifdef POLYMORPHIC
    return vmovnbq(a, b);
#else /* POLYMORPHIC */
    return vmovnbq_s32(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_u16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> poison, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
// LE-NEXT:    [[TMP1:%.*]] = bitcast <16 x i8> [[TMP0]] to <8 x i16>
// LE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[B:%.*]], <8 x i16> [[TMP1]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// LE-NEXT:    [[TMP3:%.*]] = trunc <16 x i16> [[TMP2]] to <16 x i8>
// LE-NEXT:    ret <16 x i8> [[TMP3]]
//
// BE-LABEL: @test_vmovnbq_u16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[A:%.*]], <16 x i8> poison, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.arm.mve.vreinterpretq.v8i16.v16i8(<16 x i8> [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[B:%.*]], <8 x i16> [[TMP1]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// BE-NEXT:    [[TMP3:%.*]] = trunc <16 x i16> [[TMP2]] to <16 x i8>
// BE-NEXT:    ret <16 x i8> [[TMP3]]
//
uint8x16_t test_vmovnbq_u16(uint8x16_t a, uint16x8_t b)
{
#ifdef POLYMORPHIC
    return vmovnbq(a, b);
#else /* POLYMORPHIC */
    return vmovnbq_u16(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_u32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
// LE-NEXT:    [[TMP1:%.*]] = bitcast <8 x i16> [[TMP0]] to <4 x i32>
// LE-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> [[TMP1]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// LE-NEXT:    [[TMP3:%.*]] = trunc <8 x i32> [[TMP2]] to <8 x i16>
// LE-NEXT:    ret <8 x i16> [[TMP3]]
//
// BE-LABEL: @test_vmovnbq_u32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = shufflevector <8 x i16> [[A:%.*]], <8 x i16> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i32> @llvm.arm.mve.vreinterpretq.v4i32.v8i16(<8 x i16> [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[B:%.*]], <4 x i32> [[TMP1]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// BE-NEXT:    [[TMP3:%.*]] = trunc <8 x i32> [[TMP2]] to <8 x i16>
// BE-NEXT:    ret <8 x i16> [[TMP3]]
//
uint16x8_t test_vmovnbq_u32(uint16x8_t a, uint32x4_t b)
{
#ifdef POLYMORPHIC
    return vmovnbq(a, b);
#else /* POLYMORPHIC */
    return vmovnbq_u32(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_s16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = bitcast <16 x i8> [[A:%.*]] to <8 x i16>
// LE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i16> [[TMP0]], <8 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// LE-NEXT:    [[TMP2:%.*]] = trunc <16 x i16> [[TMP1]] to <16 x i8>
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_s16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = call <8 x i16> @llvm.arm.mve.vreinterpretq.v8i16.v16i8(<16 x i8> [[A:%.*]])
// BE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i16> [[TMP0]], <8 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// BE-NEXT:    [[TMP2:%.*]] = trunc <16 x i16> [[TMP1]] to <16 x i8>
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vmovntq_s16(int8x16_t a, int16x8_t b)
{
#ifdef POLYMORPHIC
    return vmovntq(a, b);
#else /* POLYMORPHIC */
    return vmovntq_s16(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_s32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = bitcast <8 x i16> [[A:%.*]] to <4 x i32>
// LE-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[TMP0]], <4 x i32> [[B:%.*]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// LE-NEXT:    [[TMP2:%.*]] = trunc <8 x i32> [[TMP1]] to <8 x i16>
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_s32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.arm.mve.vreinterpretq.v4i32.v8i16(<8 x i16> [[A:%.*]])
// BE-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[TMP0]], <4 x i32> [[B:%.*]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// BE-NEXT:    [[TMP2:%.*]] = trunc <8 x i32> [[TMP1]] to <8 x i16>
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vmovntq_s32(int16x8_t a, int32x4_t b)
{
#ifdef POLYMORPHIC
    return vmovntq(a, b);
#else /* POLYMORPHIC */
    return vmovntq_s32(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_u16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = bitcast <16 x i8> [[A:%.*]] to <8 x i16>
// LE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i16> [[TMP0]], <8 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// LE-NEXT:    [[TMP2:%.*]] = trunc <16 x i16> [[TMP1]] to <16 x i8>
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_u16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = call <8 x i16> @llvm.arm.mve.vreinterpretq.v8i16.v16i8(<16 x i8> [[A:%.*]])
// BE-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i16> [[TMP0]], <8 x i16> [[B:%.*]], <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
// BE-NEXT:    [[TMP2:%.*]] = trunc <16 x i16> [[TMP1]] to <16 x i8>
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vmovntq_u16(uint8x16_t a, uint16x8_t b)
{
#ifdef POLYMORPHIC
    return vmovntq(a, b);
#else /* POLYMORPHIC */
    return vmovntq_u16(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_u32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = bitcast <8 x i16> [[A:%.*]] to <4 x i32>
// LE-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[TMP0]], <4 x i32> [[B:%.*]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// LE-NEXT:    [[TMP2:%.*]] = trunc <8 x i32> [[TMP1]] to <8 x i16>
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_u32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = call <4 x i32> @llvm.arm.mve.vreinterpretq.v4i32.v8i16(<8 x i16> [[A:%.*]])
// BE-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[TMP0]], <4 x i32> [[B:%.*]], <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
// BE-NEXT:    [[TMP2:%.*]] = trunc <8 x i32> [[TMP1]] to <8 x i16>
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vmovntq_u32(uint16x8_t a, uint32x4_t b)
{
#ifdef POLYMORPHIC
    return vmovntq(a, b);
#else /* POLYMORPHIC */
    return vmovntq_u32(a, b);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_m_s16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 0, <8 x i1> [[TMP1]])
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovnbq_m_s16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 0, <8 x i1> [[TMP1]])
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vmovnbq_m_s16(int8x16_t a, int16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovnbq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovnbq_m_s16(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_m_s32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovnbq_m_s32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vmovnbq_m_s32(int16x8_t a, int32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovnbq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovnbq_m_s32(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_m_u16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 0, <8 x i1> [[TMP1]])
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovnbq_m_u16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 0, <8 x i1> [[TMP1]])
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vmovnbq_m_u16(uint8x16_t a, uint16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovnbq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovnbq_m_u16(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovnbq_m_u32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovnbq_m_u32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 0, <4 x i1> [[TMP1]])
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vmovnbq_m_u32(uint16x8_t a, uint32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovnbq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovnbq_m_u32(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_m_s16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1, <8 x i1> [[TMP1]])
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_m_s16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1, <8 x i1> [[TMP1]])
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
int8x16_t test_vmovntq_m_s16(int8x16_t a, int16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovntq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovntq_m_s16(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_m_s32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_m_s32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
int16x8_t test_vmovntq_m_s32(int16x8_t a, int32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovntq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovntq_m_s32(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_m_u16(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1, <8 x i1> [[TMP1]])
// LE-NEXT:    ret <16 x i8> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_m_u16(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <8 x i1> @llvm.arm.mve.pred.i2v.v8i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <16 x i8> @llvm.arm.mve.vmovn.predicated.v16i8.v8i16.v8i1(<16 x i8> [[A:%.*]], <8 x i16> [[B:%.*]], i32 1, <8 x i1> [[TMP1]])
// BE-NEXT:    ret <16 x i8> [[TMP2]]
//
uint8x16_t test_vmovntq_m_u16(uint8x16_t a, uint16x8_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovntq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovntq_m_u16(a, b, p);
#endif /* POLYMORPHIC */
}

// LE-LABEL: @test_vmovntq_m_u32(
// LE-NEXT:  entry:
// LE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// LE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// LE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// LE-NEXT:    ret <8 x i16> [[TMP2]]
//
// BE-LABEL: @test_vmovntq_m_u32(
// BE-NEXT:  entry:
// BE-NEXT:    [[TMP0:%.*]] = zext i16 [[P:%.*]] to i32
// BE-NEXT:    [[TMP1:%.*]] = call <4 x i1> @llvm.arm.mve.pred.i2v.v4i1(i32 [[TMP0]])
// BE-NEXT:    [[TMP2:%.*]] = call <8 x i16> @llvm.arm.mve.vmovn.predicated.v8i16.v4i32.v4i1(<8 x i16> [[A:%.*]], <4 x i32> [[B:%.*]], i32 1, <4 x i1> [[TMP1]])
// BE-NEXT:    ret <8 x i16> [[TMP2]]
//
uint16x8_t test_vmovntq_m_u32(uint16x8_t a, uint32x4_t b, mve_pred16_t p)
{
#ifdef POLYMORPHIC
    return vmovntq_m(a, b, p);
#else /* POLYMORPHIC */
    return vmovntq_m_u32(a, b, p);
#endif /* POLYMORPHIC */
}
