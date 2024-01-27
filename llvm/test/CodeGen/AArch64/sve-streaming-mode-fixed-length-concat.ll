; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mattr=+sve -force-streaming-compatible-sve  < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

;
; i8
;

define <8 x i8> @concat_v8i8(<4 x i8> %op1, <4 x i8> %op2)  {
; CHECK-LABEL: concat_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    fmov w8, s1
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    mov z2.h, z1.h[3]
; CHECK-NEXT:    mov z3.h, z1.h[2]
; CHECK-NEXT:    mov z4.h, z1.h[1]
; CHECK-NEXT:    fmov w10, s2
; CHECK-NEXT:    strb w8, [sp, #12]
; CHECK-NEXT:    fmov w8, s3
; CHECK-NEXT:    strb w9, [sp, #8]
; CHECK-NEXT:    fmov w9, s4
; CHECK-NEXT:    mov z1.h, z0.h[3]
; CHECK-NEXT:    mov z5.h, z0.h[2]
; CHECK-NEXT:    mov z0.h, z0.h[1]
; CHECK-NEXT:    strb w10, [sp, #15]
; CHECK-NEXT:    fmov w10, s1
; CHECK-NEXT:    strb w8, [sp, #14]
; CHECK-NEXT:    fmov w8, s5
; CHECK-NEXT:    strb w9, [sp, #13]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    strb w10, [sp, #11]
; CHECK-NEXT:    strb w8, [sp, #10]
; CHECK-NEXT:    strb w9, [sp, #9]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %res = shufflevector <4 x i8> %op1, <4 x i8> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i8> %res
}

define <16 x i8> @concat_v16i8(<8 x i8> %op1, <8 x i8> %op2)  {
; CHECK-LABEL: concat_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.b, vl8
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.b, p0, z0.b, z1.b
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <8 x i8> %op1, <8 x i8> %op2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                 i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x i8> %res
}

define void @concat_v32i8(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <16 x i8>, ptr %a
  %op2 = load <16 x i8>, ptr %b
  %res = shufflevector <16 x i8> %op1, <16 x i8> %op2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                   i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                   i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                   i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  store <32 x i8> %res, ptr %c
  ret void
}

define void @concat_v64i8(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v64i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <32 x i8>, ptr %a
  %op2 = load <32 x i8>, ptr %b
  %res = shufflevector <32 x i8> %op1, <32 x i8> %op2, <64 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                   i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                   i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                   i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31,
                                                                   i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39,
                                                                   i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47,
                                                                   i32 48, i32 49, i32 50, i32 51, i32 52, i32 53, i32 54, i32 55,
                                                                   i32 56, i32 57, i32 58, i32 59, i32 60, i32 61, i32 62, i32 63>
  store <64 x i8> %res, ptr %c
  ret void
}

;
; i16
;

define <4 x i16> @concat_v4i16(<2 x i16> %op1, <2 x i16> %op2)  {
; CHECK-LABEL: concat_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    fmov w8, s1
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    mov z1.s, z1.s[1]
; CHECK-NEXT:    mov z0.s, z0.s[1]
; CHECK-NEXT:    fmov w10, s1
; CHECK-NEXT:    fmov w11, s0
; CHECK-NEXT:    strh w8, [sp, #12]
; CHECK-NEXT:    strh w9, [sp, #8]
; CHECK-NEXT:    strh w10, [sp, #14]
; CHECK-NEXT:    strh w11, [sp, #10]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %res = shufflevector <2 x i16> %op1, <2 x i16> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i16> %res
}

; Don't use SVE for 128-bit vectors.
define <8 x i16> @concat_v8i16(<4 x i16> %op1, <4 x i16> %op2)  {
; CHECK-LABEL: concat_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.h, p0, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <4 x i16> %op1, <4 x i16> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i16> %res
}

define void @concat_v16i16(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <8 x i16>, ptr %a
  %op2 = load <8 x i16>, ptr %b
  %res = shufflevector <8 x i16> %op1, <8 x i16> %op2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                   i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x i16> %res, ptr %c
  ret void
}

define void @concat_v32i16(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v32i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <16 x i16>, ptr %a
  %op2 = load <16 x i16>, ptr %b
  %res = shufflevector <16 x i16> %op1, <16 x i16> %op2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                     i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                     i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  store <32 x i16> %res, ptr %c
  ret void
}

;
; i32
;

; Don't use SVE for 64-bit vectors.
define <2 x i32> @concat_v2i32(<1 x i32> %op1, <1 x i32> %op2)  {
; CHECK-LABEL: concat_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    zip1 z0.s, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <1 x i32> %op1, <1 x i32> %op2, <2 x i32> <i32 0, i32 1>
  ret <2 x i32> %res
}

; Don't use SVE for 128-bit vectors.
define <4 x i32> @concat_v4i32(<2 x i32> %op1, <2 x i32> %op2)  {
; CHECK-LABEL: concat_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.s, p0, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <2 x i32> %op1, <2 x i32> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i32> %res
}

define void @concat_v8i32(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <4 x i32>, ptr %a
  %op2 = load <4 x i32>, ptr %b
  %res = shufflevector <4 x i32> %op1, <4 x i32> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i32> %res, ptr %c
  ret void
}

define void @concat_v16i32(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <8 x i32>, ptr %a
  %op2 = load <8 x i32>, ptr %b
  %res = shufflevector <8 x i32> %op1, <8 x i32> %op2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                   i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x i32> %res, ptr %c
  ret void
}

;
; i64
;

; Don't use SVE for 128-bit vectors.
define <2 x i64> @concat_v2i64(<1 x i64> %op1, <1 x i64> %op2)  {
; CHECK-LABEL: concat_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <1 x i64> %op1, <1 x i64> %op2, <2 x i32> <i32 0, i32 1>
  ret <2 x i64> %res
}

define void @concat_v4i64(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <2 x i64>, ptr %a
  %op2 = load <2 x i64>, ptr %b
  %res = shufflevector <2 x i64> %op1, <2 x i64> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %res, ptr %c
  ret void
}

define void @concat_v8i64(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v8i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <4 x i64>, ptr %a
  %op2 = load <4 x i64>, ptr %b
  %res = shufflevector <4 x i64> %op1, <4 x i64> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i64> %res, ptr %c
  ret void
}

;
; f16
;

define <4 x half> @concat_v4f16(<2 x half> %op1, <2 x half> %op2)  {
; CHECK-LABEL: concat_v4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    str h1, [sp, #12]
; CHECK-NEXT:    str h0, [sp, #8]
; CHECK-NEXT:    mov z1.h, z1.h[1]
; CHECK-NEXT:    mov z0.h, z0.h[1]
; CHECK-NEXT:    str h1, [sp, #14]
; CHECK-NEXT:    str h0, [sp, #10]
; CHECK-NEXT:    ldr d0, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %res = shufflevector <2 x half> %op1, <2 x half> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x half> %res
}

define <8 x half> @concat_v8f16(<4 x half> %op1, <4 x half> %op2)  {
; CHECK-LABEL: concat_v8f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.h, vl4
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.h, p0, z0.h, z1.h
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <4 x half> %op1, <4 x half> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x half> %res
}

define void @concat_v16f16(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v16f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <8 x half>, ptr %a
  %op2 = load <8 x half>, ptr %b
  %res = shufflevector <8 x half> %op1, <8 x half> %op2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                     i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x half> %res, ptr %c
  ret void
}

define void @concat_v32f16(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v32f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <16 x half>, ptr %a
  %op2 = load <16 x half>, ptr %b
  %res = shufflevector <16 x half> %op1, <16 x half> %op2, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                       i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                       i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  store <32 x half> %res, ptr %c
  ret void
}

;
; i32
;

; Don't use SVE for 64-bit vectors.
define <2 x float> @concat_v2f32(<1 x float> %op1, <1 x float> %op2)  {
; CHECK-LABEL: concat_v2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    zip1 z0.s, z0.s, z1.s
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <1 x float> %op1, <1 x float> %op2, <2 x i32> <i32 0, i32 1>
  ret <2 x float> %res
}

; Don't use SVE for 128-bit vectors.
define <4 x float> @concat_v4f32(<2 x float> %op1, <2 x float> %op2)  {
; CHECK-LABEL: concat_v4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.s, vl2
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.s, p0, z0.s, z1.s
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <2 x float> %op1, <2 x float> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x float> %res
}

define void @concat_v8f32(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v8f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <4 x float>, ptr %a
  %op2 = load <4 x float>, ptr %b
  %res = shufflevector <4 x float> %op1, <4 x float> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x float> %res, ptr %c
  ret void
}

define void @concat_v16f32(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v16f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <8 x float>, ptr %a
  %op2 = load <8 x float>, ptr %b
  %res = shufflevector <8 x float> %op1, <8 x float> %op2, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                       i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x float> %res, ptr %c
  ret void
}

;
; f64
;

; Don't use SVE for 128-bit vectors.
define <2 x double> @concat_v2f64(<1 x double> %op1, <1 x double> %op2)  {
; CHECK-LABEL: concat_v2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $z0
; CHECK-NEXT:    ptrue p0.d, vl1
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $z1
; CHECK-NEXT:    splice z0.d, p0, z0.d, z1.d
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %res = shufflevector <1 x double> %op1, <1 x double> %op2, <2 x i32> <i32 0, i32 1>
  ret <2 x double> %res
}

define void @concat_v4f64(ptr %a, ptr %b, ptr %c)  {
; CHECK-LABEL: concat_v4f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x1]
; CHECK-NEXT:    ldr q1, [x0]
; CHECK-NEXT:    stp q1, q0, [x2]
; CHECK-NEXT:    ret
  %op1 = load <2 x double>, ptr %a
  %op2 = load <2 x double>, ptr %b
  %res = shufflevector <2 x double> %op1, <2 x double> %op2, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x double> %res, ptr %c
  ret void
}

define void @concat_v8f64(ptr %a, ptr %b, ptr %c) {
; CHECK-LABEL: concat_v8f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldp q0, q1, [x1]
; CHECK-NEXT:    ldp q2, q3, [x0]
; CHECK-NEXT:    stp q0, q1, [x2, #32]
; CHECK-NEXT:    stp q2, q3, [x2]
; CHECK-NEXT:    ret
  %op1 = load <4 x double>, ptr %a
  %op2 = load <4 x double>, ptr %b
  %res = shufflevector <4 x double> %op1, <4 x double> %op2, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x double> %res, ptr %c
  ret void
}

;
; undef
;

define void @concat_v32i8_undef(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v32i8_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <16 x i8>, ptr %a
  %res = shufflevector <16 x i8> %op1, <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                    i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                    i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                    i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  store <32 x i8> %res, ptr %b
  ret void
}

define void @concat_v16i16_undef(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v16i16_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <8 x i16>, ptr %a
  %res = shufflevector <8 x i16> %op1, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                    i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x i16> %res, ptr %b
  ret void
}

define void @concat_v8i32_undef(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v8i32_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <4 x i32>, ptr %a
  %res = shufflevector <4 x i32> %op1, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i32> %res, ptr %b
  ret void
}

define void @concat_v4i64_undef(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v4i64_undef:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <2 x i64>, ptr %a
  %res = shufflevector <2 x i64> %op1, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %res, ptr %b
  ret void
}

;
; > 2 operands
;

define void @concat_v32i8_4op(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v32i8_4op:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <8 x i8>, ptr %a
  %shuffle = shufflevector <8 x i8> %op1, <8 x i8> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                      i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %res = shufflevector <16 x i8> %shuffle, <16 x i8> undef, <32 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                        i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15,
                                                                        i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23,
                                                                        i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31>
  store <32 x i8> %res, ptr %b
  ret void
}

define void @concat_v16i16_4op(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v16i16_4op:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <4 x i16>, ptr %a
  %shuffle = shufflevector <4 x i16> %op1, <4 x i16> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %res = shufflevector <8 x i16> %shuffle, <8 x i16> undef, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7,
                                                                        i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  store <16 x i16> %res, ptr %b
  ret void
}

define void @concat_v8i32_4op(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v8i32_4op:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <2 x i32>, ptr %a
  %shuffle = shufflevector <2 x i32> %op1, <2 x i32> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %res = shufflevector <4 x i32> %shuffle, <4 x i32> undef, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  store <8 x i32> %res, ptr %b
  ret void
}

define void @concat_v4i64_4op(ptr %a, ptr %b)  {
; CHECK-LABEL: concat_v4i64_4op:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    str q0, [x1]
; CHECK-NEXT:    ret
  %op1 = load <1 x i64>, ptr %a
  %shuffle = shufflevector <1 x i64> %op1, <1 x i64> undef, <2 x i32> <i32 0, i32 1>
  %res = shufflevector <2 x i64> %shuffle, <2 x i64> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x i64> %res, ptr %b
  ret void
}
