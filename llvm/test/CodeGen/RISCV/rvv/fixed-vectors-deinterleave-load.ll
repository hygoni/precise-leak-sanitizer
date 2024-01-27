; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+v,+zfh,+zvfh | FileCheck %s -check-prefixes=CHECK,RV32
; RUN: llc < %s -mtriple=riscv64 -mattr=+v,+zfh,+zvfh | FileCheck %s -check-prefixes=CHECK,RV64

; Integers

define {<16 x i1>, <16 x i1>} @vector_deinterleave_load_v16i1_v32i1(ptr %p) {
; RV32-LABEL: vector_deinterleave_load_v16i1_v32i1:
; RV32:       # %bb.0:
; RV32-NEXT:    li a1, 32
; RV32-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; RV32-NEXT:    vlm.v v0, (a0)
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v10, v8, 1, v0
; RV32-NEXT:    vid.v v9
; RV32-NEXT:    vadd.vv v11, v9, v9
; RV32-NEXT:    vrgather.vv v9, v10, v11
; RV32-NEXT:    vsetivli zero, 2, e8, mf4, ta, ma
; RV32-NEXT:    vslidedown.vi v0, v0, 2
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV32-NEXT:    vmerge.vim v8, v8, 1, v0
; RV32-NEXT:    vadd.vi v12, v11, -16
; RV32-NEXT:    lui a0, 16
; RV32-NEXT:    addi a0, a0, -256
; RV32-NEXT:    vsetivli zero, 1, e16, mf4, ta, ma
; RV32-NEXT:    vmv.v.x v0, a0
; RV32-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV32-NEXT:    vrgather.vv v9, v8, v12, v0.t
; RV32-NEXT:    vmsne.vi v9, v9, 0
; RV32-NEXT:    vadd.vi v12, v11, 1
; RV32-NEXT:    vrgather.vv v13, v10, v12
; RV32-NEXT:    vadd.vi v10, v11, -15
; RV32-NEXT:    vrgather.vv v13, v8, v10, v0.t
; RV32-NEXT:    vmsne.vi v8, v13, 0
; RV32-NEXT:    vmv.v.v v0, v9
; RV32-NEXT:    ret
;
; RV64-LABEL: vector_deinterleave_load_v16i1_v32i1:
; RV64:       # %bb.0:
; RV64-NEXT:    li a1, 32
; RV64-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; RV64-NEXT:    vlm.v v0, (a0)
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v10, v8, 1, v0
; RV64-NEXT:    vid.v v9
; RV64-NEXT:    vadd.vv v11, v9, v9
; RV64-NEXT:    vrgather.vv v9, v10, v11
; RV64-NEXT:    vsetivli zero, 2, e8, mf4, ta, ma
; RV64-NEXT:    vslidedown.vi v0, v0, 2
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; RV64-NEXT:    vmerge.vim v8, v8, 1, v0
; RV64-NEXT:    vadd.vi v12, v11, -16
; RV64-NEXT:    lui a0, 16
; RV64-NEXT:    addiw a0, a0, -256
; RV64-NEXT:    vsetivli zero, 1, e16, mf4, ta, ma
; RV64-NEXT:    vmv.v.x v0, a0
; RV64-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; RV64-NEXT:    vrgather.vv v9, v8, v12, v0.t
; RV64-NEXT:    vmsne.vi v9, v9, 0
; RV64-NEXT:    vadd.vi v12, v11, 1
; RV64-NEXT:    vrgather.vv v13, v10, v12
; RV64-NEXT:    vadd.vi v10, v11, -15
; RV64-NEXT:    vrgather.vv v13, v8, v10, v0.t
; RV64-NEXT:    vmsne.vi v8, v13, 0
; RV64-NEXT:    vmv.v.v v0, v9
; RV64-NEXT:    ret
  %vec = load <32 x i1>, ptr %p
  %retval = call {<16 x i1>, <16 x i1>} @llvm.experimental.vector.deinterleave2.v32i1(<32 x i1> %vec)
  ret {<16 x i1>, <16 x i1>} %retval
}

define {<16 x i8>, <16 x i8>} @vector_deinterleave_load_v16i8_v32i8(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v16i8_v32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vlseg2e8.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <32 x i8>, ptr %p
  %retval = call {<16 x i8>, <16 x i8>} @llvm.experimental.vector.deinterleave2.v32i8(<32 x i8> %vec)
  ret {<16 x i8>, <16 x i8>} %retval
}

; Shouldn't be lowered to vlseg because it's unaligned
define {<8 x i16>, <8 x i16>} @vector_deinterleave_load_v8i16_v16i16_align1(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v8i16_v16i16_align1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v10, (a0)
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vnsrl.wi v8, v10, 0
; CHECK-NEXT:    vnsrl.wi v9, v10, 16
; CHECK-NEXT:    ret
  %vec = load <16 x i16>, ptr %p, align 1
  %retval = call {<8 x i16>, <8 x i16>} @llvm.experimental.vector.deinterleave2.v16i16(<16 x i16> %vec)
  ret {<8 x i16>, <8 x i16>} %retval
}

