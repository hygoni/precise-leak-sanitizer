; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt < %s -S -passes='simplifycfg<speculate-blocks>' | FileCheck %s --check-prefix=YES
; RUN: opt < %s -S -passes='simplifycfg<no-speculate-blocks>' | FileCheck %s --check-prefix=NO

define i32 @f(i1 %a) {
; YES-LABEL: define i32 @f
; YES-SAME: (i1 [[A:%.*]]) {
; YES-NEXT:  entry:
; YES-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[A]], i32 5, i32 2
; YES-NEXT:    ret i32 [[SPEC_SELECT]]
;
; NO-LABEL: define i32 @f
; NO-SAME: (i1 [[A:%.*]]) {
; NO-NEXT:  entry:
; NO-NEXT:    br i1 [[A]], label [[BB:%.*]], label [[BB2:%.*]]
; NO:       bb:
; NO-NEXT:    br label [[BB2]]
; NO:       bb2:
; NO-NEXT:    [[R:%.*]] = phi i32 [ 2, [[ENTRY:%.*]] ], [ 5, [[BB]] ]
; NO-NEXT:    ret i32 [[R]]
;
entry:
  br i1 %a, label %bb, label %bb2
bb:
  br label %bb2
bb2:
  %r = phi i32 [ 2, %entry ], [ 5, %bb ]
  ret i32 %r
}
