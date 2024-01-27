// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs --replace-value-regex "__omp_offloading_[0-9a-z]+_[0-9a-z]+" "reduction_  size[.].+[.]" "pl_cond[.].+[.|,]" --prefix-filecheck-ir-name _
// RUN: %clang_cc1 -fopenmp-enable-irbuilder -verify -fopenmp -fopenmp-version=45 -x c++ -triple x86_64-unknown-unknown -emit-llvm %s -o - | FileCheck %s
// expected-no-diagnostics

#ifndef HEADER
#define HEADER


extern "C" void workshareloop_unsigned_runtime(float *a, float *b, float *c, float *d) {
#pragma omp for schedule(runtime)
  for (unsigned i = 33; i < 32000000; i += 7) {
    a[i] = b[i] * c[i] * d[i];
  }
}

#endif // HEADER





// CHECK-LABEL: define {{[^@]+}}@workshareloop_unsigned_runtime
// CHECK-SAME: (ptr noundef [[A:%.*]], ptr noundef [[B:%.*]], ptr noundef [[C:%.*]], ptr noundef [[D:%.*]]) #[[ATTR0:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[A_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[B_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[C_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[D_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[I:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[AGG_CAPTURED:%.*]] = alloca [[STRUCT_ANON:%.*]], align 8
// CHECK-NEXT:    [[AGG_CAPTURED1:%.*]] = alloca [[STRUCT_ANON_0:%.*]], align 4
// CHECK-NEXT:    [[DOTCOUNT_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_LASTITER:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_LOWERBOUND:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_UPPERBOUND:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[P_STRIDE:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[A]], ptr [[A_ADDR]], align 8
// CHECK-NEXT:    store ptr [[B]], ptr [[B_ADDR]], align 8
// CHECK-NEXT:    store ptr [[C]], ptr [[C_ADDR]], align 8
// CHECK-NEXT:    store ptr [[D]], ptr [[D_ADDR]], align 8
// CHECK-NEXT:    store i32 33, ptr [[I]], align 4
// CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [[STRUCT_ANON]], ptr [[AGG_CAPTURED]], i32 0, i32 0
// CHECK-NEXT:    store ptr [[I]], ptr [[TMP0]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON_0]], ptr [[AGG_CAPTURED1]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    store i32 [[TMP2]], ptr [[TMP1]], align 4
// CHECK-NEXT:    call void @__captured_stmt(ptr [[DOTCOUNT_ADDR]], ptr [[AGG_CAPTURED]])
// CHECK-NEXT:    [[DOTCOUNT:%.*]] = load i32, ptr [[DOTCOUNT_ADDR]], align 4
// CHECK-NEXT:    br label [[OMP_LOOP_PREHEADER:%.*]]
// CHECK:       omp_loop.preheader:
// CHECK-NEXT:    store i32 1, ptr [[P_LOWERBOUND]], align 4
// CHECK-NEXT:    store i32 [[DOTCOUNT]], ptr [[P_UPPERBOUND]], align 4
// CHECK-NEXT:    store i32 1, ptr [[P_STRIDE]], align 4
// CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(ptr @[[GLOB1:[0-9]+]])
// CHECK-NEXT:    call void @__kmpc_dispatch_init_4u(ptr @[[GLOB1]], i32 [[OMP_GLOBAL_THREAD_NUM]], i32 1073741861, i32 1, i32 [[DOTCOUNT]], i32 1, i32 1)
// CHECK-NEXT:    br label [[OMP_LOOP_PREHEADER_OUTER_COND:%.*]]
// CHECK:       omp_loop.header:
// CHECK-NEXT:    [[OMP_LOOP_IV:%.*]] = phi i32 [ [[LB:%.*]], [[OMP_LOOP_PREHEADER_OUTER_COND]] ], [ [[OMP_LOOP_NEXT:%.*]], [[OMP_LOOP_INC:%.*]] ]
// CHECK-NEXT:    br label [[OMP_LOOP_COND:%.*]]
// CHECK:       omp_loop.cond:
// CHECK-NEXT:    [[UB:%.*]] = load i32, ptr [[P_UPPERBOUND]], align 4
// CHECK-NEXT:    [[OMP_LOOP_CMP:%.*]] = icmp ult i32 [[OMP_LOOP_IV]], [[UB]]
// CHECK-NEXT:    br i1 [[OMP_LOOP_CMP]], label [[OMP_LOOP_BODY:%.*]], label [[OMP_LOOP_PREHEADER_OUTER_COND]]
// CHECK:       omp_loop.body:
// CHECK-NEXT:    call void @__captured_stmt.1(ptr [[I]], i32 [[OMP_LOOP_IV]], ptr [[AGG_CAPTURED1]])
// CHECK-NEXT:    [[TMP3:%.*]] = load ptr, ptr [[B_ADDR]], align 8
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[IDXPROM:%.*]] = zext i32 [[TMP4]] to i64
// CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, ptr [[TMP3]], i64 [[IDXPROM]]
// CHECK-NEXT:    [[TMP5:%.*]] = load float, ptr [[ARRAYIDX]], align 4
// CHECK-NEXT:    [[TMP6:%.*]] = load ptr, ptr [[C_ADDR]], align 8
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[IDXPROM2:%.*]] = zext i32 [[TMP7]] to i64
// CHECK-NEXT:    [[ARRAYIDX3:%.*]] = getelementptr inbounds float, ptr [[TMP6]], i64 [[IDXPROM2]]
// CHECK-NEXT:    [[TMP8:%.*]] = load float, ptr [[ARRAYIDX3]], align 4
// CHECK-NEXT:    [[MUL:%.*]] = fmul float [[TMP5]], [[TMP8]]
// CHECK-NEXT:    [[TMP9:%.*]] = load ptr, ptr [[D_ADDR]], align 8
// CHECK-NEXT:    [[TMP10:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[IDXPROM4:%.*]] = zext i32 [[TMP10]] to i64
// CHECK-NEXT:    [[ARRAYIDX5:%.*]] = getelementptr inbounds float, ptr [[TMP9]], i64 [[IDXPROM4]]
// CHECK-NEXT:    [[TMP11:%.*]] = load float, ptr [[ARRAYIDX5]], align 4
// CHECK-NEXT:    [[MUL6:%.*]] = fmul float [[MUL]], [[TMP11]]
// CHECK-NEXT:    [[TMP12:%.*]] = load ptr, ptr [[A_ADDR]], align 8
// CHECK-NEXT:    [[TMP13:%.*]] = load i32, ptr [[I]], align 4
// CHECK-NEXT:    [[IDXPROM7:%.*]] = zext i32 [[TMP13]] to i64
// CHECK-NEXT:    [[ARRAYIDX8:%.*]] = getelementptr inbounds float, ptr [[TMP12]], i64 [[IDXPROM7]]
// CHECK-NEXT:    store float [[MUL6]], ptr [[ARRAYIDX8]], align 4
// CHECK-NEXT:    br label [[OMP_LOOP_INC]]
// CHECK:       omp_loop.inc:
// CHECK-NEXT:    [[OMP_LOOP_NEXT]] = add nuw i32 [[OMP_LOOP_IV]], 1
// CHECK-NEXT:    br label [[OMP_LOOP_HEADER:%.*]]
// CHECK:       omp_loop.exit:
// CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM9:%.*]] = call i32 @__kmpc_global_thread_num(ptr @[[GLOB1]])
// CHECK-NEXT:    call void @__kmpc_barrier(ptr @[[GLOB2:[0-9]+]], i32 [[OMP_GLOBAL_THREAD_NUM9]])
// CHECK-NEXT:    br label [[OMP_LOOP_AFTER:%.*]]
// CHECK:       omp_loop.after:
// CHECK-NEXT:    ret void
// CHECK:       omp_loop.preheader.outer.cond:
// CHECK-NEXT:    [[TMP14:%.*]] = call i32 @__kmpc_dispatch_next_4u(ptr @[[GLOB1]], i32 [[OMP_GLOBAL_THREAD_NUM]], ptr [[P_LASTITER]], ptr [[P_LOWERBOUND]], ptr [[P_UPPERBOUND]], ptr [[P_STRIDE]])
// CHECK-NEXT:    [[TMP15:%.*]] = icmp ne i32 [[TMP14]], 0
// CHECK-NEXT:    [[TMP16:%.*]] = load i32, ptr [[P_LOWERBOUND]], align 4
// CHECK-NEXT:    [[LB]] = sub i32 [[TMP16]], 1
// CHECK-NEXT:    br i1 [[TMP15]], label [[OMP_LOOP_HEADER]], label [[OMP_LOOP_EXIT:%.*]]
//
//
// CHECK-LABEL: define {{[^@]+}}@__captured_stmt
// CHECK-SAME: (ptr noundef nonnull align 4 dereferenceable(4) [[DISTANCE:%.*]], ptr noalias noundef [[__CONTEXT:%.*]]) #[[ATTR1:[0-9]+]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[DISTANCE_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[__CONTEXT_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[DOTSTART:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTSTOP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[DOTSTEP:%.*]] = alloca i32, align 4
// CHECK-NEXT:    store ptr [[DISTANCE]], ptr [[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store ptr [[__CONTEXT]], ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load ptr, ptr [[TMP1]], align 8
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[TMP2]], align 4
// CHECK-NEXT:    store i32 [[TMP3]], ptr [[DOTSTART]], align 4
// CHECK-NEXT:    store i32 32000000, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    store i32 7, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[TMP4:%.*]] = load i32, ptr [[DOTSTART]], align 4
// CHECK-NEXT:    [[TMP5:%.*]] = load i32, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[TMP4]], [[TMP5]]
// CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
// CHECK:       cond.true:
// CHECK-NEXT:    [[TMP6:%.*]] = load i32, ptr [[DOTSTOP]], align 4
// CHECK-NEXT:    [[TMP7:%.*]] = load i32, ptr [[DOTSTART]], align 4
// CHECK-NEXT:    [[SUB:%.*]] = sub i32 [[TMP6]], [[TMP7]]
// CHECK-NEXT:    [[TMP8:%.*]] = load i32, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[SUB1:%.*]] = sub i32 [[TMP8]], 1
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[SUB]], [[SUB1]]
// CHECK-NEXT:    [[TMP9:%.*]] = load i32, ptr [[DOTSTEP]], align 4
// CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[ADD]], [[TMP9]]
// CHECK-NEXT:    br label [[COND_END:%.*]]
// CHECK:       cond.false:
// CHECK-NEXT:    br label [[COND_END]]
// CHECK:       cond.end:
// CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[DIV]], [[COND_TRUE]] ], [ 0, [[COND_FALSE]] ]
// CHECK-NEXT:    [[TMP10:%.*]] = load ptr, ptr [[DISTANCE_ADDR]], align 8
// CHECK-NEXT:    store i32 [[COND]], ptr [[TMP10]], align 4
// CHECK-NEXT:    ret void
//
//
// CHECK-LABEL: define {{[^@]+}}@__captured_stmt.1
// CHECK-SAME: (ptr noundef nonnull align 4 dereferenceable(4) [[LOOPVAR:%.*]], i32 noundef [[LOGICAL:%.*]], ptr noalias noundef [[__CONTEXT:%.*]]) #[[ATTR1]] {
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[LOOPVAR_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    [[LOGICAL_ADDR:%.*]] = alloca i32, align 4
// CHECK-NEXT:    [[__CONTEXT_ADDR:%.*]] = alloca ptr, align 8
// CHECK-NEXT:    store ptr [[LOOPVAR]], ptr [[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 [[LOGICAL]], ptr [[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    store ptr [[__CONTEXT]], ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP0:%.*]] = load ptr, ptr [[__CONTEXT_ADDR]], align 8
// CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_ANON_0:%.*]], ptr [[TMP0]], i32 0, i32 0
// CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[TMP1]], align 4
// CHECK-NEXT:    [[TMP3:%.*]] = load i32, ptr [[LOGICAL_ADDR]], align 4
// CHECK-NEXT:    [[MUL:%.*]] = mul i32 7, [[TMP3]]
// CHECK-NEXT:    [[ADD:%.*]] = add i32 [[TMP2]], [[MUL]]
// CHECK-NEXT:    [[TMP4:%.*]] = load ptr, ptr [[LOOPVAR_ADDR]], align 8
// CHECK-NEXT:    store i32 [[ADD]], ptr [[TMP4]], align 4
// CHECK-NEXT:    ret void
//
