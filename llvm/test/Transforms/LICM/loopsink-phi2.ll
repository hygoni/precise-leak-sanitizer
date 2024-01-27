; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -S -verify-memoryssa -passes=loop-sink < %s | FileCheck %s
; Make sure that we handle PHI-uses correctly during loop sink if the most profitable sink
; destination also has a PHI of another use.

%struct.blam = type { %struct.blam.0, [32 x i8] }
%struct.blam.0 = type { ptr, i64 }

define internal void @wibble() !prof !0 {
; CHECK-LABEL: define internal void @wibble
; CHECK-SAME: () !prof [[PROF0:![0-9]+]] {
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 false, label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    switch i32 0, label [[BB5:%.*]] [
; CHECK-NEXT:    i32 1, label [[BB4:%.*]]
; CHECK-NEXT:    i32 0, label [[BB1]]
; CHECK-NEXT:    ], !prof [[PROF1:![0-9]+]]
; CHECK:       bb4:
; CHECK-NEXT:    br i1 false, label [[BB3]], label [[BB6:%.*]]
; CHECK:       bb5:
; CHECK-NEXT:    [[GETELEMENTPTR:%.*]] = getelementptr [[STRUCT_BLAM:%.*]], ptr null, i64 0, i32 1
; CHECK-NEXT:    br i1 false, label [[BB6]], label [[BB7:%.*]]
; CHECK:       bb6:
; CHECK-NEXT:    br label [[BB7]]
; CHECK:       bb7:
; CHECK-NEXT:    [[PHI:%.*]] = phi ptr [ null, [[BB6]] ], [ [[GETELEMENTPTR]], [[BB5]] ]
; CHECK-NEXT:    [[GETELEMENTPTR1:%.*]] = getelementptr [[STRUCT_BLAM]], ptr null, i64 0, i32 1
; CHECK-NEXT:    store ptr [[GETELEMENTPTR1]], ptr null, align 8
; CHECK-NEXT:    br label [[BB1]]
;
bb:
  %getelementptr = getelementptr %struct.blam, ptr null, i64 0, i32 1
  br label %bb1

bb1:                                              ; preds = %bb7, %bb3, %bb
  br i1 false, label %bb2, label %bb3

bb2:                                              ; preds = %bb1
  ret void

bb3:                                              ; preds = %bb4, %bb1
  switch i32 0, label %bb5 [
  i32 1, label %bb4
  i32 0, label %bb1
  ], !prof !1

bb4:                                              ; preds = %bb3
  br i1 false, label %bb3, label %bb6

bb5:                                              ; preds = %bb3
  br i1 false, label %bb6, label %bb7

bb6:                                              ; preds = %bb5, %bb4
  br label %bb7

bb7:                                              ; preds = %bb6, %bb5
  %phi = phi ptr [ null, %bb6 ], [ %getelementptr, %bb5 ]
  store ptr %getelementptr, ptr null, align 8
  br label %bb1
}

!0 = !{!"function_entry_count", i64 1}
!1 = !{!"branch_weights", i32 1, i32 188894, i32 287400}
