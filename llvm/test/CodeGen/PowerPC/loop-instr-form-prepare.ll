; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -ppc-asm-full-reg-names -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 < %s | FileCheck %s

; test_no_prep:
; unsigned long test_no_prep(char *p, int count) {
;   unsigned long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4002;
;   int DISP3 = 4003;
;   int DISP4 = 4004;
;   for (; i < count ; i++) {
;     unsigned long x1 = *(unsigned long *)(p + i + DISP1);
;     unsigned long x2 = *(unsigned long *)(p + i + DISP2);
;     unsigned long x3 = *(unsigned long *)(p + i + DISP3);
;     unsigned long x4 = *(unsigned long *)(p + i + DISP4);
;     res += x1*x2*x3*x4;
;   }
;   return res + count;
; }

define i64 @test_no_prep(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_no_prep:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB0_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r5, 1
; CHECK-NEXT:    addi r3, r3, 4004
; CHECK-NEXT:    li r6, -3
; CHECK-NEXT:    li r7, -2
; CHECK-NEXT:    li r8, -1
; CHECK-NEXT:    iselgt r5, r4, r5
; CHECK-NEXT:    mtctr r5
; CHECK-NEXT:    li r5, 0
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB0_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    ldx r9, r3, r6
; CHECK-NEXT:    ldx r10, r3, r7
; CHECK-NEXT:    ldx r11, r3, r8
; CHECK-NEXT:    ld r12, 0(r3)
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    mulld r9, r10, r9
; CHECK-NEXT:    mulld r9, r9, r11
; CHECK-NEXT:    maddld r5, r9, r12, r5
; CHECK-NEXT:    bdnz .LBB0_2
; CHECK-NEXT:  # %bb.3: # %bb25
; CHECK-NEXT:    add r3, r5, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB0_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb25, label %bb3

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i23, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i22, %bb3 ], [ 0, %bb ]
  %i6 = getelementptr inbounds i8, ptr %arg, i64 %i4
  %i7 = getelementptr inbounds i8, ptr %i6, i64 4001
  %i9 = load i64, ptr %i7, align 8
  %i10 = getelementptr inbounds i8, ptr %i6, i64 4002
  %i12 = load i64, ptr %i10, align 8
  %i13 = getelementptr inbounds i8, ptr %i6, i64 4003
  %i15 = load i64, ptr %i13, align 8
  %i16 = getelementptr inbounds i8, ptr %i6, i64 4004
  %i18 = load i64, ptr %i16, align 8
  %i19 = mul i64 %i12, %i9
  %i20 = mul i64 %i19, %i15
  %i21 = mul i64 %i20, %i18
  %i22 = add i64 %i21, %i5
  %i23 = add nuw i64 %i4, 1
  %i24 = icmp ult i64 %i23, %i
  br i1 %i24, label %bb3, label %bb25

bb25:                                             ; preds = %bb3, %bb
  %i26 = phi i64 [ 0, %bb ], [ %i22, %bb3 ]
  %i27 = add i64 %i26, %i
  ret i64 %i27
}

; test_ds_prep:
; unsigned long test_ds_prep(char *p, int count) {
;   unsigned long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4002;
;   int DISP3 = 4003;
;   int DISP4 = 4006;
;   for (; i < count ; i++) {
;     unsigned long x1 = *(unsigned long *)(p + i + DISP1);
;     unsigned long x2 = *(unsigned long *)(p + i + DISP2);
;     unsigned long x3 = *(unsigned long *)(p + i + DISP3);
;     unsigned long x4 = *(unsigned long *)(p + i + DISP4);
;     res += x1*x2*x3*x4;
;   }
;   return res + count;
; }

define i64 @test_ds_prep(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_ds_prep:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB1_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r5, 1
; CHECK-NEXT:    addi r6, r3, 4002
; CHECK-NEXT:    li r7, -1
; CHECK-NEXT:    iselgt r3, r4, r5
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB1_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    ldx r8, r6, r7
; CHECK-NEXT:    ld r9, 0(r6)
; CHECK-NEXT:    ldx r10, r6, r5
; CHECK-NEXT:    ld r11, 4(r6)
; CHECK-NEXT:    addi r6, r6, 1
; CHECK-NEXT:    mulld r8, r9, r8
; CHECK-NEXT:    mulld r8, r8, r10
; CHECK-NEXT:    maddld r3, r8, r11, r3
; CHECK-NEXT:    bdnz .LBB1_2
; CHECK-NEXT:  # %bb.3: # %bb25
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB1_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb25, label %bb3

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i23, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i22, %bb3 ], [ 0, %bb ]
  %i6 = getelementptr inbounds i8, ptr %arg, i64 %i4
  %i7 = getelementptr inbounds i8, ptr %i6, i64 4001
  %i9 = load i64, ptr %i7, align 8
  %i10 = getelementptr inbounds i8, ptr %i6, i64 4002
  %i12 = load i64, ptr %i10, align 8
  %i13 = getelementptr inbounds i8, ptr %i6, i64 4003
  %i15 = load i64, ptr %i13, align 8
  %i16 = getelementptr inbounds i8, ptr %i6, i64 4006
  %i18 = load i64, ptr %i16, align 8
  %i19 = mul i64 %i12, %i9
  %i20 = mul i64 %i19, %i15
  %i21 = mul i64 %i20, %i18
  %i22 = add i64 %i21, %i5
  %i23 = add nuw i64 %i4, 1
  %i24 = icmp ult i64 %i23, %i
  br i1 %i24, label %bb3, label %bb25

