; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=ipsccp -S < %s | FileCheck %s
;
;    #include <threads.h>
;    thread_local int gtl = 0;
;    int gsh = 0;
;
;    static int callee(int *thread_local_ptr, int *shared_ptr) {
;      return *thread_local_ptr + *shared_ptr;
;    }
;
;    void broker(int *, int (*callee)(int *, int *), int *);
;
;    void caller() {
;      broker(&gtl, callee, &gsh);
;    }
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@gtl = dso_local thread_local global i32 0, align 4
@gsh = dso_local global i32 0, align 4

define internal i32 @callee(ptr %thread_local_ptr, ptr %shared_ptr) {
; CHECK-LABEL: @callee(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load i32, ptr [[THREAD_LOCAL_PTR:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[SHARED_PTR:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %tmp = load i32, ptr %thread_local_ptr, align 4
  %tmp1 = load i32, ptr %shared_ptr, align 4
  %add = add nsw i32 %tmp, %tmp1
  ret i32 %add
}

define dso_local void @caller() {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @broker(ptr nonnull @gtl, ptr nonnull @callee, ptr nonnull @gsh)
; CHECK-NEXT:    ret void
;
entry:
  call void @broker(ptr nonnull @gtl, ptr nonnull @callee, ptr nonnull @gsh)
  ret void
}

declare !callback !0 dso_local void @broker(ptr, ptr, ptr)

!1 = !{i64 1, i64 0, i64 2, i1 false}
!0 = !{!1}
