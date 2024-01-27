; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-attributes --check-globals --version 2
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-annotate-decl-cs  -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC
;
; Test cases specifically designed for the "no-capture" argument attribute.
; We use FIXME's to indicate problems and missing attributes.
;
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
declare ptr @unknown()

; TEST comparison against NULL
;
; int is_null_return(int *p) {
;   return p == 0;
; }
;
; no-capture is missing on %p because it is not dereferenceable
define i32 @is_null_return(ptr %p) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable
; CHECK-LABEL: define i32 @is_null_return
; CHECK-SAME: (ptr nofree readnone [[P:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr [[P]], null
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i32
; CHECK-NEXT:    ret i32 [[CONV]]
;
entry:
  %cmp = icmp eq ptr %p, null
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

; TEST comparison against NULL in control flow
;
; int is_null_control(int *p) {
;   if (p == 0)
;     return 1;
;   if (0 == p)
;     return 1;
;   return 0;
; }
;
; no-capture is missing on %p because it is not dereferenceable
define i32 @is_null_control(ptr %p) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable
; CHECK-LABEL: define i32 @is_null_control
; CHECK-SAME: (ptr nofree [[P:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr [[P]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 1, ptr [[RETVAL]], align 4
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq ptr null, [[P]]
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN2:%.*]], label [[IF_END3:%.*]]
; CHECK:       if.then2:
; CHECK-NEXT:    store i32 1, ptr [[RETVAL]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       if.end3:
; CHECK-NEXT:    store i32 0, ptr [[RETVAL]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, ptr [[RETVAL]], align 4
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %retval = alloca i32, align 4
  %cmp = icmp eq ptr %p, null
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  store i32 1, ptr %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  %cmp1 = icmp eq ptr null, %p
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  store i32 1, ptr %retval, align 4
  br label %return

if.end3:                                          ; preds = %if.end
  store i32 0, ptr %retval, align 4
  br label %return

return:                                           ; preds = %if.end3, %if.then2, %if.then
  %0 = load i32, ptr %retval, align 4
  ret i32 %0
}

; TEST singleton SCC
;
; double *srec0(double *a) {
;   srec0(a);
;   return 0;
; }
;
define ptr @srec0(ptr %a) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(none) uwtable
; CHECK-LABEL: define noalias noundef align 4294967296 ptr @srec0
; CHECK-SAME: (ptr nocapture nofree readnone [[A:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret ptr null
;
entry:
  %call = call ptr @srec0(ptr %a)
  ret ptr null
}

; TEST singleton SCC with lots of nested recursive calls
;
; int* srec16(int* a) {
;   return srec16(srec16(srec16(srec16(
;          srec16(srec16(srec16(srec16(
;          srec16(srec16(srec16(srec16(
;          srec16(srec16(srec16(srec16(
;                        a
;          ))))))))))))))));
; }
;
; Other arguments are possible here due to the no-return behavior.
;
define ptr @srec16(ptr %a) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(none) uwtable
; CHECK-LABEL: define noalias nonnull align 4294967296 dereferenceable(4294967295) ptr @srec16
; CHECK-SAME: (ptr nocapture nofree readnone [[A:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret ptr undef
;
entry:
  %call = call ptr @srec16(ptr %a)
  %call1 = call ptr @srec16(ptr %call)
  %call2 = call ptr @srec16(ptr %call1)
  %call3 = call ptr @srec16(ptr %call2)
  %call4 = call ptr @srec16(ptr %call3)
  %call5 = call ptr @srec16(ptr %call4)
  %call6 = call ptr @srec16(ptr %call5)
  %call7 = call ptr @srec16(ptr %call6)
  %call8 = call ptr @srec16(ptr %call7)
  %call9 = call ptr @srec16(ptr %call8)
  %call10 = call ptr @srec16(ptr %call9)
  %call11 = call ptr @srec16(ptr %call10)
  %call12 = call ptr @srec16(ptr %call11)
  %call13 = call ptr @srec16(ptr %call12)
  %call14 = call ptr @srec16(ptr %call13)
  %call15 = call ptr @srec16(ptr %call14)
  ret ptr %call15
}

; TEST SCC with various calls, casts, and comparisons agains NULL
;
; float *scc_A(int *a) {
;   return (float*)(a ? (int*)scc_A((int*)scc_B((double*)scc_C((short*)a))) : a);
; }
;
; long *scc_B(double *a) {
;   return (long*)(a ? scc_C((short*)scc_B((double*)scc_A((int*)a))) : a);
; }
;
; void *scc_C(short *a) {
;   return scc_A((int*)(scc_A(a) ? scc_B((double*)a) : scc_C(a)));
; }
define ptr @scc_A(ptr dereferenceable_or_null(4) %a) {
; CHECK: Function Attrs: nofree nosync nounwind memory(none)
; CHECK-LABEL: define noundef dereferenceable_or_null(4) ptr @scc_A
; CHECK-SAME: (ptr nofree noundef readnone returned dereferenceable_or_null(4) "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne ptr [[A]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[CALL:%.*]] = call dereferenceable_or_null(4) ptr @scc_C(ptr noalias nofree noundef nonnull readnone dereferenceable(4) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    [[CALL1:%.*]] = call dereferenceable_or_null(8) ptr @scc_B(ptr noalias nofree noundef readnone dereferenceable_or_null(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    [[CALL2:%.*]] = call ptr @scc_A(ptr noalias nofree noundef readnone dereferenceable_or_null(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi ptr [ [[A]], [[COND_TRUE]] ], [ [[A]], [[COND_FALSE]] ]
; CHECK-NEXT:    ret ptr [[A]]
;
entry:
  %tobool = icmp ne ptr %a, null
  br i1 %tobool, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  %call = call ptr @scc_C(ptr %a)
  %call1 = call ptr @scc_B(ptr %call)
  %call2 = call ptr @scc_A(ptr %call1)
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi ptr [ %call2, %cond.true ], [ %a, %cond.false ]
  ret ptr %cond
}

; FIXME: the call1 below to scc_B should return dereferenceable_or_null(8) (as the callee does). Something prevented that deduction and needs to be investigated.
define ptr @scc_B(ptr dereferenceable_or_null(8) %a) {
; CHECK: Function Attrs: nofree nosync nounwind memory(none)
; CHECK-LABEL: define noundef dereferenceable_or_null(8) ptr @scc_B
; CHECK-SAME: (ptr nofree noundef readnone returned dereferenceable_or_null(8) "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne ptr [[A]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[CALL:%.*]] = call dereferenceable_or_null(4) ptr @scc_A(ptr noalias nofree noundef nonnull readnone dereferenceable(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    [[CALL1:%.*]] = call dereferenceable_or_null(8) ptr @scc_B(ptr noalias nofree noundef readnone dereferenceable_or_null(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    [[CALL2:%.*]] = call ptr @scc_C(ptr noalias nofree noundef readnone dereferenceable_or_null(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi ptr [ [[A]], [[COND_TRUE]] ], [ [[A]], [[COND_FALSE]] ]
; CHECK-NEXT:    ret ptr [[A]]
;
entry:
  %tobool = icmp ne ptr %a, null
  br i1 %tobool, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  %call = call ptr @scc_A(ptr %a)
  %call1 = call ptr @scc_B(ptr %call)
  %call2 = call ptr @scc_C(ptr %call1)
  br label %cond.end

cond.false:                                       ; preds = %entry
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi ptr [ %call2, %cond.true ], [ %a, %cond.false ]
  ret ptr %cond
}

define ptr @scc_C(ptr dereferenceable_or_null(2) %a) {
; CHECK: Function Attrs: nofree nosync nounwind memory(none)
; CHECK-LABEL: define noundef dereferenceable_or_null(4) ptr @scc_C
; CHECK-SAME: (ptr nofree noundef readnone returned dereferenceable_or_null(4) "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call dereferenceable_or_null(4) ptr @scc_A(ptr noalias nofree noundef readnone dereferenceable_or_null(4) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp ne ptr [[A]], null
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[CALL1:%.*]] = call ptr @scc_B(ptr noalias nofree noundef readnone dereferenceable_or_null(8) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[CALL2:%.*]] = call ptr @scc_C(ptr noalias nofree noundef readnone dereferenceable_or_null(4) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[COND:%.*]] = phi ptr [ [[A]], [[COND_TRUE]] ], [ [[A]], [[COND_FALSE]] ]
; CHECK-NEXT:    [[CALL3:%.*]] = call ptr @scc_A(ptr noalias nofree noundef readnone dereferenceable_or_null(4) "no-capture-maybe-returned" [[A]]) #[[ATTR2]]
; CHECK-NEXT:    ret ptr [[A]]
;
entry:
  %call = call ptr @scc_A(ptr %a)
  %tobool = icmp ne ptr %call, null
  br i1 %tobool, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  %call1 = call ptr @scc_B(ptr %a)
  br label %cond.end

cond.false:                                       ; preds = %entry
  %call2 = call ptr @scc_C(ptr %a)
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi ptr [ %call1, %cond.true ], [ %call2, %cond.false ]
  %call3 = call ptr @scc_A(ptr %cond)
  ret ptr %call3
}


; TEST call to external function, marked no-capture
;
; void external_no_capture(int /* no-capture */ *p);
; void test_external_no_capture(int *p) {
;   external_no_capture(p);
; }
;
declare void @external_no_capture(ptr nocapture)

define void @test_external_no_capture(ptr %p) #0 {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: define void @test_external_no_capture
; CHECK-SAME: (ptr nocapture [[P:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @external_no_capture(ptr nocapture [[P]])
; CHECK-NEXT:    ret void
;
entry:
  call void @external_no_capture(ptr %p)
  ret void
}

; TEST call to external var-args function, marked no-capture
;
; void test_var_arg_call(char *p, int a) {
;   printf(p, a);
; }
;
define void @test_var_arg_call(ptr %p, i32 %a) #0 {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: define void @test_var_arg_call
; CHECK-SAME: (ptr nocapture [[P:%.*]], i32 [[A:%.*]]) #[[ATTR3]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call i32 (ptr, ...) @printf(ptr nocapture [[P]], i32 [[A]])
; CHECK-NEXT:    ret void
;
entry:
  %call = call i32 (ptr, ...) @printf(ptr %p, i32 %a)
  ret void
}

declare i32 @printf(ptr nocapture, ...)


; TEST "captured" only through return
;
; long *not_captured_but_returned_0(long *a) {
;   *a1 = 0;
;   return a;
; }
;
; There should *not* be a no-capture attribute on %a
define ptr @not_captured_but_returned_0(ptr %a) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; CHECK-LABEL: define noundef nonnull align 8 dereferenceable(8) ptr @not_captured_but_returned_0
; CHECK-SAME: (ptr nofree noundef nonnull returned writeonly align 8 dereferenceable(8) "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR4:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i64 0, ptr [[A]], align 8
; CHECK-NEXT:    ret ptr [[A]]
;
entry:
  store i64 0, ptr %a, align 8
  ret ptr %a
}

; TEST "captured" only through return
;
; long *not_captured_but_returned_1(long *a) {
;   *(a+1) = 1;
;   return a + 1;
; }
;
; There should *not* be a no-capture attribute on %a
define ptr @not_captured_but_returned_1(ptr %a) #0 {
; CHECK: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; CHECK-LABEL: define noundef nonnull align 8 dereferenceable(8) ptr @not_captured_but_returned_1
; CHECK-SAME: (ptr nofree nonnull writeonly align 8 dereferenceable(16) "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR4]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 1
; CHECK-NEXT:    store i64 1, ptr [[ADD_PTR]], align 8
; CHECK-NEXT:    ret ptr [[ADD_PTR]]
;
entry:
  %add.ptr = getelementptr inbounds i64, ptr %a, i64 1
  store i64 1, ptr %add.ptr, align 8
  ret ptr %add.ptr
}

; TEST calls to "captured" only through return functions
;
; void test_not_captured_but_returned_calls(long *a) {
;   not_captured_but_returned_0(a);
;   not_captured_but_returned_1(a);
; }
;
define void @test_not_captured_but_returned_calls(ptr %a) #0 {
; TUNIT: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; TUNIT-LABEL: define void @test_not_captured_but_returned_calls
; TUNIT-SAME: (ptr nocapture nofree writeonly align 8 [[A:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @not_captured_but_returned_0(ptr nofree noundef writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9:[0-9]+]]
; TUNIT-NEXT:    [[CALL1:%.*]] = call ptr @not_captured_but_returned_1(ptr nofree writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9]]
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(argmem: write) uwtable
; CGSCC-LABEL: define void @test_not_captured_but_returned_calls
; CGSCC-SAME: (ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A:%.*]]) #[[ATTR5:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @not_captured_but_returned_0(ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A]]) #[[ATTR10:[0-9]+]]
; CGSCC-NEXT:    [[CALL1:%.*]] = call ptr @not_captured_but_returned_1(ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A]]) #[[ATTR10]]
; CGSCC-NEXT:    ret void
;
entry:
  %call = call ptr @not_captured_but_returned_0(ptr %a)
  %call1 = call ptr @not_captured_but_returned_1(ptr %a)
  ret void
}

; TEST "captured" only through transitive return
;
; long* negative_test_not_captured_but_returned_call_0a(long *a) {
;   return not_captured_but_returned_0(a);
; }
;
; There should *not* be a no-capture attribute on %a
define ptr @negative_test_not_captured_but_returned_call_0a(ptr %a) #0 {
; TUNIT: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; TUNIT-LABEL: define align 8 ptr @negative_test_not_captured_but_returned_call_0a
; TUNIT-SAME: (ptr nofree returned writeonly align 8 "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @not_captured_but_returned_0(ptr nofree noundef writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9]]
; TUNIT-NEXT:    ret ptr [[A]]
;
; CGSCC: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(argmem: write) uwtable
; CGSCC-LABEL: define noundef nonnull align 8 dereferenceable(8) ptr @negative_test_not_captured_but_returned_call_0a
; CGSCC-SAME: (ptr nofree noundef nonnull writeonly align 8 dereferenceable(8) [[A:%.*]]) #[[ATTR5]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call noundef nonnull align 8 dereferenceable(8) ptr @not_captured_but_returned_0(ptr nofree noundef nonnull writeonly align 8 dereferenceable(8) [[A]]) #[[ATTR10]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @not_captured_but_returned_0(ptr %a)
  ret ptr %call
}

; TEST captured through write
;
; void negative_test_not_captured_but_returned_call_0b(long *a) {
;   *a = (long)not_captured_but_returned_0(a);
; }
;
; There should *not* be a no-capture attribute on %a
define void @negative_test_not_captured_but_returned_call_0b(ptr %a) #0 {
; TUNIT: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; TUNIT-LABEL: define void @negative_test_not_captured_but_returned_call_0b
; TUNIT-SAME: (ptr nofree writeonly align 8 [[A:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @not_captured_but_returned_0(ptr nofree noundef writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9]]
; TUNIT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[A]] to i64
; TUNIT-NEXT:    store i64 [[TMP0]], ptr [[A]], align 8
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(argmem: write) uwtable
; CGSCC-LABEL: define void @negative_test_not_captured_but_returned_call_0b
; CGSCC-SAME: (ptr nofree noundef nonnull writeonly align 8 dereferenceable(8) [[A:%.*]]) #[[ATTR5]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @not_captured_but_returned_0(ptr nofree noundef nonnull writeonly align 8 dereferenceable(8) [[A]]) #[[ATTR10]]
; CGSCC-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[CALL]] to i64
; CGSCC-NEXT:    store i64 [[TMP0]], ptr [[A]], align 8
; CGSCC-NEXT:    ret void
;
entry:
  %call = call ptr @not_captured_but_returned_0(ptr %a)
  %0 = ptrtoint ptr %call to i64
  store i64 %0, ptr %a, align 8
  ret void
}

; TEST "captured" only through transitive return
;
; long* negative_test_not_captured_but_returned_call_1a(long *a) {
;   return not_captured_but_returned_1(a);
; }
;
; There should *not* be a no-capture attribute on %a
define ptr @negative_test_not_captured_but_returned_call_1a(ptr %a) #0 {
; TUNIT: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable
; TUNIT-LABEL: define noundef nonnull align 8 dereferenceable(8) ptr @negative_test_not_captured_but_returned_call_1a
; TUNIT-SAME: (ptr nofree writeonly align 8 "no-capture-maybe-returned" [[A:%.*]]) #[[ATTR4]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call noundef nonnull align 8 dereferenceable(8) ptr @not_captured_but_returned_1(ptr nofree writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9]]
; TUNIT-NEXT:    ret ptr [[CALL]]
;
; CGSCC: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(argmem: write) uwtable
; CGSCC-LABEL: define noundef nonnull align 8 dereferenceable(8) ptr @negative_test_not_captured_but_returned_call_1a
; CGSCC-SAME: (ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A:%.*]]) #[[ATTR5]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call noundef nonnull align 8 dereferenceable(8) ptr @not_captured_but_returned_1(ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A]]) #[[ATTR10]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @not_captured_but_returned_1(ptr %a)
  ret ptr %call
}

; TEST captured through write
;
; void negative_test_not_captured_but_returned_call_1b(long *a) {
;   *a = (long)not_captured_but_returned_1(a);
; }
;
; There should *not* be a no-capture attribute on %a
define void @negative_test_not_captured_but_returned_call_1b(ptr %a) #0 {
; TUNIT: Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write) uwtable
; TUNIT-LABEL: define void @negative_test_not_captured_but_returned_call_1b
; TUNIT-SAME: (ptr nofree writeonly align 8 [[A:%.*]]) #[[ATTR5:[0-9]+]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call align 8 ptr @not_captured_but_returned_1(ptr nofree writeonly align 8 "no-capture-maybe-returned" [[A]]) #[[ATTR9]]
; TUNIT-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[CALL]] to i64
; TUNIT-NEXT:    store i64 [[TMP0]], ptr [[CALL]], align 8
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree noinline nosync nounwind willreturn memory(write) uwtable
; CGSCC-LABEL: define void @negative_test_not_captured_but_returned_call_1b
; CGSCC-SAME: (ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A:%.*]]) #[[ATTR6:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call align 8 ptr @not_captured_but_returned_1(ptr nofree noundef nonnull writeonly align 8 dereferenceable(16) [[A]]) #[[ATTR10]]
; CGSCC-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[CALL]] to i64
; CGSCC-NEXT:    store i64 [[TMP0]], ptr [[CALL]], align 8
; CGSCC-NEXT:    ret void
;
entry:
  %call = call ptr @not_captured_but_returned_1(ptr %a)
  %0 = ptrtoint ptr %call to i64
  store i64 %0, ptr %call, align 8
  ret void
}

