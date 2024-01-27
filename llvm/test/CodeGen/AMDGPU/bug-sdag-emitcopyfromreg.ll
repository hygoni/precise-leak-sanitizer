; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1010 < %s | FileCheck %s -check-prefix=ISA
; RUN: llc -march=amdgcn -mcpu=gfx1010 -stop-before=si-fix-sgpr-copies < %s | FileCheck %s -check-prefix=MIR

define void @f(i32 %arg, ptr %ptr) {
; ISA-LABEL: f:
; ISA:       ; %bb.0: ; %bb
; ISA-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; ISA-NEXT:    s_mov_b64 s[4:5], 0
; ISA-NEXT:    v_cmp_gt_i32_e32 vcc_lo, 1, v0
; ISA-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; ISA-NEXT:    v_mov_b32_e32 v7, 0
; ISA-NEXT:    s_waitcnt lgkmcnt(0)
; ISA-NEXT:    s_lshr_b32 s6, s5, 1
; ISA-NEXT:    s_lshr_b32 s7, 1, s4
; ISA-NEXT:    s_cmp_lg_u32 s4, 0
; ISA-NEXT:    s_cselect_b32 s4, -1, 0
; ISA-NEXT:    v_cndmask_b32_e64 v0, 0, 1.0, s4
; ISA-NEXT:    s_and_b32 s4, s4, exec_lo
; ISA-NEXT:    s_cselect_b32 s4, s6, 0
; ISA-NEXT:    s_cselect_b32 s6, s7, 0
; ISA-NEXT:    s_cselect_b32 s5, s5, 0
; ISA-NEXT:    v_cvt_f32_i32_e32 v3, s4
; ISA-NEXT:    v_cvt_f32_ubyte0_e32 v4, s6
; ISA-NEXT:    v_cvt_f32_i32_e32 v5, s5
; ISA-NEXT:    s_mov_b32 s4, 0
; ISA-NEXT:  .LBB0_1: ; %bb14
; ISA-NEXT:    ; =>This Inner Loop Header: Depth=1
; ISA-NEXT:    v_mov_b32_e32 v6, v7
; ISA-NEXT:    s_and_b32 s5, exec_lo, vcc_lo
; ISA-NEXT:    s_or_b32 s4, s5, s4
; ISA-NEXT:    v_add_f32_e32 v7, v6, v0
; ISA-NEXT:    v_add_f32_e64 v7, v7, |v3|
; ISA-NEXT:    v_add_f32_e32 v7, v7, v4
; ISA-NEXT:    v_add_f32_e32 v7, v7, v5
; ISA-NEXT:    s_andn2_b32 exec_lo, exec_lo, s4
; ISA-NEXT:    s_cbranch_execnz .LBB0_1
; ISA-NEXT:  ; %bb.2: ; %bb21
; ISA-NEXT:    s_or_b32 exec_lo, exec_lo, s4
; ISA-NEXT:    flat_store_dword v[1:2], v6
; ISA-NEXT:    s_waitcnt lgkmcnt(0)
; ISA-NEXT:    s_setpc_b64 s[30:31]
  ; MIR-LABEL: name: f
  ; MIR: bb.0.bb:
  ; MIR-NEXT:   successors: %bb.1(0x80000000)
  ; MIR-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2
  ; MIR-NEXT: {{  $}}
  ; MIR-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; MIR-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; MIR-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; MIR-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sreg_64 = REG_SEQUENCE [[COPY1]], %subreg.sub0, [[COPY]], %subreg.sub1
  ; MIR-NEXT:   [[COPY3:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]]
  ; MIR-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64 = S_MOV_B64 0
  ; MIR-NEXT:   [[S_LOAD_DWORDX2_IMM:%[0-9]+]]:sreg_64_xexec = S_LOAD_DWORDX2_IMM killed [[S_MOV_B64_]], 0, 0 :: (invariant load (s64) from `ptr addrspace(4) null`, align 4294967296, addrspace 4)
  ; MIR-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub1
  ; MIR-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY [[S_LOAD_DWORDX2_IMM]].sub0
  ; MIR-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 1
  ; MIR-NEXT:   [[S_LSHR_B32_:%[0-9]+]]:sreg_32 = S_LSHR_B32 [[COPY4]], [[S_MOV_B32_]], implicit-def dead $scc
  ; MIR-NEXT:   [[S_LSHR_B32_1:%[0-9]+]]:sreg_32 = S_LSHR_B32 [[S_MOV_B32_]], [[COPY5]], implicit-def dead $scc
  ; MIR-NEXT:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; MIR-NEXT:   S_CMP_LG_U32 [[COPY5]], [[S_MOV_B32_1]], implicit-def $scc
  ; MIR-NEXT:   [[COPY6:%[0-9]+]]:sreg_32_xm0_xexec = COPY $scc
  ; MIR-NEXT:   $scc = COPY [[COPY6]]
  ; MIR-NEXT:   [[S_CSELECT_B32_:%[0-9]+]]:sreg_32 = S_CSELECT_B32 killed [[S_LSHR_B32_]], [[S_MOV_B32_1]], implicit $scc
  ; MIR-NEXT:   [[V_CVT_F32_I32_e64_:%[0-9]+]]:vgpr_32 = V_CVT_F32_I32_e64 killed [[S_CSELECT_B32_]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[COPY7:%[0-9]+]]:sgpr_32 = COPY [[V_CVT_F32_I32_e64_]]
  ; MIR-NEXT:   [[S_MOV_B32_2:%[0-9]+]]:sgpr_32 = S_MOV_B32 1065353216
  ; MIR-NEXT:   [[S_MOV_B32_3:%[0-9]+]]:sgpr_32 = S_MOV_B32 0
  ; MIR-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY killed [[S_MOV_B32_2]]
  ; MIR-NEXT:   [[V_CNDMASK_B32_e64_:%[0-9]+]]:vgpr_32 = V_CNDMASK_B32_e64 0, [[S_MOV_B32_3]], 0, [[COPY8]], [[COPY6]], implicit $exec
  ; MIR-NEXT:   [[COPY9:%[0-9]+]]:sgpr_32 = COPY [[V_CNDMASK_B32_e64_]]
  ; MIR-NEXT:   $scc = COPY [[COPY6]]
  ; MIR-NEXT:   [[S_CSELECT_B32_1:%[0-9]+]]:sreg_32 = S_CSELECT_B32 killed [[S_LSHR_B32_1]], [[S_MOV_B32_1]], implicit $scc
  ; MIR-NEXT:   [[V_CVT_F32_UBYTE0_e64_:%[0-9]+]]:vgpr_32 = V_CVT_F32_UBYTE0_e64 killed [[S_CSELECT_B32_1]], 0, 0, implicit $exec
  ; MIR-NEXT:   [[COPY10:%[0-9]+]]:sgpr_32 = COPY [[V_CVT_F32_UBYTE0_e64_]]
  ; MIR-NEXT:   $scc = COPY [[COPY6]]
  ; MIR-NEXT:   [[S_CSELECT_B32_2:%[0-9]+]]:sreg_32 = S_CSELECT_B32 [[COPY4]], [[S_MOV_B32_1]], implicit $scc
  ; MIR-NEXT:   [[V_CVT_F32_I32_e64_1:%[0-9]+]]:vgpr_32 = V_CVT_F32_I32_e64 killed [[S_CSELECT_B32_2]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[COPY11:%[0-9]+]]:sgpr_32 = COPY [[V_CVT_F32_I32_e64_1]]
  ; MIR-NEXT:   [[V_CMP_LT_I32_e64_:%[0-9]+]]:sreg_32 = V_CMP_LT_I32_e64 [[COPY2]], [[S_MOV_B32_]], implicit $exec
  ; MIR-NEXT:   [[COPY12:%[0-9]+]]:vreg_1 = COPY [[V_CMP_LT_I32_e64_]]
  ; MIR-NEXT: {{  $}}
  ; MIR-NEXT: bb.1.bb14:
  ; MIR-NEXT:   successors: %bb.2(0x04000000), %bb.1(0x7c000000)
  ; MIR-NEXT: {{  $}}
  ; MIR-NEXT:   [[PHI:%[0-9]+]]:sreg_32 = PHI [[S_MOV_B32_1]], %bb.0, %7, %bb.1
  ; MIR-NEXT:   [[PHI1:%[0-9]+]]:sgpr_32 = PHI [[S_MOV_B32_3]], %bb.0, %8, %bb.1
  ; MIR-NEXT:   [[COPY13:%[0-9]+]]:sreg_32 = COPY [[COPY12]]
  ; MIR-NEXT:   [[SI_IF_BREAK:%[0-9]+]]:sreg_32 = SI_IF_BREAK [[COPY13]], [[PHI]], implicit-def dead $scc
  ; MIR-NEXT:   [[V_ADD_F32_e64_:%[0-9]+]]:vgpr_32 = nofpexcept V_ADD_F32_e64 0, [[PHI1]], 0, [[COPY9]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[V_ADD_F32_e64_1:%[0-9]+]]:vgpr_32 = nofpexcept V_ADD_F32_e64 0, killed [[V_ADD_F32_e64_]], 2, [[COPY7]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[V_ADD_F32_e64_2:%[0-9]+]]:vgpr_32 = nofpexcept V_ADD_F32_e64 0, killed [[V_ADD_F32_e64_1]], 0, [[COPY10]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[V_ADD_F32_e64_3:%[0-9]+]]:vgpr_32 = nofpexcept V_ADD_F32_e64 0, killed [[V_ADD_F32_e64_2]], 0, [[COPY11]], 0, 0, implicit $mode, implicit $exec
  ; MIR-NEXT:   [[COPY14:%[0-9]+]]:sgpr_32 = COPY [[V_ADD_F32_e64_3]]
  ; MIR-NEXT:   SI_LOOP [[SI_IF_BREAK]], %bb.1, implicit-def dead $exec, implicit-def dead $scc, implicit $exec
  ; MIR-NEXT:   S_BRANCH %bb.2
  ; MIR-NEXT: {{  $}}
  ; MIR-NEXT: bb.2.bb21:
  ; MIR-NEXT:   [[PHI2:%[0-9]+]]:vgpr_32 = PHI [[PHI1]], %bb.1
  ; MIR-NEXT:   [[PHI3:%[0-9]+]]:sreg_32 = PHI [[SI_IF_BREAK]], %bb.1
  ; MIR-NEXT:   SI_END_CF [[PHI3]], implicit-def dead $exec, implicit-def dead $scc, implicit $exec
  ; MIR-NEXT:   FLAT_STORE_DWORD [[COPY3]], [[PHI2]], 0, 0, implicit $exec, implicit $flat_scr :: (store (s32) into %ir.ptr)
  ; MIR-NEXT:   SI_RETURN
bb:
  %i = load <2 x i32>, ptr addrspace(4) null, align 4294967296
  %i1 = extractelement <2 x i32> %i, i64 1
  %i2 = extractelement <2 x i32> %i, i64 0
  %i3 = lshr i32 %i1, 1
  %i4 = icmp ne i32 %i2, 0
  %i5 = select i1 %i4, i32 %i3, i32 0
  %i6 = sitofp i32 %i5 to float
  %i7 = call float @llvm.fabs.f32(float %i6)
  %i8 = uitofp i1 %i4 to float
  %i9 = lshr i32 1, %i2
  %i10 = select i1 %i4, i32 %i9, i32 0
  %i11 = sitofp i32 %i10 to float
  %i12 = select i1 %i4, i32 %i1, i32 0
  %i13 = sitofp i32 %i12 to float
  br label %bb14

bb14:
  %i15 = phi float [ 0.0, %bb ], [ %i19, %bb14 ]
  %i16 = fadd float %i15, %i8
  %i17 = fadd float %i16, %i7
  %i18 = fadd float %i17, %i11
  %i19 = fadd float %i18, %i13
  %i20 = icmp sgt i32 %arg, 0
  br i1 %i20, label %bb14, label %bb21

bb21:
  store float %i15, ptr %ptr, align 4
  ret void
}

declare float @llvm.fabs.f32(float)
