; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=x86_64-pc-linux -mattr=+avx2 -interleaved-access -S | FileCheck %s
; RUN: opt < %s -mtriple=x86_64-pc-linux -mattr=+avx512f -mattr=+avx512bw -mattr=+avx512vl -interleaved-access -S | FileCheck %s

define <32 x i8> @interleaved_load_vf32_i8_stride3(ptr %ptr){
; CHECK-LABEL: @interleaved_load_vf32_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <16 x i8>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <16 x i8>, ptr [[TMP1]], align 128
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <16 x i8>, ptr [[TMP3]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <16 x i8>, ptr [[TMP5]], align 16
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = load <16 x i8>, ptr [[TMP7]], align 16
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 4
; CHECK-NEXT:    [[TMP10:%.*]] = load <16 x i8>, ptr [[TMP9]], align 16
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 5
; CHECK-NEXT:    [[TMP12:%.*]] = load <16 x i8>, ptr [[TMP11]], align 16
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <16 x i8> [[TMP2]], <16 x i8> [[TMP8]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <16 x i8> [[TMP4]], <16 x i8> [[TMP10]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <16 x i8> [[TMP6]], <16 x i8> [[TMP12]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <32 x i8> [[TMP13]], <32 x i8> poison, <32 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29>
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <32 x i8> [[TMP14]], <32 x i8> poison, <32 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29>
; CHECK-NEXT:    [[TMP18:%.*]] = shufflevector <32 x i8> [[TMP15]], <32 x i8> poison, <32 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29>
; CHECK-NEXT:    [[TMP19:%.*]] = shufflevector <32 x i8> [[TMP18]], <32 x i8> [[TMP16]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP20:%.*]] = shufflevector <32 x i8> [[TMP16]], <32 x i8> [[TMP17]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP21:%.*]] = shufflevector <32 x i8> [[TMP17]], <32 x i8> [[TMP18]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP22:%.*]] = shufflevector <32 x i8> [[TMP20]], <32 x i8> [[TMP19]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP23:%.*]] = shufflevector <32 x i8> [[TMP21]], <32 x i8> [[TMP20]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP24:%.*]] = shufflevector <32 x i8> [[TMP19]], <32 x i8> [[TMP21]], <32 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 27, i32 28, i32 29, i32 30, i32 31, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58>
; CHECK-NEXT:    [[TMP25:%.*]] = shufflevector <32 x i8> [[TMP23]], <32 x i8> poison, <32 x i32> <i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20>
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <32 x i8> [[TMP22]], <32 x i8> poison, <32 x i32> <i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25>
; CHECK-NEXT:    [[ADD1:%.*]] = add <32 x i8> [[TMP26]], [[TMP25]]
; CHECK-NEXT:    [[ADD2:%.*]] = add <32 x i8> [[TMP24]], [[ADD1]]
; CHECK-NEXT:    ret <32 x i8> [[ADD2]]
;
  %wide.vec = load <96 x i8>, ptr %ptr
  %v1 = shufflevector <96 x i8> %wide.vec, <96 x i8> undef,<32 x i32> <i32 0,i32 3,i32 6,i32 9,i32 12,i32 15,i32 18,i32 21,i32 24,i32 27,i32 30,i32 33,i32 36,i32 39,i32 42,i32 45,i32 48,i32 51,i32 54,i32 57,i32 60,i32 63,i32 66,i32 69,i32 72,i32 75,i32 78,i32 81,i32 84,i32 87,i32 90,i32 93>
  %v2 = shufflevector <96 x i8> %wide.vec, <96 x i8> undef,<32 x i32> <i32 1,i32 4,i32 7,i32 10,i32 13,i32 16,i32 19,i32 22,i32 25,i32 28,i32 31,i32 34,i32 37,i32 40,i32 43,i32 46,i32 49,i32 52,i32 55,i32 58,i32 61,i32 64,i32 67,i32 70,i32 73,i32 76,i32 79,i32 82,i32 85,i32 88,i32 91,i32 94>
  %v3 = shufflevector <96 x i8> %wide.vec, <96 x i8> undef,<32 x i32> <i32 2,i32 5,i32 8,i32 11,i32 14,i32 17,i32 20,i32 23,i32 26,i32 29,i32 32,i32 35,i32 38,i32 41,i32 44,i32 47,i32 50,i32 53,i32 56,i32 59,i32 62,i32 65,i32 68,i32 71,i32 74,i32 77,i32 80,i32 83,i32 86,i32 89,i32 92,i32 95>
  %add1 = add <32 x i8> %v1, %v2
  %add2 = add <32 x i8> %v3, %add1
  ret <32 x i8> %add2
}

