; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define float @test_min_max_ValK0_K1_f32(float %a) #0 {
; GFX10-LABEL: test_min_max_ValK0_K1_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e64 v0, v0, 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %maxnum = call nnan float @llvm.maxnum.f32(float %fmul, float 0.0)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 1.0)
  ret float %fmed
}

define double @test_min_max_K0Val_K1_f64(double %a) #1 {
; GFX10-LABEL: test_min_max_K0Val_K1_f64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul double %a, 2.0
  %maxnum = call nnan double @llvm.maxnum.f64(double 0.0, double %fmul)
  %fmed = call nnan double @llvm.minnum.f64(double %maxnum, double 1.0)
  ret double %fmed
}

; min-max patterns for ieee=true, dx10_clamp=true don't have to check for NaNs
define half @test_min_K1max_ValK0_f16(half %a) #2 {
; GFX10-LABEL: test_min_K1max_ValK0_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f16_e64 v0, v0, 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul half %a, 2.0
  %maxnum = call half @llvm.maxnum.f16(half %fmul, half 0.0)
  %fmed = call half @llvm.minnum.f16(half 1.0, half %maxnum)
  ret half %fmed
}

define <2 x half> @test_min_K1max_K0Val_f16(<2 x half> %a) #1 {
; GFX10-LABEL: test_min_K1max_K0Val_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, 2.0 op_sel_hi:[1,0] clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul <2 x half> %a, <half 2.0, half 2.0>
  %maxnum = call nnan <2 x half> @llvm.maxnum.v2f16(<2 x half> <half 0.0, half 0.0>, <2 x half> %fmul)
  %fmed = call nnan <2 x half> @llvm.minnum.v2f16(<2 x half> <half 1.0, half 1.0>, <2 x half> %maxnum)
  ret <2 x half> %fmed
}

define <2 x half> @test_min_max_splat_padded_with_undef(<2 x half> %a) #2 {
; GFX10-LABEL: test_min_max_splat_padded_with_undef:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, 2.0 op_sel_hi:[1,0] clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul <2 x half> %a, <half 2.0, half 2.0>
  %maxnum = call <2 x half> @llvm.maxnum.v2f16(<2 x half> <half 0.0, half undef>, <2 x half> %fmul)
  %fmed = call <2 x half> @llvm.minnum.v2f16(<2 x half> <half 1.0, half undef>, <2 x half> %maxnum)
  ret <2 x half> %fmed
}

; max-mix patterns work only for known non-NaN inputs

define float @test_max_min_ValK1_K0_f32(float %a) #0 {
; GFX10-LABEL: test_max_min_ValK1_K0_f32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e64 v0, v0, 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %minnum = call nnan float @llvm.minnum.f32(float %fmul, float 1.0)
  %fmed = call nnan float @llvm.maxnum.f32(float %minnum, float 0.0)
  ret float %fmed
}

define double @test_max_min_K1Val_K0_f64(double %a) #1 {
; GFX10-LABEL: test_max_min_K1Val_K0_f64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f64 v[0:1], v[0:1], 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul double %a, 2.0
  %minnum = call nnan double @llvm.minnum.f64(double 1.0, double %fmul)
  %fmed = call nnan double @llvm.maxnum.f64(double %minnum, double 0.0)
  ret double %fmed
}

define half @test_max_K0min_ValK1_f16(half %a) #0 {
; GFX10-LABEL: test_max_K0min_ValK1_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f16_e64 v0, v0, 2.0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul half %a, 2.0
  %minnum = call nnan half @llvm.minnum.f16(half %fmul, half 1.0)
  %fmed = call nnan half @llvm.maxnum.f16(half 0.0, half %minnum)
  ret half %fmed
}

; treat undef as value that will result in a constant splat
define <2 x half> @test_max_K0min_K1Val_v2f16(<2 x half> %a) #1 {
; GFX10-LABEL: test_max_K0min_K1Val_v2f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_pk_mul_f16 v0, v0, 2.0 op_sel_hi:[1,0] clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul <2 x half> %a, <half 2.0, half 2.0>
  %minnum = call nnan <2 x half> @llvm.minnum.v2f16(<2 x half> <half 1.0, half undef>, <2 x half> %fmul)
  %fmed = call nnan <2 x half> @llvm.maxnum.v2f16(<2 x half> <half undef, half 0.0>, <2 x half> %minnum)
  ret <2 x half> %fmed
}

; global nnan function attribute always forces clamp combine

