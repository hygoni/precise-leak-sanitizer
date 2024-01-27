; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+zvfh,+v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+zvfh,+v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

; This tests a mix of vfmacc and vfmadd by using different operand orders to
; trigger commuting in TwoAddressInstructionPass.

declare <vscale x 1 x half> @llvm.fma.v1f16(<vscale x 1 x half>, <vscale x 1 x half>, <vscale x 1 x half>)

define <vscale x 1 x half> @vfmadd_vv_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb, <vscale x 1 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v9, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 1 x half> @llvm.fma.v1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb, <vscale x 1 x half> %vc)
  ret <vscale x 1 x half> %vd
}

define <vscale x 1 x half> @vfmadd_vf_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf4, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 1 x half> %head, <vscale x 1 x half> poison, <vscale x 1 x i32> zeroinitializer
  %vd = call <vscale x 1 x half> @llvm.fma.v1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %splat, <vscale x 1 x half> %vb)
  ret <vscale x 1 x half> %vd
}

declare <vscale x 2 x half> @llvm.fma.v2f16(<vscale x 2 x half>, <vscale x 2 x half>, <vscale x 2 x half>)

define <vscale x 2 x half> @vfmadd_vv_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vb, <vscale x 2 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v10, v9
; CHECK-NEXT:    ret
  %vd = call <vscale x 2 x half> @llvm.fma.v2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vc, <vscale x 2 x half> %vb)
  ret <vscale x 2 x half> %vd
}

define <vscale x 2 x half> @vfmadd_vf_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, mf2, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 2 x half> %head, <vscale x 2 x half> poison, <vscale x 2 x i32> zeroinitializer
  %vd = call <vscale x 2 x half> @llvm.fma.v2f16(<vscale x 2 x half> %vb, <vscale x 2 x half> %splat, <vscale x 2 x half> %va)
  ret <vscale x 2 x half> %vd
}

declare <vscale x 4 x half> @llvm.fma.v4f16(<vscale x 4 x half>, <vscale x 4 x half>, <vscale x 4 x half>)

define <vscale x 4 x half> @vfmadd_vv_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %vb, <vscale x 4 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v9, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 4 x half> @llvm.fma.v4f16(<vscale x 4 x half> %vb, <vscale x 4 x half> %va, <vscale x 4 x half> %vc)
  ret <vscale x 4 x half> %vd
}

define <vscale x 4 x half> @vfmadd_vf_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m1, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 4 x half> %head, <vscale x 4 x half> poison, <vscale x 4 x i32> zeroinitializer
  %vd = call <vscale x 4 x half> @llvm.fma.v4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %splat, <vscale x 4 x half> %vb)
  ret <vscale x 4 x half> %vd
}

declare <vscale x 8 x half> @llvm.fma.v8f16(<vscale x 8 x half>, <vscale x 8 x half>, <vscale x 8 x half>)

define <vscale x 8 x half> @vfmadd_vv_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x half> %vb, <vscale x 8 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, ma
; CHECK-NEXT:    vfmacc.vv v8, v12, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 8 x half> @llvm.fma.v8f16(<vscale x 8 x half> %vb, <vscale x 8 x half> %vc, <vscale x 8 x half> %va)
  ret <vscale x 8 x half> %vd
}

define <vscale x 8 x half> @vfmadd_vf_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m2, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> poison, <vscale x 8 x i32> zeroinitializer
  %vd = call <vscale x 8 x half> @llvm.fma.v8f16(<vscale x 8 x half> %vb, <vscale x 8 x half> %splat, <vscale x 8 x half> %va)
  ret <vscale x 8 x half> %vd
}

declare <vscale x 16 x half> @llvm.fma.v16f16(<vscale x 16 x half>, <vscale x 16 x half>, <vscale x 16 x half>)

define <vscale x 16 x half> @vfmadd_vv_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %vb, <vscale x 16 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v16, v12
; CHECK-NEXT:    ret
  %vd = call <vscale x 16 x half> @llvm.fma.v16f16(<vscale x 16 x half> %vc, <vscale x 16 x half> %va, <vscale x 16 x half> %vb)
  ret <vscale x 16 x half> %vd
}

define <vscale x 16 x half> @vfmadd_vf_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m4, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 16 x half> %head, <vscale x 16 x half> poison, <vscale x 16 x i32> zeroinitializer
  %vd = call <vscale x 16 x half> @llvm.fma.v16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %splat, <vscale x 16 x half> %vb)
  ret <vscale x 16 x half> %vd
}

declare <vscale x 32 x half> @llvm.fma.v32f16(<vscale x 32 x half>, <vscale x 32 x half>, <vscale x 32 x half>)

define <vscale x 32 x half> @vfmadd_vv_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x half> %vb, <vscale x 32 x half> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re16.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, ma
; CHECK-NEXT:    vfmacc.vv v8, v16, v24
; CHECK-NEXT:    ret
  %vd = call <vscale x 32 x half> @llvm.fma.v32f16(<vscale x 32 x half> %vc, <vscale x 32 x half> %vb, <vscale x 32 x half> %va)
  ret <vscale x 32 x half> %vd
}

