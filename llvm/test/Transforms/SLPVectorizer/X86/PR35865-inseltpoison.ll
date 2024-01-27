; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=slp-vectorizer < %s -S -o - -mtriple=x86_64-apple-macosx10.10.0 -mcpu=core2 | FileCheck %s

define void @test(<16 x half> %v) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x half> [[V:%.*]], <16 x half> poison, <2 x i32> <i32 4, i32 5>
; CHECK-NEXT:    [[TMP1:%.*]] = fpext <2 x half> [[TMP0]] to <2 x float>
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast <2 x float> [[TMP1]] to <2 x i32>
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x i32> [[TMP2]], <2 x i32> poison, <8 x i32> <i32 0, i32 1, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison, i32 poison>
; CHECK-NEXT:    [[VECINS_I_5_I1:%.*]] = shufflevector <8 x i32> [[TMP3]], <8 x i32> poison, <8 x i32> <i32 poison, i32 poison, i32 poison, i32 poison, i32 0, i32 1, i32 poison, i32 poison>
; CHECK-NEXT:    ret void
;
entry:
  %0 = extractelement <16 x half> %v, i32 4
  %conv.i.4.i = fpext half %0 to float
  %1 = bitcast float %conv.i.4.i to i32
  %vecins.i.4.i = insertelement <8 x i32> poison, i32 %1, i32 4
  %2 = extractelement <16 x half> %v, i32 5
  %conv.i.5.i = fpext half %2 to float
  %3 = bitcast float %conv.i.5.i to i32
  %vecins.i.5.i = insertelement <8 x i32> %vecins.i.4.i, i32 %3, i32 5
  ret void
}
