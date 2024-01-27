; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s

define amdgpu_ps float @struct_ptr_buffer_load_format_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_X_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_FORMAT_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_FORMAT_X_BOTHEN]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.ptr.buffer.load.format.f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

define amdgpu_ps <2 x float> @struct_ptr_buffer_load_format_v2f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v2f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XY_BOTHEN:%[0-9]+]]:vreg_64 = BUFFER_LOAD_FORMAT_XY_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, implicit $exec :: (dereferenceable load (<2 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XY_BOTHEN]].sub0
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XY_BOTHEN]].sub1
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY7]]
  ; CHECK-NEXT:   $vgpr1 = COPY [[COPY8]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v2f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <2 x float> %val
}

define amdgpu_ps <3 x float> @struct_ptr_buffer_load_format_v3f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v3f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XYZ_BOTHEN:%[0-9]+]]:vreg_96 = BUFFER_LOAD_FORMAT_XYZ_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, implicit $exec :: (dereferenceable load (<3 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_BOTHEN]].sub0
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_BOTHEN]].sub1
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_BOTHEN]].sub2
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY7]]
  ; CHECK-NEXT:   $vgpr1 = COPY [[COPY8]]
  ; CHECK-NEXT:   $vgpr2 = COPY [[COPY9]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2
  %val = call <3 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v3f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <3 x float> %val
}

define amdgpu_ps <4 x float> @struct_ptr_buffer_load_format_v4f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v4f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN:%[0-9]+]]:vreg_128 = BUFFER_LOAD_FORMAT_XYZW_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub0
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub1
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub2
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub3
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY7]]
  ; CHECK-NEXT:   $vgpr1 = COPY [[COPY8]]
  ; CHECK-NEXT:   $vgpr2 = COPY [[COPY9]]
  ; CHECK-NEXT:   $vgpr3 = COPY [[COPY10]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3
  %val = call <4 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v4f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <4 x float> %val
}

; Waterfall for rsrc and soffset, copy for voffset
define amdgpu_ps <4 x float> @struct_ptr_buffer_load_format_v4f32__vpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset(ptr addrspace(8) %rsrc, i32 inreg %vindex, i32 inreg %voffset, i32 %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v4f32__vpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x80000000)
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; CHECK-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY1]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY2]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY3]], implicit $exec
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub0_sub1
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub2_sub3
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY11]], [[COPY9]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY12]], [[COPY10]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_]], [[V_CMP_EQ_U64_e64_1]], implicit-def $scc
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[S_AND_B64_]], [[V_CMP_EQ_U32_e64_]], implicit-def $scc
  ; CHECK-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3:
  ; CHECK-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY7]], %subreg.sub0, [[COPY8]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN:%[0-9]+]]:vreg_128 = BUFFER_LOAD_FORMAT_XYZW_BOTHEN [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[V_READFIRSTLANE_B32_4]], 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.4:
  ; CHECK-NEXT:   successors: %bb.5(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.5:
  ; CHECK-NEXT:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub0
  ; CHECK-NEXT:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub1
  ; CHECK-NEXT:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub2
  ; CHECK-NEXT:   [[COPY16:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_BOTHEN]].sub3
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY13]]
  ; CHECK-NEXT:   $vgpr1 = COPY [[COPY14]]
  ; CHECK-NEXT:   $vgpr2 = COPY [[COPY15]]
  ; CHECK-NEXT:   $vgpr3 = COPY [[COPY16]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3
  %val = call <4 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v4f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <4 x float> %val
}

define amdgpu_ps float @struct_ptr_buffer_load_format_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffsset_add_4095(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset.base, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffsset_add_4095
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_X_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_FORMAT_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 4095, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_FORMAT_X_BOTHEN]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %voffset = add i32 %voffset.base, 4095
  %val = call float @llvm.amdgcn.struct.ptr.buffer.load.format.f32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

define amdgpu_ps float @struct_ptr_buffer_load_format_i32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(ptr addrspace(8) inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_i32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_X_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_FORMAT_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   $vgpr0 = COPY [[BUFFER_LOAD_FORMAT_X_BOTHEN]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call i32 @llvm.amdgcn.struct.ptr.buffer.load.format.i32(ptr addrspace(8) %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %fval = bitcast i32 %val to float
  ret float %fval
}

define amdgpu_cs void @struct_ptr_buffer_load_format_v4i32_tfe(ptr addrspace(8) inreg %rsrc, ptr addrspace(1) %value, ptr addrspace(1) %status) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v4i32_tfe
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN:%[0-9]+]]:vreg_160 = BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN [[COPY8]], [[REG_SEQUENCE2]], [[S_MOV_B32_]], 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN]].sub0
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN]].sub1
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN]].sub2
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN]].sub3
  ; CHECK-NEXT:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZW_TFE_IDXEN]].sub4
  ; CHECK-NEXT:   [[REG_SEQUENCE3:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY9]], %subreg.sub0, [[COPY10]], %subreg.sub1, [[COPY11]], %subreg.sub2, [[COPY12]], %subreg.sub3
  ; CHECK-NEXT:   FLAT_STORE_DWORDX4 [[REG_SEQUENCE]], [[REG_SEQUENCE3]], 0, 0, implicit $exec, implicit $flat_scr :: (store (<4 x s32>) into %ir.value, addrspace 1)
  ; CHECK-NEXT:   FLAT_STORE_DWORD [[REG_SEQUENCE1]], [[COPY13]], 0, 0, implicit $exec, implicit $flat_scr :: (store (s32) into %ir.status, addrspace 1)
  ; CHECK-NEXT:   S_ENDPGM 0
  %load = call { <4 x i32>, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_v4i32i32s(ptr addrspace(8) %rsrc, i32 0, i32 0, i32 0, i32 0)

  %v = extractvalue { <4 x i32>, i32 } %load, 0
  store <4 x i32> %v, ptr addrspace(1) %value

  %s = extractvalue { <4 x i32>, i32 } %load, 1
  store i32 %s, ptr addrspace(1) %status

  ret void
}

