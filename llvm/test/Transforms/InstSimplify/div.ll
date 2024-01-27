; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instsimplify -S | FileCheck %s

define i32 @zero_dividend(i32 %A) {
; CHECK-LABEL: @zero_dividend(
; CHECK-NEXT:    ret i32 0
;
  %B = sdiv i32 0, %A
  ret i32 %B
}

define <2 x i32> @zero_dividend_vector(<2 x i32> %A) {
; CHECK-LABEL: @zero_dividend_vector(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %B = udiv <2 x i32> zeroinitializer, %A
  ret <2 x i32> %B
}

define <2 x i32> @zero_dividend_vector_undef_elt(<2 x i32> %A) {
; CHECK-LABEL: @zero_dividend_vector_undef_elt(
; CHECK-NEXT:    ret <2 x i32> zeroinitializer
;
  %B = sdiv <2 x i32> <i32 0, i32 undef>, %A
  ret <2 x i32> %B
}

; Division-by-zero is poison. UB in any vector lane means the whole op is poison.

define <2 x i8> @sdiv_zero_elt_vec_constfold(<2 x i8> %x) {
; CHECK-LABEL: @sdiv_zero_elt_vec_constfold(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = sdiv <2 x i8> <i8 1, i8 2>, <i8 0, i8 -42>
  ret <2 x i8> %div
}

define <2 x i8> @udiv_zero_elt_vec_constfold(<2 x i8> %x) {
; CHECK-LABEL: @udiv_zero_elt_vec_constfold(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = udiv <2 x i8> <i8 1, i8 2>, <i8 42, i8 0>
  ret <2 x i8> %div
}

define <2 x i8> @sdiv_zero_elt_vec(<2 x i8> %x) {
; CHECK-LABEL: @sdiv_zero_elt_vec(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = sdiv <2 x i8> %x, <i8 -42, i8 0>
  ret <2 x i8> %div
}

define <2 x i8> @udiv_zero_elt_vec(<2 x i8> %x) {
; CHECK-LABEL: @udiv_zero_elt_vec(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = udiv <2 x i8> %x, <i8 0, i8 42>
  ret <2 x i8> %div
}

define <2 x i8> @sdiv_undef_elt_vec(<2 x i8> %x) {
; CHECK-LABEL: @sdiv_undef_elt_vec(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = sdiv <2 x i8> %x, <i8 -42, i8 undef>
  ret <2 x i8> %div
}

define <2 x i8> @udiv_undef_elt_vec(<2 x i8> %x) {
; CHECK-LABEL: @udiv_undef_elt_vec(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %div = udiv <2 x i8> %x, <i8 undef, i8 42>
  ret <2 x i8> %div
}

; Division-by-zero is undef. UB in any vector lane means the whole op is undef.
; Thus, we can simplify this: if any element of 'y' is 0, we can do anything.
; Therefore, assume that all elements of 'y' must be 1.

define <2 x i1> @sdiv_bool_vec(<2 x i1> %x, <2 x i1> %y) {
; CHECK-LABEL: @sdiv_bool_vec(
; CHECK-NEXT:    ret <2 x i1> [[X:%.*]]
;
  %div = sdiv <2 x i1> %x, %y
  ret <2 x i1> %div
}

define <2 x i1> @udiv_bool_vec(<2 x i1> %x, <2 x i1> %y) {
; CHECK-LABEL: @udiv_bool_vec(
; CHECK-NEXT:    ret <2 x i1> [[X:%.*]]
;
  %div = udiv <2 x i1> %x, %y
  ret <2 x i1> %div
}

define i32 @zext_bool_udiv_divisor(i1 %x, i32 %y) {
; CHECK-LABEL: @zext_bool_udiv_divisor(
; CHECK-NEXT:    ret i32 [[Y:%.*]]
;
  %ext = zext i1 %x to i32
  %r = udiv i32 %y, %ext
  ret i32 %r
}

define <2 x i32> @zext_bool_sdiv_divisor_vec(<2 x i1> %x, <2 x i32> %y) {
; CHECK-LABEL: @zext_bool_sdiv_divisor_vec(
; CHECK-NEXT:    ret <2 x i32> [[Y:%.*]]
;
  %ext = zext <2 x i1> %x to <2 x i32>
  %r = sdiv <2 x i32> %y, %ext
  ret <2 x i32> %r
}

define i32 @udiv_dividend_known_smaller_than_constant_divisor(i32 %x) {
; CHECK-LABEL: @udiv_dividend_known_smaller_than_constant_divisor(
; CHECK-NEXT:    ret i32 0
;
  %and = and i32 %x, 250
  %div = udiv i32 %and, 251
  ret i32 %div
}

define i32 @not_udiv_dividend_known_smaller_than_constant_divisor(i32 %x) {
; CHECK-LABEL: @not_udiv_dividend_known_smaller_than_constant_divisor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 251
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[AND]], 251
; CHECK-NEXT:    ret i32 [[DIV]]
;
  %and = and i32 %x, 251
  %div = udiv i32 %and, 251
  ret i32 %div
}

define i32 @udiv_constant_dividend_known_smaller_than_divisor(i32 %x) {
; CHECK-LABEL: @udiv_constant_dividend_known_smaller_than_divisor(
; CHECK-NEXT:    ret i32 0
;
  %or = or i32 %x, 251
  %div = udiv i32 250, %or
  ret i32 %div
}

define i32 @not_udiv_constant_dividend_known_smaller_than_divisor(i32 %x) {
; CHECK-LABEL: @not_udiv_constant_dividend_known_smaller_than_divisor(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], 251
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 251, [[OR]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
  %or = or i32 %x, 251
  %div = udiv i32 251, %or
  ret i32 %div
}

define i8 @udiv_dividend_known_smaller_than_constant_divisor2(i1 %b) {
; CHECK-LABEL: @udiv_dividend_known_smaller_than_constant_divisor2(
; CHECK-NEXT:    ret i8 0
;
  %t0 = zext i1 %b to i8
  %xor = xor i8 %t0, 12
  %r = udiv i8 %xor, 14
  ret i8 %r
}

; negative test - dividend can equal 13

define i8 @not_udiv_dividend_known_smaller_than_constant_divisor2(i1 %b) {
; CHECK-LABEL: @not_udiv_dividend_known_smaller_than_constant_divisor2(
; CHECK-NEXT:    [[T0:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[XOR:%.*]] = xor i8 [[T0]], 12
; CHECK-NEXT:    [[R:%.*]] = udiv i8 [[XOR]], 13
; CHECK-NEXT:    ret i8 [[R]]
;
  %t0 = zext i1 %b to i8
  %xor = xor i8 %t0, 12
  %r = udiv i8 %xor, 13
  ret i8 %r
}

; This would require computing known bits on both x and y. Is it worth doing?

define i32 @udiv_dividend_known_smaller_than_divisor(i32 %x, i32 %y) {
; CHECK-LABEL: @udiv_dividend_known_smaller_than_divisor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 250
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 251
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[AND]], [[OR]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
  %and = and i32 %x, 250
  %or = or i32 %y, 251
  %div = udiv i32 %and, %or
  ret i32 %div
}

define i32 @not_udiv_dividend_known_smaller_than_divisor(i32 %x, i32 %y) {
; CHECK-LABEL: @not_udiv_dividend_known_smaller_than_divisor(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 251
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[Y:%.*]], 251
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[AND]], [[OR]]
; CHECK-NEXT:    ret i32 [[DIV]]
;
  %and = and i32 %x, 251
  %or = or i32 %y, 251
  %div = udiv i32 %and, %or
  ret i32 %div
}

declare i32 @external()

define i32 @div1() {
; CHECK-LABEL: @div1(
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @external(), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    ret i32 0
;
  %call = call i32 @external(), !range !0
  %urem = udiv i32 %call, 3
  ret i32 %urem
}

define i8 @sdiv_minusone_divisor() {
; CHECK-LABEL: @sdiv_minusone_divisor(
; CHECK-NEXT:    ret i8 poison
;
  %v = sdiv i8 -128, -1
  ret i8 %v
}

@g = external global i64
@g2 = external global i64

define i64 @const_sdiv_one() {
; CHECK-LABEL: @const_sdiv_one(
; CHECK-NEXT:    ret i64 ptrtoint (ptr @g to i64)
;
  %div = sdiv i64 ptrtoint (ptr @g to i64), 1
  ret i64 %div
}

define i64 @const_srem_one() {
; CHECK-LABEL: @const_srem_one(
; CHECK-NEXT:    ret i64 0
;
  %rem = srem i64 ptrtoint (ptr @g to i64), 1
  ret i64 %rem
}

define i64 @const_udiv_one() {
; CHECK-LABEL: @const_udiv_one(
; CHECK-NEXT:    ret i64 ptrtoint (ptr @g to i64)
;
  %div = udiv i64 ptrtoint (ptr @g to i64), 1
  ret i64 %div
}

define i64 @const_urem_one() {
; CHECK-LABEL: @const_urem_one(
; CHECK-NEXT:    ret i64 0
;
  %rem = urem i64 ptrtoint (ptr @g to i64), 1
  ret i64 %rem
}

define i64 @const_sdiv_zero() {
; CHECK-LABEL: @const_sdiv_zero(
; CHECK-NEXT:    ret i64 0
;
  %div = sdiv i64 0, ptrtoint (ptr @g to i64)
  ret i64 %div
}

define i64 @const_srem_zero() {
; CHECK-LABEL: @const_srem_zero(
; CHECK-NEXT:    ret i64 0
;
  %rem = srem i64 0, ptrtoint (ptr @g to i64)
  ret i64 %rem
}

define i64 @const_udiv_zero() {
; CHECK-LABEL: @const_udiv_zero(
; CHECK-NEXT:    ret i64 0
;
  %div = udiv i64 0, ptrtoint (ptr @g to i64)
  ret i64 %div
}

define i64 @const_urem_zero() {
; CHECK-LABEL: @const_urem_zero(
; CHECK-NEXT:    ret i64 0
;
  %rem = urem i64 0, ptrtoint (ptr @g to i64)
  ret i64 %rem
}

define i64 @const_sdiv_zero_negone() {
; CHECK-LABEL: @const_sdiv_zero_negone(
; CHECK-NEXT:    ret i64 0
;
  %div = sdiv i64 0, -1
  ret i64 %div
}

define i1 @const_sdiv_i1() {
; CHECK-LABEL: @const_sdiv_i1(
; CHECK-NEXT:    ret i1 ptrtoint (ptr @g to i1)
;
  %div = sdiv i1 ptrtoint (ptr @g to i1), ptrtoint (ptr @g2 to i1)
  ret i1 %div
}

define i1 @const_srem_1() {
; CHECK-LABEL: @const_srem_1(
; CHECK-NEXT:    ret i1 false
;
  %rem = srem i1 ptrtoint (ptr @g to i1), ptrtoint (ptr @g2 to i1)
  ret i1 %rem
}

define i1 @const_udiv_i1() {
; CHECK-LABEL: @const_udiv_i1(
; CHECK-NEXT:    ret i1 ptrtoint (ptr @g to i1)
;
  %div = udiv i1 ptrtoint (ptr @g to i1), ptrtoint (ptr @g2 to i1)
  ret i1 %div
}

define i1 @const_urem_1() {
; CHECK-LABEL: @const_urem_1(
; CHECK-NEXT:    ret i1 false
;
  %rem = urem i1 ptrtoint (ptr @g to i1), ptrtoint (ptr @g2 to i1)
  ret i1 %rem
}

; Can't divide evenly, so create poison.

define i8 @sdiv_exact_trailing_zeros(i8 %x) {
; CHECK-LABEL: @sdiv_exact_trailing_zeros(
; CHECK-NEXT:    ret i8 poison
;
  %o = or i8 %x, 1           ; odd number
  %r = sdiv exact i8 %o, -42 ; can't divide exactly
  ret i8 %r
}

; Negative test - could divide evenly.

define i8 @sdiv_exact_trailing_zeros_eq(i8 %x) {
; CHECK-LABEL: @sdiv_exact_trailing_zeros_eq(
; CHECK-NEXT:    [[O:%.*]] = or i8 [[X:%.*]], 2
; CHECK-NEXT:    [[R:%.*]] = sdiv exact i8 [[O]], -42
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = or i8 %x, 2
  %r = sdiv exact i8 %o, -42
  ret i8 %r
}

; Negative test - must be exact div.

define i8 @sdiv_trailing_zeros(i8 %x) {
; CHECK-LABEL: @sdiv_trailing_zeros(
; CHECK-NEXT:    [[O:%.*]] = or i8 [[X:%.*]], 1
; CHECK-NEXT:    [[R:%.*]] = sdiv i8 [[O]], -12
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = or i8 %x, 1
  %r = sdiv i8 %o, -12
  ret i8 %r
}

; TODO: Match non-splat vector constants.

define <2 x i8> @sdiv_exact_trailing_zeros_nonuniform_vector(<2 x i8> %x) {
; CHECK-LABEL: @sdiv_exact_trailing_zeros_nonuniform_vector(
; CHECK-NEXT:    [[O:%.*]] = or <2 x i8> [[X:%.*]], <i8 3, i8 1>
; CHECK-NEXT:    [[R:%.*]] = sdiv exact <2 x i8> [[O]], <i8 12, i8 2>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %o = or <2 x i8> %x, <i8 3, i8 1>
  %r = sdiv exact <2 x i8> %o, <i8 12, i8 2>
  ret <2 x i8> %r
}

; Can't divide evenly, so create poison.

define <2 x i8> @udiv_exact_trailing_zeros(<2 x i8> %x) {
; CHECK-LABEL: @udiv_exact_trailing_zeros(
; CHECK-NEXT:    ret <2 x i8> poison
;
  %o = or <2 x i8> %x, <i8 3, i8 3>
  %r = udiv exact <2 x i8> %o, <i8 12, i8 12>  ; can't divide exactly
  ret <2 x i8> %r
}

; Negative test - could divide evenly.

define <2 x i8> @udiv_exact_trailing_zeros_eq(<2 x i8> %x) {
; CHECK-LABEL: @udiv_exact_trailing_zeros_eq(
; CHECK-NEXT:    [[O:%.*]] = or <2 x i8> [[X:%.*]], <i8 28, i8 28>
; CHECK-NEXT:    [[R:%.*]] = udiv exact <2 x i8> [[O]], <i8 12, i8 12>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %o = or <2 x i8> %x, <i8 28, i8 28>
  %r = udiv exact <2 x i8> %o, <i8 12, i8 12>
  ret <2 x i8> %r
}

; Negative test - must be exact div.

define i8 @udiv_trailing_zeros(i8 %x) {
; CHECK-LABEL: @udiv_trailing_zeros(
; CHECK-NEXT:    [[O:%.*]] = or i8 [[X:%.*]], 1
; CHECK-NEXT:    [[R:%.*]] = udiv i8 [[O]], 12
; CHECK-NEXT:    ret i8 [[R]]
;
  %o = or i8 %x, 1
  %r = udiv i8 %o, 12
  ret i8 %r
}

; Negative test - only the first element is poison

define <2 x i8> @udiv_exact_trailing_zeros_nonuniform_vector(<2 x i8> %x) {
; CHECK-LABEL: @udiv_exact_trailing_zeros_nonuniform_vector(
; CHECK-NEXT:    [[O:%.*]] = or <2 x i8> [[X:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[R:%.*]] = udiv exact <2 x i8> [[O]], <i8 12, i8 1>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %o = or <2 x i8> %x, <i8 3, i8 3>
  %r = udiv exact <2 x i8> %o, <i8 12, i8 1>
  ret <2 x i8> %r
}

!0 = !{i32 0, i32 3}

define i32 @sdiv_one_srem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @sdiv_one_srem_divisor(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %srem = srem i32 1, %b
  %sdiv = sdiv i32 %a, %srem
  ret i32 %sdiv
}

define i32 @sdiv_one_urem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @sdiv_one_urem_divisor(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %urem = urem i32 1, %b
  %sdiv = sdiv i32 %a, %urem
  ret i32 %sdiv
}

define i32 @udiv_one_srem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @udiv_one_srem_divisor(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %srem = srem i32 1, %b
  %udiv = udiv i32 %a, %srem
  ret i32 %udiv
}

define i32 @udiv_one_urem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @udiv_one_urem_divisor(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %urem = urem i32 1, %b
  %udiv = udiv i32 %a, %urem
  ret i32 %udiv
}

define i32 @srem_one_srem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @srem_one_srem_divisor(
; CHECK-NEXT:    ret i32 0
;
  %srem = srem i32 1, %b
  %srem1 = srem i32 %a, %srem
  ret i32 %srem1
}

define i32 @urem_one_srem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @urem_one_srem_divisor(
; CHECK-NEXT:    ret i32 0
;
  %srem = srem i32 1, %b
  %urem = urem i32 %a, %srem
  ret i32 %urem
}

define i32 @srem_one_urem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @srem_one_urem_divisor(
; CHECK-NEXT:    ret i32 0
;
  %urem = urem i32 1, %b
  %srem = srem i32 %a, %urem
  ret i32 %srem
}

define i32 @urem_one_urem_divisor(i32 %a, i32 %b) {
; CHECK-LABEL: @urem_one_urem_divisor(
; CHECK-NEXT:    ret i32 0
;
  %urem = urem i32 1, %b
  %urem1 = urem i32 %a, %urem
  ret i32 %urem1
}

define <2 x i8> @sdiv_one_vec_srem_divisor(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @sdiv_one_vec_srem_divisor(
; CHECK-NEXT:    ret <2 x i8> [[A:%.*]]
;
  %srem = srem <2 x i8> <i8 1, i8 1>, %b
  %sdiv = sdiv <2 x i8> %a, %srem
  ret <2 x i8> %sdiv
}

define i32 @sdiv_and_one_divisor(i32 %x, i32 %y) {
; CHECK-LABEL: @sdiv_and_one_divisor(
; CHECK-NEXT:    ret i32 [[Y:%.*]]
;
  %and = and i32 %x, 1
  %res = sdiv i32 %y, %and
  ret i32 %res
}

define <2 x i8> @sdiv_and_one_vec_divisor(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @sdiv_and_one_vec_divisor(
; CHECK-NEXT:    ret <2 x i8> [[Y:%.*]]
;
  %and = and <2 x i8> %x, <i8 1, i8 1>
  %res = sdiv <2 x i8> %y, %and
  ret <2 x i8> %res
}

define i32 @sdiv_neg_or_divisor(i32 %x, i32 %y) {
; CHECK-LABEL: @sdiv_neg_or_divisor(
; CHECK-NEXT:    ret i32 [[Y:%.*]]
;
  %or = or i32 %x, -2
  %neg = xor i32 %or, -1
  %res = sdiv i32 %y, %neg
  ret i32 %res
}

define i32 @sdiv_neg_or_multi_one_bit_divisor(i32 %x, i32 %y) {
; CHECK-LABEL: @sdiv_neg_or_multi_one_bit_divisor(
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[X:%.*]], -3
; CHECK-NEXT:    [[NEG:%.*]] = xor i32 [[OR]], -1
; CHECK-NEXT:    [[RES:%.*]] = sdiv i32 [[Y:%.*]], [[NEG]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %or = or i32 %x, -3
  %neg = xor i32 %or, -1
  %res = sdiv i32 %y, %neg
  ret i32 %res
}

define <2 x i8> @sdiv_vec_multi_one_bit_divisor(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @sdiv_vec_multi_one_bit_divisor(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i8> [[X:%.*]], <i8 1, i8 3>
; CHECK-NEXT:    [[RES:%.*]] = sdiv <2 x i8> [[Y:%.*]], [[AND]]
; CHECK-NEXT:    ret <2 x i8> [[RES]]
;
  %and = and <2 x i8> %x, <i8 1, i8 3>
  %res = sdiv <2 x i8> %y, %and
  ret <2 x i8> %res
}
