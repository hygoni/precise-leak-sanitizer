; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+f,+d,+zfh,+zvfh -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32-BITS-UNKNOWN
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+f,+d,+zfh,+zvfh -riscv-v-vector-bits-max=256 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32-BITS-256
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+f,+d,+zfh,+zvfh -riscv-v-vector-bits-max=512 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32-BITS-512
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+f,+d,+zfh,+zvfh -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64-BITS-UNKNOWN
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+f,+d,+zfh,+zvfh -riscv-v-vector-bits-max=256 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64-BITS-256
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+f,+d,+zfh,+zvfh -riscv-v-vector-bits-max=512 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64-BITS-512

;
; VECTOR_REVERSE - masks
;

define <2 x i1> @reverse_v2i1(<2 x i1> %a) {
; CHECK-LABEL: reverse_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmsne.vi v0, v9, 0
; CHECK-NEXT:    ret
  %res = call <2 x i1> @llvm.experimental.vector.reverse.v2i1(<2 x i1> %a)
  ret <2 x i1> %res
}

define <4 x i1> @reverse_v4i1(<4 x i1> %a) {
; CHECK-LABEL: reverse_v4i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v9, v9, 3
; CHECK-NEXT:    vrgather.vv v10, v8, v9
; CHECK-NEXT:    vmsne.vi v0, v10, 0
; CHECK-NEXT:    ret
  %res = call <4 x i1> @llvm.experimental.vector.reverse.v4i1(<4 x i1> %a)
  ret <4 x i1> %res
}

define <8 x i1> @reverse_v8i1(<8 x i1> %a) {
; CHECK-LABEL: reverse_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v9, v9, 7
; CHECK-NEXT:    vrgather.vv v10, v8, v9
; CHECK-NEXT:    vmsne.vi v0, v10, 0
; CHECK-NEXT:    ret
  %res = call <8 x i1> @llvm.experimental.vector.reverse.v8i1(<8 x i1> %a)
  ret <8 x i1> %res
}

define <16 x i1> @reverse_v16i1(<16 x i1> %a) {
; CHECK-LABEL: reverse_v16i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v9, v9, 15
; CHECK-NEXT:    vrgather.vv v10, v8, v9
; CHECK-NEXT:    vmsne.vi v0, v10, 0
; CHECK-NEXT:    ret
  %res = call <16 x i1> @llvm.experimental.vector.reverse.v16i1(<16 x i1> %a)
  ret <16 x i1> %res
}

define <32 x i1> @reverse_v32i1(<32 x i1> %a) {
; CHECK-LABEL: reverse_v32i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI4_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI4_0)
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vmv.v.i v10, 0
; CHECK-NEXT:    vmerge.vim v10, v10, 1, v0
; CHECK-NEXT:    vrgather.vv v12, v10, v8
; CHECK-NEXT:    vmsne.vi v0, v12, 0
; CHECK-NEXT:    ret
  %res = call <32 x i1> @llvm.experimental.vector.reverse.v32i1(<32 x i1> %a)
  ret <32 x i1> %res
}

define <64 x i1> @reverse_v64i1(<64 x i1> %a) {
; CHECK-LABEL: reverse_v64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI5_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI5_0)
; CHECK-NEXT:    li a1, 64
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vmv.v.i v12, 0
; CHECK-NEXT:    vmerge.vim v12, v12, 1, v0
; CHECK-NEXT:    vrgather.vv v16, v12, v8
; CHECK-NEXT:    vmsne.vi v0, v16, 0
; CHECK-NEXT:    ret
  %res = call <64 x i1> @llvm.experimental.vector.reverse.v64i1(<64 x i1> %a)
  ret <64 x i1> %res
}


define <1 x i8> @reverse_v1i8(<1 x i8> %a) {
; CHECK-LABEL: reverse_v1i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x i8> @llvm.experimental.vector.reverse.v1i8(<1 x i8> %a)
  ret <1 x i8> %res
}

