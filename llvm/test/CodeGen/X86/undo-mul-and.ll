; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefixes=CHECK,CHECK-SSE
; RUN: llc < %s -mtriple=x86_64-linux -mattr=+avx | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX1
; RUN: llc < %s -mtriple=x86_64-linux -mattr=+avx512f,+avx512vl,+avx512bw | FileCheck %s --check-prefixes=CHECK,CHECK-AVX,CHECK-AVX512

define i32 @mul_and_to_neg_shl_and(i32 %x) {
; CHECK-LABEL: mul_and_to_neg_shl_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    negl %edi
; CHECK-NEXT:    leal (,%rdi,8), %eax
; CHECK-NEXT:    andl $56, %eax
; CHECK-NEXT:    retq
  %mul = mul i32 %x, 56
  %and = and i32 %mul, 56
  ret i32 %and
}

define i32 @mul_and_to_neg_shl_and2(i32 %x) {
; CHECK-LABEL: mul_and_to_neg_shl_and2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    negl %edi
; CHECK-NEXT:    leal (,%rdi,8), %eax
; CHECK-NEXT:    andl $48, %eax
; CHECK-NEXT:    retq
  %mul = mul i32 %x, 56
  %and = and i32 %mul, 51
  ret i32 %and
}

define <4 x i32> @mul_and_to_neg_shl_and_vec(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    psubd %xmm0, %xmm1
; CHECK-SSE-NEXT:    pslld $3, %xmm1
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX1-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX512-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 56>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 48>
  ret <4 x i32> %and
}

define <4 x i32> @mul_and_to_neg_shl_and_vec_fail_no_splat(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_fail_no_splat:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE-NEXT:    pmuludq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE-NEXT:    pmuludq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; CHECK-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec_fail_no_splat:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec_fail_no_splat:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 64>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 48>
  ret <4 x i32> %and
}

;; todo_no_splat ones have the correct invariants for all elements.
define <4 x i32> @mul_and_to_neg_shl_and_vec_todo_no_splat1(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat1:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,3,3]
; CHECK-SSE-NEXT:    pmuludq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE-NEXT:    pmuludq {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; CHECK-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat1:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat1:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 48>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 48>
  ret <4 x i32> %and
}

define <4 x i32> @mul_and_to_neg_shl_and_vec_todo_no_splat2(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat2:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    movdqa {{.*#+}} xmm1 = [56,56,56,56]
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; CHECK-SSE-NEXT:    pmuludq %xmm1, %xmm0
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; CHECK-SSE-NEXT:    pmuludq %xmm1, %xmm2
; CHECK-SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm2[0,2,2,3]
; CHECK-SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat2:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec_todo_no_splat2:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpmulld {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 56>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 32>
  ret <4 x i32> %and
}

define <4 x i32> @mul_and_to_neg_shl_and_vec_with_undef_mul(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_with_undef_mul:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    psubd %xmm0, %xmm1
; CHECK-SSE-NEXT:    pslld $3, %xmm1
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec_with_undef_mul:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX1-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec_with_undef_mul:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX512-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 undef>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 48>
  ret <4 x i32> %and
}

define <4 x i32> @mul_and_to_neg_shl_and_vec_with_undef_and(<4 x i32> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_with_undef_and:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    psubd %xmm0, %xmm1
; CHECK-SSE-NEXT:    pslld $3, %xmm1
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX1-LABEL: mul_and_to_neg_shl_and_vec_with_undef_and:
; CHECK-AVX1:       # %bb.0:
; CHECK-AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX1-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX1-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX1-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX1-NEXT:    retq
;
; CHECK-AVX512-LABEL: mul_and_to_neg_shl_and_vec_with_undef_and:
; CHECK-AVX512:       # %bb.0:
; CHECK-AVX512-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX512-NEXT:    vpsubd %xmm0, %xmm1, %xmm0
; CHECK-AVX512-NEXT:    vpslld $3, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    vpandd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %mul = mul <4 x i32> %x, <i32 56, i32 56, i32 56, i32 56>
  %and = and <4 x i32> %mul, <i32 48, i32 48, i32 48, i32 undef>
  ret <4 x i32> %and
}

define <16 x i8> @mul_and_to_neg_shl_and_vec_with_undef_mul_and(<16 x i8> %x) {
; CHECK-SSE-LABEL: mul_and_to_neg_shl_and_vec_with_undef_mul_and:
; CHECK-SSE:       # %bb.0:
; CHECK-SSE-NEXT:    pxor %xmm1, %xmm1
; CHECK-SSE-NEXT:    psubb %xmm0, %xmm1
; CHECK-SSE-NEXT:    psllw $2, %xmm1
; CHECK-SSE-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1
; CHECK-SSE-NEXT:    movdqa %xmm1, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: mul_and_to_neg_shl_and_vec_with_undef_mul_and:
; CHECK-AVX:       # %bb.0:
; CHECK-AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-AVX-NEXT:    vpsubb %xmm0, %xmm1, %xmm0
; CHECK-AVX-NEXT:    vpsllw $2, %xmm0, %xmm0
; CHECK-AVX-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
  %mul = mul <16 x i8> %x, <i8 12, i8 12, i8 12, i8 12, i8 undef, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12, i8 12>
  %and = and <16 x i8> %mul, <i8 11, i8 undef, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11, i8 11>
  ret <16 x i8> %and
}

define i32 @mul_and_to_neg_shl_and_fail_invalid_mul(i32 %x) {
; CHECK-LABEL: mul_and_to_neg_shl_and_fail_invalid_mul:
; CHECK:       # %bb.0:
; CHECK-NEXT:    imull $57, %edi, %eax
; CHECK-NEXT:    andl $56, %eax
; CHECK-NEXT:    retq
  %mul = mul i32 %x, 57
  %and = and i32 %mul, 56
  ret i32 %and
}

define i32 @mul_and_to_neg_shl_and_fail_mul_p2(i32 %x) {
; CHECK-LABEL: mul_and_to_neg_shl_and_fail_mul_p2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    shll $6, %eax
; CHECK-NEXT:    andl $64, %eax
; CHECK-NEXT:    retq
  %mul = mul i32 %x, 64
  %and = and i32 %mul, 64
  ret i32 %and
}

define i32 @mul_and_to_neg_shl_and_fail_mask_to_large(i32 %x) {
; CHECK-LABEL: mul_and_to_neg_shl_and_fail_mask_to_large:
; CHECK:       # %bb.0:
; CHECK-NEXT:    imull $56, %edi, %eax
; CHECK-NEXT:    andl $120, %eax
; CHECK-NEXT:    retq
  %mul = mul i32 %x, 56
  %and = and i32 %mul, 120
  ret i32 %and
}
