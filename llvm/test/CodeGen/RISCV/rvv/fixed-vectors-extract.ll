; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+v,+zfh,+zvfh,+f,+d -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32,RV32NOM
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+v,+zfh,+zvfh,+f,+d,+m -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32,RV32M
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+v,+zfh,+zvfh,+f,+d -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+v,+zfh,+zvfh,+f,+d,+m -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

define i8 @extractelt_v16i8(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <16 x i8>, ptr %x
  %b = extractelement <16 x i8> %a, i32 7
  ret i8 %b
}

define i16 @extractelt_v8i16(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <8 x i16>, ptr %x
  %b = extractelement <8 x i16> %a, i32 7
  ret i16 %b
}

define i32 @extractelt_v4i32(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <4 x i32>, ptr %x
  %b = extractelement <4 x i32> %a, i32 2
  ret i32 %b
}

define i64 @extractelt_v2i64(ptr %x) nounwind {
; RV32-LABEL: extractelt_v2i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    li a1, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV32-NEXT:    vsrl.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v2i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <2 x i64>, ptr %x
  %b = extractelement <2 x i64> %a, i32 0
  ret i64 %b
}

define half @extractelt_v8f16(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <8 x half>, ptr %x
  %b = extractelement <8 x half> %a, i32 7
  ret half %b
}

define float @extractelt_v4f32(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <4 x float>, ptr %x
  %b = extractelement <4 x float> %a, i32 2
  ret float %b
}

define double @extractelt_v2f64(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <2 x double>, ptr %x
  %b = extractelement <2 x double> %a, i32 0
  ret double %b
}

define i8 @extractelt_v32i8(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v32i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli zero, a1, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e8, m2, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <32 x i8>, ptr %x
  %b = extractelement <32 x i8> %a, i32 7
  ret i8 %b
}

define i16 @extractelt_v16i16(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <16 x i16>, ptr %x
  %b = extractelement <16 x i16> %a, i32 7
  ret i16 %b
}

define i32 @extractelt_v8i32(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 6
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <8 x i32>, ptr %x
  %b = extractelement <8 x i32> %a, i32 6
  ret i32 %b
}

define i64 @extractelt_v4i64(ptr %x) nounwind {
; RV32-LABEL: extractelt_v4i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV32-NEXT:    vslidedown.vi v8, v8, 3
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    li a1, 32
; RV32-NEXT:    vsrl.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v4i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV64-NEXT:    vslidedown.vi v8, v8, 3
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <4 x i64>, ptr %x
  %b = extractelement <4 x i64> %a, i32 3
  ret i64 %b
}

define half @extractelt_v16f16(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <16 x half>, ptr %x
  %b = extractelement <16 x half> %a, i32 7
  ret half %b
}

define float @extractelt_v8f32(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <8 x float>, ptr %x
  %b = extractelement <8 x float> %a, i32 2
  ret float %b
}

define double @extractelt_v4f64(ptr %x) nounwind {
; CHECK-LABEL: extractelt_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <4 x double>, ptr %x
  %b = extractelement <4 x double> %a, i32 0
  ret double %b
}

; This uses a non-power of 2 type so that it isn't an MVT to catch an
; incorrect use of getSimpleValueType().
; NOTE: Type legalization is bitcasting to vXi32 and doing 2 independent
; slidedowns and extracts.
define i64 @extractelt_v3i64(ptr %x) nounwind {
; RV32-LABEL: extractelt_v3i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 3, e64, m2, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; RV32-NEXT:    vslidedown.vi v10, v8, 4
; RV32-NEXT:    vmv.x.s a0, v10
; RV32-NEXT:    vslidedown.vi v8, v8, 5
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v3i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 3, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <3 x i64>, ptr %x
  %b = extractelement <3 x i64> %a, i32 2
  ret i64 %b
}

define i8 @extractelt_v16i8_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v16i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <16 x i8>, ptr %x
  %b = extractelement <16 x i8> %a, i32 %idx
  ret i8 %b
}

define i16 @extractelt_v8i16_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v8i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <8 x i16>, ptr %x
  %b = extractelement <8 x i16> %a, i32 %idx
  ret i16 %b
}

define i32 @extractelt_v4i32_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v4i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vadd.vv v8, v8, v8
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <4 x i32>, ptr %x
  %b = add <4 x i32> %a, %a
  %c = extractelement <4 x i32> %b, i32 %idx
  ret i32 %c
}

