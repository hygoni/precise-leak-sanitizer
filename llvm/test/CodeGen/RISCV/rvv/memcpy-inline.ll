; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+v \
; RUN:   | FileCheck %s --check-prefixes=RV32-BOTH,RV32
; RUN: llc < %s -mtriple=riscv64 -mattr=+v \
; RUN:   | FileCheck %s --check-prefixes=RV64-BOTH,RV64
; RUN: llc < %s -mtriple=riscv32 -mattr=+v,+unaligned-scalar-mem,+unaligned-vector-mem \
; RUN:   | FileCheck %s --check-prefixes=RV32-BOTH,RV32-FAST
; RUN: llc < %s -mtriple=riscv64 -mattr=+v,+unaligned-scalar-mem,+unaligned-vector-mem \
; RUN:   | FileCheck %s --check-prefixes=RV64-BOTH,RV64-FAST

; ----------------------------------------------------------------------
; Fully unaligned cases


define void @unaligned_memcpy1(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: unaligned_memcpy1:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    lbu a1, 0(a1)
; RV32-BOTH-NEXT:    sb a1, 0(a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: unaligned_memcpy1:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    lbu a1, 0(a1)
; RV64-BOTH-NEXT:    sb a1, 0(a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 1, i1 false)
  ret void
}

define void @unaligned_memcpy2(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy2:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy2:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy2:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lh a1, 0(a1)
; RV32-FAST-NEXT:    sh a1, 0(a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy2:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lh a1, 0(a1)
; RV64-FAST-NEXT:    sh a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 2, i1 false)
  ret void
}

define void @unaligned_memcpy3(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy3:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 2(a1)
; RV32-NEXT:    sb a2, 2(a0)
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy3:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 2(a1)
; RV64-NEXT:    sb a2, 2(a0)
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy3:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lbu a2, 2(a1)
; RV32-FAST-NEXT:    sb a2, 2(a0)
; RV32-FAST-NEXT:    lh a1, 0(a1)
; RV32-FAST-NEXT:    sh a1, 0(a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy3:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lbu a2, 2(a1)
; RV64-FAST-NEXT:    sb a2, 2(a0)
; RV64-FAST-NEXT:    lh a1, 0(a1)
; RV64-FAST-NEXT:    sh a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 3, i1 false)
  ret void
}

define void @unaligned_memcpy4(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy4:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy4:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy4:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a1, 0(a1)
; RV32-FAST-NEXT:    sw a1, 0(a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy4:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lw a1, 0(a1)
; RV64-FAST-NEXT:    sw a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 4, i1 false)
  ret void
}

define void @unaligned_memcpy7(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy7:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 6(a1)
; RV32-NEXT:    sb a2, 6(a0)
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a1, a1, 4
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 4
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy7:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 6(a1)
; RV64-NEXT:    sb a2, 6(a0)
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a1, a1, 4
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 4
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy7:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 3(a1)
; RV32-FAST-NEXT:    sw a2, 3(a0)
; RV32-FAST-NEXT:    lw a1, 0(a1)
; RV32-FAST-NEXT:    sw a1, 0(a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy7:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lw a2, 3(a1)
; RV64-FAST-NEXT:    sw a2, 3(a0)
; RV64-FAST-NEXT:    lw a1, 0(a1)
; RV64-FAST-NEXT:    sw a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 7, i1 false)
  ret void
}

define void @unaligned_memcpy8(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy8:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy8:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy8:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy8:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    ld a1, 0(a1)
; RV64-FAST-NEXT:    sd a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 8, i1 false)
  ret void
}

define void @unaligned_memcpy15(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy15:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 14(a1)
; RV32-NEXT:    sb a2, 14(a0)
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a2, a1, 12
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV32-NEXT:    vle8.v v8, (a2)
; RV32-NEXT:    addi a2, a0, 12
; RV32-NEXT:    vse8.v v8, (a2)
; RV32-NEXT:    addi a1, a1, 8
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 8
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy15:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 14(a1)
; RV64-NEXT:    sb a2, 14(a0)
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a2, a1, 12
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV64-NEXT:    vle8.v v8, (a2)
; RV64-NEXT:    addi a2, a0, 12
; RV64-NEXT:    vse8.v v8, (a2)
; RV64-NEXT:    addi a1, a1, 8
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 8
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy15:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 11(a1)
; RV32-FAST-NEXT:    sw a2, 11(a0)
; RV32-FAST-NEXT:    lw a2, 8(a1)
; RV32-FAST-NEXT:    sw a2, 8(a0)
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy15:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    ld a2, 7(a1)
; RV64-FAST-NEXT:    sd a2, 7(a0)
; RV64-FAST-NEXT:    ld a1, 0(a1)
; RV64-FAST-NEXT:    sd a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 15, i1 false)
  ret void
}