; TEST return argument or unknown call result
;
; int* ret_arg_or_unknown(int* b) {
;   if (b == 0)
;     return b;
;   return unknown();
; }
;
; Verify we do *not* assume b is returned or not captured.
;

define ptr @ret_arg_or_unknown(ptr %b) #0 {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: define ptr @ret_arg_or_unknown
; CHECK-SAME: (ptr [[B:%.*]]) #[[ATTR3]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr [[B]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[RET_ARG:%.*]], label [[RET_UNKNOWN:%.*]]
; CHECK:       ret_arg:
; CHECK-NEXT:    ret ptr [[B]]
; CHECK:       ret_unknown:
; CHECK-NEXT:    [[CALL:%.*]] = call ptr @unknown()
; CHECK-NEXT:    ret ptr [[CALL]]
;
entry:
  %cmp = icmp eq ptr %b, null
  br i1 %cmp, label %ret_arg, label %ret_unknown

ret_arg:
  ret ptr %b

ret_unknown:
  %call = call ptr @unknown()
  ret ptr %call
}

define ptr @ret_arg_or_unknown_through_phi(ptr %b) #0 {
; CHECK: Function Attrs: noinline nounwind uwtable
; CHECK-LABEL: define ptr @ret_arg_or_unknown_through_phi
; CHECK-SAME: (ptr [[B:%.*]]) #[[ATTR3]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq ptr [[B]], null
; CHECK-NEXT:    br i1 [[CMP]], label [[RET_ARG:%.*]], label [[RET_UNKNOWN:%.*]]
; CHECK:       ret_arg:
; CHECK-NEXT:    br label [[R:%.*]]
; CHECK:       ret_unknown:
; CHECK-NEXT:    [[CALL:%.*]] = call ptr @unknown()
; CHECK-NEXT:    br label [[R]]
; CHECK:       r:
; CHECK-NEXT:    [[PHI:%.*]] = phi ptr [ [[B]], [[RET_ARG]] ], [ [[CALL]], [[RET_UNKNOWN]] ]
; CHECK-NEXT:    ret ptr [[PHI]]
;
entry:
  %cmp = icmp eq ptr %b, null
  br i1 %cmp, label %ret_arg, label %ret_unknown

