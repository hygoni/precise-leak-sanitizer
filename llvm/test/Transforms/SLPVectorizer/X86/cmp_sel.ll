; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=slp-vectorizer,dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

; int foo(ptr restrict A, ptr restrict B, double G) {
;   A[0] = (B[10] ? G : 1);
;   A[1] = (B[11] ? G : 1);
; }

define i32 @foo(ptr noalias nocapture %A, ptr noalias nocapture %B, double %G) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, ptr [[B:%.*]], i64 10
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = fcmp une <2 x double> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[TMP3:%.*]] = insertelement <2 x double> poison, double [[G:%.*]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x double> [[TMP3]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = select <2 x i1> [[TMP2]], <2 x double> [[SHUFFLE]], <2 x double> <double 1.000000e+00, double 1.000000e+00>
; CHECK-NEXT:    store <2 x double> [[TMP4]], ptr [[A:%.*]], align 8
; CHECK-NEXT:    ret i32 undef
;
entry:
  %arrayidx = getelementptr inbounds double, ptr %B, i64 10
  %0 = load double, ptr %arrayidx, align 8
  %tobool = fcmp une double %0, 0.000000e+00
  %cond = select i1 %tobool, double %G, double 1.000000e+00
  store double %cond, ptr %A, align 8
  %arrayidx2 = getelementptr inbounds double, ptr %B, i64 11
  %1 = load double, ptr %arrayidx2, align 8
  %tobool3 = fcmp une double %1, 0.000000e+00
  %cond7 = select i1 %tobool3, double %G, double 1.000000e+00
  %arrayidx8 = getelementptr inbounds double, ptr %A, i64 1
  store double %cond7, ptr %arrayidx8, align 8
  ret i32 undef
}

