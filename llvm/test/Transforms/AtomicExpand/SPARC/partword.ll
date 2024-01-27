; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S %s -atomic-expand | FileCheck %s

;; Verify the cmpxchg and atomicrmw expansions where sub-word-size
;; instructions are not available.

;;; NOTE: this test is mostly target-independent -- any target which
;;; doesn't support cmpxchg of sub-word sizes would do.
target datalayout = "E-m:e-i64:64-n32:64-S128"
target triple = "sparcv9-unknown-unknown"

define i8 @test_cmpxchg_i8(ptr %arg, i8 %old, i8 %new) {
; CHECK-LABEL: @test_cmpxchg_i8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 255, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i8 [[NEW:%.*]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP5:%.*]] = zext i8 [[OLD:%.*]] to i32
; CHECK-NEXT:    [[TMP6:%.*]] = shl i32 [[TMP5]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = and i32 [[TMP7]], [[INV_MASK]]
; CHECK-NEXT:    br label [[PARTWORD_CMPXCHG_LOOP:%.*]]
; CHECK:       partword.cmpxchg.loop:
; CHECK-NEXT:    [[TMP9:%.*]] = phi i32 [ [[TMP8]], [[ENTRY:%.*]] ], [ [[TMP15:%.*]], [[PARTWORD_CMPXCHG_FAILURE:%.*]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = or i32 [[TMP9]], [[TMP4]]
; CHECK-NEXT:    [[TMP11:%.*]] = or i32 [[TMP9]], [[TMP6]]
; CHECK-NEXT:    [[TMP12:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[TMP11]], i32 [[TMP10]] monotonic monotonic, align 4
; CHECK-NEXT:    [[TMP13:%.*]] = extractvalue { i32, i1 } [[TMP12]], 0
; CHECK-NEXT:    [[TMP14:%.*]] = extractvalue { i32, i1 } [[TMP12]], 1
; CHECK-NEXT:    br i1 [[TMP14]], label [[PARTWORD_CMPXCHG_END:%.*]], label [[PARTWORD_CMPXCHG_FAILURE]]
; CHECK:       partword.cmpxchg.failure:
; CHECK-NEXT:    [[TMP15]] = and i32 [[TMP13]], [[INV_MASK]]
; CHECK-NEXT:    [[TMP16:%.*]] = icmp ne i32 [[TMP9]], [[TMP15]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[PARTWORD_CMPXCHG_LOOP]], label [[PARTWORD_CMPXCHG_END]]
; CHECK:       partword.cmpxchg.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[TMP13]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i8
; CHECK-NEXT:    [[TMP17:%.*]] = insertvalue { i8, i1 } poison, i8 [[EXTRACTED]], 0
; CHECK-NEXT:    [[TMP18:%.*]] = insertvalue { i8, i1 } [[TMP17]], i1 [[TMP14]], 1
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[RET:%.*]] = extractvalue { i8, i1 } [[TMP18]], 0
; CHECK-NEXT:    ret i8 [[RET]]
;
entry:
  %ret_succ = cmpxchg ptr %arg, i8 %old, i8 %new seq_cst monotonic
  %ret = extractvalue { i8, i1 } %ret_succ, 0
  ret i8 %ret
}

define i16 @test_cmpxchg_i16(ptr %arg, i16 %old, i16 %new) {
; CHECK-LABEL: @test_cmpxchg_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[NEW:%.*]] to i32
; CHECK-NEXT:    [[TMP4:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP5:%.*]] = zext i16 [[OLD:%.*]] to i32
; CHECK-NEXT:    [[TMP6:%.*]] = shl i32 [[TMP5]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    [[TMP8:%.*]] = and i32 [[TMP7]], [[INV_MASK]]
; CHECK-NEXT:    br label [[PARTWORD_CMPXCHG_LOOP:%.*]]
; CHECK:       partword.cmpxchg.loop:
; CHECK-NEXT:    [[TMP9:%.*]] = phi i32 [ [[TMP8]], [[ENTRY:%.*]] ], [ [[TMP15:%.*]], [[PARTWORD_CMPXCHG_FAILURE:%.*]] ]
; CHECK-NEXT:    [[TMP10:%.*]] = or i32 [[TMP9]], [[TMP4]]
; CHECK-NEXT:    [[TMP11:%.*]] = or i32 [[TMP9]], [[TMP6]]
; CHECK-NEXT:    [[TMP12:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[TMP11]], i32 [[TMP10]] monotonic monotonic, align 4
; CHECK-NEXT:    [[TMP13:%.*]] = extractvalue { i32, i1 } [[TMP12]], 0
; CHECK-NEXT:    [[TMP14:%.*]] = extractvalue { i32, i1 } [[TMP12]], 1
; CHECK-NEXT:    br i1 [[TMP14]], label [[PARTWORD_CMPXCHG_END:%.*]], label [[PARTWORD_CMPXCHG_FAILURE]]
; CHECK:       partword.cmpxchg.failure:
; CHECK-NEXT:    [[TMP15]] = and i32 [[TMP13]], [[INV_MASK]]
; CHECK-NEXT:    [[TMP16:%.*]] = icmp ne i32 [[TMP9]], [[TMP15]]
; CHECK-NEXT:    br i1 [[TMP16]], label [[PARTWORD_CMPXCHG_LOOP]], label [[PARTWORD_CMPXCHG_END]]
; CHECK:       partword.cmpxchg.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[TMP13]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    [[TMP17:%.*]] = insertvalue { i16, i1 } poison, i16 [[EXTRACTED]], 0
; CHECK-NEXT:    [[TMP18:%.*]] = insertvalue { i16, i1 } [[TMP17]], i1 [[TMP14]], 1
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[RET:%.*]] = extractvalue { i16, i1 } [[TMP18]], 0
; CHECK-NEXT:    ret i16 [[RET]]
;
entry:
  %ret_succ = cmpxchg ptr %arg, i16 %old, i16 %new seq_cst monotonic
  %ret = extractvalue { i16, i1 } %ret_succ, 0
  ret i16 %ret
}

define i16 @test_add_i16(ptr %arg, i16 %val) {
; CHECK-LABEL: @test_add_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    [[VALOPERAND_SHIFTED:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP4]], [[ENTRY:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[NEW:%.*]] = add i32 [[LOADED]], [[VALOPERAND_SHIFTED]]
; CHECK-NEXT:    [[TMP5:%.*]] = and i32 [[NEW]], [[MASK]]
; CHECK-NEXT:    [[TMP6:%.*]] = and i32 [[LOADED]], [[INV_MASK]]
; CHECK-NEXT:    [[TMP7:%.*]] = or i32 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP8:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[TMP7]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP8]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP8]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret i16 [[EXTRACTED]]
;
entry:
  %ret = atomicrmw add ptr %arg, i16 %val seq_cst
  ret i16 %ret
}

define i16 @test_xor_i16(ptr %arg, i16 %val) {
; CHECK-LABEL: @test_xor_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    [[VALOPERAND_SHIFTED:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP4]], [[ENTRY:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[NEW:%.*]] = xor i32 [[LOADED]], [[VALOPERAND_SHIFTED]]
; CHECK-NEXT:    [[TMP5:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[NEW]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP5]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP5]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret i16 [[EXTRACTED]]
;
entry:
  %ret = atomicrmw xor ptr %arg, i16 %val seq_cst
  ret i16 %ret
}

define i16 @test_or_i16(ptr %arg, i16 %val) {
; CHECK-LABEL: @test_or_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    [[VALOPERAND_SHIFTED:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP4]], [[ENTRY:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[NEW:%.*]] = or i32 [[LOADED]], [[VALOPERAND_SHIFTED]]
; CHECK-NEXT:    [[TMP5:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[NEW]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP5]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP5]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret i16 [[EXTRACTED]]
;
entry:
  %ret = atomicrmw or ptr %arg, i16 %val seq_cst
  ret i16 %ret
}

define i16 @test_and_i16(ptr %arg, i16 %val) {
; CHECK-LABEL: @test_and_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = zext i16 [[VAL:%.*]] to i32
; CHECK-NEXT:    [[VALOPERAND_SHIFTED:%.*]] = shl i32 [[TMP3]], [[SHIFTAMT]]
; CHECK-NEXT:    [[ANDOPERAND:%.*]] = or i32 [[INV_MASK]], [[VALOPERAND_SHIFTED]]
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP4]], [[ENTRY:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[NEW:%.*]] = and i32 [[LOADED]], [[ANDOPERAND]]
; CHECK-NEXT:    [[TMP5:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[NEW]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP5]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP5]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret i16 [[EXTRACTED]]
;
entry:
  %ret = atomicrmw and ptr %arg, i16 %val seq_cst
  ret i16 %ret
}

define i16 @test_min_i16(ptr %arg, i16 %val) {
; CHECK-LABEL: @test_min_i16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[ARG:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[ARG]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP2]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP3]], [[ENTRY:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[LOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    [[TMP4:%.*]] = icmp sle i16 [[EXTRACTED]], [[VAL:%.*]]
; CHECK-NEXT:    [[NEW:%.*]] = select i1 [[TMP4]], i16 [[EXTRACTED]], i16 [[VAL]]
; CHECK-NEXT:    [[EXTENDED:%.*]] = zext i16 [[NEW]] to i32
; CHECK-NEXT:    [[SHIFTED2:%.*]] = shl nuw i32 [[EXTENDED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[UNMASKED:%.*]] = and i32 [[LOADED]], [[INV_MASK]]
; CHECK-NEXT:    [[INSERTED:%.*]] = or i32 [[UNMASKED]], [[SHIFTED2]]
; CHECK-NEXT:    [[TMP5:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[INSERTED]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP5]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP5]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED3:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED4:%.*]] = trunc i32 [[SHIFTED3]] to i16
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret i16 [[EXTRACTED4]]
;
entry:
  %ret = atomicrmw min ptr %arg, i16 %val seq_cst
  ret i16 %ret
}

define half @test_atomicrmw_fadd_f16(ptr %ptr, half %value) {
; CHECK-LABEL: @test_atomicrmw_fadd_f16(
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    [[ALIGNEDADDR:%.*]] = call ptr @llvm.ptrmask.p0.i64(ptr [[PTR:%.*]], i64 -4)
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr [[PTR]] to i64
; CHECK-NEXT:    [[PTRLSB:%.*]] = and i64 [[TMP1]], 3
; CHECK-NEXT:    [[TMP2:%.*]] = xor i64 [[PTRLSB]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = shl i64 [[TMP2]], 3
; CHECK-NEXT:    [[SHIFTAMT:%.*]] = trunc i64 [[TMP3]] to i32
; CHECK-NEXT:    [[MASK:%.*]] = shl i32 65535, [[SHIFTAMT]]
; CHECK-NEXT:    [[INV_MASK:%.*]] = xor i32 [[MASK]], -1
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[ALIGNEDADDR]], align 4
; CHECK-NEXT:    br label [[ATOMICRMW_START:%.*]]
; CHECK:       atomicrmw.start:
; CHECK-NEXT:    [[LOADED:%.*]] = phi i32 [ [[TMP4]], [[TMP0:%.*]] ], [ [[NEWLOADED:%.*]], [[ATOMICRMW_START]] ]
; CHECK-NEXT:    [[SHIFTED:%.*]] = lshr i32 [[LOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED:%.*]] = trunc i32 [[SHIFTED]] to i16
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i16 [[EXTRACTED]] to half
; CHECK-NEXT:    [[NEW:%.*]] = fadd half [[TMP5]], [[VALUE:%.*]]
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast half [[NEW]] to i16
; CHECK-NEXT:    [[EXTENDED:%.*]] = zext i16 [[TMP6]] to i32
; CHECK-NEXT:    [[SHIFTED2:%.*]] = shl nuw i32 [[EXTENDED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[UNMASKED:%.*]] = and i32 [[LOADED]], [[INV_MASK]]
; CHECK-NEXT:    [[INSERTED:%.*]] = or i32 [[UNMASKED]], [[SHIFTED2]]
; CHECK-NEXT:    [[TMP7:%.*]] = cmpxchg ptr [[ALIGNEDADDR]], i32 [[LOADED]], i32 [[INSERTED]] monotonic monotonic, align 4
; CHECK-NEXT:    [[SUCCESS:%.*]] = extractvalue { i32, i1 } [[TMP7]], 1
; CHECK-NEXT:    [[NEWLOADED]] = extractvalue { i32, i1 } [[TMP7]], 0
; CHECK-NEXT:    br i1 [[SUCCESS]], label [[ATOMICRMW_END:%.*]], label [[ATOMICRMW_START]]
; CHECK:       atomicrmw.end:
; CHECK-NEXT:    [[SHIFTED3:%.*]] = lshr i32 [[NEWLOADED]], [[SHIFTAMT]]
; CHECK-NEXT:    [[EXTRACTED4:%.*]] = trunc i32 [[SHIFTED3]] to i16
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast i16 [[EXTRACTED4]] to half
; CHECK-NEXT:    fence seq_cst
; CHECK-NEXT:    ret half [[TMP8]]
;
  %res = atomicrmw fadd ptr %ptr, half %value seq_cst
  ret half %res
}
