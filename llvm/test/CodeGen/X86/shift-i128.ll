; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s --check-prefixes=ALL,i686
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --check-prefixes=ALL,x86_64

;
; Scalars
;

define void @test_lshr_i128(i128 %x, i128 %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_lshr_i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $32, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, (%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ecx, %eax
; i686-NEXT:    andb $7, %al
; i686-NEXT:    shrb $3, %cl
; i686-NEXT:    andb $15, %cl
; i686-NEXT:    movzbl %cl, %ebp
; i686-NEXT:    movl 4(%esp,%ebp), %edx
; i686-NEXT:    movl %edx, %esi
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    notb %cl
; i686-NEXT:    movl 8(%esp,%ebp), %ebx
; i686-NEXT:    leal (%ebx,%ebx), %edi
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    orl %esi, %edi
; i686-NEXT:    movl (%esp,%ebp), %esi
; i686-NEXT:    movl 12(%esp,%ebp), %ebp
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shrdl %cl, %ebp, %ebx
; i686-NEXT:    shrdl %cl, %edx, %esi
; i686-NEXT:    shrl %cl, %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl %ebp, 12(%eax)
; i686-NEXT:    movl %ebx, 8(%eax)
; i686-NEXT:    movl %esi, (%eax)
; i686-NEXT:    movl %edi, 4(%eax)
; i686-NEXT:    addl $32, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_lshr_i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rdx, %rcx
; x86_64-NEXT:    shrdq %cl, %rsi, %rdi
; x86_64-NEXT:    shrq %cl, %rsi
; x86_64-NEXT:    xorl %eax, %eax
; x86_64-NEXT:    testb $64, %cl
; x86_64-NEXT:    cmovneq %rsi, %rdi
; x86_64-NEXT:    cmoveq %rsi, %rax
; x86_64-NEXT:    movq %rax, 8(%r8)
; x86_64-NEXT:    movq %rdi, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = lshr i128 %x, %a
	store i128 %0, ptr %r, align 16
	ret void
}

define void @test_ashr_i128(i128 %x, i128 %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_ashr_i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $32, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, (%esp)
; i686-NEXT:    sarl $31, %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ecx, %eax
; i686-NEXT:    andb $7, %al
; i686-NEXT:    shrb $3, %cl
; i686-NEXT:    andb $15, %cl
; i686-NEXT:    movzbl %cl, %ebp
; i686-NEXT:    movl 4(%esp,%ebp), %edx
; i686-NEXT:    movl %edx, %esi
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    notb %cl
; i686-NEXT:    movl 8(%esp,%ebp), %ebx
; i686-NEXT:    leal (%ebx,%ebx), %edi
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    orl %esi, %edi
; i686-NEXT:    movl (%esp,%ebp), %esi
; i686-NEXT:    movl 12(%esp,%ebp), %ebp
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shrdl %cl, %ebp, %ebx
; i686-NEXT:    shrdl %cl, %edx, %esi
; i686-NEXT:    sarl %cl, %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl %ebp, 12(%eax)
; i686-NEXT:    movl %ebx, 8(%eax)
; i686-NEXT:    movl %esi, (%eax)
; i686-NEXT:    movl %edi, 4(%eax)
; i686-NEXT:    addl $32, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_ashr_i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rdx, %rcx
; x86_64-NEXT:    shrdq %cl, %rsi, %rdi
; x86_64-NEXT:    movq %rsi, %rax
; x86_64-NEXT:    sarq %cl, %rax
; x86_64-NEXT:    sarq $63, %rsi
; x86_64-NEXT:    testb $64, %cl
; x86_64-NEXT:    cmovneq %rax, %rdi
; x86_64-NEXT:    cmoveq %rax, %rsi
; x86_64-NEXT:    movq %rsi, 8(%r8)
; x86_64-NEXT:    movq %rdi, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = ashr i128 %x, %a
	store i128 %0, ptr %r, align 16
	ret void
}

define void @test_shl_i128(i128 %x, i128 %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_shl_i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $32, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, (%esp)
; i686-NEXT:    movl %ecx, %eax
; i686-NEXT:    andb $7, %al
; i686-NEXT:    shrb $3, %cl
; i686-NEXT:    andb $15, %cl
; i686-NEXT:    negb %cl
; i686-NEXT:    movsbl %cl, %ebp
; i686-NEXT:    movl 24(%esp,%ebp), %edx
; i686-NEXT:    movl %edx, %ebx
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shll %cl, %ebx
; i686-NEXT:    notb %cl
; i686-NEXT:    movl 20(%esp,%ebp), %edi
; i686-NEXT:    movl %edi, %esi
; i686-NEXT:    shrl %esi
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    orl %ebx, %esi
; i686-NEXT:    movl 16(%esp,%ebp), %ebx
; i686-NEXT:    movl 28(%esp,%ebp), %ebp
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shldl %cl, %edx, %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl %ebp, 12(%ecx)
; i686-NEXT:    movl %ebx, %edx
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shll %cl, %edx
; i686-NEXT:    shldl %cl, %ebx, %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl %edi, 4(%eax)
; i686-NEXT:    movl %edx, (%eax)
; i686-NEXT:    movl %esi, 8(%eax)
; i686-NEXT:    addl $32, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_shl_i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rdx, %rcx
; x86_64-NEXT:    shldq %cl, %rdi, %rsi
; x86_64-NEXT:    shlq %cl, %rdi
; x86_64-NEXT:    xorl %eax, %eax
; x86_64-NEXT:    testb $64, %cl
; x86_64-NEXT:    cmovneq %rdi, %rsi
; x86_64-NEXT:    cmoveq %rdi, %rax
; x86_64-NEXT:    movq %rsi, 8(%r8)
; x86_64-NEXT:    movq %rax, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = shl i128 %x, %a
	store i128 %0, ptr %r, align 16
	ret void
}

define void @test_lshr_i128_outofrange(i128 %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_lshr_i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = lshr i128 %x, -1
	store i128 %0, ptr %r, align 16
	ret void
}

define void @test_ashr_i128_outofrange(i128 %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_ashr_i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = ashr i128 %x, -1
	store i128 %0, ptr %r, align 16
	ret void
}

define void @test_shl_i128_outofrange(i128 %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_shl_i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = shl i128 %x, -1
	store i128 %0, ptr %r, align 16
	ret void
}

;
; Vectors
;

define void @test_lshr_v2i128(<2 x i128> %x, <2 x i128> %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_lshr_v2i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $100, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl %ebp, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl %ebp, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl %ebp, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl %ebp, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, %ecx
; i686-NEXT:    andl $7, %ecx
; i686-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    shrl $3, %esi
; i686-NEXT:    andl $15, %esi
; i686-NEXT:    movl 40(%esp,%esi), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    shrl %cl, %eax
; i686-NEXT:    notl %ecx
; i686-NEXT:    movl 44(%esp,%esi), %edx
; i686-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    addl %edx, %edx
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shll %cl, %edx
; i686-NEXT:    orl %eax, %edx
; i686-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl 36(%esp,%esi), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, %edx
; i686-NEXT:    andl $7, %edx
; i686-NEXT:    shrl $3, %ebx
; i686-NEXT:    andl $15, %ebx
; i686-NEXT:    movl 72(%esp,%ebx), %ebp
; i686-NEXT:    movl %ebp, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    shrl %cl, %ebp
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    notl %ecx
; i686-NEXT:    movl 76(%esp,%ebx), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    leal (%eax,%eax), %edi
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    orl %ebp, %edi
; i686-NEXT:    movl 48(%esp,%esi), %esi
; i686-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    shrdl %cl, %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; i686-NEXT:    movl 68(%esp,%ebx), %ecx
; i686-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; i686-NEXT:    movl 80(%esp,%ebx), %esi
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebx # 4-byte Reload
; i686-NEXT:    shrdl %cl, %esi, %ebx
; i686-NEXT:    movl %eax, %ecx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebp # 4-byte Reload
; i686-NEXT:    shrdl %cl, %ebp, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebp # 4-byte Reload
; i686-NEXT:    shrl %cl, %ebp
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    shrdl %cl, %eax, (%esp) # 4-byte Folded Spill
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl %esi, 28(%ecx)
; i686-NEXT:    movl %ebx, 24(%ecx)
; i686-NEXT:    movl (%esp), %eax # 4-byte Reload
; i686-NEXT:    movl %eax, 16(%ecx)
; i686-NEXT:    movl %ebp, 12(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; i686-NEXT:    movl %edx, 8(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; i686-NEXT:    movl %edx, (%ecx)
; i686-NEXT:    movl %edi, 20(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    movl %eax, 4(%ecx)
; i686-NEXT:    addl $100, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_lshr_v2i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rcx, %rax
; x86_64-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; x86_64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r9d
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    shrdq %cl, %rax, %rdx
; x86_64-NEXT:    movl %r8d, %ecx
; x86_64-NEXT:    shrdq %cl, %rsi, %rdi
; x86_64-NEXT:    shrq %cl, %rsi
; x86_64-NEXT:    xorl %r11d, %r11d
; x86_64-NEXT:    testb $64, %r8b
; x86_64-NEXT:    cmovneq %rsi, %rdi
; x86_64-NEXT:    cmovneq %r11, %rsi
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    shrq %cl, %rax
; x86_64-NEXT:    testb $64, %r9b
; x86_64-NEXT:    cmovneq %rax, %rdx
; x86_64-NEXT:    cmovneq %r11, %rax
; x86_64-NEXT:    movq %rax, 24(%r10)
; x86_64-NEXT:    movq %rdx, 16(%r10)
; x86_64-NEXT:    movq %rsi, 8(%r10)
; x86_64-NEXT:    movq %rdi, (%r10)
; x86_64-NEXT:    retq
entry:
	%0 = lshr <2 x i128> %x, %a
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_ashr_v2i128(<2 x i128> %x, <2 x i128> %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_ashr_v2i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $92, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    sarl $31, %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; i686-NEXT:    sarl $31, %eax
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebp, %ebx
; i686-NEXT:    andl $7, %ebx
; i686-NEXT:    shrl $3, %ebp
; i686-NEXT:    andl $15, %ebp
; i686-NEXT:    movl 32(%esp,%ebp), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    shrl %cl, %eax
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    notl %ecx
; i686-NEXT:    movl 36(%esp,%ebp), %edx
; i686-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    addl %edx, %edx
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shll %cl, %edx
; i686-NEXT:    orl %eax, %edx
; i686-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %edi, %ecx
; i686-NEXT:    movl %edi, %edx
; i686-NEXT:    andl $7, %edx
; i686-NEXT:    shrl $3, %ecx
; i686-NEXT:    andl $15, %ecx
; i686-NEXT:    movl 64(%esp,%ecx), %esi
; i686-NEXT:    movl %ecx, %edi
; i686-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; i686-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    notl %ecx
; i686-NEXT:    movl 68(%esp,%edi), %eax
; i686-NEXT:    leal (%eax,%eax), %edi
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    orl %esi, %edi
; i686-NEXT:    movl 28(%esp,%ebp), %ecx
; i686-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl 40(%esp,%ebp), %esi
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    shrdl %cl, %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; i686-NEXT:    movl (%esp), %ecx # 4-byte Reload
; i686-NEXT:    movl 60(%esp,%ecx), %ebp
; i686-NEXT:    movl %ebp, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl 72(%esp,%ecx), %ebp
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    shrdl %cl, %ebp, %eax
; i686-NEXT:    movl %eax, (%esp) # 4-byte Spill
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    shrdl %cl, %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; i686-NEXT:    sarl %cl, %esi
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebx # 4-byte Reload
; i686-NEXT:    shrdl %cl, %eax, %ebx
; i686-NEXT:    movl %edx, %ecx
; i686-NEXT:    sarl %cl, %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl %ebp, 28(%eax)
; i686-NEXT:    movl (%esp), %ecx # 4-byte Reload
; i686-NEXT:    movl %ecx, 24(%eax)
; i686-NEXT:    movl %ebx, 16(%eax)
; i686-NEXT:    movl %esi, 12(%eax)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; i686-NEXT:    movl %ecx, 8(%eax)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; i686-NEXT:    movl %ecx, (%eax)
; i686-NEXT:    movl %edi, 20(%eax)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; i686-NEXT:    movl %ecx, 4(%eax)
; i686-NEXT:    addl $92, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_ashr_v2i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rcx, %rax
; x86_64-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; x86_64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r9d
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    shrdq %cl, %rax, %rdx
; x86_64-NEXT:    movl %r8d, %ecx
; x86_64-NEXT:    shrdq %cl, %rsi, %rdi
; x86_64-NEXT:    movq %rsi, %r11
; x86_64-NEXT:    sarq %cl, %r11
; x86_64-NEXT:    sarq $63, %rsi
; x86_64-NEXT:    testb $64, %r8b
; x86_64-NEXT:    cmovneq %r11, %rdi
; x86_64-NEXT:    cmoveq %r11, %rsi
; x86_64-NEXT:    movq %rax, %r8
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    sarq %cl, %r8
; x86_64-NEXT:    sarq $63, %rax
; x86_64-NEXT:    testb $64, %r9b
; x86_64-NEXT:    cmovneq %r8, %rdx
; x86_64-NEXT:    cmoveq %r8, %rax
; x86_64-NEXT:    movq %rax, 24(%r10)
; x86_64-NEXT:    movq %rdx, 16(%r10)
; x86_64-NEXT:    movq %rsi, 8(%r10)
; x86_64-NEXT:    movq %rdi, (%r10)
; x86_64-NEXT:    retq
entry:
	%0 = ashr <2 x i128> %x, %a
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_shl_v2i128(<2 x i128> %x, <2 x i128> %a, ptr nocapture %r) nounwind {
; i686-LABEL: test_shl_v2i128:
; i686:       # %bb.0: # %entry
; i686-NEXT:    pushl %ebp
; i686-NEXT:    pushl %ebx
; i686-NEXT:    pushl %edi
; i686-NEXT:    pushl %esi
; i686-NEXT:    subl $100, %esp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl %ebx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; i686-NEXT:    movl %ebp, %ecx
; i686-NEXT:    shrl $3, %ebp
; i686-NEXT:    andl $15, %ebp
; i686-NEXT:    leal {{[0-9]+}}(%esp), %eax
; i686-NEXT:    subl %ebp, %eax
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl 8(%eax), %edx
; i686-NEXT:    movl %edx, (%esp) # 4-byte Spill
; i686-NEXT:    andl $7, %ecx
; i686-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    shll %cl, %edx
; i686-NEXT:    movl 4(%eax), %esi
; i686-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    shrl %esi
; i686-NEXT:    notl %ecx
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shrl %cl, %esi
; i686-NEXT:    orl %edx, %esi
; i686-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; i686-NEXT:    movl (%eax), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %ebx, %edx
; i686-NEXT:    shrl $3, %edx
; i686-NEXT:    andl $15, %edx
; i686-NEXT:    leal {{[0-9]+}}(%esp), %esi
; i686-NEXT:    subl %edx, %esi
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    movl $0, {{[0-9]+}}(%esp)
; i686-NEXT:    andl $7, %ebx
; i686-NEXT:    movl 8(%esi), %edi
; i686-NEXT:    movl %edi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    movl 4(%esi), %eax
; i686-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    shrl %eax
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    notl %ecx
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    shrl %cl, %eax
; i686-NEXT:    orl %edi, %eax
; i686-NEXT:    movl (%esi), %ecx
; i686-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; i686-NEXT:    movl %esi, %edi
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    movl %edi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; i686-NEXT:    movl %ecx, %edi
; i686-NEXT:    shldl %cl, %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Folded Spill
; i686-NEXT:    negl %ebp
; i686-NEXT:    movl 64(%esp,%ebp), %esi
; i686-NEXT:    movl %edi, %ecx
; i686-NEXT:    # kill: def $cl killed $cl killed $ecx
; i686-NEXT:    movl (%esp), %edi # 4-byte Reload
; i686-NEXT:    shldl %cl, %edi, %esi
; i686-NEXT:    movl %esi, (%esp) # 4-byte Spill
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; i686-NEXT:    movl %esi, %edi
; i686-NEXT:    movl %ebx, %ecx
; i686-NEXT:    shll %cl, %edi
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebp # 4-byte Reload
; i686-NEXT:    shldl %cl, %esi, %ebp
; i686-NEXT:    negl %edx
; i686-NEXT:    movl 96(%esp,%edx), %edx
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebx # 4-byte Reload
; i686-NEXT:    shldl %cl, %ebx, %edx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl %edx, 28(%ecx)
; i686-NEXT:    movl %ebp, 20(%ecx)
; i686-NEXT:    movl %edi, 16(%ecx)
; i686-NEXT:    movl (%esp), %edx # 4-byte Reload
; i686-NEXT:    movl %edx, 12(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; i686-NEXT:    movl %edx, 4(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; i686-NEXT:    movl %edx, (%ecx)
; i686-NEXT:    movl %eax, 24(%ecx)
; i686-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; i686-NEXT:    movl %eax, 8(%ecx)
; i686-NEXT:    addl $100, %esp
; i686-NEXT:    popl %esi
; i686-NEXT:    popl %edi
; i686-NEXT:    popl %ebx
; i686-NEXT:    popl %ebp
; i686-NEXT:    retl
;
; x86_64-LABEL: test_shl_v2i128:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    movq %rcx, %rax
; x86_64-NEXT:    movq {{[0-9]+}}(%rsp), %r10
; x86_64-NEXT:    movzbl {{[0-9]+}}(%rsp), %r9d
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    shldq %cl, %rdx, %rax
; x86_64-NEXT:    movl %r8d, %ecx
; x86_64-NEXT:    shldq %cl, %rdi, %rsi
; x86_64-NEXT:    shlq %cl, %rdi
; x86_64-NEXT:    xorl %r11d, %r11d
; x86_64-NEXT:    testb $64, %r8b
; x86_64-NEXT:    cmovneq %rdi, %rsi
; x86_64-NEXT:    cmovneq %r11, %rdi
; x86_64-NEXT:    movl %r9d, %ecx
; x86_64-NEXT:    shlq %cl, %rdx
; x86_64-NEXT:    testb $64, %r9b
; x86_64-NEXT:    cmovneq %rdx, %rax
; x86_64-NEXT:    cmovneq %r11, %rdx
; x86_64-NEXT:    movq %rax, 24(%r10)
; x86_64-NEXT:    movq %rdx, 16(%r10)
; x86_64-NEXT:    movq %rsi, 8(%r10)
; x86_64-NEXT:    movq %rdi, (%r10)
; x86_64-NEXT:    retq
entry:
	%0 = shl <2 x i128> %x, %a
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_lshr_v2i128_outofrange(<2 x i128> %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_lshr_v2i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = lshr <2 x i128> %x, <i128 -1, i128 -1>
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_ashr_v2i128_outofrange(<2 x i128> %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_ashr_v2i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = ashr <2 x i128> %x, <i128 -1, i128 -1>
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_shl_v2i128_outofrange(<2 x i128> %x, ptr nocapture %r) nounwind {
; ALL-LABEL: test_shl_v2i128_outofrange:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    ret{{[l|q]}}
entry:
	%0 = shl <2 x i128> %x, <i128 -1, i128 -1>
	store <2 x i128> %0, ptr %r, align 16
	ret void
}

define void @test_lshr_v2i128_outofrange_sum(<2 x i128> %x, ptr nocapture %r) nounwind {
; i686-LABEL: test_lshr_v2i128_outofrange_sum:
; i686:       # %bb.0: # %entry
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl
;
; x86_64-LABEL: test_lshr_v2i128_outofrange_sum:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 16(%r8)
; x86_64-NEXT:    movaps %xmm0, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = lshr <2 x i128> %x, <i128 -1, i128 -1>
	%1 = lshr <2 x i128> %0, <i128  1, i128  1>
	store <2 x i128> %1, ptr %r, align 16
	ret void
}

define void @test_ashr_v2i128_outofrange_sum(<2 x i128> %x, ptr nocapture %r) nounwind {
; i686-LABEL: test_ashr_v2i128_outofrange_sum:
; i686:       # %bb.0: # %entry
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl
;
; x86_64-LABEL: test_ashr_v2i128_outofrange_sum:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 16(%r8)
; x86_64-NEXT:    movaps %xmm0, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = ashr <2 x i128> %x, <i128 -1, i128 -1>
	%1 = ashr <2 x i128> %0, <i128  1, i128  1>
	store <2 x i128> %1, ptr %r, align 16
	ret void
}

define void @test_shl_v2i128_outofrange_sum(<2 x i128> %x, ptr nocapture %r) nounwind {
; i686-LABEL: test_shl_v2i128_outofrange_sum:
; i686:       # %bb.0: # %entry
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl
;
; x86_64-LABEL: test_shl_v2i128_outofrange_sum:
; x86_64:       # %bb.0: # %entry
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 16(%r8)
; x86_64-NEXT:    movaps %xmm0, (%r8)
; x86_64-NEXT:    retq
entry:
	%0 = shl <2 x i128> %x, <i128 -1, i128 -1>
	%1 = shl <2 x i128> %0, <i128  1, i128  1>
	store <2 x i128> %1, ptr %r, align 16
	ret void
}

;
; Combines
;

define <2 x i256> @shl_sext_shl_outofrange(<2 x i128> %a0) {
; i686-LABEL: shl_sext_shl_outofrange:
; i686:       # %bb.0:
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 60(%eax)
; i686-NEXT:    movl $0, 56(%eax)
; i686-NEXT:    movl $0, 52(%eax)
; i686-NEXT:    movl $0, 48(%eax)
; i686-NEXT:    movl $0, 44(%eax)
; i686-NEXT:    movl $0, 40(%eax)
; i686-NEXT:    movl $0, 36(%eax)
; i686-NEXT:    movl $0, 32(%eax)
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl $4
;
; x86_64-LABEL: shl_sext_shl_outofrange:
; x86_64:       # %bb.0:
; x86_64-NEXT:    movq %rdi, %rax
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 48(%rdi)
; x86_64-NEXT:    movaps %xmm0, 32(%rdi)
; x86_64-NEXT:    movaps %xmm0, 16(%rdi)
; x86_64-NEXT:    movaps %xmm0, (%rdi)
; x86_64-NEXT:    retq
  %1 = shl <2 x i128> %a0, <i128 -1, i128 -1>
  %2 = sext <2 x i128> %1 to <2 x i256>
  %3 = shl <2 x i256> %2, <i256 128, i256 128>
  ret <2 x i256> %3
}

define <2 x i256> @shl_zext_shl_outofrange(<2 x i128> %a0) {
; i686-LABEL: shl_zext_shl_outofrange:
; i686:       # %bb.0:
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 60(%eax)
; i686-NEXT:    movl $0, 56(%eax)
; i686-NEXT:    movl $0, 52(%eax)
; i686-NEXT:    movl $0, 48(%eax)
; i686-NEXT:    movl $0, 44(%eax)
; i686-NEXT:    movl $0, 40(%eax)
; i686-NEXT:    movl $0, 36(%eax)
; i686-NEXT:    movl $0, 32(%eax)
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl $4
;
; x86_64-LABEL: shl_zext_shl_outofrange:
; x86_64:       # %bb.0:
; x86_64-NEXT:    movq %rdi, %rax
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 48(%rdi)
; x86_64-NEXT:    movaps %xmm0, 32(%rdi)
; x86_64-NEXT:    movaps %xmm0, 16(%rdi)
; x86_64-NEXT:    movaps %xmm0, (%rdi)
; x86_64-NEXT:    retq
  %1 = shl <2 x i128> %a0, <i128 -1, i128 -1>
  %2 = zext <2 x i128> %1 to <2 x i256>
  %3 = shl <2 x i256> %2, <i256 128, i256 128>
  ret <2 x i256> %3
}

define <2 x i256> @shl_zext_lshr_outofrange(<2 x i128> %a0) {
; i686-LABEL: shl_zext_lshr_outofrange:
; i686:       # %bb.0:
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl $0, 60(%eax)
; i686-NEXT:    movl $0, 56(%eax)
; i686-NEXT:    movl $0, 52(%eax)
; i686-NEXT:    movl $0, 48(%eax)
; i686-NEXT:    movl $0, 44(%eax)
; i686-NEXT:    movl $0, 40(%eax)
; i686-NEXT:    movl $0, 36(%eax)
; i686-NEXT:    movl $0, 32(%eax)
; i686-NEXT:    movl $0, 28(%eax)
; i686-NEXT:    movl $0, 24(%eax)
; i686-NEXT:    movl $0, 20(%eax)
; i686-NEXT:    movl $0, 16(%eax)
; i686-NEXT:    movl $0, 12(%eax)
; i686-NEXT:    movl $0, 8(%eax)
; i686-NEXT:    movl $0, 4(%eax)
; i686-NEXT:    movl $0, (%eax)
; i686-NEXT:    retl $4
;
; x86_64-LABEL: shl_zext_lshr_outofrange:
; x86_64:       # %bb.0:
; x86_64-NEXT:    movq %rdi, %rax
; x86_64-NEXT:    xorps %xmm0, %xmm0
; x86_64-NEXT:    movaps %xmm0, 48(%rdi)
; x86_64-NEXT:    movaps %xmm0, 32(%rdi)
; x86_64-NEXT:    movaps %xmm0, 16(%rdi)
; x86_64-NEXT:    movaps %xmm0, (%rdi)
; x86_64-NEXT:    retq
  %1 = lshr <2 x i128> %a0, <i128 -1, i128 -1>
  %2 = zext <2 x i128> %1 to <2 x i256>
  %3 = shl <2 x i256> %2, <i256 128, i256 128>
  ret <2 x i256> %3
}

define i128 @lshr_shl_mask(i128 %a0) {
; i686-LABEL: lshr_shl_mask:
; i686:       # %bb.0:
; i686-NEXT:    pushl %edi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    pushl %esi
; i686-NEXT:    .cfi_def_cfa_offset 12
; i686-NEXT:    .cfi_offset %esi, -12
; i686-NEXT:    .cfi_offset %edi, -8
; i686-NEXT:    movl {{[0-9]+}}(%esp), %eax
; i686-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edx
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl $2147483647, %edi # imm = 0x7FFFFFFF
; i686-NEXT:    andl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    movl %edi, 12(%eax)
; i686-NEXT:    movl %esi, 8(%eax)
; i686-NEXT:    movl %edx, 4(%eax)
; i686-NEXT:    movl %ecx, (%eax)
; i686-NEXT:    popl %esi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    popl %edi
; i686-NEXT:    .cfi_def_cfa_offset 4
; i686-NEXT:    retl $4
;
; x86_64-LABEL: lshr_shl_mask:
; x86_64:       # %bb.0:
; x86_64-NEXT:    movq %rdi, %rax
; x86_64-NEXT:    movabsq $9223372036854775807, %rdx # imm = 0x7FFFFFFFFFFFFFFF
; x86_64-NEXT:    andq %rsi, %rdx
; x86_64-NEXT:    retq
  %1 = shl i128 %a0, 1
  %2 = lshr i128 %1, 1
  ret i128 %2
}