bb25:                                             ; preds = %bb3, %bb
  %i26 = phi i64 [ 0, %bb ], [ %i22, %bb3 ]
  %i27 = add i64 %i26, %i
  ret i64 %i27
}

; test_max_number_reminder:
; unsigned long test_max_number_reminder(char *p, int count) {
;  unsigned long i=0, res=0;
;  int DISP1 = 4001;
;  int DISP2 = 4002;
;  int DISP3 = 4003;
;  int DISP4 = 4005;
;  int DISP5 = 4006;
;  int DISP6 = 4007;
;  int DISP7 = 4014;
;  int DISP8 = 4010;
;  int DISP9 = 4011;
;  for (; i < count ; i++) {
;    unsigned long x1 = *(unsigned long *)(p + i + DISP1);
;    unsigned long x2 = *(unsigned long *)(p + i + DISP2);
;    unsigned long x3 = *(unsigned long *)(p + i + DISP3);
;    unsigned long x4 = *(unsigned long *)(p + i + DISP4);
;    unsigned long x5 = *(unsigned long *)(p + i + DISP5);
;    unsigned long x6 = *(unsigned long *)(p + i + DISP6);
;    unsigned long x7 = *(unsigned long *)(p + i + DISP7);
;    unsigned long x8 = *(unsigned long *)(p + i + DISP8);
;    unsigned long x9 = *(unsigned long *)(p + i + DISP9);
;    res += x1*x2*x3*x4*x5*x6*x7*x8*x9;
;  }
;  return res + count;
;}

