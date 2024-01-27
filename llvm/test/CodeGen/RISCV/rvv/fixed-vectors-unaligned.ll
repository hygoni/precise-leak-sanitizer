; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=SLOW,RV32-SLOW
; RUN: llc -mtriple=riscv64 -mattr=+m,+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=SLOW,RV64-SLOW
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+unaligned-vector-mem -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=FAST,RV32-FAST
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+unaligned-vector-mem -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=FAST,RV64-FAST

define <4 x i32> @load_v4i32_align1(ptr %ptr) {
; SLOW-LABEL: load_v4i32_align1:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; SLOW-NEXT:    vle8.v v8, (a0)
; SLOW-NEXT:    ret
;
; FAST-LABEL: load_v4i32_align1:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; FAST-NEXT:    vle32.v v8, (a0)
; FAST-NEXT:    ret
  %z = load <4 x i32>, ptr %ptr, align 1
  ret <4 x i32> %z
}

define <4 x i32> @load_v4i32_align2(ptr %ptr) {
; SLOW-LABEL: load_v4i32_align2:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; SLOW-NEXT:    vle8.v v8, (a0)
; SLOW-NEXT:    ret
;
; FAST-LABEL: load_v4i32_align2:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; FAST-NEXT:    vle32.v v8, (a0)
; FAST-NEXT:    ret
  %z = load <4 x i32>, ptr %ptr, align 2
  ret <4 x i32> %z
}

define void @store_v4i32_align1(<4 x i32> %x, ptr %ptr) {
; SLOW-LABEL: store_v4i32_align1:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; SLOW-NEXT:    vse8.v v8, (a0)
; SLOW-NEXT:    ret
;
; FAST-LABEL: store_v4i32_align1:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; FAST-NEXT:    vse32.v v8, (a0)
; FAST-NEXT:    ret
  store <4 x i32> %x, ptr %ptr, align 1
  ret void
}

define void @store_v4i32_align2(<4 x i32> %x, ptr %ptr) {
; SLOW-LABEL: store_v4i32_align2:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; SLOW-NEXT:    vse8.v v8, (a0)
; SLOW-NEXT:    ret
;
; FAST-LABEL: store_v4i32_align2:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 4, e32, m1, ta, ma
; FAST-NEXT:    vse32.v v8, (a0)
; FAST-NEXT:    ret
  store <4 x i32> %x, ptr %ptr, align 2
  ret void
}

declare <2 x i16> @llvm.masked.gather.v2i16.v2p0(<2 x ptr>, i32, <2 x i1>, <2 x i16>)

