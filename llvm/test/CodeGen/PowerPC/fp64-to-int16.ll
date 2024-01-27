; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 < %s | FileCheck %s
target triple = "powerpc64le--linux-gnu"

define i1 @Test(double %a) {
; CHECK-LABEL: Test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xscvdpsxws 0, 1
; CHECK-NEXT:    mffprwz 3, 0
; CHECK-NEXT:    cmplwi 3, 65534
; CHECK-NEXT:    crmove 20, 2
; CHECK-NEXT:    li 4, 0
; CHECK-NEXT:    li 3, 1
; CHECK-NEXT:    isel 3, 3, 4, 20
; CHECK-NEXT:    blr
entry:
  %conv = fptoui double %a to i16
  %cmp = icmp eq i16 %conv, -2
  ret i1 %cmp
}
