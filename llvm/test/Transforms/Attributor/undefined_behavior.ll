; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-annotate-decl-cs  -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Test cases specifically designed for the "undefined behavior" abstract function attribute.
; We want to verify that whenever undefined behavior is assumed, the code becomes unreachable.
; We use FIXME's to indicate problems and missing attributes.

; -- Load tests --

define void @load_wholly_unreachable() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@load_wholly_unreachable
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    unreachable
;
  %a = load i32, ptr null
  ret void
}

define void @loads_wholly_unreachable() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@loads_wholly_unreachable
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %a = load i32, ptr null
  %b = load i32, ptr null
  ret void
}


define void @load_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@load_single_bb_unreachable
; CHECK-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %b = load i32, ptr null
  br label %e
e:
  ret void
}

; Note that while the load is removed (because it's unused), the block
; is not changed to unreachable
define void @load_null_pointer_is_defined() null_pointer_is_valid {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@load_null_pointer_is_defined
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    ret void
;
  %a = load i32, ptr null
  ret void
}

define internal ptr @ret_null() {
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@ret_null
; CGSCC-SAME: () #[[ATTR0]] {
; CGSCC-NEXT:    ret ptr null
;
  ret ptr null
}

define void @load_null_propagated() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@load_null_propagated
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@load_null_propagated
; CGSCC-SAME: () #[[ATTR2:[0-9]+]] {
; CGSCC-NEXT:    ret void
;
  %ptr = call ptr @ret_null()
  %a = load i32, ptr %ptr
  ret void
}

; -- Store tests --

define void @store_wholly_unreachable() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@store_wholly_unreachable
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  store i32 5, ptr null
  ret void
}

define void @store_wholly_unreachable_volatile() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@store_wholly_unreachable_volatile
; TUNIT-SAME: () #[[ATTR2:[0-9]+]] {
; TUNIT-NEXT:    store volatile i32 5, ptr null, align 4294967296
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@store_wholly_unreachable_volatile
; CGSCC-SAME: () #[[ATTR3:[0-9]+]] {
; CGSCC-NEXT:    store volatile i32 5, ptr null, align 4294967296
; CGSCC-NEXT:    ret void
;
  store volatile i32 5, ptr null
  ret void
}

define void @store_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@store_single_bb_unreachable
; CHECK-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  store i32 5, ptr null
  br label %e
e:
  ret void
}

define void @store_null_pointer_is_defined() null_pointer_is_valid {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(write)
; TUNIT-LABEL: define {{[^@]+}}@store_null_pointer_is_defined
; TUNIT-SAME: () #[[ATTR3:[0-9]+]] {
; TUNIT-NEXT:    store i32 5, ptr null, align 4294967296
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(write)
; CGSCC-LABEL: define {{[^@]+}}@store_null_pointer_is_defined
; CGSCC-SAME: () #[[ATTR4:[0-9]+]] {
; CGSCC-NEXT:    store i32 5, ptr null, align 4294967296
; CGSCC-NEXT:    ret void
;
  store i32 5, ptr null
  ret void
}

define void @store_null_propagated() {
; ATTRIBUTOR-LABEL: @store_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@store_null_propagated
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(write)
; CGSCC-LABEL: define {{[^@]+}}@store_null_propagated
; CGSCC-SAME: () #[[ATTR5:[0-9]+]] {
; CGSCC-NEXT:    [[PTR:%.*]] = call noalias align 4294967296 ptr @ret_null() #[[ATTR10:[0-9]+]]
; CGSCC-NEXT:    ret void
;
  %ptr = call ptr @ret_null()
  store i32 5, ptr %ptr
  ret void
}

; -- AtomicRMW tests --

define void @atomicrmw_wholly_unreachable() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomicrmw_wholly_unreachable
; TUNIT-SAME: () #[[ATTR2]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@atomicrmw_wholly_unreachable
; CGSCC-SAME: () #[[ATTR3]] {
; CGSCC-NEXT:    unreachable
;
  %a = atomicrmw add ptr null, i32 1 acquire
  ret void
}