define <2 x i8> @reverse_v2i8(<2 x i8> %a) {
; CHECK-LABEL: reverse_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x i8> @llvm.experimental.vector.reverse.v2i8(<2 x i8> %a)
  ret <2 x i8> %res
}

define <4 x i8> @reverse_v4i8(<4 x i8> %a) {
; CHECK-LABEL: reverse_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 3
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <4 x i8> @llvm.experimental.vector.reverse.v4i8(<4 x i8> %a)
  ret <4 x i8> %res
}

define <8 x i8> @reverse_v8i8(<8 x i8> %a) {
; CHECK-LABEL: reverse_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 7
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <8 x i8> @llvm.experimental.vector.reverse.v8i8(<8 x i8> %a)
  ret <8 x i8> %res
}

define <16 x i8> @reverse_v16i8(<16 x i8> %a) {
; CHECK-LABEL: reverse_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 15
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <16 x i8> @llvm.experimental.vector.reverse.v16i8(<16 x i8> %a)
  ret <16 x i8> %res
}

define <32 x i8> @reverse_v32i8(<32 x i8> %a) {
; CHECK-LABEL: reverse_v32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI11_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI11_0)
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v12, (a0)
; CHECK-NEXT:    vrgather.vv v10, v8, v12
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %res = call <32 x i8> @llvm.experimental.vector.reverse.v32i8(<32 x i8> %a)
  ret <32 x i8> %res
}

define <64 x i8> @reverse_v64i8(<64 x i8> %a) {
; CHECK-LABEL: reverse_v64i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI12_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI12_0)
; CHECK-NEXT:    li a1, 64
; CHECK-NEXT:    vsetvli zero, a1, e8, m4, ta, ma
; CHECK-NEXT:    vle8.v v16, (a0)
; CHECK-NEXT:    vrgather.vv v12, v8, v16
; CHECK-NEXT:    vmv.v.v v8, v12
; CHECK-NEXT:    ret
  %res = call <64 x i8> @llvm.experimental.vector.reverse.v64i8(<64 x i8> %a)
  ret <64 x i8> %res
}

define <1 x i16> @reverse_v1i16(<1 x i16> %a) {
; CHECK-LABEL: reverse_v1i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x i16> @llvm.experimental.vector.reverse.v1i16(<1 x i16> %a)
  ret <1 x i16> %res
}

define <2 x i16> @reverse_v2i16(<2 x i16> %a) {
; CHECK-LABEL: reverse_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x i16> @llvm.experimental.vector.reverse.v2i16(<2 x i16> %a)
  ret <2 x i16> %res
}

define <4 x i16> @reverse_v4i16(<4 x i16> %a) {
; CHECK-LABEL: reverse_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 3
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <4 x i16> @llvm.experimental.vector.reverse.v4i16(<4 x i16> %a)
  ret <4 x i16> %res
}

define <8 x i16> @reverse_v8i16(<8 x i16> %a) {
; CHECK-LABEL: reverse_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 7
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <8 x i16> @llvm.experimental.vector.reverse.v8i16(<8 x i16> %a)
  ret <8 x i16> %res
}

define <16 x i16> @reverse_v16i16(<16 x i16> %a) {
; CHECK-LABEL: reverse_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vid.v v10
; CHECK-NEXT:    vrsub.vi v12, v10, 15
; CHECK-NEXT:    vrgather.vv v10, v8, v12
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %res = call <16 x i16> @llvm.experimental.vector.reverse.v16i16(<16 x i16> %a)
  ret <16 x i16> %res
}

define <32 x i16> @reverse_v32i16(<32 x i16> %a) {
; CHECK-LABEL: reverse_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI18_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI18_0)
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, ma
; CHECK-NEXT:    vle16.v v16, (a0)
; CHECK-NEXT:    vrgather.vv v12, v8, v16
; CHECK-NEXT:    vmv.v.v v8, v12
; CHECK-NEXT:    ret
  %res = call <32 x i16> @llvm.experimental.vector.reverse.v32i16(<32 x i16> %a)
  ret <32 x i16> %res
}