define <2 x i16> @mgather_v2i16_align1(<2 x ptr> %ptrs, <2 x i1> %m, <2 x i16> %passthru) {
; RV32-SLOW-LABEL: mgather_v2i16_align1:
; RV32-SLOW:       # %bb.0:
; RV32-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a0, v0
; RV32-SLOW-NEXT:    andi a1, a0, 1
; RV32-SLOW-NEXT:    bnez a1, .LBB4_3
; RV32-SLOW-NEXT:  # %bb.1: # %else
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    bnez a0, .LBB4_4
; RV32-SLOW-NEXT:  .LBB4_2: # %else2
; RV32-SLOW-NEXT:    vmv1r.v v8, v9
; RV32-SLOW-NEXT:    ret
; RV32-SLOW-NEXT:  .LBB4_3: # %cond.load
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    lbu a2, 1(a1)
; RV32-SLOW-NEXT:    lbu a1, 0(a1)
; RV32-SLOW-NEXT:    slli a2, a2, 8
; RV32-SLOW-NEXT:    or a1, a2, a1
; RV32-SLOW-NEXT:    vsetivli zero, 2, e16, mf4, tu, ma
; RV32-SLOW-NEXT:    vmv.s.x v9, a1
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    beqz a0, .LBB4_2
; RV32-SLOW-NEXT:  .LBB4_4: # %cond.load1
; RV32-SLOW-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV32-SLOW-NEXT:    vmv.x.s a0, v8
; RV32-SLOW-NEXT:    lbu a1, 1(a0)
; RV32-SLOW-NEXT:    lbu a0, 0(a0)
; RV32-SLOW-NEXT:    slli a1, a1, 8
; RV32-SLOW-NEXT:    or a0, a1, a0
; RV32-SLOW-NEXT:    vmv.s.x v8, a0
; RV32-SLOW-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; RV32-SLOW-NEXT:    vslideup.vi v9, v8, 1
; RV32-SLOW-NEXT:    vmv1r.v v8, v9
; RV32-SLOW-NEXT:    ret
;
; RV64-SLOW-LABEL: mgather_v2i16_align1:
; RV64-SLOW:       # %bb.0:
; RV64-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a0, v0
; RV64-SLOW-NEXT:    andi a1, a0, 1
; RV64-SLOW-NEXT:    bnez a1, .LBB4_3
; RV64-SLOW-NEXT:  # %bb.1: # %else
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    bnez a0, .LBB4_4
; RV64-SLOW-NEXT:  .LBB4_2: # %else2
; RV64-SLOW-NEXT:    vmv1r.v v8, v9
; RV64-SLOW-NEXT:    ret
; RV64-SLOW-NEXT:  .LBB4_3: # %cond.load
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    lbu a2, 1(a1)
; RV64-SLOW-NEXT:    lbu a1, 0(a1)
; RV64-SLOW-NEXT:    slli a2, a2, 8
; RV64-SLOW-NEXT:    or a1, a2, a1
; RV64-SLOW-NEXT:    vsetivli zero, 2, e16, mf4, tu, ma
; RV64-SLOW-NEXT:    vmv.s.x v9, a1
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    beqz a0, .LBB4_2
; RV64-SLOW-NEXT:  .LBB4_4: # %cond.load1
; RV64-SLOW-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV64-SLOW-NEXT:    vmv.x.s a0, v8
; RV64-SLOW-NEXT:    lbu a1, 1(a0)
; RV64-SLOW-NEXT:    lbu a0, 0(a0)
; RV64-SLOW-NEXT:    slli a1, a1, 8
; RV64-SLOW-NEXT:    or a0, a1, a0
; RV64-SLOW-NEXT:    vmv.s.x v8, a0
; RV64-SLOW-NEXT:    vsetivli zero, 2, e16, mf4, ta, ma
; RV64-SLOW-NEXT:    vslideup.vi v9, v8, 1
; RV64-SLOW-NEXT:    vmv1r.v v8, v9
; RV64-SLOW-NEXT:    ret
;
; RV32-FAST-LABEL: mgather_v2i16_align1:
; RV32-FAST:       # %bb.0:
; RV32-FAST-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV32-FAST-NEXT:    vluxei32.v v9, (zero), v8, v0.t
; RV32-FAST-NEXT:    vmv1r.v v8, v9
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: mgather_v2i16_align1:
; RV64-FAST:       # %bb.0:
; RV64-FAST-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV64-FAST-NEXT:    vluxei64.v v9, (zero), v8, v0.t
; RV64-FAST-NEXT:    vmv1r.v v8, v9
; RV64-FAST-NEXT:    ret
  %v = call <2 x i16> @llvm.masked.gather.v2i16.v2p0(<2 x ptr> %ptrs, i32 1, <2 x i1> %m, <2 x i16> %passthru)
  ret <2 x i16> %v
}

declare <2 x i64> @llvm.masked.gather.v2i64.v2p0(<2 x ptr>, i32, <2 x i1>, <2 x i64>)

