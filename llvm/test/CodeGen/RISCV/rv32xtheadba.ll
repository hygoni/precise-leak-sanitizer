; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --extra_scrub
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=RV32I
; RUN: llc -mtriple=riscv32 -mattr=+m,+xtheadba -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefixes=RV32XTHEADBA

define signext i16 @th_addsl_1(i64 %0, ptr %1) {
; RV32I-LABEL: th_addsl_1:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    lh a0, 0(a0)
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: th_addsl_1:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a2, a0, 1
; RV32XTHEADBA-NEXT:    lh a0, 0(a0)
; RV32XTHEADBA-NEXT:    ret
  %3 = getelementptr inbounds i16, ptr %1, i64 %0
  %4 = load i16, ptr %3
  ret i16 %4
}

define signext i32 @th_addsl_2(i64 %0, ptr %1) {
; RV32I-LABEL: th_addsl_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 2
; RV32I-NEXT:    add a0, a2, a0
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: th_addsl_2:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a2, a0, 2
; RV32XTHEADBA-NEXT:    lw a0, 0(a0)
; RV32XTHEADBA-NEXT:    ret
  %3 = getelementptr inbounds i32, ptr %1, i64 %0
  %4 = load i32, ptr %3
  ret i32 %4
}

define i64 @th_addsl_3(i64 %0, ptr %1) {
; RV32I-LABEL: th_addsl_3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 3
; RV32I-NEXT:    add a2, a2, a0
; RV32I-NEXT:    lw a0, 0(a2)
; RV32I-NEXT:    lw a1, 4(a2)
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: th_addsl_3:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a1, a2, a0, 3
; RV32XTHEADBA-NEXT:    lw a0, 0(a1)
; RV32XTHEADBA-NEXT:    lw a1, 4(a1)
; RV32XTHEADBA-NEXT:    ret
  %3 = getelementptr inbounds i64, ptr %1, i64 %0
  %4 = load i64, ptr %3
  ret i64 %4
}

; Type legalization inserts a sext_inreg after the first add. That add will be
; selected as th.addsl which does not sign extend. SimplifyDemandedBits is unable
; to remove the sext_inreg because it has multiple uses. The ashr will use the
; sext_inreg to become sraiw. This leaves the sext_inreg only used by the shl.
; If the shl is selected as sllw, we don't need the sext_inreg.
define i64 @th_addsl_2_extra_sext(i32 %x, i32 %y, i32 %z) {
; RV32I-LABEL: th_addsl_2_extra_sext:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    sll a1, a2, a0
; RV32I-NEXT:    srai a2, a0, 2
; RV32I-NEXT:    mul a0, a1, a2
; RV32I-NEXT:    mulh a1, a1, a2
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: th_addsl_2_extra_sext:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 2
; RV32XTHEADBA-NEXT:    sll a1, a2, a0
; RV32XTHEADBA-NEXT:    srai a2, a0, 2
; RV32XTHEADBA-NEXT:    mul a0, a1, a2
; RV32XTHEADBA-NEXT:    mulh a1, a1, a2
; RV32XTHEADBA-NEXT:    ret
  %a = shl i32 %x, 2
  %b = add i32 %a, %y
  %c = shl i32 %z, %b
  %d = ashr i32 %b, 2
  %e = sext i32 %c to i64
  %f = sext i32 %d to i64
  %g = mul i64 %e, %f
  ret i64 %g
}

define i32 @addmul6(i32 %a, i32 %b) {
; RV32I-LABEL: addmul6:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 6
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul6:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 1
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 1
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 6
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul10(i32 %a, i32 %b) {
; RV32I-LABEL: addmul10:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 10
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul10:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 1
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 10
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul12(i32 %a, i32 %b) {
; RV32I-LABEL: addmul12:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 12
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul12:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 1
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 2
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 12
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul18(i32 %a, i32 %b) {
; RV32I-LABEL: addmul18:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 18
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul18:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 3
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 1
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 18
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul20(i32 %a, i32 %b) {
; RV32I-LABEL: addmul20:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 20
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul20:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 2
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 20
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul24(i32 %a, i32 %b) {
; RV32I-LABEL: addmul24:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 24
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul24:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 1
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 3
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 24
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul36(i32 %a, i32 %b) {
; RV32I-LABEL: addmul36:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 36
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul36:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 3
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 2
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 36
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul40(i32 %a, i32 %b) {
; RV32I-LABEL: addmul40:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 40
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul40:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 3
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 40
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @addmul72(i32 %a, i32 %b) {
; RV32I-LABEL: addmul72:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a2, 72
; RV32I-NEXT:    mul a0, a0, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: addmul72:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 3
; RV32XTHEADBA-NEXT:    th.addsl a0, a1, a0, 3
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 72
  %d = add i32 %c, %b
  ret i32 %d
}

define i32 @mul96(i32 %a) {
; RV32I-LABEL: mul96:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 96
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: mul96:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 1
; RV32XTHEADBA-NEXT:    slli a0, a0, 5
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 96
  ret i32 %c
}

define i32 @mul160(i32 %a) {
; RV32I-LABEL: mul160:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 160
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: mul160:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    slli a0, a0, 5
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 160
  ret i32 %c
}

define i32 @mul200(i32 %a) {
; RV32I-LABEL: mul200:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 200
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: mul200:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 2
; RV32XTHEADBA-NEXT:    slli a0, a0, 3
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 200
  ret i32 %c
}

define i32 @mul288(i32 %a) {
; RV32I-LABEL: mul288:
; RV32I:       # %bb.0:
; RV32I-NEXT:    li a1, 288
; RV32I-NEXT:    mul a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32XTHEADBA-LABEL: mul288:
; RV32XTHEADBA:       # %bb.0:
; RV32XTHEADBA-NEXT:    th.addsl a0, a0, a0, 3
; RV32XTHEADBA-NEXT:    slli a0, a0, 5
; RV32XTHEADBA-NEXT:    ret
  %c = mul i32 %a, 288
  ret i32 %c
}