ret_arg:
  br label %r

ret_unknown:
  %call = call ptr @unknown()
  br label %r

r:
  %phi = phi ptr [ %b, %ret_arg ], [ %call, %ret_unknown ]
  ret ptr %phi
}


; TEST not captured by readonly external function
;
declare ptr @readonly_unknown(ptr, ptr) readonly

define void @not_captured_by_readonly_call(ptr %b) #0 {
; TUNIT: Function Attrs: noinline nounwind memory(read) uwtable
; TUNIT-LABEL: define void @not_captured_by_readonly_call
; TUNIT-SAME: (ptr nocapture readonly [[B:%.*]]) #[[ATTR7:[0-9]+]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown(ptr readonly [[B]], ptr readonly [[B]]) #[[ATTR6:[0-9]+]]
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: noinline nounwind memory(read) uwtable
; CGSCC-LABEL: define void @not_captured_by_readonly_call
; CGSCC-SAME: (ptr nocapture readonly [[B:%.*]]) #[[ATTR8:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown(ptr readonly [[B]], ptr readonly [[B]]) #[[ATTR7:[0-9]+]]
; CGSCC-NEXT:    ret void
;
entry:
  %call = call ptr @readonly_unknown(ptr %b, ptr %b)
  ret void
}


; TEST not captured by readonly external function if return chain is known
;
; Make sure the returned flag on %r is strong enough to justify nocapture on %b but **not** on %r.
;
define ptr @not_captured_by_readonly_call_not_returned_either1(ptr %b, ptr returned %r) {
; TUNIT: Function Attrs: nounwind memory(read)
; TUNIT-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either1
; TUNIT-SAME: (ptr nocapture readonly [[B:%.*]], ptr readonly returned [[R:%.*]]) #[[ATTR8:[0-9]+]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR8]]
; TUNIT-NEXT:    ret ptr [[CALL]]
;
; CGSCC: Function Attrs: nounwind memory(read)
; CGSCC-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either1
; CGSCC-SAME: (ptr nocapture readonly [[B:%.*]], ptr readonly returned [[R:%.*]]) #[[ATTR9:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR9]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @readonly_unknown(ptr %b, ptr %r) nounwind
  ret ptr %call
}

