; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=slp-vectorizer -mtriple=x86_64-apple-macosx -mattr=+avx2 < %s | FileCheck %s

define i64 @foo(i32 %tmp7) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <4 x i32> <i32 0, i32 0, i32 poison, i32 0>, i32 [[TMP7:%.*]], i32 2
; CHECK-NEXT:    [[TMP1:%.*]] = sub <4 x i32> [[TMP0]], zeroinitializer
; CHECK-NEXT:    [[TMP24:%.*]] = sub i32 undef, 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 poison, i32 poison, i32 undef, i32 0>, i32 [[TMP24]], i32 4
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <8 x i32> [[TMP2]], i32 0, i32 5
; CHECK-NEXT:    [[TMP4:%.*]] = shufflevector <4 x i32> [[TMP1]], <4 x i32> poison, <8 x i32> <i32 0, i32 1, i32 poison, i32 2, i32 3, i32 poison, i32 poison, i32 poison>
; CHECK-NEXT:    [[TMP5:%.*]] = insertelement <8 x i32> [[TMP4]], i32 [[TMP24]], i32 6
; CHECK-NEXT:    [[TMP6:%.*]] = sub nsw <8 x i32> [[TMP3]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <8 x i32> [[TMP3]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <8 x i32> [[TMP6]], <8 x i32> [[TMP7]], <8 x i32> <i32 0, i32 9, i32 2, i32 3, i32 12, i32 13, i32 6, i32 7>
; CHECK-NEXT:    [[TMP9:%.*]] = add <8 x i32> zeroinitializer, [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = xor <8 x i32> [[TMP9]], zeroinitializer
; CHECK-NEXT:    [[TMP11:%.*]] = call i32 @llvm.vector.reduce.add.v8i32(<8 x i32> [[TMP10]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = add i32 [[TMP11]], 0
; CHECK-NEXT:    [[TMP64:%.*]] = zext i32 [[OP_RDX]] to i64
; CHECK-NEXT:    ret i64 [[TMP64]]
;
bb:
  %tmp = sub i32 0, 0
  %tmp2 = sub nsw i32 0, %tmp
  %tmp3 = add i32 0, %tmp2
  %tmp4 = xor i32 %tmp3, 0
  %tmp6 = sub i32 0, 0
  %tmp8 = sub i32 %tmp7, 0
  %tmp9 = sub nsw i32 0, undef
  %tmp10 = add nsw i32 0, %tmp6
  %tmp11 = sub nsw i32 0, %tmp8
  %tmp12 = add i32 0, %tmp10
  %tmp13 = xor i32 %tmp12, 0
  %tmp14 = add i32 0, %tmp9
  %tmp15 = xor i32 %tmp14, 0
  %tmp16 = add i32 0, %tmp11
  %tmp17 = xor i32 %tmp16, 0
  %tmp18 = add i32 %tmp13, %tmp4
  %tmp19 = add i32 %tmp18, 0
  %tmp20 = add i32 %tmp19, %tmp15
  %tmp21 = add i32 %tmp20, %tmp17
  %tmp22 = sub i32 0, 0
  %tmp23 = add i32 0, 0
  %tmp24 = sub i32 undef, 0
  %tmp25 = add nsw i32 %tmp23, undef
  %tmp26 = add nsw i32 %tmp24, %tmp22
  %tmp27 = sub nsw i32 undef, %tmp24
  %tmp28 = add i32 0, %tmp25
  %tmp29 = xor i32 %tmp28, 0
  %tmp30 = add i32 0, %tmp26
  %tmp31 = xor i32 %tmp30, 0
  %tmp32 = add i32 0, %tmp27
  %tmp33 = xor i32 %tmp32, 0
  %tmp34 = add i32 %tmp31, %tmp21
  %tmp35 = add i32 %tmp34, %tmp29
  %tmp36 = add i32 %tmp35, 0
  %tmp37 = add i32 %tmp36, %tmp33
  %tmp38 = sub nsw i32 0, undef
  %tmp39 = add i32 0, %tmp38
  %tmp40 = xor i32 %tmp39, 0
  %tmp41 = add i32 0, %tmp37
  %tmp42 = add i32 %tmp41, 0
  %tmp43 = add i32 %tmp42, %tmp40
  %tmp64 = zext i32 %tmp43 to i64
  ret i64 %tmp64
}