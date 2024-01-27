; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 2
; RUN: llc < %s | FileCheck %s

target triple = "aarch64"

define <vscale x 2 x i64> @test_tileslice_no_add(i32 %idx) #0 {
; CHECK-LABEL: test_tileslice_no_add:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w8, w0
; CHECK-NEXT:    mov { z0.d, z1.d }, za.d[w8, 0, vgx2]
; CHECK-NEXT:    // kill: def $z0 killed $z0 killed $z0_z1
; CHECK-NEXT:    ret
entry:
  %read = call { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sme.read.vg1x2.nxv2i64(i32 %idx)
  %read.ext = extractvalue { <vscale x 2 x i64>, <vscale x 2 x i64> } %read, 0
  ret <vscale x 2 x i64> %read.ext
}

define <vscale x 2 x i64> @test_tileslice_add_nonconstant(i32 %idx1, i32 %idx2) #0 {
; CHECK-LABEL: test_tileslice_add_nonconstant:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    add w8, w0, w1
; CHECK-NEXT:    mov { z0.d, z1.d }, za.d[w8, 0, vgx2]
; CHECK-NEXT:    // kill: def $z0 killed $z0 killed $z0_z1
; CHECK-NEXT:    ret
entry:
  %add = add i32 %idx1, %idx2
  %read = call { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sme.read.vg1x2.nxv2i64(i32 %add)
  %read.ext = extractvalue { <vscale x 2 x i64>, <vscale x 2 x i64> } %read, 0
  ret <vscale x 2 x i64> %read.ext
}

declare { <vscale x 2 x i64>, <vscale x 2 x i64> } @llvm.aarch64.sme.read.vg1x2.nxv2i64(i32)

attributes #0 = { nounwind "target-features"="+sme2" }
