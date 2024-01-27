; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV32ZBB
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefix=RV64ZBB

declare i8 @llvm.abs.i8(i8, i1 immarg)
declare i16 @llvm.abs.i16(i16, i1 immarg)
declare i32 @llvm.abs.i32(i32, i1 immarg)
declare i64 @llvm.abs.i64(i64, i1 immarg)
declare i128 @llvm.abs.i128(i128, i1 immarg)

define i8 @abs8(i8 %x) {
; RV32I-LABEL: abs8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 24
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: abs8:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    sext.b a0, a0
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: abs8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 56
; RV64I-NEXT:    srai a1, a1, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i8 @llvm.abs.i8(i8 %x, i1 true)
  ret i8 %abs
}

define i8 @select_abs8(i8 %x) {
; RV32I-LABEL: select_abs8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 24
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: select_abs8:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    sext.b a0, a0
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: select_abs8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 56
; RV64I-NEXT:    srai a1, a1, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: select_abs8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %1 = icmp slt i8 %x, 0
  %2 = sub nsw i8 0, %x
  %3 = select i1 %1, i8 %2, i8 %x
  ret i8 %3
}

define i16 @abs16(i16 %x) {
; RV32I-LABEL: abs16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 16
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: abs16:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    sext.h a0, a0
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: abs16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 48
; RV64I-NEXT:    srai a1, a1, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.h a0, a0
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i16 @llvm.abs.i16(i16 %x, i1 true)
  ret i16 %abs
}

define i16 @select_abs16(i16 %x) {
; RV32I-LABEL: select_abs16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a1, a0, 16
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: select_abs16:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    sext.h a0, a0
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: select_abs16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a1, a0, 48
; RV64I-NEXT:    srai a1, a1, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: select_abs16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.h a0, a0
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %1 = icmp slt i16 %x, 0
  %2 = sub nsw i16 0, %x
  %3 = select i1 %1, i16 %2, i16 %x
  ret i16 %3
}

