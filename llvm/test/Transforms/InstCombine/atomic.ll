; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -passes=instcombine | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"
target triple = "x86_64-apple-macosx10.7.0"

; Check transforms involving atomic operations

define i32 @test1(ptr %p) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p seq_cst, align 4
  %y = load i32, ptr %p, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

define i32 @test2(ptr %p) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[Y:%.*]] = load volatile i32, ptr [[P]], align 4
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load volatile i32, ptr %p, align 4
  %y = load volatile i32, ptr %p, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; The exact semantics of mixing volatile and non-volatile on the same
; memory location are a bit unclear, but conservatively, we know we don't
; want to remove the volatile.
define i32 @test3(ptr %p) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[X:%.*]] = load volatile i32, ptr [[P:%.*]], align 4
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load volatile i32, ptr %p, align 4
  %y = load i32, ptr %p, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; Forwarding from a stronger ordered atomic is fine
define i32 @test4(ptr %p) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p seq_cst, align 4
  %y = load atomic i32, ptr %p unordered, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; Forwarding from a non-atomic is not.  (The earlier load
; could in priciple be promoted to atomic and then forwarded,
; but we can't just  drop the atomic from the load.)
define i32 @test5(ptr %p) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p unordered, align 4
  %y = load i32, ptr %p, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; Forwarding atomic to atomic is fine
define i32 @test6(ptr %p) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    [[Z:%.*]] = shl i32 [[X]], 1
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p unordered, align 4
  %y = load atomic i32, ptr %p unordered, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; FIXME: we currently don't do anything for monotonic
define i32 @test7(ptr %p) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[Y:%.*]] = load atomic i32, ptr [[P]] monotonic, align 4
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p seq_cst, align 4
  %y = load atomic i32, ptr %p monotonic, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; FIXME: We could forward in racy code
define i32 @test8(ptr %p) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    [[Y:%.*]] = load atomic i32, ptr [[P]] acquire, align 4
; CHECK-NEXT:    [[Z:%.*]] = add i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i32 [[Z]]
;
  %x = load atomic i32, ptr %p seq_cst, align 4
  %y = load atomic i32, ptr %p acquire, align 4
  %z = add i32 %x, %y
  ret i32 %z
}

; An unordered access to null is still unreachable.  There's no
; ordering imposed.
define i32 @test9() {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    store i1 true, ptr poison, align 1
; CHECK-NEXT:    ret i32 poison
;
  %x = load atomic i32, ptr null unordered, align 4
  ret i32 %x
}

define i32 @test9_no_null_opt() #0 {
; CHECK-LABEL: @test9_no_null_opt(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr null unordered, align 4294967296
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = load atomic i32, ptr null unordered, align 4
  ret i32 %x
}

; FIXME: Could also fold
define i32 @test10() {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr null monotonic, align 4294967296
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = load atomic i32, ptr null monotonic, align 4
  ret i32 %x
}

define i32 @test10_no_null_opt() #0 {
; CHECK-LABEL: @test10_no_null_opt(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr null monotonic, align 4294967296
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = load atomic i32, ptr null monotonic, align 4
  ret i32 %x
}

; Would this be legal to fold?  Probably?
define i32 @test11() {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr null seq_cst, align 4294967296
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = load atomic i32, ptr null seq_cst, align 4
  ret i32 %x
}

define i32 @test11_no_null_opt() #0 {
; CHECK-LABEL: @test11_no_null_opt(
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr null seq_cst, align 4294967296
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = load atomic i32, ptr null seq_cst, align 4
  ret i32 %x
}

; An unordered access to null is still unreachable.  There's no
; ordering imposed.
define i32 @test12() {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    store atomic i32 poison, ptr null unordered, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null unordered, align 4
  ret i32 0
}

define i32 @test12_no_null_opt() #0 {
; CHECK-LABEL: @test12_no_null_opt(
; CHECK-NEXT:    store atomic i32 0, ptr null unordered, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null unordered, align 4
  ret i32 0
}

; FIXME: Could also fold
define i32 @test13() {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    store atomic i32 0, ptr null monotonic, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null monotonic, align 4
  ret i32 0
}

define i32 @test13_no_null_opt() #0 {
; CHECK-LABEL: @test13_no_null_opt(
; CHECK-NEXT:    store atomic i32 0, ptr null monotonic, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null monotonic, align 4
  ret i32 0
}