define <1 x i32> @reverse_v1i32(<1 x i32> %a) {
; CHECK-LABEL: reverse_v1i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x i32> @llvm.experimental.vector.reverse.v1i32(<1 x i32> %a)
  ret <1 x i32> %res
}

define <2 x i32> @reverse_v2i32(<2 x i32> %a) {
; CHECK-LABEL: reverse_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x i32> @llvm.experimental.vector.reverse.v2i32(<2 x i32> %a)
  ret <2 x i32> %res
}

define <4 x i32> @reverse_v4i32(<4 x i32> %a) {
; CHECK-LABEL: reverse_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 3
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <4 x i32> @llvm.experimental.vector.reverse.v4i32(<4 x i32> %a)
  ret <4 x i32> %res
}

define <8 x i32> @reverse_v8i32(<8 x i32> %a) {
; CHECK-LABEL: reverse_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vid.v v10
; CHECK-NEXT:    vrsub.vi v12, v10, 7
; CHECK-NEXT:    vrgather.vv v10, v8, v12
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %res = call <8 x i32> @llvm.experimental.vector.reverse.v8i32(<8 x i32> %a)
  ret <8 x i32> %res
}

define <16 x i32> @reverse_v16i32(<16 x i32> %a) {
; CHECK-LABEL: reverse_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; CHECK-NEXT:    vid.v v12
; CHECK-NEXT:    vrsub.vi v16, v12, 15
; CHECK-NEXT:    vrgather.vv v12, v8, v16
; CHECK-NEXT:    vmv.v.v v8, v12
; CHECK-NEXT:    ret
  %res = call <16 x i32> @llvm.experimental.vector.reverse.v16i32(<16 x i32> %a)
  ret <16 x i32> %res
}

define <1 x i64> @reverse_v1i64(<1 x i64> %a) {
; CHECK-LABEL: reverse_v1i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x i64> @llvm.experimental.vector.reverse.v1i64(<1 x i64> %a)
  ret <1 x i64> %res
}

define <2 x i64> @reverse_v2i64(<2 x i64> %a) {
; CHECK-LABEL: reverse_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x i64> @llvm.experimental.vector.reverse.v2i64(<2 x i64> %a)
  ret <2 x i64> %res
}

define <4 x i64> @reverse_v4i64(<4 x i64> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v4i64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vid.v v10
; RV32-BITS-UNKNOWN-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-UNKNOWN-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v4i64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-256-NEXT:    vid.v v10
; RV32-BITS-256-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-256-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-256-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-256-NEXT:    vmv.v.v v8, v10
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v4i64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-512-NEXT:    vid.v v10
; RV32-BITS-512-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-512-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-512-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-512-NEXT:    vmv.v.v v8, v10
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v4i64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v10
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v4i64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-256-NEXT:    vid.v v10
; RV64-BITS-256-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-256-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-256-NEXT:    vmv.v.v v8, v10
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v4i64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-512-NEXT:    vid.v v10
; RV64-BITS-512-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-512-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-512-NEXT:    vmv.v.v v8, v10
; RV64-BITS-512-NEXT:    ret
  %res = call <4 x i64> @llvm.experimental.vector.reverse.v4i64(<4 x i64> %a)
  ret <4 x i64> %res
}

define <8 x i64> @reverse_v8i64(<8 x i64> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v8i64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vid.v v12
; RV32-BITS-UNKNOWN-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-UNKNOWN-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v8i64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-256-NEXT:    vid.v v12
; RV32-BITS-256-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-256-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-256-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-256-NEXT:    vmv.v.v v8, v12
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v8i64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-512-NEXT:    vid.v v12
; RV32-BITS-512-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-512-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-512-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-512-NEXT:    vmv.v.v v8, v12
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v8i64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v12
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v8i64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-256-NEXT:    vid.v v12
; RV64-BITS-256-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-256-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-256-NEXT:    vmv.v.v v8, v12
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v8i64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-512-NEXT:    vid.v v12
; RV64-BITS-512-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-512-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-512-NEXT:    vmv.v.v v8, v12
; RV64-BITS-512-NEXT:    ret
  %res = call <8 x i64> @llvm.experimental.vector.reverse.v8i64(<8 x i64> %a)
  ret <8 x i64> %res
}


