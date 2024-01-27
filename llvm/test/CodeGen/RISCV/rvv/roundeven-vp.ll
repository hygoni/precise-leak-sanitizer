; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d,+zfh,+zvfh,+v -target-abi=ilp32d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+zfh,+zvfh,+v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

declare <vscale x 1 x half> @llvm.vp.roundeven.nxv1f16(<vscale x 1 x half>, <vscale x 1 x i1>, i32)

define <vscale x 1 x half> @vp_roundeven_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI0_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI0_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x half> @llvm.vp.roundeven.nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x half> %v
}

define <vscale x 1 x half> @vp_roundeven_nxv1f16_unmasked(<vscale x 1 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI1_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI1_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, mf4, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 1 x i1> %head, <vscale x 1 x i1> poison, <vscale x 1 x i32> zeroinitializer
  %v = call <vscale x 1 x half> @llvm.vp.roundeven.nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x half> %v
}

declare <vscale x 2 x half> @llvm.vp.roundeven.nxv2f16(<vscale x 2 x half>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vp_roundeven_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI2_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI2_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.roundeven.nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vp_roundeven_nxv2f16_unmasked(<vscale x 2 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI3_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI3_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 2 x i1> %head, <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer
  %v = call <vscale x 2 x half> @llvm.vp.roundeven.nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 4 x half> @llvm.vp.roundeven.nxv4f16(<vscale x 4 x half>, <vscale x 4 x i1>, i32)

define <vscale x 4 x half> @vp_roundeven_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI4_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI4_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, m1, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x half> @llvm.vp.roundeven.nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x half> %v
}

define <vscale x 4 x half> @vp_roundeven_nxv4f16_unmasked(<vscale x 4 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI5_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI5_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 4 x i1> %head, <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer
  %v = call <vscale x 4 x half> @llvm.vp.roundeven.nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x half> %v
}

declare <vscale x 8 x half> @llvm.vp.roundeven.nxv8f16(<vscale x 8 x half>, <vscale x 8 x i1>, i32)

define <vscale x 8 x half> @vp_roundeven_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v10, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI6_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI6_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m2, ta, mu
; CHECK-NEXT:    vmflt.vf v10, v12, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, m2, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v10
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x half> @llvm.vp.roundeven.nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x half> %v
}

define <vscale x 8 x half> @vp_roundeven_nxv8f16_unmasked(<vscale x 8 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI7_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI7_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m2, ta, ma
; CHECK-NEXT:    vfabs.v v10, v8
; CHECK-NEXT:    vmflt.vf v0, v10, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v10, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v10, v10, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v10, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 8 x i1> %head, <vscale x 8 x i1> poison, <vscale x 8 x i32> zeroinitializer
  %v = call <vscale x 8 x half> @llvm.vp.roundeven.nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x half> %v
}

declare <vscale x 16 x half> @llvm.vp.roundeven.nxv16f16(<vscale x 16 x half>, <vscale x 16 x i1>, i32)

define <vscale x 16 x half> @vp_roundeven_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v12, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI8_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI8_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m4, ta, mu
; CHECK-NEXT:    vmflt.vf v12, v16, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, m4, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v12
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x half> @llvm.vp.roundeven.nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x half> %v
}

define <vscale x 16 x half> @vp_roundeven_nxv16f16_unmasked(<vscale x 16 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI9_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI9_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8
; CHECK-NEXT:    vmflt.vf v0, v12, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 16 x i1> %head, <vscale x 16 x i1> poison, <vscale x 16 x i32> zeroinitializer
  %v = call <vscale x 16 x half> @llvm.vp.roundeven.nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x half> %v
}

declare <vscale x 32 x half> @llvm.vp.roundeven.nxv32f16(<vscale x 32 x half>, <vscale x 32 x i1>, i32)

define <vscale x 32 x half> @vp_roundeven_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v16, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI10_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI10_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v16, v24, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e16, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v16
; CHECK-NEXT:    vfcvt.x.f.v v24, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v24, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 32 x half> @llvm.vp.roundeven.nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x i1> %m, i32 %evl)
  ret <vscale x 32 x half> %v
}

define <vscale x 32 x half> @vp_roundeven_nxv32f16_unmasked(<vscale x 32 x half> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv32f16_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI11_0)
; CHECK-NEXT:    flh fa5, %lo(.LCPI11_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8
; CHECK-NEXT:    vmflt.vf v0, v16, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e16, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 32 x i1> %head, <vscale x 32 x i1> poison, <vscale x 32 x i32> zeroinitializer
  %v = call <vscale x 32 x half> @llvm.vp.roundeven.nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x i1> %m, i32 %evl)
  ret <vscale x 32 x half> %v
}