define <2 x i64> @mgather_v2i64_align4(<2 x ptr> %ptrs, <2 x i1> %m, <2 x i64> %passthru) {
; RV32-SLOW-LABEL: mgather_v2i64_align4:
; RV32-SLOW:       # %bb.0:
; RV32-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a0, v0
; RV32-SLOW-NEXT:    andi a1, a0, 1
; RV32-SLOW-NEXT:    bnez a1, .LBB5_3
; RV32-SLOW-NEXT:  # %bb.1: # %else
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    bnez a0, .LBB5_4
; RV32-SLOW-NEXT:  .LBB5_2: # %else2
; RV32-SLOW-NEXT:    vmv1r.v v8, v9
; RV32-SLOW-NEXT:    ret
; RV32-SLOW-NEXT:  .LBB5_3: # %cond.load
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    lw a2, 0(a1)
; RV32-SLOW-NEXT:    lw a1, 4(a1)
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, m1, tu, ma
; RV32-SLOW-NEXT:    vslide1down.vx v9, v9, a2
; RV32-SLOW-NEXT:    vslide1down.vx v9, v9, a1
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    beqz a0, .LBB5_2
; RV32-SLOW-NEXT:  .LBB5_4: # %cond.load1
; RV32-SLOW-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV32-SLOW-NEXT:    vmv.x.s a0, v8
; RV32-SLOW-NEXT:    lw a1, 0(a0)
; RV32-SLOW-NEXT:    lw a0, 4(a0)
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, m1, ta, ma
; RV32-SLOW-NEXT:    vslide1down.vx v8, v8, a1
; RV32-SLOW-NEXT:    vslide1down.vx v8, v8, a0
; RV32-SLOW-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV32-SLOW-NEXT:    vslideup.vi v9, v8, 1
; RV32-SLOW-NEXT:    vmv1r.v v8, v9
; RV32-SLOW-NEXT:    ret
;
; RV64-SLOW-LABEL: mgather_v2i64_align4:
; RV64-SLOW:       # %bb.0:
; RV64-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a0, v0
; RV64-SLOW-NEXT:    andi a1, a0, 1
; RV64-SLOW-NEXT:    bnez a1, .LBB5_3
; RV64-SLOW-NEXT:  # %bb.1: # %else
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    bnez a0, .LBB5_4
; RV64-SLOW-NEXT:  .LBB5_2: # %else2
; RV64-SLOW-NEXT:    vmv1r.v v8, v9
; RV64-SLOW-NEXT:    ret
; RV64-SLOW-NEXT:  .LBB5_3: # %cond.load
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    lwu a2, 4(a1)
; RV64-SLOW-NEXT:    lwu a1, 0(a1)
; RV64-SLOW-NEXT:    slli a2, a2, 32
; RV64-SLOW-NEXT:    or a1, a2, a1
; RV64-SLOW-NEXT:    vsetivli zero, 2, e64, m1, tu, ma
; RV64-SLOW-NEXT:    vmv.s.x v9, a1
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    beqz a0, .LBB5_2
; RV64-SLOW-NEXT:  .LBB5_4: # %cond.load1
; RV64-SLOW-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV64-SLOW-NEXT:    vmv.x.s a0, v8
; RV64-SLOW-NEXT:    lwu a1, 4(a0)
; RV64-SLOW-NEXT:    lwu a0, 0(a0)
; RV64-SLOW-NEXT:    slli a1, a1, 32
; RV64-SLOW-NEXT:    or a0, a1, a0
; RV64-SLOW-NEXT:    vmv.s.x v8, a0
; RV64-SLOW-NEXT:    vsetivli zero, 2, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vslideup.vi v9, v8, 1
; RV64-SLOW-NEXT:    vmv1r.v v8, v9
; RV64-SLOW-NEXT:    ret
;
; RV32-FAST-LABEL: mgather_v2i64_align4:
; RV32-FAST:       # %bb.0:
; RV32-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; RV32-FAST-NEXT:    vluxei32.v v9, (zero), v8, v0.t
; RV32-FAST-NEXT:    vmv.v.v v8, v9
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: mgather_v2i64_align4:
; RV64-FAST:       # %bb.0:
; RV64-FAST-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; RV64-FAST-NEXT:    vluxei64.v v9, (zero), v8, v0.t
; RV64-FAST-NEXT:    vmv.v.v v8, v9
; RV64-FAST-NEXT:    ret
  %v = call <2 x i64> @llvm.masked.gather.v2i64.v2p0(<2 x ptr> %ptrs, i32 4, <2 x i1> %m, <2 x i64> %passthru)
  ret <2 x i64> %v
}

declare void @llvm.masked.scatter.v4i16.v4p0(<4 x i16>, <4 x ptr>, i32, <4 x i1>)

