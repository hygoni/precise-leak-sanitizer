; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt < %s -aa-pipeline=basic-aa -passes=loop-vectorize,instcombine -force-vector-width=2 -force-vector-interleave=1 -debug-only=loop-vectorize -disable-output -print-after=instcombine 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128"

;
define void @vector_gep(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @vector_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775806
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i32, ptr [[B:%.*]], <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    store <2 x ptr> [[TMP0]], ptr [[TMP1]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP2]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[VAR0:%.*]] = getelementptr inbounds i32, ptr [[B]], i64 [[I]]
; CHECK-NEXT:    [[VAR1:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[I]]
; CHECK-NEXT:    store ptr [[VAR0]], ptr [[VAR1]], align 8
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %var0 = getelementptr inbounds i32, ptr %b, i64 %i
  %var1 = getelementptr inbounds ptr, ptr %a, i64 %i
  store ptr %var0, ptr %var1, align 8
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}

;
define void @scalar_store(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @scalar_store(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 2)
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[SMAX]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 3
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[TMP2]], 9223372036854775806
; CHECK-NEXT:    [[IND_END:%.*]] = shl nuw i64 [[N_VEC]], 1
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = shl i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i64 [[OFFSET_IDX]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr [[B:%.*]], i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[B]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[TMP3]]
; CHECK-NEXT:    store ptr [[TMP4]], ptr [[TMP6]], align 8
; CHECK-NEXT:    store ptr [[TMP5]], ptr [[TMP7]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP2]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[VAR0:%.*]] = getelementptr inbounds i32, ptr [[B]], i64 [[I]]
; CHECK-NEXT:    [[VAR1:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[I]]
; CHECK-NEXT:    store ptr [[VAR0]], ptr [[VAR1]], align 8
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 2
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %var0 = getelementptr inbounds i32, ptr %b, i64 %i
  %var1 = getelementptr inbounds ptr, ptr %a, i64 %i
  store ptr %var0, ptr %var1, align 8
  %i.next = add nuw nsw i64 %i, 2
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}

;
define void @expansion(ptr %a, ptr %b, i64 %n) {
; CHECK-LABEL: @expansion(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 2)
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[SMAX]], -1
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i64 [[TMP1]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 3
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[TMP2]], 9223372036854775806
; CHECK-NEXT:    [[IND_END:%.*]] = shl nuw i64 [[N_VEC]], 1
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[OFFSET_IDX:%.*]] = shl i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = or i64 [[OFFSET_IDX]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[B:%.*]], i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i64, ptr [[B]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i64 [[OFFSET_IDX]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[TMP3]]
; CHECK-NEXT:    store ptr [[TMP4]], ptr [[TMP6]], align 8
; CHECK-NEXT:    store ptr [[TMP5]], ptr [[TMP7]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[TMP2]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[VAR0:%.*]] = getelementptr inbounds i64, ptr [[B]], i64 [[I]]
; CHECK-NEXT:    [[VAR3:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[I]]
; CHECK-NEXT:    store ptr [[VAR0]], ptr [[VAR3]], align 8
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 2
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %var0 = getelementptr inbounds i64, ptr %b, i64 %i
  %var3 = getelementptr inbounds ptr, ptr %a, i64 %i
  store ptr %var0, ptr %var3, align 8
  %i.next = add nuw nsw i64 %i, 2
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}

;
define void @no_gep_or_bitcast(ptr noalias %a, i64 %n) {
; CHECK-LABEL: @no_gep_or_bitcast(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[SMAX]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_VEC:%.*]] = and i64 [[SMAX]], 9223372036854775806
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds ptr, ptr [[A:%.*]], i64 [[INDEX]]
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x ptr>, ptr [[TMP0]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x ptr> [[WIDE_LOAD]], i64 0
; CHECK-NEXT:    store i32 0, ptr [[TMP1]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x ptr> [[WIDE_LOAD]], i64 1
; CHECK-NEXT:    store i32 0, ptr [[TMP2]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP3]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[SMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i64 [ [[I_NEXT:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[VAR0:%.*]] = getelementptr inbounds ptr, ptr [[A]], i64 [[I]]
; CHECK-NEXT:    [[VAR1:%.*]] = load ptr, ptr [[VAR0]], align 8
; CHECK-NEXT:    store i32 0, ptr [[VAR1]], align 8
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i64 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_BODY]], label [[FOR_END]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %i = phi i64 [ %i.next, %for.body ], [ 0, %entry ]
  %var0 = getelementptr inbounds ptr, ptr %a, i64 %i
  %var1 = load ptr, ptr %var0, align 8
  store i32 0, ptr %var1, align 8
  %i.next = add nuw nsw i64 %i, 1
  %cond = icmp slt i64 %i.next, %n
  br i1 %cond, label %for.body, label %for.end

for.end:
  ret void
}
