; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --check-globals
; RUN: opt -passes=globalopt -S %s | FileCheck %s

%struct.20ptr = type { ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }

@global.20ptr = internal global %struct.20ptr zeroinitializer

@c = global ptr null

;.
; CHECK: @[[C:[a-zA-Z0-9_$"\\.-]+]] = global ptr null
; CHECK: @[[GLOBAL_20PTR_3:[a-zA-Z0-9_$"\\.-]+]] = internal unnamed_addr global [[STRUCT_20PTR:%.*]] { ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr null, ptr null, ptr null, ptr @c }
; CHECK: @[[GLOBAL_20PTR_4_16:[a-zA-Z0-9_$"\\.-]+]] = internal unnamed_addr global ptr null
;.
define void @store_initializer() {
; CHECK-LABEL: @store_initializer(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    ret void
;
entry:
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 0), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 1), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 2), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 3), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 4), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 5), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 6), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 7), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 8), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 9), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 10), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 11), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 12), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 13), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 14), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 15), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 16), align 8

  %l0 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 0), align 8
  store volatile ptr %l0, ptr @c
  %l1 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 1), align 8
  store volatile ptr %l1, ptr @c
  %l2 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 2), align 8
  store volatile ptr %l2, ptr @c
  %l3 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 3), align 8
  store volatile ptr %l3, ptr @c
  %l4 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 4), align 8
  store volatile ptr %l4, ptr @c
  %l5 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 5), align 8
  store volatile ptr %l5, ptr @c
  %l6 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 6), align 8
  store volatile ptr %l6, ptr @c
  %l7 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 7), align 8
  store volatile ptr %l7, ptr @c
  %l8 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 8), align 8
  store volatile ptr %l8, ptr @c
  %l9 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 9), align 8
  store volatile ptr %l9, ptr @c
  %l10 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 10), align 8
  store volatile ptr %l10, ptr @c
  %l11 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 11), align 8
  store volatile ptr %l11, ptr @c
  %l12 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 12), align 8
  store volatile ptr %l12, ptr @c
  %l13 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 13), align 8
  store volatile ptr %l13, ptr @c
  %l14 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 14), align 8
  store volatile ptr %l14, ptr @c
  %l15 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 15), align 8
  store volatile ptr %l15, ptr @c
  %l16 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr, i64 0, i32 16), align 8
  store volatile ptr %l16, ptr @c

  ret void
}

; Global with initializer where some elements in the initializer are not null.

@global.20ptr.2 = internal global %struct.20ptr { ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr null, ptr @c }

define void @store_null_initializer_2() {
; CHECK-LABEL: @store_null_initializer_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    ret void
;
entry:
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 0), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 1), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 2), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 3), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 4), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 5), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 6), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 7), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 8), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 9), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 10), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 11), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 12), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 13), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 14), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 15), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 16), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 19), align 8

  %l0 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 0), align 8
  store volatile ptr %l0, ptr @c
  %l1 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 1), align 8
  store volatile ptr %l1, ptr @c
  %l2 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 2), align 8
  store volatile ptr %l2, ptr @c
  %l3 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 3), align 8
  store volatile ptr %l3, ptr @c
  %l4 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 4), align 8
  store volatile ptr %l4, ptr @c
  %l5 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 5), align 8
  store volatile ptr %l5, ptr @c
  %l6 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 6), align 8
  store volatile ptr %l6, ptr @c
  %l7 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 7), align 8
  store volatile ptr %l7, ptr @c
  %l8 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 8), align 8
  store volatile ptr %l8, ptr @c
  %l9 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 9), align 8
  store volatile ptr %l9, ptr @c
  %l10 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 10), align 8
  store volatile ptr %l10, ptr @c
  %l11 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 11), align 8
  store volatile ptr %l11, ptr @c
  %l12 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 12), align 8
  store volatile ptr %l12, ptr @c
  %l13 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 13), align 8
  store volatile ptr %l13, ptr @c
  %l14 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 14), align 8
  store volatile ptr %l14, ptr @c
  %l15 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 15), align 8
  store volatile ptr %l15, ptr @c
  %l16 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 16), align 8
  store volatile ptr %l16, ptr @c
  %l19 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.2, i64 0, i32 19), align 8
  store volatile ptr %l19, ptr @c

  ret void
}


@global.20ptr.3 = internal global %struct.20ptr { ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr null, ptr null, ptr null, ptr @c }