declare <vscale x 1 x float> @llvm.vp.roundeven.nxv1f32(<vscale x 1 x float>, <vscale x 1 x i1>, i32)

define <vscale x 1 x float> @vp_roundeven_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x float> @llvm.vp.roundeven.nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x float> %v
}

define <vscale x 1 x float> @vp_roundeven_nxv1f32_unmasked(<vscale x 1 x float> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, mf2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 1 x i1> %head, <vscale x 1 x i1> poison, <vscale x 1 x i32> zeroinitializer
  %v = call <vscale x 1 x float> @llvm.vp.roundeven.nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x float> %v
}

declare <vscale x 2 x float> @llvm.vp.roundeven.nxv2f32(<vscale x 2 x float>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vp_roundeven_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.roundeven.nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vp_roundeven_nxv2f32_unmasked(<vscale x 2 x float> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 2 x i1> %head, <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer
  %v = call <vscale x 2 x float> @llvm.vp.roundeven.nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 4 x float> @llvm.vp.roundeven.nxv4f32(<vscale x 4 x float>, <vscale x 4 x i1>, i32)

define <vscale x 4 x float> @vp_roundeven_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v10, v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8, v0.t
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; CHECK-NEXT:    vmflt.vf v10, v12, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v10
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x float> @llvm.vp.roundeven.nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x float> %v
}

define <vscale x 4 x float> @vp_roundeven_nxv4f32_unmasked(<vscale x 4 x float> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m2, ta, ma
; CHECK-NEXT:    vfabs.v v10, v8
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vmflt.vf v0, v10, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v10, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v10, v10, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v10, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 4 x i1> %head, <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer
  %v = call <vscale x 4 x float> @llvm.vp.roundeven.nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x float> %v
}

declare <vscale x 8 x float> @llvm.vp.roundeven.nxv8f32(<vscale x 8 x float>, <vscale x 8 x i1>, i32)

define <vscale x 8 x float> @vp_roundeven_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v12, v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8, v0.t
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; CHECK-NEXT:    vmflt.vf v12, v16, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v12
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x float> @llvm.vp.roundeven.nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x float> %v
}

define <vscale x 8 x float> @vp_roundeven_nxv8f32_unmasked(<vscale x 8 x float> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m4, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vmflt.vf v0, v12, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 8 x i1> %head, <vscale x 8 x i1> poison, <vscale x 8 x i32> zeroinitializer
  %v = call <vscale x 8 x float> @llvm.vp.roundeven.nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x float> %v
}

declare <vscale x 16 x float> @llvm.vp.roundeven.nxv16f32(<vscale x 16 x float>, <vscale x 16 x i1>, i32)

define <vscale x 16 x float> @vp_roundeven_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v16, v0
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v8, v0.t
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v16, v24, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v16
; CHECK-NEXT:    vfcvt.x.f.v v24, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v24, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x float> @llvm.vp.roundeven.nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x float> %v
}

define <vscale x 16 x float> @vp_roundeven_nxv16f32_unmasked(<vscale x 16 x float> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f32_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m8, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8
; CHECK-NEXT:    lui a0, 307200
; CHECK-NEXT:    fmv.w.x fa5, a0
; CHECK-NEXT:    vmflt.vf v0, v16, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e32, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 16 x i1> %head, <vscale x 16 x i1> poison, <vscale x 16 x i32> zeroinitializer
  %v = call <vscale x 16 x float> @llvm.vp.roundeven.nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x float> %v
}

declare <vscale x 1 x double> @llvm.vp.roundeven.nxv1f64(<vscale x 1 x double>, <vscale x 1 x i1>, i32)

define <vscale x 1 x double> @vp_roundeven_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI22_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI22_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; CHECK-NEXT:    vmflt.vf v0, v9, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 1 x double> @llvm.vp.roundeven.nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x double> %v
}

define <vscale x 1 x double> @vp_roundeven_nxv1f64_unmasked(<vscale x 1 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv1f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI23_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI23_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfabs.v v9, v8
; CHECK-NEXT:    vmflt.vf v0, v9, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v9, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v9, v9, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v9, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 1 x i1> %head, <vscale x 1 x i1> poison, <vscale x 1 x i32> zeroinitializer
  %v = call <vscale x 1 x double> @llvm.vp.roundeven.nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x i1> %m, i32 %evl)
  ret <vscale x 1 x double> %v
}

