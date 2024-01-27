; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=div-rem-pairs -S -mtriple=riscv64-unknown-unknown | FileCheck %s

; Do not hoist to the common predecessor block since we don't
; have a div-rem operation.

define i32 @no_domination(i1 %cmp, i32 %a, i32 %b) {
; CHECK-LABEL: @no_domination(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[A]], [[B]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i32 [ [[DIV]], [[IF]] ], [ [[REM]], [[ELSE]] ]
; CHECK-NEXT:    ret i32 [[RET]]
;
entry:
  br i1 %cmp, label %if, label %else

if:
  %div = sdiv i32 %a, %b
  br label %end

else:
  %rem = srem i32 %a, %b
  br label %end

end:
  %ret = phi i32 [ %div, %if ], [ %rem, %else ]
  ret i32 %ret
}
