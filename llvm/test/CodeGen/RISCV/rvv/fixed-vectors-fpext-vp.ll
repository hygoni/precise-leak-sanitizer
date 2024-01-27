; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+zvfh,+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+zvfh,+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s

declare <2 x float> @llvm.vp.fpext.v2f32.v2f16(<2 x half>, <2 x i1>, i32)

define <2 x float> @vfpext_v2f16_v2f32(<2 x half> %a, <2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f16_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <2 x float> @llvm.vp.fpext.v2f32.v2f16(<2 x half> %a, <2 x i1> %m, i32 %vl)
  ret <2 x float> %v
}

define <2 x float> @vfpext_v2f16_v2f32_unmasked(<2 x half> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f16_v2f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <2 x float> @llvm.vp.fpext.v2f32.v2f16(<2 x half> %a, <2 x i1> shufflevector (<2 x i1> insertelement (<2 x i1> undef, i1 true, i32 0), <2 x i1> undef, <2 x i32> zeroinitializer), i32 %vl)
  ret <2 x float> %v
}

declare <2 x double> @llvm.vp.fpext.v2f64.v2f16(<2 x half>, <2 x i1>, i32)

define <2 x double> @vfpext_v2f16_v2f64(<2 x half> %a, <2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f16_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.vp.fpext.v2f64.v2f16(<2 x half> %a, <2 x i1> %m, i32 %vl)
  ret <2 x double> %v
}

define <2 x double> @vfpext_v2f16_v2f64_unmasked(<2 x half> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f16_v2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v8, v9
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.vp.fpext.v2f64.v2f16(<2 x half> %a, <2 x i1> shufflevector (<2 x i1> insertelement (<2 x i1> undef, i1 true, i32 0), <2 x i1> undef, <2 x i32> zeroinitializer), i32 %vl)
  ret <2 x double> %v
}

declare <2 x double> @llvm.vp.fpext.v2f64.v2f32(<2 x float>, <2 x i1>, i32)

define <2 x double> @vfpext_v2f32_v2f64(<2 x float> %a, <2 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f32_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8, v0.t
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.vp.fpext.v2f64.v2f32(<2 x float> %a, <2 x i1> %m, i32 %vl)
  ret <2 x double> %v
}

define <2 x double> @vfpext_v2f32_v2f64_unmasked(<2 x float> %a, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v2f32_v2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v9, v8
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %v = call <2 x double> @llvm.vp.fpext.v2f64.v2f32(<2 x float> %a, <2 x i1> shufflevector (<2 x i1> insertelement (<2 x i1> undef, i1 true, i32 0), <2 x i1> undef, <2 x i32> zeroinitializer), i32 %vl)
  ret <2 x double> %v
}

declare <15 x double> @llvm.vp.fpext.v15f64.v15f32(<15 x float>, <15 x i1>, i32)

define <15 x double> @vfpext_v15f32_v15f64(<15 x float> %a, <15 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v15f32_v15f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vfwcvt.f.f.v v16, v8, v0.t
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    ret
  %v = call <15 x double> @llvm.vp.fpext.v15f64.v15f32(<15 x float> %a, <15 x i1> %m, i32 %vl)
  ret <15 x double> %v
}

declare <32 x double> @llvm.vp.fpext.v32f64.v32f32(<32 x float>, <32 x i1>, i32)

define <32 x double> @vfpext_v32f32_v32f64(<32 x float> %a, <32 x i1> %m, i32 zeroext %vl) {
; CHECK-LABEL: vfpext_v32f32_v32f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, ma
; CHECK-NEXT:    vslidedown.vi v0, v0, 2
; CHECK-NEXT:    addi a1, a0, -16
; CHECK-NEXT:    sltu a2, a0, a1
; CHECK-NEXT:    addi a2, a2, -1
; CHECK-NEXT:    and a1, a2, a1
; CHECK-NEXT:    vsetivli zero, 16, e32, m8, ta, ma
; CHECK-NEXT:    vslidedown.vi v24, v8, 16
; CHECK-NEXT:    vsetvli zero, a1, e32, m4, ta, ma
; CHECK-NEXT:    li a1, 16
; CHECK-NEXT:    vfwcvt.f.f.v v16, v24, v0.t
; CHECK-NEXT:    bltu a0, a1, .LBB7_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a0, 16
; CHECK-NEXT:  .LBB7_2:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v1
; CHECK-NEXT:    vfwcvt.f.f.v v24, v8, v0.t
; CHECK-NEXT:    vmv8r.v v8, v24
; CHECK-NEXT:    ret
  %v = call <32 x double> @llvm.vp.fpext.v32f64.v32f32(<32 x float> %a, <32 x i1> %m, i32 %vl)
  ret <32 x double> %v
}
