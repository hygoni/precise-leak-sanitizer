; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-- < %s -jump-table-density=40 -switch-peel-threshold=101 | FileCheck %s

; This switch should use bit tests, and the third bit test case is just
; testing for one possible value, so it doesn't need a bt.

define void @test(ptr %l) nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    movq %rdi, (%rsp)
; CHECK-NEXT:    movsbl (%rdi), %eax
; CHECK-NEXT:    addl $-33, %eax
; CHECK-NEXT:    cmpl $61, %eax
; CHECK-NEXT:    ja .LBB0_7
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movabsq $2305843009482129440, %rcx # imm = 0x2000000010000020
; CHECK-NEXT:    btq %rax, %rcx
; CHECK-NEXT:    jb .LBB0_6
; CHECK-NEXT:  # %bb.2: # %entry
; CHECK-NEXT:    movl $671088640, %ecx # imm = 0x28000000
; CHECK-NEXT:    btq %rax, %rcx
; CHECK-NEXT:    jae .LBB0_3
; CHECK-NEXT:  # %bb.5: # %sw.bb
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    jmp .LBB0_8
; CHECK-NEXT:  .LBB0_6: # %sw.bb2
; CHECK-NEXT:    movl $1, %edi
; CHECK-NEXT:    jmp .LBB0_8
; CHECK-NEXT:  .LBB0_3: # %entry
; CHECK-NEXT:    testq %rax, %rax
; CHECK-NEXT:    jne .LBB0_7
; CHECK-NEXT:  # %bb.4: # %sw.bb4
; CHECK-NEXT:    movl $3, %edi
; CHECK-NEXT:    jmp .LBB0_8
; CHECK-NEXT:  .LBB0_7: # %sw.default
; CHECK-NEXT:    movl $97, %edi
; CHECK-NEXT:  .LBB0_8: # %sw.epilog
; CHECK-NEXT:    callq foo@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
entry:
  %l.addr = alloca ptr, align 8                   ; <ptr> [#uses=2]
  store ptr %l, ptr %l.addr
  %tmp = load ptr, ptr %l.addr                        ; <ptr> [#uses=1]
  %tmp1 = load i8, ptr %tmp                           ; <i8> [#uses=1]
  %conv = sext i8 %tmp1 to i32                    ; <i32> [#uses=1]
  switch i32 %conv, label %sw.default [
    i32 62, label %sw.bb
    i32 60, label %sw.bb
    i32 38, label %sw.bb2
    i32 94, label %sw.bb2
    i32 61, label %sw.bb2
    i32 33, label %sw.bb4
  ]

sw.bb:                                            ; preds = %entry, %entry
  call void @foo(i32 0)
  br label %sw.epilog

sw.bb2:                                           ; preds = %entry, %entry, %entry
  call void @foo(i32 1)
  br label %sw.epilog

sw.bb4:                                           ; preds = %entry
  call void @foo(i32 3)
  br label %sw.epilog

sw.default:                                       ; preds = %entry
  call void @foo(i32 97)
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default, %sw.bb4, %sw.bb2, %sw.bb
  ret void
}

declare void @foo(i32)

; Don't zero extend the test operands to pointer type if it can be avoided.
; rdar://8781238
define void @test2(i32 %x) nounwind ssp {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpl $6, %edi
; CHECK-NEXT:    ja .LBB1_2
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movl $91, %eax
; CHECK-NEXT:    btl %edi, %eax
; CHECK-NEXT:    jb bar@PLT # TAILCALL
; CHECK-NEXT:  .LBB1_2: # %if.end
; CHECK-NEXT:    retq

entry:
  switch i32 %x, label %if.end [
    i32 6, label %if.then
    i32 4, label %if.then
    i32 3, label %if.then
    i32 1, label %if.then
    i32 0, label %if.then
  ]

if.then:                                          ; preds = %entry, %entry, %entry, %entry, %entry
  tail call void @bar() nounwind
  ret void

if.end:                                           ; preds = %entry
  ret void
}

declare void @bar()

define void @test3(i32 %x) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    cmpl $5, %edi
; CHECK-NEXT:    ja .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    cmpl $4, %edi
; CHECK-NEXT:    jne bar@PLT # TAILCALL
; CHECK-NEXT:  .LBB2_2: # %if.end
; CHECK-NEXT:    retq
  switch i32 %x, label %if.end [
    i32 0, label %if.then
    i32 1, label %if.then
    i32 2, label %if.then
    i32 3, label %if.then
    i32 5, label %if.then
  ]
if.then:
  tail call void @bar() nounwind
  ret void
if.end:
  ret void
}

; Ensure that optimizing for jump tables doesn't needlessly deteriorate the
; created binary tree search. See PR22262.
define void @test4(i32 %x, ptr %y) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpl $39, %edi
; CHECK-NEXT:    jg .LBB3_5
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    cmpl $10, %edi
; CHECK-NEXT:    je .LBB3_9
; CHECK-NEXT:  # %bb.2: # %entry
; CHECK-NEXT:    cmpl $20, %edi
; CHECK-NEXT:    je .LBB3_10
; CHECK-NEXT:  # %bb.3: # %entry
; CHECK-NEXT:    cmpl $30, %edi
; CHECK-NEXT:    jne .LBB3_13
; CHECK-NEXT:  # %bb.4: # %sw.bb2
; CHECK-NEXT:    movl $3, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_5: # %entry
; CHECK-NEXT:    cmpl $40, %edi
; CHECK-NEXT:    je .LBB3_11
; CHECK-NEXT:  # %bb.6: # %entry
; CHECK-NEXT:    cmpl $50, %edi
; CHECK-NEXT:    je .LBB3_12
; CHECK-NEXT:  # %bb.7: # %entry
; CHECK-NEXT:    cmpl $60, %edi
; CHECK-NEXT:    jne .LBB3_13
; CHECK-NEXT:  # %bb.8: # %sw.bb5
; CHECK-NEXT:    movl $6, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_9: # %sw.bb
; CHECK-NEXT:    movl $1, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_10: # %sw.bb1
; CHECK-NEXT:    movl $2, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_11: # %sw.bb3
; CHECK-NEXT:    movl $4, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_12: # %sw.bb4
; CHECK-NEXT:    movl $5, (%rsi)
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB3_13: # %sw.default
; CHECK-NEXT:    movl $7, (%rsi)
; CHECK-NEXT:    retq

entry:
  switch i32 %x, label %sw.default [
    i32 10, label %sw.bb
    i32 20, label %sw.bb1
    i32 30, label %sw.bb2
    i32 40, label %sw.bb3
    i32 50, label %sw.bb4
    i32 60, label %sw.bb5
  ]
sw.bb:
  store i32 1, ptr %y
  br label %sw.epilog
sw.bb1:
  store i32 2, ptr %y
  br label %sw.epilog
sw.bb2:
  store i32 3, ptr %y
  br label %sw.epilog
sw.bb3:
  store i32 4, ptr %y
  br label %sw.epilog
sw.bb4:
  store i32 5, ptr %y
  br label %sw.epilog
sw.bb5:
  store i32 6, ptr %y
  br label %sw.epilog
sw.default:
  store i32 7, ptr %y
  br label %sw.epilog
sw.epilog:
  ret void

; The balanced binary switch here would start with a comparison against 39, but
; it is currently starting with 29 because of the density-sum heuristic.
}


; Omit the range check when the default case is unreachable, see PR43129.
declare void @g(i32)
define void @test5(i32 %x) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    movl $73, %eax
; CHECK-NEXT:    btl %edi, %eax
; CHECK-NEXT:    jb .LBB4_3
; CHECK-NEXT:  # %bb.1: # %entry
; CHECK-NEXT:    movl $146, %eax
; CHECK-NEXT:    btl %edi, %eax
; CHECK-NEXT:    jae .LBB4_2
; CHECK-NEXT:  # %bb.4: # %bb1
; CHECK-NEXT:    movl $1, %edi
; CHECK-NEXT:    callq g@PLT
; CHECK-NEXT:  .LBB4_3: # %bb0
; CHECK-NEXT:    xorl %edi, %edi
; CHECK-NEXT:    callq g@PLT
; CHECK-NEXT:  .LBB4_2: # %bb2
; CHECK-NEXT:    movl $2, %edi
; CHECK-NEXT:    callq g@PLT

entry:
  switch i32 %x, label %return [
    ; 73 = 2^0 + 2^3 + 2^6
    i32 0, label %bb0
    i32 3, label %bb0
    i32 6, label %bb0

    ; 146 = 2^1 + 2^4 + 2^7
    i32 1, label %bb1
    i32 4, label %bb1
    i32 7, label %bb1

    i32 2, label %bb2
    i32 5, label %bb2
    i32 8, label %bb2
  ]
bb0: tail call void @g(i32 0) br label %return
bb1: tail call void @g(i32 1) br label %return
bb2: tail call void @g(i32 2) br label %return
return: unreachable
}