; Stores writing a different value than the initializer.
define void @store_mixed_initializer_negative() {
; CHECK-LABEL: @store_mixed_initializer_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store ptr null, ptr @global.20ptr.3, align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR:%.*]], ptr @global.20ptr.3, i64 0, i32 1), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 2), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 3), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 4), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 5), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 6), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 7), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 8), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 9), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 10), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 11), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 12), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 13), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 14), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 15), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 16), align 8
; CHECK-NEXT:    store ptr null, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 19), align 8
; CHECK-NEXT:    [[L0:%.*]] = load ptr, ptr @global.20ptr.3, align 8
; CHECK-NEXT:    store volatile ptr [[L0]], ptr @c, align 8
; CHECK-NEXT:    [[L1:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 1), align 8
; CHECK-NEXT:    store volatile ptr [[L1]], ptr @c, align 8
; CHECK-NEXT:    [[L2:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 2), align 8
; CHECK-NEXT:    store volatile ptr [[L2]], ptr @c, align 8
; CHECK-NEXT:    [[L3:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 3), align 8
; CHECK-NEXT:    store volatile ptr [[L3]], ptr @c, align 8
; CHECK-NEXT:    [[L4:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 4), align 8
; CHECK-NEXT:    store volatile ptr [[L4]], ptr @c, align 8
; CHECK-NEXT:    [[L5:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 5), align 8
; CHECK-NEXT:    store volatile ptr [[L5]], ptr @c, align 8
; CHECK-NEXT:    [[L6:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 6), align 8
; CHECK-NEXT:    store volatile ptr [[L6]], ptr @c, align 8
; CHECK-NEXT:    [[L7:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 7), align 8
; CHECK-NEXT:    store volatile ptr [[L7]], ptr @c, align 8
; CHECK-NEXT:    [[L8:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 8), align 8
; CHECK-NEXT:    store volatile ptr [[L8]], ptr @c, align 8
; CHECK-NEXT:    [[L9:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 9), align 8
; CHECK-NEXT:    store volatile ptr [[L9]], ptr @c, align 8
; CHECK-NEXT:    [[L10:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 10), align 8
; CHECK-NEXT:    store volatile ptr [[L10]], ptr @c, align 8
; CHECK-NEXT:    [[L11:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 11), align 8
; CHECK-NEXT:    store volatile ptr [[L11]], ptr @c, align 8
; CHECK-NEXT:    [[L12:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 12), align 8
; CHECK-NEXT:    store volatile ptr [[L12]], ptr @c, align 8
; CHECK-NEXT:    [[L13:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 13), align 8
; CHECK-NEXT:    store volatile ptr [[L13]], ptr @c, align 8
; CHECK-NEXT:    [[L14:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 14), align 8
; CHECK-NEXT:    store volatile ptr [[L14]], ptr @c, align 8
; CHECK-NEXT:    [[L15:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 15), align 8
; CHECK-NEXT:    store volatile ptr [[L15]], ptr @c, align 8
; CHECK-NEXT:    [[L16:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 16), align 8
; CHECK-NEXT:    store volatile ptr [[L16]], ptr @c, align 8
; CHECK-NEXT:    [[L19:%.*]] = load ptr, ptr getelementptr inbounds ([[STRUCT_20PTR]], ptr @global.20ptr.3, i64 0, i32 19), align 8
; CHECK-NEXT:    store volatile ptr [[L19]], ptr @c, align 8
; CHECK-NEXT:    ret void
;
entry:
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 0), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 1), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 2), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 3), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 4), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 5), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 6), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 7), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 8), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 9), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 10), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 11), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 12), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 13), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 14), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 15), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 16), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 19), align 8

  %l0 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 0), align 8
  store volatile ptr %l0, ptr @c
  %l1 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 1), align 8
  store volatile ptr %l1, ptr @c
  %l2 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 2), align 8
  store volatile ptr %l2, ptr @c
  %l3 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 3), align 8
  store volatile ptr %l3, ptr @c
  %l4 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 4), align 8
  store volatile ptr %l4, ptr @c
  %l5 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 5), align 8
  store volatile ptr %l5, ptr @c
  %l6 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 6), align 8
  store volatile ptr %l6, ptr @c
  %l7 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 7), align 8
  store volatile ptr %l7, ptr @c
  %l8 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 8), align 8
  store volatile ptr %l8, ptr @c
  %l9 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 9), align 8
  store volatile ptr %l9, ptr @c
  %l10 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 10), align 8
  store volatile ptr %l10, ptr @c
  %l11 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 11), align 8
  store volatile ptr %l11, ptr @c
  %l12 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 12), align 8
  store volatile ptr %l12, ptr @c
  %l13 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 13), align 8
  store volatile ptr %l13, ptr @c
  %l14 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 14), align 8
  store volatile ptr %l14, ptr @c
  %l15 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 15), align 8
  store volatile ptr %l15, ptr @c
  %l16 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 16), align 8
  store volatile ptr %l16, ptr @c
  %l19 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.3, i64 0, i32 19), align 8
  store volatile ptr %l19, ptr @c

  ret void
}