define i64 @test_max_number_reminder(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_max_number_reminder:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB2_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r5, 1
; CHECK-NEXT:    addi r9, r3, 4002
; CHECK-NEXT:    std r25, -56(r1) # 8-byte Folded Spill
; CHECK-NEXT:    li r6, -1
; CHECK-NEXT:    std r26, -48(r1) # 8-byte Folded Spill
; CHECK-NEXT:    li r7, 3
; CHECK-NEXT:    li r8, 5
; CHECK-NEXT:    li r10, 9
; CHECK-NEXT:    std r27, -40(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r28, -32(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    iselgt r3, r4, r5
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB2_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    ldx r11, r9, r6
; CHECK-NEXT:    ld r12, 0(r9)
; CHECK-NEXT:    ldx r0, r9, r5
; CHECK-NEXT:    ldx r30, r9, r7
; CHECK-NEXT:    mulld r11, r12, r11
; CHECK-NEXT:    ld r29, 4(r9)
; CHECK-NEXT:    ldx r28, r9, r8
; CHECK-NEXT:    ld r27, 12(r9)
; CHECK-NEXT:    ld r26, 8(r9)
; CHECK-NEXT:    ldx r25, r9, r10
; CHECK-NEXT:    addi r9, r9, 1
; CHECK-NEXT:    mulld r11, r11, r0
; CHECK-NEXT:    mulld r11, r11, r30
; CHECK-NEXT:    mulld r11, r11, r29
; CHECK-NEXT:    mulld r11, r11, r28
; CHECK-NEXT:    mulld r11, r11, r27
; CHECK-NEXT:    mulld r11, r11, r26
; CHECK-NEXT:    maddld r3, r11, r25, r3
; CHECK-NEXT:    bdnz .LBB2_2
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r28, -32(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r27, -40(r1) # 8-byte Folded Reload
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    ld r26, -48(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r25, -56(r1) # 8-byte Folded Reload
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB2_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb45, label %bb3

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i43, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i42, %bb3 ], [ 0, %bb ]
  %i6 = getelementptr inbounds i8, ptr %arg, i64 %i4
  %i7 = getelementptr inbounds i8, ptr %i6, i64 4001
  %i9 = load i64, ptr %i7, align 8
  %i10 = getelementptr inbounds i8, ptr %i6, i64 4002
  %i12 = load i64, ptr %i10, align 8
  %i13 = getelementptr inbounds i8, ptr %i6, i64 4003
  %i15 = load i64, ptr %i13, align 8
  %i16 = getelementptr inbounds i8, ptr %i6, i64 4005
  %i18 = load i64, ptr %i16, align 8
  %i19 = getelementptr inbounds i8, ptr %i6, i64 4006
  %i21 = load i64, ptr %i19, align 8
  %i22 = getelementptr inbounds i8, ptr %i6, i64 4007
  %i24 = load i64, ptr %i22, align 8
  %i25 = getelementptr inbounds i8, ptr %i6, i64 4014
  %i27 = load i64, ptr %i25, align 8
  %i28 = getelementptr inbounds i8, ptr %i6, i64 4010
  %i30 = load i64, ptr %i28, align 8
  %i31 = getelementptr inbounds i8, ptr %i6, i64 4011
  %i33 = load i64, ptr %i31, align 8
  %i34 = mul i64 %i12, %i9
  %i35 = mul i64 %i34, %i15
  %i36 = mul i64 %i35, %i18
  %i37 = mul i64 %i36, %i21
  %i38 = mul i64 %i37, %i24
  %i39 = mul i64 %i38, %i27
  %i40 = mul i64 %i39, %i30
  %i41 = mul i64 %i40, %i33
  %i42 = add i64 %i41, %i5
  %i43 = add nuw i64 %i4, 1
  %i44 = icmp ult i64 %i43, %i
  br i1 %i44, label %bb3, label %bb45

bb45:                                             ; preds = %bb3, %bb
  %i46 = phi i64 [ 0, %bb ], [ %i42, %bb3 ]
  %i47 = add i64 %i46, %i
  ret i64 %i47
}

; test_update_ds_prep_interact:
; unsigned long test_update_ds_prep_interact(char *p, int count) {
;   unsigned long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4002;
;   int DISP3 = 4003;
;   int DISP4 = 4006;
;   for (; i < count ; i++) {
;     unsigned long x1 = *(unsigned long *)(p + 4 * i + DISP1);
;     unsigned long x2 = *(unsigned long *)(p + 4 * i + DISP2);
;     unsigned long x3 = *(unsigned long *)(p + 4 * i + DISP3);
;     unsigned long x4 = *(unsigned long *)(p + 4 * i + DISP4);
;     res += x1*x2*x3*x4;
;   }
;   return res + count;
; }

define dso_local i64 @test_update_ds_prep_interact(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_update_ds_prep_interact:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB3_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r6, 1
; CHECK-NEXT:    addi r3, r3, 3998
; CHECK-NEXT:    li r7, -1
; CHECK-NEXT:    iselgt r5, r4, r6
; CHECK-NEXT:    mtctr r5
; CHECK-NEXT:    li r5, 0
; CHECK-NEXT:    .p2align 5
; CHECK-NEXT:  .LBB3_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    ldu r8, 4(r3)
; CHECK-NEXT:    ldx r9, r3, r7
; CHECK-NEXT:    ldx r10, r3, r6
; CHECK-NEXT:    ld r11, 4(r3)
; CHECK-NEXT:    mulld r8, r8, r9
; CHECK-NEXT:    mulld r8, r8, r10
; CHECK-NEXT:    maddld r5, r8, r11, r5
; CHECK-NEXT:    bdnz .LBB3_2
; CHECK-NEXT:  # %bb.3: # %bb26
; CHECK-NEXT:    add r3, r5, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB3_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb26, label %bb3

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i24, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i23, %bb3 ], [ 0, %bb ]
  %i6 = shl i64 %i4, 2
  %i7 = getelementptr inbounds i8, ptr %arg, i64 %i6
  %i8 = getelementptr inbounds i8, ptr %i7, i64 4001
  %i10 = load i64, ptr %i8, align 8
  %i11 = getelementptr inbounds i8, ptr %i7, i64 4002
  %i13 = load i64, ptr %i11, align 8
  %i14 = getelementptr inbounds i8, ptr %i7, i64 4003
  %i16 = load i64, ptr %i14, align 8
  %i17 = getelementptr inbounds i8, ptr %i7, i64 4006
  %i19 = load i64, ptr %i17, align 8
  %i20 = mul i64 %i13, %i10
  %i21 = mul i64 %i20, %i16
  %i22 = mul i64 %i21, %i19
  %i23 = add i64 %i22, %i5
  %i24 = add nuw i64 %i4, 1
  %i25 = icmp ult i64 %i24, %i
  br i1 %i25, label %bb3, label %bb26

bb26:                                             ; preds = %bb3, %bb
  %i27 = phi i64 [ 0, %bb ], [ %i23, %bb3 ]
  %i28 = add i64 %i27, %i
  ret i64 %i28
}

; test_update_ds_prep_nointeract:
; unsigned long test_update_ds_prep_nointeract(char *p, int count) {
;   unsigned long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4002;
;   int DISP3 = 4003;
;   int DISP4 = 4007;
;   for (; i < count ; i++) {
;     char x1 = *(p + i + DISP1);
;     unsigned long x2 = *(unsigned long *)(p + i + DISP2);
;     unsigned long x3 = *(unsigned long *)(p + i + DISP3);
;     unsigned long x4 = *(unsigned long *)(p + i + DISP4);
;     res += (unsigned long)x1*x2*x3*x4;
;   }
;   return res + count;
; }

define i64 @test_update_ds_prep_nointeract(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_update_ds_prep_nointeract:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB4_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r6, 1
; CHECK-NEXT:    addi r5, r3, 4000
; CHECK-NEXT:    addi r3, r3, 4003
; CHECK-NEXT:    li r7, -1
; CHECK-NEXT:    iselgt r6, r4, r6
; CHECK-NEXT:    mtctr r6
; CHECK-NEXT:    li r6, 0
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB4_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    lbzu r8, 1(r5)
; CHECK-NEXT:    ldx r9, r3, r7
; CHECK-NEXT:    ld r10, 0(r3)
; CHECK-NEXT:    ld r11, 4(r3)
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    mulld r8, r9, r8
; CHECK-NEXT:    mulld r8, r8, r10
; CHECK-NEXT:    maddld r6, r8, r11, r6
; CHECK-NEXT:    bdnz .LBB4_2
; CHECK-NEXT:  # %bb.3: # %bb25
; CHECK-NEXT:    add r3, r6, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB4_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb25, label %bb3

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i23, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i22, %bb3 ], [ 0, %bb ]
  %i6 = getelementptr inbounds i8, ptr %arg, i64 %i4
  %i7 = getelementptr inbounds i8, ptr %i6, i64 4001
  %i8 = load i8, ptr %i7, align 1
  %i9 = getelementptr inbounds i8, ptr %i6, i64 4002
  %i11 = load i64, ptr %i9, align 8
  %i12 = getelementptr inbounds i8, ptr %i6, i64 4003
  %i14 = load i64, ptr %i12, align 8
  %i15 = getelementptr inbounds i8, ptr %i6, i64 4007
  %i17 = load i64, ptr %i15, align 8
  %i18 = zext i8 %i8 to i64
  %i19 = mul i64 %i11, %i18
  %i20 = mul i64 %i19, %i14
  %i21 = mul i64 %i20, %i17
  %i22 = add i64 %i21, %i5
  %i23 = add nuw i64 %i4, 1
  %i24 = icmp ult i64 %i23, %i
  br i1 %i24, label %bb3, label %bb25

bb25:                                             ; preds = %bb3, %bb
  %i26 = phi i64 [ 0, %bb ], [ %i22, %bb3 ]
  %i27 = add i64 %i26, %i
  ret i64 %i27
}

; test_ds_multiple_chains:
; unsigned long test_ds_multiple_chains(char *p, char *q, int count) {
;   unsigned long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4010;
;   int DISP3 = 4005;
;   int DISP4 = 4009;
;   for (; i < count ; i++) {
;     unsigned long x1 = *(unsigned long *)(p + i + DISP1);
;     unsigned long x2 = *(unsigned long *)(p + i + DISP2);
;     unsigned long x3 = *(unsigned long *)(p + i + DISP3);
;     unsigned long x4 = *(unsigned long *)(p + i + DISP4);
;     unsigned long x5 = *(unsigned long *)(q + i + DISP1);
;     unsigned long x6 = *(unsigned long *)(q + i + DISP2);
;     unsigned long x7 = *(unsigned long *)(q + i + DISP3);
;     unsigned long x8 = *(unsigned long *)(q + i + DISP4);
;     res += x1*x2*x3*x4*x5*x6*x7*x8;
;   }
;   return res + count;
; }

define dso_local i64 @test_ds_multiple_chains(ptr %arg, ptr %arg1, i32 signext %arg2) {
; CHECK-LABEL: test_ds_multiple_chains:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r5, 0
; CHECK-NEXT:    beq cr0, .LBB5_4
; CHECK-NEXT:  # %bb.1: # %bb4.preheader
; CHECK-NEXT:    cmpldi r5, 1
; CHECK-NEXT:    li r6, 1
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    addi r3, r3, 4001
; CHECK-NEXT:    addi r4, r4, 4001
; CHECK-NEXT:    li r7, 9
; CHECK-NEXT:    iselgt r6, r5, r6
; CHECK-NEXT:    mtctr r6
; CHECK-NEXT:    li r6, 0
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB5_2: # %bb4
; CHECK-NEXT:    #
; CHECK-NEXT:    ld r8, 0(r3)
; CHECK-NEXT:    ldx r9, r3, r7
; CHECK-NEXT:    ld r10, 4(r3)
; CHECK-NEXT:    ld r11, 8(r3)
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    mulld r8, r9, r8
; CHECK-NEXT:    ld r12, 0(r4)
; CHECK-NEXT:    ldx r0, r4, r7
; CHECK-NEXT:    ld r30, 4(r4)
; CHECK-NEXT:    ld r9, 8(r4)
; CHECK-NEXT:    addi r4, r4, 1
; CHECK-NEXT:    mulld r8, r8, r10
; CHECK-NEXT:    mulld r8, r8, r11
; CHECK-NEXT:    mulld r8, r8, r12
; CHECK-NEXT:    mulld r8, r8, r0
; CHECK-NEXT:    mulld r8, r8, r30
; CHECK-NEXT:    maddld r6, r8, r9, r6
; CHECK-NEXT:    bdnz .LBB5_2
; CHECK-NEXT:  # %bb.3:
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    add r3, r6, r5
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB5_4:
; CHECK-NEXT:    addi r3, r5, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg2 to i64
  %i3 = icmp eq i32 %arg2, 0
  br i1 %i3, label %bb43, label %bb4

bb4:                                              ; preds = %bb4, %bb
  %i5 = phi i64 [ %i41, %bb4 ], [ 0, %bb ]
  %i6 = phi i64 [ %i40, %bb4 ], [ 0, %bb ]
  %i7 = getelementptr inbounds i8, ptr %arg, i64 %i5
  %i8 = getelementptr inbounds i8, ptr %i7, i64 4001
  %i10 = load i64, ptr %i8, align 8
  %i11 = getelementptr inbounds i8, ptr %i7, i64 4010
  %i13 = load i64, ptr %i11, align 8
  %i14 = getelementptr inbounds i8, ptr %i7, i64 4005
  %i16 = load i64, ptr %i14, align 8
  %i17 = getelementptr inbounds i8, ptr %i7, i64 4009
  %i19 = load i64, ptr %i17, align 8
  %i20 = getelementptr inbounds i8, ptr %arg1, i64 %i5
  %i21 = getelementptr inbounds i8, ptr %i20, i64 4001
  %i23 = load i64, ptr %i21, align 8
  %i24 = getelementptr inbounds i8, ptr %i20, i64 4010
  %i26 = load i64, ptr %i24, align 8
  %i27 = getelementptr inbounds i8, ptr %i20, i64 4005
  %i29 = load i64, ptr %i27, align 8
  %i30 = getelementptr inbounds i8, ptr %i20, i64 4009
  %i32 = load i64, ptr %i30, align 8
  %i33 = mul i64 %i13, %i10
  %i34 = mul i64 %i33, %i16
  %i35 = mul i64 %i34, %i19
  %i36 = mul i64 %i35, %i23
  %i37 = mul i64 %i36, %i26
  %i38 = mul i64 %i37, %i29
  %i39 = mul i64 %i38, %i32
  %i40 = add i64 %i39, %i6
  %i41 = add nuw i64 %i5, 1
  %i42 = icmp ult i64 %i41, %i
  br i1 %i42, label %bb4, label %bb43

bb43:                                             ; preds = %bb4, %bb
  %i44 = phi i64 [ 0, %bb ], [ %i40, %bb4 ]
  %i45 = add i64 %i44, %i
  ret i64 %i45
}

; test_ds_cross_basic_blocks:
;extern char *arr;
;unsigned long foo(char *p, int count)
;{
;  unsigned long i=0, res=0;
;  int DISP1 = 4000;
;  int DISP2 = 4001;
;  int DISP3 = 4002;
;  int DISP4 = 4003;
;  int DISP5 = 4005;
;  int DISP6 = 4009;
;  unsigned long x1, x2, x3, x4, x5, x6;
;  x1=x2=x3=x4=x5=x6=1;
;  for (; i < count ; i++) {
;    if (arr[i] % 3 == 1) {
;      x1 += *(unsigned long *)(p + i + DISP1);
;      x2 += *(unsigned long *)(p + i + DISP2);
;    }
;    else if (arr[i] % 3 == 2) {
;      x3 += *(unsigned long *)(p + i + DISP3);
;      x4 += *(unsigned long *)(p + i + DISP5);
;    }
;    else {
;      x5 += *(unsigned long *)(p + i + DISP4);
;      x6 += *(unsigned long *)(p + i + DISP6);
;    }
;    res += x1*x2*x3*x4*x5*x6;
;  }
;  return res;
;}

@arr = external local_unnamed_addr global ptr, align 8

define i64 @test_ds_cross_basic_blocks(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_ds_cross_basic_blocks:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmplwi r4, 0
; CHECK-NEXT:    beq cr0, .LBB6_9
; CHECK-NEXT:  # %bb.1: # %bb3
; CHECK-NEXT:    addis r5, r2, .LC0@toc@ha
; CHECK-NEXT:    cmpldi r4, 1
; CHECK-NEXT:    li r7, 1
; CHECK-NEXT:    addi r6, r3, 4009
; CHECK-NEXT:    std r28, -32(r1) # 8-byte Folded Spill
; CHECK-NEXT:    ld r5, .LC0@toc@l(r5)
; CHECK-NEXT:    iselgt r3, r4, r7
; CHECK-NEXT:    std r29, -24(r1) # 8-byte Folded Spill
; CHECK-NEXT:    std r30, -16(r1) # 8-byte Folded Spill
; CHECK-NEXT:    li r4, -7
; CHECK-NEXT:    li r8, -6
; CHECK-NEXT:    li r9, 1
; CHECK-NEXT:    li r10, 1
; CHECK-NEXT:    li r11, 1
; CHECK-NEXT:    li r12, 1
; CHECK-NEXT:    li r30, 1
; CHECK-NEXT:    ld r5, 0(r5)
; CHECK-NEXT:    mtctr r3
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    addi r5, r5, -1
; CHECK-NEXT:    b .LBB6_4
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB6_2: # %bb18
; CHECK-NEXT:    #
; CHECK-NEXT:    addi r29, r6, -9
; CHECK-NEXT:    ld r0, 0(r29)
; CHECK-NEXT:    add r30, r0, r30
; CHECK-NEXT:    ld r0, -8(r6)
; CHECK-NEXT:    add r12, r0, r12
; CHECK-NEXT:  .LBB6_3: # %bb49
; CHECK-NEXT:    #
; CHECK-NEXT:    mulld r0, r12, r30
; CHECK-NEXT:    addi r6, r6, 1
; CHECK-NEXT:    mulld r0, r0, r11
; CHECK-NEXT:    mulld r0, r0, r10
; CHECK-NEXT:    mulld r0, r0, r9
; CHECK-NEXT:    maddld r3, r0, r7, r3
; CHECK-NEXT:    bdz .LBB6_8
; CHECK-NEXT:  .LBB6_4: # %bb5
; CHECK-NEXT:    #
; CHECK-NEXT:    lbzu r0, 1(r5)
; CHECK-NEXT:    mulli r29, r0, 171
; CHECK-NEXT:    rlwinm r28, r29, 24, 8, 30
; CHECK-NEXT:    srwi r29, r29, 9
; CHECK-NEXT:    add r29, r29, r28
; CHECK-NEXT:    sub r0, r0, r29
; CHECK-NEXT:    clrlwi r0, r0, 24
; CHECK-NEXT:    cmplwi r0, 1
; CHECK-NEXT:    beq cr0, .LBB6_2
; CHECK-NEXT:  # %bb.5: # %bb28
; CHECK-NEXT:    #
; CHECK-NEXT:    cmplwi r0, 2
; CHECK-NEXT:    bne cr0, .LBB6_7
; CHECK-NEXT:  # %bb.6: # %bb31
; CHECK-NEXT:    #
; CHECK-NEXT:    ldx r0, r6, r4
; CHECK-NEXT:    add r11, r0, r11
; CHECK-NEXT:    ld r0, -4(r6)
; CHECK-NEXT:    add r10, r0, r10
; CHECK-NEXT:    b .LBB6_3
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB6_7: # %bb40
; CHECK-NEXT:    #
; CHECK-NEXT:    ldx r0, r6, r8
; CHECK-NEXT:    add r9, r0, r9
; CHECK-NEXT:    ld r0, 0(r6)
; CHECK-NEXT:    add r7, r0, r7
; CHECK-NEXT:    b .LBB6_3
; CHECK-NEXT:  .LBB6_8:
; CHECK-NEXT:    ld r30, -16(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r29, -24(r1) # 8-byte Folded Reload
; CHECK-NEXT:    ld r28, -32(r1) # 8-byte Folded Reload
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB6_9:
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp eq i32 %arg1, 0
  br i1 %i2, label %bb64, label %bb3

bb3:                                              ; preds = %bb
  %i4 = load ptr, ptr @arr, align 8
  br label %bb5

bb5:                                              ; preds = %bb49, %bb3
  %i6 = phi i64 [ 1, %bb3 ], [ %i55, %bb49 ]
  %i7 = phi i64 [ 1, %bb3 ], [ %i54, %bb49 ]
  %i8 = phi i64 [ 1, %bb3 ], [ %i53, %bb49 ]
  %i9 = phi i64 [ 1, %bb3 ], [ %i52, %bb49 ]
  %i10 = phi i64 [ 1, %bb3 ], [ %i51, %bb49 ]
  %i11 = phi i64 [ 1, %bb3 ], [ %i50, %bb49 ]
  %i12 = phi i64 [ 0, %bb3 ], [ %i62, %bb49 ]
  %i13 = phi i64 [ 0, %bb3 ], [ %i61, %bb49 ]
  %i14 = getelementptr inbounds i8, ptr %i4, i64 %i12
  %i15 = load i8, ptr %i14, align 1
  %i16 = urem i8 %i15, 3
  %i17 = icmp eq i8 %i16, 1
  br i1 %i17, label %bb18, label %bb28

bb18:                                             ; preds = %bb5
  %i19 = getelementptr inbounds i8, ptr %arg, i64 %i12
  %i20 = getelementptr inbounds i8, ptr %i19, i64 4000
  %i22 = load i64, ptr %i20, align 8
  %i23 = add i64 %i22, %i11
  %i24 = getelementptr inbounds i8, ptr %i19, i64 4001
  %i26 = load i64, ptr %i24, align 8
  %i27 = add i64 %i26, %i10
  br label %bb49

bb28:                                             ; preds = %bb5
  %i29 = icmp eq i8 %i16, 2
  %i30 = getelementptr inbounds i8, ptr %arg, i64 %i12
  br i1 %i29, label %bb31, label %bb40

bb31:                                             ; preds = %bb28
  %i32 = getelementptr inbounds i8, ptr %i30, i64 4002
  %i34 = load i64, ptr %i32, align 8
  %i35 = add i64 %i34, %i9
  %i36 = getelementptr inbounds i8, ptr %i30, i64 4005
  %i38 = load i64, ptr %i36, align 8
  %i39 = add i64 %i38, %i8
  br label %bb49

bb40:                                             ; preds = %bb28
  %i41 = getelementptr inbounds i8, ptr %i30, i64 4003
  %i43 = load i64, ptr %i41, align 8
  %i44 = add i64 %i43, %i7
  %i45 = getelementptr inbounds i8, ptr %i30, i64 4009
  %i47 = load i64, ptr %i45, align 8
  %i48 = add i64 %i47, %i6
  br label %bb49

bb49:                                             ; preds = %bb40, %bb31, %bb18
  %i50 = phi i64 [ %i23, %bb18 ], [ %i11, %bb31 ], [ %i11, %bb40 ]
  %i51 = phi i64 [ %i27, %bb18 ], [ %i10, %bb31 ], [ %i10, %bb40 ]
  %i52 = phi i64 [ %i9, %bb18 ], [ %i35, %bb31 ], [ %i9, %bb40 ]
  %i53 = phi i64 [ %i8, %bb18 ], [ %i39, %bb31 ], [ %i8, %bb40 ]
  %i54 = phi i64 [ %i7, %bb18 ], [ %i7, %bb31 ], [ %i44, %bb40 ]
  %i55 = phi i64 [ %i6, %bb18 ], [ %i6, %bb31 ], [ %i48, %bb40 ]
  %i56 = mul i64 %i51, %i50
  %i57 = mul i64 %i56, %i52
  %i58 = mul i64 %i57, %i53
  %i59 = mul i64 %i58, %i54
  %i60 = mul i64 %i59, %i55
  %i61 = add i64 %i60, %i13
  %i62 = add nuw i64 %i12, 1
  %i63 = icmp ult i64 %i62, %i
  br i1 %i63, label %bb5, label %bb64

bb64:                                             ; preds = %bb49, %bb
  %i65 = phi i64 [ 0, %bb ], [ %i61, %bb49 ]
  ret i64 %i65
}

; test_ds_float:
;float test_ds_float(char *p, int count) {
;  int i=0 ;
;  float res=0;
;  int DISP1 = 4001;
;  int DISP2 = 4002;
;  int DISP3 = 4022;
;  int DISP4 = 4062;
;  for (; i < count ; i++) {
;    float x1 = *(float *)(p + i + DISP1);
;    float x2 = *(float *)(p + i + DISP2);
;    float x3 = *(float *)(p + i + DISP3);
;    float x4 = *(float *)(p + i + DISP4);
;    res += x1*x2*x3*x4;
;  }
;  return res;
;}

define float @test_ds_float(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_ds_float:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmpwi r4, 0
; CHECK-NEXT:    ble cr0, .LBB7_4
; CHECK-NEXT:  # %bb.1: # %bb2
; CHECK-NEXT:    clrldi r4, r4, 32
; CHECK-NEXT:    addi r3, r3, 4002
; CHECK-NEXT:    xxlxor f1, f1, f1
; CHECK-NEXT:    mtctr r4
; CHECK-NEXT:    li r4, -1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB7_2: # %bb4
; CHECK-NEXT:    #
; CHECK-NEXT:    lfsx f0, r3, r4
; CHECK-NEXT:    lfs f2, 0(r3)
; CHECK-NEXT:    xsmulsp f0, f0, f2
; CHECK-NEXT:    lfs f3, 20(r3)
; CHECK-NEXT:    xsmulsp f0, f0, f3
; CHECK-NEXT:    lfs f4, 60(r3)
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    xsmulsp f0, f0, f4
; CHECK-NEXT:    xsaddsp f1, f1, f0
; CHECK-NEXT:    bdnz .LBB7_2
; CHECK-NEXT:  # %bb.3: # %bb26
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB7_4:
; CHECK-NEXT:    xxlxor f1, f1, f1
; CHECK-NEXT:    blr
bb:
  %i = icmp sgt i32 %arg1, 0
  br i1 %i, label %bb2, label %bb26

bb2:                                              ; preds = %bb
  %i3 = zext i32 %arg1 to i64
  br label %bb4

bb4:                                              ; preds = %bb4, %bb2
  %i5 = phi i64 [ 0, %bb2 ], [ %i24, %bb4 ]
  %i6 = phi float [ 0.000000e+00, %bb2 ], [ %i23, %bb4 ]
  %i7 = getelementptr inbounds i8, ptr %arg, i64 %i5
  %i8 = getelementptr inbounds i8, ptr %i7, i64 4001
  %i10 = load float, ptr %i8, align 4
  %i11 = getelementptr inbounds i8, ptr %i7, i64 4002
  %i13 = load float, ptr %i11, align 4
  %i14 = getelementptr inbounds i8, ptr %i7, i64 4022
  %i16 = load float, ptr %i14, align 4
  %i17 = getelementptr inbounds i8, ptr %i7, i64 4062
  %i19 = load float, ptr %i17, align 4
  %i20 = fmul float %i10, %i13
  %i21 = fmul float %i20, %i16
  %i22 = fmul float %i21, %i19
  %i23 = fadd float %i6, %i22
  %i24 = add nuw nsw i64 %i5, 1
  %i25 = icmp eq i64 %i24, %i3
  br i1 %i25, label %bb26, label %bb4

bb26:                                             ; preds = %bb4, %bb
  %i27 = phi float [ 0.000000e+00, %bb ], [ %i23, %bb4 ]
  ret float %i27
}

; test_ds_combine_float_int:
;float test_ds_combine_float_int(char *p, int count) {
;  int i=0 ;
;  float res=0;
;  int DISP1 = 4001;
;  int DISP2 = 4002;
;  int DISP3 = 4022;
;  int DISP4 = 4062;
;  for (; i < count ; i++) {
;    float x1 = *(float *)(p + i + DISP1);
;    unsigned long x2 = *(unsigned long*)(p + i + DISP2);
;    float x3 = *(float *)(p + i + DISP3);
;    float x4 = *(float *)(p + i + DISP4);
;    res += x1*x2*x3*x4;
;  }
;  return res;
;}

define float @test_ds_combine_float_int(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_ds_combine_float_int:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmpwi r4, 0
; CHECK-NEXT:    ble cr0, .LBB8_4
; CHECK-NEXT:  # %bb.1: # %bb2
; CHECK-NEXT:    clrldi r4, r4, 32
; CHECK-NEXT:    addi r3, r3, 4002
; CHECK-NEXT:    xxlxor f1, f1, f1
; CHECK-NEXT:    mtctr r4
; CHECK-NEXT:    li r4, -1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB8_2: # %bb4
; CHECK-NEXT:    #
; CHECK-NEXT:    lfd f4, 0(r3)
; CHECK-NEXT:    lfsx f0, r3, r4
; CHECK-NEXT:    xscvuxdsp f4, f4
; CHECK-NEXT:    lfs f2, 20(r3)
; CHECK-NEXT:    lfs f3, 60(r3)
; CHECK-NEXT:    addi r3, r3, 1
; CHECK-NEXT:    xsmulsp f0, f0, f4
; CHECK-NEXT:    xsmulsp f0, f2, f0
; CHECK-NEXT:    xsmulsp f0, f3, f0
; CHECK-NEXT:    xsaddsp f1, f1, f0
; CHECK-NEXT:    bdnz .LBB8_2
; CHECK-NEXT:  # %bb.3: # %bb27
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB8_4:
; CHECK-NEXT:    xxlxor f1, f1, f1
; CHECK-NEXT:    blr
bb:
  %i = icmp sgt i32 %arg1, 0
  br i1 %i, label %bb2, label %bb27

bb2:                                              ; preds = %bb
  %i3 = zext i32 %arg1 to i64
  br label %bb4

bb4:                                              ; preds = %bb4, %bb2
  %i5 = phi i64 [ 0, %bb2 ], [ %i25, %bb4 ]
  %i6 = phi float [ 0.000000e+00, %bb2 ], [ %i24, %bb4 ]
  %i7 = getelementptr inbounds i8, ptr %arg, i64 %i5
  %i8 = getelementptr inbounds i8, ptr %i7, i64 4001
  %i10 = load float, ptr %i8, align 4
  %i11 = getelementptr inbounds i8, ptr %i7, i64 4002
  %i13 = load i64, ptr %i11, align 8
  %i14 = getelementptr inbounds i8, ptr %i7, i64 4022
  %i16 = load float, ptr %i14, align 4
  %i17 = getelementptr inbounds i8, ptr %i7, i64 4062
  %i19 = load float, ptr %i17, align 4
  %i20 = uitofp i64 %i13 to float
  %i21 = fmul float %i10, %i20
  %i22 = fmul float %i16, %i21
  %i23 = fmul float %i19, %i22
  %i24 = fadd float %i6, %i23
  %i25 = add nuw nsw i64 %i5, 1
  %i26 = icmp eq i64 %i25, %i3
  br i1 %i26, label %bb27, label %bb4

bb27:                                             ; preds = %bb4, %bb
  %i28 = phi float [ 0.000000e+00, %bb ], [ %i24, %bb4 ]
  ret float %i28
}

; test_ds_lwa_prep:
; long long test_ds_lwa_prep(char *p, int count) {
;   long long i=0, res=0;
;   int DISP1 = 4001;
;   int DISP2 = 4002;
;   int DISP3 = 4006;
;   int DISP4 = 4010;
;   for (; i < count ; i++) {
;     long long x1 = *(int *)(p + i + DISP1);
;     long long x2 = *(int *)(p + i + DISP2);
;     long long x3 = *(int *)(p + i + DISP3);
;     long long x4 = *(int *)(p + i + DISP4);
;     res += x1*x2*x3*x4;
;   }
;   return res + count;
; }

define i64 @test_ds_lwa_prep(ptr %arg, i32 signext %arg1) {
; CHECK-LABEL: test_ds_lwa_prep:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    cmpwi r4, 0
; CHECK-NEXT:    ble cr0, .LBB9_4
; CHECK-NEXT:  # %bb.1: # %bb3.preheader
; CHECK-NEXT:    mtctr r4
; CHECK-NEXT:    addi r5, r3, 2
; CHECK-NEXT:    li r3, 0
; CHECK-NEXT:    li r6, -1
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  .LBB9_2: # %bb3
; CHECK-NEXT:    #
; CHECK-NEXT:    lwax r7, r5, r6
; CHECK-NEXT:    lwa r8, 0(r5)
; CHECK-NEXT:    lwa r9, 4(r5)
; CHECK-NEXT:    lwa r10, 8(r5)
; CHECK-NEXT:    addi r5, r5, 1
; CHECK-NEXT:    mulld r7, r8, r7
; CHECK-NEXT:    mulld r7, r7, r9
; CHECK-NEXT:    maddld r3, r7, r10, r3
; CHECK-NEXT:    bdnz .LBB9_2
; CHECK-NEXT:  # %bb.3: # %bb29
; CHECK-NEXT:    add r3, r3, r4
; CHECK-NEXT:    blr
; CHECK-NEXT:  .LBB9_4:
; CHECK-NEXT:    addi r3, r4, 0
; CHECK-NEXT:    blr
bb:
  %i = sext i32 %arg1 to i64
  %i2 = icmp sgt i32 %arg1, 0
  br i1 %i2, label %bb3, label %bb29

bb3:                                              ; preds = %bb3, %bb
  %i4 = phi i64 [ %i27, %bb3 ], [ 0, %bb ]
  %i5 = phi i64 [ %i26, %bb3 ], [ 0, %bb ]
  %i6 = getelementptr inbounds i8, ptr %arg, i64 %i4
  %i7 = getelementptr inbounds i8, ptr %i6, i64 1
  %i9 = load i32, ptr %i7, align 4
  %i10 = sext i32 %i9 to i64
  %i11 = getelementptr inbounds i8, ptr %i6, i64 2
  %i13 = load i32, ptr %i11, align 4
  %i14 = sext i32 %i13 to i64
  %i15 = getelementptr inbounds i8, ptr %i6, i64 6
  %i17 = load i32, ptr %i15, align 4
  %i18 = sext i32 %i17 to i64
  %i19 = getelementptr inbounds i8, ptr %i6, i64 10
  %i21 = load i32, ptr %i19, align 4
  %i22 = sext i32 %i21 to i64
  %i23 = mul nsw i64 %i14, %i10
  %i24 = mul nsw i64 %i23, %i18
  %i25 = mul nsw i64 %i24, %i22
  %i26 = add nsw i64 %i25, %i5
  %i27 = add nuw nsw i64 %i4, 1
  %i28 = icmp eq i64 %i27, %i
  br i1 %i28, label %bb29, label %bb3

bb29:                                             ; preds = %bb3, %bb
  %i30 = phi i64 [ 0, %bb ], [ %i26, %bb3 ]
  %i31 = add nsw i64 %i30, %i
  ret i64 %i31
}