define void @mscatter_v4i16_align1(<4 x i16> %val, <4 x ptr> %ptrs, <4 x i1> %m) {
; RV32-SLOW-LABEL: mscatter_v4i16_align1:
; RV32-SLOW:       # %bb.0:
; RV32-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a0, v0
; RV32-SLOW-NEXT:    andi a1, a0, 1
; RV32-SLOW-NEXT:    bnez a1, .LBB6_5
; RV32-SLOW-NEXT:  # %bb.1: # %else
; RV32-SLOW-NEXT:    andi a1, a0, 2
; RV32-SLOW-NEXT:    bnez a1, .LBB6_6
; RV32-SLOW-NEXT:  .LBB6_2: # %else2
; RV32-SLOW-NEXT:    andi a1, a0, 4
; RV32-SLOW-NEXT:    bnez a1, .LBB6_7
; RV32-SLOW-NEXT:  .LBB6_3: # %else4
; RV32-SLOW-NEXT:    andi a0, a0, 8
; RV32-SLOW-NEXT:    bnez a0, .LBB6_8
; RV32-SLOW-NEXT:  .LBB6_4: # %else6
; RV32-SLOW-NEXT:    ret
; RV32-SLOW-NEXT:  .LBB6_5: # %cond.store
; RV32-SLOW-NEXT:    vsetivli zero, 0, e16, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a2, v9
; RV32-SLOW-NEXT:    sb a1, 0(a2)
; RV32-SLOW-NEXT:    srli a1, a1, 8
; RV32-SLOW-NEXT:    sb a1, 1(a2)
; RV32-SLOW-NEXT:    andi a1, a0, 2
; RV32-SLOW-NEXT:    beqz a1, .LBB6_2
; RV32-SLOW-NEXT:  .LBB6_6: # %cond.store1
; RV32-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v10, v8, 1
; RV32-SLOW-NEXT:    vmv.x.s a1, v10
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v10, v9, 1
; RV32-SLOW-NEXT:    vmv.x.s a2, v10
; RV32-SLOW-NEXT:    sb a1, 0(a2)
; RV32-SLOW-NEXT:    srli a1, a1, 8
; RV32-SLOW-NEXT:    sb a1, 1(a2)
; RV32-SLOW-NEXT:    andi a1, a0, 4
; RV32-SLOW-NEXT:    beqz a1, .LBB6_3
; RV32-SLOW-NEXT:  .LBB6_7: # %cond.store3
; RV32-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v10, v8, 2
; RV32-SLOW-NEXT:    vmv.x.s a1, v10
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v10, v9, 2
; RV32-SLOW-NEXT:    vmv.x.s a2, v10
; RV32-SLOW-NEXT:    sb a1, 0(a2)
; RV32-SLOW-NEXT:    srli a1, a1, 8
; RV32-SLOW-NEXT:    sb a1, 1(a2)
; RV32-SLOW-NEXT:    andi a0, a0, 8
; RV32-SLOW-NEXT:    beqz a0, .LBB6_4
; RV32-SLOW-NEXT:  .LBB6_8: # %cond.store5
; RV32-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v8, v8, 3
; RV32-SLOW-NEXT:    vmv.x.s a0, v8
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, m1, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v8, v9, 3
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    sb a0, 0(a1)
; RV32-SLOW-NEXT:    srli a0, a0, 8
; RV32-SLOW-NEXT:    sb a0, 1(a1)
; RV32-SLOW-NEXT:    ret
;
; RV64-SLOW-LABEL: mscatter_v4i16_align1:
; RV64-SLOW:       # %bb.0:
; RV64-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a0, v0
; RV64-SLOW-NEXT:    andi a1, a0, 1
; RV64-SLOW-NEXT:    bnez a1, .LBB6_5
; RV64-SLOW-NEXT:  # %bb.1: # %else
; RV64-SLOW-NEXT:    andi a1, a0, 2
; RV64-SLOW-NEXT:    bnez a1, .LBB6_6
; RV64-SLOW-NEXT:  .LBB6_2: # %else2
; RV64-SLOW-NEXT:    andi a1, a0, 4
; RV64-SLOW-NEXT:    bnez a1, .LBB6_7
; RV64-SLOW-NEXT:  .LBB6_3: # %else4
; RV64-SLOW-NEXT:    andi a0, a0, 8
; RV64-SLOW-NEXT:    bnez a0, .LBB6_8
; RV64-SLOW-NEXT:  .LBB6_4: # %else6
; RV64-SLOW-NEXT:    ret
; RV64-SLOW-NEXT:  .LBB6_5: # %cond.store
; RV64-SLOW-NEXT:    vsetivli zero, 0, e16, mf2, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a2, v10
; RV64-SLOW-NEXT:    sb a1, 0(a2)
; RV64-SLOW-NEXT:    srli a1, a1, 8
; RV64-SLOW-NEXT:    sb a1, 1(a2)
; RV64-SLOW-NEXT:    andi a1, a0, 2
; RV64-SLOW-NEXT:    beqz a1, .LBB6_2
; RV64-SLOW-NEXT:  .LBB6_6: # %cond.store1
; RV64-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v9, v8, 1
; RV64-SLOW-NEXT:    vmv.x.s a1, v9
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v12, v10, 1
; RV64-SLOW-NEXT:    vmv.x.s a2, v12
; RV64-SLOW-NEXT:    sb a1, 0(a2)
; RV64-SLOW-NEXT:    srli a1, a1, 8
; RV64-SLOW-NEXT:    sb a1, 1(a2)
; RV64-SLOW-NEXT:    andi a1, a0, 4
; RV64-SLOW-NEXT:    beqz a1, .LBB6_3
; RV64-SLOW-NEXT:  .LBB6_7: # %cond.store3
; RV64-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v9, v8, 2
; RV64-SLOW-NEXT:    vmv.x.s a1, v9
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v12, v10, 2
; RV64-SLOW-NEXT:    vmv.x.s a2, v12
; RV64-SLOW-NEXT:    sb a1, 0(a2)
; RV64-SLOW-NEXT:    srli a1, a1, 8
; RV64-SLOW-NEXT:    sb a1, 1(a2)
; RV64-SLOW-NEXT:    andi a0, a0, 8
; RV64-SLOW-NEXT:    beqz a0, .LBB6_4
; RV64-SLOW-NEXT:  .LBB6_8: # %cond.store5
; RV64-SLOW-NEXT:    vsetivli zero, 1, e16, mf2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v8, 3
; RV64-SLOW-NEXT:    vmv.x.s a0, v8
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v10, 3
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    sb a0, 0(a1)
; RV64-SLOW-NEXT:    srli a0, a0, 8
; RV64-SLOW-NEXT:    sb a0, 1(a1)
; RV64-SLOW-NEXT:    ret
;
; RV32-FAST-LABEL: mscatter_v4i16_align1:
; RV32-FAST:       # %bb.0:
; RV32-FAST-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV32-FAST-NEXT:    vsoxei32.v v8, (zero), v9, v0.t
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: mscatter_v4i16_align1:
; RV64-FAST:       # %bb.0:
; RV64-FAST-NEXT:    vsetivli zero, 4, e16, mf2, ta, ma
; RV64-FAST-NEXT:    vsoxei64.v v8, (zero), v10, v0.t
; RV64-FAST-NEXT:    ret
  call void @llvm.masked.scatter.v4i16.v4p0(<4 x i16> %val, <4 x ptr> %ptrs, i32 1, <4 x i1> %m)
  ret void
}