define <1 x half> @reverse_v1f16(<1 x half> %a) {
; CHECK-LABEL: reverse_v1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x half> @llvm.experimental.vector.reverse.v1f16(<1 x half> %a)
  ret <1 x half> %res
}

define <2 x half> @reverse_v2f16(<2 x half> %a) {
; CHECK-LABEL: reverse_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x half> @llvm.experimental.vector.reverse.v2f16(<2 x half> %a)
  ret <2 x half> %res
}

define <4 x half> @reverse_v4f16(<4 x half> %a) {
; CHECK-LABEL: reverse_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 3
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <4 x half> @llvm.experimental.vector.reverse.v4f16(<4 x half> %a)
  ret <4 x half> %res
}

define <8 x half> @reverse_v8f16(<8 x half> %a) {
; CHECK-LABEL: reverse_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 7
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <8 x half> @llvm.experimental.vector.reverse.v8f16(<8 x half> %a)
  ret <8 x half> %res
}

define <16 x half> @reverse_v16f16(<16 x half> %a) {
; CHECK-LABEL: reverse_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vid.v v10
; CHECK-NEXT:    vrsub.vi v12, v10, 15
; CHECK-NEXT:    vrgather.vv v10, v8, v12
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %res = call <16 x half> @llvm.experimental.vector.reverse.v16f16(<16 x half> %a)
  ret <16 x half> %res
}

define <32 x half> @reverse_v32f16(<32 x half> %a) {
; CHECK-LABEL: reverse_v32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI33_0)
; CHECK-NEXT:    addi a0, a0, %lo(.LCPI33_0)
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, ma
; CHECK-NEXT:    vle16.v v16, (a0)
; CHECK-NEXT:    vrgather.vv v12, v8, v16
; CHECK-NEXT:    vmv.v.v v8, v12
; CHECK-NEXT:    ret
  %res = call <32 x half> @llvm.experimental.vector.reverse.v32f16(<32 x half> %a)
  ret <32 x half> %res
}

define <1 x float> @reverse_v1f32(<1 x float> %a) {
; CHECK-LABEL: reverse_v1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x float> @llvm.experimental.vector.reverse.v1f32(<1 x float> %a)
  ret <1 x float> %res
}

define <2 x float> @reverse_v2f32(<2 x float> %a) {
; CHECK-LABEL: reverse_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x float> @llvm.experimental.vector.reverse.v2f32(<2 x float> %a)
  ret <2 x float> %res
}

define <4 x float> @reverse_v4f32(<4 x float> %a) {
; CHECK-LABEL: reverse_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vid.v v9
; CHECK-NEXT:    vrsub.vi v10, v9, 3
; CHECK-NEXT:    vrgather.vv v9, v8, v10
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <4 x float> @llvm.experimental.vector.reverse.v4f32(<4 x float> %a)
  ret <4 x float> %res
}

define <8 x float> @reverse_v8f32(<8 x float> %a) {
; CHECK-LABEL: reverse_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vid.v v10
; CHECK-NEXT:    vrsub.vi v12, v10, 7
; CHECK-NEXT:    vrgather.vv v10, v8, v12
; CHECK-NEXT:    vmv.v.v v8, v10
; CHECK-NEXT:    ret
  %res = call <8 x float> @llvm.experimental.vector.reverse.v8f32(<8 x float> %a)
  ret <8 x float> %res
}

define <16 x float> @reverse_v16f32(<16 x float> %a) {
; CHECK-LABEL: reverse_v16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; CHECK-NEXT:    vid.v v12
; CHECK-NEXT:    vrsub.vi v16, v12, 15
; CHECK-NEXT:    vrgather.vv v12, v8, v16
; CHECK-NEXT:    vmv.v.v v8, v12
; CHECK-NEXT:    ret
  %res = call <16 x float> @llvm.experimental.vector.reverse.v16f32(<16 x float> %a)
  ret <16 x float> %res
}

