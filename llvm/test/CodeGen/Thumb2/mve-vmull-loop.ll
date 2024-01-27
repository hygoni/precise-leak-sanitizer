; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK

define arm_aapcs_vfpcc void @test32(ptr noalias nocapture readonly %x, ptr noalias nocapture readonly %y, ptr nocapture %z, i32 %n) {
; CHECK-LABEL: test32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB0_1: @ %vector.body.preheader
; CHECK-NEXT:    .save {r4, r5, r7, lr}
; CHECK-NEXT:    push {r4, r5, r7, lr}
; CHECK-NEXT:  .LBB0_2: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrw.u32 q0, [r0], #16
; CHECK-NEXT:    vldrw.u32 q1, [r1], #16
; CHECK-NEXT:    subs r3, #4
; CHECK-NEXT:    vmullb.s32 q2, q1, q0
; CHECK-NEXT:    vmullt.s32 q3, q1, q0
; CHECK-NEXT:    vmov r12, r5, d5
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmov r4, r5, d4
; CHECK-NEXT:    lsrl r4, r5, #31
; CHECK-NEXT:    vmov q2[2], q2[0], r4, r12
; CHECK-NEXT:    vmov r12, r5, d7
; CHECK-NEXT:    lsrl r12, r5, #31
; CHECK-NEXT:    vmov r4, r5, d6
; CHECK-NEXT:    lsrl r4, r5, #31
; CHECK-NEXT:    vmov q2[3], q2[1], r4, r12
; CHECK-NEXT:    vstrb.8 q2, [r2], #16
; CHECK-NEXT:    bne .LBB0_2
; CHECK-NEXT:  @ %bb.3:
; CHECK-NEXT:    pop.w {r4, r5, r7, lr}
; CHECK-NEXT:    bx lr
entry:
  %0 = and i32 %n, 3
  %cmp = icmp eq i32 %0, 0
  %cmp113 = icmp sgt i32 %n, 0
  br i1 %cmp113, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i32, ptr %x, i32 %index
  %wide.load = load <4 x i32>, ptr %1, align 4
  %2 = shufflevector <4 x i32> %wide.load, <4 x i32> %wide.load, <2 x i32> <i32 0, i32 2>
  %3 = shufflevector <4 x i32> %wide.load, <4 x i32> %wide.load, <2 x i32> <i32 1, i32 3>
  %4 = sext <2 x i32> %2 to <2 x i64>
  %5 = sext <2 x i32> %3 to <2 x i64>
  %6 = getelementptr inbounds i32, ptr %y, i32 %index
  %wide.load15 = load <4 x i32>, ptr %6, align 4
  %7 = shufflevector <4 x i32> %wide.load15, <4 x i32> %wide.load15, <2 x i32> <i32 0, i32 2>
  %8 = shufflevector <4 x i32> %wide.load15, <4 x i32> %wide.load15, <2 x i32> <i32 1, i32 3>
  %9 = sext <2 x i32> %7 to <2 x i64>
  %10 = sext <2 x i32> %8 to <2 x i64>
  %11 = mul <2 x i64> %9, %4
  %12 = mul <2 x i64> %10, %5
  %13 = lshr <2 x i64> %11, <i64 31, i64 31>
  %14 = lshr <2 x i64> %12, <i64 31, i64 31>
  %15 = shufflevector <2 x i64> %13, <2 x i64> %14, <4 x i32> <i32 0, i32 2, i32 1, i32 3>
  %16 = trunc <4 x i64> %15 to <4 x i32>
  %17 = getelementptr inbounds i32, ptr %z, i32 %index
  store <4 x i32> %16, ptr %17, align 4
  %index.next = add i32 %index, 4
  %18 = icmp eq i32 %index.next, %n
  br i1 %18, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @test16(ptr noalias nocapture readonly %x, ptr noalias nocapture readonly %y, ptr nocapture %z, i32 %n) {
; CHECK-LABEL: test16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB1_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrh.u16 q0, [r0], #16
; CHECK-NEXT:    vldrh.u16 q1, [r1], #16
; CHECK-NEXT:    subs r3, #8
; CHECK-NEXT:    vmullt.s16 q2, q1, q0
; CHECK-NEXT:    vmullb.s16 q0, q1, q0
; CHECK-NEXT:    vshr.u32 q2, q2, #15
; CHECK-NEXT:    vshr.u32 q0, q0, #15
; CHECK-NEXT:    vmovnt.i32 q0, q2
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    bne .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    bx lr
entry:
  %0 = and i32 %n, 7
  %cmp = icmp eq i32 %0, 0
  %cmp113 = icmp sgt i32 %n, 0
  br i1 %cmp113, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i16, ptr %x, i32 %index
  %wide.load = load <8 x i16>, ptr %1, align 2
  %2 = shufflevector <8 x i16> %wide.load, <8 x i16> %wide.load, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %3 = shufflevector <8 x i16> %wide.load, <8 x i16> %wide.load, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %4 = sext <4 x i16> %2 to <4 x i32>
  %5 = sext <4 x i16> %3 to <4 x i32>
  %6 = getelementptr inbounds i16, ptr %y, i32 %index
  %wide.load15 = load <8 x i16>, ptr %6, align 2
  %7 = shufflevector <8 x i16> %wide.load15, <8 x i16> %wide.load15, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  %8 = shufflevector <8 x i16> %wide.load15, <8 x i16> %wide.load15, <4 x i32> <i32 1, i32 3, i32 5, i32 7>
  %9 = sext <4 x i16> %7 to <4 x i32>
  %10 = sext <4 x i16> %8 to <4 x i32>
  %11 = mul <4 x i32> %9, %4
  %12 = mul <4 x i32> %10, %5
  %13 = lshr <4 x i32> %11, <i32 15, i32 15, i32 15, i32 15>
  %14 = lshr <4 x i32> %12, <i32 15, i32 15, i32 15, i32 15>
  %15 = shufflevector <4 x i32> %13, <4 x i32> %14, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  %16 = trunc <8 x i32> %15 to <8 x i16>
  %17 = getelementptr inbounds i16, ptr %z, i32 %index
  store <8 x i16> %16, ptr %17, align 2
  %index.next = add i32 %index, 8
  %18 = icmp eq i32 %index.next, %n
  br i1 %18, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}

define arm_aapcs_vfpcc void @test8(ptr noalias nocapture readonly %x, ptr noalias nocapture readonly %y, ptr nocapture %z, i32 %n) {
; CHECK-LABEL: test8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    cmp r3, #1
; CHECK-NEXT:    it lt
; CHECK-NEXT:    bxlt lr
; CHECK-NEXT:  .LBB2_1: @ %vector.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vldrb.u8 q0, [r0], #16
; CHECK-NEXT:    vldrb.u8 q1, [r1], #16
; CHECK-NEXT:    subs r3, #16
; CHECK-NEXT:    vmullt.u8 q2, q1, q0
; CHECK-NEXT:    vmullb.u8 q0, q1, q0
; CHECK-NEXT:    vshr.u16 q2, q2, #7
; CHECK-NEXT:    vshr.u16 q0, q0, #7
; CHECK-NEXT:    vmovnt.i16 q0, q2
; CHECK-NEXT:    vstrb.8 q0, [r2], #16
; CHECK-NEXT:    bne .LBB2_1
; CHECK-NEXT:  @ %bb.2: @ %for.cond.cleanup
; CHECK-NEXT:    bx lr
entry:
  %0 = and i32 %n, 15
  %cmp = icmp eq i32 %0, 0
  %cmp117 = icmp sgt i32 %n, 0
  br i1 %cmp117, label %vector.body, label %for.cond.cleanup

vector.body:                                      ; preds = %vector.body, %entry
  %index = phi i32 [ %index.next, %vector.body ], [ 0, %entry ]
  %1 = getelementptr inbounds i8, ptr %x, i32 %index
  %wide.load = load <16 x i8>, ptr %1, align 1
  %2 = shufflevector <16 x i8> %wide.load, <16 x i8> %wide.load, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %3 = shufflevector <16 x i8> %wide.load, <16 x i8> %wide.load, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %4 = zext <8 x i8> %2 to <8 x i16>
  %5 = zext <8 x i8> %3 to <8 x i16>
  %6 = getelementptr inbounds i8, ptr %y, i32 %index
  %wide.load19 = load <16 x i8>, ptr %6, align 1
  %7 = shufflevector <16 x i8> %wide.load19, <16 x i8> %wide.load19, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  %8 = shufflevector <16 x i8> %wide.load19, <16 x i8> %wide.load19, <8 x i32> <i32 1, i32 3, i32 5, i32 7, i32 9, i32 11, i32 13, i32 15>
  %9 = zext <8 x i8> %7 to <8 x i16>
  %10 = zext <8 x i8> %8 to <8 x i16>
  %11 = mul <8 x i16> %9, %4
  %12 = mul <8 x i16> %10, %5
  %13 = lshr <8 x i16> %11, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %14 = lshr <8 x i16> %12, <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>
  %15 = shufflevector <8 x i16> %13, <8 x i16> %14, <16 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11, i32 4, i32 12, i32 5, i32 13, i32 6, i32 14, i32 7, i32 15>
  %16 = trunc <16 x i16> %15 to <16 x i8>
  %17 = getelementptr inbounds i8, ptr %z, i32 %index
  store <16 x i8> %16, ptr %17, align 1
  %index.next = add i32 %index, 16
  %18 = icmp eq i32 %index.next, %n
  br i1 %18, label %for.cond.cleanup, label %vector.body

for.cond.cleanup:                                 ; preds = %vector.body, %entry
  ret void
}
