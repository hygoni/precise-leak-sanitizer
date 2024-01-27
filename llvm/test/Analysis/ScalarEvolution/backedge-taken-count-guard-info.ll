; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py UTC_ARGS: --version 2
; RUN: opt -passes='print<scalar-evolution>' -disable-output %s 2>&1 | FileCheck %s

define void @loop_guard_improves_exact_backedge_taken_count_1(i32 %conv) {
; CHECK-LABEL: 'loop_guard_improves_exact_backedge_taken_count_1'
; CHECK-NEXT:  Classifying expressions for: @loop_guard_improves_exact_backedge_taken_count_1
; CHECK-NEXT:    %and = and i32 %conv, 1
; CHECK-NEXT:    --> (zext i1 (trunc i32 %conv to i1) to i32) U: [0,2) S: [0,2)
; CHECK-NEXT:    %conv8 = zext i32 %and to i64
; CHECK-NEXT:    --> (zext i1 (trunc i32 %conv to i1) to i64) U: [0,2) S: [0,2)
; CHECK-NEXT:    %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.next = add i64 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @loop_guard_improves_exact_backedge_taken_count_1
; CHECK-NEXT:  Loop %loop: backedge-taken count is 0
; CHECK-NEXT:  Loop %loop: constant max backedge-taken count is 0
; CHECK-NEXT:  Loop %loop: symbolic max backedge-taken count is 0
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is 0
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  %and = and i32 %conv, 1
  %conv8 = zext i32 %and to i64
  %c = icmp ugt i32 %and, 0
  br i1 %c, label %exit, label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  call void @clobber()
  %iv.next = add i64 %iv, 1
  %exitcond = icmp eq i64 %iv, %conv8
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

define void @loop_guard_improves_exact_backedge_taken_count_2(i32 %conv) {
; CHECK-LABEL: 'loop_guard_improves_exact_backedge_taken_count_2'
; CHECK-NEXT:  Classifying expressions for: @loop_guard_improves_exact_backedge_taken_count_2
; CHECK-NEXT:    %and = and i32 %conv, 1
; CHECK-NEXT:    --> (zext i1 (trunc i32 %conv to i1) to i32) U: [0,2) S: [0,2)
; CHECK-NEXT:    %conv8 = zext i32 %and to i64
; CHECK-NEXT:    --> (zext i1 (trunc i32 %conv to i1) to i64) U: [0,2) S: [0,2)
; CHECK-NEXT:    %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,2) S: [0,2) Exits: (zext i1 (trunc i32 %conv to i1) to i64) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.next = add i64 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,3) S: [1,3) Exits: (1 + (zext i1 (trunc i32 %conv to i1) to i64))<nuw><nsw> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @loop_guard_improves_exact_backedge_taken_count_2
; CHECK-NEXT:  Loop %loop: backedge-taken count is (zext i1 (trunc i32 %conv to i1) to i64)
; CHECK-NEXT:  Loop %loop: constant max backedge-taken count is 1
; CHECK-NEXT:  Loop %loop: symbolic max backedge-taken count is (zext i1 (trunc i32 %conv to i1) to i64)
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (zext i1 (trunc i32 %conv to i1) to i64)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 2
;
entry:
  %and = and i32 %conv, 1
  %conv8 = zext i32 %and to i64
  %c = icmp eq i32 %and, 1
  br i1 %c, label %loop, label %exit

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  call void @clobber()
  %iv.next = add i64 %iv, 1
  %exitcond = icmp eq i64 %iv, %conv8
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

declare void @clobber()