declare <vscale x 2 x double> @llvm.vp.roundeven.nxv2f64(<vscale x 2 x double>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vp_roundeven_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v10, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI24_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI24_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; CHECK-NEXT:    vmflt.vf v10, v12, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v10
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.roundeven.nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vp_roundeven_nxv2f64_unmasked(<vscale x 2 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv2f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI25_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI25_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, ma
; CHECK-NEXT:    vfabs.v v10, v8
; CHECK-NEXT:    vmflt.vf v0, v10, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v10, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v10, v10, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m2, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v10, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 2 x i1> %head, <vscale x 2 x i1> poison, <vscale x 2 x i32> zeroinitializer
  %v = call <vscale x 2 x double> @llvm.vp.roundeven.nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

declare <vscale x 4 x double> @llvm.vp.roundeven.nxv4f64(<vscale x 4 x double>, <vscale x 4 x i1>, i32)

define <vscale x 4 x double> @vp_roundeven_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v12, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI26_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI26_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; CHECK-NEXT:    vmflt.vf v12, v16, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v12
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 4 x double> @llvm.vp.roundeven.nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x double> %v
}

define <vscale x 4 x double> @vp_roundeven_nxv4f64_unmasked(<vscale x 4 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv4f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI27_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI27_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m4, ta, ma
; CHECK-NEXT:    vfabs.v v12, v8
; CHECK-NEXT:    vmflt.vf v0, v12, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v12, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v12, v12, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m4, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v12, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 4 x i1> %head, <vscale x 4 x i1> poison, <vscale x 4 x i32> zeroinitializer
  %v = call <vscale x 4 x double> @llvm.vp.roundeven.nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x i1> %m, i32 %evl)
  ret <vscale x 4 x double> %v
}

declare <vscale x 7 x double> @llvm.vp.roundeven.nxv7f64(<vscale x 7 x double>, <vscale x 7 x i1>, i32)

define <vscale x 7 x double> @vp_roundeven_nxv7f64(<vscale x 7 x double> %va, <vscale x 7 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv7f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v16, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI28_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI28_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v16, v24, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v16
; CHECK-NEXT:    vfcvt.x.f.v v24, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v24, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 7 x double> @llvm.vp.roundeven.nxv7f64(<vscale x 7 x double> %va, <vscale x 7 x i1> %m, i32 %evl)
  ret <vscale x 7 x double> %v
}

define <vscale x 7 x double> @vp_roundeven_nxv7f64_unmasked(<vscale x 7 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv7f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI29_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI29_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8
; CHECK-NEXT:    vmflt.vf v0, v16, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 7 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 7 x i1> %head, <vscale x 7 x i1> poison, <vscale x 7 x i32> zeroinitializer
  %v = call <vscale x 7 x double> @llvm.vp.roundeven.nxv7f64(<vscale x 7 x double> %va, <vscale x 7 x i1> %m, i32 %evl)
  ret <vscale x 7 x double> %v
}

declare <vscale x 8 x double> @llvm.vp.roundeven.nxv8f64(<vscale x 8 x double>, <vscale x 8 x i1>, i32)

define <vscale x 8 x double> @vp_roundeven_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v16, v0
; CHECK-NEXT:    lui a1, %hi(.LCPI30_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI30_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v16, v24, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v16
; CHECK-NEXT:    vfcvt.x.f.v v24, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v24, v8, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 8 x double> @llvm.vp.roundeven.nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x double> %v
}

define <vscale x 8 x double> @vp_roundeven_nxv8f64_unmasked(<vscale x 8 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv8f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a1, %hi(.LCPI31_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI31_0)(a1)
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v16, v8
; CHECK-NEXT:    vmflt.vf v0, v16, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 8 x i1> %head, <vscale x 8 x i1> poison, <vscale x 8 x i32> zeroinitializer
  %v = call <vscale x 8 x double> @llvm.vp.roundeven.nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x i1> %m, i32 %evl)
  ret <vscale x 8 x double> %v
}

; Test splitting.
declare <vscale x 16 x double> @llvm.vp.roundeven.nxv16f64(<vscale x 16 x double>, <vscale x 16 x i1>, i32)

