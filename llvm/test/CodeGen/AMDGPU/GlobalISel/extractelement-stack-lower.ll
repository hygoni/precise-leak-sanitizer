; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -mattr=-xnack -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN %s

; Check lowering of some large extractelement that use the stack
; instead of register indexing.

define i32 @v_extract_v64i32_varidx(ptr addrspace(1) %ptr, i32 %idx) {
; GCN-LABEL: v_extract_v64i32_varidx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s4, s33
; GCN-NEXT:    s_add_i32 s33, s32, 0x3fc0
; GCN-NEXT:    s_and_b32 s33, s33, 0xffffc000
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 ; 4-byte Folded Spill
; GCN-NEXT:    v_mov_b32_e32 v6, v2
; GCN-NEXT:    global_load_dwordx4 v[2:5], v[0:1], off
; GCN-NEXT:    global_load_dwordx4 v[16:19], v[0:1], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[56:59], v[0:1], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[48:51], v[0:1], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[20:23], v[0:1], off offset:64
; GCN-NEXT:    global_load_dwordx4 v[44:47], v[0:1], off offset:80
; GCN-NEXT:    global_load_dwordx4 v[40:43], v[0:1], off offset:96
; GCN-NEXT:    global_load_dwordx4 v[60:63], v[0:1], off offset:112
; GCN-NEXT:    global_load_dwordx4 v[36:39], v[0:1], off offset:128
; GCN-NEXT:    global_load_dwordx4 v[32:35], v[0:1], off offset:144
; GCN-NEXT:    global_load_dwordx4 v[28:31], v[0:1], off offset:160
; GCN-NEXT:    global_load_dwordx4 v[52:55], v[0:1], off offset:176
; GCN-NEXT:    global_load_dwordx4 v[24:27], v[0:1], off offset:192
; GCN-NEXT:    global_load_dwordx4 v[7:10], v[0:1], off offset:208
; GCN-NEXT:    s_add_i32 s32, s32, 0x10000
; GCN-NEXT:    s_add_i32 s32, s32, 0xffff0000
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:512 ; 4-byte Folded Spill
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:516 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:520 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v6, off, s[0:3], s33 offset:524 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v7, off, s[0:3], s33 offset:528 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:532 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:536 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:540 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:544 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:548 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:552 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:556 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:560 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:564 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:568 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:572 ; 4-byte Folded Spill
; GCN-NEXT:    global_load_dwordx4 v[8:11], v[0:1], off offset:224
; GCN-NEXT:    global_load_dwordx4 v[12:15], v[0:1], off offset:240
; GCN-NEXT:    v_lshrrev_b32_e64 v1, 6, s33
; GCN-NEXT:    v_add_u32_e32 v1, 0x100, v1
; GCN-NEXT:    buffer_store_dword v2, off, s[0:3], s33 offset:256
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:260
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:264
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:268
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:272
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:276
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:280
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:284
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:288
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:292
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:296
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:300
; GCN-NEXT:    buffer_store_dword v48, off, s[0:3], s33 offset:304
; GCN-NEXT:    buffer_store_dword v49, off, s[0:3], s33 offset:308
; GCN-NEXT:    buffer_store_dword v50, off, s[0:3], s33 offset:312
; GCN-NEXT:    buffer_store_dword v51, off, s[0:3], s33 offset:316
; GCN-NEXT:    buffer_store_dword v20, off, s[0:3], s33 offset:320
; GCN-NEXT:    buffer_store_dword v21, off, s[0:3], s33 offset:324
; GCN-NEXT:    buffer_store_dword v22, off, s[0:3], s33 offset:328
; GCN-NEXT:    buffer_store_dword v23, off, s[0:3], s33 offset:332
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:336
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:340
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:344
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:348
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:352
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:356
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:360
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:364
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:368
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:372
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:376
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 offset:380
; GCN-NEXT:    buffer_store_dword v36, off, s[0:3], s33 offset:384
; GCN-NEXT:    buffer_store_dword v37, off, s[0:3], s33 offset:388
; GCN-NEXT:    buffer_store_dword v38, off, s[0:3], s33 offset:392
; GCN-NEXT:    buffer_store_dword v39, off, s[0:3], s33 offset:396
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s33 offset:400
; GCN-NEXT:    buffer_store_dword v33, off, s[0:3], s33 offset:404
; GCN-NEXT:    buffer_store_dword v34, off, s[0:3], s33 offset:408
; GCN-NEXT:    buffer_store_dword v35, off, s[0:3], s33 offset:412
; GCN-NEXT:    buffer_store_dword v28, off, s[0:3], s33 offset:416
; GCN-NEXT:    buffer_store_dword v29, off, s[0:3], s33 offset:420
; GCN-NEXT:    buffer_store_dword v30, off, s[0:3], s33 offset:424
; GCN-NEXT:    buffer_store_dword v31, off, s[0:3], s33 offset:428
; GCN-NEXT:    buffer_store_dword v52, off, s[0:3], s33 offset:432
; GCN-NEXT:    buffer_store_dword v53, off, s[0:3], s33 offset:436
; GCN-NEXT:    buffer_store_dword v54, off, s[0:3], s33 offset:440
; GCN-NEXT:    buffer_store_dword v55, off, s[0:3], s33 offset:444
; GCN-NEXT:    buffer_store_dword v24, off, s[0:3], s33 offset:448
; GCN-NEXT:    buffer_store_dword v25, off, s[0:3], s33 offset:452
; GCN-NEXT:    buffer_store_dword v26, off, s[0:3], s33 offset:456
; GCN-NEXT:    buffer_store_dword v27, off, s[0:3], s33 offset:460
; GCN-NEXT:    buffer_load_dword v16, off, s[0:3], s33 offset:512 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v17, off, s[0:3], s33 offset:516 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v18, off, s[0:3], s33 offset:520 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v19, off, s[0:3], s33 offset:524 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v20, off, s[0:3], s33 offset:528 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v21, off, s[0:3], s33 offset:532 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v22, off, s[0:3], s33 offset:536 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v23, off, s[0:3], s33 offset:540 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v24, off, s[0:3], s33 offset:544 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v25, off, s[0:3], s33 offset:548 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v26, off, s[0:3], s33 offset:552 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v27, off, s[0:3], s33 offset:556 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v28, off, s[0:3], s33 offset:560 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v29, off, s[0:3], s33 offset:564 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v30, off, s[0:3], s33 offset:568 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v31, off, s[0:3], s33 offset:572 ; 4-byte Folded Reload
; GCN-NEXT:    v_and_b32_e32 v0, 63, v6
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GCN-NEXT:    v_add_u32_e32 v0, v1, v0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v16, v20
; GCN-NEXT:    v_mov_b32_e32 v17, v21
; GCN-NEXT:    v_mov_b32_e32 v18, v22
; GCN-NEXT:    v_mov_b32_e32 v19, v23
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:464
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:468
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:472
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:476
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:480
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:484
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:488
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:492
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:496
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:500
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:504
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:508
; GCN-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v63, off, s[0:3], s33 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b32 s33, s4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %vec = load <64 x i32>, ptr addrspace(1) %ptr
  %elt = extractelement <64 x i32> %vec, i32 %idx
  ret i32 %elt
}