define <1 x double> @reverse_v1f64(<1 x double> %a) {
; CHECK-LABEL: reverse_v1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %res = call <1 x double> @llvm.experimental.vector.reverse.v1f64(<1 x double> %a)
  ret <1 x double> %res
}

define <2 x double> @reverse_v2f64(<2 x double> %a) {
; CHECK-LABEL: reverse_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v9, v8, 1
; CHECK-NEXT:    vslideup.vi v9, v8, 1
; CHECK-NEXT:    vmv.v.v v8, v9
; CHECK-NEXT:    ret
  %res = call <2 x double> @llvm.experimental.vector.reverse.v2f64(<2 x double> %a)
  ret <2 x double> %res
}

define <4 x double> @reverse_v4f64(<4 x double> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v4f64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vid.v v10
; RV32-BITS-UNKNOWN-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-UNKNOWN-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v4f64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-256-NEXT:    vid.v v10
; RV32-BITS-256-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-256-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-256-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-256-NEXT:    vmv.v.v v8, v10
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v4f64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-BITS-512-NEXT:    vid.v v10
; RV32-BITS-512-NEXT:    vrsub.vi v12, v10, 3
; RV32-BITS-512-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV32-BITS-512-NEXT:    vrgatherei16.vv v10, v8, v12
; RV32-BITS-512-NEXT:    vmv.v.v v8, v10
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v4f64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v10
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v4f64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-256-NEXT:    vid.v v10
; RV64-BITS-256-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-256-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-256-NEXT:    vmv.v.v v8, v10
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v4f64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-512-NEXT:    vid.v v10
; RV64-BITS-512-NEXT:    vrsub.vi v12, v10, 3
; RV64-BITS-512-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-512-NEXT:    vmv.v.v v8, v10
; RV64-BITS-512-NEXT:    ret
  %res = call <4 x double> @llvm.experimental.vector.reverse.v4f64(<4 x double> %a)
  ret <4 x double> %res
}

define <8 x double> @reverse_v8f64(<8 x double> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v8f64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vid.v v12
; RV32-BITS-UNKNOWN-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-UNKNOWN-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v8f64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-256-NEXT:    vid.v v12
; RV32-BITS-256-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-256-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-256-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-256-NEXT:    vmv.v.v v8, v12
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v8f64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; RV32-BITS-512-NEXT:    vid.v v12
; RV32-BITS-512-NEXT:    vrsub.vi v16, v12, 7
; RV32-BITS-512-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; RV32-BITS-512-NEXT:    vrgatherei16.vv v12, v8, v16
; RV32-BITS-512-NEXT:    vmv.v.v v8, v12
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v8f64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v12
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v8f64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-256-NEXT:    vid.v v12
; RV64-BITS-256-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-256-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-256-NEXT:    vmv.v.v v8, v12
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v8f64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-512-NEXT:    vid.v v12
; RV64-BITS-512-NEXT:    vrsub.vi v16, v12, 7
; RV64-BITS-512-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-512-NEXT:    vmv.v.v v8, v12
; RV64-BITS-512-NEXT:    ret
  %res = call <8 x double> @llvm.experimental.vector.reverse.v8f64(<8 x double> %a)
  ret <8 x double> %res
}