define void @unaligned_memcpy16(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy16:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy16:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy16:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy16:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 16, i1 false)
  ret void
}

define void @unaligned_memcpy31(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy31:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 30(a1)
; RV32-NEXT:    sb a2, 30(a0)
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a2, a1, 28
; RV32-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV32-NEXT:    vle8.v v8, (a2)
; RV32-NEXT:    addi a2, a0, 28
; RV32-NEXT:    vse8.v v8, (a2)
; RV32-NEXT:    addi a2, a1, 24
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV32-NEXT:    vle8.v v8, (a2)
; RV32-NEXT:    addi a2, a0, 24
; RV32-NEXT:    vse8.v v8, (a2)
; RV32-NEXT:    addi a1, a1, 16
; RV32-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 16
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy31:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 30(a1)
; RV64-NEXT:    sb a2, 30(a0)
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a2, a1, 28
; RV64-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; RV64-NEXT:    vle8.v v8, (a2)
; RV64-NEXT:    addi a2, a0, 28
; RV64-NEXT:    vse8.v v8, (a2)
; RV64-NEXT:    addi a2, a1, 24
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV64-NEXT:    vle8.v v8, (a2)
; RV64-NEXT:    addi a2, a0, 24
; RV64-NEXT:    vse8.v v8, (a2)
; RV64-NEXT:    addi a1, a1, 16
; RV64-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 16
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy31:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 27(a1)
; RV32-FAST-NEXT:    sw a2, 27(a0)
; RV32-FAST-NEXT:    lw a2, 24(a1)
; RV32-FAST-NEXT:    sw a2, 24(a0)
; RV32-FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    addi a1, a1, 16
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    addi a0, a0, 16
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy31:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    ld a2, 23(a1)
; RV64-FAST-NEXT:    sd a2, 23(a0)
; RV64-FAST-NEXT:    ld a2, 16(a1)
; RV64-FAST-NEXT:    sd a2, 16(a0)
; RV64-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 31, i1 false)
  ret void
}

define void @unaligned_memcpy32(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy32:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 32
; RV32-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy32:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 32
; RV64-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy32:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy32:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 32, i1 false)
  ret void
}

define void @unaligned_memcpy64(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy64:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 64
; RV32-NEXT:    vsetvli zero, a2, e8, m4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy64:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 64
; RV64-NEXT:    vsetvli zero, a2, e8, m4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy64:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy64:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 64, i1 false)
  ret void
}

define void @unaligned_memcpy96(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy96:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 64
; RV32-NEXT:    vsetvli zero, a2, e8, m4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a1, a1, 64
; RV32-NEXT:    li a2, 32
; RV32-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 64
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy96:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 64
; RV64-NEXT:    vsetvli zero, a2, e8, m4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a1, a1, 64
; RV64-NEXT:    li a2, 32
; RV64-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 64
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy96:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    addi a1, a1, 64
; RV32-FAST-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    addi a0, a0, 64
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy96:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    addi a1, a1, 64
; RV64-FAST-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    addi a0, a0, 64
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 96, i1 false)
  ret void
}

define void @unaligned_memcpy128(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy128:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 128
; RV32-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy128:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 128
; RV64-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy128:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    li a2, 32
; RV32-FAST-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy128:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 128, i1 false)
  ret void
}

define void @unaligned_memcpy196(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy196:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 128
; RV32-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a2, a1, 128
; RV32-NEXT:    li a3, 64
; RV32-NEXT:    vsetvli zero, a3, e8, m4, ta, ma
; RV32-NEXT:    vle8.v v8, (a2)
; RV32-NEXT:    addi a2, a0, 128
; RV32-NEXT:    vse8.v v8, (a2)
; RV32-NEXT:    addi a1, a1, 192
; RV32-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 192
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy196:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 128
; RV64-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a2, a1, 128
; RV64-NEXT:    li a3, 64
; RV64-NEXT:    vsetvli zero, a3, e8, m4, ta, ma
; RV64-NEXT:    vle8.v v8, (a2)
; RV64-NEXT:    addi a2, a0, 128
; RV64-NEXT:    vse8.v v8, (a2)
; RV64-NEXT:    addi a1, a1, 192
; RV64-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 192
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy196:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    li a2, 32
; RV32-FAST-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    lw a2, 192(a1)
; RV32-FAST-NEXT:    sw a2, 192(a0)
; RV32-FAST-NEXT:    addi a1, a1, 128
; RV32-FAST-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    addi a0, a0, 128
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy196:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lw a2, 192(a1)
; RV64-FAST-NEXT:    sw a2, 192(a0)
; RV64-FAST-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    addi a1, a1, 128
; RV64-FAST-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    addi a0, a0, 128
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 196, i1 false)
  ret void
}

