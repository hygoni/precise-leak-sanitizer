; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --scrub-attributes --check-globals
; RUN: opt '-passes=simplifycfg<switch-to-lookup>' -data-layout="e" -S %s | FileCheck %s
;; If basic integer types are natively supported, the value is generated inline instead of using a global
; RUN: opt '-passes=simplifycfg<switch-to-lookup>' -data-layout="e-n8:16:32:64" -S %s | FileCheck %s --check-prefix=INLINE
target triple = "x86_64-unknown-linux-gnu"

;.
; CHECK: @[[SWITCH_TABLE_SWITCH_TO_LOOKUP_I64:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [3 x i8] c"\03\01\02", align 1
; CHECK: @[[SWITCH_TABLE_SWITCH_TO_LOOKUP_I128:[a-zA-Z0-9_$"\\.-]+]] = private unnamed_addr constant [3 x i8] c"\03\01\02", align 1
;.
define i8 @switch_to_lookup_i64(i64 %x){
; CHECK-LABEL: @switch_to_lookup_i64(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i64 [[X:%.*]], 3
; CHECK-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[COMMON_RET:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    [[COMMON_RET_OP:%.*]] = phi i8 [ [[SWITCH_LOAD:%.*]], [[SWITCH_LOOKUP]] ], [ 10, [[START:%.*]] ]
; CHECK-NEXT:    ret i8 [[COMMON_RET_OP]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i8], ptr @switch.table.switch_to_lookup_i64, i32 0, i64 [[X]]
; CHECK-NEXT:    [[SWITCH_LOAD]] = load i8, ptr [[SWITCH_GEP]], align 1
; CHECK-NEXT:    br label [[COMMON_RET]]
;
; INLINE-LABEL: @switch_to_lookup_i64(
; INLINE-NEXT:  start:
; INLINE-NEXT:    [[TMP0:%.*]] = icmp ult i64 [[X:%.*]], 3
; INLINE-NEXT:    [[SWITCH_CAST:%.*]] = trunc i64 [[X]] to i24
; INLINE-NEXT:    [[SWITCH_SHIFTAMT:%.*]] = mul nuw nsw i24 [[SWITCH_CAST]], 8
; INLINE-NEXT:    [[SWITCH_DOWNSHIFT:%.*]] = lshr i24 131331, [[SWITCH_SHIFTAMT]]
; INLINE-NEXT:    [[SWITCH_MASKED:%.*]] = trunc i24 [[SWITCH_DOWNSHIFT]] to i8
; INLINE-NEXT:    [[COMMON_RET_OP:%.*]] = select i1 [[TMP0]], i8 [[SWITCH_MASKED]], i8 10
; INLINE-NEXT:    ret i8 [[COMMON_RET_OP]]
;
start:
  switch i64 %x, label %default [
  i64 0, label %end
  i64 1, label %bb1
  i64 2, label %bb2
  ]

bb1:
  br label %end

bb2:
  br label %end

default:
  ret i8 10

end:
  %p = phi i8 [ 1, %bb1 ], [ 2, %bb2 ], [ 3, %start ]
  ret i8 %p
}

define i8 @switch_to_lookup_i128(i128 %x){
; CHECK-LABEL: @switch_to_lookup_i128(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ult i128 [[X:%.*]], 3
; CHECK-NEXT:    br i1 [[TMP0]], label [[SWITCH_LOOKUP:%.*]], label [[COMMON_RET:%.*]]
; CHECK:       common.ret:
; CHECK-NEXT:    [[COMMON_RET_OP:%.*]] = phi i8 [ [[SWITCH_LOAD:%.*]], [[SWITCH_LOOKUP]] ], [ 10, [[START:%.*]] ]
; CHECK-NEXT:    ret i8 [[COMMON_RET_OP]]
; CHECK:       switch.lookup:
; CHECK-NEXT:    [[SWITCH_GEP:%.*]] = getelementptr inbounds [3 x i8], ptr @switch.table.switch_to_lookup_i128, i32 0, i128 [[X]]
; CHECK-NEXT:    [[SWITCH_LOAD]] = load i8, ptr [[SWITCH_GEP]], align 1
; CHECK-NEXT:    br label [[COMMON_RET]]
;
; INLINE-LABEL: @switch_to_lookup_i128(
; INLINE-NEXT:  start:
; INLINE-NEXT:    [[TMP0:%.*]] = icmp ult i128 [[X:%.*]], 3
; INLINE-NEXT:    [[SWITCH_CAST:%.*]] = trunc i128 [[X]] to i24
; INLINE-NEXT:    [[SWITCH_SHIFTAMT:%.*]] = mul nuw nsw i24 [[SWITCH_CAST]], 8
; INLINE-NEXT:    [[SWITCH_DOWNSHIFT:%.*]] = lshr i24 131331, [[SWITCH_SHIFTAMT]]
; INLINE-NEXT:    [[SWITCH_MASKED:%.*]] = trunc i24 [[SWITCH_DOWNSHIFT]] to i8
; INLINE-NEXT:    [[COMMON_RET_OP:%.*]] = select i1 [[TMP0]], i8 [[SWITCH_MASKED]], i8 10
; INLINE-NEXT:    ret i8 [[COMMON_RET_OP]]
;
start:
  switch i128 %x, label %default [
  i128 0, label %end
  i128 1, label %bb1
  i128 2, label %bb2
  ]

bb1:
  br label %end

bb2:
  br label %end

default:
  ret i8 10

end:
  %p = phi i8 [ 1, %bb1 ], [ 2, %bb2 ], [ 3, %start ]
  ret i8 %p
}
