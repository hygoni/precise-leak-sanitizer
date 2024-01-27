; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare void @use(i8)
declare void @use_vec(<2 x i8>)

; ((b | a) & C1) | (b & C2) -> (a & C1) | b iff C1 == ~C2

define i32 @or_and_not_constant_commute0(i32 %a, i32 %b) {
; CHECK-LABEL: @or_and_not_constant_commute0(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[T3:%.*]] = or i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t = or i32 %b, %a
  %t1 = and i32 %t, 1
  %t2 = and i32 %b, -2
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @or_and_not_constant_commute1(i32 %a, i32 %b) {
; CHECK-LABEL: @or_and_not_constant_commute1(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[T3:%.*]] = or i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t = or i32 %a, %b
  %t1 = and i32 1, %t
  %t2 = and i32 -2, %b
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @or_and_not_constant_commute2(i32 %a, i32 %b) {
; CHECK-LABEL: @or_and_not_constant_commute2(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[T3:%.*]] = or i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t = or i32 %b, %a
  %t1 = and i32 %t, 1
  %t2 = and i32 %b, -2
  %t3 = or i32 %t2, %t1
  ret i32 %t3
}

define i32 @or_and_not_constant_commute3(i32 %a, i32 %b) {
; CHECK-LABEL: @or_and_not_constant_commute3(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], 1
; CHECK-NEXT:    [[T3:%.*]] = or i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i32 [[T3]]
;
  %t = or i32 %a, %b
  %t1 = and i32 1, %t
  %t2 = and i32 -2, %b
  %t3 = or i32 %t2, %t1
  ret i32 %t3
}

define <2 x i7> @or_and_not_constant_commute0_splat(<2 x i7> %a, <2 x i7> %b) {
; CHECK-LABEL: @or_and_not_constant_commute0_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i7> [[A:%.*]], <i7 42, i7 42>
; CHECK-NEXT:    [[T3:%.*]] = or <2 x i7> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i7> [[T3]]
;
  %t = or <2 x i7> %b, %a
  %t1 = and <2 x i7> %t, <i7 42, i7 42>
  %t2 = and <2 x i7> %b, <i7 -43, i7 -43>
  %t3 = or <2 x i7> %t1, %t2
  ret <2 x i7> %t3
}

; ((x | N) & C1) | (x & C2) --> (x | N) & (C1 | C2)
; iff (C1 & C2) == 0 and (N & ~C1) == 0

define i8 @or_and_or_commute0(i8 %x) {
; CHECK-LABEL: @or_and_or_commute0(
; CHECK-NEXT:    [[XN:%.*]] = or i8 [[X:%.*]], 16
; CHECK-NEXT:    call void @use(i8 [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and i8 [[XN]], 59
; CHECK-NEXT:    call void @use(i8 [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and i8 [[X]], 64
; CHECK-NEXT:    call void @use(i8 [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[XN]], 123
; CHECK-NEXT:    ret i8 [[R]]
;
  %xn = or i8 %x, 16   ; 0001_0000
  call void @use(i8 %xn)
  %x1 = and i8 %xn, 59 ; 0011_1011
  call void @use(i8 %x1)
  %x2 = and i8 %x, 64  ; 0100_0000
  call void @use(i8 %x2)
  %r = or i8 %x1, %x2
  ret i8 %r
}

define i8 @or_and_or_commute1(i8 %x) {
; CHECK-LABEL: @or_and_or_commute1(
; CHECK-NEXT:    [[XN:%.*]] = or i8 [[X:%.*]], 16
; CHECK-NEXT:    call void @use(i8 [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and i8 [[XN]], 59
; CHECK-NEXT:    call void @use(i8 [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and i8 [[X]], 64
; CHECK-NEXT:    call void @use(i8 [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[XN]], 123
; CHECK-NEXT:    ret i8 [[R]]
;
  %xn = or i8 %x, 16   ; 0001_0000
  call void @use(i8 %xn)
  %x1 = and i8 %xn, 59 ; 0011_1011
  call void @use(i8 %x1)
  %x2 = and i8 %x, 64  ; 0100_0000
  call void @use(i8 %x2)
  %r = or i8 %x2, %x1
  ret i8 %r
}

define <2 x i8> @or_and_or_commute1_splat(<2 x i8> %x) {
; CHECK-LABEL: @or_and_or_commute1_splat(
; CHECK-NEXT:    [[XN:%.*]] = or <2 x i8> [[X:%.*]], <i8 16, i8 16>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and <2 x i8> [[XN]], <i8 59, i8 59>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and <2 x i8> [[X]], <i8 64, i8 64>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[XN]], <i8 123, i8 123>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %xn = or <2 x i8> %x, <i8 16, i8 16>
  call void @use_vec(<2 x i8> %xn)
  %x1 = and <2 x i8> %xn, <i8 59, i8 59>
  call void @use_vec(<2 x i8> %x1)
  %x2 = and <2 x i8> %x, <i8 64, i8 64>
  call void @use_vec(<2 x i8> %x2)
  %r = or <2 x i8> %x2, %x1
  ret <2 x i8> %r
}

define i8 @or_and_or_commute2(i8 %x, i8 %y) {
; CHECK-LABEL: @or_and_or_commute2(
; CHECK-NEXT:    [[N:%.*]] = lshr i8 [[Y:%.*]], 6
; CHECK-NEXT:    [[XN:%.*]] = or i8 [[N]], [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and i8 [[XN]], -69
; CHECK-NEXT:    call void @use(i8 [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and i8 [[X]], 64
; CHECK-NEXT:    call void @use(i8 [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[XN]], -5
; CHECK-NEXT:    ret i8 [[R]]
;
  %n = lshr i8 %y, 6
  %xn = or i8 %n, %x
  call void @use(i8 %xn)
  %x1 = and i8 %xn, 187
  call void @use(i8 %x1)
  %x2 = and i8 %x, 64
  call void @use(i8 %x2)
  %r = or i8 %x1, %x2
  ret i8 %r
}

define <2 x i8> @or_and_or_commute2_splat(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @or_and_or_commute2_splat(
; CHECK-NEXT:    [[N:%.*]] = lshr <2 x i8> [[Y:%.*]], <i8 6, i8 6>
; CHECK-NEXT:    [[XN:%.*]] = or <2 x i8> [[N]], [[X:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and <2 x i8> [[XN]], <i8 -69, i8 -69>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and <2 x i8> [[X]], <i8 64, i8 64>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and <2 x i8> [[XN]], <i8 -5, i8 -5>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %n = lshr <2 x i8> %y, <i8 6, i8 6>
  %xn = or <2 x i8> %n, %x
  call void @use_vec(<2 x i8> %xn)
  %x1 = and <2 x i8> %xn, <i8 187, i8 187>
  call void @use_vec(<2 x i8> %x1)
  %x2 = and <2 x i8> %x, <i8 64, i8 64>
  call void @use_vec(<2 x i8> %x2)
  %r = or <2 x i8> %x1, %x2
  ret <2 x i8> %r
}

define i8 @or_and_or_commute3(i8 %x, i8 %y) {
; CHECK-LABEL: @or_and_or_commute3(
; CHECK-NEXT:    [[N:%.*]] = lshr i8 [[Y:%.*]], 6
; CHECK-NEXT:    [[XN:%.*]] = or i8 [[N]], [[X:%.*]]
; CHECK-NEXT:    call void @use(i8 [[XN]])
; CHECK-NEXT:    [[X1:%.*]] = and i8 [[XN]], -69
; CHECK-NEXT:    call void @use(i8 [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and i8 [[X]], 64
; CHECK-NEXT:    call void @use(i8 [[X2]])
; CHECK-NEXT:    [[R:%.*]] = and i8 [[XN]], -5
; CHECK-NEXT:    ret i8 [[R]]
;
  %n = lshr i8 %y, 6
  %xn = or i8 %n, %x
  call void @use(i8 %xn)
  %x1 = and i8 %xn, 187
  call void @use(i8 %x1)
  %x2 = and i8 %x, 64
  call void @use(i8 %x2)
  %r = or i8 %x2, %x1
  ret i8 %r
}

define i8 @or_and2_or2(i8 %x) {
; CHECK-LABEL: @or_and2_or2(
; CHECK-NEXT:    [[O1:%.*]] = or i8 [[X:%.*]], 1
; CHECK-NEXT:    call void @use(i8 [[O1]])
; CHECK-NEXT:    [[O2:%.*]] = or i8 [[X]], 2
; CHECK-NEXT:    call void @use(i8 [[O2]])
; CHECK-NEXT:    [[X1:%.*]] = and i8 [[O1]], -71
; CHECK-NEXT:    call void @use(i8 [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and i8 [[O2]], 66
; CHECK-NEXT:    call void @use(i8 [[X2]])
; CHECK-NEXT:    [[BITFIELD:%.*]] = and i8 [[X]], -8
; CHECK-NEXT:    [[R:%.*]] = or i8 [[BITFIELD]], 3
; CHECK-NEXT:    ret i8 [[R]]
;
  %o1 = or i8 %x, 1
  call void @use(i8 %o1)
  %o2 = or i8 %x, 2
  call void @use(i8 %o2)
  %x1 = and i8 %o1, 185
  call void @use(i8 %x1)
  %x2 = and i8 %o2, 66
  call void @use(i8 %x2)
  %r = or i8 %x1, %x2
  ret i8 %r
}

define <2 x i8> @or_and2_or2_splat(<2 x i8> %x) {
; CHECK-LABEL: @or_and2_or2_splat(
; CHECK-NEXT:    [[O1:%.*]] = or <2 x i8> [[X:%.*]], <i8 1, i8 1>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[O1]])
; CHECK-NEXT:    [[O2:%.*]] = or <2 x i8> [[X]], <i8 2, i8 2>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[O2]])
; CHECK-NEXT:    [[X1:%.*]] = and <2 x i8> [[O1]], <i8 -71, i8 -71>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X1]])
; CHECK-NEXT:    [[X2:%.*]] = and <2 x i8> [[O2]], <i8 66, i8 66>
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[X2]])
; CHECK-NEXT:    [[BITFIELD:%.*]] = and <2 x i8> [[X]], <i8 -8, i8 -8>
; CHECK-NEXT:    [[R:%.*]] = or <2 x i8> [[BITFIELD]], <i8 3, i8 3>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %o1 = or <2 x i8> %x, <i8 1, i8 1>
  call void @use_vec(<2 x i8> %o1)
  %o2 = or <2 x i8> %x, <i8 2, i8 2>
  call void @use_vec(<2 x i8> %o2)
  %x1 = and <2 x i8> %o1, <i8 185, i8 185>
  call void @use_vec(<2 x i8> %x1)
  %x2 = and <2 x i8> %o2, <i8 66, i8 66>
  call void @use_vec(<2 x i8> %x2)
  %r = or <2 x i8> %x1, %x2
  ret <2 x i8> %r
}

; Check variants of:
; and ({x}or X, Y), C --> {x}or X, (and Y, C)
; ...in the following 5 tests.

define i8 @and_or_hoist_mask(i8 %a, i8 %b) {
; CHECK-LABEL: @and_or_hoist_mask(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 [[A:%.*]], 6
; CHECK-NEXT:    [[B_MASKED:%.*]] = and i8 [[B:%.*]], 3
; CHECK-NEXT:    [[AND:%.*]] = or i8 [[SH]], [[B_MASKED]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %sh = lshr i8 %a, 6
  %or = or i8 %sh, %b
  %and = and i8 %or, 3
  ret i8 %and
}

define <2 x i8> @and_xor_hoist_mask_vec_splat(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @and_xor_hoist_mask_vec_splat(
; CHECK-NEXT:    [[SH:%.*]] = lshr <2 x i8> [[A:%.*]], <i8 6, i8 6>
; CHECK-NEXT:    [[B_MASKED:%.*]] = and <2 x i8> [[B:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[AND:%.*]] = xor <2 x i8> [[SH]], [[B_MASKED]]
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %sh = lshr <2 x i8> %a, <i8 6, i8 6>
  %xor = xor <2 x i8> %sh, %b
  %and = and <2 x i8> %xor, <i8 3, i8 3>
  ret <2 x i8> %and
}

define i8 @and_xor_hoist_mask_commute(i8 %a, i8 %b) {
; CHECK-LABEL: @and_xor_hoist_mask_commute(
; CHECK-NEXT:    [[C:%.*]] = mul i8 [[B:%.*]], 3
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 [[A:%.*]], 6
; CHECK-NEXT:    [[C_MASKED:%.*]] = and i8 [[C]], 3
; CHECK-NEXT:    [[AND:%.*]] = xor i8 [[C_MASKED]], [[SH]]
; CHECK-NEXT:    ret i8 [[AND]]
;
  %c = mul i8 %b, 43 ; thwart complexity-based ordering
  %sh = lshr i8 %a, 6
  %xor = xor i8 %c, %sh
  %and = and i8 %xor, 3
  ret i8 %and
}

define <2 x i8> @and_or_hoist_mask_commute_vec_splat(<2 x i8> %a, <2 x i8> %b) {
; CHECK-LABEL: @and_or_hoist_mask_commute_vec_splat(
; CHECK-NEXT:    [[C:%.*]] = mul <2 x i8> [[B:%.*]], <i8 3, i8 3>
; CHECK-NEXT:    [[SH:%.*]] = lshr <2 x i8> [[A:%.*]], <i8 6, i8 6>
; CHECK-NEXT:    [[C_MASKED:%.*]] = and <2 x i8> [[C]], <i8 3, i8 3>
; CHECK-NEXT:    [[AND:%.*]] = or <2 x i8> [[C_MASKED]], [[SH]]
; CHECK-NEXT:    ret <2 x i8> [[AND]]
;
  %c = mul <2 x i8> %b, <i8 43, i8 43> ; thwart complexity-based ordering
  %sh = lshr <2 x i8> %a, <i8 6, i8 6>
  %or = or <2 x i8> %c, %sh
  %and = and <2 x i8> %or, <i8 3, i8 3>
  ret <2 x i8> %and
}

; Don't transform if the 'or' has multiple uses because that would increase instruction count.

define i8 @and_or_do_not_hoist_mask(i8 %a, i8 %b) {
; CHECK-LABEL: @and_or_do_not_hoist_mask(
; CHECK-NEXT:    [[SH:%.*]] = lshr i8 [[A:%.*]], 6
; CHECK-NEXT:    [[OR:%.*]] = or i8 [[SH]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i8 [[OR]], 3
; CHECK-NEXT:    [[EXTRA_USE_OF_OR:%.*]] = mul i8 [[OR]], [[AND]]
; CHECK-NEXT:    ret i8 [[EXTRA_USE_OF_OR]]
;
  %sh = lshr i8 %a, 6
  %or = or i8 %sh, %b
  %and = and i8 %or, 3
  %extra_use_of_or = mul i8 %or, %and
  ret i8 %extra_use_of_or
}

define i64 @or_or_and_complex(i64 %i) {
; CHECK-LABEL: @or_or_and_complex(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[I:%.*]], 8
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[I]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP1]], 71777214294589695
; CHECK-NEXT:    [[TMP4:%.*]] = and i64 [[TMP2]], -71777214294589696
; CHECK-NEXT:    [[OR27:%.*]] = or i64 [[TMP3]], [[TMP4]]
; CHECK-NEXT:    ret i64 [[OR27]]
;
  %1 = lshr i64 %i, 8
  %shl = and i64 %1, 71776119061217280
  %2 = shl i64 %i, 8
  %shl3 = and i64 %2, -72057594037927936
  %or = or i64 %shl, %shl3
  %shl6 = and i64 %1, 1095216660480
  %or7 = or i64 %or, %shl6
  %shl10 = and i64 %2, 280375465082880
  %or11 = or i64 %or7, %shl10
  %shl14 = and i64 %1, 16711680
  %or15 = or i64 %or11, %shl14
  %shl18 = and i64 %2, 4278190080
  %or19 = or i64 %or15, %shl18
  %and21 = and i64 %1, 255
  %or23 = or i64 %or19, %and21
  %shl26 = and i64 %2, 65280
  %or27 = or i64 %or23, %shl26
  ret i64 %or27
}

; (C | (A & D)) | (A & B)
define i8 @or_or_and_noOneUse(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_noOneUse(
; CHECK-NEXT:    [[AND1:%.*]] = and i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @use(i8 [[AND1]])
; CHECK-NEXT:    [[AND2:%.*]] = and i8 [[A]], [[D:%.*]]
; CHECK-NEXT:    call void @use(i8 [[AND2]])
; CHECK-NEXT:    [[OR1:%.*]] = or i8 [[AND2]], [[C:%.*]]
; CHECK-NEXT:    call void @use(i8 [[OR1]])
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[OR1]], [[AND1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  call void @use(i8 %and1)
  %and2 = and i8 %a, %d
  call void @use(i8 %and2)
  %or1 = or i8 %c, %and2
  call void @use(i8 %or1)
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; (C | (A & D)) | (A & B)
define i8 @or_or_and_pat1(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat1(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %a, %d
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; (C | (D & A)) | (A & B)
define i8 @or_or_and_pat2(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat2(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %a
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; (C | (B & D)) | (A & B)
define i8 @or_or_and_pat3(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat3(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %b, %d
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; (C | (D & B)) | (A & B)
define i8 @or_or_and_pat4(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat4(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %b
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; ((A & D) | C) | (A & B)
define i8 @or_or_and_pat5(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat5(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP2]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %a, %d
  %or1 = or i8 %and2, %c
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; ((D & A) | C) | (A & B)
define i8 @or_or_and_pat6(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat6(
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %a
  %or1 = or i8 %and2, %c
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; ((B & D) | C) | (A & B)
define i8 @or_or_and_pat7(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat7(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP2]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %b, %d
  %or1 = or i8 %and2, %c
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; ((D & B) | C) | (A & B)
define i8 @or_or_and_pat8(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_or_and_pat8(
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %b
  %or1 = or i8 %and2, %c
  %or2 = or i8 %or1, %and1
  ret i8 %or2
}

; (A & B) | (C | (A & D))
define i8 @or_and_or_noOneUse(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_noOneUse(
; CHECK-NEXT:    [[AND1:%.*]] = and i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @use(i8 [[AND1]])
; CHECK-NEXT:    [[AND2:%.*]] = and i8 [[A]], [[D:%.*]]
; CHECK-NEXT:    call void @use(i8 [[AND2]])
; CHECK-NEXT:    [[OR1:%.*]] = or i8 [[AND2]], [[C:%.*]]
; CHECK-NEXT:    call void @use(i8 [[OR1]])
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[AND1]], [[OR1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  call void @use(i8 %and1)
  %and2 = and i8 %a, %d
  call void @use(i8 %and2)
  %or1 = or i8 %c, %and2
  call void @use(i8 %or1)
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | (C | (A & D))
define i8 @or_and_or_pat1(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat1(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %a, %d
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | (C | (D & A))
define i8 @or_and_or_pat2(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat2(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %a
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | (C | (B & D))
define i8 @or_and_or_pat3(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat3(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP2]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %b, %d
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | (C | (D & B))
define i8 @or_and_or_pat4(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat4(
; CHECK-NEXT:    [[CT:%.*]] = udiv i8 42, [[C:%.*]]
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[CT]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %ct = udiv i8 42, %c ; thwart complexity-based canonicalization
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %b
  %or1 = or i8 %ct, %and2
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | ((A & D) | C)
define i8 @or_and_or_pat5(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat5(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP2]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %a, %d
  %or1 = or i8 %and2, %c
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | ((D & A) | C)
define i8 @or_and_or_pat6(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat6(
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[A:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %a
  %or1 = or i8 %and2, %c
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | ((B & D) | C)
define i8 @or_and_or_pat7(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat7(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i8 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP2]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %b, %d
  %or1 = or i8 %and2, %c
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

; (A & B) | ((D & B) | C)
define i8 @or_and_or_pat8(i8 %a, i8 %b, i8 %c, i8 %d) {
; CHECK-LABEL: @or_and_or_pat8(
; CHECK-NEXT:    [[AND21:%.*]] = or i8 [[D:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[AND21]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i8 [[TMP1]], [[C:%.*]]
; CHECK-NEXT:    ret i8 [[OR2]]
;
  %and1 = and i8 %a, %b
  %and2 = and i8 %d, %b
  %or1 = or i8 %and2, %c
  %or2 = or i8 %and1, %or1
  ret i8 %or2
}

declare void @use2(i32)

define i32 @or_or_and_noOneUse_fail1(i32 %a, i32 %b) {
; CHECK-LABEL: @or_or_and_noOneUse_fail1(
; CHECK-NEXT:    [[SHR:%.*]] = ashr i32 [[A:%.*]], 23
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[SHR]], 157
; CHECK-NEXT:    call void @use2(i32 [[AND]])
; CHECK-NEXT:    [[AND1:%.*]] = or i32 [[B:%.*]], 157
; CHECK-NEXT:    [[OR:%.*]] = and i32 [[SHR]], [[AND1]]
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[B]], 23
; CHECK-NEXT:    [[AND9:%.*]] = and i32 [[TMP1]], 157
; CHECK-NEXT:    [[R:%.*]] = or i32 [[OR]], [[AND9]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %shr = ashr i32 %a, 23
  %conv = trunc i32 %shr to i8
  %conv1 = zext i8 %conv to i32
  %and = and i32 %conv1, 925
  call void @use2(i32 %and)
  %and3 = and i32 %shr, %b
  %or = or i32 %and3, %and
  %shr8 = ashr i32 %b, 23
  %and9 = and i32 %shr8, 157
  %r = or i32 %or, %and9
  ret i32 %r
}

define { i1, i1, i1, i1, i1 } @or_or_and_noOneUse_fail2(i1 %a_0, i1 %a_1, i1 %a_2, i1 %a_3, i1 %b_0, i1 %b_1, i1 %b_2, i1 %b_3) {
; CHECK-LABEL: @or_or_and_noOneUse_fail2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = and i1 [[A_0:%.*]], [[B_0:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i1 [[A_3:%.*]], [[B_3:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor i1 [[A_2:%.*]], [[B_2:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i1 [[A_1:%.*]], [[B_1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor i1 [[TMP3]], true
; CHECK-NEXT:    [[TMP5:%.*]] = and i1 [[TMP0]], [[A_1]]
; CHECK-NEXT:    [[TMP6:%.*]] = or i1 [[TMP2]], [[A_1]]
; CHECK-NEXT:    [[TMP7:%.*]] = and i1 [[TMP6]], [[B_1]]
; CHECK-NEXT:    [[D:%.*]] = or i1 [[TMP7]], [[TMP5]]
; CHECK-NEXT:    [[DOTNOT1:%.*]] = or i1 [[TMP1]], [[TMP3]]
; CHECK-NEXT:    [[TMP8:%.*]] = insertvalue { i1, i1, i1, i1, i1 } zeroinitializer, i1 [[D]], 0
; CHECK-NEXT:    [[TMP9:%.*]] = insertvalue { i1, i1, i1, i1, i1 } [[TMP8]], i1 [[TMP4]], 1
; CHECK-NEXT:    [[TMP10:%.*]] = insertvalue { i1, i1, i1, i1, i1 } [[TMP9]], i1 true, 2
; CHECK-NEXT:    [[TMP11:%.*]] = insertvalue { i1, i1, i1, i1, i1 } [[TMP10]], i1 [[A_3]], 3
; CHECK-NEXT:    [[TMP12:%.*]] = insertvalue { i1, i1, i1, i1, i1 } [[TMP11]], i1 [[DOTNOT1]], 4
; CHECK-NEXT:    ret { i1, i1, i1, i1, i1 } [[TMP12]]
;
entry:
  %0 = and i1 %a_0, %b_0
  %1 = and i1 %a_3, %b_3
  %2 = xor i1 %a_2, %b_2
  %3 = and i1 %a_1, %b_1
  %4 = xor i1 %3, true
  %5 = and i1 %0, %a_1
  %6 = and i1 %2, %b_1
  %7 = or i1 %3, %6
  %d = or i1 %7, %5
  %8 = xor i1 %d, true
  %9 = xor i1 %8, true
  %10 = xor i1 %1, true
  %11 = and i1 %10, %4
  %12 = xor i1 %11, true
  %13 = insertvalue { i1, i1, i1, i1, i1 } zeroinitializer, i1 %9, 0
  %14 = insertvalue { i1, i1, i1, i1, i1 } %13, i1 %4, 1
  %15 = insertvalue { i1, i1, i1, i1, i1 } %14, i1 true, 2
  %16 = insertvalue { i1, i1, i1, i1, i1 } %15, i1 %a_3, 3
  %17 = insertvalue { i1, i1, i1, i1, i1 } %16, i1 %12, 4
  ret { i1, i1, i1, i1, i1 } %17
}
