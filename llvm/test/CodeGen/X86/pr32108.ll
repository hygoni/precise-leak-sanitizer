; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

define void @pr32108() {
; CHECK-LABEL: pr32108:
; CHECK:       # %bb.0: # %BB
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %CF244
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    jmp .LBB0_1
BB:
  %Cmp45 = icmp slt <4 x i32> undef, undef
  br label %CF243

CF243:                                            ; preds = %CF243, %BB
  br i1 undef, label %CF243, label %CF257

CF257:                                            ; preds = %CF243
  %Shuff144 = shufflevector <4 x i1> undef, <4 x i1> %Cmp45, <4 x i32> <i32 undef, i32 undef, i32 5, i32 undef>
  br label %CF244

CF244:                                            ; preds = %CF244, %CF257
  %Shuff182 = shufflevector <4 x i1> %Shuff144, <4 x i1> zeroinitializer, <4 x i32> <i32 3, i32 5, i32 7, i32 undef>
  br label %CF244
}