define i64 @extractelt_v2i64_idx(ptr %x, i32 zeroext %idx) nounwind {
; RV32-LABEL: extractelt_v2i64_idx:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vadd.vv v8, v8, v8
; RV32-NEXT:    vslidedown.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    li a1, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV32-NEXT:    vsrl.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v2i64_idx:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vadd.vv v8, v8, v8
; RV64-NEXT:    vslidedown.vx v8, v8, a1
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <2 x i64>, ptr %x
  %b = add <2 x i64> %a, %a
  %c = extractelement <2 x i64> %b, i32 %idx
  ret i64 %c
}

define half @extractelt_v8f16_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v8f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <8 x half>, ptr %x
  %b = fadd <8 x half> %a, %a
  %c = extractelement <8 x half> %b, i32 %idx
  ret half %c
}

define float @extractelt_v4f32_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v4f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <4 x float>, ptr %x
  %b = fadd <4 x float> %a, %a
  %c = extractelement <4 x float> %b, i32 %idx
  ret float %c
}

define double @extractelt_v2f64_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v2f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <2 x double>, ptr %x
  %b = fadd <2 x double> %a, %a
  %c = extractelement <2 x double> %b, i32 %idx
  ret double %c
}

define i8 @extractelt_v32i8_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v32i8_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e8, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <32 x i8>, ptr %x
  %b = extractelement <32 x i8> %a, i32 %idx
  ret i8 %b
}

define i16 @extractelt_v16i16_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v16i16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <16 x i16>, ptr %x
  %b = extractelement <16 x i16> %a, i32 %idx
  ret i16 %b
}

define i32 @extractelt_v8i32_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v8i32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vadd.vv v8, v8, v8
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    ret
  %a = load <8 x i32>, ptr %x
  %b = add <8 x i32> %a, %a
  %c = extractelement <8 x i32> %b, i32 %idx
  ret i32 %c
}

define i64 @extractelt_v4i64_idx(ptr %x, i32 zeroext %idx) nounwind {
; RV32-LABEL: extractelt_v4i64_idx:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vadd.vv v8, v8, v8
; RV32-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV32-NEXT:    vslidedown.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    li a1, 32
; RV32-NEXT:    vsrl.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v4i64_idx:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vadd.vv v8, v8, v8
; RV64-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV64-NEXT:    vslidedown.vx v8, v8, a1
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <4 x i64>, ptr %x
  %b = add <4 x i64> %a, %a
  %c = extractelement <4 x i64> %b, i32 %idx
  ret i64 %c
}

define half @extractelt_v16f16_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v16f16_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vsetivli zero, 1, e16, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <16 x half>, ptr %x
  %b = fadd <16 x half> %a, %a
  %c = extractelement <16 x half> %b, i32 %idx
  ret half %c
}

define float @extractelt_v8f32_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v8f32_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <8 x float>, ptr %x
  %b = fadd <8 x float> %a, %a
  %c = extractelement <8 x float> %b, i32 %idx
  ret float %c
}

define double @extractelt_v4f64_idx(ptr %x, i32 zeroext %idx) nounwind {
; CHECK-LABEL: extractelt_v4f64_idx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; CHECK-NEXT:    vslidedown.vx v8, v8, a1
; CHECK-NEXT:    vfmv.f.s fa0, v8
; CHECK-NEXT:    ret
  %a = load <4 x double>, ptr %x
  %b = fadd <4 x double> %a, %a
  %c = extractelement <4 x double> %b, i32 %idx
  ret double %c
}

; This uses a non-power of 2 type so that it isn't an MVT to catch an
; incorrect use of getSimpleValueType_idx(, i32 zeroext %idx).
; NOTE: Type legalization is bitcasting to vXi32 and doing 2 independent
; slidedowns and extracts.
define i64 @extractelt_v3i64_idx(ptr %x, i32 zeroext %idx) nounwind {
; RV32-LABEL: extractelt_v3i64_idx:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 3, e64, m2, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV32-NEXT:    vadd.vv v8, v8, v8
; RV32-NEXT:    add a1, a1, a1
; RV32-NEXT:    vsetivli zero, 1, e32, m2, ta, ma
; RV32-NEXT:    vslidedown.vx v10, v8, a1
; RV32-NEXT:    vmv.x.s a0, v10
; RV32-NEXT:    addi a1, a1, 1
; RV32-NEXT:    vslidedown.vx v8, v8, a1
; RV32-NEXT:    vmv.x.s a1, v8
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v3i64_idx:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 3, e64, m2, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vsetivli zero, 4, e64, m2, ta, ma
; RV64-NEXT:    vadd.vv v8, v8, v8
; RV64-NEXT:    vsetivli zero, 1, e64, m2, ta, ma
; RV64-NEXT:    vslidedown.vx v8, v8, a1
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %a = load <3 x i64>, ptr %x
  %b = add <3 x i64> %a, %a
  %c = extractelement <3 x i64> %b, i32 %idx
  ret i64 %c
}