; Would this be legal to fold?  Probably?
define i32 @test14() {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    store atomic i32 0, ptr null seq_cst, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null seq_cst, align 4
  ret i32 0
}

define i32 @test14_no_null_opt() #0 {
; CHECK-LABEL: @test14_no_null_opt(
; CHECK-NEXT:    store atomic i32 0, ptr null seq_cst, align 4294967296
; CHECK-NEXT:    ret i32 0
;
  store atomic i32 0, ptr null seq_cst, align 4
  ret i32 0
}

@a = external global i32
@b = external global i32

define i32 @test15(i1 %cnd) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[A_VAL:%.*]] = load atomic i32, ptr @a unordered, align 4
; CHECK-NEXT:    [[B_VAL:%.*]] = load atomic i32, ptr @b unordered, align 4
; CHECK-NEXT:    [[X:%.*]] = select i1 [[CND:%.*]], i32 [[A_VAL]], i32 [[B_VAL]]
; CHECK-NEXT:    ret i32 [[X]]
;
  %addr = select i1 %cnd, ptr @a, ptr @b
  %x = load atomic i32, ptr %addr unordered, align 4
  ret i32 %x
}

; FIXME: This would be legal to transform
define i32 @test16(i1 %cnd) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[ADDR:%.*]] = select i1 [[CND:%.*]], ptr @a, ptr @b
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[ADDR]] monotonic, align 4
; CHECK-NEXT:    ret i32 [[X]]
;
  %addr = select i1 %cnd, ptr @a, ptr @b
  %x = load atomic i32, ptr %addr monotonic, align 4
  ret i32 %x
}

; FIXME: This would be legal to transform
define i32 @test17(i1 %cnd) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    [[ADDR:%.*]] = select i1 [[CND:%.*]], ptr @a, ptr @b
; CHECK-NEXT:    [[X:%.*]] = load atomic i32, ptr [[ADDR]] seq_cst, align 4
; CHECK-NEXT:    ret i32 [[X]]
;
  %addr = select i1 %cnd, ptr @a, ptr @b
  %x = load atomic i32, ptr %addr seq_cst, align 4
  ret i32 %x
}

define i32 @test22(i1 %cnd) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BLOCK1:%.*]], label [[BLOCK2:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       block2:
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32 [ 2, [[BLOCK2]] ], [ 1, [[BLOCK1]] ]
; CHECK-NEXT:    store atomic i32 [[STOREMERGE]], ptr @a unordered, align 4
; CHECK-NEXT:    ret i32 0
;
  br i1 %cnd, label %block1, label %block2

block1:
  store atomic i32 1, ptr @a unordered, align 4
  br label %merge
block2:
  store atomic i32 2, ptr @a unordered, align 4
  br label %merge

merge:
  ret i32 0
}

; TODO: probably also legal here
define i32 @test23(i1 %cnd) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[BLOCK1:%.*]], label [[BLOCK2:%.*]]
; CHECK:       block1:
; CHECK-NEXT:    store atomic i32 1, ptr @a monotonic, align 4
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       block2:
; CHECK-NEXT:    store atomic i32 2, ptr @a monotonic, align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret i32 0
;
  br i1 %cnd, label %block1, label %block2

block1:
  store atomic i32 1, ptr @a monotonic, align 4
  br label %merge
block2:
  store atomic i32 2, ptr @a monotonic, align 4
  br label %merge

merge:
  ret i32 0
}

declare void @clobber()

define i32 @test18(ptr %p) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[X:%.*]] = load atomic float, ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    store atomic float [[X]], ptr [[P]] unordered, align 4
; CHECK-NEXT:    ret i32 0
;
  %x = load atomic float, ptr %p unordered, align 4
  call void @clobber() ;; keep the load around
  store atomic float %x, ptr %p unordered, align 4
  ret i32 0
}

; TODO: probably also legal in this case
define i32 @test19(ptr %p) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[X:%.*]] = load atomic float, ptr [[P:%.*]] seq_cst, align 4
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    store atomic float [[X]], ptr [[P]] seq_cst, align 4
; CHECK-NEXT:    ret i32 0
;
  %x = load atomic float, ptr %p seq_cst, align 4
  call void @clobber() ;; keep the load around
  store atomic float %x, ptr %p seq_cst, align 4
  ret i32 0
}

