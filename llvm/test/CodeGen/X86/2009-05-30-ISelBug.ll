; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

define void @BZ2_bzDecompress_bb5_2E_outer_bb35_2E_i_bb54_2E_i(ptr, i32 %c_nblock_used.2.i, i32 %.reload51, ptr %.out, ptr %.out1, ptr %.out2, ptr %.out3) nounwind {
; CHECK-LABEL: BZ2_bzDecompress_bb5_2E_outer_bb35_2E_i_bb54_2E_i:
; CHECK:       # %bb.0: # %newFuncRoot
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movl %edx, %edx
; CHECK-NEXT:    movl (%rdi,%rdx,4), %edx
; CHECK-NEXT:    movzbl %dl, %r10d
; CHECK-NEXT:    # kill: def $edx killed $edx def $rdx
; CHECK-NEXT:    shrl $8, %edx
; CHECK-NEXT:    addl $4, %r10d
; CHECK-NEXT:    movl (%rdi,%rdx,4), %edx
; CHECK-NEXT:    movzbl %dl, %edi
; CHECK-NEXT:    shrl $8, %edx
; CHECK-NEXT:    addl $5, %esi
; CHECK-NEXT:    movl %r10d, (%rcx)
; CHECK-NEXT:    movl %edi, (%r8)
; CHECK-NEXT:    movl %edx, (%r9)
; CHECK-NEXT:    movl %esi, (%rax)
; CHECK-NEXT:    retq
newFuncRoot:
	br label %bb54.i

bb35.i.backedge.exitStub:		; preds = %bb54.i
	store i32 %6, ptr %.out
	store i32 %10, ptr %.out1
	store i32 %11, ptr %.out2
	store i32 %12, ptr %.out3
	ret void

bb54.i:		; preds = %newFuncRoot
	%1 = zext i32 %.reload51 to i64		; <i64> [#uses=1]
	%2 = getelementptr i32, ptr %0, i64 %1		; <ptr> [#uses=1]
	%3 = load i32, ptr %2, align 4		; <i32> [#uses=2]
	%4 = lshr i32 %3, 8		; <i32> [#uses=1]
	%5 = and i32 %3, 255		; <i32> [#uses=1]
	%6 = add i32 %5, 4		; <i32> [#uses=1]
	%7 = zext i32 %4 to i64		; <i64> [#uses=1]
	%8 = getelementptr i32, ptr %0, i64 %7		; <ptr> [#uses=1]
	%9 = load i32, ptr %8, align 4		; <i32> [#uses=2]
	%10 = and i32 %9, 255		; <i32> [#uses=1]
	%11 = lshr i32 %9, 8		; <i32> [#uses=1]
	%12 = add i32 %c_nblock_used.2.i, 5		; <i32> [#uses=1]
	br label %bb35.i.backedge.exitStub
}