define i16 @v_extract_v128i16_varidx(ptr addrspace(1) %ptr, i32 %idx) {
; GCN-LABEL: v_extract_v128i16_varidx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s4, s33
; GCN-NEXT:    s_add_i32 s33, s32, 0x3fc0
; GCN-NEXT:    s_and_b32 s33, s33, 0xffffc000
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 ; 4-byte Folded Spill
; GCN-NEXT:    v_mov_b32_e32 v6, v2
; GCN-NEXT:    global_load_dwordx4 v[2:5], v[0:1], off
; GCN-NEXT:    global_load_dwordx4 v[16:19], v[0:1], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[56:59], v[0:1], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[48:51], v[0:1], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[20:23], v[0:1], off offset:64
; GCN-NEXT:    global_load_dwordx4 v[44:47], v[0:1], off offset:80
; GCN-NEXT:    global_load_dwordx4 v[40:43], v[0:1], off offset:96
; GCN-NEXT:    global_load_dwordx4 v[60:63], v[0:1], off offset:112
; GCN-NEXT:    global_load_dwordx4 v[36:39], v[0:1], off offset:128
; GCN-NEXT:    global_load_dwordx4 v[32:35], v[0:1], off offset:144
; GCN-NEXT:    global_load_dwordx4 v[28:31], v[0:1], off offset:160
; GCN-NEXT:    global_load_dwordx4 v[52:55], v[0:1], off offset:176
; GCN-NEXT:    global_load_dwordx4 v[24:27], v[0:1], off offset:192
; GCN-NEXT:    global_load_dwordx4 v[7:10], v[0:1], off offset:208
; GCN-NEXT:    s_add_i32 s32, s32, 0x10000
; GCN-NEXT:    s_add_i32 s32, s32, 0xffff0000
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:512 ; 4-byte Folded Spill
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:516 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:520 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v6, off, s[0:3], s33 offset:524 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v7, off, s[0:3], s33 offset:528 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:532 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:536 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:540 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:544 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:548 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:552 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:556 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:560 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:564 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:568 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:572 ; 4-byte Folded Spill
; GCN-NEXT:    global_load_dwordx4 v[8:11], v[0:1], off offset:224
; GCN-NEXT:    global_load_dwordx4 v[12:15], v[0:1], off offset:240
; GCN-NEXT:    v_lshrrev_b32_e64 v1, 6, s33
; GCN-NEXT:    v_add_u32_e32 v1, 0x100, v1
; GCN-NEXT:    buffer_store_dword v2, off, s[0:3], s33 offset:256
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:260
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:264
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:268
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:272
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:276
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:280
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:284
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:288
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:292
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:296
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:300
; GCN-NEXT:    buffer_store_dword v48, off, s[0:3], s33 offset:304
; GCN-NEXT:    buffer_store_dword v49, off, s[0:3], s33 offset:308
; GCN-NEXT:    buffer_store_dword v50, off, s[0:3], s33 offset:312
; GCN-NEXT:    buffer_store_dword v51, off, s[0:3], s33 offset:316
; GCN-NEXT:    buffer_store_dword v20, off, s[0:3], s33 offset:320
; GCN-NEXT:    buffer_store_dword v21, off, s[0:3], s33 offset:324
; GCN-NEXT:    buffer_store_dword v22, off, s[0:3], s33 offset:328
; GCN-NEXT:    buffer_store_dword v23, off, s[0:3], s33 offset:332
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:336
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:340
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:344
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:348
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:352
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:356
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:360
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:364
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:368
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:372
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:376
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 offset:380
; GCN-NEXT:    buffer_store_dword v36, off, s[0:3], s33 offset:384
; GCN-NEXT:    buffer_store_dword v37, off, s[0:3], s33 offset:388
; GCN-NEXT:    buffer_store_dword v38, off, s[0:3], s33 offset:392
; GCN-NEXT:    buffer_store_dword v39, off, s[0:3], s33 offset:396
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s33 offset:400
; GCN-NEXT:    buffer_store_dword v33, off, s[0:3], s33 offset:404
; GCN-NEXT:    buffer_store_dword v34, off, s[0:3], s33 offset:408
; GCN-NEXT:    buffer_store_dword v35, off, s[0:3], s33 offset:412
; GCN-NEXT:    buffer_store_dword v28, off, s[0:3], s33 offset:416
; GCN-NEXT:    buffer_store_dword v29, off, s[0:3], s33 offset:420
; GCN-NEXT:    buffer_store_dword v30, off, s[0:3], s33 offset:424
; GCN-NEXT:    buffer_store_dword v31, off, s[0:3], s33 offset:428
; GCN-NEXT:    buffer_store_dword v52, off, s[0:3], s33 offset:432
; GCN-NEXT:    buffer_store_dword v53, off, s[0:3], s33 offset:436
; GCN-NEXT:    buffer_store_dword v54, off, s[0:3], s33 offset:440
; GCN-NEXT:    buffer_store_dword v55, off, s[0:3], s33 offset:444
; GCN-NEXT:    buffer_store_dword v24, off, s[0:3], s33 offset:448
; GCN-NEXT:    buffer_store_dword v25, off, s[0:3], s33 offset:452
; GCN-NEXT:    buffer_store_dword v26, off, s[0:3], s33 offset:456
; GCN-NEXT:    buffer_store_dword v27, off, s[0:3], s33 offset:460
; GCN-NEXT:    buffer_load_dword v16, off, s[0:3], s33 offset:512 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v17, off, s[0:3], s33 offset:516 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v18, off, s[0:3], s33 offset:520 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v19, off, s[0:3], s33 offset:524 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v20, off, s[0:3], s33 offset:528 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v21, off, s[0:3], s33 offset:532 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v22, off, s[0:3], s33 offset:536 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v23, off, s[0:3], s33 offset:540 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v24, off, s[0:3], s33 offset:544 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v25, off, s[0:3], s33 offset:548 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v26, off, s[0:3], s33 offset:552 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v27, off, s[0:3], s33 offset:556 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v28, off, s[0:3], s33 offset:560 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v29, off, s[0:3], s33 offset:564 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v30, off, s[0:3], s33 offset:568 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v31, off, s[0:3], s33 offset:572 ; 4-byte Folded Reload
; GCN-NEXT:    v_bfe_u32 v0, v6, 1, 6
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GCN-NEXT:    v_add_u32_e32 v0, v1, v0
; GCN-NEXT:    v_and_b32_e32 v1, 1, v6
; GCN-NEXT:    v_lshlrev_b32_e32 v1, 4, v1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v16, v20
; GCN-NEXT:    v_mov_b32_e32 v17, v21
; GCN-NEXT:    v_mov_b32_e32 v18, v22
; GCN-NEXT:    v_mov_b32_e32 v19, v23
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:464
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:468
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:472
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:476
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:480
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:484
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:488
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:492
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:496
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:500
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:504
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:508
; GCN-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v63, off, s[0:3], s33 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b32 s33, s4
; GCN-NEXT:    s_waitcnt vmcnt(16)
; GCN-NEXT:    v_lshrrev_b32_e32 v0, v1, v0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %vec = load <128 x i16>, ptr addrspace(1) %ptr
  %elt = extractelement <128 x i16> %vec, i32 %idx
  ret i16 %elt
}

