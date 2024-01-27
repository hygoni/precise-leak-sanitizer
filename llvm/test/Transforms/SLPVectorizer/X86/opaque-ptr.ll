; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=slp-vectorizer -mtriple=x86_64-apple-macosx -mcpu=haswell < %s | FileCheck %s

define void @test(ptr %r, ptr %p, ptr %q) #0 {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[P0:%.*]] = getelementptr inbounds i64, ptr [[P:%.*]], i64 0
; CHECK-NEXT:    [[Q0:%.*]] = getelementptr inbounds i64, ptr [[Q:%.*]], i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = load <4 x i64>, ptr [[P0]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = load <4 x i64>, ptr [[Q0]], align 2
; CHECK-NEXT:    [[TMP3:%.*]] = sub nsw <4 x i64> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x i64> [[TMP3]], i32 0
; CHECK-NEXT:    [[G0:%.*]] = getelementptr inbounds i32, ptr [[R:%.*]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i64> [[TMP3]], i32 1
; CHECK-NEXT:    [[G1:%.*]] = getelementptr inbounds i32, ptr [[R]], i64 [[TMP5]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i64> [[TMP3]], i32 2
; CHECK-NEXT:    [[G2:%.*]] = getelementptr inbounds i32, ptr [[R]], i64 [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i64> [[TMP3]], i32 3
; CHECK-NEXT:    [[G3:%.*]] = getelementptr inbounds i32, ptr [[R]], i64 [[TMP7]]
; CHECK-NEXT:    ret void
;
  %p0 = getelementptr inbounds i64, ptr %p, i64 0
  %p1 = getelementptr inbounds i64, ptr %p, i64 1
  %p2 = getelementptr inbounds i64, ptr %p, i64 2
  %p3 = getelementptr inbounds i64, ptr %p, i64 3

  %q0 = getelementptr inbounds i64, ptr %q, i64 0
  %q1 = getelementptr inbounds i64, ptr %q, i64 1
  %q2 = getelementptr inbounds i64, ptr %q, i64 2
  %q3 = getelementptr inbounds i64, ptr %q, i64 3

  %x0 = load i64, ptr %p0, align 2
  %x1 = load i64, ptr %p1, align 2
  %x2 = load i64, ptr %p2, align 2
  %x3 = load i64, ptr %p3, align 2

  %y0 = load i64, ptr %q0, align 2
  %y1 = load i64, ptr %q1, align 2
  %y2 = load i64, ptr %q2, align 2
  %y3 = load i64, ptr %q3, align 2

  %sub0 = sub nsw i64 %x0, %y0
  %sub1 = sub nsw i64 %x1, %y1
  %sub2 = sub nsw i64 %x2, %y2
  %sub3 = sub nsw i64 %x3, %y3

  %g0 = getelementptr inbounds i32, ptr %r, i64 %sub0
  %g1 = getelementptr inbounds i32, ptr %r, i64 %sub1
  %g2 = getelementptr inbounds i32, ptr %r, i64 %sub2
  %g3 = getelementptr inbounds i32, ptr %r, i64 %sub3
  ret void
}

define void @test2(i64* %a, i64* %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <2 x ptr> poison, ptr [[A:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <2 x ptr> [[TMP1]], ptr [[B:%.*]], i32 1
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr i64, <2 x ptr> [[TMP2]], <2 x i64> <i64 1, i64 3>
; CHECK-NEXT:    [[TMP4:%.*]] = ptrtoint <2 x ptr> [[TMP3]] to <2 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x ptr> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = load <2 x i64>, ptr [[TMP5]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = add <2 x i64> [[TMP4]], [[TMP6]]
; CHECK-NEXT:    store <2 x i64> [[TMP7]], ptr [[TMP5]], align 8
; CHECK-NEXT:    ret void
;
  %a1 = getelementptr inbounds i64, i64* %a, i64 1
  %a2 = getelementptr inbounds i64, i64* %a, i64 2
  %i1 = ptrtoint i64* %a1 to i64
  %b3 = getelementptr inbounds i64, i64* %b, i64 3
  %i2 = ptrtoint i64* %b3 to i64
  %v1 = load i64, i64* %a1, align 8
  %v2 = load i64, i64* %a2, align 8
  %add1 = add i64 %i1, %v1
  %add2 = add i64 %i2, %v2
  store i64 %add1, i64* %a1, align 8
  store i64 %add2, i64* %a2, align 8
  ret void
}
