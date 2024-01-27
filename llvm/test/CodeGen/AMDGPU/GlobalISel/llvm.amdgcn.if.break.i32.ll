; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn--amdhsa -mcpu=gfx1010 -mattr=+wavefrontsize32,-wavefrontsize64 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s
; RUN: llc -global-isel -mtriple=amdgcn--amdhsa -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -mattr=+wavefrontsize32,-wavefrontsize64 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX11 %s

define amdgpu_kernel void @test_wave32(i32 %arg0, [8 x i32], i32 %saved) {
; GFX10-LABEL: test_wave32:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dword s0, s[4:5], 0x0
; GFX10-NEXT:    s_load_dword s1, s[4:5], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_cmp_eq_u32 s0, 0
; GFX10-NEXT:    s_cselect_b32 s0, 1, 0
; GFX10-NEXT:    s_and_b32 s0, 1, s0
; GFX10-NEXT:    v_cmp_ne_u32_e64 s0, 0, s0
; GFX10-NEXT:    s_or_b32 s0, s0, s1
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    global_store_dword v[0:1], v0, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_endpgm
;
; GFX11-LABEL: test_wave32:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b32 s2, s[0:1], 0x0
; GFX11-NEXT:    s_load_b32 s0, s[0:1], 0x24
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_cmp_eq_u32 s2, 0
; GFX11-NEXT:    s_cselect_b32 s1, 1, 0
; GFX11-NEXT:    s_and_b32 s1, 1, s1
; GFX11-NEXT:    v_cmp_ne_u32_e64 s1, 0, s1
; GFX11-NEXT:    s_or_b32 s0, s1, s0
; GFX11-NEXT:    v_mov_b32_e32 v0, s0
; GFX11-NEXT:    global_store_b32 v[0:1], v0, off dlc
; GFX11-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
entry:
  %cond = icmp eq i32 %arg0, 0
  %break = call i32 @llvm.amdgcn.if.break.i32(i1 %cond, i32 %saved)
  store volatile i32 %break, ptr addrspace(1) undef
  ret void
}

declare i32 @llvm.amdgcn.if.break.i32(i1, i32)
