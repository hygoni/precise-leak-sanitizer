; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; int test0(int a) { return (a + (~(a & 0x55555555) + 1)); }
define i32 @test0(i32 %a0) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A0:%.*]], -1431655766
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = and i32 %a0, 1431655765
  %2 = xor i32 %1, -1
  %3 = add nsw i32 %2, 1
  %4 = add nsw i32 %a0, %3
  ret i32 %4
}

define <4 x i32> @test0_vec(<4 x i32> %a0) {
; CHECK-LABEL: @test0_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <4 x i32> [[A0:%.*]], <i32 -1431655766, i32 -1431655766, i32 -1431655766, i32 -1431655766>
; CHECK-NEXT:    ret <4 x i32> [[TMP1]]
;
  %1 = and <4 x i32> %a0, <i32 1431655765, i32 1431655765, i32 1431655765, i32 1431655765>
  %2 = xor <4 x i32> %1, <i32 -1, i32 -1, i32 -1, i32 -1>
  %3 = add nsw <4 x i32> %2, <i32 1, i32 1, i32 1, i32 1>
  %4 = add nsw <4 x i32> %a0, %3
  ret <4 x i32> %4
}

; int test1(int a) { return (a + (~((a >> 1) & 0x55555555) + 1)); }
define i32 @test1(i32 %a0) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[A0:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 1431655765
; CHECK-NEXT:    [[TMP3:%.*]] = sub i32 [[A0]], [[TMP2]]
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = ashr i32 %a0, 1
  %2 = and i32 %1, 1431655765
  %3 = xor i32 %2, -1
  %4 = add nsw i32 %3, 1
  %5 = add nsw i32 %a0, %4
  ret i32 %5
}

define <4 x i32> @test1_vec(<4 x i32> %a0) {
; CHECK-LABEL: @test1_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> [[A0:%.*]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[TMP1]], <i32 1431655765, i32 1431655765, i32 1431655765, i32 1431655765>
; CHECK-NEXT:    [[TMP3:%.*]] = sub <4 x i32> [[A0]], [[TMP2]]
; CHECK-NEXT:    ret <4 x i32> [[TMP3]]
;
  %1 = ashr <4 x i32> %a0, <i32 1, i32 1, i32 1, i32 1>
  %2 = and <4 x i32> %1, <i32 1431655765, i32 1431655765, i32 1431655765, i32 1431655765>
  %3 = xor <4 x i32> %2, <i32 -1, i32 -1, i32 -1, i32 -1>
  %4 = add nsw <4 x i32> %3, <i32 1, i32 1, i32 1, i32 1>
  %5 = add nsw <4 x i32> %a0, %4
  ret <4 x i32> %5
}