define <16 x i8> @interleaved_load_vf16_i8_stride3(ptr %ptr){
; CHECK-LABEL: @interleaved_load_vf16_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <16 x i8>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <16 x i8>, ptr [[TMP1]], align 64
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <16 x i8>, ptr [[TMP3]], align 16
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <16 x i8>, ptr [[TMP5]], align 16
; CHECK-NEXT:    [[TMP7:%.*]] = shufflevector <16 x i8> [[TMP2]], <16 x i8> poison, <16 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13>
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <16 x i8> [[TMP4]], <16 x i8> poison, <16 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13>
; CHECK-NEXT:    [[TMP9:%.*]] = shufflevector <16 x i8> [[TMP6]], <16 x i8> poison, <16 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13>
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <16 x i8> [[TMP9]], <16 x i8> [[TMP7]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP11:%.*]] = shufflevector <16 x i8> [[TMP7]], <16 x i8> [[TMP8]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP12:%.*]] = shufflevector <16 x i8> [[TMP8]], <16 x i8> [[TMP9]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP13:%.*]] = shufflevector <16 x i8> [[TMP11]], <16 x i8> [[TMP10]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP14:%.*]] = shufflevector <16 x i8> [[TMP12]], <16 x i8> [[TMP11]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP15:%.*]] = shufflevector <16 x i8> [[TMP10]], <16 x i8> [[TMP12]], <16 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26>
; CHECK-NEXT:    [[TMP16:%.*]] = shufflevector <16 x i8> [[TMP14]], <16 x i8> poison, <16 x i32> <i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4>
; CHECK-NEXT:    [[TMP17:%.*]] = shufflevector <16 x i8> [[TMP13]], <16 x i8> poison, <16 x i32> <i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9>
; CHECK-NEXT:    [[ADD1:%.*]] = add <16 x i8> [[TMP17]], [[TMP16]]
; CHECK-NEXT:    [[ADD2:%.*]] = add <16 x i8> [[TMP15]], [[ADD1]]
; CHECK-NEXT:    ret <16 x i8> [[ADD2]]
;
  %wide.vec = load <48 x i8>, ptr %ptr
  %v1 = shufflevector <48 x i8> %wide.vec, <48 x i8> undef,<16 x i32> <i32 0,i32 3,i32 6,i32 9,i32 12,i32 15,i32 18,i32 21,i32 24,i32 27,i32 30,i32 33,i32 36,i32 39,i32 42 ,i32 45>
  %v2 = shufflevector <48 x i8> %wide.vec, <48 x i8> undef,<16 x i32> <i32 1,i32 4,i32 7,i32 10,i32 13,i32 16,i32 19,i32 22,i32 25,i32 28,i32 31,i32 34,i32 37,i32 40,i32 43,i32 46>
  %v3 = shufflevector <48 x i8> %wide.vec, <48 x i8> undef,<16 x i32> <i32 2,i32 5,i32 8,i32 11,i32 14,i32 17,i32 20,i32 23,i32 26,i32 29,i32 32,i32 35,i32 38,i32 41,i32 44,i32 47>
  %add1 = add <16 x i8> %v1, %v2
  %add2 = add <16 x i8> %v3, %add1
  ret <16 x i8> %add2
}