define void @atomicrmw_single_bb_unreachable(i1 %cond) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomicrmw_single_bb_unreachable
; TUNIT-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR2]] {
; TUNIT-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@atomicrmw_single_bb_unreachable
; CGSCC-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    unreachable
; CGSCC:       e:
; CGSCC-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %a = atomicrmw add ptr null, i32 1 acquire
  br label %e
e:
  ret void
}

define void @atomicrmw_null_pointer_is_defined() null_pointer_is_valid {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn
; TUNIT-LABEL: define {{[^@]+}}@atomicrmw_null_pointer_is_defined
; TUNIT-SAME: () #[[ATTR4:[0-9]+]] {
; TUNIT-NEXT:    [[A:%.*]] = atomicrmw add ptr null, i32 1 acquire, align 4
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn
; CGSCC-LABEL: define {{[^@]+}}@atomicrmw_null_pointer_is_defined
; CGSCC-SAME: () #[[ATTR6:[0-9]+]] {
; CGSCC-NEXT:    [[A:%.*]] = atomicrmw add ptr null, i32 1 acquire, align 4
; CGSCC-NEXT:    ret void
;
  %a = atomicrmw add ptr null, i32 1 acquire
  ret void
}

define void @atomicrmw_null_propagated() {
; ATTRIBUTOR-LABEL: @atomicrmw_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomicrmw_null_propagated
; TUNIT-SAME: () #[[ATTR2]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nounwind willreturn
; CGSCC-LABEL: define {{[^@]+}}@atomicrmw_null_propagated
; CGSCC-SAME: () #[[ATTR7:[0-9]+]] {
; CGSCC-NEXT:    [[PTR:%.*]] = call noalias ptr @ret_null() #[[ATTR10]]
; CGSCC-NEXT:    [[A:%.*]] = atomicrmw add ptr [[PTR]], i32 1 acquire, align 4
; CGSCC-NEXT:    ret void
;
  %ptr = call ptr @ret_null()
  %a = atomicrmw add ptr %ptr, i32 1 acquire
  ret void
}

; -- AtomicCmpXchg tests --

define void @atomiccmpxchg_wholly_unreachable() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomiccmpxchg_wholly_unreachable
; TUNIT-SAME: () #[[ATTR2]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@atomiccmpxchg_wholly_unreachable
; CGSCC-SAME: () #[[ATTR3]] {
; CGSCC-NEXT:    unreachable
;
  %a = cmpxchg ptr null, i32 2, i32 3 acq_rel monotonic
  ret void
}

define void @atomiccmpxchg_single_bb_unreachable(i1 %cond) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomiccmpxchg_single_bb_unreachable
; TUNIT-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR2]] {
; TUNIT-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@atomiccmpxchg_single_bb_unreachable
; CGSCC-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR3]] {
; CGSCC-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    unreachable
; CGSCC:       e:
; CGSCC-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %a = cmpxchg ptr null, i32 2, i32 3 acq_rel monotonic
  br label %e
e:
  ret void
}

define void @atomiccmpxchg_null_pointer_is_defined() null_pointer_is_valid {
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn
; TUNIT-LABEL: define {{[^@]+}}@atomiccmpxchg_null_pointer_is_defined
; TUNIT-SAME: () #[[ATTR4]] {
; TUNIT-NEXT:    [[A:%.*]] = cmpxchg ptr null, i32 2, i32 3 acq_rel monotonic, align 4
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn
; CGSCC-LABEL: define {{[^@]+}}@atomiccmpxchg_null_pointer_is_defined
; CGSCC-SAME: () #[[ATTR6]] {
; CGSCC-NEXT:    [[A:%.*]] = cmpxchg ptr null, i32 2, i32 3 acq_rel monotonic, align 4
; CGSCC-NEXT:    ret void
;
  %a = cmpxchg ptr null, i32 2, i32 3 acq_rel monotonic
  ret void
}