define <vscale x 16 x double> @vp_roundeven_nxv16f64(<vscale x 16 x double> %va, <vscale x 16 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    slli a1, a1, 3
; CHECK-NEXT:    sub sp, sp, a1
; CHECK-NEXT:    .cfi_escape 0x0f, 0x0d, 0x72, 0x00, 0x11, 0x10, 0x22, 0x11, 0x08, 0x92, 0xa2, 0x38, 0x00, 0x1e, 0x22 # sp + 16 + 8 * vlenb
; CHECK-NEXT:    vmv1r.v v1, v0
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    srli a2, a1, 3
; CHECK-NEXT:    vsetvli a3, zero, e8, mf4, ta, ma
; CHECK-NEXT:    vslidedown.vx v2, v0, a2
; CHECK-NEXT:    sub a2, a0, a1
; CHECK-NEXT:    sltu a3, a0, a2
; CHECK-NEXT:    addi a3, a3, -1
; CHECK-NEXT:    and a2, a3, a2
; CHECK-NEXT:    lui a3, %hi(.LCPI32_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI32_0)(a3)
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v2
; CHECK-NEXT:    vfabs.v v24, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v2, v24, fa5, v0.t
; CHECK-NEXT:    fsrmi a2, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v2
; CHECK-NEXT:    vfcvt.x.f.v v24, v16, v0.t
; CHECK-NEXT:    fsrm a2
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    addi a2, sp, 16
; CHECK-NEXT:    vs8r.v v24, (a2) # Unknown-size Folded Spill
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vl8r.v v24, (a2) # Unknown-size Folded Reload
; CHECK-NEXT:    vfsgnj.vv v16, v24, v16, v0.t
; CHECK-NEXT:    vs8r.v v16, (a2) # Unknown-size Folded Spill
; CHECK-NEXT:    bltu a0, a1, .LBB32_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:  .LBB32_2:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v1
; CHECK-NEXT:    vfabs.v v16, v8, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vmflt.vf v1, v16, fa5, v0.t
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, ma
; CHECK-NEXT:    vmv1r.v v0, v1
; CHECK-NEXT:    vfcvt.x.f.v v16, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v16, v16, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v16, v8, v0.t
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl8r.v v16, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
  %v = call <vscale x 16 x double> @llvm.vp.roundeven.nxv16f64(<vscale x 16 x double> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x double> %v
}

define <vscale x 16 x double> @vp_roundeven_nxv16f64_unmasked(<vscale x 16 x double> %va, i32 zeroext %evl) {
; CHECK-LABEL: vp_roundeven_nxv16f64_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a1, vlenb
; CHECK-NEXT:    sub a2, a0, a1
; CHECK-NEXT:    lui a3, %hi(.LCPI33_0)
; CHECK-NEXT:    fld fa5, %lo(.LCPI33_0)(a3)
; CHECK-NEXT:    sltu a3, a0, a2
; CHECK-NEXT:    addi a3, a3, -1
; CHECK-NEXT:    and a2, a3, a2
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v16
; CHECK-NEXT:    vmflt.vf v0, v24, fa5
; CHECK-NEXT:    fsrmi a2, 0
; CHECK-NEXT:    vfcvt.x.f.v v24, v16, v0.t
; CHECK-NEXT:    fsrm a2
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v16, v24, v16, v0.t
; CHECK-NEXT:    bltu a0, a1, .LBB33_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:  .LBB33_2:
; CHECK-NEXT:    vsetvli zero, a0, e64, m8, ta, ma
; CHECK-NEXT:    vfabs.v v24, v8
; CHECK-NEXT:    vmflt.vf v0, v24, fa5
; CHECK-NEXT:    fsrmi a0, 0
; CHECK-NEXT:    vfcvt.x.f.v v24, v8, v0.t
; CHECK-NEXT:    fsrm a0
; CHECK-NEXT:    vfcvt.f.x.v v24, v24, v0.t
; CHECK-NEXT:    vsetvli zero, zero, e64, m8, ta, mu
; CHECK-NEXT:    vfsgnj.vv v8, v24, v8, v0.t
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x i1> poison, i1 true, i32 0
  %m = shufflevector <vscale x 16 x i1> %head, <vscale x 16 x i1> poison, <vscale x 16 x i32> zeroinitializer
  %v = call <vscale x 16 x double> @llvm.vp.roundeven.nxv16f64(<vscale x 16 x double> %va, <vscale x 16 x i1> %m, i32 %evl)
  ret <vscale x 16 x double> %v
}