define <3 x i64> @reverse_v3i64(<3 x i64> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v3i64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    lui a0, %hi(.LCPI43_0)
; RV32-BITS-UNKNOWN-NEXT:    addi a0, a0, %lo(.LCPI43_0)
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vle32.v v12, (a0)
; RV32-BITS-UNKNOWN-NEXT:    vrgather.vv v10, v8, v12
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v3i64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    lui a0, %hi(.LCPI43_0)
; RV32-BITS-256-NEXT:    addi a0, a0, %lo(.LCPI43_0)
; RV32-BITS-256-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-BITS-256-NEXT:    vle32.v v12, (a0)
; RV32-BITS-256-NEXT:    vrgather.vv v10, v8, v12
; RV32-BITS-256-NEXT:    vmv.v.v v8, v10
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v3i64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    lui a0, %hi(.LCPI43_0)
; RV32-BITS-512-NEXT:    addi a0, a0, %lo(.LCPI43_0)
; RV32-BITS-512-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; RV32-BITS-512-NEXT:    vle32.v v12, (a0)
; RV32-BITS-512-NEXT:    vrgather.vv v10, v8, v12
; RV32-BITS-512-NEXT:    vmv.v.v v8, v10
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v3i64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v10
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v12, v10, 2
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v10
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v3i64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-256-NEXT:    vid.v v10
; RV64-BITS-256-NEXT:    vrsub.vi v12, v10, 2
; RV64-BITS-256-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-256-NEXT:    vmv.v.v v8, v10
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v3i64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-BITS-512-NEXT:    vid.v v10
; RV64-BITS-512-NEXT:    vrsub.vi v12, v10, 2
; RV64-BITS-512-NEXT:    vrgather.vv v10, v8, v12
; RV64-BITS-512-NEXT:    vmv.v.v v8, v10
; RV64-BITS-512-NEXT:    ret
  %res = call <3 x i64> @llvm.experimental.vector.reverse.v3i64(<3 x i64> %a)
  ret <3 x i64> %res
}

define <6 x i64> @reverse_v6i64(<6 x i64> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v6i64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    lui a0, %hi(.LCPI44_0)
; RV32-BITS-UNKNOWN-NEXT:    addi a0, a0, %lo(.LCPI44_0)
; RV32-BITS-UNKNOWN-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vle32.v v16, (a0)
; RV32-BITS-UNKNOWN-NEXT:    vrgather.vv v12, v8, v16
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v6i64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    lui a0, %hi(.LCPI44_0)
; RV32-BITS-256-NEXT:    addi a0, a0, %lo(.LCPI44_0)
; RV32-BITS-256-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BITS-256-NEXT:    vle32.v v16, (a0)
; RV32-BITS-256-NEXT:    vrgather.vv v12, v8, v16
; RV32-BITS-256-NEXT:    vmv.v.v v8, v12
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v6i64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    lui a0, %hi(.LCPI44_0)
; RV32-BITS-512-NEXT:    addi a0, a0, %lo(.LCPI44_0)
; RV32-BITS-512-NEXT:    vsetivli zero, 16, e32, m4, ta, ma
; RV32-BITS-512-NEXT:    vle32.v v16, (a0)
; RV32-BITS-512-NEXT:    vrgather.vv v12, v8, v16
; RV32-BITS-512-NEXT:    vmv.v.v v8, v12
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v6i64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v12
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v16, v12, 5
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v12
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v6i64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-256-NEXT:    vid.v v12
; RV64-BITS-256-NEXT:    vrsub.vi v16, v12, 5
; RV64-BITS-256-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-256-NEXT:    vmv.v.v v8, v12
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v6i64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 8, e64, m4, ta, ma
; RV64-BITS-512-NEXT:    vid.v v12
; RV64-BITS-512-NEXT:    vrsub.vi v16, v12, 5
; RV64-BITS-512-NEXT:    vrgather.vv v12, v8, v16
; RV64-BITS-512-NEXT:    vmv.v.v v8, v12
; RV64-BITS-512-NEXT:    ret
  %res = call <6 x i64> @llvm.experimental.vector.reverse.v6i64(<6 x i64> %a)
  ret <6 x i64> %res
}