define void @atomiccmpxchg_null_propagated() {
; ATTRIBUTOR-LABEL: @atomiccmpxchg_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; TUNIT: Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@atomiccmpxchg_null_propagated
; TUNIT-SAME: () #[[ATTR2]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nounwind willreturn
; CGSCC-LABEL: define {{[^@]+}}@atomiccmpxchg_null_propagated
; CGSCC-SAME: () #[[ATTR7]] {
; CGSCC-NEXT:    [[PTR:%.*]] = call noalias ptr @ret_null() #[[ATTR10]]
; CGSCC-NEXT:    [[A:%.*]] = cmpxchg ptr [[PTR]], i32 2, i32 3 acq_rel monotonic, align 4
; CGSCC-NEXT:    ret void
;
  %ptr = call ptr @ret_null()
  %a = cmpxchg ptr %ptr, i32 2, i32 3 acq_rel monotonic
  ret void
}

; -- Conditional branching tests --

; Note: The unreachable on %t and %e is _not_ from AAUndefinedBehavior

define i32 @cond_br_on_undef() {
; TUNIT: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@cond_br_on_undef
; TUNIT-SAME: () #[[ATTR5:[0-9]+]] {
; TUNIT-NEXT:    unreachable
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@cond_br_on_undef
; CGSCC-SAME: () #[[ATTR8:[0-9]+]] {
; CGSCC-NEXT:    unreachable
; CGSCC:       t:
; CGSCC-NEXT:    unreachable
; CGSCC:       e:
; CGSCC-NEXT:    unreachable
;
  br i1 undef, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; More complicated branching
  ; Valid branch - verify that this is not converted
  ; to unreachable.
define void @cond_br_on_undef2(i1 %cond) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef2
; CHECK-SAME: (i1 noundef [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T1:%.*]], label [[E1:%.*]]
; CHECK:       t1:
; CHECK-NEXT:    unreachable
; CHECK:       t2:
; CHECK-NEXT:    unreachable
; CHECK:       e2:
; CHECK-NEXT:    unreachable
; CHECK:       e1:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t1, label %e1
t1:
  br i1 undef, label %t2, label %e2
t2:
  ret void
e2:
  ret void
e1:
  ret void
}

define i1 @ret_undef() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@ret_undef
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i1 undef
;
  ret i1 undef
}

define void @cond_br_on_undef_interproc() {
; TUNIT: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc
; TUNIT-SAME: () #[[ATTR5]] {
; TUNIT-NEXT:    unreachable
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    [[COND:%.*]] = call i1 @ret_undef() #[[ATTR10]]
; CGSCC-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    ret void
; CGSCC:       e:
; CGSCC-NEXT:    ret void
;
  %cond = call i1 @ret_undef()
  br i1 %cond, label %t, label %e
t:
  ret void
e:
  ret void
}

define i1 @ret_undef2() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@ret_undef2
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    br i1 true, label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 undef
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  br i1 true, label %t, label %e
t:
  ret i1 undef
e:
  ret i1 undef
}

; More complicated interproc deduction of undef
define void @cond_br_on_undef_interproc2() {
; TUNIT: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc2
; TUNIT-SAME: () #[[ATTR5]] {
; TUNIT-NEXT:    unreachable
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc2
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    [[COND:%.*]] = call i1 @ret_undef2() #[[ATTR10]]
; CGSCC-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    ret void
; CGSCC:       e:
; CGSCC-NEXT:    ret void
;
  %cond = call i1 @ret_undef2()
  br i1 %cond, label %t, label %e
t:
  ret void
e:
  ret void
}

; Branch on undef that depends on propagation of
; undef of a previous instruction.
define i32 @cond_br_on_undef3() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef3
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 1, undef
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i32 1
; CHECK:       e:
; CHECK-NEXT:    ret i32 2
;
  %cond = icmp ne i32 1, undef
  br i1 %cond, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; Branch on undef because of uninitialized value.
