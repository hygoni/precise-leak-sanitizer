; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-unroll -S %s | FileCheck %s

; Loop with multiple exiting blocks, where the header exits but not the latch,
; e.g. because it has not been rotated.
define i16 @full_unroll_multiple_exiting_blocks(ptr %A, i16 %x, i16 %y) {
; CHECK-LABEL: @full_unroll_multiple_exiting_blocks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[LV:%.*]] = load i16, ptr [[A:%.*]], align 2
; CHECK-NEXT:    [[RES_NEXT:%.*]] = add i16 123, [[LV]]
; CHECK-NEXT:    br label [[EXITING_1:%.*]]
; CHECK:       exiting.1:
; CHECK-NEXT:    [[EC_1:%.*]] = icmp eq i16 [[LV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[EC_1]], label [[EXIT:%.*]], label [[EXITING_2:%.*]]
; CHECK:       exiting.2:
; CHECK-NEXT:    [[EC_2:%.*]] = icmp eq i16 [[LV]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[EC_2]], label [[EXIT]], label [[LATCH:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[PTR_1:%.*]] = getelementptr inbounds i16, ptr [[A]], i64 1
; CHECK-NEXT:    [[LV_1:%.*]] = load i16, ptr [[PTR_1]], align 2
; CHECK-NEXT:    [[RES_NEXT_1:%.*]] = add i16 [[RES_NEXT]], [[LV_1]]
; CHECK-NEXT:    br label [[EXITING_1_1:%.*]]
; CHECK:       exiting.1.1:
; CHECK-NEXT:    [[EC_1_1:%.*]] = icmp eq i16 [[LV_1]], [[X]]
; CHECK-NEXT:    br i1 [[EC_1_1]], label [[EXIT]], label [[EXITING_2_1:%.*]]
; CHECK:       exiting.2.1:
; CHECK-NEXT:    [[EC_2_1:%.*]] = icmp eq i16 [[LV_1]], [[Y]]
; CHECK-NEXT:    br i1 [[EC_2_1]], label [[EXIT]], label [[LATCH_1:%.*]]
; CHECK:       latch.1:
; CHECK-NEXT:    [[PTR_2:%.*]] = getelementptr inbounds i16, ptr [[A]], i64 2
; CHECK-NEXT:    [[LV_2:%.*]] = load i16, ptr [[PTR_2]], align 2
; CHECK-NEXT:    [[RES_NEXT_2:%.*]] = add i16 [[RES_NEXT_1]], [[LV_2]]
; CHECK-NEXT:    br label [[EXITING_1_2:%.*]]
; CHECK:       exiting.1.2:
; CHECK-NEXT:    [[EC_1_2:%.*]] = icmp eq i16 [[LV_2]], [[X]]
; CHECK-NEXT:    br i1 [[EC_1_2]], label [[EXIT]], label [[EXITING_2_2:%.*]]
; CHECK:       exiting.2.2:
; CHECK-NEXT:    [[EC_2_2:%.*]] = icmp eq i16 [[LV_2]], [[Y]]
; CHECK-NEXT:    br i1 [[EC_2_2]], label [[EXIT]], label [[LATCH_2:%.*]]
; CHECK:       latch.2:
; CHECK-NEXT:    [[PTR_3:%.*]] = getelementptr inbounds i16, ptr [[A]], i64 3
; CHECK-NEXT:    [[LV_3:%.*]] = load i16, ptr [[PTR_3]], align 2
; CHECK-NEXT:    [[RES_NEXT_3:%.*]] = add i16 [[RES_NEXT_2]], [[LV_3]]
; CHECK-NEXT:    br i1 false, label [[EXITING_1_3:%.*]], label [[EXIT]]
; CHECK:       exiting.1.3:
; CHECK-NEXT:    [[EC_1_3:%.*]] = icmp eq i16 [[LV_3]], [[X]]
; CHECK-NEXT:    br i1 [[EC_1_3]], label [[EXIT]], label [[EXITING_2_3:%.*]]
; CHECK:       exiting.2.3:
; CHECK-NEXT:    [[EC_2_3:%.*]] = icmp eq i16 [[LV_3]], [[Y]]
; CHECK-NEXT:    br i1 [[EC_2_3]], label [[EXIT]], label [[LATCH_3:%.*]]
; CHECK:       latch.3:
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[RES_LCSSA:%.*]] = phi i16 [ 0, [[EXITING_1]] ], [ 1, [[EXITING_2]] ], [ 0, [[EXITING_1_1]] ], [ 1, [[EXITING_2_1]] ], [ 0, [[EXITING_1_2]] ], [ 1, [[EXITING_2_2]] ], [ [[RES_NEXT_3]], [[LATCH_2]] ], [ 0, [[EXITING_1_3]] ], [ 1, [[EXITING_2_3]] ]
; CHECK-NEXT:    ret i16 [[RES_LCSSA]]
;
entry:
  br label %header

header:
  %res = phi i16 [ 123, %entry ], [ %res.next, %latch ]
  %i.0 = phi i64 [ 0, %entry ], [ %inc9, %latch ]
  %ptr = getelementptr inbounds i16, ptr %A, i64 %i.0
  %lv = load i16, ptr %ptr
  %res.next = add i16 %res, %lv
  %cmp = icmp ult i64 %i.0, 3
  br i1 %cmp, label %exiting.1, label %exit

exiting.1:
  %ec.1 = icmp eq i16 %lv, %x
  br i1 %ec.1, label %exit, label %exiting.2

exiting.2:
  %ec.2 = icmp eq i16 %lv, %y
  br i1 %ec.2, label %exit, label %latch

latch:
  %inc9 = add i64 %i.0, 1
  br label %header

exit:
  %res.lcssa = phi i16 [ %res.next, %header ], [ 0, %exiting.1 ], [ 1, %exiting.2 ]
  ret i16 %res.lcssa
}