define i64 @v_extract_v32i64_varidx(ptr addrspace(1) %ptr, i32 %idx) {
; GCN-LABEL: v_extract_v32i64_varidx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s4, s33
; GCN-NEXT:    s_add_i32 s33, s32, 0x3fc0
; GCN-NEXT:    s_and_b32 s33, s33, 0xffffc000
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 ; 4-byte Folded Spill
; GCN-NEXT:    v_mov_b32_e32 v6, v2
; GCN-NEXT:    global_load_dwordx4 v[2:5], v[0:1], off
; GCN-NEXT:    global_load_dwordx4 v[16:19], v[0:1], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[56:59], v[0:1], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[48:51], v[0:1], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[20:23], v[0:1], off offset:64
; GCN-NEXT:    global_load_dwordx4 v[44:47], v[0:1], off offset:80
; GCN-NEXT:    global_load_dwordx4 v[40:43], v[0:1], off offset:96
; GCN-NEXT:    global_load_dwordx4 v[60:63], v[0:1], off offset:112
; GCN-NEXT:    global_load_dwordx4 v[36:39], v[0:1], off offset:128
; GCN-NEXT:    global_load_dwordx4 v[32:35], v[0:1], off offset:144
; GCN-NEXT:    global_load_dwordx4 v[28:31], v[0:1], off offset:160
; GCN-NEXT:    global_load_dwordx4 v[52:55], v[0:1], off offset:176
; GCN-NEXT:    global_load_dwordx4 v[24:27], v[0:1], off offset:192
; GCN-NEXT:    global_load_dwordx4 v[7:10], v[0:1], off offset:208
; GCN-NEXT:    s_add_i32 s32, s32, 0x10000
; GCN-NEXT:    s_add_i32 s32, s32, 0xffff0000
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:512 ; 4-byte Folded Spill
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:516 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:520 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v6, off, s[0:3], s33 offset:524 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v7, off, s[0:3], s33 offset:528 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:532 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:536 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:540 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:544 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:548 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:552 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:556 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:560 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:564 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:568 ; 4-byte Folded Spill
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:572 ; 4-byte Folded Spill
; GCN-NEXT:    global_load_dwordx4 v[8:11], v[0:1], off offset:224
; GCN-NEXT:    global_load_dwordx4 v[12:15], v[0:1], off offset:240
; GCN-NEXT:    buffer_store_dword v2, off, s[0:3], s33 offset:256
; GCN-NEXT:    buffer_store_dword v3, off, s[0:3], s33 offset:260
; GCN-NEXT:    buffer_store_dword v4, off, s[0:3], s33 offset:264
; GCN-NEXT:    buffer_store_dword v5, off, s[0:3], s33 offset:268
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:272
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:276
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:280
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:284
; GCN-NEXT:    buffer_store_dword v56, off, s[0:3], s33 offset:288
; GCN-NEXT:    buffer_store_dword v57, off, s[0:3], s33 offset:292
; GCN-NEXT:    buffer_store_dword v58, off, s[0:3], s33 offset:296
; GCN-NEXT:    buffer_store_dword v59, off, s[0:3], s33 offset:300
; GCN-NEXT:    buffer_store_dword v48, off, s[0:3], s33 offset:304
; GCN-NEXT:    buffer_store_dword v49, off, s[0:3], s33 offset:308
; GCN-NEXT:    buffer_store_dword v50, off, s[0:3], s33 offset:312
; GCN-NEXT:    buffer_store_dword v51, off, s[0:3], s33 offset:316
; GCN-NEXT:    buffer_store_dword v20, off, s[0:3], s33 offset:320
; GCN-NEXT:    buffer_store_dword v21, off, s[0:3], s33 offset:324
; GCN-NEXT:    buffer_store_dword v22, off, s[0:3], s33 offset:328
; GCN-NEXT:    buffer_store_dword v23, off, s[0:3], s33 offset:332
; GCN-NEXT:    buffer_store_dword v44, off, s[0:3], s33 offset:336
; GCN-NEXT:    buffer_store_dword v45, off, s[0:3], s33 offset:340
; GCN-NEXT:    buffer_store_dword v46, off, s[0:3], s33 offset:344
; GCN-NEXT:    buffer_store_dword v47, off, s[0:3], s33 offset:348
; GCN-NEXT:    buffer_store_dword v40, off, s[0:3], s33 offset:352
; GCN-NEXT:    buffer_store_dword v41, off, s[0:3], s33 offset:356
; GCN-NEXT:    buffer_store_dword v42, off, s[0:3], s33 offset:360
; GCN-NEXT:    buffer_store_dword v43, off, s[0:3], s33 offset:364
; GCN-NEXT:    buffer_store_dword v60, off, s[0:3], s33 offset:368
; GCN-NEXT:    buffer_store_dword v61, off, s[0:3], s33 offset:372
; GCN-NEXT:    buffer_store_dword v62, off, s[0:3], s33 offset:376
; GCN-NEXT:    buffer_store_dword v63, off, s[0:3], s33 offset:380
; GCN-NEXT:    buffer_store_dword v36, off, s[0:3], s33 offset:384
; GCN-NEXT:    buffer_store_dword v37, off, s[0:3], s33 offset:388
; GCN-NEXT:    buffer_store_dword v38, off, s[0:3], s33 offset:392
; GCN-NEXT:    buffer_store_dword v39, off, s[0:3], s33 offset:396
; GCN-NEXT:    buffer_store_dword v32, off, s[0:3], s33 offset:400
; GCN-NEXT:    buffer_store_dword v33, off, s[0:3], s33 offset:404
; GCN-NEXT:    buffer_store_dword v34, off, s[0:3], s33 offset:408
; GCN-NEXT:    buffer_store_dword v35, off, s[0:3], s33 offset:412
; GCN-NEXT:    buffer_store_dword v28, off, s[0:3], s33 offset:416
; GCN-NEXT:    buffer_store_dword v29, off, s[0:3], s33 offset:420
; GCN-NEXT:    buffer_store_dword v30, off, s[0:3], s33 offset:424
; GCN-NEXT:    buffer_store_dword v31, off, s[0:3], s33 offset:428
; GCN-NEXT:    buffer_store_dword v52, off, s[0:3], s33 offset:432
; GCN-NEXT:    buffer_store_dword v53, off, s[0:3], s33 offset:436
; GCN-NEXT:    buffer_store_dword v54, off, s[0:3], s33 offset:440
; GCN-NEXT:    buffer_store_dword v55, off, s[0:3], s33 offset:444
; GCN-NEXT:    buffer_store_dword v24, off, s[0:3], s33 offset:448
; GCN-NEXT:    buffer_store_dword v25, off, s[0:3], s33 offset:452
; GCN-NEXT:    buffer_store_dword v26, off, s[0:3], s33 offset:456
; GCN-NEXT:    buffer_store_dword v27, off, s[0:3], s33 offset:460
; GCN-NEXT:    buffer_load_dword v16, off, s[0:3], s33 offset:512 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v17, off, s[0:3], s33 offset:516 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v18, off, s[0:3], s33 offset:520 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v19, off, s[0:3], s33 offset:524 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v20, off, s[0:3], s33 offset:528 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v21, off, s[0:3], s33 offset:532 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v22, off, s[0:3], s33 offset:536 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v23, off, s[0:3], s33 offset:540 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v24, off, s[0:3], s33 offset:544 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v25, off, s[0:3], s33 offset:548 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v26, off, s[0:3], s33 offset:552 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v27, off, s[0:3], s33 offset:556 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v28, off, s[0:3], s33 offset:560 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v29, off, s[0:3], s33 offset:564 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v30, off, s[0:3], s33 offset:568 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v31, off, s[0:3], s33 offset:572 ; 4-byte Folded Reload
; GCN-NEXT:    v_and_b32_e32 v0, 31, v6
; GCN-NEXT:    v_lshrrev_b32_e64 v2, 6, s33
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GCN-NEXT:    v_add_u32_e32 v2, 0x100, v2
; GCN-NEXT:    v_add_u32_e32 v1, v2, v0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v16, v20
; GCN-NEXT:    v_mov_b32_e32 v17, v21
; GCN-NEXT:    v_mov_b32_e32 v18, v22
; GCN-NEXT:    v_mov_b32_e32 v19, v23
; GCN-NEXT:    buffer_store_dword v16, off, s[0:3], s33 offset:464
; GCN-NEXT:    buffer_store_dword v17, off, s[0:3], s33 offset:468
; GCN-NEXT:    buffer_store_dword v18, off, s[0:3], s33 offset:472
; GCN-NEXT:    buffer_store_dword v19, off, s[0:3], s33 offset:476
; GCN-NEXT:    buffer_store_dword v8, off, s[0:3], s33 offset:480
; GCN-NEXT:    buffer_store_dword v9, off, s[0:3], s33 offset:484
; GCN-NEXT:    buffer_store_dword v10, off, s[0:3], s33 offset:488
; GCN-NEXT:    buffer_store_dword v11, off, s[0:3], s33 offset:492
; GCN-NEXT:    buffer_store_dword v12, off, s[0:3], s33 offset:496
; GCN-NEXT:    buffer_store_dword v13, off, s[0:3], s33 offset:500
; GCN-NEXT:    buffer_store_dword v14, off, s[0:3], s33 offset:504
; GCN-NEXT:    buffer_store_dword v15, off, s[0:3], s33 offset:508
; GCN-NEXT:    buffer_load_dword v0, v1, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v1, v1, s[0:3], 0 offen offset:4
; GCN-NEXT:    buffer_load_dword v63, off, s[0:3], s33 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v62, off, s[0:3], s33 offset:4 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v61, off, s[0:3], s33 offset:8 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v60, off, s[0:3], s33 offset:12 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v59, off, s[0:3], s33 offset:16 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v58, off, s[0:3], s33 offset:20 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v57, off, s[0:3], s33 offset:24 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v56, off, s[0:3], s33 offset:28 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v47, off, s[0:3], s33 offset:32 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v46, off, s[0:3], s33 offset:36 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v45, off, s[0:3], s33 offset:40 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v44, off, s[0:3], s33 offset:44 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v43, off, s[0:3], s33 offset:48 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v42, off, s[0:3], s33 offset:52 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v41, off, s[0:3], s33 offset:56 ; 4-byte Folded Reload
; GCN-NEXT:    buffer_load_dword v40, off, s[0:3], s33 offset:60 ; 4-byte Folded Reload
; GCN-NEXT:    s_mov_b32 s33, s4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %vec = load <32 x i64>, ptr addrspace(1) %ptr
  %elt = extractelement <32 x i64> %vec, i32 %idx
  ret i64 %elt
}
