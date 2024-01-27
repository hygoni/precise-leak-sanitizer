; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+d,+zfh,+v,+zvfh \
; RUN:   -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,CHECK-RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+d,+zfh,+v,+zvfh \
; RUN:   -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,CHECK-RV64

declare void @llvm.experimental.vp.strided.store.v2i8.p0.i8(<2 x i8>, ptr, i8, <2 x i1>, i32)

define void @strided_vpstore_v2i8_i8(<2 x i8> %val, ptr %ptr, i8 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i8_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf8, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i8.p0.i8(<2 x i8> %val, ptr %ptr, i8 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i8.p0.i16(<2 x i8>, ptr, i16, <2 x i1>, i32)

define void @strided_vpstore_v2i8_i16(<2 x i8> %val, ptr %ptr, i16 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i8_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf8, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i8.p0.i16(<2 x i8> %val, ptr %ptr, i16 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i8.p0.i64(<2 x i8>, ptr, i64, <2 x i1>, i32)

define void @strided_vpstore_v2i8_i64(<2 x i8> %val, ptr %ptr, i64 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-RV32-LABEL: strided_vpstore_v2i8_i64:
; CHECK-RV32:       # %bb.0:
; CHECK-RV32-NEXT:    vsetvli zero, a3, e8, mf8, ta, ma
; CHECK-RV32-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-RV32-NEXT:    ret
;
; CHECK-RV64-LABEL: strided_vpstore_v2i8_i64:
; CHECK-RV64:       # %bb.0:
; CHECK-RV64-NEXT:    vsetvli zero, a2, e8, mf8, ta, ma
; CHECK-RV64-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-RV64-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i8.p0.i64(<2 x i8> %val, ptr %ptr, i64 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i8.p0.i32(<2 x i8>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2i8(<2 x i8> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf8, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i8.p0.i32(<2 x i8> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4i8.p0.i32(<4 x i8>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4i8(<4 x i8> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf4, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4i8.p0.i32(<4 x i8> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8i8.p0.i32(<8 x i8>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8i8(<8 x i8> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf2, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8i8.p0.i32(<8 x i8> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i16.p0.i32(<2 x i16>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2i16(<2 x i16> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, mf4, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i16.p0.i32(<2 x i16> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4i16.p0.i32(<4 x i16>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4i16(<4 x i16> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, mf2, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4i16.p0.i32(<4 x i16> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8i16.p0.i32(<8 x i16>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8i16(<8 x i16> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, m1, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8i16.p0.i32(<8 x i16> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i32.p0.i32(<2 x i32>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2i32(<2 x i32> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, mf2, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i32.p0.i32(<2 x i32> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4i32.p0.i32(<4 x i32>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4i32(<4 x i32> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m1, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4i32.p0.i32(<4 x i32> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8i32.p0.i32(<8 x i32>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8i32(<8 x i32> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m2, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8i32.p0.i32(<8 x i32> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2i64.p0.i32(<2 x i64>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2i64(<2 x i64> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2i64.p0.i32(<2 x i64> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4i64.p0.i32(<4 x i64>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4i64(<4 x i64> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m2, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4i64.p0.i32(<4 x i64> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8i64.p0.i32(<8 x i64>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8i64(<8 x i64> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m4, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8i64.p0.i32(<8 x i64> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2f16.p0.i32(<2 x half>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2f16(<2 x half> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, mf4, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2f16.p0.i32(<2 x half> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4f16.p0.i32(<4 x half>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4f16(<4 x half> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, mf2, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4f16.p0.i32(<4 x half> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8f16.p0.i32(<8 x half>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8f16(<8 x half> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e16, m1, ta, ma
; CHECK-NEXT:    vsse16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8f16.p0.i32(<8 x half> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2f32.p0.i32(<2 x float>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2f32(<2 x float> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, mf2, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2f32.p0.i32(<2 x float> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4f32.p0.i32(<4 x float>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4f32(<4 x float> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m1, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4f32.p0.i32(<4 x float> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8f32.p0.i32(<8 x float>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8f32(<8 x float> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m2, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8f32.p0.i32(<8 x float> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v2f64.p0.i32(<2 x double>, ptr, i32, <2 x i1>, i32)

define void @strided_vpstore_v2f64(<2 x double> %val, ptr %ptr, i32 signext %stride, <2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m1, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v2f64.p0.i32(<2 x double> %val, ptr %ptr, i32 %stride, <2 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v4f64.p0.i32(<4 x double>, ptr, i32, <4 x i1>, i32)

define void @strided_vpstore_v4f64(<4 x double> %val, ptr %ptr, i32 signext %stride, <4 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m2, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v4f64.p0.i32(<4 x double> %val, ptr %ptr, i32 %stride, <4 x i1> %m, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v8f64.p0.i32(<8 x double>, ptr, i32, <8 x i1>, i32)

define void @strided_vpstore_v8f64(<8 x double> %val, ptr %ptr, i32 signext %stride, <8 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e64, m4, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v8f64.p0.i32(<8 x double> %val, ptr %ptr, i32 %stride, <8 x i1> %m, i32 %evl)
  ret void
}

define void @strided_vpstore_v2i8_allones_mask(<2 x i8> %val, ptr %ptr, i32 signext %stride, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v2i8_allones_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e8, mf8, ta, ma
; CHECK-NEXT:    vsse8.v v8, (a0), a1
; CHECK-NEXT:    ret
  %a = insertelement <2 x i1> poison, i1 true, i32 0
  %b = shufflevector <2 x i1> %a, <2 x i1> poison, <2 x i32> zeroinitializer
  call void @llvm.experimental.vp.strided.store.v2i8.p0.i32(<2 x i8> %val, ptr %ptr, i32 %stride, <2 x i1> %b, i32 %evl)
  ret void
}

; Widening
define void @strided_vpstore_v3f32(<3 x float> %v, ptr %ptr, i32 signext %stride, <3 x i1> %mask, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v3f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m1, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v3f32.p0.i32(<3 x float> %v, ptr %ptr, i32 %stride, <3 x i1> %mask, i32 %evl)
  ret void
}

define void @strided_vpstore_v3f32_allones_mask(<3 x float> %v, ptr %ptr, i32 signext %stride, i32 zeroext %evl) {
; CHECK-LABEL: strided_vpstore_v3f32_allones_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a2, e32, m1, ta, ma
; CHECK-NEXT:    vsse32.v v8, (a0), a1
; CHECK-NEXT:    ret
  %one = insertelement <3 x i1> poison, i1 true, i32 0
  %allones = shufflevector <3 x i1> %one, <3 x i1> poison, <3 x i32> zeroinitializer
  call void @llvm.experimental.vp.strided.store.v3f32.p0.i32(<3 x float> %v, ptr %ptr, i32 %stride, <3 x i1> %allones, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v3f32.p0.i32(<3 x float>, ptr , i32, <3 x i1>, i32)

; Splitting
define void @strided_store_v32f64(<32 x double> %v, ptr %ptr, i32 signext %stride, <32 x i1> %mask, i32 zeroext %evl) {
; CHECK-LABEL: strided_store_v32f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a4, 16
; CHECK-NEXT:    mv a3, a2
; CHECK-NEXT:    bltu a2, a4, .LBB27_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a3, 16
; CHECK-NEXT:  .LBB27_2:
; CHECK-NEXT:    vsetvli zero, a3, e64, m8, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1, v0.t
; CHECK-NEXT:    mul a3, a3, a1
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:    addi a3, a2, -16
; CHECK-NEXT:    sltu a2, a2, a3
; CHECK-NEXT:    addi a2, a2, -1
; CHECK-NEXT:    and a2, a2, a3
; CHECK-NEXT:    vsetivli zero, 2, e8, mf4, ta, ma
; CHECK-NEXT:    vslidedown.vi v0, v0, 2
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, ma
; CHECK-NEXT:    vsse64.v v16, (a0), a1, v0.t
; CHECK-NEXT:    ret
  call void @llvm.experimental.vp.strided.store.v32f64.p0.i32(<32 x double> %v, ptr %ptr, i32 %stride, <32 x i1> %mask, i32 %evl)
  ret void
}

define void @strided_store_v32f64_allones_mask(<32 x double> %v, ptr %ptr, i32 signext %stride, i32 zeroext %evl) {
; CHECK-LABEL: strided_store_v32f64_allones_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a4, 16
; CHECK-NEXT:    mv a3, a2
; CHECK-NEXT:    bltu a2, a4, .LBB28_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    li a3, 16
; CHECK-NEXT:  .LBB28_2:
; CHECK-NEXT:    vsetvli zero, a3, e64, m8, ta, ma
; CHECK-NEXT:    vsse64.v v8, (a0), a1
; CHECK-NEXT:    mul a3, a3, a1
; CHECK-NEXT:    add a0, a0, a3
; CHECK-NEXT:    addi a3, a2, -16
; CHECK-NEXT:    sltu a2, a2, a3
; CHECK-NEXT:    addi a2, a2, -1
; CHECK-NEXT:    and a2, a2, a3
; CHECK-NEXT:    vsetvli zero, a2, e64, m8, ta, ma
; CHECK-NEXT:    vsse64.v v16, (a0), a1
; CHECK-NEXT:    ret
  %one = insertelement <32 x i1> poison, i1 true, i32 0
  %allones = shufflevector <32 x i1> %one, <32 x i1> poison, <32 x i32> zeroinitializer
  call void @llvm.experimental.vp.strided.store.v32f64.p0.i32(<32 x double> %v, ptr %ptr, i32 %stride, <32 x i1> %allones, i32 %evl)
  ret void
}

declare void @llvm.experimental.vp.strided.store.v32f64.p0.i32(<32 x double>, ptr, i32, <32 x i1>, i32)
