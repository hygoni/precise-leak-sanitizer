; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zihintntl,+f,+d,+zfh,+v < %s | FileCheck %s -check-prefix=CHECK-RV64V
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zihintntl,+f,+d,+zfh,+v < %s | FileCheck %s -check-prefix=CHECK-RV32V

define <vscale x 2 x i64> @test_nontemporal_load_nxv2i64(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_load_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_load_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 2 x i64>, ptr %p, !nontemporal !0
  ret <vscale x 2 x i64> %1
}

define <vscale x 4 x i32> @test_nontemporal_load_nxv4i32(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_load_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_load_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 4 x i32>, ptr %p, !nontemporal !0
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i16> @test_nontemporal_load_nxv8i16(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_load_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_load_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 8 x i16>, ptr %p, !nontemporal !0
  ret <vscale x 8 x i16> %1
}

define <vscale x 16 x i8> @test_nontemporal_load_nxv16i8(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_load_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_load_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 16 x i8>, ptr %p, !nontemporal !0
  ret <vscale x 16 x i8> %1
}

define void @test_nontemporal_store_nxv2i64(ptr %p, <vscale x 2 x i64> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_store_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_store_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 2 x i64> %v, ptr %p, !nontemporal !0
  ret void
}

define void @test_nontemporal_store_nxv4i32(ptr %p, <vscale x 4 x i32> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_store_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_store_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 4 x i32> %v, ptr %p, !nontemporal !0
  ret void
}

define void @test_nontemporal_store_nxv8i16(ptr %p, <vscale x 8 x i16> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_store_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_store_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 8 x i16> %v, ptr %p, !nontemporal !0
  ret void
}

define void @test_nontemporal_store_nxv16i8(ptr %p, <vscale x 16 x i8> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_store_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_store_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 16 x i8> %v, ptr %p, !nontemporal !0
  ret void
}

define <vscale x 2 x i64> @test_nontemporal_P1_load_nxv2i64(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_load_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_load_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 2 x i64>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret <vscale x 2 x i64> %1
}

define <vscale x 4 x i32> @test_nontemporal_P1_load_nxv4i32(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_load_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_load_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 4 x i32>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i16> @test_nontemporal_P1_load_nxv8i16(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_load_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_load_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 8 x i16>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret <vscale x 8 x i16> %1
}

define <vscale x 16 x i8> @test_nontemporal_P1_load_nxv16i8(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_load_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_load_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 16 x i8>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret <vscale x 16 x i8> %1
}

define void @test_nontemporal_P1_store_nxv2i64(ptr %p, <vscale x 2 x i64> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_store_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_store_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 2 x i64> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret void
}

define void @test_nontemporal_P1_store_nxv4i32(ptr %p, <vscale x 4 x i32> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_store_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_store_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 4 x i32> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret void
}

define void @test_nontemporal_P1_store_nxv8i16(ptr %p, <vscale x 8 x i16> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_store_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_store_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 8 x i16> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret void
}

define void @test_nontemporal_P1_store_nxv16i8(ptr %p, <vscale x 16 x i8> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_P1_store_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.p1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_P1_store_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.p1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 16 x i8> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !1
  ret void
}

define <vscale x 2 x i64> @test_nontemporal_PALL_load_nxv2i64(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_load_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_load_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 2 x i64>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret <vscale x 2 x i64> %1
}

define <vscale x 4 x i32> @test_nontemporal_PALL_load_nxv4i32(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_load_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_load_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 4 x i32>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i16> @test_nontemporal_PALL_load_nxv8i16(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_load_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_load_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 8 x i16>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret <vscale x 8 x i16> %1
}

define <vscale x 16 x i8> @test_nontemporal_PALL_load_nxv16i8(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_load_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_load_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 16 x i8>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret <vscale x 16 x i8> %1
}

define void @test_nontemporal_PALL_store_nxv2i64(ptr %p, <vscale x 2 x i64> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_store_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_store_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 2 x i64> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret void
}

define void @test_nontemporal_PALL_store_nxv4i32(ptr %p, <vscale x 4 x i32> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_store_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_store_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 4 x i32> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret void
}

define void @test_nontemporal_PALL_store_nxv8i16(ptr %p, <vscale x 8 x i16> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_store_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_store_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 8 x i16> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret void
}

define void @test_nontemporal_PALL_store_nxv16i8(ptr %p, <vscale x 16 x i8> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_PALL_store_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.pall
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_PALL_store_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.pall
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 16 x i8> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !2
  ret void
}

define <vscale x 2 x i64> @test_nontemporal_S1_load_nxv2i64(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_load_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_load_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 2 x i64>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret <vscale x 2 x i64> %1
}

define <vscale x 4 x i32> @test_nontemporal_S1_load_nxv4i32(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_load_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_load_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 4 x i32>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i16> @test_nontemporal_S1_load_nxv8i16(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_load_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_load_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 8 x i16>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret <vscale x 8 x i16> %1
}

define <vscale x 16 x i8> @test_nontemporal_S1_load_nxv16i8(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_load_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_load_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 16 x i8>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret <vscale x 16 x i8> %1
}

define void @test_nontemporal_S1_store_nxv2i64(ptr %p, <vscale x 2 x i64> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_store_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_store_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 2 x i64> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret void
}

define void @test_nontemporal_S1_store_nxv4i32(ptr %p, <vscale x 4 x i32> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_store_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_store_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 4 x i32> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret void
}

define void @test_nontemporal_S1_store_nxv8i16(ptr %p, <vscale x 8 x i16> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_store_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_store_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 8 x i16> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret void
}

define void @test_nontemporal_S1_store_nxv16i8(ptr %p, <vscale x 16 x i8> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_S1_store_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.s1
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_S1_store_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.s1
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 16 x i8> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !3
  ret void
}

define <vscale x 2 x i64> @test_nontemporal_ALL_load_nxv2i64(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_load_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_load_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re64.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 2 x i64>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret <vscale x 2 x i64> %1
}

define <vscale x 4 x i32> @test_nontemporal_ALL_load_nxv4i32(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_load_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_load_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re32.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 4 x i32>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret <vscale x 4 x i32> %1
}

define <vscale x 8 x i16> @test_nontemporal_ALL_load_nxv8i16(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_load_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_load_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2re16.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 8 x i16>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret <vscale x 8 x i16> %1
}

define <vscale x 16 x i8> @test_nontemporal_ALL_load_nxv16i8(ptr %p) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_load_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_load_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vl2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  %1 = load <vscale x 16 x i8>, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret <vscale x 16 x i8> %1
}

define void @test_nontemporal_ALL_store_nxv2i64(ptr %p, <vscale x 2 x i64> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_store_nxv2i64:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_store_nxv2i64:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 2 x i64> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret void
}

define void @test_nontemporal_ALL_store_nxv4i32(ptr %p, <vscale x 4 x i32> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_store_nxv4i32:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_store_nxv4i32:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 4 x i32> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret void
}

define void @test_nontemporal_ALL_store_nxv8i16(ptr %p, <vscale x 8 x i16> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_store_nxv8i16:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_store_nxv8i16:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 8 x i16> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret void
}

define void @test_nontemporal_ALL_store_nxv16i8(ptr %p, <vscale x 16 x i8> %v) {
; CHECK-RV64V-LABEL: test_nontemporal_ALL_store_nxv16i8:
; CHECK-RV64V:       # %bb.0:
; CHECK-RV64V-NEXT:    ntl.all
; CHECK-RV64V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV64V-NEXT:    ret
;
; CHECK-RV32V-LABEL: test_nontemporal_ALL_store_nxv16i8:
; CHECK-RV32V:       # %bb.0:
; CHECK-RV32V-NEXT:    ntl.all
; CHECK-RV32V-NEXT:    vs2r.v v8, (a0)
; CHECK-RV32V-NEXT:    ret
  store <vscale x 16 x i8> %v, ptr %p, !nontemporal !0, !riscv-nontemporal-domain !4
  ret void
}

!0 = !{i32 1}
!1 = !{i32 2}
!2 = !{i32 3}
!3 = !{i32 4}
!4 = !{i32 5}