define <vscale x 32 x half> @vfmadd_vf_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x half> %vb, half %c) {
; CHECK-LABEL: vfmadd_vf_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16, m8, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x half> poison, half %c, i32 0
  %splat = shufflevector <vscale x 32 x half> %head, <vscale x 32 x half> poison, <vscale x 32 x i32> zeroinitializer
  %vd = call <vscale x 32 x half> @llvm.fma.v32f16(<vscale x 32 x half> %vb, <vscale x 32 x half> %splat, <vscale x 32 x half> %va)
  ret <vscale x 32 x half> %vd
}

declare <vscale x 1 x float> @llvm.fma.v1f32(<vscale x 1 x float>, <vscale x 1 x float>, <vscale x 1 x float>)

define <vscale x 1 x float> @vfmadd_vv_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb, <vscale x 1 x float> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v9, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 1 x float> @llvm.fma.v1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb, <vscale x 1 x float> %vc)
  ret <vscale x 1 x float> %vd
}

define <vscale x 1 x float> @vfmadd_vf_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb, float %c) {
; CHECK-LABEL: vfmadd_vf_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x float> poison, float %c, i32 0
  %splat = shufflevector <vscale x 1 x float> %head, <vscale x 1 x float> poison, <vscale x 1 x i32> zeroinitializer
  %vd = call <vscale x 1 x float> @llvm.fma.v1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %splat, <vscale x 1 x float> %vb)
  ret <vscale x 1 x float> %vd
}

declare <vscale x 2 x float> @llvm.fma.v2f32(<vscale x 2 x float>, <vscale x 2 x float>, <vscale x 2 x float>)

define <vscale x 2 x float> @vfmadd_vv_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vb, <vscale x 2 x float> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v10, v9
; CHECK-NEXT:    ret
  %vd = call <vscale x 2 x float> @llvm.fma.v2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vc, <vscale x 2 x float> %vb)
  ret <vscale x 2 x float> %vd
}

define <vscale x 2 x float> @vfmadd_vf_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vb, float %c) {
; CHECK-LABEL: vfmadd_vf_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x float> poison, float %c, i32 0
  %splat = shufflevector <vscale x 2 x float> %head, <vscale x 2 x float> poison, <vscale x 2 x i32> zeroinitializer
  %vd = call <vscale x 2 x float> @llvm.fma.v2f32(<vscale x 2 x float> %vb, <vscale x 2 x float> %splat, <vscale x 2 x float> %va)
  ret <vscale x 2 x float> %vd
}

declare <vscale x 4 x float> @llvm.fma.v4f32(<vscale x 4 x float>, <vscale x 4 x float>, <vscale x 4 x float>)

define <vscale x 4 x float> @vfmadd_vv_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %vb, <vscale x 4 x float> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v10, v12
; CHECK-NEXT:    ret
  %vd = call <vscale x 4 x float> @llvm.fma.v4f32(<vscale x 4 x float> %vb, <vscale x 4 x float> %va, <vscale x 4 x float> %vc)
  ret <vscale x 4 x float> %vd
}

define <vscale x 4 x float> @vfmadd_vf_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %vb, float %c) {
; CHECK-LABEL: vfmadd_vf_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m2, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x float> poison, float %c, i32 0
  %splat = shufflevector <vscale x 4 x float> %head, <vscale x 4 x float> poison, <vscale x 4 x i32> zeroinitializer
  %vd = call <vscale x 4 x float> @llvm.fma.v4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %splat, <vscale x 4 x float> %vb)
  ret <vscale x 4 x float> %vd
}

declare <vscale x 8 x float> @llvm.fma.v8f32(<vscale x 8 x float>, <vscale x 8 x float>, <vscale x 8 x float>)

define <vscale x 8 x float> @vfmadd_vv_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x float> %vb, <vscale x 8 x float> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vfmacc.vv v8, v16, v12
; CHECK-NEXT:    ret
  %vd = call <vscale x 8 x float> @llvm.fma.v8f32(<vscale x 8 x float> %vb, <vscale x 8 x float> %vc, <vscale x 8 x float> %va)
  ret <vscale x 8 x float> %vd
}

define <vscale x 8 x float> @vfmadd_vf_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x float> %vb, float %c) {
; CHECK-LABEL: vfmadd_vf_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m4, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> poison, float %c, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> poison, <vscale x 8 x i32> zeroinitializer
  %vd = call <vscale x 8 x float> @llvm.fma.v8f32(<vscale x 8 x float> %vb, <vscale x 8 x float> %splat, <vscale x 8 x float> %va)
  ret <vscale x 8 x float> %vd
}

declare <vscale x 16 x float> @llvm.fma.v16f32(<vscale x 16 x float>, <vscale x 16 x float>, <vscale x 16 x float>)

define <vscale x 16 x float> @vfmadd_vv_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %vb, <vscale x 16 x float> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re32.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v24, v16
; CHECK-NEXT:    ret
  %vd = call <vscale x 16 x float> @llvm.fma.v16f32(<vscale x 16 x float> %vc, <vscale x 16 x float> %va, <vscale x 16 x float> %vb)
  ret <vscale x 16 x float> %vd
}