; FIXME: Currently it doesn't propagate the undef.
define i32 @cond_br_on_undef_uninit() {
; TUNIT: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@cond_br_on_undef_uninit
; TUNIT-SAME: () #[[ATTR5]] {
; TUNIT-NEXT:    unreachable
; TUNIT:       t:
; TUNIT-NEXT:    unreachable
; TUNIT:       e:
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@cond_br_on_undef_uninit
; CGSCC-SAME: () #[[ATTR8]] {
; CGSCC-NEXT:    unreachable
; CGSCC:       t:
; CGSCC-NEXT:    unreachable
; CGSCC:       e:
; CGSCC-NEXT:    unreachable
;
  %alloc = alloca i1
  %cond = load i1, ptr %alloc
  br i1 %cond, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; Note that the `load` has UB (so it will be changed to unreachable)
; and the branch is a terminator that can be constant-folded.
; We want to test that doing both won't cause a segfault.
; MODULE-NOT: @callee(
define internal i32 @callee(i1 %C, ptr %A) {
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@callee
; CGSCC-SAME: () #[[ATTR0]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    unreachable
; CGSCC:       T:
; CGSCC-NEXT:    unreachable
; CGSCC:       F:
; CGSCC-NEXT:    ret i32 1
;
entry:
  %A.0 = load i32, ptr null
  br i1 %C, label %T, label %F

T:
  ret i32 %A.0

F:
  ret i32 1
}

define i32 @foo() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@foo
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    ret i32 1
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@foo
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    [[X:%.*]] = call noundef i32 @callee() #[[ATTR10]]
; CGSCC-NEXT:    ret i32 [[X]]
;
  %X = call i32 @callee(i1 false, ptr null)
  ret i32 %X
}

; Tests for nonnull noundef attribute violation.
;
; Tests for argument position

define void @arg_nonnull_1(ptr nonnull %a) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_1
; TUNIT-SAME: (ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR6:[0-9]+]] {
; TUNIT-NEXT:    store i32 0, ptr [[A]], align 4
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_1
; CGSCC-SAME: (ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR9:[0-9]+]] {
; CGSCC-NEXT:    store i32 0, ptr [[A]], align 4
; CGSCC-NEXT:    ret void
;
  store i32 0, ptr %a
  ret void
}