define void @unaligned_memcpy256(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: unaligned_memcpy256:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    li a2, 128
; RV32-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    addi a1, a1, 128
; RV32-NEXT:    vle8.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 128
; RV32-NEXT:    vse8.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: unaligned_memcpy256:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    li a2, 128
; RV64-NEXT:    vsetvli zero, a2, e8, m8, ta, ma
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    addi a1, a1, 128
; RV64-NEXT:    vle8.v v8, (a1)
; RV64-NEXT:    addi a0, a0, 128
; RV64-NEXT:    vse8.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: unaligned_memcpy256:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    li a2, 32
; RV32-FAST-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    addi a1, a1, 128
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    addi a0, a0, 128
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: unaligned_memcpy256:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    addi a1, a1, 128
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    addi a0, a0, 128
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr %dest, ptr %src, i64 256, i1 false)
  ret void
}


; ----------------------------------------------------------------------
; Fully aligned cases

define void @aligned_memcpy2(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy2:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    lh a1, 0(a1)
; RV32-BOTH-NEXT:    sh a1, 0(a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy2:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    lh a1, 0(a1)
; RV64-BOTH-NEXT:    sh a1, 0(a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 2, i1 false)
  ret void
}

define void @aligned_memcpy3(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy3:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    lbu a2, 2(a1)
; RV32-BOTH-NEXT:    sb a2, 2(a0)
; RV32-BOTH-NEXT:    lh a1, 0(a1)
; RV32-BOTH-NEXT:    sh a1, 0(a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy3:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    lbu a2, 2(a1)
; RV64-BOTH-NEXT:    sb a2, 2(a0)
; RV64-BOTH-NEXT:    lh a1, 0(a1)
; RV64-BOTH-NEXT:    sh a1, 0(a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 3, i1 false)
  ret void
}

define void @aligned_memcpy4(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy4:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    lw a1, 0(a1)
; RV32-BOTH-NEXT:    sw a1, 0(a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy4:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    lw a1, 0(a1)
; RV64-BOTH-NEXT:    sw a1, 0(a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 4, i1 false)
  ret void
}

define void @aligned_memcpy7(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: aligned_memcpy7:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 6(a1)
; RV32-NEXT:    sb a2, 6(a0)
; RV32-NEXT:    lh a2, 4(a1)
; RV32-NEXT:    sh a2, 4(a0)
; RV32-NEXT:    lw a1, 0(a1)
; RV32-NEXT:    sw a1, 0(a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: aligned_memcpy7:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 6(a1)
; RV64-NEXT:    sb a2, 6(a0)
; RV64-NEXT:    lh a2, 4(a1)
; RV64-NEXT:    sh a2, 4(a0)
; RV64-NEXT:    lw a1, 0(a1)
; RV64-NEXT:    sw a1, 0(a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: aligned_memcpy7:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 3(a1)
; RV32-FAST-NEXT:    sw a2, 3(a0)
; RV32-FAST-NEXT:    lw a1, 0(a1)
; RV32-FAST-NEXT:    sw a1, 0(a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: aligned_memcpy7:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lw a2, 3(a1)
; RV64-FAST-NEXT:    sw a2, 3(a0)
; RV64-FAST-NEXT:    lw a1, 0(a1)
; RV64-FAST-NEXT:    sw a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 7, i1 false)
  ret void
}

define void @aligned_memcpy8(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy8:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy8:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    ld a1, 0(a1)
; RV64-BOTH-NEXT:    sd a1, 0(a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 8, i1 false)
  ret void
}

define void @aligned_memcpy15(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: aligned_memcpy15:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 14(a1)
; RV32-NEXT:    sb a2, 14(a0)
; RV32-NEXT:    lh a2, 12(a1)
; RV32-NEXT:    sh a2, 12(a0)
; RV32-NEXT:    lw a2, 8(a1)
; RV32-NEXT:    sw a2, 8(a0)
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-NEXT:    vle32.v v8, (a1)
; RV32-NEXT:    vse32.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: aligned_memcpy15:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 14(a1)
; RV64-NEXT:    sb a2, 14(a0)
; RV64-NEXT:    lh a2, 12(a1)
; RV64-NEXT:    sh a2, 12(a0)
; RV64-NEXT:    lw a2, 8(a1)
; RV64-NEXT:    sw a2, 8(a0)
; RV64-NEXT:    ld a1, 0(a1)
; RV64-NEXT:    sd a1, 0(a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: aligned_memcpy15:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 11(a1)
; RV32-FAST-NEXT:    sw a2, 11(a0)
; RV32-FAST-NEXT:    lw a2, 8(a1)
; RV32-FAST-NEXT:    sw a2, 8(a0)
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: aligned_memcpy15:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    ld a2, 7(a1)
; RV64-FAST-NEXT:    sd a2, 7(a0)
; RV64-FAST-NEXT:    ld a1, 0(a1)
; RV64-FAST-NEXT:    sd a1, 0(a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 15, i1 false)
  ret void
}

define void @aligned_memcpy16(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy16:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy16:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 16, i1 false)
  ret void
}

define void @aligned_memcpy31(ptr nocapture %dest, ptr %src) nounwind {
; RV32-LABEL: aligned_memcpy31:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 30(a1)
; RV32-NEXT:    sb a2, 30(a0)
; RV32-NEXT:    lh a2, 28(a1)
; RV32-NEXT:    sh a2, 28(a0)
; RV32-NEXT:    lw a2, 24(a1)
; RV32-NEXT:    sw a2, 24(a0)
; RV32-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-NEXT:    vle32.v v8, (a1)
; RV32-NEXT:    vse32.v v8, (a0)
; RV32-NEXT:    addi a1, a1, 16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-NEXT:    vle32.v v8, (a1)
; RV32-NEXT:    addi a0, a0, 16
; RV32-NEXT:    vse32.v v8, (a0)
; RV32-NEXT:    ret
;
; RV64-LABEL: aligned_memcpy31:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 30(a1)
; RV64-NEXT:    sb a2, 30(a0)
; RV64-NEXT:    lh a2, 28(a1)
; RV64-NEXT:    sh a2, 28(a0)
; RV64-NEXT:    lw a2, 24(a1)
; RV64-NEXT:    sw a2, 24(a0)
; RV64-NEXT:    ld a2, 16(a1)
; RV64-NEXT:    sd a2, 16(a0)
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-NEXT:    vle64.v v8, (a1)
; RV64-NEXT:    vse64.v v8, (a0)
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: aligned_memcpy31:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 27(a1)
; RV32-FAST-NEXT:    sw a2, 27(a0)
; RV32-FAST-NEXT:    lw a2, 24(a1)
; RV32-FAST-NEXT:    sw a2, 24(a0)
; RV32-FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    addi a1, a1, 16
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    addi a0, a0, 16
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: aligned_memcpy31:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    ld a2, 23(a1)
; RV64-FAST-NEXT:    sd a2, 23(a0)
; RV64-FAST-NEXT:    ld a2, 16(a1)
; RV64-FAST-NEXT:    sd a2, 16(a0)
; RV64-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 31, i1 false)
  ret void
}

define void @aligned_memcpy32(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy32:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy32:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 32, i1 false)
  ret void
}

define void @aligned_memcpy64(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy64:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy64:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 64, i1 false)
  ret void
}

define void @aligned_memcpy96(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy96:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    addi a1, a1, 64
; RV32-BOTH-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    addi a0, a0, 64
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy96:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    addi a1, a1, 64
; RV64-BOTH-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    addi a0, a0, 64
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 96, i1 false)
  ret void
}

define void @aligned_memcpy128(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy128:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    li a2, 32
; RV32-BOTH-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy128:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 128, i1 false)
  ret void
}

