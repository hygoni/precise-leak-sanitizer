; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m,+f,+d,+a,+c,+v \
; RUN:   -target-abi=lp64d -verify-machineinstrs -O2 < %s | FileCheck %s

declare i64 @llvm.riscv.vsetvli(i64, i64, i64)
declare i64 @llvm.riscv.vsetvlimax(i64, i64)
declare <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  i64, i64)
declare <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>*,
  <vscale x 1 x i1>,
  i64, i64)

define <vscale x 1 x double> @test1(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 %0)
  ret <vscale x 1 x double> %1
}

define <vscale x 1 x double> @test2(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 %avl)
  ret <vscale x 1 x double> %1
}

define <vscale x 1 x i64> @test3(i64 %avl, <vscale x 1 x i64> %a, <vscale x 1 x i64>* %b, <vscale x 1 x i1> %c) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %0, i64 1)

  ret <vscale x 1 x i64> %1
}

define <vscale x 1 x i64> @test4(i64 %avl, <vscale x 1 x i64> %a, <vscale x 1 x i64>* %b, <vscale x 1 x i1> %c) nounwind {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, mu
; CHECK-NEXT:    vle64.v v8, (a1), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %1 = call <vscale x 1 x i64> @llvm.riscv.vle.mask.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64>* %b,
    <vscale x 1 x i1> %c,
    i64 %avl, i64 1)

  ret <vscale x 1 x i64> %1
}

; Make sure we don't insert a vsetvli for the vmand instruction.
define <vscale x 1 x i1> @test5(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, <vscale x 1 x i1> %2, i64 %avl) nounwind {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vmseq.vv v8, v8, v9
; CHECK-NEXT:    vmand.mm v0, v8, v0
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 0)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmseq.nxv1i64.i64(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, i64 %vl)
  %b = call <vscale x 1 x i1> @llvm.riscv.vmand.nxv1i1.i64(<vscale x 1 x i1> %a, <vscale x 1 x i1> %2, i64 %vl)
  ret <vscale x 1 x i1> %b
}
declare <vscale x 1 x i1> @llvm.riscv.vmseq.nxv1i64.i64(<vscale x 1 x i64>, <vscale x 1 x i64>, i64)
declare <vscale x 1 x i1> @llvm.riscv.vmand.nxv1i1.i64(<vscale x 1 x i1>, <vscale x 1 x i1>, i64)

; Make sure we don't insert a vsetvli for the vmor instruction.
define void @test6(i32* nocapture readonly %A, i32* nocapture %B, i64 %n) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a3, a2, e32, m1, ta, ma
; CHECK-NEXT:    beqz a3, .LBB5_3
; CHECK-NEXT:  # %bb.1: # %for.body.preheader
; CHECK-NEXT:    li a4, 0
; CHECK-NEXT:  .LBB5_2: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    slli a6, a4, 2
; CHECK-NEXT:    add a5, a0, a6
; CHECK-NEXT:    vle32.v v8, (a5)
; CHECK-NEXT:    vmsle.vi v9, v8, -3
; CHECK-NEXT:    vmsgt.vi v10, v8, 2
; CHECK-NEXT:    vmor.mm v0, v9, v10
; CHECK-NEXT:    add a6, a6, a1
; CHECK-NEXT:    vse32.v v8, (a6), v0.t
; CHECK-NEXT:    add a4, a4, a3
; CHECK-NEXT:    vsetvli a3, a2, e32, m1, ta, ma
; CHECK-NEXT:    bnez a3, .LBB5_2
; CHECK-NEXT:  .LBB5_3: # %for.cond.cleanup
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 2, i64 0)
  %cmp.not11 = icmp eq i64 %0, 0
  br i1 %cmp.not11, label %for.cond.cleanup, label %for.body

for.cond.cleanup:                                 ; preds = %for.body, %entry
  ret void