declare ptr @readonly_unknown_r1a(ptr, ptr returned) readonly
define ptr @not_captured_by_readonly_call_not_returned_either2(ptr %b, ptr %r) {
; TUNIT: Function Attrs: nounwind memory(read)
; TUNIT-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either2
; TUNIT-SAME: (ptr readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR8]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1a(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR8]]
; TUNIT-NEXT:    ret ptr [[CALL]]
;
; CGSCC: Function Attrs: nounwind memory(read)
; CGSCC-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either2
; CGSCC-SAME: (ptr readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1a(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR9]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @readonly_unknown_r1a(ptr %b, ptr %r) nounwind
  ret ptr %call
}

declare ptr @readonly_unknown_r1b(ptr, ptr returned) readonly nounwind
define ptr @not_captured_by_readonly_call_not_returned_either3(ptr %b, ptr %r) {
; TUNIT: Function Attrs: nounwind memory(read)
; TUNIT-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either3
; TUNIT-SAME: (ptr nocapture readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR8]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1b(ptr nocapture readonly [[B]], ptr readonly [[R]]) #[[ATTR8]]
; TUNIT-NEXT:    ret ptr [[CALL]]
;
; CGSCC: Function Attrs: nounwind memory(read)
; CGSCC-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either3
; CGSCC-SAME: (ptr nocapture readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1b(ptr nocapture readonly [[B]], ptr readonly [[R]]) #[[ATTR9]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @readonly_unknown_r1b(ptr %b, ptr %r)
  ret ptr %call
}

define ptr @not_captured_by_readonly_call_not_returned_either4(ptr %b, ptr %r) nounwind {
; TUNIT: Function Attrs: nounwind memory(read)
; TUNIT-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either4
; TUNIT-SAME: (ptr readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR8]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1a(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR6]]
; TUNIT-NEXT:    ret ptr [[CALL]]
;
; CGSCC: Function Attrs: nounwind memory(read)
; CGSCC-LABEL: define ptr @not_captured_by_readonly_call_not_returned_either4
; CGSCC-SAME: (ptr readonly [[B:%.*]], ptr readonly [[R:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_unknown_r1a(ptr readonly [[B]], ptr readonly [[R]]) #[[ATTR7]]
; CGSCC-NEXT:    ret ptr [[CALL]]
;
entry:
  %call = call ptr @readonly_unknown_r1a(ptr %b, ptr %r)
  ret ptr %call
}


declare ptr @unknown_i32p(ptr)
define void @nocapture_is_not_subsumed_1(ptr nocapture %b) {
; CHECK-LABEL: define void @nocapture_is_not_subsumed_1
; CHECK-SAME: (ptr nocapture [[B:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call ptr @unknown_i32p(ptr [[B]])
; CHECK-NEXT:    store i32 0, ptr [[CALL]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %call = call ptr @unknown_i32p(ptr %b)
  store i32 0, ptr %call
  ret void
}

declare ptr @readonly_i32p(ptr) readonly
define void @nocapture_is_not_subsumed_2(ptr nocapture %b) {
; TUNIT-LABEL: define void @nocapture_is_not_subsumed_2
; TUNIT-SAME: (ptr nocapture [[B:%.*]]) {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    [[CALL:%.*]] = call ptr @readonly_i32p(ptr readonly [[B]]) #[[ATTR6]]
; TUNIT-NEXT:    store i32 0, ptr [[CALL]], align 4
; TUNIT-NEXT:    ret void
;
; CGSCC-LABEL: define void @nocapture_is_not_subsumed_2
; CGSCC-SAME: (ptr nocapture [[B:%.*]]) {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[CALL:%.*]] = call ptr @readonly_i32p(ptr readonly [[B]]) #[[ATTR7]]
; CGSCC-NEXT:    store i32 0, ptr [[CALL]], align 4
; CGSCC-NEXT:    ret void
;
entry:
  %call = call ptr @readonly_i32p(ptr %b)
  store i32 0, ptr %call
  ret void
}

attributes #0 = { noinline nounwind uwtable }
;.
; TUNIT: attributes #[[ATTR0]] = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable }
; TUNIT: attributes #[[ATTR1]] = { mustprogress nofree noinline nosync nounwind willreturn memory(none) uwtable }
; TUNIT: attributes #[[ATTR2]] = { nofree nosync nounwind memory(none) }
; TUNIT: attributes #[[ATTR3]] = { noinline nounwind uwtable }
; TUNIT: attributes #[[ATTR4]] = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable }
; TUNIT: attributes #[[ATTR5]] = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(write) uwtable }
; TUNIT: attributes #[[ATTR6]] = { memory(read) }
; TUNIT: attributes #[[ATTR7]] = { noinline nounwind memory(read) uwtable }
; TUNIT: attributes #[[ATTR8]] = { nounwind memory(read) }
; TUNIT: attributes #[[ATTR9]] = { nofree nosync nounwind willreturn memory(write) }
;.
; CGSCC: attributes #[[ATTR0]] = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable }
; CGSCC: attributes #[[ATTR1]] = { mustprogress nofree noinline nosync nounwind willreturn memory(none) uwtable }
; CGSCC: attributes #[[ATTR2]] = { nofree nosync nounwind memory(none) }
; CGSCC: attributes #[[ATTR3]] = { noinline nounwind uwtable }
; CGSCC: attributes #[[ATTR4]] = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(argmem: write) uwtable }
; CGSCC: attributes #[[ATTR5]] = { mustprogress nofree noinline nosync nounwind willreturn memory(argmem: write) uwtable }
; CGSCC: attributes #[[ATTR6]] = { mustprogress nofree noinline nosync nounwind willreturn memory(write) uwtable }
; CGSCC: attributes #[[ATTR7]] = { memory(read) }
; CGSCC: attributes #[[ATTR8]] = { noinline nounwind memory(read) uwtable }
; CGSCC: attributes #[[ATTR9]] = { nounwind memory(read) }
; CGSCC: attributes #[[ATTR10]] = { nofree nounwind willreturn memory(write) }
;.
