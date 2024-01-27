; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i32 @callee()

declare void @use(i64)

define i64 @sext_sext_add(i32 %A) {
; CHECK-LABEL: @sext_sext_add(
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[A]], 9
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[B]], [[C]]
; CHECK-NEXT:    [[F:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i32 %A, 7
  %C = ashr i32 %A, 9
  %D = sext i32 %B to i64
  %E = sext i32 %C to i64
  %F = add i64 %D, %E
  ret i64 %F
}

; Negative test

define i64 @sext_zext_add_mismatched_exts(i32 %A) {
; CHECK-LABEL: @sext_zext_add_mismatched_exts(
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = lshr i32 [[A]], 9
; CHECK-NEXT:    [[D:%.*]] = sext i32 [[B]] to i64
; CHECK-NEXT:    [[E:%.*]] = zext i32 [[C]] to i64
; CHECK-NEXT:    [[F:%.*]] = add nsw i64 [[D]], [[E]]
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i32 %A, 7
  %C = lshr i32 %A, 9
  %D = sext i32 %B to i64
  %E = zext i32 %C to i64
  %F = add i64 %D, %E
  ret i64 %F
}

; Negative test

define i64 @sext_sext_add_mismatched_types(i16 %A, i32 %x) {
; CHECK-LABEL: @sext_sext_add_mismatched_types(
; CHECK-NEXT:    [[B:%.*]] = ashr i16 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[X:%.*]], 9
; CHECK-NEXT:    [[D:%.*]] = sext i16 [[B]] to i64
; CHECK-NEXT:    [[E:%.*]] = sext i32 [[C]] to i64
; CHECK-NEXT:    [[F:%.*]] = add nsw i64 [[D]], [[E]]
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i16 %A, 7
  %C = ashr i32 %x, 9
  %D = sext i16 %B to i64
  %E = sext i32 %C to i64
  %F = add i64 %D, %E
  ret i64 %F
}

define i64 @sext_sext_add_extra_use1(i32 %A) {
; CHECK-LABEL: @sext_sext_add_extra_use1(
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[A]], 9
; CHECK-NEXT:    [[D:%.*]] = sext i32 [[B]] to i64
; CHECK-NEXT:    call void @use(i64 [[D]])
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[B]], [[C]]
; CHECK-NEXT:    [[F:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i32 %A, 7
  %C = ashr i32 %A, 9
  %D = sext i32 %B to i64
  call void @use(i64 %D)
  %E = sext i32 %C to i64
  %F = add i64 %D, %E
  ret i64 %F
}

define i64 @sext_sext_add_extra_use2(i32 %A) {
; CHECK-LABEL: @sext_sext_add_extra_use2(
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[A]], 9
; CHECK-NEXT:    [[E:%.*]] = sext i32 [[C]] to i64
; CHECK-NEXT:    call void @use(i64 [[E]])
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[B]], [[C]]
; CHECK-NEXT:    [[F:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i32 %A, 7
  %C = ashr i32 %A, 9
  %D = sext i32 %B to i64
  %E = sext i32 %C to i64
  call void @use(i64 %E)
  %F = add i64 %D, %E
  ret i64 %F
}

; Negative test - if both extends have extra uses, we need an extra instruction.

define i64 @sext_sext_add_extra_use3(i32 %A) {
; CHECK-LABEL: @sext_sext_add_extra_use3(
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[A:%.*]], 7
; CHECK-NEXT:    [[C:%.*]] = ashr i32 [[A]], 9
; CHECK-NEXT:    [[D:%.*]] = sext i32 [[B]] to i64
; CHECK-NEXT:    call void @use(i64 [[D]])
; CHECK-NEXT:    [[E:%.*]] = sext i32 [[C]] to i64
; CHECK-NEXT:    call void @use(i64 [[E]])
; CHECK-NEXT:    [[F:%.*]] = add nsw i64 [[D]], [[E]]
; CHECK-NEXT:    ret i64 [[F]]
;
  %B = ashr i32 %A, 7
  %C = ashr i32 %A, 9
  %D = sext i32 %B to i64
  call void @use(i64 %D)
  %E = sext i32 %C to i64
  call void @use(i64 %E)
  %F = add i64 %D, %E
  ret i64 %F
}

define i64 @test1(i32 %V) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[NARROW:%.*]] = add nuw nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ADD:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %call1 = call i32 @callee(), !range !0
  %call2 = call i32 @callee(), !range !0
  %zext1 = sext i32 %call1 to i64
  %zext2 = sext i32 %call2 to i64
  %add = add i64 %zext1, %zext2
  ret i64 %add
}

define i64 @test2(i32 %V) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i32 [[ADD]] to i64
; CHECK-NEXT:    ret i64 [[ZEXT]]
;
  %call1 = call i32 @callee(), !range !0
  %call2 = call i32 @callee(), !range !0
  %add = add i32 %call1, %call2
  %zext = sext i32 %add to i64
  ret i64 %zext
}

define i64 @test3(i32 %V) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[NARROW:%.*]] = mul nuw nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ADD:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %call1 = call i32 @callee(), !range !0
  %call2 = call i32 @callee(), !range !0
  %zext1 = sext i32 %call1 to i64
  %zext2 = sext i32 %call2 to i64
  %add = mul i64 %zext1, %zext2
  ret i64 %add
}