for.body:                                         ; preds = %entry, %for.body
  %1 = phi i64 [ %8, %for.body ], [ %0, %entry ]
  %i.012 = phi i64 [ %add, %for.body ], [ 0, %entry ]
  %add.ptr = getelementptr inbounds i32, i32* %A, i64 %i.012
  %2 = bitcast i32* %add.ptr to <vscale x 2 x i32>*
  %3 = tail call <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32.i64(<vscale x 2 x i32> undef, <vscale x 2 x i32>* %2, i64 %1)
  %4 = tail call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32.i64(<vscale x 2 x i32> %3, i32 -2, i64 %1)
  %5 = tail call <vscale x 2 x i1> @llvm.riscv.vmsgt.nxv2i32.i32.i64(<vscale x 2 x i32> %3, i32 2, i64 %1)
  %6 = tail call <vscale x 2 x i1> @llvm.riscv.vmor.nxv2i1.i64(<vscale x 2 x i1> %4, <vscale x 2 x i1> %5, i64 %1)
  %add.ptr1 = getelementptr inbounds i32, i32* %B, i64 %i.012
  %7 = bitcast i32* %add.ptr1 to <vscale x 2 x i32>*
  tail call void @llvm.riscv.vse.mask.nxv2i32.i64(<vscale x 2 x i32> %3, <vscale x 2 x i32>* %7, <vscale x 2 x i1> %6, i64 %1)
  %add = add i64 %1, %i.012
  %8 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 2, i64 0)
  %cmp.not = icmp eq i64 %8, 0
  br i1 %cmp.not, label %for.cond.cleanup, label %for.body
}

define <vscale x 1 x i64> @test7(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, tu, ma
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvlimax(i64 3, i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(
    <vscale x 1 x i64> %a,
    i64 %b, i64 1)

  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x i64> @test8(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, tu, ma
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(<vscale x 1 x i64> %a, i64 %b, i64 2)
  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x i64> @test9(<vscale x 1 x i64> %a, i64 %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 9, e64, m1, tu, mu
; CHECK-NEXT:    vadd.vv v8, v8, v8, v0.t
; CHECK-NEXT:    vmv.s.x v8, a0
; CHECK-NEXT:    ret
entry:
  %x = call <vscale x 1 x i64> @llvm.riscv.vadd.mask.nxv1i64.nxv1i64(
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64> %a,
    <vscale x 1 x i64> %a,
    <vscale x 1 x i1> %mask,
    i64 9,
    i64 0)
  %y = call <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(<vscale x 1 x i64> %x, i64 %b, i64 2)
  ret <vscale x 1 x i64> %y
}

define <vscale x 1 x double> @test10(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, tu, ma
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvlimax(i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 1)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test11(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test11:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, tu, ma
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 2)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test12(<vscale x 1 x double> %a, double %b, <vscale x 1 x i1> %mask) nounwind {
; CHECK-LABEL: test12:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 9, e64, m1, tu, mu
; CHECK-NEXT:    vfadd.vv v8, v8, v8, v0.t
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    ret
entry:
  %x = call <vscale x 1 x double> @llvm.riscv.vfadd.mask.nxv1f64.f64(
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %a,
    <vscale x 1 x i1> %mask,
    i64 7,
    i64 9,
    i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %x, double %b, i64 2)
  ret <vscale x 1 x double> %y
}

define <vscale x 1 x double> @test13(<vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test13:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %0 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 -1)
  ret <vscale x 1 x double> %0
}

define <vscale x 1 x double> @test14(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test14:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vsetivli zero, 1, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %vsetvli = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %f1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 1)
  %f2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %f1,
    <vscale x 1 x double> %b,
    i64 7, i64 %vsetvli)
  ret <vscale x 1 x double> %f2
}

define <vscale x 1 x double> @test15(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test15:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    ret
entry:
  %vsetvli = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %f1 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 %avl)
  %f2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %f1,
    <vscale x 1 x double> %b,
    i64 7, i64 %vsetvli)
  ret <vscale x 1 x double> %f2
}


