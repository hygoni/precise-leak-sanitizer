; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck --check-prefixes=SI %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX89,VI %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX89,GFX9 %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx1100 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX11 %s

define amdgpu_kernel void @fsub_f16(
; SI-LABEL: fsub_f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s14, s2
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s12, s6
; SI-NEXT:    s_mov_b32 s13, s7
; SI-NEXT:    s_mov_b32 s15, s3
; SI-NEXT:    s_mov_b32 s10, s2
; SI-NEXT:    s_mov_b32 s11, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_sub_f32_e32 v0, v0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; GFX89-LABEL: fsub_f16:
; GFX89:       ; %bb.0: ; %entry
; GFX89-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX89-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX89-NEXT:    s_mov_b32 s3, 0xf000
; GFX89-NEXT:    s_mov_b32 s2, -1
; GFX89-NEXT:    s_mov_b32 s14, s2
; GFX89-NEXT:    s_waitcnt lgkmcnt(0)
; GFX89-NEXT:    s_mov_b32 s12, s6
; GFX89-NEXT:    s_mov_b32 s13, s7
; GFX89-NEXT:    s_mov_b32 s15, s3
; GFX89-NEXT:    s_mov_b32 s10, s2
; GFX89-NEXT:    s_mov_b32 s11, s3
; GFX89-NEXT:    buffer_load_ushort v0, off, s[12:15], 0 glc
; GFX89-NEXT:    s_waitcnt vmcnt(0)
; GFX89-NEXT:    buffer_load_ushort v1, off, s[8:11], 0 glc
; GFX89-NEXT:    s_waitcnt vmcnt(0)
; GFX89-NEXT:    s_mov_b32 s0, s4
; GFX89-NEXT:    s_mov_b32 s1, s5
; GFX89-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX89-NEXT:    buffer_store_short v0, off, s[0:3], 0
; GFX89-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_f16:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    s_mov_b32 s10, -1
; GFX11-NEXT:    s_mov_b32 s11, 0x31016000
; GFX11-NEXT:    s_mov_b32 s14, s10
; GFX11-NEXT:    s_mov_b32 s15, s11
; GFX11-NEXT:    s_mov_b32 s2, s10
; GFX11-NEXT:    s_mov_b32 s3, s11
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s12, s6
; GFX11-NEXT:    s_mov_b32 s13, s7
; GFX11-NEXT:    buffer_load_u16 v0, off, s[12:15], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    buffer_load_u16 v1, off, s[0:3], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_mov_b32 s8, s4
; GFX11-NEXT:    s_mov_b32 s9, s5
; GFX11-NEXT:    v_sub_f16_e32 v0, v0, v1
; GFX11-NEXT:    buffer_store_b16 v0, off, s[8:11], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) {
entry:
  %a.val = load volatile half, ptr addrspace(1) %a
  %b.val = load volatile half, ptr addrspace(1) %b
  %r.val = fsub half %a.val, %b.val
  store half %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fsub_f16_imm_a(
; SI-LABEL: fsub_f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_sub_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; GFX89-LABEL: fsub_f16_imm_a:
; GFX89:       ; %bb.0: ; %entry
; GFX89-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX89-NEXT:    s_mov_b32 s7, 0xf000
; GFX89-NEXT:    s_mov_b32 s6, -1
; GFX89-NEXT:    s_mov_b32 s10, s6
; GFX89-NEXT:    s_mov_b32 s11, s7
; GFX89-NEXT:    s_waitcnt lgkmcnt(0)
; GFX89-NEXT:    s_mov_b32 s8, s2
; GFX89-NEXT:    s_mov_b32 s9, s3
; GFX89-NEXT:    buffer_load_ushort v0, off, s[8:11], 0 glc
; GFX89-NEXT:    s_waitcnt vmcnt(0)
; GFX89-NEXT:    s_mov_b32 s4, s0
; GFX89-NEXT:    s_mov_b32 s5, s1
; GFX89-NEXT:    v_sub_f16_e32 v0, 1.0, v0
; GFX89-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX89-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_f16_imm_a:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_load_b128 s[0:3], s[0:1], 0x24
; GFX11-NEXT:    s_mov_b32 s6, -1
; GFX11-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-NEXT:    s_mov_b32 s10, s6
; GFX11-NEXT:    s_mov_b32 s11, s7
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s8, s2
; GFX11-NEXT:    s_mov_b32 s9, s3
; GFX11-NEXT:    s_mov_b32 s4, s0
; GFX11-NEXT:    buffer_load_u16 v0, off, s[8:11], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_mov_b32 s5, s1
; GFX11-NEXT:    v_sub_f16_e32 v0, 1.0, v0
; GFX11-NEXT:    buffer_store_b16 v0, off, s[4:7], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %b) {
entry:
  %b.val = load volatile half, ptr addrspace(1) %b
  %r.val = fsub half 1.0, %b.val
  store half %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fsub_f16_imm_b(
; SI-LABEL: fsub_f16_imm_b:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_ushort v0, off, s[8:11], 0 glc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_add_f32_e32 v0, -2.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; GFX89-LABEL: fsub_f16_imm_b:
; GFX89:       ; %bb.0: ; %entry
; GFX89-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX89-NEXT:    s_mov_b32 s7, 0xf000
; GFX89-NEXT:    s_mov_b32 s6, -1
; GFX89-NEXT:    s_mov_b32 s10, s6
; GFX89-NEXT:    s_mov_b32 s11, s7
; GFX89-NEXT:    s_waitcnt lgkmcnt(0)
; GFX89-NEXT:    s_mov_b32 s8, s2
; GFX89-NEXT:    s_mov_b32 s9, s3
; GFX89-NEXT:    buffer_load_ushort v0, off, s[8:11], 0 glc
; GFX89-NEXT:    s_waitcnt vmcnt(0)
; GFX89-NEXT:    s_mov_b32 s4, s0
; GFX89-NEXT:    s_mov_b32 s5, s1
; GFX89-NEXT:    v_add_f16_e32 v0, -2.0, v0
; GFX89-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX89-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_f16_imm_b:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_load_b128 s[0:3], s[0:1], 0x24
; GFX11-NEXT:    s_mov_b32 s6, -1
; GFX11-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-NEXT:    s_mov_b32 s10, s6
; GFX11-NEXT:    s_mov_b32 s11, s7
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s8, s2
; GFX11-NEXT:    s_mov_b32 s9, s3
; GFX11-NEXT:    s_mov_b32 s4, s0
; GFX11-NEXT:    buffer_load_u16 v0, off, s[8:11], 0 glc dlc
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    s_mov_b32 s5, s1
; GFX11-NEXT:    v_add_f16_e32 v0, -2.0, v0
; GFX11-NEXT:    buffer_store_b16 v0, off, s[4:7], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load volatile half, ptr addrspace(1) %a
  %r.val = fsub half %a.val, 2.0
  store half %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fsub_v2f16(
; SI-LABEL: fsub_v2f16:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_mov_b32 s10, s2
; SI-NEXT:    s_mov_b32 s11, s3
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s12, s6
; SI-NEXT:    s_mov_b32 s13, s7
; SI-NEXT:    s_mov_b32 s14, s2
; SI-NEXT:    s_mov_b32 s15, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    buffer_load_dword v1, off, s[12:15], 0
; SI-NEXT:    s_mov_b32 s0, s4
; SI-NEXT:    s_mov_b32 s1, s5
; SI-NEXT:    s_waitcnt vmcnt(1)
; SI-NEXT:    v_lshrrev_b32_e32 v2, 16, v0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v3, 16, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v2, v2
; SI-NEXT:    v_cvt_f32_f16_e32 v3, v3
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_sub_f32_e32 v2, v3, v2
; SI-NEXT:    v_cvt_f16_f32_e32 v2, v2
; SI-NEXT:    v_sub_f32_e32 v0, v1, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v2
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fsub_v2f16:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_mov_b32 s10, s2
; VI-NEXT:    s_mov_b32 s11, s3
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s12, s6
; VI-NEXT:    s_mov_b32 s13, s7
; VI-NEXT:    s_mov_b32 s14, s2
; VI-NEXT:    s_mov_b32 s15, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    buffer_load_dword v1, off, s[12:15], 0
; VI-NEXT:    s_mov_b32 s0, s4
; VI-NEXT:    s_mov_b32 s1, s5
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_sub_f16_sdwa v2, v1, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NEXT:    v_sub_f16_e32 v0, v1, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fsub_v2f16:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x34
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_mov_b32 s14, s2
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s12, s6
; GFX9-NEXT:    s_mov_b32 s13, s7
; GFX9-NEXT:    s_mov_b32 s15, s3
; GFX9-NEXT:    s_mov_b32 s10, s2
; GFX9-NEXT:    s_mov_b32 s11, s3
; GFX9-NEXT:    buffer_load_dword v0, off, s[12:15], 0
; GFX9-NEXT:    buffer_load_dword v1, off, s[8:11], 0
; GFX9-NEXT:    s_mov_b32 s0, s4
; GFX9-NEXT:    s_mov_b32 s1, s5
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_add_f16 v0, v0, v1 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_v2f16:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_clause 0x1
; GFX11-NEXT:    s_load_b128 s[4:7], s[0:1], 0x24
; GFX11-NEXT:    s_load_b64 s[0:1], s[0:1], 0x34
; GFX11-NEXT:    s_mov_b32 s10, -1
; GFX11-NEXT:    s_mov_b32 s11, 0x31016000
; GFX11-NEXT:    s_mov_b32 s14, s10
; GFX11-NEXT:    s_mov_b32 s15, s11
; GFX11-NEXT:    s_mov_b32 s2, s10
; GFX11-NEXT:    s_mov_b32 s3, s11
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s12, s6
; GFX11-NEXT:    s_mov_b32 s13, s7
; GFX11-NEXT:    buffer_load_b32 v0, off, s[12:15], 0
; GFX11-NEXT:    buffer_load_b32 v1, off, s[0:3], 0
; GFX11-NEXT:    s_mov_b32 s8, s4
; GFX11-NEXT:    s_mov_b32 s9, s5
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_pk_add_f16 v0, v0, v1 neg_lo:[0,1] neg_hi:[0,1]
; GFX11-NEXT:    buffer_store_b32 v0, off, s[8:11], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a,
    ptr addrspace(1) %b) {
entry:
  %a.val = load <2 x half>, ptr addrspace(1) %a
  %b.val = load <2 x half>, ptr addrspace(1) %b
  %r.val = fsub <2 x half> %a.val, %b.val
  store <2 x half> %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fsub_v2f16_imm_a(
; SI-LABEL: fsub_v2f16_imm_a:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_sub_f32_e32 v1, 2.0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_sub_f32_e32 v0, 1.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fsub_v2f16_imm_a:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    v_mov_b32_e32 v1, 0x4000
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_sub_f16_sdwa v1, v1, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_1
; VI-NEXT:    v_sub_f16_e32 v0, 1.0, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fsub_v2f16_imm_a:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_mov_b32 s10, s6
; GFX9-NEXT:    s_mov_b32 s11, s7
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s8, s2
; GFX9-NEXT:    s_mov_b32 s9, s3
; GFX9-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; GFX9-NEXT:    s_mov_b32 s4, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x40003c00
; GFX9-NEXT:    s_mov_b32 s5, s1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_add_f16 v0, v0, s0 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_v2f16_imm_a:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_load_b128 s[0:3], s[0:1], 0x24
; GFX11-NEXT:    s_mov_b32 s6, -1
; GFX11-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-NEXT:    s_mov_b32 s10, s6
; GFX11-NEXT:    s_mov_b32 s11, s7
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s8, s2
; GFX11-NEXT:    s_mov_b32 s9, s3
; GFX11-NEXT:    s_mov_b32 s4, s0
; GFX11-NEXT:    buffer_load_b32 v0, off, s[8:11], 0
; GFX11-NEXT:    s_mov_b32 s5, s1
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_pk_add_f16 v0, 0x40003c00, v0 neg_lo:[0,1] neg_hi:[0,1]
; GFX11-NEXT:    buffer_store_b32 v0, off, s[4:7], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %b) {
entry:
  %b.val = load <2 x half>, ptr addrspace(1) %b
  %r.val = fsub <2 x half> <half 1.0, half 2.0>, %b.val
  store <2 x half> %r.val, ptr addrspace(1) %r
  ret void
}

define amdgpu_kernel void @fsub_v2f16_imm_b(
; SI-LABEL: fsub_v2f16_imm_b:
; SI:       ; %bb.0: ; %entry
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s10, s6
; SI-NEXT:    s_mov_b32 s11, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s8, s2
; SI-NEXT:    s_mov_b32 s9, s3
; SI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; SI-NEXT:    s_mov_b32 s4, s0
; SI-NEXT:    s_mov_b32 s5, s1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v1, v1
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    v_add_f32_e32 v1, -1.0, v1
; SI-NEXT:    v_cvt_f16_f32_e32 v1, v1
; SI-NEXT:    v_add_f32_e32 v0, -2.0, v0
; SI-NEXT:    v_cvt_f16_f32_e32 v0, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: fsub_v2f16_imm_b:
; VI:       ; %bb.0: ; %entry
; VI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_mov_b32 s10, s6
; VI-NEXT:    s_mov_b32 s11, s7
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    s_mov_b32 s8, s2
; VI-NEXT:    s_mov_b32 s9, s3
; VI-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; VI-NEXT:    v_mov_b32_e32 v1, 0xbc00
; VI-NEXT:    s_mov_b32 s4, s0
; VI-NEXT:    s_mov_b32 s5, s1
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    v_add_f16_sdwa v1, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-NEXT:    v_add_f16_e32 v0, -2.0, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: fsub_v2f16_imm_b:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_mov_b32 s10, s6
; GFX9-NEXT:    s_mov_b32 s11, s7
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s8, s2
; GFX9-NEXT:    s_mov_b32 s9, s3
; GFX9-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; GFX9-NEXT:    s_mov_b32 s4, s0
; GFX9-NEXT:    s_mov_b32 s0, 0xbc00c000
; GFX9-NEXT:    s_mov_b32 s5, s1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_pk_add_f16 v0, v0, s0
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
;
; GFX11-LABEL: fsub_v2f16_imm_b:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_load_b128 s[0:3], s[0:1], 0x24
; GFX11-NEXT:    s_mov_b32 s6, -1
; GFX11-NEXT:    s_mov_b32 s7, 0x31016000
; GFX11-NEXT:    s_mov_b32 s10, s6
; GFX11-NEXT:    s_mov_b32 s11, s7
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 s8, s2
; GFX11-NEXT:    s_mov_b32 s9, s3
; GFX11-NEXT:    s_mov_b32 s4, s0
; GFX11-NEXT:    buffer_load_b32 v0, off, s[8:11], 0
; GFX11-NEXT:    s_mov_b32 s5, s1
; GFX11-NEXT:    s_waitcnt vmcnt(0)
; GFX11-NEXT:    v_pk_add_f16 v0, 0xbc00c000, v0
; GFX11-NEXT:    buffer_store_b32 v0, off, s[4:7], 0
; GFX11-NEXT:    s_nop 0
; GFX11-NEXT:    s_sendmsg sendmsg(MSG_DEALLOC_VGPRS)
; GFX11-NEXT:    s_endpgm
    ptr addrspace(1) %r,
    ptr addrspace(1) %a) {
entry:
  %a.val = load <2 x half>, ptr addrspace(1) %a
  %r.val = fsub <2 x half> %a.val, <half 2.0, half 1.0>
  store <2 x half> %r.val, ptr addrspace(1) %r
  ret void
}
