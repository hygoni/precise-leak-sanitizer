; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64_32-apple-ios %s -o - | FileCheck %s

; If %base < 96 then the sum will not wrap (in an unsigned sense), but "ldr w0,
; [x0, #-96]" would.
define i32 @test_valid_wrap(i32 %base) {
; CHECK-LABEL: test_valid_wrap:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub w8, w0, #96
; CHECK-NEXT:    ldr w0, [x8]
; CHECK-NEXT:    ret

  %newaddr = add nuw i32 %base, -96
  %ptr = inttoptr i32 %newaddr to ptr
  %val = load i32, ptr %ptr
  ret i32 %val
}

define i8 @test_valid_wrap_optimizable(ptr %base) {
; CHECK-LABEL: test_valid_wrap_optimizable:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldurb w0, [x0, #-96]
; CHECK-NEXT:    ret

  %newaddr = getelementptr inbounds i8, ptr %base, i32 -96
  %val = load i8, ptr %newaddr
  ret i8 %val
}

define i8 @test_valid_wrap_optimizable1(ptr %base, i32 %offset) {
; CHECK-LABEL: test_valid_wrap_optimizable1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldrb w0, [x0, w1, sxtw]
; CHECK-NEXT:    ret

  %newaddr = getelementptr inbounds i8, ptr %base, i32 %offset
  %val = load i8, ptr %newaddr
  ret i8 %val
}

;
define i8 @test_valid_wrap_optimizable2(ptr %base, i32 %offset) {
; CHECK-LABEL: test_valid_wrap_optimizable2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w8, #-100
; CHECK-NEXT:    ; kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    sxtw x9, w1
; CHECK-NEXT:    ldrb w0, [x9, x8]
; CHECK-NEXT:    ret

  %newaddr = getelementptr inbounds i8, ptr inttoptr(i32 -100 to ptr), i32 %offset
  %val = load i8, ptr %newaddr
  ret i8 %val
}
