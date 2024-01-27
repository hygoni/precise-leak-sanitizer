; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -passes=loop-vectorize -force-vector-width=4 -force-vector-interleave=1 -S | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"

define void @same_step_and_size(ptr %a, i32* %b, i64 %n) {
; CHECK-LABEL: @same_step_and_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A2:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[B1:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i64 [[B1]], [[A2]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP0]], 16
; CHECK-NEXT:    br i1 [[DIFF_CHECK]], label %scalar.ph, label %vector.ph
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.a = getelementptr inbounds i32, ptr %a, i64 %iv
  %l = load i32, ptr %gep.a
  %mul = mul nsw i32 %l, 3
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %iv
  store i32 %mul, ptr %gep.b
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

define void @same_step_and_size_no_dominance_between_accesses(ptr %a, ptr %b, i64 %n, i64 %x) {
; CHECK-LABEL: @same_step_and_size_no_dominance_between_accesses(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B2:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[A1:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = sub i64 [[A1]], [[B2]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP0]], 16
; CHECK-NEXT:    br i1 [[DIFF_CHECK]], label %scalar.ph, label %vector.ph
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %cmp = icmp ne i64 %iv, %x
  br i1 %cmp, label %then, label %else

then:
  %gep.a = getelementptr inbounds i32, ptr %a, i64 %iv
  store i32 0, ptr %gep.a
  br label %loop.latch

else:
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %iv
  store i32 10, ptr %gep.b
  br label %loop.latch

loop.latch:
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

define void @different_steps_and_different_access_sizes(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @different_steps_and_different_access_sizes(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[N_SHL_2:%.]] = shl i64 %n, 2
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i8, ptr %b, i64 [[N_SHL_2]]
; CHECK-NEXT:    [[N_SHL_1:%.]] = shl i64 %n, 1
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr i8, ptr %a, i64 [[N_SHL_1]]
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult ptr %b, [[SCEVGEP4]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult ptr %a, [[SCEVGEP]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label %scalar.ph, label %vector.ph
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.a = getelementptr inbounds i16, ptr %a, i64 %iv
  %l = load i16, ptr %gep.a
  %l.ext = sext i16 %l to i32
  %mul = mul nsw i32 %l.ext, 3
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %iv
  store i32 %mul, ptr %gep.b
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

define void @steps_match_but_different_access_sizes_1(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @steps_match_but_different_access_sizes_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A2:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[B1:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add nuw i64 [[A2]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = sub i64 [[B1]], [[TMP0]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP1]], 16
; CHECK-NEXT:    br i1 [[DIFF_CHECK]], label %scalar.ph, label %vector.ph
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.a = getelementptr inbounds [2 x i16], ptr %a, i64 %iv, i64 1
  %l = load i16, ptr %gep.a
  %l.ext = sext i16 %l to i32
  %mul = mul nsw i32 %l.ext, 3
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %iv
  store i32 %mul, ptr %gep.b
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

; Same as @steps_match_but_different_access_sizes_1, but with source and sink
; accesses flipped.
define void @steps_match_but_different_access_sizes_2(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @steps_match_but_different_access_sizes_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B2:%.*]] = ptrtoint ptr [[B:%.*]] to i64
; CHECK-NEXT:    [[A1:%.*]] = ptrtoint ptr [[A:%.*]] to i64
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add nuw i64 [[A1]], 2
; CHECK-NEXT:    [[TMP1:%.*]] = sub i64 [[TMP0]], [[B2]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP1]], 16
; CHECK-NEXT:    br i1 [[DIFF_CHECK]], label %scalar.ph, label %vector.ph
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %iv
  %l = load i32, ptr %gep.b
  %mul = mul nsw i32 %l, 3
  %gep.a = getelementptr inbounds [2 x i16], ptr %a, i64 %iv, i64 1
  %trunc = trunc i32 %mul to i16
  store i16 %trunc, ptr %gep.a
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond = icmp eq i64 %iv.next, %n
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

; Full no-overlap checks are required instead of difference checks, as
; one of the add-recs used is invariant in the inner loop.
; Test case for PR57315.
define void @nested_loop_outer_iv_addrec_invariant_in_inner1(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @nested_loop_outer_iv_addrec_invariant_in_inner1(
; CHECK:        entry:
; CHECK-NEXT:    [[N_SHL_2:%.]] = shl i64 %n, 2
; CHECK-NEXT:    [[B_GEP_UPPER:%.*]] = getelementptr i8, ptr %b, i64 [[N_SHL_2]]
; CHECK-NEXT:    br label %outer

; CHECK:       outer.header:
; CHECK:         [[OUTER_IV_SHL_2:%.]] = shl i64 %outer.iv, 2
; CHECK-NEXT:    [[A_GEP_UPPER:%.*]] = getelementptr i8, ptr %a, i64 [[OUTER_IV_SHL_2]]
; CHECK-NEXT:    [[OUTER_IV_4:%.]] = add i64 [[OUTER_IV_SHL_2]], 4
; CHECK-NEXT:    [[A_GEP_UPPER_4:%.*]] = getelementptr i8, ptr %a, i64 [[OUTER_IV_4]]
; CHECK:         [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck

; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult ptr [[A_GEP_UPPER]], [[B_GEP_UPPER]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult ptr %b, [[A_GEP_UPPER_4]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label %scalar.ph, label %vector.ph
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ %outer.iv.next, %outer.latch ], [ 0, %entry ]
  %gep.a = getelementptr inbounds i32, ptr %a, i64 %outer.iv
  br label %inner.body

inner.body:
  %inner.iv = phi i64 [ 0, %outer.header ], [ %inner.iv.next, %inner.body ]
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %inner.iv
  %l = load i32, ptr %gep.b, align 4
  %sub = sub i32 %l, 10
  store i32 %sub, ptr %gep.a, align 4
  %inner.iv.next = add nuw nsw i64 %inner.iv, 1
  %inner.cond = icmp eq i64 %inner.iv.next, %n
  br i1 %inner.cond, label %outer.latch, label %inner.body

outer.latch:
  %outer.iv.next = add nuw nsw i64 %outer.iv, 1
  %outer.cond = icmp eq i64 %outer.iv.next, %n
  br i1 %outer.cond, label %exit, label %outer.header

exit:
  ret void
}

; Same as @nested_loop_outer_iv_addrec_invariant_in_inner1 but with dependence
; sink and source swapped.
define void @nested_loop_outer_iv_addrec_invariant_in_inner2(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @nested_loop_outer_iv_addrec_invariant_in_inner2(
; CHECK:        entry:
; CHECK-NEXT:    [[N_SHL_2:%.]] = shl i64 %n, 2
; CHECK-NEXT:    [[B_GEP_UPPER:%.*]] = getelementptr i8, ptr %b, i64 [[N_SHL_2]]
; CHECK-NEXT:    br label %outer

; CHECK:       outer.header:
; CHECK:         [[OUTER_IV_SHL_2:%.]] = shl i64 %outer.iv, 2
; CHECK-NEXT:    [[A_GEP_UPPER:%.*]] = getelementptr i8, ptr %a, i64 [[OUTER_IV_SHL_2]]
; CHECK-NEXT:    [[OUTER_IV_4:%.]] = add i64 [[OUTER_IV_SHL_2]], 4
; CHECK-NEXT:    [[A_GEP_UPPER_4:%.*]] = getelementptr i8, ptr %a, i64 [[OUTER_IV_4]]
; CHECK:         [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label %scalar.ph, label %vector.memcheck

; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult ptr %b, [[A_GEP_UPPER_4]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult ptr [[A_GEP_UPPER]], [[B_GEP_UPPER]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    br i1 [[FOUND_CONFLICT]], label %scalar.ph, label %vector.ph
;
entry:
  br label %outer.header

outer.header:
  %outer.iv = phi i64 [ %outer.iv.next, %outer.latch ], [ 0, %entry ]
  %gep.a = getelementptr inbounds i32, ptr %a, i64 %outer.iv
  br label %inner.body

inner.body:
  %inner.iv = phi i64 [ 0, %outer.header ], [ %inner.iv.next, %inner.body ]
  %l = load i32, ptr %gep.a, align 4
  %sub = sub i32 %l, 10
  %gep.b = getelementptr inbounds i32, ptr %b, i64 %inner.iv
  store i32 %sub, ptr %gep.b, align 4
  %inner.iv.next = add nuw nsw i64 %inner.iv, 1
  %inner.cond = icmp eq i64 %inner.iv.next, %n
  br i1 %inner.cond, label %outer.latch, label %inner.body

outer.latch:
  %outer.iv.next = add nuw nsw i64 %outer.iv, 1
  %outer.cond = icmp eq i64 %outer.iv.next, %n
  br i1 %outer.cond, label %exit, label %outer.header

exit:
  ret void
}