define i64 @test4(i32 %V) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[ADD:%.*]] = mul nuw nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i32 [[ADD]] to i64
; CHECK-NEXT:    ret i64 [[ZEXT]]
;
  %call1 = call i32 @callee(), !range !0
  %call2 = call i32 @callee(), !range !0
  %add = mul i32 %call1, %call2
  %zext = sext i32 %add to i64
  ret i64 %zext
}

define i64 @test5(i32 %V) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[ASHR]], 1073741823
; CHECK-NEXT:    [[ADD:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %ashr = ashr i32 %V, 1
  %sext = sext i32 %ashr to i64
  %add = add i64 %sext, 1073741823
  ret i64 %add
}

; Negative test - extra use means we'd have more instructions than we started with.

define i64 @sext_add_constant_extra_use(i32 %V) {
; CHECK-LABEL: @sext_add_constant_extra_use(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[SEXT:%.*]] = sext i32 [[ASHR]] to i64
; CHECK-NEXT:    call void @use(i64 [[SEXT]])
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[SEXT]], 1073741823
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %ashr = ashr i32 %V, 1
  %sext = sext i32 %ashr to i64
  call void @use(i64 %sext)
  %add = add i64 %sext, 1073741823
  ret i64 %add
}

define <2 x i64> @test5_splat(<2 x i32> %V) {
; CHECK-LABEL: @test5_splat(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw <2 x i32> [[ASHR]], <i32 1073741823, i32 1073741823>
; CHECK-NEXT:    [[ADD:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %add = add <2 x i64> %sext, <i64 1073741823, i64 1073741823>
  ret <2 x i64> %add
}

define <2 x i64> @test5_vec(<2 x i32> %V) {
; CHECK-LABEL: @test5_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw <2 x i32> [[ASHR]], <i32 1, i32 2>
; CHECK-NEXT:    [[ADD:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %add = add <2 x i64> %sext, <i64 1, i64 2>
  ret <2 x i64> %add
}

define i64 @test6(i32 %V) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[ASHR]], -1073741824
; CHECK-NEXT:    [[ADD:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %ashr = ashr i32 %V, 1
  %sext = sext i32 %ashr to i64
  %add = add i64 %sext, -1073741824
  ret i64 %add
}

define <2 x i64> @test6_splat(<2 x i32> %V) {
; CHECK-LABEL: @test6_splat(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw <2 x i32> [[ASHR]], <i32 -1073741824, i32 -1073741824>
; CHECK-NEXT:    [[ADD:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %add = add <2 x i64> %sext, <i64 -1073741824, i64 -1073741824>
  ret <2 x i64> %add
}

define <2 x i64> @test6_vec(<2 x i32> %V) {
; CHECK-LABEL: @test6_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw <2 x i32> [[ASHR]], <i32 -1, i32 -2>
; CHECK-NEXT:    [[ADD:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %add = add <2 x i64> %sext, <i64 -1, i64 -2>
  ret <2 x i64> %add
}

define <2 x i64> @test6_vec2(<2 x i32> %V) {
; CHECK-LABEL: @test6_vec2(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw <2 x i32> [[ASHR]], <i32 -1, i32 1>
; CHECK-NEXT:    [[ADD:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %add = add <2 x i64> %sext, <i64 -1, i64 1>
  ret <2 x i64> %add
}

define i64 @test7(i32 %V) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[NARROW:%.*]] = add nuw i32 [[LSHR]], 2147483647
; CHECK-NEXT:    [[ADD:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %lshr = lshr i32 %V, 1
  %zext = zext i32 %lshr to i64
  %add = add i64 %zext, 2147483647
  ret i64 %add
}

define <2 x i64> @test7_splat(<2 x i32> %V) {
; CHECK-LABEL: @test7_splat(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nuw <2 x i32> [[LSHR]], <i32 2147483647, i32 2147483647>
; CHECK-NEXT:    [[ADD:%.*]] = zext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %lshr = lshr <2 x i32> %V, <i32 1, i32 1>
  %zext = zext <2 x i32> %lshr to <2 x i64>
  %add = add <2 x i64> %zext, <i64 2147483647, i64 2147483647>
  ret <2 x i64> %add
}

define <2 x i64> @test7_vec(<2 x i32> %V) {
; CHECK-LABEL: @test7_vec(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = add nuw <2 x i32> [[LSHR]], <i32 1, i32 2>
; CHECK-NEXT:    [[ADD:%.*]] = zext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[ADD]]
;
  %lshr = lshr <2 x i32> %V, <i32 1, i32 1>
  %zext = zext <2 x i32> %lshr to <2 x i64>
  %add = add <2 x i64> %zext, <i64 1, i64 2>
  ret <2 x i64> %add
}

define i64 @test8(i32 %V) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 16
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw i32 [[ASHR]], 32767
; CHECK-NEXT:    [[MUL:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %ashr = ashr i32 %V, 16
  %sext = sext i32 %ashr to i64
  %mul = mul i64 %sext, 32767
  ret i64 %mul
}

define <2 x i64> @test8_splat(<2 x i32> %V) {
; CHECK-LABEL: @test8_splat(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw <2 x i32> [[ASHR]], <i32 32767, i32 32767>
; CHECK-NEXT:    [[MUL:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %ashr = ashr <2 x i32> %V, <i32 16, i32 16>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %mul = mul <2 x i64> %sext, <i64 32767, i64 32767>
  ret <2 x i64> %mul
}

define <2 x i64> @test8_vec(<2 x i32> %V) {
; CHECK-LABEL: @test8_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw <2 x i32> [[ASHR]], <i32 32767, i32 16384>
; CHECK-NEXT:    [[MUL:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %ashr = ashr <2 x i32> %V, <i32 16, i32 16>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %mul = mul <2 x i64> %sext, <i64 32767, i64 16384>
  ret <2 x i64> %mul
}

define <2 x i64> @test8_vec2(<2 x i32> %V) {
; CHECK-LABEL: @test8_vec2(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw <2 x i32> [[ASHR]], <i32 32767, i32 -32767>
; CHECK-NEXT:    [[MUL:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %ashr = ashr <2 x i32> %V, <i32 16, i32 16>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %mul = mul <2 x i64> %sext, <i64 32767, i64 -32767>
  ret <2 x i64> %mul
}

define i64 @test9(i32 %V) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 16
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw i32 [[ASHR]], -32767
; CHECK-NEXT:    [[MUL:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %ashr = ashr i32 %V, 16
  %sext = sext i32 %ashr to i64
  %mul = mul i64 %sext, -32767
  ret i64 %mul
}

define <2 x i64> @test9_splat(<2 x i32> %V) {
; CHECK-LABEL: @test9_splat(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw <2 x i32> [[ASHR]], <i32 -32767, i32 -32767>
; CHECK-NEXT:    [[MUL:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %ashr = ashr <2 x i32> %V, <i32 16, i32 16>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %mul = mul <2 x i64> %sext, <i64 -32767, i64 -32767>
  ret <2 x i64> %mul
}

define <2 x i64> @test9_vec(<2 x i32> %V) {
; CHECK-LABEL: @test9_vec(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw <2 x i32> [[ASHR]], <i32 -32767, i32 -10>
; CHECK-NEXT:    [[MUL:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %ashr = ashr <2 x i32> %V, <i32 16, i32 16>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %mul = mul <2 x i64> %sext, <i64 -32767, i64 -10>
  ret <2 x i64> %mul
}

define i64 @test10(i32 %V) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr i32 [[V:%.*]], 16
; CHECK-NEXT:    [[NARROW:%.*]] = mul nuw i32 [[LSHR]], 65535
; CHECK-NEXT:    [[MUL:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[MUL]]
;
  %lshr = lshr i32 %V, 16
  %zext = zext i32 %lshr to i64
  %mul = mul i64 %zext, 65535
  ret i64 %mul
}

define <2 x i64> @test10_splat(<2 x i32> %V) {
; CHECK-LABEL: @test10_splat(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nuw <2 x i32> [[LSHR]], <i32 65535, i32 65535>
; CHECK-NEXT:    [[MUL:%.*]] = zext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %lshr = lshr <2 x i32> %V, <i32 16, i32 16>
  %zext = zext <2 x i32> %lshr to <2 x i64>
  %mul = mul <2 x i64> %zext, <i64 65535, i64 65535>
  ret <2 x i64> %mul
}

define <2 x i64> @test10_vec(<2 x i32> %V) {
; CHECK-LABEL: @test10_vec(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> [[V:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[NARROW:%.*]] = mul nuw <2 x i32> [[LSHR]], <i32 65535, i32 2>
; CHECK-NEXT:    [[MUL:%.*]] = zext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[MUL]]
;
  %lshr = lshr <2 x i32> %V, <i32 16, i32 16>
  %zext = zext <2 x i32> %lshr to <2 x i64>
  %mul = mul <2 x i64> %zext, <i64 65535, i64 2>
  ret <2 x i64> %mul
}

define i64 @test11(i32 %V) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG1]]
; CHECK-NEXT:    [[NARROW:%.*]] = add nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ADD:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %call1 = call i32 @callee(), !range !1
  %call2 = call i32 @callee(), !range !1
  %sext1 = sext i32 %call1 to i64
  %sext2 = sext i32 %call2 to i64
  %add = add i64 %sext1, %sext2
  ret i64 %add
}

define i64 @test12(i32 %V) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG1]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG1]]
; CHECK-NEXT:    [[NARROW:%.*]] = mul nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[ADD:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[ADD]]
;
  %call1 = call i32 @callee(), !range !1
  %call2 = call i32 @callee(), !range !1
  %sext1 = sext i32 %call1 to i64
  %sext2 = sext i32 %call2 to i64
  %add = mul i64 %sext1, %sext2
  ret i64 %add
}

define i64 @test13(i32 %V) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG3:![0-9]+]]
; CHECK-NEXT:    [[NARROW:%.*]] = sub nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[SUB:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %call1 = call i32 @callee(), !range !2
  %call2 = call i32 @callee(), !range !3
  %sext1 = sext i32 %call1 to i64
  %sext2 = sext i32 %call2 to i64
  %sub = sub i64 %sext1, %sext2
  ret i64 %sub
}

define i64 @test14(i32 %V) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG2]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[NARROW:%.*]] = sub nuw nsw i32 [[CALL1]], [[CALL2]]
; CHECK-NEXT:    [[SUB:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %call1 = call i32 @callee(), !range !2
  %call2 = call i32 @callee(), !range !0
  %zext1 = zext i32 %call1 to i64
  %zext2 = zext i32 %call2 to i64
  %sub = sub i64 %zext1, %zext2
  ret i64 %sub
}

define i64 @test15(i32 %V) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[NARROW:%.*]] = sub nsw i32 8, [[ASHR]]
; CHECK-NEXT:    [[SUB:%.*]] = sext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %ashr = ashr i32 %V, 1
  %sext = sext i32 %ashr to i64
  %sub = sub i64 8, %sext
  ret i64 %sub
}

define <2 x i64> @test15vec(<2 x i32> %V) {
; CHECK-LABEL: @test15vec(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = sub nsw <2 x i32> <i32 8, i32 8>, [[ASHR]]
; CHECK-NEXT:    [[SUB:%.*]] = sext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %ashr = ashr <2 x i32> %V, <i32 1, i32 1>
  %sext = sext <2 x i32> %ashr to <2 x i64>
  %sub = sub <2 x i64> <i64 8, i64 8>, %sext
  ret <2 x i64> %sub
}

define i64 @test16(i32 %V) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr i32 [[V:%.*]], 1
; CHECK-NEXT:    [[NARROW:%.*]] = sub nuw i32 -2, [[LSHR]]
; CHECK-NEXT:    [[SUB:%.*]] = zext i32 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %lshr = lshr i32 %V, 1
  %zext = zext i32 %lshr to i64
  %sub = sub i64 4294967294, %zext
  ret i64 %sub
}

define <2 x i64> @test16vec(<2 x i32> %V) {
; CHECK-LABEL: @test16vec(
; CHECK-NEXT:    [[LSHR:%.*]] = lshr <2 x i32> [[V:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[NARROW:%.*]] = sub nuw <2 x i32> <i32 -2, i32 -2>, [[LSHR]]
; CHECK-NEXT:    [[SUB:%.*]] = zext <2 x i32> [[NARROW]] to <2 x i64>
; CHECK-NEXT:    ret <2 x i64> [[SUB]]
;
  %lshr = lshr <2 x i32> %V, <i32 1, i32 1>
  %zext = zext <2 x i32> %lshr to <2 x i64>
  %sub = sub <2 x i64> <i64 4294967294, i64 4294967294>, %zext
  ret <2 x i64> %sub
}

; Negative test. Both have the same range so we can't guarantee the subtract
; won't wrap.
define i64 @test17(i32 %V) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[CALL2:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[SEXT1:%.*]] = zext i32 [[CALL1]] to i64
; CHECK-NEXT:    [[SEXT2:%.*]] = zext i32 [[CALL2]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i64 [[SEXT1]], [[SEXT2]]
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %call1 = call i32 @callee(), !range !0
  %call2 = call i32 @callee(), !range !0
  %sext1 = zext i32 %call1 to i64
  %sext2 = zext i32 %call2 to i64
  %sub = sub i64 %sext1, %sext2
  ret i64 %sub
}

; Negative test. LHS is large positive 32-bit number. Range of callee can
; cause overflow.
define i64 @test18(i32 %V) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG1]]
; CHECK-NEXT:    [[SEXT1:%.*]] = sext i32 [[CALL1]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i64 2147481648, [[SEXT1]]
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %call1 = call i32 @callee(), !range !1
  %sext1 = sext i32 %call1 to i64
  %sub = sub i64 2147481648, %sext1
  ret i64 %sub
}

; Negative test. LHS is large negative 32-bit number. Range of callee can
; cause overflow.
define i64 @test19(i32 %V) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @callee(), !range [[RNG0]]
; CHECK-NEXT:    [[SEXT1:%.*]] = zext i32 [[CALL1]] to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub nuw nsw i64 -2147481648, [[SEXT1]]
; CHECK-NEXT:    ret i64 [[SUB]]
;
  %call1 = call i32 @callee(), !range !0
  %sext1 = sext i32 %call1 to i64
  %sub = sub i64 -2147481648, %sext1
  ret i64 %sub
}

!0 = !{ i32 0, i32 2000 }
!1 = !{ i32 -2000, i32 0 }
!2 = !{ i32 -512, i32 -255 }
!3 = !{ i32 -128, i32 0 }