@gdouble = external global double

define <vscale x 1 x double> @test16(i64 %avl, double %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, mf2, ta, ma
; CHECK-NEXT:    vsetvli a1, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfmv.v.f v9, fa0
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %vsetvli = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 3, i64 7)

  %head = insertelement <vscale x 1 x double> poison, double %a, i32 0
  %splat = shufflevector <vscale x 1 x double> %head, <vscale x 1 x double> poison, <vscale x 1 x i32> zeroinitializer
  %f2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %splat,
    <vscale x 1 x double> %b,
    i64 7, i64 %vsetvli)
  ret <vscale x 1 x double> %f2
}

define double @test17(i64 %avl, <vscale x 1 x double> %a, <vscale x 1 x double> %b) nounwind {
; CHECK-LABEL: test17:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfmv.f.s fa5, v8
; CHECK-NEXT:    vsetvli zero, a0, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v9
; CHECK-NEXT:    vfmv.f.s fa4, v8
; CHECK-NEXT:    fadd.d fa0, fa5, fa4
; CHECK-NEXT:    ret
entry:
  %vsetvli = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %c1 = extractelement <vscale x 1 x double> %a, i32 0
  %f2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %b,
    i64 7, i64 %vsetvli)
  %c2 = extractelement <vscale x 1 x double> %f2, i32 0
  %c3 = fadd double %c1, %c2
  ret double %c3
}


define <vscale x 1 x double> @test18(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test18:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 6, e64, m1, tu, ma
; CHECK-NEXT:    vmv1r.v v9, v8
; CHECK-NEXT:    vfmv.s.f v9, fa0
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v8, v8
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, tu, ma
; CHECK-NEXT:    vfmv.s.f v8, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 2)
  %f2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %a,
    <vscale x 1 x double> %a,
    i64 7, i64 %x)
  %y2 = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %f2, double %b, i64 1)
  %res = fadd <vscale x 1 x double> %y, %y2
  ret <vscale x 1 x double> %res
}

define <vscale x 1 x double> @test19(<vscale x 1 x double> %a, double %b) nounwind {
; CHECK-LABEL: test19:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, tu, ma
; CHECK-NEXT:    vmv1r.v v9, v8
; CHECK-NEXT:    vfmv.s.f v9, fa0
; CHECK-NEXT:    vsetvli a0, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v9, v8
; CHECK-NEXT:    ret
entry:
  %x = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 3, i64 0)
  %y = call <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64(
    <vscale x 1 x double> %a, double %b, i64 2)
  %y2 = fadd <vscale x 1 x double> %y, %a
  ret <vscale x 1 x double> %y2
}

define i64 @avl_forward1(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p) nounwind {
; CHECK-LABEL: avl_forward1:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli a1, 6, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 2, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret i64 %vl
}

; Incompatible vtype
define i64 @avl_forward1b_neg(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p) nounwind {
; CHECK-LABEL: avl_forward1b_neg:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli a1, 6, e16, m1, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 6, i64 1, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret i64 %vl
}

define i64 @avl_forward2(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p) nounwind {
; CHECK-LABEL: avl_forward2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvlimax(i64 2, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret i64 %vl
}


; %vl is intentionally used only once
define void @avl_forward3(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %reg) nounwind {
; CHECK-LABEL: avl_forward3:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %reg, i64 2, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret void
}

; %vl has multiple uses
define i64 @avl_forward3b(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %reg) nounwind {
; CHECK-LABEL: avl_forward3b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %reg, i64 2, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret i64 %vl
}

; Like4, but with incompatible VTYPE
define void @avl_forward4(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %reg) nounwind {
; CHECK-LABEL: avl_forward4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16, m1, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %reg, i64 1, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret void
}

; Like4b, but with incompatible VTYPE
define i64 @avl_forward4b(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %reg) nounwind {
; CHECK-LABEL: avl_forward4b:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e16, m1, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vse32.v v8, (a0)
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:    ret
entry:
  %vl = tail call i64 @llvm.riscv.vsetvli(i64 %reg, i64 1, i64 0)
  call void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32> %v, <vscale x 2 x i32>* %p, i64 %vl)
  ret i64 %vl
}

