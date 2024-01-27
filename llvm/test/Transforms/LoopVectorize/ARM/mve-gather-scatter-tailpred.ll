; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -force-vector-width=4 -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -tail-predication=force-enabled -S %s -o - | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"

define void @test_stride1_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride1_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N:%.*]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul nuw nsw i32 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i32 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[TMP4]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, ptr [[TMP6]], i32 0
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP5]], ptr [[TMP7]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP9]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP3:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, 1
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride-1_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride-1_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = mul nuw nsw i32 [[TMP0]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i32 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[TMP4]], i32 -3
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x i32>, ptr [[TMP5]], align 4
; CHECK-NEXT:    [[REVERSE:%.*]] = shufflevector <4 x i32> [[WIDE_LOAD]], <4 x i32> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP6:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[REVERSE]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, ptr [[TMP7]], i32 0
; CHECK-NEXT:    store <4 x i32> [[TMP6]], ptr [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], -1
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP10]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, -1
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride2_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
;
; CHECK-LABEL: @test_stride2_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ule i32 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], 4
; CHECK-NEXT:    [[TMP0:%.*]] = icmp eq i32 [[N_MOD_VF]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[TMP0]], i32 4, i32 [[N_MOD_VF]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[TMP1]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = mul nuw nsw i32 [[TMP2]], 2
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i32 [[TMP3]], 2
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], i32 [[TMP4]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[TMP5]], i32 0
; CHECK-NEXT:    [[WIDE_VEC:%.*]] = load <8 x i32>, ptr [[TMP6]], align 4
; CHECK-NEXT:    [[STRIDED_VEC:%.*]] = shufflevector <8 x i32> [[WIDE_VEC]], <8 x i32> poison, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[STRIDED_VEC]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, ptr [[TMP8]], i32 0
; CHECK-NEXT:    store <4 x i32> [[TMP7]], ptr [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], 2
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP11]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END:%.*]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, 2
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride3_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride3_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N:%.*]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul nuw nsw <4 x i32> [[VEC_IND]], <i32 3, i32 3, i32 3, i32 3>
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw <4 x i32> [[TMP1]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0(<4 x ptr> [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_GATHER]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[TMP5]], i32 0
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP4]], ptr [[TMP6]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], 3
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP8]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, 3
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride4_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride4_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N:%.*]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul nuw nsw <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw <4 x i32> [[TMP1]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], <4 x i32> [[TMP2]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0(<4 x ptr> [[TMP3]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP4:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_GATHER]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[TMP5]], i32 0
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP4]], ptr [[TMP6]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], 4
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP8]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, 4
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride_loopinvar_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n, i32 %stride) {
; CHECK-LABEL: @test_stride_loopinvar_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i32 [[STRIDE:%.*]], 1
; CHECK-NEXT:    br i1 [[IDENT_CHECK]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_RND_UP:%.*]] = add i32 [[N:%.*]], 3
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N_RND_UP]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N_RND_UP]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[ACTIVE_LANE_MASK:%.*]] = call <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32 [[TMP0]], i32 [[N]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul nuw nsw i32 [[TMP0]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add nuw nsw i32 [[TMP1]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], i32 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <4 x i32> @llvm.masked.load.v4i32.p0(ptr [[TMP4]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]], <4 x i32> poison)
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_LOAD]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, ptr [[TMP6]], i32 0
; CHECK-NEXT:    call void @llvm.masked.store.v4i32.p0(<4 x i32> [[TMP5]], ptr [[TMP7]], i32 4, <4 x i1> [[ACTIVE_LANE_MASK]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], [[STRIDE]]
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP9]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %mul = mul nuw nsw i32 %i.023, %stride
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride_noninvar_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride_noninvar_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP0:%.*]] = mul i32 [[N_VEC]], 8
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 3, [[TMP0]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND2:%.*]] = phi <4 x i32> [ <i32 3, i32 11, i32 19, i32 27>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = mul nuw nsw <4 x i32> [[VEC_IND]], [[VEC_IND2]]
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw <4 x i32> [[TMP2]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], <4 x i32> [[TMP3]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0(<4 x ptr> [[TMP4]], i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> poison)
; CHECK-NEXT:    [[TMP5:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_GATHER]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP1]]
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds i32, ptr [[TMP6]], i32 0
; CHECK-NEXT:    store <4 x i32> [[TMP5]], ptr [[TMP7]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[VEC_IND_NEXT3]] = add <4 x i32> [[VEC_IND2]], <i32 32, i32 32, i32 32, i32 32>
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 3, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[STRIDE:%.*]] = phi i32 [ [[NEXT_STRIDE:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], [[STRIDE]]
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP9]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[NEXT_STRIDE]] = add nuw nsw i32 [[STRIDE]], 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP15:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %stride = phi i32 [ %next.stride, %for.body ], [ 3, %entry ]
  %mul = mul nuw nsw i32 %i.023, %stride
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %next.stride = add nuw nsw i32 %stride, 8
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride_noninvar2_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n) {
; CHECK-LABEL: @test_stride_noninvar2_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[STRIDE:%.*]] = phi i32 [ [[NEXT_STRIDE:%.*]], [[FOR_BODY]] ], [ 3, [[ENTRY]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], [[STRIDE]]
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP0]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[NEXT_STRIDE]] = mul nuw nsw i32 [[STRIDE]], 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END:%.*]], label [[FOR_BODY]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %stride = phi i32 [ %next.stride, %for.body ], [ 3, %entry ]
  %mul = mul nuw nsw i32 %i.023, %stride
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %next.stride = mul nuw nsw i32 %stride, 8
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

define void @test_stride_noninvar3_4i32(ptr readonly %data, ptr noalias nocapture %dst, i32 %n, i32 %x) {
; CHECK-LABEL: @test_stride_noninvar3_4i32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[TMP0:%.*]] = mul i32 [[N_VEC]], [[X:%.*]]
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 3, [[TMP0]]
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[X]], i64 0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP1:%.*]] = mul <4 x i32> <i32 0, i32 1, i32 2, i32 3>, [[DOTSPLAT]]
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <4 x i32> <i32 3, i32 3, i32 3, i32 3>, [[TMP1]]
; CHECK-NEXT:    [[TMP2:%.*]] = mul i32 [[X]], 4
; CHECK-NEXT:    [[DOTSPLATINSERT2:%.*]] = insertelement <4 x i32> poison, i32 [[TMP2]], i64 0
; CHECK-NEXT:    [[DOTSPLAT3:%.*]] = shufflevector <4 x i32> [[DOTSPLATINSERT2]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND4:%.*]] = phi <4 x i32> [ [[INDUCTION]], [[VECTOR_PH]] ], [ [[VEC_IND_NEXT5:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP4:%.*]] = mul nuw nsw <4 x i32> [[VEC_IND]], [[VEC_IND4]]
; CHECK-NEXT:    [[TMP5:%.*]] = add nuw nsw <4 x i32> [[TMP4]], <i32 2, i32 2, i32 2, i32 2>
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, ptr [[DATA:%.*]], <4 x i32> [[TMP5]]
; CHECK-NEXT:    [[WIDE_MASKED_GATHER:%.*]] = call <4 x i32> @llvm.masked.gather.v4i32.v4p0(<4 x ptr> [[TMP6]], i32 4, <4 x i1> <i1 true, i1 true, i1 true, i1 true>, <4 x i32> poison)
; CHECK-NEXT:    [[TMP7:%.*]] = add nsw <4 x i32> <i32 5, i32 5, i32 5, i32 5>, [[WIDE_MASKED_GATHER]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, ptr [[DST:%.*]], i32 [[TMP3]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i32, ptr [[TMP8]], i32 0
; CHECK-NEXT:    store <4 x i32> [[TMP7]], ptr [[TMP9]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[VEC_IND_NEXT5]] = add <4 x i32> [[VEC_IND4]], [[DOTSPLAT3]]
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP16:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_RESUME_VAL1:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ 3, [[ENTRY]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_023:%.*]] = phi i32 [ [[INC:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[STRIDE:%.*]] = phi i32 [ [[NEXT_STRIDE:%.*]], [[FOR_BODY]] ], [ [[BC_RESUME_VAL1]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[MUL:%.*]] = mul nuw nsw i32 [[I_023]], [[STRIDE]]
; CHECK-NEXT:    [[ADD5:%.*]] = add nuw nsw i32 [[MUL]], 2
; CHECK-NEXT:    [[ARRAYIDX6:%.*]] = getelementptr inbounds i32, ptr [[DATA]], i32 [[ADD5]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i32, ptr [[ARRAYIDX6]], align 4
; CHECK-NEXT:    [[ADD7:%.*]] = add nsw i32 5, [[TMP11]]
; CHECK-NEXT:    [[ARRAYIDX9:%.*]] = getelementptr inbounds i32, ptr [[DST]], i32 [[I_023]]
; CHECK-NEXT:    store i32 [[ADD7]], ptr [[ARRAYIDX9]], align 4
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[I_023]], 1
; CHECK-NEXT:    [[NEXT_STRIDE]] = add nuw nsw i32 [[STRIDE]], [[X]]
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i32 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[END]], label [[FOR_BODY]], !llvm.loop [[LOOP17:![0-9]+]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body
for.body:                                         ; preds = %for.body.preheader, %for.body
  %i.023 = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %stride = phi i32 [ %next.stride, %for.body ], [ 3, %entry ]
  %mul = mul nuw nsw i32 %i.023, %stride
  %add5 = add nuw nsw i32 %mul, 2
  %arrayidx6 = getelementptr inbounds i32, ptr %data, i32 %add5
  %0 = load i32, ptr %arrayidx6, align 4
  %add7 = add nsw i32 5, %0
  %arrayidx9 = getelementptr inbounds i32, ptr %dst, i32 %i.023
  store i32 %add7, ptr %arrayidx9, align 4
  %inc = add nuw nsw i32 %i.023, 1
  %next.stride = add nuw nsw i32 %stride, %x
  %exitcond.not = icmp eq i32 %inc, %n
  br i1 %exitcond.not, label %end, label %for.body
end:                                 ; preds = %end, %entry
  ret void
}

declare i32 @llvm.vector.reduce.add.v4i32(<4 x i32>)
declare <4 x i32> @llvm.masked.gather.v4i32.v4p0(<4 x ptr>, i32, <4 x i1>, <4 x i32>)
declare <4 x i1> @llvm.get.active.lane.mask.v4i1.i32(i32, i32)
declare <4 x i32> @llvm.masked.load.v4i32.p0(ptr, i32, <4 x i1>, <4 x i32>)
declare void @llvm.masked.scatter.v4i32.v4p0(<4 x i32>, <4 x ptr>, i32, <4 x i1>)