define <12 x i64> @reverse_v12i64(<12 x i64> %a) {
; RV32-BITS-UNKNOWN-LABEL: reverse_v12i64:
; RV32-BITS-UNKNOWN:       # %bb.0:
; RV32-BITS-UNKNOWN-NEXT:    lui a0, %hi(.LCPI45_0)
; RV32-BITS-UNKNOWN-NEXT:    addi a0, a0, %lo(.LCPI45_0)
; RV32-BITS-UNKNOWN-NEXT:    li a1, 32
; RV32-BITS-UNKNOWN-NEXT:    vsetvli zero, a1, e32, m8, ta, ma
; RV32-BITS-UNKNOWN-NEXT:    vle32.v v24, (a0)
; RV32-BITS-UNKNOWN-NEXT:    vrgather.vv v16, v8, v24
; RV32-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v16
; RV32-BITS-UNKNOWN-NEXT:    ret
;
; RV32-BITS-256-LABEL: reverse_v12i64:
; RV32-BITS-256:       # %bb.0:
; RV32-BITS-256-NEXT:    lui a0, %hi(.LCPI45_0)
; RV32-BITS-256-NEXT:    addi a0, a0, %lo(.LCPI45_0)
; RV32-BITS-256-NEXT:    li a1, 32
; RV32-BITS-256-NEXT:    vsetvli zero, a1, e32, m8, ta, ma
; RV32-BITS-256-NEXT:    vle32.v v24, (a0)
; RV32-BITS-256-NEXT:    vrgather.vv v16, v8, v24
; RV32-BITS-256-NEXT:    vmv.v.v v8, v16
; RV32-BITS-256-NEXT:    ret
;
; RV32-BITS-512-LABEL: reverse_v12i64:
; RV32-BITS-512:       # %bb.0:
; RV32-BITS-512-NEXT:    lui a0, %hi(.LCPI45_0)
; RV32-BITS-512-NEXT:    addi a0, a0, %lo(.LCPI45_0)
; RV32-BITS-512-NEXT:    li a1, 32
; RV32-BITS-512-NEXT:    vsetvli zero, a1, e32, m8, ta, ma
; RV32-BITS-512-NEXT:    vle32.v v24, (a0)
; RV32-BITS-512-NEXT:    vrgather.vv v16, v8, v24
; RV32-BITS-512-NEXT:    vmv.v.v v8, v16
; RV32-BITS-512-NEXT:    ret
;
; RV64-BITS-UNKNOWN-LABEL: reverse_v12i64:
; RV64-BITS-UNKNOWN:       # %bb.0:
; RV64-BITS-UNKNOWN-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BITS-UNKNOWN-NEXT:    vid.v v16
; RV64-BITS-UNKNOWN-NEXT:    vrsub.vi v24, v16, 11
; RV64-BITS-UNKNOWN-NEXT:    vrgather.vv v16, v8, v24
; RV64-BITS-UNKNOWN-NEXT:    vmv.v.v v8, v16
; RV64-BITS-UNKNOWN-NEXT:    ret
;
; RV64-BITS-256-LABEL: reverse_v12i64:
; RV64-BITS-256:       # %bb.0:
; RV64-BITS-256-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BITS-256-NEXT:    vid.v v16
; RV64-BITS-256-NEXT:    vrsub.vi v24, v16, 11
; RV64-BITS-256-NEXT:    vrgather.vv v16, v8, v24
; RV64-BITS-256-NEXT:    vmv.v.v v8, v16
; RV64-BITS-256-NEXT:    ret
;
; RV64-BITS-512-LABEL: reverse_v12i64:
; RV64-BITS-512:       # %bb.0:
; RV64-BITS-512-NEXT:    vsetivli zero, 16, e64, m8, ta, ma
; RV64-BITS-512-NEXT:    vid.v v16
; RV64-BITS-512-NEXT:    vrsub.vi v24, v16, 11
; RV64-BITS-512-NEXT:    vrgather.vv v16, v8, v24
; RV64-BITS-512-NEXT:    vmv.v.v v8, v16
; RV64-BITS-512-NEXT:    ret
  %res = call <12 x i64> @llvm.experimental.vector.reverse.v12i64(<12 x i64> %a)
  ret <12 x i64> %res
}