define void @store_extractelt_v16i8(ptr %x, ptr %p) nounwind {
; CHECK-LABEL: store_extractelt_v16i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vsetivli zero, 1, e8, m1, ta, ma
; CHECK-NEXT:    vse8.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <16 x i8>, ptr %x
  %b = extractelement <16 x i8> %a, i32 7
  store i8 %b, ptr %p
  ret void
}

define void @store_extractelt_v8i16(ptr %x, ptr %p) nounwind {
; CHECK-LABEL: store_extractelt_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, ma
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 7
; CHECK-NEXT:    vsetivli zero, 1, e16, m1, ta, ma
; CHECK-NEXT:    vse16.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <8 x i16>, ptr %x
  %b = extractelement <8 x i16> %a, i32 7
  store i16 %b, ptr %p
  ret void
}

define void @store_extractelt_v4i32(ptr %x, ptr %p) nounwind {
; CHECK-LABEL: store_extractelt_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <4 x i32>, ptr %x
  %b = extractelement <4 x i32> %a, i32 2
  store i32 %b, ptr %p
  ret void
}

; FIXME: Use vse64.v on RV32 to avoid two scalar extracts and two scalar stores.
define void @store_extractelt_v2i64(ptr %x, ptr %p) nounwind {
; RV32-LABEL: store_extractelt_v2i64:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV32-NEXT:    vle64.v v8, (a0)
; RV32-NEXT:    vslidedown.vi v8, v8, 1
; RV32-NEXT:    li a0, 32
; RV32-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV32-NEXT:    vsrl.vx v9, v8, a0
; RV32-NEXT:    vmv.x.s a0, v9
; RV32-NEXT:    vmv.x.s a2, v8
; RV32-NEXT:    sw a2, 0(a1)
; RV32-NEXT:    sw a0, 4(a1)
; RV32-NEXT:    ret
;
; RV64-LABEL: store_extractelt_v2i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-NEXT:    vle64.v v8, (a0)
; RV64-NEXT:    vslidedown.vi v8, v8, 1
; RV64-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV64-NEXT:    vse64.v v8, (a1)
; RV64-NEXT:    ret
  %a = load <2 x i64>, ptr %x
  %b = extractelement <2 x i64> %a, i64 1
  store i64 %b, ptr %p
  ret void
}

define void @store_extractelt_v2f64(ptr %x, ptr %p) nounwind {
; CHECK-LABEL: store_extractelt_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vslidedown.vi v8, v8, 1
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; CHECK-NEXT:    vse64.v v8, (a1)
; CHECK-NEXT:    ret
  %a = load <2 x double>, ptr %x
  %b = extractelement <2 x double> %a, i64 1
  store double %b, ptr %p
  ret void
}

define i32 @extractelt_add_v4i32(<4 x i32> %x) {
; RV32-LABEL: extractelt_add_v4i32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; RV32-NEXT:    vslidedown.vi v8, v8, 2
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    addi a0, a0, 13
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_add_v4i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vadd.vi v8, v8, 13
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %bo = add <4 x i32> %x, <i32 11, i32 12, i32 13, i32 14>
  %ext = extractelement <4 x i32> %bo, i32 2
  ret i32 %ext
}

define i32 @extractelt_sub_v4i32(<4 x i32> %x) {
; RV32-LABEL: extractelt_sub_v4i32:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; RV32-NEXT:    vslidedown.vi v8, v8, 2
; RV32-NEXT:    vmv.x.s a0, v8
; RV32-NEXT:    li a1, 13
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_sub_v4i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vrsub.vi v8, v8, 13
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %bo = sub <4 x i32> <i32 11, i32 12, i32 13, i32 14>, %x
  %ext = extractelement <4 x i32> %bo, i32 2
  ret i32 %ext
}

