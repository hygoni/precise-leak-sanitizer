; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the wcslen library call simplifier works correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; Test behavior for wchar_size==2
!llvm.module.flags = !{!0}
!0 = !{i32 1, !"wchar_size", i32 2}

declare i64 @wcslen(ptr)

@hello = constant [6 x i16] [i16 104, i16 101, i16 108, i16 108, i16 111, i16 0]
@longer = constant [7 x i16] [i16 108, i16 111, i16 110, i16 103, i16 101, i16 114, i16 0]
@null = constant [1 x i16] zeroinitializer
@null_hello = constant [7 x i16] [i16 0, i16 104, i16 101, i16 108, i16 108, i16 111, i16 0]
@nullstring = constant i16 0
@a = common global [32 x i16] zeroinitializer, align 1
@null_hello_mid = constant [13 x i16] [i16 104, i16 101, i16 108, i16 108, i16 111, i16 32, i16 119, i16 111, i16 114, i16 0, i16 108, i16 100, i16 0]

define i64 @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    ret i64 5
;
  %hello_l = call i64 @wcslen(ptr @hello)
  ret i64 %hello_l
}

define i64 @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret i64 0
;
  %null_l = call i64 @wcslen(ptr @null)
  ret i64 %null_l
}

define i64 @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret i64 0
;
  %null_hello_l = call i64 @wcslen(ptr @null_hello)
  ret i64 %null_hello_l
}

define i64 @test_simplify4() {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    ret i64 0
;
  %len = tail call i64 @wcslen(ptr @nullstring) nounwind
  ret i64 %len
}

; Check wcslen(x) == 0 --> *x == 0.

define i1 @test_simplify5() {
; CHECK-LABEL: @test_simplify5(
; CHECK-NEXT:    ret i1 false
;
  %hello_l = call i64 @wcslen(ptr @hello)
  %eq_hello = icmp eq i64 %hello_l, 0
  ret i1 %eq_hello
}

define i1 @test_simplify6(ptr %str_p) {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i16, ptr [[STR_P:%.*]], align 2
; CHECK-NEXT:    [[EQ_NULL:%.*]] = icmp eq i16 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[EQ_NULL]]
;
  %str_l = call i64 @wcslen(ptr %str_p)
  %eq_null = icmp eq i64 %str_l, 0
  ret i1 %eq_null
}

; Check wcslen(x) != 0 --> *x != 0.

define i1 @test_simplify7() {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    ret i1 true
;
  %hello_l = call i64 @wcslen(ptr @hello)
  %ne_hello = icmp ne i64 %hello_l, 0
  ret i1 %ne_hello
}

define i1 @test_simplify8(ptr %str_p) {
; CHECK-LABEL: @test_simplify8(
; CHECK-NEXT:    [[CHAR0:%.*]] = load i16, ptr [[STR_P:%.*]], align 2
; CHECK-NEXT:    [[NE_NULL:%.*]] = icmp ne i16 [[CHAR0]], 0
; CHECK-NEXT:    ret i1 [[NE_NULL]]
;
  %str_l = call i64 @wcslen(ptr %str_p)
  %ne_null = icmp ne i64 %str_l, 0
  ret i1 %ne_null
}

define i64 @test_simplify9(i1 %x) {
; CHECK-LABEL: @test_simplify9(
; CHECK-NEXT:    [[L:%.*]] = select i1 [[X:%.*]], i64 5, i64 6
; CHECK-NEXT:    ret i64 [[L]]
;
  %s = select i1 %x, ptr @hello, ptr @longer
  %l = call i64 @wcslen(ptr %s)
  ret i64 %l
}

; Check the case that should be simplified to a sub instruction.
; wcslen(@hello + x) --> 5 - x

define i64 @test_simplify10(i16 %x) {
; CHECK-LABEL: @test_simplify10(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[X:%.*]] to i64
; CHECK-NEXT:    [[HELLO_L:%.*]] = sub nsw i64 5, [[TMP1]]
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %hello_p = getelementptr inbounds [6 x i16], ptr @hello, i16 0, i16 %x
  %hello_l = call i64 @wcslen(ptr %hello_p)
  ret i64 %hello_l
}

; wcslen(@null_hello_mid + (x & 7)) --> 9 - (x & 7)

define i64 @test_simplify11(i16 %x) {
; CHECK-LABEL: @test_simplify11(
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[X:%.*]], 7
; CHECK-NEXT:    [[NARROW:%.*]] = sub nuw nsw i16 9, [[AND]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = zext i16 [[NARROW]] to i64
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %and = and i16 %x, 7
  %hello_p = getelementptr inbounds [13 x i16], ptr @null_hello_mid, i16 0, i16 %and
  %hello_l = call i64 @wcslen(ptr %hello_p)
  ret i64 %hello_l
}

; Check cases that shouldn't be simplified.

define i64 @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[A_L:%.*]] = call i64 @wcslen(ptr nonnull @a)
; CHECK-NEXT:    ret i64 [[A_L]]
;
  %a_l = call i64 @wcslen(ptr @a)
  ret i64 %a_l
}

; wcslen(@null_hello + x) should not be simplified to a sub instruction.

define i64 @test_no_simplify2(i16 %x) {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i16 [[X:%.*]] to i64
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [7 x i16], ptr @null_hello, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i64 @wcslen(ptr nonnull [[HELLO_P]])
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %hello_p = getelementptr inbounds [7 x i16], ptr @null_hello, i16 0, i16 %x
  %hello_l = call i64 @wcslen(ptr %hello_p)
  ret i64 %hello_l
}

; wcslen(@null_hello_mid + (x & 15)) should not be simplified to a sub instruction.

define i64 @test_no_simplify3(i16 %x) {
; CHECK-LABEL: @test_no_simplify3(
; CHECK-NEXT:    [[AND:%.*]] = and i16 [[X:%.*]], 15
; CHECK-NEXT:    [[TMP1:%.*]] = zext i16 [[AND]] to i64
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [13 x i16], ptr @null_hello_mid, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i64 @wcslen(ptr nonnull [[HELLO_P]])
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %and = and i16 %x, 15
  %hello_p = getelementptr inbounds [13 x i16], ptr @null_hello_mid, i16 0, i16 %and
  %hello_l = call i64 @wcslen(ptr %hello_p)
  ret i64 %hello_l
}

@str32 = constant [1 x i32] [i32 0]

; This is safe to simplify despite the type mismatch.

define i64 @test_no_simplify4() {
; CHECK-LABEL: @test_no_simplify4(
; CHECK-NEXT:    ret i64 0
;
  %l = call i64 @wcslen(ptr @str32)
  ret i64 %l
}