@global.20ptr.4 = internal global %struct.20ptr { ptr null, ptr null, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr @c, ptr null, ptr null, ptr null, ptr @c }

; Stores writing a different value than the initializer.
define void @store_mixed_initializer() {
; CHECK-LABEL: @store_mixed_initializer(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store ptr @c, ptr @global.20ptr.4.16, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    [[L16:%.*]] = load ptr, ptr @global.20ptr.4.16, align 8
; CHECK-NEXT:    store volatile ptr [[L16]], ptr @c, align 8
; CHECK-NEXT:    ret void
;
entry:
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 0), align 8
  store ptr null, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 1), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 2), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 3), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 4), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 5), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 6), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 7), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 8), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 9), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 10), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 11), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 12), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 13), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 14), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 15), align 8
  store ptr @c, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 16), align 8

  %l0 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 0), align 8
  store volatile ptr %l0, ptr @c
  %l1 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 1), align 8
  store volatile ptr %l1, ptr @c
  %l2 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 2), align 8
  store volatile ptr %l2, ptr @c
  %l3 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 3), align 8
  store volatile ptr %l3, ptr @c
  %l4 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 4), align 8
  store volatile ptr %l4, ptr @c
  %l5 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 5), align 8
  store volatile ptr %l5, ptr @c
  %l6 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 6), align 8
  store volatile ptr %l6, ptr @c
  %l7 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 7), align 8
  store volatile ptr %l7, ptr @c
  %l8 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 8), align 8
  store volatile ptr %l8, ptr @c
  %l9 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 9), align 8
  store volatile ptr %l9, ptr @c
  %l10 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 10), align 8
  store volatile ptr %l10, ptr @c
  %l11 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 11), align 8
  store volatile ptr %l11, ptr @c
  %l12 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 12), align 8
  store volatile ptr %l12, ptr @c
  %l13 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 13), align 8
  store volatile ptr %l13, ptr @c
  %l14 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 14), align 8
  store volatile ptr %l14, ptr @c
  %l15 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 15), align 8
  store volatile ptr %l15, ptr @c
  %l16 = load ptr, ptr getelementptr inbounds (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 16), align 8
  store volatile ptr %l16, ptr @c

  ret void
}

; Same as @store_mixed_initializer, but the GEP constant expressions are not
; inbounds.
define void @store_mixed_initializer_geps_without_inbounds() {
; CHECK-LABEL: @store_mixed_initializer_geps_without_inbounds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store ptr @c, ptr @global.20ptr.4.16, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr null, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    store volatile ptr @c, ptr @c, align 8
; CHECK-NEXT:    [[L16:%.*]] = load ptr, ptr @global.20ptr.4.16, align 8
; CHECK-NEXT:    store volatile ptr [[L16]], ptr @c, align 8
; CHECK-NEXT:    ret void
;
entry:
  store ptr null, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 0), align 8
  store ptr null, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 1), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 2), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 3), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 4), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 5), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 6), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 7), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 8), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 9), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 10), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 11), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 12), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 13), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 14), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 15), align 8
  store ptr @c, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 16), align 8

  %l0 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 0), align 8
  store volatile ptr %l0, ptr @c
  %l1 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 1), align 8
  store volatile ptr %l1, ptr @c
  %l2 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 2), align 8
  store volatile ptr %l2, ptr @c
  %l3 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 3), align 8
  store volatile ptr %l3, ptr @c
  %l4 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 4), align 8
  store volatile ptr %l4, ptr @c
  %l5 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 5), align 8
  store volatile ptr %l5, ptr @c
  %l6 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 6), align 8
  store volatile ptr %l6, ptr @c
  %l7 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 7), align 8
  store volatile ptr %l7, ptr @c
  %l8 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 8), align 8
  store volatile ptr %l8, ptr @c
  %l9 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 9), align 8
  store volatile ptr %l9, ptr @c
  %l10 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 10), align 8
  store volatile ptr %l10, ptr @c
  %l11 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 11), align 8
  store volatile ptr %l11, ptr @c
  %l12 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 12), align 8
  store volatile ptr %l12, ptr @c
  %l13 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 13), align 8
  store volatile ptr %l13, ptr @c
  %l14 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 14), align 8
  store volatile ptr %l14, ptr @c
  %l15 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 15), align 8
  store volatile ptr %l15, ptr @c
  %l16 = load ptr, ptr getelementptr (%struct.20ptr, ptr @global.20ptr.4, i64 0, i32 16), align 8
  store volatile ptr %l16, ptr @c

  ret void
}