define i32 @extractelt_mul_v4i32(<4 x i32> %x) {
; RV32NOM-LABEL: extractelt_mul_v4i32:
; RV32NOM:       # %bb.0:
; RV32NOM-NEXT:    li a0, 13
; RV32NOM-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32NOM-NEXT:    vmul.vx v8, v8, a0
; RV32NOM-NEXT:    vslidedown.vi v8, v8, 2
; RV32NOM-NEXT:    vmv.x.s a0, v8
; RV32NOM-NEXT:    ret
;
; RV32M-LABEL: extractelt_mul_v4i32:
; RV32M:       # %bb.0:
; RV32M-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; RV32M-NEXT:    vslidedown.vi v8, v8, 2
; RV32M-NEXT:    vmv.x.s a0, v8
; RV32M-NEXT:    li a1, 13
; RV32M-NEXT:    mul a0, a0, a1
; RV32M-NEXT:    ret
;
; RV64-LABEL: extractelt_mul_v4i32:
; RV64:       # %bb.0:
; RV64-NEXT:    li a0, 13
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vmul.vx v8, v8, a0
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %bo = mul <4 x i32> %x, <i32 11, i32 12, i32 13, i32 14>
  %ext = extractelement <4 x i32> %bo, i32 2
  ret i32 %ext
}

define i32 @extractelt_sdiv_v4i32(<4 x i32> %x) {
; RV32NOM-LABEL: extractelt_sdiv_v4i32:
; RV32NOM:       # %bb.0:
; RV32NOM-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32NOM-NEXT:    vmv.v.i v9, -1
; RV32NOM-NEXT:    vmv.v.i v10, 0
; RV32NOM-NEXT:    vslideup.vi v10, v9, 3
; RV32NOM-NEXT:    lui a0, %hi(.LCPI38_0)
; RV32NOM-NEXT:    addi a0, a0, %lo(.LCPI38_0)
; RV32NOM-NEXT:    vle32.v v9, (a0)
; RV32NOM-NEXT:    lui a0, %hi(.LCPI38_1)
; RV32NOM-NEXT:    addi a0, a0, %lo(.LCPI38_1)
; RV32NOM-NEXT:    vle32.v v11, (a0)
; RV32NOM-NEXT:    vand.vv v10, v8, v10
; RV32NOM-NEXT:    vmulh.vv v8, v8, v9
; RV32NOM-NEXT:    vadd.vv v8, v8, v10
; RV32NOM-NEXT:    vsra.vv v9, v8, v11
; RV32NOM-NEXT:    vsrl.vi v8, v8, 31
; RV32NOM-NEXT:    vadd.vv v8, v9, v8
; RV32NOM-NEXT:    vslidedown.vi v8, v8, 2
; RV32NOM-NEXT:    vmv.x.s a0, v8
; RV32NOM-NEXT:    ret
;
; RV32M-LABEL: extractelt_sdiv_v4i32:
; RV32M:       # %bb.0:
; RV32M-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; RV32M-NEXT:    vslidedown.vi v8, v8, 2
; RV32M-NEXT:    vmv.x.s a0, v8
; RV32M-NEXT:    lui a1, 322639
; RV32M-NEXT:    addi a1, a1, -945
; RV32M-NEXT:    mulh a0, a0, a1
; RV32M-NEXT:    srli a1, a0, 31
; RV32M-NEXT:    srai a0, a0, 2
; RV32M-NEXT:    add a0, a0, a1
; RV32M-NEXT:    ret
;
; RV64-LABEL: extractelt_sdiv_v4i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vmv.v.i v9, -1
; RV64-NEXT:    vmv.v.i v10, 0
; RV64-NEXT:    vslideup.vi v10, v9, 3
; RV64-NEXT:    lui a0, %hi(.LCPI38_0)
; RV64-NEXT:    addi a0, a0, %lo(.LCPI38_0)
; RV64-NEXT:    vle32.v v9, (a0)
; RV64-NEXT:    lui a0, %hi(.LCPI38_1)
; RV64-NEXT:    addi a0, a0, %lo(.LCPI38_1)
; RV64-NEXT:    vle32.v v11, (a0)
; RV64-NEXT:    vand.vv v10, v8, v10
; RV64-NEXT:    vmulh.vv v8, v8, v9
; RV64-NEXT:    vadd.vv v8, v8, v10
; RV64-NEXT:    vsra.vv v8, v8, v11
; RV64-NEXT:    vsrl.vi v9, v8, 31
; RV64-NEXT:    vadd.vv v8, v8, v9
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %bo = sdiv <4 x i32> %x, <i32 11, i32 12, i32 13, i32 14>
  %ext = extractelement <4 x i32> %bo, i32 2
  ret i32 %ext
}