define i32 @test20(ptr %p, ptr %v) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    store atomic ptr [[V:%.*]], ptr [[P:%.*]] unordered, align 4
; CHECK-NEXT:    ret i32 0
;
  store atomic ptr %v, ptr %p unordered, align 4
  ret i32 0
}

define i32 @test21(ptr %p, ptr %v) {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    store atomic ptr [[V:%.*]], ptr [[P:%.*]] monotonic, align 4
; CHECK-NEXT:    ret i32 0
;
  store atomic ptr %v, ptr %p monotonic, align 4
  ret i32 0
}

define void @pr27490a(ptr %p1, ptr %p2) {
; CHECK-LABEL: @pr27490a(
; CHECK-NEXT:    [[L:%.*]] = load ptr, ptr [[P1:%.*]], align 8
; CHECK-NEXT:    store volatile ptr [[L]], ptr [[P2:%.*]], align 8
; CHECK-NEXT:    ret void
;
  %l = load ptr, ptr %p1
  store volatile ptr %l, ptr %p2
  ret void
}

define void @pr27490b(ptr %p1, ptr %p2) {
; CHECK-LABEL: @pr27490b(
; CHECK-NEXT:    [[L:%.*]] = load ptr, ptr [[P1:%.*]], align 8
; CHECK-NEXT:    store atomic ptr [[L]], ptr [[P2:%.*]] seq_cst, align 8
; CHECK-NEXT:    ret void
;
  %l = load ptr, ptr %p1
  store atomic ptr %l, ptr %p2 seq_cst, align 8
  ret void
}

;; At the moment, we can't form atomic vectors by folding since these are
;; not representable in the IR.  This was pr29121.  The right long term
;; solution is to extend the IR to handle this case.
define <2 x float> @no_atomic_vector_load(ptr %p) {
; CHECK-LABEL: @no_atomic_vector_load(
; CHECK-NEXT:    [[LOAD:%.*]] = load atomic i64, ptr [[P:%.*]] unordered, align 8
; CHECK-NEXT:    [[DOTCAST:%.*]] = bitcast i64 [[LOAD]] to <2 x float>
; CHECK-NEXT:    ret <2 x float> [[DOTCAST]]
;
  %load = load atomic i64, ptr %p unordered, align 8
  %.cast = bitcast i64 %load to <2 x float>
  ret <2 x float> %.cast
}

define void @no_atomic_vector_store(<2 x float> %p, ptr %p2) {
; CHECK-LABEL: @no_atomic_vector_store(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast <2 x float> [[P:%.*]] to i64
; CHECK-NEXT:    store atomic i64 [[TMP1]], ptr [[P2:%.*]] unordered, align 8
; CHECK-NEXT:    ret void
;
  %1 = bitcast <2 x float> %p to i64
  store atomic i64 %1, ptr %p2 unordered, align 8
  ret void
}

@c = constant i32 42
@g = global i32 42

define i32 @atomic_load_from_constant_global() {
; CHECK-LABEL: @atomic_load_from_constant_global(
; CHECK-NEXT:    ret i32 42
;
  %v = load atomic i32, ptr @c seq_cst, align 4
  ret i32 %v
}

define i8 @atomic_load_from_constant_global_bitcast() {
; CHECK-LABEL: @atomic_load_from_constant_global_bitcast(
; CHECK-NEXT:    ret i8 42
;
  %v = load atomic i8, ptr @c seq_cst, align 1
  ret i8 %v
}

define void @atomic_load_from_non_constant_global() {
; CHECK-LABEL: @atomic_load_from_non_constant_global(
; CHECK-NEXT:    [[TMP1:%.*]] = load atomic i32, ptr @g seq_cst, align 4
; CHECK-NEXT:    ret void
;
  load atomic i32, ptr @g seq_cst, align 4
  ret void
}

define void @volatile_load_from_constant_global() {
; CHECK-LABEL: @volatile_load_from_constant_global(
; CHECK-NEXT:    [[TMP1:%.*]] = load volatile i32, ptr @c, align 4
; CHECK-NEXT:    ret void
;
  load volatile i32, ptr @c, align 4
  ret void
}

attributes #0 = { null_pointer_is_valid }