define <vscale x 16 x float> @vfmadd_vf_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %vb, float %c) {
; CHECK-LABEL: vfmadd_vf_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m8, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x float> poison, float %c, i32 0
  %splat = shufflevector <vscale x 16 x float> %head, <vscale x 16 x float> poison, <vscale x 16 x i32> zeroinitializer
  %vd = call <vscale x 16 x float> @llvm.fma.v16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %splat, <vscale x 16 x float> %vb)
  ret <vscale x 16 x float> %vd
}

declare <vscale x 1 x double> @llvm.fma.v1f64(<vscale x 1 x double>, <vscale x 1 x double>, <vscale x 1 x double>)

define <vscale x 1 x double> @vfmadd_vv_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb, <vscale x 1 x double> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v9, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 1 x double> @llvm.fma.v1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb, <vscale x 1 x double> %vc)
  ret <vscale x 1 x double> %vd
}

define <vscale x 1 x double> @vfmadd_vf_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb, double %c) {
; CHECK-LABEL: vfmadd_vf_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v9
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x double> poison, double %c, i32 0
  %splat = shufflevector <vscale x 1 x double> %head, <vscale x 1 x double> poison, <vscale x 1 x i32> zeroinitializer
  %vd = call <vscale x 1 x double> @llvm.fma.v1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %splat, <vscale x 1 x double> %vb)
  ret <vscale x 1 x double> %vd
}

declare <vscale x 2 x double> @llvm.fma.v2f64(<vscale x 2 x double>, <vscale x 2 x double>, <vscale x 2 x double>)

define <vscale x 2 x double> @vfmadd_vv_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vb, <vscale x 2 x double> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v12, v10
; CHECK-NEXT:    ret
  %vd = call <vscale x 2 x double> @llvm.fma.v2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vc, <vscale x 2 x double> %vb)
  ret <vscale x 2 x double> %vd
}

define <vscale x 2 x double> @vfmadd_vf_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vb, double %c) {
; CHECK-LABEL: vfmadd_vf_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v10
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x double> poison, double %c, i32 0
  %splat = shufflevector <vscale x 2 x double> %head, <vscale x 2 x double> poison, <vscale x 2 x i32> zeroinitializer
  %vd = call <vscale x 2 x double> @llvm.fma.v2f64(<vscale x 2 x double> %vb, <vscale x 2 x double> %splat, <vscale x 2 x double> %va)
  ret <vscale x 2 x double> %vd
}

declare <vscale x 4 x double> @llvm.fma.v4f64(<vscale x 4 x double>, <vscale x 4 x double>, <vscale x 4 x double>)

define <vscale x 4 x double> @vfmadd_vv_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %vb, <vscale x 4 x double> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, ma
; CHECK-NEXT:    vfmadd.vv v8, v12, v16
; CHECK-NEXT:    ret
  %vd = call <vscale x 4 x double> @llvm.fma.v4f64(<vscale x 4 x double> %vb, <vscale x 4 x double> %va, <vscale x 4 x double> %vc)
  ret <vscale x 4 x double> %vd
}

define <vscale x 4 x double> @vfmadd_vf_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %vb, double %c) {
; CHECK-LABEL: vfmadd_vf_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m4, ta, ma
; CHECK-NEXT:    vfmadd.vf v8, fa0, v12
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x double> poison, double %c, i32 0
  %splat = shufflevector <vscale x 4 x double> %head, <vscale x 4 x double> poison, <vscale x 4 x i32> zeroinitializer
  %vd = call <vscale x 4 x double> @llvm.fma.v4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %splat, <vscale x 4 x double> %vb)
  ret <vscale x 4 x double> %vd
}

declare <vscale x 8 x double> @llvm.fma.v8f64(<vscale x 8 x double>, <vscale x 8 x double>, <vscale x 8 x double>)

define <vscale x 8 x double> @vfmadd_vv_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x double> %vb, <vscale x 8 x double> %vc) {
; CHECK-LABEL: vfmadd_vv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vl8re64.v v24, (a0)
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, ma
; CHECK-NEXT:    vfmacc.vv v8, v16, v24
; CHECK-NEXT:    ret
  %vd = call <vscale x 8 x double> @llvm.fma.v8f64(<vscale x 8 x double> %vb, <vscale x 8 x double> %vc, <vscale x 8 x double> %va)
  ret <vscale x 8 x double> %vd
}

define <vscale x 8 x double> @vfmadd_vf_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x double> %vb, double %c) {
; CHECK-LABEL: vfmadd_vf_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m8, ta, ma
; CHECK-NEXT:    vfmacc.vf v8, fa0, v16
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> poison, double %c, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> poison, <vscale x 8 x i32> zeroinitializer
  %vd = call <vscale x 8 x double> @llvm.fma.v8f64(<vscale x 8 x double> %vb, <vscale x 8 x double> %splat, <vscale x 8 x double> %va)
  ret <vscale x 8 x double> %vd
}