declare <2 x i1> @llvm.experimental.vector.reverse.v2i1(<2 x i1>)
declare <4 x i1> @llvm.experimental.vector.reverse.v4i1(<4 x i1>)
declare <8 x i1> @llvm.experimental.vector.reverse.v8i1(<8 x i1>)
declare <16 x i1> @llvm.experimental.vector.reverse.v16i1(<16 x i1>)
declare <32 x i1> @llvm.experimental.vector.reverse.v32i1(<32 x i1>)
declare <64 x i1> @llvm.experimental.vector.reverse.v64i1(<64 x i1>)
declare <1 x i8> @llvm.experimental.vector.reverse.v1i8(<1 x i8>)
declare <2 x i8> @llvm.experimental.vector.reverse.v2i8(<2 x i8>)
declare <4 x i8> @llvm.experimental.vector.reverse.v4i8(<4 x i8>)
declare <8 x i8> @llvm.experimental.vector.reverse.v8i8(<8 x i8>)
declare <16 x i8> @llvm.experimental.vector.reverse.v16i8(<16 x i8>)
declare <32 x i8> @llvm.experimental.vector.reverse.v32i8(<32 x i8>)
declare <64 x i8> @llvm.experimental.vector.reverse.v64i8(<64 x i8>)
declare <1 x i16> @llvm.experimental.vector.reverse.v1i16(<1 x i16>)
declare <2 x i16> @llvm.experimental.vector.reverse.v2i16(<2 x i16>)
declare <4 x i16> @llvm.experimental.vector.reverse.v4i16(<4 x i16>)
declare <8 x i16> @llvm.experimental.vector.reverse.v8i16(<8 x i16>)
declare <16 x i16> @llvm.experimental.vector.reverse.v16i16(<16 x i16>)
declare <32 x i16> @llvm.experimental.vector.reverse.v32i16(<32 x i16>)
declare <1 x i32> @llvm.experimental.vector.reverse.v1i32(<1 x i32>)
declare <2 x i32> @llvm.experimental.vector.reverse.v2i32(<2 x i32>)
declare <4 x i32> @llvm.experimental.vector.reverse.v4i32(<4 x i32>)
declare <8 x i32> @llvm.experimental.vector.reverse.v8i32(<8 x i32>)
declare <16 x i32> @llvm.experimental.vector.reverse.v16i32(<16 x i32>)
declare <1 x i64> @llvm.experimental.vector.reverse.v1i64(<1 x i64>)
declare <2 x i64> @llvm.experimental.vector.reverse.v2i64(<2 x i64>)
declare <4 x i64> @llvm.experimental.vector.reverse.v4i64(<4 x i64>)
declare <8 x i64> @llvm.experimental.vector.reverse.v8i64(<8 x i64>)
declare <1 x half> @llvm.experimental.vector.reverse.v1f16(<1 x half>)
declare <2 x half> @llvm.experimental.vector.reverse.v2f16(<2 x half>)
declare <4 x half> @llvm.experimental.vector.reverse.v4f16(<4 x half>)
declare <8 x half> @llvm.experimental.vector.reverse.v8f16(<8 x half>)
declare <16 x half> @llvm.experimental.vector.reverse.v16f16(<16 x half>)
declare <32 x half> @llvm.experimental.vector.reverse.v32f16(<32 x half>)
declare <1 x float> @llvm.experimental.vector.reverse.v1f32(<1 x float>)
declare <2 x float> @llvm.experimental.vector.reverse.v2f32(<2 x float>)
declare <4 x float> @llvm.experimental.vector.reverse.v4f32(<4 x float>)
declare <8 x float> @llvm.experimental.vector.reverse.v8f32(<8 x float>)
declare <16 x float> @llvm.experimental.vector.reverse.v16f32(<16 x float>)
declare <1 x double> @llvm.experimental.vector.reverse.v1f64(<1 x double>)
declare <2 x double> @llvm.experimental.vector.reverse.v2f64(<2 x double>)
declare <4 x double> @llvm.experimental.vector.reverse.v4f64(<4 x double>)
declare <8 x double> @llvm.experimental.vector.reverse.v8f64(<8 x double>)
declare <3 x i64> @llvm.experimental.vector.reverse.v3i64(<3 x i64>)
declare <6 x i64> @llvm.experimental.vector.reverse.v6i64(<6 x i64>)
declare <12 x i64> @llvm.experimental.vector.reverse.v12i64(<12 x i64>)
