; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s -verify-machineinstrs -mtriple=arm64-eabi | FileCheck %s

; Check if sqshl/uqshl with constant shift amount can be selected.
define i64 @test_vqshld_s64_i(i64 %a) {
; CHECK-LABEL: test_vqshld_s64_i:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d0, x0
; CHECK-NEXT:    sqshl d0, d0, #36
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %1 = tail call i64 @llvm.aarch64.neon.sqshl.i64(i64 %a, i64 36)
  ret i64 %1
}

define i64 @test_vqshld_u64_i(i64 %a) {
; CHECK-LABEL: test_vqshld_u64_i:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov d0, x0
; CHECK-NEXT:    uqshl d0, d0, #36
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %1 = tail call i64 @llvm.aarch64.neon.uqshl.i64(i64 %a, i64 36)
  ret i64 %1
}

define i32 @test_vqshld_s32_i(i32 %a) {
; CHECK-LABEL: test_vqshld_s32_i:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s0, w0
; CHECK-NEXT:    sqshl s0, s0, #16
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %1 = tail call i32 @llvm.aarch64.neon.sqshl.i32(i32 %a, i32 16)
  ret i32 %1
}

define i32 @test_vqshld_u32_i(i32 %a) {
; CHECK-LABEL: test_vqshld_u32_i:
; CHECK:       // %bb.0:
; CHECK-NEXT:    fmov s0, w0
; CHECK-NEXT:    uqshl s0, s0, #16
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %1 = tail call i32 @llvm.aarch64.neon.uqshl.i32(i32 %a, i32 16)
  ret i32 %1
}

declare i64 @llvm.aarch64.neon.uqshl.i64(i64, i64)
declare i64 @llvm.aarch64.neon.sqshl.i64(i64, i64)

declare i32 @llvm.aarch64.neon.uqshl.i32(i32, i32)
declare i32 @llvm.aarch64.neon.sqshl.i32(i32, i32)