define amdgpu_cs void @struct_ptr_buffer_load_format_v3i32_tfe(ptr addrspace(8) inreg %rsrc, ptr addrspace(1) %value, ptr addrspace(1) %status) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_v3i32_tfe
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN:%[0-9]+]]:vreg_128 = BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN [[COPY8]], [[REG_SEQUENCE2]], [[S_MOV_B32_]], 0, 0, 0, implicit $exec :: (dereferenceable load (<3 x s32>) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN]].sub0
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN]].sub1
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN]].sub2
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_XYZ_TFE_IDXEN]].sub3
  ; CHECK-NEXT:   [[REG_SEQUENCE3:%[0-9]+]]:vreg_96 = REG_SEQUENCE [[COPY9]], %subreg.sub0, [[COPY10]], %subreg.sub1, [[COPY11]], %subreg.sub2
  ; CHECK-NEXT:   FLAT_STORE_DWORDX3 [[REG_SEQUENCE]], [[REG_SEQUENCE3]], 0, 0, implicit $exec, implicit $flat_scr :: (store (<3 x s32>) into %ir.value, align 16, addrspace 1)
  ; CHECK-NEXT:   FLAT_STORE_DWORD [[REG_SEQUENCE1]], [[COPY12]], 0, 0, implicit $exec, implicit $flat_scr :: (store (s32) into %ir.status, addrspace 1)
  ; CHECK-NEXT:   S_ENDPGM 0
  %load = call { <3 x i32>, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_v3i32i32s(ptr addrspace(8) %rsrc, i32 0, i32 0, i32 0, i32 0)

  %v = extractvalue { <3 x i32>, i32 } %load, 0
  store <3 x i32> %v, ptr addrspace(1) %value

  %s = extractvalue { <3 x i32>, i32 } %load, 1
  store i32 %s, ptr addrspace(1) %status

  ret void
}

define amdgpu_cs void @struct_ptr_buffer_load_format_i32_tfe(ptr addrspace(8) inreg %rsrc, ptr addrspace(1) %value, ptr addrspace(1) %status) {
  ; CHECK-LABEL: name: struct_ptr_buffer_load_format_i32_tfe
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK-NEXT:   [[BUFFER_LOAD_FORMAT_X_TFE_IDXEN:%[0-9]+]]:vreg_64 = BUFFER_LOAD_FORMAT_X_TFE_IDXEN [[COPY8]], [[REG_SEQUENCE2]], [[S_MOV_B32_]], 0, 0, 0, implicit $exec :: (dereferenceable load (s32) from %ir.rsrc, align 1, addrspace 8)
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_X_TFE_IDXEN]].sub0
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_FORMAT_X_TFE_IDXEN]].sub1
  ; CHECK-NEXT:   FLAT_STORE_DWORD [[REG_SEQUENCE]], [[COPY9]], 0, 0, implicit $exec, implicit $flat_scr :: (store (s32) into %ir.value, addrspace 1)
  ; CHECK-NEXT:   FLAT_STORE_DWORD [[REG_SEQUENCE1]], [[COPY10]], 0, 0, implicit $exec, implicit $flat_scr :: (store (s32) into %ir.status, addrspace 1)
  ; CHECK-NEXT:   S_ENDPGM 0
  %load = call { i32, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_i32i32s(ptr addrspace(8) %rsrc, i32 0, i32 0, i32 0, i32 0)

  %v = extractvalue { i32, i32 } %load, 0
  store i32 %v, ptr addrspace(1) %value

  %s = extractvalue { i32, i32 } %load, 1
  store i32 %s, ptr addrspace(1) %status

  ret void
}

declare float @llvm.amdgcn.struct.ptr.buffer.load.format.f32(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare <2 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v2f32(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare <3 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v3f32(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.struct.ptr.buffer.load.format.v4f32(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare i32 @llvm.amdgcn.struct.ptr.buffer.load.format.i32(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare { <4 x i32>, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_v4i32i32s(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare { <3 x i32>, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_v3i32i32s(ptr addrspace(8), i32, i32, i32, i32 immarg) #0
declare { i32, i32 } @llvm.amdgcn.struct.ptr.buffer.load.format.sl_i32i32s(ptr addrspace(8), i32, i32, i32, i32 immarg) #0

attributes #0 = { nounwind readonly }