declare void @llvm.masked.scatter.v2i32.v2p0(<2 x i32>, <2 x ptr>, i32, <2 x i1>)

define void @mscatter_v2i32_align2(<2 x i32> %val, <2 x ptr> %ptrs, <2 x i1> %m) {
; RV32-SLOW-LABEL: mscatter_v2i32_align2:
; RV32-SLOW:       # %bb.0:
; RV32-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a0, v0
; RV32-SLOW-NEXT:    andi a1, a0, 1
; RV32-SLOW-NEXT:    bnez a1, .LBB7_3
; RV32-SLOW-NEXT:  # %bb.1: # %else
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    bnez a0, .LBB7_4
; RV32-SLOW-NEXT:  .LBB7_2: # %else2
; RV32-SLOW-NEXT:    ret
; RV32-SLOW-NEXT:  .LBB7_3: # %cond.store
; RV32-SLOW-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    vmv.x.s a2, v9
; RV32-SLOW-NEXT:    sh a1, 0(a2)
; RV32-SLOW-NEXT:    srli a1, a1, 16
; RV32-SLOW-NEXT:    sh a1, 2(a2)
; RV32-SLOW-NEXT:    andi a0, a0, 2
; RV32-SLOW-NEXT:    beqz a0, .LBB7_2
; RV32-SLOW-NEXT:  .LBB7_4: # %cond.store1
; RV32-SLOW-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV32-SLOW-NEXT:    vmv.x.s a0, v8
; RV32-SLOW-NEXT:    vslidedown.vi v8, v9, 1
; RV32-SLOW-NEXT:    vmv.x.s a1, v8
; RV32-SLOW-NEXT:    sh a0, 0(a1)
; RV32-SLOW-NEXT:    srli a0, a0, 16
; RV32-SLOW-NEXT:    sh a0, 2(a1)
; RV32-SLOW-NEXT:    ret
;
; RV64-SLOW-LABEL: mscatter_v2i32_align2:
; RV64-SLOW:       # %bb.0:
; RV64-SLOW-NEXT:    vsetivli zero, 0, e8, mf8, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a0, v0
; RV64-SLOW-NEXT:    andi a1, a0, 1
; RV64-SLOW-NEXT:    bnez a1, .LBB7_3
; RV64-SLOW-NEXT:  # %bb.1: # %else
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    bnez a0, .LBB7_4
; RV64-SLOW-NEXT:  .LBB7_2: # %else2
; RV64-SLOW-NEXT:    ret
; RV64-SLOW-NEXT:  .LBB7_3: # %cond.store
; RV64-SLOW-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a2, v9
; RV64-SLOW-NEXT:    sh a1, 0(a2)
; RV64-SLOW-NEXT:    srli a1, a1, 16
; RV64-SLOW-NEXT:    sh a1, 2(a2)
; RV64-SLOW-NEXT:    andi a0, a0, 2
; RV64-SLOW-NEXT:    beqz a0, .LBB7_2
; RV64-SLOW-NEXT:  .LBB7_4: # %cond.store1
; RV64-SLOW-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v8, 1
; RV64-SLOW-NEXT:    vmv.x.s a0, v8
; RV64-SLOW-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; RV64-SLOW-NEXT:    vslidedown.vi v8, v9, 1
; RV64-SLOW-NEXT:    vmv.x.s a1, v8
; RV64-SLOW-NEXT:    sh a0, 0(a1)
; RV64-SLOW-NEXT:    srli a0, a0, 16
; RV64-SLOW-NEXT:    sh a0, 2(a1)
; RV64-SLOW-NEXT:    ret
;
; RV32-FAST-LABEL: mscatter_v2i32_align2:
; RV32-FAST:       # %bb.0:
; RV32-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-FAST-NEXT:    vsoxei32.v v8, (zero), v9, v0.t
; RV32-FAST-NEXT:    ret
;
; RV64-FAST-LABEL: mscatter_v2i32_align2:
; RV64-FAST:       # %bb.0:
; RV64-FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV64-FAST-NEXT:    vsoxei64.v v8, (zero), v9, v0.t
; RV64-FAST-NEXT:    ret
  call void @llvm.masked.scatter.v2i32.v2p0(<2 x i32> %val, <2 x ptr> %ptrs, i32 2, <2 x i1> %m)
  ret void
}

