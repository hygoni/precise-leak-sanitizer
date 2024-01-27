; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare i64 @llvm.cttz.i64(i64, i1)

declare i64 @llvm.ctlz.i64(i64, i1)

declare <8 x i64> @llvm.cttz.v8i64(<8 x i64>, i1)

define i32 @test0(i64 %x) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.cttz.i64(i64 [[X]], i1 true), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[CTZ32:%.*]] = trunc i64 [[CTZ]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[CTZ32]], [[NON_ZERO]] ], [ 0, [[START:%.*]] ]
; CHECK-NEXT:    ret i32 [[RES]]
;
start:
  %c = icmp eq i64 %x, 0
  br i1 %c, label %exit, label %non_zero

non_zero:
  %ctz = call i64 @llvm.cttz.i64(i64 %x, i1 false)
  %ctz32 = trunc i64 %ctz to i32
  br label %exit

exit:
  %res = phi i32 [ %ctz32, %non_zero ], [ 0, %start ]
  ret i32 %res
}

define i32 @test1(i64 %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    [[CTZ32:%.*]] = trunc i64 [[CTZ]] to i32
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi i32 [ [[CTZ32]], [[NON_ZERO]] ], [ 0, [[START:%.*]] ]
; CHECK-NEXT:    ret i32 [[RES]]
;
start:
  %c = icmp eq i64 %x, 0
  br i1 %c, label %exit, label %non_zero

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  %ctz32 = trunc i64 %ctz to i32
  br label %exit

exit:
  %res = phi i32 [ %ctz32, %non_zero ], [ 0, %start ]
  ret i32 %res
}

define <8 x i64> @test2(<8 x i64> %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[A:%.*]] = icmp eq <8 x i64> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[B:%.*]] = bitcast <8 x i1> [[A]] to i8
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[B]], 0
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call <8 x i64> @llvm.cttz.v8i64(<8 x i64> [[X]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = phi <8 x i64> [ [[CTZ]], [[NON_ZERO]] ], [ zeroinitializer, [[START:%.*]] ]
; CHECK-NEXT:    ret <8 x i64> [[RES]]
;
start:
  %a = icmp eq <8 x i64> %x, zeroinitializer
  %b = bitcast <8 x i1> %a to i8
  %c = icmp eq i8 %b, 0
  br i1 %c, label %exit, label %non_zero

non_zero:
  ; NB: We cannot determine that vectors are known to be zero based
  ; on the dominating condition
  %ctz = call <8 x i64> @llvm.cttz.v8i64(<8 x i64> %x, i1 false)
  br label %exit

exit:
  %res = phi <8 x i64> [ %ctz, %non_zero ], [ zeroinitializer, %start ]
  ret <8 x i64> %res
}

; Test that exposed a bug in the PHI handling after D60846. No folding should happen here!
define void @D60846_miscompile(ptr %p) {
; CHECK-LABEL: @D60846_miscompile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[I:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[I_INC:%.*]], [[COMMON:%.*]] ]
; CHECK-NEXT:    [[IS_ZERO:%.*]] = icmp eq i16 [[I]], 0
; CHECK-NEXT:    br i1 [[IS_ZERO]], label [[COMMON]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[IS_ONE:%.*]] = icmp eq i16 [[I]], 1
; CHECK-NEXT:    store i1 [[IS_ONE]], ptr [[P:%.*]], align 1
; CHECK-NEXT:    br label [[COMMON]]
; CHECK:       common:
; CHECK-NEXT:    [[I_INC]] = add i16 [[I]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i16 [[I_INC]], 2
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                             ; preds = %common, %entry
  %i = phi i16 [ 0, %entry ], [ %i.inc, %common ]
  %is_zero = icmp eq i16 %i, 0
  br i1 %is_zero, label %common, label %non_zero

non_zero:                                         ; preds = %loop
  %is_one = icmp eq i16 %i, 1
  store i1 %is_one, ptr %p
  br label %common

common:                                           ; preds = %non_zero, %loop
  %i.inc = add i16 %i, 1
  %loop_cond = icmp ult i16 %i.inc, 2
  br i1 %loop_cond, label %loop, label %exit

exit:                                             ; preds = %common
  ret void
}

define i64 @test_sgt_zero(i64 %x) {
; CHECK-LABEL: @test_sgt_zero(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i64 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[NON_ZERO:%.*]], label [[EXIT:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp sgt i64 %x, 0
  br i1 %c, label %non_zero, label %exit

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_slt_neg_ten(i64 %x) {
; CHECK-LABEL: @test_slt_neg_ten(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp slt i64 [[X:%.*]], -10
; CHECK-NEXT:    br i1 [[C]], label [[NON_ZERO:%.*]], label [[EXIT:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp slt i64 %x, -10
  br i1 %c, label %non_zero, label %exit

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_slt_ten(i64 %x) {
; CHECK-LABEL: @test_slt_ten(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp slt i64 [[X:%.*]], 10
; CHECK-NEXT:    br i1 [[C]], label [[MAYBE_ZERO:%.*]], label [[EXIT:%.*]]
; CHECK:       maybe_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp slt i64 %x, 10
  br i1 %c, label %maybe_zero, label %exit

maybe_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_ugt_unknown(i64 %x, i64 %y) {
; CHECK-LABEL: @test_ugt_unknown(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[NON_ZERO:%.*]], label [[EXIT:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp ugt i64 %x, %y
  br i1 %c, label %non_zero, label %exit

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_sle_zero(i64 %x) {
; CHECK-LABEL: @test_sle_zero(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp slt i64 [[X:%.*]], 1
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp sle i64 %x, 0
  br i1 %c, label %exit, label %non_zero

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_sge_neg_ten(i64 %x) {
; CHECK-LABEL: @test_sge_neg_ten(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i64 [[X:%.*]], -11
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[NON_ZERO:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp sge i64 %x, -10
  br i1 %c, label %exit, label %non_zero

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_sge_ten(i64 %x) {
; CHECK-LABEL: @test_sge_ten(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i64 [[X:%.*]], 9
; CHECK-NEXT:    br i1 [[C]], label [[EXIT:%.*]], label [[MAYBE_ZERO:%.*]]
; CHECK:       maybe_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 false), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp sge i64 %x, 10
  br i1 %c, label %exit, label %maybe_zero

maybe_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}

define i64 @test_ule_unknown(i64 %x, i64 %y) {
; CHECK-LABEL: @test_ule_unknown(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[C_NOT:%.*]] = icmp ugt i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C_NOT]], label [[NON_ZERO:%.*]], label [[EXIT:%.*]]
; CHECK:       non_zero:
; CHECK-NEXT:    [[CTZ:%.*]] = call i64 @llvm.ctlz.i64(i64 [[X]], i1 true), !range [[RNG0]]
; CHECK-NEXT:    ret i64 [[CTZ]]
; CHECK:       exit:
; CHECK-NEXT:    ret i64 -1
;
start:
  %c = icmp ule i64 %x, %y
  br i1 %c, label %exit, label %non_zero

non_zero:
  %ctz = call i64 @llvm.ctlz.i64(i64 %x, i1 false)
  ret i64 %ctz

exit:
  ret i64 -1
}