define void @aligned_memcpy196(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy196:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    li a2, 32
; RV32-BOTH-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    lw a2, 192(a1)
; RV32-BOTH-NEXT:    sw a2, 192(a0)
; RV32-BOTH-NEXT:    addi a1, a1, 128
; RV32-BOTH-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    addi a0, a0, 128
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy196:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    lw a2, 192(a1)
; RV64-BOTH-NEXT:    sw a2, 192(a0)
; RV64-BOTH-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    addi a1, a1, 128
; RV64-BOTH-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    addi a0, a0, 128
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 196, i1 false)
  ret void
}

define void @aligned_memcpy256(ptr nocapture %dest, ptr %src) nounwind {
; RV32-BOTH-LABEL: aligned_memcpy256:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    li a2, 32
; RV32-BOTH-NEXT:    vsetvli zero, a2, e32, m8, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    addi a1, a1, 128
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    addi a0, a0, 128
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-BOTH-LABEL: aligned_memcpy256:
; RV64-BOTH:       # %bb.0: # %entry
; RV64-BOTH-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    addi a1, a1, 128
; RV64-BOTH-NEXT:    vle64.v v8, (a1)
; RV64-BOTH-NEXT:    addi a0, a0, 128
; RV64-BOTH-NEXT:    vse64.v v8, (a0)
; RV64-BOTH-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i64(ptr align 8 %dest, ptr align 8 %src, i64 256, i1 false)
  ret void
}