; Fault first loads can modify VL.
; TODO: The VSETVLI of vadd could be removed here.
define <vscale x 1 x i64> @vleNff(i64* %str, i64 %n, i64 %x) {
; CHECK-LABEL: vleNff:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8, m4, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vle64ff.v v8, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, tu, ma
; CHECK-NEXT:    vadd.vx v8, v8, a2
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 0, i64 2)
  %1 = bitcast i64* %str to <vscale x 1 x i64>*
  %2 = tail call { <vscale x 1 x i64>, i64 } @llvm.riscv.vleff.nxv1i64.i64(<vscale x 1 x i64> undef, <vscale x 1 x i64>* %1, i64 %0)
  %3 = extractvalue { <vscale x 1 x i64>, i64 } %2, 0
  %4 = extractvalue { <vscale x 1 x i64>, i64 } %2, 1
  %5 = tail call <vscale x 1 x i64> @llvm.riscv.vadd.nxv1i64.i64.i64(<vscale x 1 x i64> %3, <vscale x 1 x i64> %3, i64 %x, i64 %4)
  ret <vscale x 1 x i64> %5
}

; Similiar test case, but use same policy for vleff and vadd.
; Note: The test may be redundant if we could fix the TODO of @vleNff.
define <vscale x 1 x i64> @vleNff2(i64* %str, i64 %n, i64 %x) {
; CHECK-LABEL: vleNff2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, a1, e8, m4, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e64, m1, ta, ma
; CHECK-NEXT:    vle64ff.v v8, (a0)
; CHECK-NEXT:    vadd.vx v8, v8, a2
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli.i64(i64 %n, i64 0, i64 2)
  %1 = bitcast i64* %str to <vscale x 1 x i64>*
  %2 = tail call { <vscale x 1 x i64>, i64 } @llvm.riscv.vleff.nxv1i64.i64(<vscale x 1 x i64> undef, <vscale x 1 x i64>* %1, i64 %0)
  %3 = extractvalue { <vscale x 1 x i64>, i64 } %2, 0
  %4 = extractvalue { <vscale x 1 x i64>, i64 } %2, 1
  %5 = tail call <vscale x 1 x i64> @llvm.riscv.vadd.nxv1i64.i64.i64(<vscale x 1 x i64> undef, <vscale x 1 x i64> %3, i64 %x, i64 %4)
  ret <vscale x 1 x i64> %5
}

declare { <vscale x 1 x i64>, i64 } @llvm.riscv.vleff.nxv1i64.i64(
  <vscale x 1 x i64>, <vscale x 1 x i64>* nocapture, i64)

declare <vscale x 1 x i1> @llvm.riscv.vmseq.nxv1i64.i64.i64(
  <vscale x 1 x i64>, i64, i64)

; Ensure AVL register is alive when forwarding an AVL immediate that does not fit in 5 bits
define <vscale x 2 x i32> @avl_forward5(<vscale x 2 x i32>* %addr) {
; CHECK-LABEL: avl_forward5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a1, 32
; CHECK-NEXT:    vsetvli a1, a1, e8, m4, ta, ma
; CHECK-NEXT:    vsetvli zero, a1, e32, m1, ta, ma
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    ret
  %gvl = tail call i64 @llvm.riscv.vsetvli.i64(i64 32, i64 0, i64 2)
  %ret = tail call <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32.i64(<vscale x 2 x i32> undef, <vscale x 2 x i32>* %addr, i64 %gvl)
  ret <vscale x 2 x i32> %ret
}

