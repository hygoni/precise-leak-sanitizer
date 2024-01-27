; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=icelake-server  | FileCheck %s --check-prefixes=CHECK,CHECK-ICX,CHECK-ICX-NO-BYPASS-DELAY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=icelake-server -mattr=-no-bypass-delay-shuffle | FileCheck %s --check-prefixes=CHECK,CHECK-ICX,CHECK-ICX-BYPASS-DELAY
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=x86-64-v4  | FileCheck %s --check-prefixes=CHECK,CHECK-V4
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vl,+avx512bw,+avx512dq  | FileCheck %s --check-prefixes=CHECK,CHECK-AVX512
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mcpu=znver4  | FileCheck %s --check-prefixes=CHECK,CHECK-ZNVER4

define <8 x double> @transform_VPERMILPSZrr(<8 x double> %a) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vshufpd {{.*#+}} zmm0 = zmm0[0,1,2,3,4,5,7,6]
; CHECK-NEXT:    retq
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 7, i32 6>
  ret <8 x double> %shufp
}

define <4 x double> @transform_VPERMILPSYrr(<4 x double> %a) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vshufpd {{.*#+}} ymm0 = ymm0[1,0,2,3]
; CHECK-NEXT:    retq
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 2, i32 3>
  ret <4 x double> %shufp
}

define <2 x double> @transform_VPERMILPSrr(<2 x double> %a) nounwind {
; CHECK-LABEL: transform_VPERMILPSrr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vshufpd {{.*#+}} xmm0 = xmm0[1,0]
; CHECK-NEXT:    retq
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  ret <2 x double> %shufp
}

define <8 x double> @transform_VPERMILPSZrrkz(<8 x double> %a, i8 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrrkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} zmm0 {%k1} {z} = zmm0[0,1,2,3,5,4,6,7]
; CHECK-NEXT:    retq
  %mask = bitcast i8 %mask_int to <8 x i1>
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 5, i32 4, i32 6, i32 7>
  %res = select <8 x i1> %mask, <8 x double> %shufp, <8 x double> zeroinitializer
  ret <8 x double> %res
}

define <4 x double> @transform_VPERMILPSYrrkz(<4 x double> %a, i4 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrrkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} ymm0 {%k1} {z} = ymm0[0,1,3,2]
; CHECK-NEXT:    retq
  %mask = bitcast i4 %mask_int to <4 x i1>
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
  %res = select <4 x i1> %mask, <4 x double> %shufp, <4 x double> zeroinitializer
  ret <4 x double> %res
}

define <2 x double> @transform_VPERMILPSrrkz(<2 x double> %a, i2 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSrrkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} xmm0 {%k1} {z} = xmm0[1,0]
; CHECK-NEXT:    retq
  %mask = bitcast i2 %mask_int to <2 x i1>
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  %res = select <2 x i1> %mask, <2 x double> %shufp, <2 x double> zeroinitializer
  ret <2 x double> %res
}

define <8 x double> @transform_VPERMILPSZrrk(<8 x double> %a, <8 x double> %b, i8 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrrk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} zmm1 {%k1} = zmm0[0,1,3,2,4,5,6,7]
; CHECK-NEXT:    vmovapd %zmm1, %zmm0
; CHECK-NEXT:    retq
  %mask = bitcast i8 %mask_int to <8 x i1>
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 0, i32 1, i32 3, i32 2, i32 4, i32 5, i32 6, i32 7>
  %res = select <8 x i1> %mask, <8 x double> %shufp, <8 x double> %b
  ret <8 x double> %res
}

define <4 x double> @transform_VPERMILPSYrrk(<4 x double> %a, <4 x double> %b, i4 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrrk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} ymm1 {%k1} = ymm0[1,0,3,2]
; CHECK-NEXT:    vmovapd %ymm1, %ymm0
; CHECK-NEXT:    retq
  %mask = bitcast i4 %mask_int to <4 x i1>
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %res = select <4 x i1> %mask, <4 x double> %shufp, <4 x double> %b
  ret <4 x double> %res
}

define <2 x double> @transform_VPERMILPSrrk(<2 x double> %a, <2 x double> %b, i2 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSrrk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vshufpd {{.*#+}} xmm1 {%k1} = xmm0[1,0]
; CHECK-NEXT:    vmovapd %xmm1, %xmm0
; CHECK-NEXT:    retq
  %mask = bitcast i2 %mask_int to <2 x i1>
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  %res = select <2 x i1> %mask, <2 x double> %shufp, <2 x double> %b
  ret <2 x double> %res
}

define <8 x double> @transform_VPERMILPSZrm(ptr %ap) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} zmm0 = mem[1,0,2,3,4,5,6,7]
; CHECK-NEXT:    retq
  %a = load <8 x double>, ptr %ap
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 1, i32 0, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x double> %shufp
}