; ------------------------------------------------------------------------
; A few partially aligned cases


define void @memcpy16_align4(ptr nocapture %dest, ptr nocapture %src) nounwind {
; RV32-BOTH-LABEL: memcpy16_align4:
; RV32-BOTH:       # %bb.0: # %entry
; RV32-BOTH-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32-BOTH-NEXT:    vle32.v v8, (a1)
; RV32-BOTH-NEXT:    vse32.v v8, (a0)
; RV32-BOTH-NEXT:    ret
;
; RV64-LABEL: memcpy16_align4:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vle32.v v8, (a1)
; RV64-NEXT:    vse32.v v8, (a0)
; RV64-NEXT:    ret
;
; RV64-FAST-LABEL: memcpy16_align4:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-FAST-NEXT:    vle64.v v8, (a1)
; RV64-FAST-NEXT:    vse64.v v8, (a0)
; RV64-FAST-NEXT:    ret
entry:
  tail call void @llvm.memcpy.inline.p0.p0.i32(ptr align 4 %dest, ptr align 4 %src, i32 16, i1 false)
  ret void
}

define i32 @memcpy11_align8(ptr nocapture %dest, ptr %src) {
; RV32-LABEL: memcpy11_align8:
; RV32:       # %bb.0: # %entry
; RV32-NEXT:    lbu a2, 10(a1)
; RV32-NEXT:    sb a2, 10(a0)
; RV32-NEXT:    lh a2, 8(a1)
; RV32-NEXT:    sh a2, 8(a0)
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-NEXT:    vle32.v v8, (a1)
; RV32-NEXT:    vse32.v v8, (a0)
; RV32-NEXT:    li a0, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: memcpy11_align8:
; RV64:       # %bb.0: # %entry
; RV64-NEXT:    lbu a2, 10(a1)
; RV64-NEXT:    sb a2, 10(a0)
; RV64-NEXT:    lh a2, 8(a1)
; RV64-NEXT:    sh a2, 8(a0)
; RV64-NEXT:    ld a1, 0(a1)
; RV64-NEXT:    sd a1, 0(a0)
; RV64-NEXT:    li a0, 0
; RV64-NEXT:    ret
;
; RV32-FAST-LABEL: memcpy11_align8:
; RV32-FAST:       # %bb.0: # %entry
; RV32-FAST-NEXT:    lw a2, 7(a1)
; RV32-FAST-NEXT:    sw a2, 7(a0)
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vle32.v v8, (a1)
; RV32-FAST-NEXT:    vse32.v v8, (a0)
; RV32-FAST-NEXT:    li a0, 0
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: memcpy11_align8:
; RV64-FAST:       # %bb.0: # %entry
; RV64-FAST-NEXT:    lw a2, 7(a1)
; RV64-FAST-NEXT:    sw a2, 7(a0)
; RV64-FAST-NEXT:    ld a1, 0(a1)
; RV64-FAST-NEXT:    sd a1, 0(a0)
; RV64-FAST-NEXT:    li a0, 0
; RV64-FAST-NEXT:    ret
entry:
  call void @llvm.memcpy.inline.p0.p0.i32(ptr align 8 %dest, ptr align 8 %src, i32 11, i1 false)
  ret i32 0
}


declare void @llvm.memcpy.inline.p0.p0.i32(ptr nocapture, ptr nocapture, i32, i1) nounwind
declare void @llvm.memcpy.inline.p0.p0.i64(ptr nocapture, ptr nocapture, i64, i1) nounwind