define float @test_min_max_global_nnan(float %a) #3 {
; GFX10-LABEL: test_min_max_global_nnan:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_max_f32_e64 v0, v0, v0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call float @llvm.maxnum.f32(float %a, float 0.0)
  %fmed = call float @llvm.minnum.f32(float %maxnum, float 1.0)
  ret float %fmed
}

define float @test_max_min_global_nnan(float %a) #3 {
; GFX10-LABEL: test_max_min_global_nnan:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_max_f32_e64 v0, v0, v0 clamp
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call float @llvm.minnum.f32(float %a, float 1.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 0.0)
  ret float %fmed
}

; ------------------------------------------------------------------------------
; Negative patterns
; ------------------------------------------------------------------------------

; min(max(Val, 1.0), 0.0), should be min(max(Val, 0.0), 1.0)
define float @test_min_max_K0_gt_K1(float %a) #0 {
; GFX10-LABEL: test_min_max_K0_gt_K1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_max_f32_e32 v0, 1.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %maxnum = call nnan float @llvm.maxnum.f32(float %a, float 1.0)
  %fmed = call nnan float @llvm.minnum.f32(float %maxnum, float 0.0)
  ret float %fmed
}

; max(min(Val, 0.0), 1.0), should be max(min(Val, 1.0), 0.0)
define float @test_max_min_K0_gt_K1(float %a) #0 {
; GFX10-LABEL: test_max_min_K0_gt_K1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_min_f32_e32 v0, 0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 1.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %minnum = call nnan float @llvm.minnum.f32(float %a, float 0.0)
  %fmed = call nnan float @llvm.maxnum.f32(float %minnum, float 1.0)
  ret float %fmed
}

; Input that can be NaN

; min-max patterns for ieee=false require known non-NaN input
define float @test_min_max_maybe_NaN_input_ieee_false(float %a) #1 {
; GFX10-LABEL: test_min_max_maybe_NaN_input_ieee_false:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 1.0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %maxnum = call float @llvm.maxnum.f32(float %fmul, float 0.0)
  %fmed = call float @llvm.minnum.f32(float %maxnum, float 1.0)
  ret float %fmed
}

; clamp fails here since input can be NaN and dx10_clamp=false; fmed3 succeds
define float @test_min_max_maybe_NaN_input_ieee_true_dx10clamp_false(float %a) #4 {
; GFX10-LABEL: test_min_max_maybe_NaN_input_ieee_true_dx10clamp_false:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_med3_f32 v0, v0, 0, 1.0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %maxnum = call float @llvm.maxnum.f32(float %fmul, float 0.0)
  %fmed = call float @llvm.minnum.f32(float %maxnum, float 1.0)
  ret float %fmed
}

; max-min patterns always require known non-NaN input

define float @test_max_min_maybe_NaN_input_ieee_true(float %a) #0 {
; GFX10-LABEL: test_max_min_maybe_NaN_input_ieee_true:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 1.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %minnum = call float @llvm.minnum.f32(float %fmul, float 1.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 0.0)
  ret float %fmed
}

define float @test_max_min_maybe_NaN_input_ieee_false(float %a) #1 {
; GFX10-LABEL: test_max_min_maybe_NaN_input_ieee_false:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    v_mul_f32_e32 v0, 2.0, v0
; GFX10-NEXT:    v_min_f32_e32 v0, 1.0, v0
; GFX10-NEXT:    v_max_f32_e32 v0, 0, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fmul = fmul float %a, 2.0
  %minnum = call float @llvm.minnum.f32(float %fmul, float 1.0)
  %fmed = call float @llvm.maxnum.f32(float %minnum, float 0.0)
  ret float %fmed
}

declare half @llvm.minnum.f16(half, half)
declare half @llvm.maxnum.f16(half, half)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare double @llvm.minnum.f64(double, double)
declare double @llvm.maxnum.f64(double, double)
declare <2 x half> @llvm.minnum.v2f16(<2 x half>, <2 x half>)
declare <2 x half> @llvm.maxnum.v2f16(<2 x half>, <2 x half>)
attributes #0 = {"amdgpu-ieee"="true"}
attributes #1 = {"amdgpu-ieee"="false"}
attributes #2 = {"amdgpu-ieee"="true" "amdgpu-dx10-clamp"="true"}
attributes #3 = {"no-nans-fp-math"="true"}
attributes #4 = {"amdgpu-ieee"="true" "amdgpu-dx10-clamp"="false"}