define void @arg_nonnull_1_noundef_1(ptr nonnull noundef %a) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_1_noundef_1
; TUNIT-SAME: (ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR6]] {
; TUNIT-NEXT:    store i32 0, ptr [[A]], align 4
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_1_noundef_1
; CGSCC-SAME: (ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:    store i32 0, ptr [[A]], align 4
; CGSCC-NEXT:    ret void
;
  store i32 0, ptr %a
  ret void
}

define void @arg_nonnull_12(ptr nonnull %a, ptr nonnull %b, ptr %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_12
; TUNIT-SAME: (ptr nocapture nofree nonnull writeonly [[A:%.*]], ptr nocapture nofree nonnull writeonly [[B:%.*]], ptr nofree writeonly [[C:%.*]]) #[[ATTR6]] {
; TUNIT-NEXT:    [[D:%.*]] = icmp eq ptr [[C]], null
; TUNIT-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    store i32 0, ptr [[A]], align 4
; TUNIT-NEXT:    br label [[RET:%.*]]
; TUNIT:       f:
; TUNIT-NEXT:    store i32 1, ptr [[B]], align 4
; TUNIT-NEXT:    br label [[RET]]
; TUNIT:       ret:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_12
; CGSCC-SAME: (ptr nocapture nofree nonnull writeonly [[A:%.*]], ptr nocapture nofree nonnull writeonly [[B:%.*]], ptr nofree writeonly [[C:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:    [[D:%.*]] = icmp eq ptr [[C]], null
; CGSCC-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    store i32 0, ptr [[A]], align 4
; CGSCC-NEXT:    br label [[RET:%.*]]
; CGSCC:       f:
; CGSCC-NEXT:    store i32 1, ptr [[B]], align 4
; CGSCC-NEXT:    br label [[RET]]
; CGSCC:       ret:
; CGSCC-NEXT:    ret void
;
  %d = icmp eq ptr %c, null
  br i1 %d, label %t, label %f
t:
  store i32 0, ptr %a
  br label %ret
f:
  store i32 1, ptr %b
  br label %ret
ret:
  ret void
}

define void @arg_nonnull_12_noundef_2(ptr nonnull %a, ptr noundef nonnull %b, ptr %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_12_noundef_2
; TUNIT-SAME: (ptr nocapture nofree nonnull writeonly [[A:%.*]], ptr nocapture nofree noundef nonnull writeonly [[B:%.*]], ptr nofree writeonly [[C:%.*]]) #[[ATTR6]] {
; TUNIT-NEXT:    [[D:%.*]] = icmp eq ptr [[C]], null
; TUNIT-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    store i32 0, ptr [[A]], align 4
; TUNIT-NEXT:    br label [[RET:%.*]]
; TUNIT:       f:
; TUNIT-NEXT:    store i32 1, ptr [[B]], align 4
; TUNIT-NEXT:    br label [[RET]]
; TUNIT:       ret:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_12_noundef_2
; CGSCC-SAME: (ptr nocapture nofree nonnull writeonly [[A:%.*]], ptr nocapture nofree noundef nonnull writeonly [[B:%.*]], ptr nofree writeonly [[C:%.*]]) #[[ATTR9]] {
; CGSCC-NEXT:    [[D:%.*]] = icmp eq ptr [[C]], null
; CGSCC-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    store i32 0, ptr [[A]], align 4
; CGSCC-NEXT:    br label [[RET:%.*]]
; CGSCC:       f:
; CGSCC-NEXT:    store i32 1, ptr [[B]], align 4
; CGSCC-NEXT:    br label [[RET]]
; CGSCC:       ret:
; CGSCC-NEXT:    ret void
;
  %d = icmp eq ptr %c, null
  br i1 %d, label %t, label %f
t:
  store i32 0, ptr %a
  br label %ret
f:
  store i32 1, ptr %b
  br label %ret
ret:
  ret void
}

; Pass null directly to argument with nonnull attribute
define void @arg_nonnull_violation1_1() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation1_1
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation1_1
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    unreachable
;
  call void @arg_nonnull_1(ptr null)
  ret void
}

define void @arg_nonnull_violation1_2() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation1_2
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation1_2
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    unreachable
;
  call void @arg_nonnull_1_noundef_1(ptr null)
  ret void
}

; A case that depends on value simplification
define void @arg_nonnull_violation2_1(i1 %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation2_1
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation2_1
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    unreachable
;
  %mustnull = select i1 %c, ptr null, ptr null
  call void @arg_nonnull_1(ptr %mustnull)
  ret void
}

define void @arg_nonnull_violation2_2(i1 %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation2_2
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    unreachable
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation2_2
; CGSCC-SAME: (i1 [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    unreachable
;
  %mustnull = select i1 %c, ptr null, ptr null
  call void @arg_nonnull_1_noundef_1(ptr %mustnull)
  ret void
}

; Cases for single and multiple violation at a callsite
define void @arg_nonnull_violation3_1(i1 %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation3_1
; TUNIT-SAME: (i1 noundef [[C:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    call void @arg_nonnull_12(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR7:[0-9]+]]
; TUNIT-NEXT:    call void @arg_nonnull_12(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef writeonly align 4294967296 null) #[[ATTR7]]
; TUNIT-NEXT:    unreachable
; TUNIT:       f:
; TUNIT-NEXT:    unreachable
; TUNIT:       ret:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation3_1
; CGSCC-SAME: (i1 noundef [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    call void @arg_nonnull_12(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR11:[0-9]+]]
; CGSCC-NEXT:    call void @arg_nonnull_12(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef writeonly align 4294967296 null) #[[ATTR11]]
; CGSCC-NEXT:    unreachable
; CGSCC:       f:
; CGSCC-NEXT:    unreachable
; CGSCC:       ret:
; CGSCC-NEXT:    ret void
;
  %ptr = alloca i32
  br i1 %c, label %t, label %f
t:
  call void @arg_nonnull_12(ptr %ptr, ptr %ptr, ptr %ptr)
  call void @arg_nonnull_12(ptr %ptr, ptr %ptr, ptr null)
  call void @arg_nonnull_12(ptr %ptr, ptr null, ptr %ptr)
  call void @arg_nonnull_12(ptr %ptr, ptr null, ptr null)
  br label %ret
f:
  call void @arg_nonnull_12(ptr null, ptr %ptr, ptr %ptr)
  call void @arg_nonnull_12(ptr null, ptr %ptr, ptr null)
  call void @arg_nonnull_12(ptr null, ptr null, ptr %ptr)
  call void @arg_nonnull_12(ptr null, ptr null, ptr null)
  br label %ret
ret:
  ret void
}

define void @arg_nonnull_violation3_2(i1 %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@arg_nonnull_violation3_2
; TUNIT-SAME: (i1 noundef [[C:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; TUNIT-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; TUNIT:       t:
; TUNIT-NEXT:    call void @arg_nonnull_12_noundef_2(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR7]]
; TUNIT-NEXT:    call void @arg_nonnull_12_noundef_2(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef writeonly align 4294967296 null) #[[ATTR7]]
; TUNIT-NEXT:    unreachable
; TUNIT:       f:
; TUNIT-NEXT:    unreachable
; TUNIT:       ret:
; TUNIT-NEXT:    ret void
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@arg_nonnull_violation3_2
; CGSCC-SAME: (i1 noundef [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CGSCC-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CGSCC:       t:
; CGSCC-NEXT:    call void @arg_nonnull_12_noundef_2(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR11]]
; CGSCC-NEXT:    call void @arg_nonnull_12_noundef_2(ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], ptr nofree noundef writeonly align 4294967296 null) #[[ATTR11]]
; CGSCC-NEXT:    unreachable
; CGSCC:       f:
; CGSCC-NEXT:    unreachable
; CGSCC:       ret:
; CGSCC-NEXT:    ret void
;
  %ptr = alloca i32
  br i1 %c, label %t, label %f
t:
  call void @arg_nonnull_12_noundef_2(ptr %ptr, ptr %ptr, ptr %ptr)
  call void @arg_nonnull_12_noundef_2(ptr %ptr, ptr %ptr, ptr null)
  call void @arg_nonnull_12_noundef_2(ptr %ptr, ptr null, ptr %ptr)
  call void @arg_nonnull_12_noundef_2(ptr %ptr, ptr null, ptr null)
  br label %ret
f:
  call void @arg_nonnull_12_noundef_2(ptr null, ptr %ptr, ptr %ptr)
  call void @arg_nonnull_12_noundef_2(ptr null, ptr %ptr, ptr null)
  call void @arg_nonnull_12_noundef_2(ptr null, ptr null, ptr %ptr)
  call void @arg_nonnull_12_noundef_2(ptr null, ptr null, ptr null)
  br label %ret
ret:
  ret void
}

; Tests for returned position

define nonnull ptr @returned_nonnnull(i32 %c) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull
; CHECK-SAME: (i32 noundef [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret ptr [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    ret ptr null
; CHECK:       ondefault:
; CHECK-NEXT:    ret ptr undef
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret ptr %ptr
onone:
  ret ptr null
ondefault:
  ret ptr undef
}

define noundef ptr @returned_noundef(i32 %c) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@returned_noundef
; CHECK-SAME: (i32 noundef [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret ptr [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    ret ptr null
; CHECK:       ondefault:
; CHECK-NEXT:    unreachable
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret ptr %ptr
onone:
  ret ptr null
ondefault:
  ret ptr undef
}

define nonnull noundef ptr @returned_nonnnull_noundef(i32 %c) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull_noundef
; CHECK-SAME: (i32 noundef [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret ptr [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    unreachable
; CHECK:       ondefault:
; CHECK-NEXT:    unreachable
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret ptr %ptr
onone:
  ret ptr null
ondefault:
  ret ptr undef
}

define noundef i32 @returned_nonnnull_noundef_int() {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull_noundef_int
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

declare void @callee_int_arg(i32)

define void @callsite_noundef_1() {
; CHECK-LABEL: define {{[^@]+}}@callsite_noundef_1() {
; CHECK-NEXT:    call void @callee_int_arg(i32 noundef 0)
; CHECK-NEXT:    ret void
;
  call void @callee_int_arg(i32 noundef 0)
  ret void
}

declare void @callee_ptr_arg(ptr)

define void @callsite_noundef_2() {
; CHECK-LABEL: define {{[^@]+}}@callsite_noundef_2() {
; CHECK-NEXT:    unreachable
;
  call void @callee_ptr_arg(ptr noundef undef)
  ret void
}

define i32 @argument_noundef1(i32 noundef %c) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@argument_noundef1
; CHECK-SAME: (i32 noundef returned [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    ret i32 [[C]]
;
  ret i32 %c
}

define i32 @violate_noundef_nonpointer() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@violate_noundef_nonpointer
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    ret i32 undef
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@violate_noundef_nonpointer
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    unreachable
;
  %ret = call i32 @argument_noundef1(i32 undef)
  ret i32 %ret
}

define ptr @argument_noundef2(ptr noundef %c) {
; CHECK: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CHECK-LABEL: define {{[^@]+}}@argument_noundef2
; CHECK-SAME: (ptr nofree noundef readnone returned "no-capture-maybe-returned" [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    ret ptr [[C]]
;
  ret ptr %c
}

define ptr @violate_noundef_pointer() {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@violate_noundef_pointer
; TUNIT-SAME: () #[[ATTR0]] {
; TUNIT-NEXT:    ret ptr undef
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@violate_noundef_pointer
; CGSCC-SAME: () #[[ATTR2]] {
; CGSCC-NEXT:    ret ptr undef
;
  %ret = call ptr @argument_noundef2(ptr undef)
  ret ptr %ret
}

define internal noundef i32 @assumed_undef_is_ok(i1 %c, i32 %arg) {
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@assumed_undef_is_ok
; CGSCC-SAME: (i1 noundef [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    br i1 [[C]], label [[REC:%.*]], label [[RET:%.*]]
; CGSCC:       rec:
; CGSCC-NEXT:    br label [[RET]]
; CGSCC:       ret:
; CGSCC-NEXT:    ret i32 0
;
  %stack = alloca i32
  store i32 %arg, ptr %stack
  br i1 %c, label %rec, label %ret
rec:
  %call = call i32 @assumed_undef_is_ok(i1 false, i32 0)
  store i32 %call, ptr %stack
  br label %ret
ret:
  %l = load i32, ptr %stack
  ret i32 %l
}

define noundef i32 @assumed_undef_is_ok_caller(i1 %c) {
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@assumed_undef_is_ok_caller
; TUNIT-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; TUNIT-NEXT:    ret i32 0
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@assumed_undef_is_ok_caller
; CGSCC-SAME: (i1 noundef [[C:%.*]]) #[[ATTR2]] {
; CGSCC-NEXT:    [[CALL:%.*]] = call i32 @assumed_undef_is_ok(i1 noundef [[C]]) #[[ATTR10]]
; CGSCC-NEXT:    ret i32 [[CALL]]
;
  %call = call i32 @assumed_undef_is_ok(i1 %c, i32 undef)
  ret i32 %call
}

;.
; TUNIT: attributes #[[ATTR0]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
; TUNIT: attributes #[[ATTR1]] = { mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(none) }
; TUNIT: attributes #[[ATTR2]] = { mustprogress nofree norecurse nounwind willreturn memory(none) }
; TUNIT: attributes #[[ATTR3]] = { mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(write) }
; TUNIT: attributes #[[ATTR4]] = { mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn }
; TUNIT: attributes #[[ATTR5]] = { mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none) }
; TUNIT: attributes #[[ATTR6]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
; TUNIT: attributes #[[ATTR7]] = { nofree nosync nounwind willreturn memory(write) }
;.
; CGSCC: attributes #[[ATTR0]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR1]] = { mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(none) }
; CGSCC: attributes #[[ATTR2]] = { mustprogress nofree nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR3]] = { mustprogress nofree norecurse nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR4]] = { mustprogress nofree norecurse nosync nounwind null_pointer_is_valid willreturn memory(write) }
; CGSCC: attributes #[[ATTR5]] = { mustprogress nofree nosync nounwind willreturn memory(write) }
; CGSCC: attributes #[[ATTR6]] = { mustprogress nofree norecurse nounwind null_pointer_is_valid willreturn }
; CGSCC: attributes #[[ATTR7]] = { mustprogress nofree nounwind willreturn }
; CGSCC: attributes #[[ATTR8]] = { mustprogress nofree norecurse noreturn nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR9]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
; CGSCC: attributes #[[ATTR10]] = { nofree willreturn }
; CGSCC: attributes #[[ATTR11]] = { nofree nounwind willreturn memory(write) }
;.