define i32 @abs32(i32 %x) {
; RV32I-LABEL: abs32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: abs32:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: abs32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sraiw a1, a0, 31
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.w a0, a0
; RV64ZBB-NEXT:    negw a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

define i32 @select_abs32(i32 %x) {
; RV32I-LABEL: select_abs32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: select_abs32:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: select_abs32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sraiw a1, a0, 31
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: select_abs32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.w a0, a0
; RV64ZBB-NEXT:    negw a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %1 = icmp slt i32 %x, 0
  %2 = sub nsw i32 0, %x
  %3 = select i1 %1, i32 %2, i32 %x
  ret i32 %3
}

define i64 @abs64(i64 %x) {
; RV32I-LABEL: abs64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgez a1, .LBB6_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    snez a2, a0
; RV32I-NEXT:    neg a0, a0
; RV32I-NEXT:    neg a1, a1
; RV32I-NEXT:    sub a1, a1, a2
; RV32I-NEXT:  .LBB6_2:
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: abs64:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    bgez a1, .LBB6_2
; RV32ZBB-NEXT:  # %bb.1:
; RV32ZBB-NEXT:    snez a2, a0
; RV32ZBB-NEXT:    neg a0, a0
; RV32ZBB-NEXT:    neg a1, a1
; RV32ZBB-NEXT:    sub a1, a1, a2
; RV32ZBB-NEXT:  .LBB6_2:
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: abs64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  ret i64 %abs
}

define i64 @select_abs64(i64 %x) {
; RV32I-LABEL: select_abs64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    bgez a1, .LBB7_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    snez a2, a0
; RV32I-NEXT:    neg a0, a0
; RV32I-NEXT:    neg a1, a1
; RV32I-NEXT:    sub a1, a1, a2
; RV32I-NEXT:  .LBB7_2:
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: select_abs64:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    bgez a1, .LBB7_2
; RV32ZBB-NEXT:  # %bb.1:
; RV32ZBB-NEXT:    snez a2, a0
; RV32ZBB-NEXT:    neg a0, a0
; RV32ZBB-NEXT:    neg a1, a1
; RV32ZBB-NEXT:    sub a1, a1, a2
; RV32ZBB-NEXT:  .LBB7_2:
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: select_abs64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: select_abs64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %1 = icmp slt i64 %x, 0
  %2 = sub nsw i64 0, %x
  %3 = select i1 %1, i64 %2, i64 %x
  ret i64 %3
}

define i128 @abs128(i128 %x) {
; RV32I-LABEL: abs128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 12(a1)
; RV32I-NEXT:    lw a3, 4(a1)
; RV32I-NEXT:    lw a4, 0(a1)
; RV32I-NEXT:    lw a1, 8(a1)
; RV32I-NEXT:    bgez a2, .LBB8_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    neg a5, a1
; RV32I-NEXT:    or a6, a4, a3
; RV32I-NEXT:    snez a6, a6
; RV32I-NEXT:    sltu a7, a5, a6
; RV32I-NEXT:    snez a1, a1
; RV32I-NEXT:    add a1, a2, a1
; RV32I-NEXT:    neg a1, a1
; RV32I-NEXT:    sub a2, a1, a7
; RV32I-NEXT:    sub a1, a5, a6
; RV32I-NEXT:    snez a5, a4
; RV32I-NEXT:    neg a3, a3
; RV32I-NEXT:    sub a3, a3, a5
; RV32I-NEXT:    neg a4, a4
; RV32I-NEXT:  .LBB8_2:
; RV32I-NEXT:    sw a4, 0(a0)
; RV32I-NEXT:    sw a1, 8(a0)
; RV32I-NEXT:    sw a3, 4(a0)
; RV32I-NEXT:    sw a2, 12(a0)
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: abs128:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    lw a2, 12(a1)
; RV32ZBB-NEXT:    lw a3, 4(a1)
; RV32ZBB-NEXT:    lw a4, 0(a1)
; RV32ZBB-NEXT:    lw a1, 8(a1)
; RV32ZBB-NEXT:    bgez a2, .LBB8_2
; RV32ZBB-NEXT:  # %bb.1:
; RV32ZBB-NEXT:    neg a5, a1
; RV32ZBB-NEXT:    or a6, a4, a3
; RV32ZBB-NEXT:    snez a6, a6
; RV32ZBB-NEXT:    sltu a7, a5, a6
; RV32ZBB-NEXT:    snez a1, a1
; RV32ZBB-NEXT:    add a1, a2, a1
; RV32ZBB-NEXT:    neg a1, a1
; RV32ZBB-NEXT:    sub a2, a1, a7
; RV32ZBB-NEXT:    sub a1, a5, a6
; RV32ZBB-NEXT:    snez a5, a4
; RV32ZBB-NEXT:    neg a3, a3
; RV32ZBB-NEXT:    sub a3, a3, a5
; RV32ZBB-NEXT:    neg a4, a4
; RV32ZBB-NEXT:  .LBB8_2:
; RV32ZBB-NEXT:    sw a4, 0(a0)
; RV32ZBB-NEXT:    sw a1, 8(a0)
; RV32ZBB-NEXT:    sw a3, 4(a0)
; RV32ZBB-NEXT:    sw a2, 12(a0)
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: abs128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgez a1, .LBB8_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    snez a2, a0
; RV64I-NEXT:    neg a0, a0
; RV64I-NEXT:    neg a1, a1
; RV64I-NEXT:    sub a1, a1, a2
; RV64I-NEXT:  .LBB8_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs128:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    bgez a1, .LBB8_2
; RV64ZBB-NEXT:  # %bb.1:
; RV64ZBB-NEXT:    snez a2, a0
; RV64ZBB-NEXT:    neg a0, a0
; RV64ZBB-NEXT:    neg a1, a1
; RV64ZBB-NEXT:    sub a1, a1, a2
; RV64ZBB-NEXT:  .LBB8_2:
; RV64ZBB-NEXT:    ret
  %abs = tail call i128 @llvm.abs.i128(i128 %x, i1 true)
  ret i128 %abs
}

define i128 @select_abs128(i128 %x) {
; RV32I-LABEL: select_abs128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 12(a1)
; RV32I-NEXT:    lw a3, 4(a1)
; RV32I-NEXT:    lw a4, 0(a1)
; RV32I-NEXT:    lw a1, 8(a1)
; RV32I-NEXT:    bgez a2, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    neg a5, a1
; RV32I-NEXT:    or a6, a4, a3
; RV32I-NEXT:    snez a6, a6
; RV32I-NEXT:    sltu a7, a5, a6
; RV32I-NEXT:    snez a1, a1
; RV32I-NEXT:    add a1, a2, a1
; RV32I-NEXT:    neg a1, a1
; RV32I-NEXT:    sub a2, a1, a7
; RV32I-NEXT:    sub a1, a5, a6
; RV32I-NEXT:    snez a5, a4
; RV32I-NEXT:    neg a3, a3
; RV32I-NEXT:    sub a3, a3, a5
; RV32I-NEXT:    neg a4, a4
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    sw a4, 0(a0)
; RV32I-NEXT:    sw a1, 8(a0)
; RV32I-NEXT:    sw a3, 4(a0)
; RV32I-NEXT:    sw a2, 12(a0)
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: select_abs128:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    lw a2, 12(a1)
; RV32ZBB-NEXT:    lw a3, 4(a1)
; RV32ZBB-NEXT:    lw a4, 0(a1)
; RV32ZBB-NEXT:    lw a1, 8(a1)
; RV32ZBB-NEXT:    bgez a2, .LBB9_2
; RV32ZBB-NEXT:  # %bb.1:
; RV32ZBB-NEXT:    neg a5, a1
; RV32ZBB-NEXT:    or a6, a4, a3
; RV32ZBB-NEXT:    snez a6, a6
; RV32ZBB-NEXT:    sltu a7, a5, a6
; RV32ZBB-NEXT:    snez a1, a1
; RV32ZBB-NEXT:    add a1, a2, a1
; RV32ZBB-NEXT:    neg a1, a1
; RV32ZBB-NEXT:    sub a2, a1, a7
; RV32ZBB-NEXT:    sub a1, a5, a6
; RV32ZBB-NEXT:    snez a5, a4
; RV32ZBB-NEXT:    neg a3, a3
; RV32ZBB-NEXT:    sub a3, a3, a5
; RV32ZBB-NEXT:    neg a4, a4
; RV32ZBB-NEXT:  .LBB9_2:
; RV32ZBB-NEXT:    sw a4, 0(a0)
; RV32ZBB-NEXT:    sw a1, 8(a0)
; RV32ZBB-NEXT:    sw a3, 4(a0)
; RV32ZBB-NEXT:    sw a2, 12(a0)
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: select_abs128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bgez a1, .LBB9_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    snez a2, a0
; RV64I-NEXT:    neg a0, a0
; RV64I-NEXT:    neg a1, a1
; RV64I-NEXT:    sub a1, a1, a2
; RV64I-NEXT:  .LBB9_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: select_abs128:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    bgez a1, .LBB9_2
; RV64ZBB-NEXT:  # %bb.1:
; RV64ZBB-NEXT:    snez a2, a0
; RV64ZBB-NEXT:    neg a0, a0
; RV64ZBB-NEXT:    neg a1, a1
; RV64ZBB-NEXT:    sub a1, a1, a2
; RV64ZBB-NEXT:  .LBB9_2:
; RV64ZBB-NEXT:    ret
  %1 = icmp slt i128 %x, 0
  %2 = sub nsw i128 0, %x
  %3 = select i1 %1, i128 %2, i128 %x
  ret i128 %3
}

define i64 @zext_abs32(i32 %x) {
; RV32I-LABEL: zext_abs32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext_abs32:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    li a1, 0
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext_abs32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sraiw a1, a0, 31
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext_abs32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.w a0, a0
; RV64ZBB-NEXT:    negw a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  %zext = zext i32 %abs to i64
  ret i64 %zext
}

define signext i32 @zext_abs8(i8 signext %x) {
; RV32I-LABEL: zext_abs8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext_abs8:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext_abs8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext_abs8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %a = call i8 @llvm.abs.i8(i8 %x, i1 false)
  %b = zext i8 %a to i32
  ret i32 %b
}

define signext i32 @zext_abs16(i16 signext %x) {
; RV32I-LABEL: zext_abs16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext_abs16:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext_abs16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext_abs16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %a = call i16 @llvm.abs.i16(i16 %x, i1 false)
  %b = zext i16 %a to i32
  ret i32 %b
}

define i64 @zext64_abs8(i8 signext %x) {
; RV32I-LABEL: zext64_abs8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext64_abs8:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    li a1, 0
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext64_abs8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext64_abs8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %a = call i8 @llvm.abs.i8(i8 %x, i1 false)
  %b = zext i8 %a to i64
  ret i64 %b
}

define i64 @zext64_abs16(i16 signext %x) {
; RV32I-LABEL: zext64_abs16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext64_abs16:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    neg a1, a0
; RV32ZBB-NEXT:    max a0, a0, a1
; RV32ZBB-NEXT:    li a1, 0
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext64_abs16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext64_abs16:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %a = call i16 @llvm.abs.i16(i16 %x, i1 false)
  %b = zext i16 %a to i64
  ret i64 %b
}

define void @zext16_abs8(i8 %x, ptr %p) {
; RV32I-LABEL: zext16_abs8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    srai a2, a0, 31
; RV32I-NEXT:    xor a0, a0, a2
; RV32I-NEXT:    sub a0, a0, a2
; RV32I-NEXT:    sh a0, 0(a1)
; RV32I-NEXT:    ret
;
; RV32ZBB-LABEL: zext16_abs8:
; RV32ZBB:       # %bb.0:
; RV32ZBB-NEXT:    sext.b a0, a0
; RV32ZBB-NEXT:    neg a2, a0
; RV32ZBB-NEXT:    max a0, a0, a2
; RV32ZBB-NEXT:    sh a0, 0(a1)
; RV32ZBB-NEXT:    ret
;
; RV64I-LABEL: zext16_abs8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    srai a2, a0, 63
; RV64I-NEXT:    xor a0, a0, a2
; RV64I-NEXT:    subw a0, a0, a2
; RV64I-NEXT:    sh a0, 0(a1)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zext16_abs8:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    neg a2, a0
; RV64ZBB-NEXT:    max a0, a0, a2
; RV64ZBB-NEXT:    sh a0, 0(a1)
; RV64ZBB-NEXT:    ret
  %a = call i8 @llvm.abs.i8(i8 %x, i1 false)
  %b = zext i8 %a to i16
  store i16 %b, ptr %p
  ret void
}
