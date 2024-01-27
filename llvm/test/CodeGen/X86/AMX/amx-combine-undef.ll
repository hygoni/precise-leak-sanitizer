; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt --codegen-opt-level=2 -mtriple=x86_64 -lower-amx-type %s -S | FileCheck %s

define void @undef_2phi(ptr%buf) {
; CHECK-LABEL: @undef_2phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[L3:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[TMP1:%.*]] = phi x86_amx [ [[TMP0]], [[ENTRY:%.*]] ], [ [[T1]], [[L1]] ]
; CHECK-NEXT:    br i1 undef, label [[L3]], label [[EXIT:%.*]]
; CHECK:       l3:
; CHECK-NEXT:    [[TMP2:%.*]] = phi x86_amx [ [[TMP1]], [[L2]] ], [ [[T1]], [[L1]] ]
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr [[BUF:%.*]], i64 1024, x86_amx [[TMP2]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %l3

l2:
  %t3 = phi <256 x i32> [ undef, %entry ], [ %t2, %l1 ]
  br i1 undef, label %l3, label %exit

l3:
  %t4 = phi <256 x i32> [ %t3, %l2], [ %t2, %l1 ]
  %t5 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t4)
  call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr %buf, i64 1024, x86_amx %t5)
  br label %exit

exit:
  ret void
}

define void @foo_undef(ptr%buf) {
; CHECK-LABEL: @foo_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[TMP1:%.*]] = phi x86_amx [ [[TMP0]], [[ENTRY:%.*]] ], [ [[T1]], [[L1]] ]
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr [[BUF:%.*]], i64 1024, x86_amx [[TMP1]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ undef, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr %buf, i64 1024, x86_amx %t4)
  br label %exit

exit:
  ret void
}

define void @foo_zero(ptr%buf) {
; CHECK-LABEL: @foo_zero(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[TMP1:%.*]] = phi x86_amx [ [[TMP0]], [[ENTRY:%.*]] ], [ [[T1]], [[L1]] ]
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr [[BUF:%.*]], i64 1024, x86_amx [[TMP1]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ zeroinitializer, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr %buf, i64 1024, x86_amx %t4)
  br label %exit

exit:
  ret void
}

define void @foo_vrow(ptr%buf, i16 %row) {
; CHECK-LABEL: @foo_vrow(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 [[ROW:%.*]], i16 32)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[ROW]], i16 32, ptr [[TMP1]], i64 32, x86_amx [[T1]])
; CHECK-NEXT:    [[TMP3:%.*]] = load <256 x i32>, ptr [[TMP1]], align 1024
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[T3:%.*]] = phi <256 x i32> [ undef, [[ENTRY:%.*]] ], [ [[TMP3]], [[L1]] ]
; CHECK-NEXT:    store <256 x i32> [[T3]], ptr [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP5:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 [[ROW]], i16 32, ptr [[TMP0]], i64 32)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 [[ROW]], i16 32, ptr [[BUF:%.*]], i64 1024, x86_amx [[TMP5]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 %row, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ undef, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  call void @llvm.x86.tilestored64.internal(i16 %row, i16 32, ptr %buf, i64 1024, x86_amx %t4)
  br label %exit

exit:
  ret void
}

define void @foo_vcol(ptr%buf, i16 %col) {
; CHECK-LABEL: @foo_vcol(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    [[TMP1:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 [[COL:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = sext i16 [[COL]] to i64
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 [[COL]], ptr [[TMP1]], i64 [[TMP3]], x86_amx [[T1]])
; CHECK-NEXT:    [[TMP4:%.*]] = load <256 x i32>, ptr [[TMP1]], align 1024
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[T3:%.*]] = phi <256 x i32> [ zeroinitializer, [[ENTRY:%.*]] ], [ [[TMP4]], [[L1]] ]
; CHECK-NEXT:    store <256 x i32> [[T3]], ptr [[TMP0]], align 1024
; CHECK-NEXT:    [[TMP6:%.*]] = sext i16 [[COL]] to i64
; CHECK-NEXT:    [[TMP7:%.*]] = call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 [[COL]], ptr [[TMP0]], i64 [[TMP6]])
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 [[COL]], ptr [[BUF:%.*]], i64 1024, x86_amx [[TMP7]])
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 %col)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ zeroinitializer, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  call void @llvm.x86.tilestored64.internal(i16 8, i16 %col, ptr %buf, i64 1024, x86_amx %t4)
  br label %exit

exit:
  ret void
}

define void @noshape(ptr%buf) {
; CHECK-LABEL: @noshape(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr [[TMP0]], i64 32, x86_amx [[T1]])
; CHECK-NEXT:    [[TMP2:%.*]] = load <256 x i32>, ptr [[TMP0]], align 1024
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[T3:%.*]] = phi <256 x i32> [ undef, [[ENTRY:%.*]] ], [ [[TMP2]], [[L1]] ]
; CHECK-NEXT:    store <256 x i32> [[T3]], ptr [[BUF:%.*]], align 1024
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ undef, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  %t5 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t4)
  store <256 x i32> %t5, ptr %buf
  br label %exit

exit:
  ret void
}

define void @noshape2(ptr%buf) {
; CHECK-LABEL: @noshape2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca <256 x i32>, align 64
; CHECK-NEXT:    br i1 undef, label [[L1:%.*]], label [[L2:%.*]]
; CHECK:       l1:
; CHECK-NEXT:    [[T1:%.*]] = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
; CHECK-NEXT:    call void @llvm.x86.tilestored64.internal(i16 8, i16 32, ptr [[TMP0]], i64 32, x86_amx [[T1]])
; CHECK-NEXT:    [[TMP2:%.*]] = load <256 x i32>, ptr [[TMP0]], align 1024
; CHECK-NEXT:    br i1 undef, label [[L2]], label [[EXIT:%.*]]
; CHECK:       l2:
; CHECK-NEXT:    [[T3:%.*]] = phi <256 x i32> [ undef, [[ENTRY:%.*]] ], [ [[TMP2]], [[L1]] ]
; CHECK-NEXT:    [[T6:%.*]] = call <256 x i32> @llvm.abs.v256i32(<256 x i32> [[T3]], i1 true)
; CHECK-NEXT:    store <256 x i32> [[T6]], ptr [[BUF:%.*]], align 1024
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br i1 undef, label %l1, label %l2

l1:
  %t1 = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 32)
  %t2 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t1)
  br i1 undef, label %l2, label %exit

l2:
  %t3 = phi <256 x i32> [ undef, %entry ], [ %t2, %l1 ]
  %t4 = call x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32> %t3)
  %t5 = call <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx %t4)
  %t6 = call <256 x i32> @llvm.abs.v256i32(<256 x i32> %t5, i1 1)
  store <256 x i32> %t6, ptr %buf
  br label %exit

exit:
  ret void
}

declare <256 x i32> @llvm.abs.v256i32(<256 x i32>, i1)
declare x86_amx @llvm.x86.tilezero.internal(i16, i16)
declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, ptr, i64)
declare <256 x i32> @llvm.x86.cast.tile.to.vector.v256i32(x86_amx)
declare x86_amx @llvm.x86.cast.vector.to.tile.v256i32(<256 x i32>)
declare void @llvm.x86.tilestored64.internal(i16, i16, ptr, i64, x86_amx)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