define <4 x double> @transform_VPERMILPSYrm(ptr %ap) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 = mem[0,1,3,2]
; CHECK-NEXT:    retq
  %a = load <4 x double>, ptr %ap
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
  ret <4 x double> %shufp
}

define <2 x double> @transform_VPERMILPSrm(ptr %ap) nounwind {
; CHECK-LABEL: transform_VPERMILPSrm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 = mem[1,0]
; CHECK-NEXT:    retq
  %a = load <2 x double>, ptr %ap
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  ret <2 x double> %shufp
}

define <8 x double> @transform_VPERMILPSZrmkz(ptr %ap, i8 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrmkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} zmm0 {%k1} {z} = mem[1,0,2,3,4,5,7,6]
; CHECK-NEXT:    retq
  %mask = bitcast i8 %mask_int to <8 x i1>
  %a = load <8 x double>, ptr %ap
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 1, i32 0, i32 2, i32 3, i32 4, i32 5, i32 7, i32 6>
  %res = select <8 x i1> %mask, <8 x double> %shufp, <8 x double> zeroinitializer
  ret <8 x double> %res
}

define <4 x double> @transform_VPERMILPSYrmkz(ptr %ap, i4 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrmkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 {%k1} {z} = mem[1,0,3,2]
; CHECK-NEXT:    retq
  %mask = bitcast i4 %mask_int to <4 x i1>
  %a = load <4 x double>, ptr %ap
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %res = select <4 x i1> %mask, <4 x double> %shufp, <4 x double> zeroinitializer
  ret <4 x double> %res
}

define <2 x double> @transform_VPERMILPSrmkz(ptr %ap, i2 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSrmkz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 {%k1} {z} = mem[1,0]
; CHECK-NEXT:    retq
  %mask = bitcast i2 %mask_int to <2 x i1>
  %a = load <2 x double>, ptr %ap
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  %res = select <2 x i1> %mask, <2 x double> %shufp, <2 x double> zeroinitializer
  ret <2 x double> %res
}

define <8 x double> @transform_VPERMILPSZrmk(ptr %ap, <8 x double> %b, i8 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSZrmk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} zmm0 {%k1} = mem[0,1,3,2,4,5,7,6]
; CHECK-NEXT:    retq
  %mask = bitcast i8 %mask_int to <8 x i1>
  %a = load <8 x double>, ptr %ap
  %shufp = shufflevector <8 x double> %a, <8 x double> poison, <8 x i32> <i32 0, i32 1, i32 3, i32 2, i32 4, i32 5, i32 7, i32 6>
  %res = select <8 x i1> %mask, <8 x double> %shufp, <8 x double> %b
  ret <8 x double> %res
}

define <4 x double> @transform_VPERMILPSYrmk(ptr %ap, <4 x double> %b, i4 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSYrmk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} ymm0 {%k1} = mem[0,1,3,2]
; CHECK-NEXT:    retq
  %mask = bitcast i4 %mask_int to <4 x i1>
  %a = load <4 x double>, ptr %ap
  %shufp = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 0, i32 1, i32 3, i32 2>
  %res = select <4 x i1> %mask, <4 x double> %shufp, <4 x double> %b
  ret <4 x double> %res
}

define <2 x double> @transform_VPERMILPSrmk(ptr %ap, <2 x double> %b, i2 %mask_int) nounwind {
; CHECK-LABEL: transform_VPERMILPSrmk:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vpermilpd {{.*#+}} xmm0 {%k1} = mem[1,0]
; CHECK-NEXT:    retq
  %mask = bitcast i2 %mask_int to <2 x i1>
  %a = load <2 x double>, ptr %ap
  %shufp = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  %res = select <2 x i1> %mask, <2 x double> %shufp, <2 x double> %b
  ret <2 x double> %res
}
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK-AVX512: {{.*}}
; CHECK-ICX: {{.*}}
; CHECK-ICX-BYPASS-DELAY: {{.*}}
; CHECK-ICX-NO-BYPASS-DELAY: {{.*}}
; CHECK-V4: {{.*}}
; CHECK-ZNVER4: {{.*}}
