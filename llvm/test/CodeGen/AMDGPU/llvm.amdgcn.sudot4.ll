; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1100 -show-mc-encoding -verify-machineinstrs < %s | FileCheck %s --check-prefixes=GFX11

declare i32 @llvm.amdgcn.sudot4(i1 %asign, i32 %a, i1 %bsign, i32 %b, i32 %c, i1 %clamp)

define i32 @test_llvm_amdgcn_sudot4_uu(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_uu:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 ; encoding: [0x00,0x40,0x16,0xcc,0x00,0x03,0x0a,0x1c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 0, i32 %a, i1 0, i32 %b, i32 %c, i1 0)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_us(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_us:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[0,1,0] ; encoding: [0x00,0x40,0x16,0xcc,0x00,0x03,0x0a,0x5c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 0, i32 %a, i1 1, i32 %b, i32 %c, i1 0)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_su(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_su:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[1,0,0] ; encoding: [0x00,0x40,0x16,0xcc,0x00,0x03,0x0a,0x3c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 1, i32 %a, i1 0, i32 %b, i32 %c, i1 0)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_ss(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_ss:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[1,1,0] ; encoding: [0x00,0x40,0x16,0xcc,0x00,0x03,0x0a,0x7c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 1, i32 %a, i1 1, i32 %b, i32 %c, i1 0)
  ret i32 %ret
}



define i32 @test_llvm_amdgcn_sudot4_uu_clamp(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_uu_clamp:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 clamp ; encoding: [0x00,0xc0,0x16,0xcc,0x00,0x03,0x0a,0x1c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 0, i32 %a, i1 0, i32 %b, i32 %c, i1 1)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_us_clamp(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_us_clamp:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[0,1,0] clamp ; encoding: [0x00,0xc0,0x16,0xcc,0x00,0x03,0x0a,0x5c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 0, i32 %a, i1 1, i32 %b, i32 %c, i1 1)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_su_clamp(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_su_clamp:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[1,0,0] clamp ; encoding: [0x00,0xc0,0x16,0xcc,0x00,0x03,0x0a,0x3c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 1, i32 %a, i1 0, i32 %b, i32 %c, i1 1)
  ret i32 %ret
}

define i32 @test_llvm_amdgcn_sudot4_ss_clamp(i32 %a, i32 %b, i32 %c) {
; GFX11-LABEL: test_llvm_amdgcn_sudot4_ss_clamp:
; GFX11:       ; %bb.0: ; %entry
; GFX11-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0) ; encoding: [0x00,0x00,0x89,0xbf]
; GFX11-NEXT:    v_dot4_i32_iu8 v0, v0, v1, v2 neg_lo:[1,1,0] clamp ; encoding: [0x00,0xc0,0x16,0xcc,0x00,0x03,0x0a,0x7c]
; GFX11-NEXT:    s_setpc_b64 s[30:31] ; encoding: [0x1e,0x48,0x80,0xbe]
entry:
  %ret = call i32 @llvm.amdgcn.sudot4(i1 1, i32 %a, i1 1, i32 %b, i32 %c, i1 1)
  ret i32 %ret
}
