; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible-sve < %s | FileCheck %s


target triple = "aarch64-unknown-linux-gnu"

define void @store_trunc_v8i16i8(ptr %ap, ptr %dest) {
; CHECK-LABEL: store_trunc_v8i16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ptrue p0.h, vl8
; CHECK-NEXT:    st1b { z0.h }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <8 x i16>, ptr %ap
  %val = trunc <8 x i16> %a to <8 x i8>
  store <8 x i8> %val, ptr %dest
  ret void
}

define void @store_trunc_v4i32i8(ptr %ap, ptr %dest) {
; CHECK-LABEL: store_trunc_v4i32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    st1b { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <4 x i32>, ptr %ap
  %val = trunc <4 x i32> %a to <4 x i8>
  store <4 x i8> %val, ptr %dest
  ret void
}

define void @store_trunc_v4i32i16(ptr %ap, ptr %dest) {
; CHECK-LABEL: store_trunc_v4i32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ptrue p0.s, vl4
; CHECK-NEXT:    st1h { z0.s }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <4 x i32>, ptr %ap
  %val = trunc <4 x i32> %a to <4 x i16>
  store <4 x i16> %val, ptr %dest
  ret void
}

define void @store_trunc_v2i64i8(ptr %ap, ptr %dest) {
; CHECK-LABEL: store_trunc_v2i64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ptrue p0.d, vl2
; CHECK-NEXT:    st1w { z0.d }, p0, [x1]
; CHECK-NEXT:    ret
  %a = load <2 x i64>, ptr %ap
  %val = trunc <2 x i64> %a to <2 x i32>
  store <2 x i32> %val, ptr %dest
  ret void
}

define void @store_trunc_v2i256i64(ptr %ap, ptr %dest) {
; CHECK-LABEL: store_trunc_v2i256i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0, #32]
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    ldr d1, [x0]
; CHECK-NEXT:    splice z1.d, p0, z1.d, z0.d
; CHECK-NEXT:    str q1, [x1]
; CHECK-NEXT:    ret
  %a = load <2 x i256>, ptr %ap
  %val = trunc <2 x i256> %a to <2 x i64>
  store <2 x i64> %val, ptr %dest
  ret void
}
