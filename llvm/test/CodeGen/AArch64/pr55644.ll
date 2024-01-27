; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-apple-darwin | FileCheck %s

define i1 @f(i2 %0) {
; CHECK-LABEL: f:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #0, #2
; CHECK-NEXT:    lsl w8, w8, #1
; CHECK-NEXT:    neg w9, w8
; CHECK-NEXT:    lsl w9, w9, #30
; CHECK-NEXT:    cmn w8, w9, asr #30
; CHECK-NEXT:    cset w0, ne
; CHECK-NEXT:    ret
  %2 = call { i2, i1 } @llvm.smul.with.overflow.i2(i2 %0, i2 -2)
  %3 = extractvalue { i2, i1 } %2, 1
  ret i1 %3
}

declare { i2, i1 } @llvm.smul.with.overflow.i2(i2, i2)