define <8 x i8> @interleaved_load_vf8_i8_stride3(ptr %ptr){
; CHECK-LABEL: @interleaved_load_vf8_i8_stride3(
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <24 x i8>, ptr [[PTR:%.*]], align 32
; CHECK-NEXT:    [[V1:%.*]] = shufflevector <24 x i8> [[WIDE_VEC]], <24 x i8> undef, <8 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 18, i32 21>
; CHECK-NEXT:    [[V2:%.*]] = shufflevector <24 x i8> [[WIDE_VEC]], <24 x i8> undef, <8 x i32> <i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22>
; CHECK-NEXT:    [[V3:%.*]] = shufflevector <24 x i8> [[WIDE_VEC]], <24 x i8> undef, <8 x i32> <i32 2, i32 5, i32 8, i32 11, i32 14, i32 17, i32 20, i32 23>
; CHECK-NEXT:    [[ADD1:%.*]] = add <8 x i8> [[V1]], [[V2]]
; CHECK-NEXT:    [[ADD2:%.*]] = add <8 x i8> [[V3]], [[ADD1]]
; CHECK-NEXT:    ret <8 x i8> [[ADD2]]
;
  %wide.vec = load <24 x i8>, ptr %ptr
  %v1 = shufflevector <24 x i8> %wide.vec, <24 x i8> undef,<8 x i32> <i32 0,i32 3,i32 6,i32  9,i32 12,i32 15,i32 18,i32 21>
  %v2 = shufflevector <24 x i8> %wide.vec, <24 x i8> undef,<8 x i32> <i32 1,i32 4,i32 7,i32 10,i32 13,i32 16,i32 19,i32 22>
  %v3 = shufflevector <24 x i8> %wide.vec, <24 x i8> undef,<8 x i32> <i32 2,i32 5,i32 8,i32 11,i32 14,i32 17,i32 20,i32 23>
  %add1 = add <8 x i8> %v1, %v2
  %add2 = add <8 x i8> %v3, %add1
  ret <8 x i8> %add2
}


define <64 x i8> @interleaved_load_vf64_i8_stride3(ptr %ptr){
; CHECK-LABEL: @interleaved_load_vf64_i8_stride3(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr <16 x i8>, ptr [[PTR:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = load <16 x i8>, ptr [[TMP1]], align 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 1
; CHECK-NEXT:    [[TMP4:%.*]] = load <16 x i8>, ptr [[TMP3]], align 1
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 2
; CHECK-NEXT:    [[TMP6:%.*]] = load <16 x i8>, ptr [[TMP5]], align 1
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 3
; CHECK-NEXT:    [[TMP8:%.*]] = load <16 x i8>, ptr [[TMP7]], align 1
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 4
; CHECK-NEXT:    [[TMP10:%.*]] = load <16 x i8>, ptr [[TMP9]], align 1
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 5
; CHECK-NEXT:    [[TMP12:%.*]] = load <16 x i8>, ptr [[TMP11]], align 1
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 6
; CHECK-NEXT:    [[TMP14:%.*]] = load <16 x i8>, ptr [[TMP13]], align 1
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 7
; CHECK-NEXT:    [[TMP16:%.*]] = load <16 x i8>, ptr [[TMP15]], align 1
; CHECK-NEXT:    [[TMP17:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 8
; CHECK-NEXT:    [[TMP18:%.*]] = load <16 x i8>, ptr [[TMP17]], align 1
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 9
; CHECK-NEXT:    [[TMP20:%.*]] = load <16 x i8>, ptr [[TMP19]], align 1
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 10
; CHECK-NEXT:    [[TMP22:%.*]] = load <16 x i8>, ptr [[TMP21]], align 1
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr <16 x i8>, ptr [[PTR]], i32 11
; CHECK-NEXT:    [[TMP24:%.*]] = load <16 x i8>, ptr [[TMP23]], align 1
; CHECK-NEXT:    [[TMP25:%.*]] = shufflevector <16 x i8> [[TMP2]], <16 x i8> [[TMP8]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP26:%.*]] = shufflevector <16 x i8> [[TMP4]], <16 x i8> [[TMP10]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP27:%.*]] = shufflevector <16 x i8> [[TMP6]], <16 x i8> [[TMP12]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP28:%.*]] = shufflevector <16 x i8> [[TMP14]], <16 x i8> [[TMP20]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP29:%.*]] = shufflevector <16 x i8> [[TMP16]], <16 x i8> [[TMP22]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP30:%.*]] = shufflevector <16 x i8> [[TMP18]], <16 x i8> [[TMP24]], <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
; CHECK-NEXT:    [[TMP31:%.*]] = shufflevector <32 x i8> [[TMP25]], <32 x i8> [[TMP28]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP32:%.*]] = shufflevector <32 x i8> [[TMP26]], <32 x i8> [[TMP29]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP33:%.*]] = shufflevector <32 x i8> [[TMP27]], <32 x i8> [[TMP30]], <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
; CHECK-NEXT:    [[TMP34:%.*]] = shufflevector <64 x i8> [[TMP31]], <64 x i8> poison, <64 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29, i32 32, i32 35, i32 38, i32 41, i32 44, i32 47, i32 34, i32 37, i32 40, i32 43, i32 46, i32 33, i32 36, i32 39, i32 42, i32 45, i32 48, i32 51, i32 54, i32 57, i32 60, i32 63, i32 50, i32 53, i32 56, i32 59, i32 62, i32 49, i32 52, i32 55, i32 58, i32 61>
; CHECK-NEXT:    [[TMP35:%.*]] = shufflevector <64 x i8> [[TMP32]], <64 x i8> poison, <64 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29, i32 32, i32 35, i32 38, i32 41, i32 44, i32 47, i32 34, i32 37, i32 40, i32 43, i32 46, i32 33, i32 36, i32 39, i32 42, i32 45, i32 48, i32 51, i32 54, i32 57, i32 60, i32 63, i32 50, i32 53, i32 56, i32 59, i32 62, i32 49, i32 52, i32 55, i32 58, i32 61>
; CHECK-NEXT:    [[TMP36:%.*]] = shufflevector <64 x i8> [[TMP33]], <64 x i8> poison, <64 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 2, i32 5, i32 8, i32 11, i32 14, i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 18, i32 21, i32 24, i32 27, i32 30, i32 17, i32 20, i32 23, i32 26, i32 29, i32 32, i32 35, i32 38, i32 41, i32 44, i32 47, i32 34, i32 37, i32 40, i32 43, i32 46, i32 33, i32 36, i32 39, i32 42, i32 45, i32 48, i32 51, i32 54, i32 57, i32 60, i32 63, i32 50, i32 53, i32 56, i32 59, i32 62, i32 49, i32 52, i32 55, i32 58, i32 61>
; CHECK-NEXT:    [[TMP37:%.*]] = shufflevector <64 x i8> [[TMP36]], <64 x i8> [[TMP34]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP38:%.*]] = shufflevector <64 x i8> [[TMP34]], <64 x i8> [[TMP35]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP39:%.*]] = shufflevector <64 x i8> [[TMP35]], <64 x i8> [[TMP36]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP40:%.*]] = shufflevector <64 x i8> [[TMP38]], <64 x i8> [[TMP37]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP41:%.*]] = shufflevector <64 x i8> [[TMP39]], <64 x i8> [[TMP38]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP42:%.*]] = shufflevector <64 x i8> [[TMP37]], <64 x i8> [[TMP39]], <64 x i32> <i32 11, i32 12, i32 13, i32 14, i32 15, i32 64, i32 65, i32 66, i32 67, i32 68, i32 69, i32 70, i32 71, i32 72, i32 73, i32 74, i32 27, i32 28, i32 29, i32 30, i32 31, i32 80, i32 81, i32 82, i32 83, i32 84, i32 85, i32 86, i32 87, i32 88, i32 89, i32 90, i32 43, i32 44, i32 45, i32 46, i32 47, i32 96, i32 97, i32 98, i32 99, i32 100, i32 101, i32 102, i32 103, i32 104, i32 105, i32 106, i32 59, i32 60, i32 61, i32 62, i32 63, i32 112, i32 113, i32 114, i32 115, i32 116, i32 117, i32 118, i32 119, i32 120, i32 121, i32 122>
; CHECK-NEXT:    [[TMP43:%.*]] = shufflevector <64 x i8> [[TMP41]], <64 x i8> poison, <64 x i32> <i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 32, i32 33, i32 34, i32 35, i32 36, i32 53, i32 54, i32 55, i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 48, i32 49, i32 50, i32 51, i32 52>
; CHECK-NEXT:    [[TMP44:%.*]] = shufflevector <64 x i8> [[TMP40]], <64 x i8> poison, <64 x i32> <i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63, i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55, i32 56, i32 57>
; CHECK-NEXT:    [[ADD1:%.*]] = add <64 x i8> [[TMP44]], [[TMP43]]
; CHECK-NEXT:    [[ADD2:%.*]] = add <64 x i8> [[TMP42]], [[ADD1]]
; CHECK-NEXT:    ret <64 x i8> [[ADD2]]
;
  %wide.vec = load <192 x i8>, ptr %ptr, align 1
  %v1 = shufflevector <192 x i8> %wide.vec, <192 x i8> undef, <64 x i32> <i32 0, i32 3, i32 6, i32 9, i32 12, i32 15, i32 18, i32 21, i32 24, i32 27, i32 30, i32 33, i32 36, i32 39, i32 42, i32 45, i32 48, i32 51, i32 54, i32 57, i32 60, i32 63, i32 66, i32 69, i32 72, i32 75, i32 78, i32 81, i32 84, i32 87, i32 90, i32 93, i32 96, i32 99, i32 102, i32 105, i32 108, i32 111, i32 114, i32 117, i32 120, i32 123, i32 126, i32 129, i32 132, i32 135, i32 138, i32 141, i32 144, i32 147, i32 150, i32 153, i32 156, i32 159, i32 162, i32 165, i32 168, i32 171, i32 174, i32 177, i32 180, i32 183, i32 186, i32 189>
  %v2 = shufflevector <192 x i8> %wide.vec, <192 x i8> undef, <64 x i32> <i32 1, i32 4, i32 7, i32 10, i32 13, i32 16, i32 19, i32 22, i32 25, i32 28, i32 31, i32 34, i32 37, i32 40, i32 43, i32 46, i32 49, i32 52, i32 55, i32 58, i32 61, i32 64, i32 67, i32 70, i32 73, i32 76, i32 79, i32 82, i32 85, i32 88, i32 91, i32 94, i32 97, i32 100, i32 103, i32 106, i32 109, i32 112, i32 115, i32 118, i32 121, i32 124, i32 127, i32 130, i32 133, i32 136, i32 139, i32 142, i32 145, i32 148, i32 151, i32 154, i32 157, i32 160, i32 163, i32 166, i32 169, i32 172, i32 175, i32 178, i32 181, i32 184, i32 187, i32 190>
  %v3 = shufflevector <192 x i8> %wide.vec, <192 x i8> undef, <64 x i32> <i32 2, i32 5, i32 8, i32 11, i32 14, i32 17, i32 20, i32 23, i32 26, i32 29, i32 32, i32 35, i32 38, i32 41, i32 44, i32 47, i32 50, i32 53, i32 56, i32 59, i32 62, i32 65, i32 68, i32 71, i32 74, i32 77, i32 80, i32 83, i32 86, i32 89, i32 92, i32 95, i32 98, i32 101, i32 104, i32 107, i32 110, i32 113, i32 116, i32 119, i32 122, i32 125, i32 128, i32 131, i32 134, i32 137, i32 140, i32 143, i32 146, i32 149, i32 152, i32 155, i32 158, i32 161, i32 164, i32 167, i32 170, i32 173, i32 176, i32 179, i32 182, i32 185, i32 188, i32 191>
  %add1 = add <64 x i8> %v1, %v2
  %add2 = add <64 x i8> %v3, %add1
  ret <64 x i8> %add2
}
