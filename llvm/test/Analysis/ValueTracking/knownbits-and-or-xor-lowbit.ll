; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define <2 x i1> @sub_XY_and_bit0_is_zero(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @sub_XY_and_bit0_is_zero(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %C1 = or <2 x i8> %C, <i8 9, i8 9>
  %y = sub <2 x i8> %x, %C1
  %w = and <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 -1, i8 -1>
  ret <2 x i1> %r
}

define i1 @sub_XY_xor_bit0_is_one(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_XY_xor_bit0_is_one(
; CHECK-NEXT:    ret i1 false
;
  %C1 = or i8 %C, 1
  %y = sub i8 %x, %C1
  %w = xor i8 %x, %y
  %r = icmp eq i8 %w, 10
  ret i1 %r
}

define i1 @sub_XY_or_bit0_is_one(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_XY_or_bit0_is_one(
; CHECK-NEXT:    ret i1 false
;
  %C1 = or i8 %C, 1
  %y = sub i8 %x, %C1
  %w = or i8 %x, %y
  %r = icmp eq i8 %w, 10
  ret i1 %r
}

define i1 @sub_YX_and_bit0_is_zero(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_YX_and_bit0_is_zero(
; CHECK-NEXT:    ret i1 false
;
  %C1 = or i8 %C, 1
  %y = sub i8 %C1, %x
  %w = and i8 %x, %y
  %r = icmp eq i8 %w, -1
  ret i1 %r
}

define <2 x i1> @sub_YX_xor_bit0_is_one(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @sub_YX_xor_bit0_is_one(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %C1 = or <2 x i8> %C, <i8 1, i8 1>
  %y = sub <2 x i8> %C1, %x
  %w = xor <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 12, i8 12>
  ret <2 x i1> %r
}

define i1 @sub_YX_or_bit0_is_one(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_YX_or_bit0_is_one(
; CHECK-NEXT:    ret i1 false
;
  %C1 = or i8 %C, 1
  %y = sub i8 %C1, %x
  %w = or i8 %x, %y
  %r = icmp eq i8 %w, 32
  ret i1 %r
}

define i1 @add_YX_xor_bit0_is_one(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @add_YX_xor_bit0_is_one(
; CHECK-NEXT:    ret i1 false
;
  %C1 = or i8 %C, 1
  %y = add i8 %C1, %x
  %w = xor i8 %x, %y
  %r = icmp eq i8 %w, 32
  ret i1 %r
}

define <2 x i1> @add_XY_or_bit0_is_one(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @add_XY_or_bit0_is_one(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %C1 = or <2 x i8> %C, <i8 1, i8 1>
  %y = add <2 x i8> %C1, %x
  %w = or <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 90, i8 90>
  ret <2 x i1> %r
}

define <2 x i1> @sub_XY_and_bit0_is_zero_fail(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @sub_XY_and_bit0_is_zero_fail(
; CHECK-NEXT:    [[C1:%.*]] = or <2 x i8> [[C:%.*]], <i8 8, i8 8>
; CHECK-NEXT:    [[Y:%.*]] = sub <2 x i8> [[X:%.*]], [[C1]]
; CHECK-NEXT:    [[W:%.*]] = and <2 x i8> [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq <2 x i8> [[W]], <i8 -1, i8 -1>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %C1 = or <2 x i8> %C, <i8 8, i8 8>
  %y = sub <2 x i8> %x, %C1
  %w = and <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 -1, i8 -1>
  ret <2 x i1> %r
}

define i1 @sub_XY_xor_bit0_is_one_fail(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_XY_xor_bit0_is_one_fail(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[C:%.*]], -2
; CHECK-NEXT:    [[C1_NEG:%.*]] = add i8 [[TMP1]], 1
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[C1_NEG]], [[X:%.*]]
; CHECK-NEXT:    [[W:%.*]] = xor i8 [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[W]], 10
; CHECK-NEXT:    ret i1 [[R]]
;
  %C1 = xor i8 %C, 1
  %y = sub i8 %x, %C1
  %w = xor i8 %x, %y
  %r = icmp eq i8 %w, 10
  ret i1 %r
}

define i1 @sub_XY_or_bit0_is_one_fail(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_XY_or_bit0_is_one_fail(
; CHECK-NEXT:    [[Y:%.*]] = sub i8 [[X:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[W:%.*]] = or i8 [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[W]], 10
; CHECK-NEXT:    ret i1 [[R]]
;
  %y = sub i8 %x, %C
  %w = or i8 %x, %y
  %r = icmp eq i8 %w, 10
  ret i1 %r
}

define i1 @sub_YX_and_bit0_is_zero_fail(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_YX_and_bit0_is_zero_fail(
; CHECK-NEXT:    [[Y:%.*]] = sub i8 [[C:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[W:%.*]] = and i8 [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[W]], -1
; CHECK-NEXT:    ret i1 [[R]]
;
  %y = sub i8 %C, %x
  %w = and i8 %x, %y
  %r = icmp eq i8 %w, -1
  ret i1 %r
}

define <2 x i1> @sub_YX_xor_bit0_is_one_fail(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @sub_YX_xor_bit0_is_one_fail(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[Y:%.*]] = add <2 x i8> [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    [[W:%.*]] = xor <2 x i8> [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq <2 x i8> [[W]], <i8 12, i8 12>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %C1 = sub <2 x i8> %C, <i8 1, i8 1>
  %y = sub <2 x i8> %C1, %x
  %w = xor <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 12, i8 12>
  ret <2 x i1> %r
}

define i1 @sub_YX_or_bit0_is_one_fail(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @sub_YX_or_bit0_is_one_fail(
; CHECK-NEXT:    [[C1:%.*]] = xor i8 [[C:%.*]], 1
; CHECK-NEXT:    [[Y:%.*]] = sub i8 [[C1]], [[X:%.*]]
; CHECK-NEXT:    [[W:%.*]] = or i8 [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[W]], 32
; CHECK-NEXT:    ret i1 [[R]]
;
  %C1 = xor i8 %C, 1
  %y = sub i8 %C1, %x
  %w = or i8 %x, %y
  %r = icmp eq i8 %w, 32
  ret i1 %r
}

define i1 @add_YX_xor_bit0_is_one_fail(i8 %x, i8 %C) nounwind {
; CHECK-LABEL: @add_YX_xor_bit0_is_one_fail(
; CHECK-NEXT:    [[C1:%.*]] = and i8 [[C:%.*]], 1
; CHECK-NEXT:    [[Y:%.*]] = add i8 [[C1]], [[X:%.*]]
; CHECK-NEXT:    [[W:%.*]] = xor i8 [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq i8 [[W]], 32
; CHECK-NEXT:    ret i1 [[R]]
;
  %C1 = and i8 %C, 1
  %y = add i8 %C1, %x
  %w = xor i8 %x, %y
  %r = icmp eq i8 %w, 32
  ret i1 %r
}

define <2 x i1> @add_XY_or_bit0_is_one_fail(<2 x i8> %x, <2 x i8> %C) nounwind {
; CHECK-LABEL: @add_XY_or_bit0_is_one_fail(
; CHECK-NEXT:    [[C1:%.*]] = add <2 x i8> [[C:%.*]], <i8 1, i8 1>
; CHECK-NEXT:    [[Y:%.*]] = add <2 x i8> [[C1]], [[X:%.*]]
; CHECK-NEXT:    [[W:%.*]] = or <2 x i8> [[Y]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = icmp eq <2 x i8> [[W]], <i8 90, i8 90>
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %C1 = add <2 x i8> %C, <i8 1, i8 1>
  %y = add <2 x i8> %C1, %x
  %w = or <2 x i8> %x, %y
  %r = icmp eq <2 x i8> %w, <i8 90, i8 90>
  ret <2 x i1> %r
}

;; These tests are just to check if it can simplify using demanded bits path.
define <2 x i32> @add_and_eval_vec(<2 x i32> %x, <2 x i32> %C) {
; CHECK-LABEL: @add_and_eval_vec(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %y = add <2 x i32> %x, <i32 1, i32 1>
  %z = and <2 x i32> %x, %y
  ;; shl so we don't commute the and
  %b = shl <2 x i32> %z, <i32 31, i32 31>
  ret <2 x i32> %b
}


define <2 x i32> @add_xor_eval_vec(<2 x i32> %x) {
; CHECK-LABEL: @add_xor_eval_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 1, i32 1>
;
  %y = add <2 x i32> %x, <i32 1, i32 1>
  %z = xor <2 x i32> %y, %x
  %b = and <2 x i32> %z, <i32 1, i32 1>
  ret <2 x i32> %b
}

define <2 x i32> @add_or_eval_vec(<2 x i32> %x, <2 x i32> %C) {
; CHECK-LABEL: @add_or_eval_vec(
; CHECK-NEXT:    ret <2 x i32> <i32 1, i32 1>
;
  %y = add <2 x i32> %x, <i32 1, i32 1>
  %z = or <2 x i32> %y, %x
  %b = and <2 x i32> %z, <i32 1, i32 1>
  ret <2 x i32> %b
}
