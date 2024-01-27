; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=knl --show-mc-encoding | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512-KNL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx --show-mc-encoding | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512-SKX
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=corei7-avx --show-mc-encoding | FileCheck %s --check-prefix=AVX

define float @test_fdiv(float %a, float %b) {
; AVX512-LABEL: test_fdiv:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vdivss %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x5e,0xc1]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_fdiv:
; AVX:       ## %bb.0:
; AVX-NEXT:    vdivss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x5e,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = fdiv float %a, %b
  ret float %c
}

define float @test_fsub(float %a, float %b) {
; AVX512-LABEL: test_fsub:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vsubss %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x5c,0xc1]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_fsub:
; AVX:       ## %bb.0:
; AVX-NEXT:    vsubss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x5c,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = fsub float %a, %b
  ret float %c
}

define double @test_fadd(double %a, double %b) {
; AVX512-LABEL: test_fadd:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfb,0x58,0xc1]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_fadd:
; AVX:       ## %bb.0:
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x58,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = fadd double %a, %b
  ret double %c
}

declare float     @llvm.trunc.f32(float  %Val)
declare double    @llvm.trunc.f64(double %Val)
declare float     @llvm.rint.f32(float  %Val)
declare double    @llvm.rint.f64(double %Val)
declare double    @llvm.sqrt.f64(double %Val)
declare float     @llvm.sqrt.f32(float  %Val)

define float @test_trunc(float %a) {
; AVX512-LABEL: test_trunc:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0a,0xc0,0x0b]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_trunc:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0a,0xc0,0x0b]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = call float @llvm.trunc.f32(float %a)
  ret float %c
}

define double @test_sqrt(double %a) {
; AVX512-LABEL: test_sqrt:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfb,0x51,0xc0]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_sqrt:
; AVX:       ## %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x51,0xc0]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = call double @llvm.sqrt.f64(double %a)
  ret double %c
}

define float @test_rint(float %a) {
; AVX512-LABEL: test_rint:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc4,0xe3,0x79,0x0a,0xc0,0x04]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_rint:
; AVX:       ## %bb.0:
; AVX-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x0a,0xc0,0x04]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %c = call float @llvm.rint.f32(float %a)
  ret float %c
}

define float @test_vmax(float %i, float %j) {
; AVX512-LABEL: test_vmax:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vmaxss %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x5f,0xc1]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_vmax:
; AVX:       ## %bb.0:
; AVX-NEXT:    vmaxss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x5f,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %cmp_res = fcmp ogt float %i, %j
  %max = select i1 %cmp_res, float %i, float %j
  ret float %max
}

define float @test_mov(float %a, float %b, float %i, float %j) {
; AVX512-LABEL: test_mov:
; AVX512:       ## %bb.0:
; AVX512-NEXT:    vcmpltss %xmm2, %xmm3, %k1 ## encoding: [0x62,0xf1,0x66,0x08,0xc2,0xca,0x01]
; AVX512-NEXT:    vmovss %xmm1, %xmm0, %xmm0 {%k1} ## encoding: [0x62,0xf1,0x7e,0x09,0x10,0xc1]
; AVX512-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: test_mov:
; AVX:       ## %bb.0:
; AVX-NEXT:    vcmpltss %xmm2, %xmm3, %xmm2 ## encoding: [0xc5,0xe2,0xc2,0xd2,0x01]
; AVX-NEXT:    vblendvps %xmm2, %xmm1, %xmm0, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x4a,0xc1,0x20]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %cmp_res = fcmp ogt float %i, %j
  %max = select i1 %cmp_res, float %b, float %a
  ret float %max
}

define float @zero_float(float %a) {
; AVX512-KNL-LABEL: zero_float:
; AVX512-KNL:       ## %bb.0:
; AVX512-KNL-NEXT:    vxorps %xmm1, %xmm1, %xmm1 ## encoding: [0xc5,0xf0,0x57,0xc9]
; AVX512-KNL-NEXT:    vaddss %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x58,0xc1]
; AVX512-KNL-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-SKX-LABEL: zero_float:
; AVX512-SKX:       ## %bb.0:
; AVX512-SKX-NEXT:    vxorps %xmm1, %xmm1, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf0,0x57,0xc9]
; AVX512-SKX-NEXT:    vaddss %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfa,0x58,0xc1]
; AVX512-SKX-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: zero_float:
; AVX:       ## %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1 ## encoding: [0xc5,0xf0,0x57,0xc9]
; AVX-NEXT:    vaddss %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfa,0x58,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %b = fadd float %a, 0.0
  ret float %b
}

define double @zero_double(double %a) {
; AVX512-KNL-LABEL: zero_double:
; AVX512-KNL:       ## %bb.0:
; AVX512-KNL-NEXT:    vxorpd %xmm1, %xmm1, %xmm1 ## encoding: [0xc5,0xf1,0x57,0xc9]
; AVX512-KNL-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfb,0x58,0xc1]
; AVX512-KNL-NEXT:    retq ## encoding: [0xc3]
;
; AVX512-SKX-LABEL: zero_double:
; AVX512-SKX:       ## %bb.0:
; AVX512-SKX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1 ## EVEX TO VEX Compression encoding: [0xc5,0xf1,0x57,0xc9]
; AVX512-SKX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xfb,0x58,0xc1]
; AVX512-SKX-NEXT:    retq ## encoding: [0xc3]
;
; AVX-LABEL: zero_double:
; AVX:       ## %bb.0:
; AVX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1 ## encoding: [0xc5,0xf1,0x57,0xc9]
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0 ## encoding: [0xc5,0xfb,0x58,0xc1]
; AVX-NEXT:    retq ## encoding: [0xc3]
  %b = fadd double %a, 0.0
  ret double %b
}
