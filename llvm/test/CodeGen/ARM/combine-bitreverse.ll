; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7m-none-eabi -mattr=v7 | FileCheck %s --check-prefixes=CHECK

declare i16 @llvm.bswap.i16(i16) readnone
declare i32 @llvm.bswap.i32(i32) readnone
declare i32 @llvm.bitreverse.i32(i32) readnone

define i32 @brev_and_lhs_brev32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_and_lhs_brev32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    ands r0, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %a)
  %2 = and i32 %1, %b
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  ret i32 %3
}

define i32 @brev_or_lhs_brev32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_or_lhs_brev32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    orrs r0, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %a)
  %2 = or i32 %1, %b
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  ret i32 %3
}

define i32 @brev_xor_rhs_brev32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_xor_rhs_brev32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r1, r1
; CHECK-NEXT:    eors r0, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %b)
  %2 = xor i32 %a, %1
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  ret i32 %3
}

define i32 @brev_and_all_operand_multiuse(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_and_all_operand_multiuse:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r1, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    and.w r2, r0, r1
; CHECK-NEXT:    rbit r2, r2
; CHECK-NEXT:    muls r0, r2, r0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %a)
  %2 = tail call i32 @llvm.bitreverse.i32(i32 %b)
  %3 = and i32 %1, %2
  %4 = tail call i32 @llvm.bitreverse.i32(i32 %3)
  %5 = mul i32 %1, %4 ;increase use of left bitreverse
  %6 = mul i32 %2, %5 ;increase use of right bitreverse

  ret i32 %6
}

; negative test
define i32 @brev_and_rhs_brev32_multiuse1(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_and_rhs_brev32_multiuse1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r1, r1
; CHECK-NEXT:    ands r0, r1
; CHECK-NEXT:    rbit r1, r0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %b)
  %2 = and i32 %1, %a
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  %4 = mul i32 %2, %3 ;increase use of logical op
  ret i32 %4
}

; negative test
define i32 @brev_and_rhs_brev32_multiuse2(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_and_rhs_brev32_multiuse2:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rbit r1, r1
; CHECK-NEXT:    ands r0, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    muls r0, r1, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bitreverse.i32(i32 %b)
  %2 = and i32 %1, %a
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  %4 = mul i32 %1, %3 ;increase use of inner bitreverse
  ret i32 %4
}

; negative test
define i32 @brev_xor_rhs_bs32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: brev_xor_rhs_bs32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    rev r1, r1
; CHECK-NEXT:    eors r0, r1
; CHECK-NEXT:    rbit r0, r0
; CHECK-NEXT:    bx lr
  %1 = tail call i32 @llvm.bswap.i32(i32 %b)
  %2 = xor i32 %a, %1
  %3 = tail call i32 @llvm.bitreverse.i32(i32 %2)
  ret i32 %3
}

