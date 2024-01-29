; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

declare i32 @passthru_i32(i32 returned)
declare ptr @passthru_p8(ptr returned)
declare ptr @passthru_p8_from_p32(ptr returned)
declare <8 x i8> @passthru_8i8v_from_2i32v(<2 x i32> returned)

define i32 @returned_const_int_arg() {
; CHECK-LABEL: @returned_const_int_arg(
; CHECK-NEXT:    [[X:%.*]] = call i32 @passthru_i32(i32 42)
; CHECK-NEXT:    ret i32 42
;
  %x = call i32 @passthru_i32(i32 42)
  ret i32 %x
}

define ptr @returned_const_ptr_arg() {
; CHECK-LABEL: @returned_const_ptr_arg(
; CHECK-NEXT:    [[X:%.*]] = call ptr @passthru_p8(ptr null)
; CHECK-NEXT:    ret ptr null
;
  %x = call ptr @passthru_p8(ptr null)
  ret ptr %x
}

define ptr @returned_const_ptr_arg_casted() {
; CHECK-LABEL: @returned_const_ptr_arg_casted(
; CHECK-NEXT:    [[X:%.*]] = call ptr @passthru_p8_from_p32(ptr null)
; CHECK-NEXT:    ret ptr null
;
  %x = call ptr @passthru_p8_from_p32(ptr null)
  ret ptr %x
}

define ptr @returned_ptr_arg_casted(ptr %a) {
; CHECK-LABEL: @returned_ptr_arg_casted(
; CHECK-NEXT:    [[X:%.*]] = call ptr @passthru_p8_from_p32(ptr [[A:%.*]])
; CHECK-NEXT:    ret ptr [[A]]
;
  %x = call ptr @passthru_p8_from_p32(ptr %a)
  ret ptr %x
}

@GV = constant <2 x i32> zeroinitializer
define <8 x i8> @returned_const_vec_arg_casted() {
; CHECK-LABEL: @returned_const_vec_arg_casted(
; CHECK-NEXT:    [[X:%.*]] = call <8 x i8> @passthru_8i8v_from_2i32v(<2 x i32> zeroinitializer)
; CHECK-NEXT:    ret <8 x i8> zeroinitializer
;
  %v = load <2 x i32>, ptr @GV
  %x = call <8 x i8> @passthru_8i8v_from_2i32v(<2 x i32> %v)
  ret <8 x i8> %x
}

define <8 x i8> @returned_vec_arg_casted(<2 x i32> %a) {
; CHECK-LABEL: @returned_vec_arg_casted(
; CHECK-NEXT:    [[X:%.*]] = bitcast <2 x i32> [[A:%.*]] to <8 x i8>
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i8> @passthru_8i8v_from_2i32v(<2 x i32> [[A]])
; CHECK-NEXT:    ret <8 x i8> [[X]]
;
  %x = call <8 x i8> @passthru_8i8v_from_2i32v(<2 x i32> %a)
  ret <8 x i8> %x
}

define i32 @returned_var_arg(i32 %arg) {
; CHECK-LABEL: @returned_var_arg(
; CHECK-NEXT:    [[X:%.*]] = call i32 @passthru_i32(i32 [[ARG:%.*]])
; CHECK-NEXT:    ret i32 [[ARG]]
;
  %x = call i32 @passthru_i32(i32 %arg)
  ret i32 %x
}

define i32 @returned_const_int_arg_musttail(i32 %arg) {
; CHECK-LABEL: @returned_const_int_arg_musttail(
; CHECK-NEXT:    [[X:%.*]] = musttail call i32 @passthru_i32(i32 42)
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = musttail call i32 @passthru_i32(i32 42)
  ret i32 %x
}

define i32 @returned_var_arg_musttail(i32 %arg) {
; CHECK-LABEL: @returned_var_arg_musttail(
; CHECK-NEXT:    [[X:%.*]] = musttail call i32 @passthru_i32(i32 [[ARG:%.*]])
; CHECK-NEXT:    ret i32 [[X]]
;
  %x = musttail call i32 @passthru_i32(i32 %arg)
  ret i32 %x
}