declare <2 x i32> @llvm.masked.load.v2i32(ptr, i32, <2 x i1>, <2 x i32>)

define void @masked_load_v2i32_align1(ptr %a, <2 x i32> %m, ptr %res_ptr) nounwind {
; RV32-SLOW-LABEL: masked_load_v2i32_align1:
; RV32-SLOW:       # %bb.0:
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmseq.vi v8, v8, 0
; RV32-SLOW-NEXT:    vsetvli zero, zero, e8, mf8, ta, ma
; RV32-SLOW-NEXT:    vmv.x.s a2, v8
; RV32-SLOW-NEXT:    andi a3, a2, 1
; RV32-SLOW-NEXT:    # implicit-def: $v8
; RV32-SLOW-NEXT:    beqz a3, .LBB8_2
; RV32-SLOW-NEXT:  # %bb.1: # %cond.load
; RV32-SLOW-NEXT:    lbu a3, 1(a0)
; RV32-SLOW-NEXT:    lbu a4, 0(a0)
; RV32-SLOW-NEXT:    lbu a5, 2(a0)
; RV32-SLOW-NEXT:    lbu a6, 3(a0)
; RV32-SLOW-NEXT:    slli a3, a3, 8
; RV32-SLOW-NEXT:    or a3, a3, a4
; RV32-SLOW-NEXT:    slli a5, a5, 16
; RV32-SLOW-NEXT:    slli a6, a6, 24
; RV32-SLOW-NEXT:    or a4, a6, a5
; RV32-SLOW-NEXT:    or a3, a4, a3
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.v.x v8, a3
; RV32-SLOW-NEXT:  .LBB8_2: # %else
; RV32-SLOW-NEXT:    andi a2, a2, 2
; RV32-SLOW-NEXT:    beqz a2, .LBB8_4
; RV32-SLOW-NEXT:  # %bb.3: # %cond.load1
; RV32-SLOW-NEXT:    lbu a2, 5(a0)
; RV32-SLOW-NEXT:    lbu a3, 4(a0)
; RV32-SLOW-NEXT:    lbu a4, 6(a0)
; RV32-SLOW-NEXT:    lbu a0, 7(a0)
; RV32-SLOW-NEXT:    slli a2, a2, 8
; RV32-SLOW-NEXT:    or a2, a2, a3
; RV32-SLOW-NEXT:    slli a4, a4, 16
; RV32-SLOW-NEXT:    slli a0, a0, 24
; RV32-SLOW-NEXT:    or a0, a0, a4
; RV32-SLOW-NEXT:    or a0, a0, a2
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vmv.s.x v9, a0
; RV32-SLOW-NEXT:    vslideup.vi v8, v9, 1
; RV32-SLOW-NEXT:  .LBB8_4: # %else2
; RV32-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV32-SLOW-NEXT:    vse32.v v8, (a1)
; RV32-SLOW-NEXT:    ret
;
; RV64-SLOW-LABEL: masked_load_v2i32_align1:
; RV64-SLOW:       # %bb.0:
; RV64-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vmseq.vi v8, v8, 0
; RV64-SLOW-NEXT:    vsetvli zero, zero, e8, mf8, ta, ma
; RV64-SLOW-NEXT:    vmv.x.s a2, v8
; RV64-SLOW-NEXT:    andi a3, a2, 1
; RV64-SLOW-NEXT:    # implicit-def: $v8
; RV64-SLOW-NEXT:    beqz a3, .LBB8_2
; RV64-SLOW-NEXT:  # %bb.1: # %cond.load
; RV64-SLOW-NEXT:    lbu a3, 1(a0)
; RV64-SLOW-NEXT:    lbu a4, 0(a0)
; RV64-SLOW-NEXT:    lbu a5, 2(a0)
; RV64-SLOW-NEXT:    lb a6, 3(a0)
; RV64-SLOW-NEXT:    slli a3, a3, 8
; RV64-SLOW-NEXT:    or a3, a3, a4
; RV64-SLOW-NEXT:    slli a5, a5, 16
; RV64-SLOW-NEXT:    slli a6, a6, 24
; RV64-SLOW-NEXT:    or a4, a6, a5
; RV64-SLOW-NEXT:    or a3, a4, a3
; RV64-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vmv.v.x v8, a3
; RV64-SLOW-NEXT:  .LBB8_2: # %else
; RV64-SLOW-NEXT:    andi a2, a2, 2
; RV64-SLOW-NEXT:    beqz a2, .LBB8_4
; RV64-SLOW-NEXT:  # %bb.3: # %cond.load1
; RV64-SLOW-NEXT:    lbu a2, 5(a0)
; RV64-SLOW-NEXT:    lbu a3, 4(a0)
; RV64-SLOW-NEXT:    lbu a4, 6(a0)
; RV64-SLOW-NEXT:    lb a0, 7(a0)
; RV64-SLOW-NEXT:    slli a2, a2, 8
; RV64-SLOW-NEXT:    or a2, a2, a3
; RV64-SLOW-NEXT:    slli a4, a4, 16
; RV64-SLOW-NEXT:    slli a0, a0, 24
; RV64-SLOW-NEXT:    or a0, a0, a4
; RV64-SLOW-NEXT:    or a0, a0, a2
; RV64-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vmv.s.x v9, a0
; RV64-SLOW-NEXT:    vslideup.vi v8, v9, 1
; RV64-SLOW-NEXT:  .LBB8_4: # %else2
; RV64-SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; RV64-SLOW-NEXT:    vse32.v v8, (a1)
; RV64-SLOW-NEXT:    ret
;
; FAST-LABEL: masked_load_v2i32_align1:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; FAST-NEXT:    vmseq.vi v0, v8, 0
; FAST-NEXT:    vle32.v v8, (a0), v0.t
; FAST-NEXT:    vse32.v v8, (a1)
; FAST-NEXT:    ret
  %mask = icmp eq <2 x i32> %m, zeroinitializer
  %load = call <2 x i32> @llvm.masked.load.v2i32(ptr %a, i32 1, <2 x i1> %mask, <2 x i32> undef)
  store <2 x i32> %load, ptr %res_ptr
  ret void
}

