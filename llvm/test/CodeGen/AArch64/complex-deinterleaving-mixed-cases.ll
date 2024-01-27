; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s --mattr=+complxnum,+neon,+fullfp16 -o - | FileCheck %s

target triple = "aarch64"

; Expected to transform
define <4 x float> @mul_mul(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_mul:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v4.2d, #0000000000000000
; CHECK-NEXT:    movi v3.2d, #0000000000000000
; CHECK-NEXT:    fcmla v4.4s, v0.4s, v1.4s, #0
; CHECK-NEXT:    fcmla v4.4s, v0.4s, v1.4s, #90
; CHECK-NEXT:    fcmla v3.4s, v4.4s, v2.4s, #0
; CHECK-NEXT:    fcmla v3.4s, v4.4s, v2.4s, #90
; CHECK-NEXT:    mov v0.16b, v3.16b
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec151 = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %strided.vec153 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec154 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %strided.vec154, %strided.vec151
  %1 = fmul fast <2 x float> %strided.vec153, %strided.vec
  %2 = fmul fast <2 x float> %strided.vec154, %strided.vec
  %3 = fmul fast <2 x float> %strided.vec153, %strided.vec151
  %4 = fadd fast <2 x float> %3, %2
  %5 = fsub fast <2 x float> %1, %0
  %strided.vec156 = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec157 = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %6 = fmul fast <2 x float> %4, %strided.vec156
  %7 = fmul fast <2 x float> %5, %strided.vec157
  %8 = fadd fast <2 x float> %6, %7
  %9 = fmul fast <2 x float> %strided.vec156, %5
  %10 = fmul fast <2 x float> %4, %strided.vec157
  %11 = fsub fast <2 x float> %9, %10
  %interleaved.vec = shufflevector <2 x float> %11, <2 x float> %8, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to not transform
define <4 x float> @add_mul(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: add_mul:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fsub v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    fsub v1.4s, v1.4s, v2.4s
; CHECK-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; CHECK-NEXT:    ext v4.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ext v5.16b, v1.16b, v1.16b, #8
; CHECK-NEXT:    zip2 v0.2s, v0.2s, v4.2s
; CHECK-NEXT:    zip2 v4.2s, v2.2s, v3.2s
; CHECK-NEXT:    zip1 v1.2s, v1.2s, v5.2s
; CHECK-NEXT:    zip1 v2.2s, v2.2s, v3.2s
; CHECK-NEXT:    fmul v5.2s, v4.2s, v0.2s
; CHECK-NEXT:    fmul v3.2s, v1.2s, v4.2s
; CHECK-NEXT:    fneg v4.2s, v5.2s
; CHECK-NEXT:    fmla v3.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmla v4.2s, v1.2s, v2.2s
; CHECK-NEXT:    zip1 v0.4s, v4.4s, v3.4s
; CHECK-NEXT:    ret
entry:
  %0 = fsub fast <4 x float> %b, %c
  %1 = shufflevector <4 x float> %0, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec58 = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec59 = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %2 = fmul fast <2 x float> %1, %strided.vec59
  %3 = fsub fast <4 x float> %b, %a
  %4 = shufflevector <4 x float> %3, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %5 = fmul fast <2 x float> %strided.vec58, %4
  %6 = fadd fast <2 x float> %5, %2
  %7 = fmul fast <2 x float> %strided.vec58, %1
  %8 = fmul fast <2 x float> %strided.vec59, %4
  %9 = fsub fast <2 x float> %7, %8
  %interleaved.vec = shufflevector <2 x float> %9, <2 x float> %6, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to not transform
define <4 x float> @mul_mul270_mul(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_mul270_mul:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; CHECK-NEXT:    ext v4.16b, v1.16b, v1.16b, #8
; CHECK-NEXT:    zip1 v5.2s, v2.2s, v3.2s
; CHECK-NEXT:    zip2 v2.2s, v2.2s, v3.2s
; CHECK-NEXT:    zip1 v6.2s, v1.2s, v4.2s
; CHECK-NEXT:    zip2 v1.2s, v1.2s, v4.2s
; CHECK-NEXT:    ext v3.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fmul v7.2s, v6.2s, v5.2s
; CHECK-NEXT:    fneg v4.2s, v7.2s
; CHECK-NEXT:    zip2 v7.2s, v0.2s, v3.2s
; CHECK-NEXT:    zip1 v0.2s, v0.2s, v3.2s
; CHECK-NEXT:    fmla v4.2s, v2.2s, v1.2s
; CHECK-NEXT:    fmul v1.2s, v1.2s, v5.2s
; CHECK-NEXT:    fmul v3.2s, v4.2s, v7.2s
; CHECK-NEXT:    fmla v1.2s, v2.2s, v6.2s
; CHECK-NEXT:    fmul v2.2s, v4.2s, v0.2s
; CHECK-NEXT:    fneg v3.2s, v3.2s
; CHECK-NEXT:    fmla v2.2s, v7.2s, v1.2s
; CHECK-NEXT:    fmla v3.2s, v0.2s, v1.2s
; CHECK-NEXT:    zip1 v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec81 = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %strided.vec83 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec84 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %strided.vec84, %strided.vec
  %1 = fmul fast <2 x float> %strided.vec83, %strided.vec81
  %2 = fadd fast <2 x float> %1, %0
  %strided.vec86 = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec87 = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %3 = fmul fast <2 x float> %2, %strided.vec87
  %4 = fmul fast <2 x float> %strided.vec84, %strided.vec81
  %5 = fmul fast <2 x float> %strided.vec83, %strided.vec
  %6 = fsub fast <2 x float> %4, %5
  %7 = fmul fast <2 x float> %6, %strided.vec86
  %8 = fadd fast <2 x float> %3, %7
  %9 = fmul fast <2 x float> %2, %strided.vec86
  %10 = fmul fast <2 x float> %6, %strided.vec87
  %11 = fsub fast <2 x float> %9, %10
  %interleaved.vec = shufflevector <2 x float> %11, <2 x float> %8, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; (a * b) * a
; Expected to transform
define <4 x float> @mul_triangle(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: mul_triangle:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v3.2d, #0000000000000000
; CHECK-NEXT:    movi v2.2d, #0000000000000000
; CHECK-NEXT:    fcmla v3.4s, v1.4s, v0.4s, #0
; CHECK-NEXT:    fcmla v3.4s, v1.4s, v0.4s, #90
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v3.4s, #0
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v3.4s, #90
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec35 = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %strided.vec37 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec38 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %strided.vec37, %strided.vec
  %1 = fmul fast <2 x float> %strided.vec38, %strided.vec35
  %2 = fsub fast <2 x float> %0, %1
  %3 = fmul fast <2 x float> %2, %strided.vec35
  %4 = fmul fast <2 x float> %strided.vec38, %strided.vec
  %5 = fmul fast <2 x float> %strided.vec35, %strided.vec37
  %6 = fadd fast <2 x float> %4, %5
  %7 = fmul fast <2 x float> %6, %strided.vec
  %8 = fadd fast <2 x float> %3, %7
  %9 = fmul fast <2 x float> %2, %strided.vec
  %10 = fmul fast <2 x float> %6, %strided.vec35
  %11 = fsub fast <2 x float> %9, %10
  %interleaved.vec = shufflevector <2 x float> %11, <2 x float> %8, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}


; d * (b * a) * (c * a)
; Expected to transform
define <4 x float> @mul_diamond(<4 x float> %a, <4 x float> %b, <4 x float> %c, <4 x float> %d) {
; CHECK-LABEL: mul_diamond:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v4.2d, #0000000000000000
; CHECK-NEXT:    movi v5.2d, #0000000000000000
; CHECK-NEXT:    movi v6.2d, #0000000000000000
; CHECK-NEXT:    fcmla v4.4s, v1.4s, v0.4s, #0
; CHECK-NEXT:    fcmla v6.4s, v2.4s, v0.4s, #0
; CHECK-NEXT:    fcmla v4.4s, v1.4s, v0.4s, #90
; CHECK-NEXT:    movi v1.2d, #0000000000000000
; CHECK-NEXT:    fcmla v6.4s, v2.4s, v0.4s, #90
; CHECK-NEXT:    fcmla v5.4s, v4.4s, v3.4s, #0
; CHECK-NEXT:    fcmla v5.4s, v4.4s, v3.4s, #90
; CHECK-NEXT:    fcmla v1.4s, v6.4s, v5.4s, #0
; CHECK-NEXT:    fcmla v1.4s, v6.4s, v5.4s, #90
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %a.real = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %c.real = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %c.imag = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %d.real = shufflevector <4 x float> %d, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %d.imag = shufflevector <4 x float> %d, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %a.imag, %b.real
  %1 = fmul fast <2 x float> %a.real, %b.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %a.real, %b.real
  %4 = fmul fast <2 x float> %b.imag, %a.imag
  %5 = fsub fast <2 x float> %3, %4
  %6 = fmul fast <2 x float> %d.real, %5
  %7 = fmul fast <2 x float> %2, %d.imag
  %8 = fmul fast <2 x float> %d.real, %2
  %9 = fmul fast <2 x float> %5, %d.imag
  %10 = fsub fast <2 x float> %6, %7
  %11 = fadd fast <2 x float> %8, %9
  %12 = fmul fast <2 x float> %c.real, %a.imag
  %13 = fmul fast <2 x float> %c.imag, %a.real
  %14 = fadd fast <2 x float> %13, %12
  %15 = fmul fast <2 x float> %14, %10
  %16 = fmul fast <2 x float> %c.real, %a.real
  %17 = fmul fast <2 x float> %c.imag, %a.imag
  %18 = fsub fast <2 x float> %16, %17
  %19 = fmul fast <2 x float> %18, %11
  %20 = fadd fast <2 x float> %15, %19
  %21 = fmul fast <2 x float> %18, %10
  %22 = fmul fast <2 x float> %14, %11
  %23 = fsub fast <2 x float> %21, %22
  %interleaved.vec = shufflevector <2 x float> %23, <2 x float> %20, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to transform
define <4 x float> @mul_add90_mul(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_add90_mul:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v3.2d, #0000000000000000
; CHECK-NEXT:    movi v4.2d, #0000000000000000
; CHECK-NEXT:    fcmla v3.4s, v2.4s, v0.4s, #0
; CHECK-NEXT:    fcmla v4.4s, v1.4s, v0.4s, #0
; CHECK-NEXT:    fcmla v3.4s, v2.4s, v0.4s, #90
; CHECK-NEXT:    fcmla v4.4s, v1.4s, v0.4s, #90
; CHECK-NEXT:    fcadd v0.4s, v3.4s, v4.4s, #90
; CHECK-NEXT:    ret
entry:
  %ar = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %ai = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %br = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %bi = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %cr = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %ci = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>

  %i6 = fmul fast <2 x float> %br, %ar
  %i7 = fmul fast <2 x float> %bi, %ai
  %xr = fsub fast <2 x float> %i6, %i7
  %i9 = fmul fast <2 x float> %bi, %ar
  %i10 = fmul fast <2 x float> %br, %ai
  %xi = fadd fast <2 x float> %i9, %i10

  %j6 = fmul fast <2 x float> %cr, %ar
  %j7 = fmul fast <2 x float> %ci, %ai
  %yr = fsub fast <2 x float> %j6, %j7
  %j9 = fmul fast <2 x float> %ci, %ar
  %j10 = fmul fast <2 x float> %cr, %ai
  %yi = fadd fast <2 x float> %j9, %j10

  %zr = fsub fast <2 x float> %yr, %xi
  %zi = fadd fast <2 x float> %yi, %xr
  %interleaved.vec = shufflevector <2 x float> %zr, <2 x float> %zi, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to not transform
define <4 x float> @mul_triangle_addmul(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_triangle_addmul:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v3.16b, v1.16b, v1.16b, #8
; CHECK-NEXT:    ext v4.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    zip1 v5.2s, v1.2s, v3.2s
; CHECK-NEXT:    zip2 v1.2s, v1.2s, v3.2s
; CHECK-NEXT:    zip1 v6.2s, v0.2s, v4.2s
; CHECK-NEXT:    zip2 v0.2s, v0.2s, v4.2s
; CHECK-NEXT:    ext v3.16b, v2.16b, v2.16b, #8
; CHECK-NEXT:    fmul v7.2s, v5.2s, v6.2s
; CHECK-NEXT:    fmul v6.2s, v1.2s, v6.2s
; CHECK-NEXT:    zip1 v4.2s, v2.2s, v3.2s
; CHECK-NEXT:    zip2 v2.2s, v2.2s, v3.2s
; CHECK-NEXT:    fmov d3, d7
; CHECK-NEXT:    fmov d16, d6
; CHECK-NEXT:    fmls v7.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmla v6.2s, v0.2s, v4.2s
; CHECK-NEXT:    fmls v3.2s, v0.2s, v1.2s
; CHECK-NEXT:    fmla v16.2s, v0.2s, v5.2s
; CHECK-NEXT:    fsub v0.2s, v7.2s, v16.2s
; CHECK-NEXT:    fadd v1.2s, v6.2s, v3.2s
; CHECK-NEXT:    zip1 v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    ret
entry:
  %ar = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %ai = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %br = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %bi = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %cr = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %ci = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>

  %i6 = fmul fast <2 x float> %br, %ar
  %i7 = fmul fast <2 x float> %bi, %ai
  %xr = fsub fast <2 x float> %i6, %i7
  %i9 = fmul fast <2 x float> %bi, %ar
  %i10 = fmul fast <2 x float> %br, %ai
  %xi = fadd fast <2 x float> %i9, %i10

  ;%j6 = fmul fast <2 x float> %cr, %ar
  %j7 = fmul fast <2 x float> %ci, %ai
  %yr = fsub fast <2 x float> %i6, %j7
  ;%j9 = fmul fast <2 x float> %ci, %ar
  %j10 = fmul fast <2 x float> %cr, %ai
  %yi = fadd fast <2 x float> %i9, %j10

  %zr = fsub fast <2 x float> %yr, %xi
  %zi = fadd fast <2 x float> %yi, %xr
  %interleaved.vec = shufflevector <2 x float> %zr, <2 x float> %zi, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to not transform
define <4 x float> @mul_triangle_multiuses(<4 x float> %a, <4 x float> %b, ptr %p) {
; CHECK-LABEL: mul_triangle_multiuses:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v2.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ext v3.16b, v1.16b, v1.16b, #8
; CHECK-NEXT:    zip2 v4.2s, v0.2s, v2.2s
; CHECK-NEXT:    zip1 v0.2s, v0.2s, v2.2s
; CHECK-NEXT:    zip1 v5.2s, v1.2s, v3.2s
; CHECK-NEXT:    zip2 v1.2s, v1.2s, v3.2s
; CHECK-NEXT:    fmul v2.2s, v4.2s, v5.2s
; CHECK-NEXT:    fmul v3.2s, v1.2s, v4.2s
; CHECK-NEXT:    fmla v2.2s, v0.2s, v1.2s
; CHECK-NEXT:    fneg v1.2s, v3.2s
; CHECK-NEXT:    fmul v3.2s, v2.2s, v4.2s
; CHECK-NEXT:    fmla v1.2s, v0.2s, v5.2s
; CHECK-NEXT:    fmul v5.2s, v2.2s, v0.2s
; CHECK-NEXT:    fneg v3.2s, v3.2s
; CHECK-NEXT:    fmla v5.2s, v4.2s, v1.2s
; CHECK-NEXT:    fmla v3.2s, v0.2s, v1.2s
; CHECK-NEXT:    mov v1.d[1], v2.d[0]
; CHECK-NEXT:    zip1 v0.4s, v3.4s, v5.4s
; CHECK-NEXT:    str q1, [x0]
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec35 = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %strided.vec37 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %strided.vec38 = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %strided.vec37, %strided.vec
  %1 = fmul fast <2 x float> %strided.vec38, %strided.vec35
  %2 = fsub fast <2 x float> %0, %1
  %3 = fmul fast <2 x float> %2, %strided.vec35
  %4 = fmul fast <2 x float> %strided.vec38, %strided.vec
  %5 = fmul fast <2 x float> %strided.vec35, %strided.vec37
  %6 = fadd fast <2 x float> %4, %5
  %otheruse = shufflevector <2 x float> %2, <2 x float> %6, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  store <4 x float> %otheruse, ptr %p
  %7 = fmul fast <2 x float> %6, %strided.vec
  %8 = fadd fast <2 x float> %3, %7
  %9 = fmul fast <2 x float> %2, %strided.vec
  %10 = fmul fast <2 x float> %6, %strided.vec35
  %11 = fsub fast <2 x float> %9, %10
  %interleaved.vec = shufflevector <2 x float> %11, <2 x float> %8, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to transform
define <4 x float> @mul_addequal(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_addequal:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v1.4s, #0
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v1.4s, #90
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %b.imag, %strided.vec
  %1 = fmul fast <2 x float> %b.real, %a.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %b.real, %strided.vec
  %4 = fmul fast <2 x float> %a.imag, %b.imag
  %5 = fsub fast <2 x float> %3, %4
  %c.real = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %c.imag = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %6 = fadd fast <2 x float> %5, %c.real
  %7 = fadd fast <2 x float> %2, %c.imag
  %interleaved.vec = shufflevector <2 x float> %6, <2 x float> %7, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to transform
define <4 x float> @mul_subequal(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_subequal:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v3.2d, #0000000000000000
; CHECK-NEXT:    fcmla v3.4s, v0.4s, v1.4s, #0
; CHECK-NEXT:    fcmla v3.4s, v0.4s, v1.4s, #90
; CHECK-NEXT:    fsub v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %b.imag, %strided.vec
  %1 = fmul fast <2 x float> %b.real, %a.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %b.real, %strided.vec
  %4 = fmul fast <2 x float> %a.imag, %b.imag
  %5 = fsub fast <2 x float> %3, %4
  %c.real = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %c.imag = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %6 = fsub fast <2 x float> %5, %c.real
  %7 = fsub fast <2 x float> %2, %c.imag
  %interleaved.vec = shufflevector <2 x float> %6, <2 x float> %7, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}


; Expected to transform
define <4 x float> @mul_mulequal(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_mulequal:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v3.2d, #0000000000000000
; CHECK-NEXT:    fcmla v3.4s, v0.4s, v1.4s, #0
; CHECK-NEXT:    fcmla v3.4s, v0.4s, v1.4s, #90
; CHECK-NEXT:    fmul v0.4s, v3.4s, v2.4s
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %b.imag, %strided.vec
  %1 = fmul fast <2 x float> %b.real, %a.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %b.real, %strided.vec
  %4 = fmul fast <2 x float> %a.imag, %b.imag
  %5 = fsub fast <2 x float> %3, %4
  %c.real = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %c.imag = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %6 = fmul fast <2 x float> %5, %c.real
  %7 = fmul fast <2 x float> %2, %c.imag
  %interleaved.vec = shufflevector <2 x float> %6, <2 x float> %7, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to not transform
define <4 x float> @mul_divequal(<4 x float> %a, <4 x float> %b, <4 x float> %c) {
; CHECK-LABEL: mul_divequal:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v3.16b, v1.16b, v1.16b, #8
; CHECK-NEXT:    ext v4.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    ext v16.16b, v2.16b, v2.16b, #8
; CHECK-NEXT:    zip2 v5.2s, v1.2s, v3.2s
; CHECK-NEXT:    zip1 v1.2s, v1.2s, v3.2s
; CHECK-NEXT:    zip2 v6.2s, v0.2s, v4.2s
; CHECK-NEXT:    zip1 v0.2s, v0.2s, v4.2s
; CHECK-NEXT:    zip1 v4.2s, v2.2s, v16.2s
; CHECK-NEXT:    zip2 v2.2s, v2.2s, v16.2s
; CHECK-NEXT:    fmul v7.2s, v6.2s, v5.2s
; CHECK-NEXT:    fneg v3.2s, v7.2s
; CHECK-NEXT:    fmla v3.2s, v0.2s, v1.2s
; CHECK-NEXT:    fmul v0.2s, v5.2s, v0.2s
; CHECK-NEXT:    fmla v0.2s, v6.2s, v1.2s
; CHECK-NEXT:    fdiv v3.2s, v3.2s, v4.2s
; CHECK-NEXT:    fdiv v0.2s, v0.2s, v2.2s
; CHECK-NEXT:    zip1 v0.4s, v3.4s, v0.4s
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %b.imag, %strided.vec
  %1 = fmul fast <2 x float> %b.real, %a.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %b.real, %strided.vec
  %4 = fmul fast <2 x float> %a.imag, %b.imag
  %5 = fsub fast <2 x float> %3, %4
  %c.real = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %c.imag = shufflevector <4 x float> %c, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %6 = fdiv fast <2 x float> %5, %c.real
  %7 = fdiv fast <2 x float> %2, %c.imag
  %interleaved.vec = shufflevector <2 x float> %6, <2 x float> %7, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}

; Expected to transform
define <4 x float> @mul_negequal(<4 x float> %a, <4 x float> %b) {
; CHECK-LABEL: mul_negequal:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    movi v2.2d, #0000000000000000
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v1.4s, #180
; CHECK-NEXT:    fcmla v2.4s, v0.4s, v1.4s, #270
; CHECK-NEXT:    mov v0.16b, v2.16b
; CHECK-NEXT:    ret
entry:
  %strided.vec = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %a.imag = shufflevector <4 x float> %a, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %b.real = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 0, i32 2>
  %b.imag = shufflevector <4 x float> %b, <4 x float> poison, <2 x i32> <i32 1, i32 3>
  %0 = fmul fast <2 x float> %b.imag, %strided.vec
  %1 = fmul fast <2 x float> %b.real, %a.imag
  %2 = fadd fast <2 x float> %1, %0
  %3 = fmul fast <2 x float> %b.real, %strided.vec
  %4 = fmul fast <2 x float> %a.imag, %b.imag
  %5 = fsub fast <2 x float> %3, %4
  %6 = fneg fast <2 x float> %5
  %7 = fneg fast <2 x float> %2
  %interleaved.vec = shufflevector <2 x float> %6, <2 x float> %7, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  ret <4 x float> %interleaved.vec
}
