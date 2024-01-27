; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: opt -S -codegenprepare -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 < %s | FileCheck -check-prefix=OPT %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 < %s | FileCheck -check-prefix=GCN %s

; Make sure we match the addressing mode offset of globla.atomic.fadd intrinsics across blocks.

define amdgpu_kernel void @test_sink_small_offset_global_atomic_fadd_f32(ptr addrspace(1) %out, ptr addrspace(1) %in) {
; OPT-LABEL: @test_sink_small_offset_global_atomic_fadd_f32(
; OPT-NEXT:  entry:
; OPT-NEXT:    [[TID:%.*]] = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #[[ATTR3:[0-9]+]]
; OPT-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TID]], 0
; OPT-NEXT:    br i1 [[CMP]], label [[ENDIF:%.*]], label [[IF:%.*]]
; OPT:       if:
; OPT-NEXT:    [[IN_GEP:%.*]] = getelementptr float, ptr addrspace(1) [[IN:%.*]], i32 7
; OPT-NEXT:    [[FADD2:%.*]] = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) [[IN_GEP]], float 2.000000e+00)
; OPT-NEXT:    [[VAL:%.*]] = load volatile float, ptr addrspace(1) undef, align 4
; OPT-NEXT:    br label [[ENDIF]]
; OPT:       endif:
; OPT-NEXT:    [[X:%.*]] = phi float [ [[VAL]], [[IF]] ], [ 0.000000e+00, [[ENTRY:%.*]] ]
; OPT-NEXT:    [[OUT_GEP:%.*]] = getelementptr float, ptr addrspace(1) [[OUT:%.*]], i32 999999
; OPT-NEXT:    store float [[X]], ptr addrspace(1) [[OUT_GEP]], align 4
; OPT-NEXT:    br label [[DONE:%.*]]
; OPT:       done:
; OPT-NEXT:    ret void
;
; GCN-LABEL: test_sink_small_offset_global_atomic_fadd_f32:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GCN-NEXT:    v_mbcnt_lo_u32_b32 v0, -1, 0
; GCN-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; GCN-NEXT:    s_cbranch_execz .LBB0_2
; GCN-NEXT:  ; %bb.1: ; %if
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    v_mov_b32_e32 v1, 2.0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    global_atomic_add_f32 v0, v1, s[2:3] offset:28
; GCN-NEXT:    global_load_dword v0, v[0:1], off glc
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:  .LBB0_2: ; %endif
; GCN-NEXT:    s_or_b64 exec, exec, s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v1, 0x3d0000
; GCN-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GCN-NEXT:    global_store_dword v1, v0, s[0:1] offset:2300
; GCN-NEXT:    s_endpgm
entry:
  %tid = call i32 @llvm.amdgcn.mbcnt.lo(i32 -1, i32 0) #0
  %cmp = icmp eq i32 %tid, 0
  br i1 %cmp, label %endif, label %if

if:
  %in.gep = getelementptr float, ptr addrspace(1) %in, i32 7
  %fadd2 = call float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) %in.gep, float 2.0)
  %val = load volatile float, ptr addrspace(1) undef
  br label %endif

endif:
  %x = phi float [ %val, %if ], [ 0.0, %entry ]
  %out.gep = getelementptr float, ptr addrspace(1) %out, i32 999999
  store float %x, ptr addrspace(1) %out.gep
  br label %done

done:
  ret void
}

declare i32 @llvm.amdgcn.mbcnt.lo(i32, i32) #1
declare float @llvm.amdgcn.global.atomic.fadd.f32.p1.f32(ptr addrspace(1) nocapture, float) #2

attributes #0 = { argmemonly nounwind }
attributes #1 = { nounwind readnone willreturn }
attributes #2 = { argmemonly nounwind willreturn }