define i32 @extractelt_udiv_v4i32(<4 x i32> %x) {
; RV32NOM-LABEL: extractelt_udiv_v4i32:
; RV32NOM:       # %bb.0:
; RV32NOM-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV32NOM-NEXT:    vsrl.vi v8, v8, 0
; RV32NOM-NEXT:    lui a0, 322639
; RV32NOM-NEXT:    addi a0, a0, -945
; RV32NOM-NEXT:    vmulhu.vx v8, v8, a0
; RV32NOM-NEXT:    vslidedown.vi v8, v8, 2
; RV32NOM-NEXT:    vmv.x.s a0, v8
; RV32NOM-NEXT:    srli a0, a0, 2
; RV32NOM-NEXT:    ret
;
; RV32M-LABEL: extractelt_udiv_v4i32:
; RV32M:       # %bb.0:
; RV32M-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; RV32M-NEXT:    vslidedown.vi v8, v8, 2
; RV32M-NEXT:    vmv.x.s a0, v8
; RV32M-NEXT:    lui a1, 322639
; RV32M-NEXT:    addi a1, a1, -945
; RV32M-NEXT:    mulhu a0, a0, a1
; RV32M-NEXT:    srli a0, a0, 2
; RV32M-NEXT:    ret
;
; RV64-LABEL: extractelt_udiv_v4i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; RV64-NEXT:    vsrl.vi v8, v8, 0
; RV64-NEXT:    lui a0, 322639
; RV64-NEXT:    addiw a0, a0, -945
; RV64-NEXT:    vmulhu.vx v8, v8, a0
; RV64-NEXT:    vsrl.vi v8, v8, 2
; RV64-NEXT:    vslidedown.vi v8, v8, 2
; RV64-NEXT:    vmv.x.s a0, v8
; RV64-NEXT:    ret
  %bo = udiv <4 x i32> %x, <i32 11, i32 12, i32 13, i32 14>
  %ext = extractelement <4 x i32> %bo, i32 2
  ret i32 %ext
}

define float @extractelt_fadd_v4f32(<4 x float> %x) {
; CHECK-LABEL: extractelt_fadd_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    lui a0, 267520
; CHECK-NEXT:    fmv.w.x fa4, a0
; CHECK-NEXT:    fadd.s fa0, fa5, fa4
; CHECK-NEXT:    ret
  %bo = fadd <4 x float> %x, <float 11.0, float 12.0, float 13.0, float 14.0>
  %ext = extractelement <4 x float> %bo, i32 2
  ret float %ext
}

define float @extractelt_fsub_v4f32(<4 x float> %x) {
; CHECK-LABEL: extractelt_fsub_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    lui a0, 267520
; CHECK-NEXT:    fmv.w.x fa4, a0
; CHECK-NEXT:    fsub.s fa0, fa4, fa5
; CHECK-NEXT:    ret
  %bo = fsub <4 x float> <float 11.0, float 12.0, float 13.0, float 14.0>, %x
  %ext = extractelement <4 x float> %bo, i32 2
  ret float %ext
}

define float @extractelt_fmul_v4f32(<4 x float> %x) {
; CHECK-LABEL: extractelt_fmul_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    lui a0, 267520
; CHECK-NEXT:    fmv.w.x fa4, a0
; CHECK-NEXT:    fmul.s fa0, fa5, fa4
; CHECK-NEXT:    ret
  %bo = fmul <4 x float> %x, <float 11.0, float 12.0, float 13.0, float 14.0>
  %ext = extractelement <4 x float> %bo, i32 2
  ret float %ext
}

define float @extractelt_fdiv_v4f32(<4 x float> %x) {
; CHECK-LABEL: extractelt_fdiv_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e32, m1, ta, ma
; CHECK-NEXT:    vslidedown.vi v8, v8, 2
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    lui a0, 267520
; CHECK-NEXT:    fmv.w.x fa4, a0
; CHECK-NEXT:    fdiv.s fa0, fa5, fa4
; CHECK-NEXT:    ret
  %bo = fdiv <4 x float> %x, <float 11.0, float 12.0, float 13.0, float 14.0>
  %ext = extractelement <4 x float> %bo, i32 2
  ret float %ext
}
