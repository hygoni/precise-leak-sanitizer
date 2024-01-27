; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i64 @test_ptrauth_nop(ptr %p) {
; CHECK-LABEL: @test_ptrauth_nop(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    ret i64 [[TMP0]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.sign(i64 %tmp0, i32 1, i64 1234)
  %authed = call i64 @llvm.ptrauth.auth(i64 %signed, i32 1, i64 1234)
  ret i64 %authed
}

define i64 @test_ptrauth_nop_mismatch(ptr %p) {
; CHECK-LABEL: @test_ptrauth_nop_mismatch(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[SIGNED:%.*]] = call i64 @llvm.ptrauth.sign(i64 [[TMP0]], i32 1, i64 1234)
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.auth(i64 [[SIGNED]], i32 1, i64 10)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.sign(i64 %tmp0, i32 1, i64 1234)
  %authed = call i64 @llvm.ptrauth.auth(i64 %signed, i32 1, i64 10)
  ret i64 %authed
}

define i64 @test_ptrauth_nop_mismatch_keys(ptr %p) {
; CHECK-LABEL: @test_ptrauth_nop_mismatch_keys(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[SIGNED:%.*]] = call i64 @llvm.ptrauth.sign(i64 [[TMP0]], i32 0, i64 1234)
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.auth(i64 [[SIGNED]], i32 1, i64 1234)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.sign(i64 %tmp0, i32 0, i64 1234)
  %authed = call i64 @llvm.ptrauth.auth(i64 %signed, i32 1, i64 1234)
  ret i64 %authed
}

define i64 @test_ptrauth_sign_resign(ptr %p) {
; CHECK-LABEL: @test_ptrauth_sign_resign(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.sign(i64 [[TMP0]], i32 0, i64 42)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.sign(i64 %tmp0, i32 1, i64 1234)
  %authed = call i64 @llvm.ptrauth.resign(i64 %signed, i32 1, i64 1234, i32 0, i64 42)
  ret i64 %authed
}

define i64 @test_ptrauth_resign_resign(ptr %p) {
; CHECK-LABEL: @test_ptrauth_resign_resign(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.resign(i64 [[TMP0]], i32 1, i64 1234, i32 1, i64 3141)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.resign(i64 %tmp0, i32 1, i64 1234, i32 0, i64 42)
  %authed = call i64 @llvm.ptrauth.resign(i64 %signed, i32 0, i64 42, i32 1, i64 3141)
  ret i64 %authed
}

define i64 @test_ptrauth_resign_auth(ptr %p) {
; CHECK-LABEL: @test_ptrauth_resign_auth(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.auth(i64 [[TMP0]], i32 1, i64 1234)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.resign(i64 %tmp0, i32 1, i64 1234, i32 0, i64 42)
  %authed = call i64 @llvm.ptrauth.auth(i64 %signed, i32 0, i64 42)
  ret i64 %authed
}

define i64 @test_ptrauth_resign_auth_mismatch(ptr %p) {
; CHECK-LABEL: @test_ptrauth_resign_auth_mismatch(
; CHECK-NEXT:    [[TMP0:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    [[SIGNED:%.*]] = call i64 @llvm.ptrauth.resign(i64 [[TMP0]], i32 1, i64 1234, i32 0, i64 10)
; CHECK-NEXT:    [[AUTHED:%.*]] = call i64 @llvm.ptrauth.auth(i64 [[SIGNED]], i32 0, i64 42)
; CHECK-NEXT:    ret i64 [[AUTHED]]
;
  %tmp0 = ptrtoint ptr %p to i64
  %signed = call i64 @llvm.ptrauth.resign(i64 %tmp0, i32 1, i64 1234, i32 0, i64 10)
  %authed = call i64 @llvm.ptrauth.auth(i64 %signed, i32 0, i64 42)
  ret i64 %authed
}

declare i64 @llvm.ptrauth.auth(i64, i32, i64)
declare i64 @llvm.ptrauth.sign(i64, i32, i64)
declare i64 @llvm.ptrauth.resign(i64, i32, i64, i32, i64)
