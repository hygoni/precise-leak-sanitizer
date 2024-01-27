; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simple-loop-unswitch-inject-invariant-conditions=true -passes='loop(simple-loop-unswitch<nontrivial>,loop-instsimplify)' -S | FileCheck %s

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[TMP1:%.*]] = load atomic i32, ptr addrspace(1) poison unordered, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load atomic i32, ptr addrspace(1) poison unordered, align 8
; CHECK-NEXT:    br i1 [[TMP]], label [[BB_SPLIT:%.*]], label [[BB3_SPLIT_US:%.*]]
; CHECK:       bb.split:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB3_SPLIT:%.*]]
; CHECK:       bb3.split.us:
; CHECK-NEXT:    br label [[BB4_US:%.*]]
; CHECK:       bb4.us:
; CHECK-NEXT:    [[TMP5_US:%.*]] = phi i32 [ poison, [[BB3_SPLIT_US]] ]
; CHECK-NEXT:    [[TMP6_US:%.*]] = phi i32 [ poison, [[BB3_SPLIT_US]] ]
; CHECK-NEXT:    [[TMP7_US:%.*]] = add nuw nsw i32 [[TMP6_US]], 2
; CHECK-NEXT:    [[TMP8_US:%.*]] = icmp ult i32 [[TMP7_US]], [[TMP2]]
; CHECK-NEXT:    br i1 [[TMP8_US]], label [[BB9_US:%.*]], label [[BB16_SPLIT_US:%.*]], !prof [[PROF0:![0-9]+]]
; CHECK:       bb9.us:
; CHECK-NEXT:    br label [[BB17_SPLIT_US:%.*]]
; CHECK:       bb16.split.us:
; CHECK-NEXT:    br label [[BB16:%.*]]
; CHECK:       bb17.split.us:
; CHECK-NEXT:    br label [[BB17:%.*]]
; CHECK:       bb3.split:
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    [[TMP5:%.*]] = phi i32 [ poison, [[BB3_SPLIT]] ], [ [[TMP14:%.*]], [[BB13:%.*]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = phi i32 [ poison, [[BB3_SPLIT]] ], [ [[TMP5]], [[BB13]] ]
; CHECK-NEXT:    [[TMP7:%.*]] = add nuw nsw i32 [[TMP6]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp ult i32 [[TMP7]], [[TMP2]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[BB9:%.*]], label [[BB16_SPLIT:%.*]], !prof [[PROF0]]
; CHECK:       bb9:
; CHECK-NEXT:    [[TMP10:%.*]] = icmp ult i32 [[TMP7]], [[TMP1]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[BB12:%.*]], label [[BB17_SPLIT:%.*]], !prof [[PROF0]]
; CHECK:       bb12:
; CHECK-NEXT:    br i1 true, label [[BB15:%.*]], label [[BB13]]
; CHECK:       bb13:
; CHECK-NEXT:    [[TMP14]] = add nuw nsw i32 [[TMP5]], 1
; CHECK-NEXT:    br label [[BB4]]
; CHECK:       bb15:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb16.split:
; CHECK-NEXT:    br label [[BB16]]
; CHECK:       bb16:
; CHECK-NEXT:    ret void
; CHECK:       bb17.split:
; CHECK-NEXT:    br label [[BB17]]
; CHECK:       bb17:
; CHECK-NEXT:    ret void
;
bb:
  %tmp = call i1 @llvm.experimental.widenable.condition()
  %tmp1 = load atomic i32, ptr addrspace(1) poison unordered, align 8
  %tmp2 = load atomic i32, ptr addrspace(1) poison unordered, align 8
  br label %bb3

bb3:                                              ; preds = %bb15, %bb
  br label %bb4

bb4:                                              ; preds = %bb13, %bb3
  %tmp5 = phi i32 [ poison, %bb3 ], [ %tmp14, %bb13 ]
  %tmp6 = phi i32 [ poison, %bb3 ], [ %tmp5, %bb13 ]
  %tmp7 = add nuw nsw i32 %tmp6, 2
  %tmp8 = icmp ult i32 %tmp7, %tmp2
  br i1 %tmp8, label %bb9, label %bb16, !prof !0

bb9:                                              ; preds = %bb4
  %tmp10 = icmp ult i32 %tmp7, %tmp1
  %tmp11 = and i1 %tmp10, %tmp
  br i1 %tmp11, label %bb12, label %bb17, !prof !0

bb12:                                             ; preds = %bb9
  br i1 poison, label %bb15, label %bb13

bb13:                                             ; preds = %bb12
  %tmp14 = add nuw nsw i32 %tmp5, 1
  br label %bb4

bb15:                                             ; preds = %bb12
  br label %bb3

bb16:                                             ; preds = %bb4
  ret void

bb17:                                             ; preds = %bb9
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(inaccessiblemem: readwrite)
declare i1 @llvm.experimental.widenable.condition()

!0 = !{!"branch_weights", i32 1048576, i32 1}

