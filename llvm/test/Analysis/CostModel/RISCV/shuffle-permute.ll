; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes="print<cost-model>" 2>&1 -disable-output -mtriple=riscv32 -mattr=+v,+f,+d,+zfh,+zvfh | FileCheck %s
; Check that we don't crash querying costs when vectors are not enabled.
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -mtriple=riscv32

; Note: There are no 2 element general single source permute cases.
define void @general_permute_single_source() {
;
; CHECK-LABEL: 'general_permute_single_source'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 7, i32 5, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 9, i32 6, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 3, i32 2, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 5, i32 5, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 11, i32 11, i32 11, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 2, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 7, i32 4, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 3, i32 1, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f16 = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 3, i32 1, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v8f16 = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 7, i32 5, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v16f16 = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 12, i32 12, i32 12, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f32 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 1>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8f32 = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %v4f64 = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 3, i32 2, i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 2, i32 3, i32 1, i32 0>
  %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 7, i32 5, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>
  %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 9, i32 6, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 3, i32 2, i32 2, i32 0>
  %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 5, i32 5, i32 2, i32 1, i32 0>
  %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 11, i32 11, i32 11, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 3, i32 2, i32 2, i32 0>
  %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 7, i32 4, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 3, i32 1, i32 1, i32 0>

  %v4f16 = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 3, i32 1, i32 1, i32 0>
  %v8f16 = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 7, i32 5, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>
  %v16f16 = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 12, i32 12, i32 12, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v4f32 = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 3, i32 2, i32 1, i32 1>
  %v8f32 = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 7, i32 6, i32 5, i32 5, i32 3, i32 2, i32 1, i32 0>

  %v4f64 = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 3, i32 2, i32 3, i32 0>

  ret void
}

define void @general_permute_two_source() {
;
; CHECK-LABEL: 'general_permute_two_source'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 47 for instruction: %v16i32 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 41 for instruction: %v8i64 = shufflevector <8 x i64> undef, <8 x i64> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 139 for instruction: %v16i64 = shufflevector <16 x i64> undef, <16 x i64> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2half = shufflevector <2 x half> undef, <2 x half> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v4half = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v8half = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v16half = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2float = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v4float = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 19 for instruction: %v8float = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 47 for instruction: %v16float = shufflevector <16 x float> undef, <16 x float> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 11 for instruction: %v2double = shufflevector <2 x double> undef, <2 x double> undef, <2 x i32> <i32 3, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 17 for instruction: %v4double = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 41 for instruction: %v8double = shufflevector <8 x double> undef, <8 x double> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 139 for instruction: %v16double = shufflevector <16 x double> undef, <16 x double> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %v2i8 = shufflevector <2 x i8> undef, <2 x i8> undef, <2 x i32> <i32 3, i32 0>
  %v4i8 = shufflevector <4 x i8> undef, <4 x i8> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8i8 = shufflevector <8 x i8> undef, <8 x i8> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16i8 = shufflevector <16 x i8> undef, <16 x i8> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i16 = shufflevector <2 x i16> undef, <2 x i16> undef, <2 x i32> <i32 3, i32 0>
  %v4i16 = shufflevector <4 x i16> undef, <4 x i16> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8i16 = shufflevector <8 x i16> undef, <8 x i16> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16i16 = shufflevector <16 x i16> undef, <16 x i16> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i32 = shufflevector <2 x i32> undef, <2 x i32> undef, <2 x i32> <i32 3, i32 0>
  %v4i32 = shufflevector <4 x i32> undef, <4 x i32> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8i32 = shufflevector <8 x i32> undef, <8 x i32> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16i32 = shufflevector <16 x i32> undef, <16 x i32> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2i64 = shufflevector <2 x i64> undef, <2 x i64> undef, <2 x i32> <i32 3, i32 0>
  %v4i64 = shufflevector <4 x i64> undef, <4 x i64> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8i64 = shufflevector <8 x i64> undef, <8 x i64> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16i64 = shufflevector <16 x i64> undef, <16 x i64> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2half = shufflevector <2 x half> undef, <2 x half> undef, <2 x i32> <i32 3, i32 0>
  %v4half = shufflevector <4 x half> undef, <4 x half> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8half = shufflevector <8 x half> undef, <8 x half> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16half = shufflevector <16 x half> undef, <16 x half> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2float = shufflevector <2 x float> undef, <2 x float> undef, <2 x i32> <i32 3, i32 0>
  %v4float = shufflevector <4 x float> undef, <4 x float> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8float = shufflevector <8 x float> undef, <8 x float> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16float = shufflevector <16 x float> undef, <16 x float> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  %v2double = shufflevector <2 x double> undef, <2 x double> undef, <2 x i32> <i32 3, i32 0>
  %v4double = shufflevector <4 x double> undef, <4 x double> undef, <4 x i32> <i32 5, i32 7, i32 1, i32 0>
  %v8double = shufflevector <8 x double> undef, <8 x double> undef, <8 x i32> <i32 14, i32 6, i32 5, i32 4, i32 13, i32 2, i32 1, i32 0>
  %v16double = shufflevector <16 x double> undef, <16 x double> undef, <16 x i32> <i32 15, i32 14, i32 13, i32 17, i32 11, i32 20, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>

  ret void
}