declare void @llvm.masked.store.v2i32.p0(<2 x i32>, ptr, i32, <2 x i1>)

define void @masked_store_v2i32_align2(<2 x i32> %val, ptr %a, <2 x i32> %m) nounwind {
; SLOW-LABEL: masked_store_v2i32_align2:
; SLOW:       # %bb.0:
; SLOW-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; SLOW-NEXT:    vmseq.vi v9, v9, 0
; SLOW-NEXT:    vsetvli zero, zero, e8, mf8, ta, ma
; SLOW-NEXT:    vmv.x.s a1, v9
; SLOW-NEXT:    andi a2, a1, 1
; SLOW-NEXT:    bnez a2, .LBB9_3
; SLOW-NEXT:  # %bb.1: # %else
; SLOW-NEXT:    andi a1, a1, 2
; SLOW-NEXT:    bnez a1, .LBB9_4
; SLOW-NEXT:  .LBB9_2: # %else2
; SLOW-NEXT:    ret
; SLOW-NEXT:  .LBB9_3: # %cond.store
; SLOW-NEXT:    vsetvli zero, zero, e32, mf2, ta, ma
; SLOW-NEXT:    vmv.x.s a2, v8
; SLOW-NEXT:    sh a2, 0(a0)
; SLOW-NEXT:    srli a2, a2, 16
; SLOW-NEXT:    sh a2, 2(a0)
; SLOW-NEXT:    andi a1, a1, 2
; SLOW-NEXT:    beqz a1, .LBB9_2
; SLOW-NEXT:  .LBB9_4: # %cond.store1
; SLOW-NEXT:    vsetivli zero, 1, e32, mf2, ta, ma
; SLOW-NEXT:    vslidedown.vi v8, v8, 1
; SLOW-NEXT:    vmv.x.s a1, v8
; SLOW-NEXT:    sh a1, 4(a0)
; SLOW-NEXT:    srli a1, a1, 16
; SLOW-NEXT:    sh a1, 6(a0)
; SLOW-NEXT:    ret
;
; FAST-LABEL: masked_store_v2i32_align2:
; FAST:       # %bb.0:
; FAST-NEXT:    vsetivli zero, 2, e32, mf2, ta, ma
; FAST-NEXT:    vmseq.vi v0, v9, 0
; FAST-NEXT:    vse32.v v8, (a0), v0.t
; FAST-NEXT:    ret
  %mask = icmp eq <2 x i32> %m, zeroinitializer
  call void @llvm.masked.store.v2i32.p0(<2 x i32> %val, ptr %a, i32 2, <2 x i1> %mask)
  ret void
}