declare <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.nxv1f32(<vscale x 1 x double>, <vscale x 1 x float>, <vscale x 1 x float>, i64, i64)

define <vscale x 1 x double> @test20(i64 %avl, <vscale x 1 x float> %a, <vscale x 1 x float> %b, <vscale x 1 x double> %c) nounwind {
; CHECK-LABEL: test20:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a0, e32, mf2, ta, ma
; CHECK-NEXT:    vfwadd.vv v11, v8, v9
; CHECK-NEXT:    vsetvli zero, zero, e64, m1, ta, ma
; CHECK-NEXT:    vfadd.vv v8, v11, v10
; CHECK-NEXT:    ret
entry:
  %0 = tail call i64 @llvm.riscv.vsetvli(i64 %avl, i64 2, i64 7)
  %1 = tail call <vscale x 1 x double> @llvm.riscv.vfwadd.nxv1f64.nxv1f32.nxv1f32(
    <vscale x 1 x double> undef,
    <vscale x 1 x float> %a,
    <vscale x 1 x float> %b,
    i64 7, i64 %0)
  %2 = tail call <vscale x 1 x double> @llvm.riscv.vfadd.nxv1f64.nxv1f64(
    <vscale x 1 x double> undef,
    <vscale x 1 x double> %1,
    <vscale x 1 x double> %c,
    i64 7, i64 %0)
  ret <vscale x 1 x double> %2
}

; This used to fail the machine verifier due to the vsetvli being removed
; while the add was still using it.
define i64 @bad_removal(<2 x i64> %arg) {
; CHECK-LABEL: bad_removal:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    vsetivli zero, 16, e64, m1, ta, ma
; CHECK-NEXT:    vmv.x.s a0, v8
; CHECK-NEXT:    vsetivli a1, 16, e64, m1, ta, ma
; CHECK-NEXT:    add a0, a0, a1
; CHECK-NEXT:    ret
bb:
  %tmp = extractelement <2 x i64> %arg, i64 0
  %tmp1 = call i64 @llvm.riscv.vsetvli.i64(i64 16, i64 3, i64 0)
  %tmp2 = add i64 %tmp, %tmp1
  ret i64 %tmp2
}

declare <vscale x 1 x i64> @llvm.riscv.vadd.mask.nxv1i64.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i1>,
  i64,
  i64);

declare <vscale x 1 x i64> @llvm.riscv.vadd.nxv1i64.i64.i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  i64,
  i64);

declare <vscale x 1 x double> @llvm.riscv.vfadd.mask.nxv1f64.f64(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x i1>,
  i64,
  i64,
  i64);

declare <vscale x 1 x i64> @llvm.riscv.vmv.s.x.nxv1i64(
  <vscale x 1 x i64>,
  i64,
  i64);

declare <vscale x 1 x double> @llvm.riscv.vfmv.s.f.nxv1f64
  (<vscale x 1 x double>,
  double,
  i64)

declare i64 @llvm.riscv.vsetvli.i64(i64, i64 immarg, i64 immarg)
declare <vscale x 2 x i32> @llvm.riscv.vle.nxv2i32.i64(<vscale x 2 x i32>, <vscale x 2 x i32>* nocapture, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32.i64(<vscale x 2 x i32>, i32, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmsgt.nxv2i32.i32.i64(<vscale x 2 x i32>, i32, i64)
declare <vscale x 2 x i1> @llvm.riscv.vmor.nxv2i1.i64(<vscale x 2 x i1>, <vscale x 2 x i1>, i64)
declare void @llvm.riscv.vse.mask.nxv2i32.i64(<vscale x 2 x i32>, <vscale x 2 x i32>* nocapture, <vscale x 2 x i1>, i64)
declare void @llvm.riscv.vse.nxv2i32.i64(<vscale x 2 x i32>, <vscale x 2 x i32>* nocapture, i64)
