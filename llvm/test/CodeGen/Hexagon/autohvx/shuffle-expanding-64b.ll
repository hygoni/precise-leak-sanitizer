; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

define <128 x i8> @f0(<64 x i8> %a0) #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0.uh = vunpack(v0.ub)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> undef, <128 x i32> <i32 0, i32 undef, i32 1, i32 undef, i32 2, i32 undef, i32 3, i32 undef, i32 4, i32 undef, i32 5, i32 undef, i32 6, i32 undef, i32 7, i32 undef, i32 8, i32 undef, i32 9, i32 undef, i32 10, i32 undef, i32 11, i32 undef, i32 12, i32 undef, i32 13, i32 undef, i32 14, i32 undef, i32 15, i32 undef, i32 16, i32 undef, i32 17, i32 undef, i32 18, i32 undef, i32 19, i32 undef, i32 20, i32 undef, i32 21, i32 undef, i32 22, i32 undef, i32 23, i32 undef, i32 24, i32 undef, i32 25, i32 undef, i32 26, i32 undef, i32 27, i32 undef, i32 28, i32 undef, i32 29, i32 undef, i32 30, i32 undef, i32 31, i32 undef, i32 32, i32 undef, i32 33, i32 undef, i32 34, i32 undef, i32 35, i32 undef, i32 36, i32 undef, i32 37, i32 undef, i32 38, i32 undef, i32 39, i32 undef, i32 40, i32 undef, i32 41, i32 undef, i32 42, i32 undef, i32 43, i32 undef, i32 44, i32 undef, i32 45, i32 undef, i32 46, i32 undef, i32 47, i32 undef, i32 48, i32 undef, i32 49, i32 undef, i32 50, i32 undef, i32 51, i32 undef, i32 52, i32 undef, i32 53, i32 undef, i32 54, i32 undef, i32 55, i32 undef, i32 56, i32 undef, i32 57, i32 undef, i32 58, i32 undef, i32 59, i32 undef, i32 60, i32 undef, i32 61, i32 undef, i32 62, i32 undef, i32 63, i32 undef>
  ret <128 x i8> %v0
}


define <128 x i8> @f1(<64 x i8> %a0) #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1:0.uw = vunpack(v0.uh)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = shufflevector <64 x i8> %a0, <64 x i8> undef, <128 x i32> <i32 0, i32 1, i32 undef, i32 undef, i32 2, i32 3, i32 undef, i32 undef, i32 4, i32 5, i32 undef, i32 undef, i32 6, i32 7, i32 undef, i32 undef, i32 8, i32 9, i32 undef, i32 undef, i32 10, i32 11, i32 undef, i32 undef, i32 12, i32 13, i32 undef, i32 undef, i32 14, i32 15, i32 undef, i32 undef, i32 16, i32 17, i32 undef, i32 undef, i32 18, i32 19, i32 undef, i32 undef, i32 20, i32 21, i32 undef, i32 undef, i32 22, i32 23, i32 undef, i32 undef, i32 24, i32 25, i32 undef, i32 undef, i32 26, i32 27, i32 undef, i32 undef, i32 28, i32 29, i32 undef, i32 undef, i32 30, i32 31, i32 undef, i32 undef, i32 32, i32 33, i32 undef, i32 undef, i32 34, i32 35, i32 undef, i32 undef, i32 36, i32 37, i32 undef, i32 undef, i32 38, i32 39, i32 undef, i32 undef, i32 40, i32 41, i32 undef, i32 undef, i32 42, i32 43, i32 undef, i32 undef, i32 44, i32 45, i32 undef, i32 undef, i32 46, i32 47, i32 undef, i32 undef, i32 48, i32 49, i32 undef, i32 undef, i32 50, i32 51, i32 undef, i32 undef, i32 52, i32 53, i32 undef, i32 undef, i32 54, i32 55, i32 undef, i32 undef, i32 56, i32 57, i32 undef, i32 undef, i32 58, i32 59, i32 undef, i32 undef, i32 60, i32 61, i32 undef, i32 undef, i32 62, i32 63, i32 undef, i32 undef>
  ret <128 x i8> %v0
}

attributes #0 = { nounwind readnone "target-features"="+hvx,+hvx-length64b" }