define {<8 x i16>, <8 x i16>} @vector_deinterleave_load_v8i16_v16i16(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v8i16_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vlseg2e16.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <16 x i16>, ptr %p
  %retval = call {<8 x i16>, <8 x i16>} @llvm.experimental.vector.deinterleave2.v16i16(<16 x i16> %vec)
  ret {<8 x i16>, <8 x i16>} %retval
}

define {<4 x i32>, <4 x i32>} @vector_deinterleave_load_v4i32_vv8i32(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v4i32_vv8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vlseg2e32.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <8 x i32>, ptr %p
  %retval = call {<4 x i32>, <4 x i32>} @llvm.experimental.vector.deinterleave2.v8i32(<8 x i32> %vec)
  ret {<4 x i32>, <4 x i32>} %retval
}

define {<2 x i64>, <2 x i64>} @vector_deinterleave_load_v2i64_v4i64(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v2i64_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vlseg2e64.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <4 x i64>, ptr %p
  %retval = call {<2 x i64>, <2 x i64>} @llvm.experimental.vector.deinterleave2.v4i64(<4 x i64> %vec)
  ret {<2 x i64>, <2 x i64>} %retval
}

declare {<16 x i1>, <16 x i1>} @llvm.experimental.vector.deinterleave2.v32i1(<32 x i1>)
declare {<16 x i8>, <16 x i8>} @llvm.experimental.vector.deinterleave2.v32i8(<32 x i8>)
declare {<8 x i16>, <8 x i16>} @llvm.experimental.vector.deinterleave2.v16i16(<16 x i16>)
declare {<4 x i32>, <4 x i32>} @llvm.experimental.vector.deinterleave2.v8i32(<8 x i32>)
declare {<2 x i64>, <2 x i64>} @llvm.experimental.vector.deinterleave2.v4i64(<4 x i64>)

; Floats

define {<2 x half>, <2 x half>} @vector_deinterleave_load_v2f16_v4f16(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v2f16_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; CHECK-NEXT:    vlseg2e16.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <4 x half>, ptr %p
  %retval = call {<2 x half>, <2 x half>} @llvm.experimental.vector.deinterleave2.v4f16(<4 x half> %vec)
  ret {<2 x half>, <2 x half>} %retval
}

define {<4 x half>, <4 x half>} @vector_deinterleave_load_v4f16_v8f16(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v4f16_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; CHECK-NEXT:    vlseg2e16.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <8 x half>, ptr %p
  %retval = call {<4 x half>, <4 x half>} @llvm.experimental.vector.deinterleave2.v8f16(<8 x half> %vec)
  ret {<4 x half>, <4 x half>} %retval
}

define {<2 x float>, <2 x float>} @vector_deinterleave_load_v2f32_v4f32(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v2f32_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; CHECK-NEXT:    vlseg2e32.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <4 x float>, ptr %p
  %retval = call {<2 x float>, <2 x float>} @llvm.experimental.vector.deinterleave2.v4f32(<4 x float> %vec)
  ret {<2 x float>, <2 x float>} %retval
}

define {<8 x half>, <8 x half>} @vector_deinterleave_load_v8f16_v16f16(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v8f16_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vlseg2e16.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <16 x half>, ptr %p
  %retval = call {<8 x half>, <8 x half>} @llvm.experimental.vector.deinterleave2.v16f16(<16 x half> %vec)
  ret {<8 x half>, <8 x half>} %retval
}

define {<4 x float>, <4 x float>} @vector_deinterleave_load_v4f32_v8f32(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v4f32_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vlseg2e32.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <8 x float>, ptr %p
  %retval = call {<4 x float>, <4 x float>} @llvm.experimental.vector.deinterleave2.v8f32(<8 x float> %vec)
  ret  {<4 x float>, <4 x float>} %retval
}

define {<2 x double>, <2 x double>} @vector_deinterleave_load_v2f64_v4f64(ptr %p) {
; CHECK-LABEL: vector_deinterleave_load_v2f64_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vlseg2e64.v v8, (a0)
; CHECK-NEXT:    ret
  %vec = load <4 x double>, ptr %p
  %retval = call {<2 x double>, <2 x double>} @llvm.experimental.vector.deinterleave2.v4f64(<4 x double> %vec)
  ret {<2 x double>, <2 x double>} %retval
}

declare {<2 x half>,<2 x half>} @llvm.experimental.vector.deinterleave2.v4f16(<4 x half>)
declare {<4 x half>, <4 x half>} @llvm.experimental.vector.deinterleave2.v8f16(<8 x half>)
declare {<2 x float>, <2 x float>} @llvm.experimental.vector.deinterleave2.v4f32(<4 x float>)
declare {<8 x half>, <8 x half>} @llvm.experimental.vector.deinterleave2.v16f16(<16 x half>)
declare {<4 x float>, <4 x float>} @llvm.experimental.vector.deinterleave2.v8f32(<8 x float>)
declare {<2 x double>, <2 x double>} @llvm.experimental.vector.deinterleave2.v4f64(<4 x double>)
