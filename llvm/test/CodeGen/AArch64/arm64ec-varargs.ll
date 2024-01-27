; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=arm64ec-pc-windows-msvc < %s | FileCheck %s
; RUN: llc -mtriple=arm64ec-pc-windows-msvc < %s -global-isel=1 -global-isel-abort=0 | FileCheck %s

define void @varargs_callee(double %x, ...) nounwind {
; CHECK-LABEL: varargs_callee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #48
; CHECK-NEXT:    stp x1, x2, [x4, #-24]!
; CHECK-NEXT:    str x3, [x4, #16]
; CHECK-NEXT:    str x4, [sp, #8]
; CHECK-NEXT:    add sp, sp, #48
; CHECK-NEXT:    ret
  %list = alloca ptr, align 8
  call void @llvm.va_start(ptr nonnull %list)
  ret void
}

define void @varargs_callee_manyargs(i64, i64, i64, i64, i64, ...) nounwind {
; CHECK-LABEL: varargs_callee_manyargs:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #16
; CHECK-NEXT:    add x8, x4, #8
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    add sp, sp, #16
; CHECK-NEXT:    ret
  %list = alloca ptr, align 8
  call void @llvm.va_start(ptr nonnull %list)
  ret void
}

define void @varargs_caller() nounwind {
; CHECK-LABEL: varargs_caller:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #48
; CHECK-NEXT:    mov x4, sp
; CHECK-NEXT:    add x8, sp, #16
; CHECK-NEXT:    mov x9, #4617315517961601024 // =0x4014000000000000
; CHECK-NEXT:    mov x0, #4607182418800017408 // =0x3ff0000000000000
; CHECK-NEXT:    mov w1, #2 // =0x2
; CHECK-NEXT:    mov x2, #4613937818241073152 // =0x4008000000000000
; CHECK-NEXT:    mov w3, #4 // =0x4
; CHECK-NEXT:    mov w5, #16 // =0x10
; CHECK-NEXT:    stp xzr, x30, [sp, #24] // 8-byte Folded Spill
; CHECK-NEXT:    stp x9, x8, [sp]
; CHECK-NEXT:    str xzr, [sp, #16]
; CHECK-NEXT:    bl varargs_callee
; CHECK-NEXT:    ldr x30, [sp, #32] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #48
; CHECK-NEXT:    ret
  call void (double, ...) @varargs_callee(double 1.0, i32 2, double 3.0, i32 4, double 5.0, <2 x double> <double 0.0, double 0.0>)
  ret void
}

define <2 x double> @varargs_many_argscallee(double %a, double %b, double %c,
; CHECK-LABEL: varargs_many_argscallee:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x4]
; CHECK-NEXT:    ldr q0, [x3]
; CHECK-NEXT:    ldr q1, [x8]
; CHECK-NEXT:    fadd v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    ret
                                             <2 x double> %d, <2 x double> %e, ...) nounwind {
  %rval = fadd <2 x double> %d, %e
  ret <2 x double> %rval
}

define void @varargs_many_argscalleer() nounwind {
; CHECK-LABEL: varargs_many_argscalleer:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub sp, sp, #64
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    mov x4, sp
; CHECK-NEXT:    mov x8, #4618441417868443648 // =0x4018000000000000
; CHECK-NEXT:    add x9, sp, #16
; CHECK-NEXT:    add x3, sp, #32
; CHECK-NEXT:    mov x0, #4607182418800017408 // =0x3ff0000000000000
; CHECK-NEXT:    mov x1, #4611686018427387904 // =0x4000000000000000
; CHECK-NEXT:    mov x2, #4613937818241073152 // =0x4008000000000000
; CHECK-NEXT:    mov w5, #16 // =0x10
; CHECK-NEXT:    str x30, [sp, #48] // 8-byte Folded Spill
; CHECK-NEXT:    stp x9, x8, [sp]
; CHECK-NEXT:    stp q0, q0, [sp, #16]
; CHECK-NEXT:    bl varargs_many_argscallee
; CHECK-NEXT:    ldr x30, [sp, #48] // 8-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #64
; CHECK-NEXT:    ret
  call <2 x double> (double, double, double, <2 x double>, <2 x double>, ...)
      @varargs_many_argscallee(double 1., double 2., double 3.,
                               <2 x double> zeroinitializer,
                               <2 x double> zeroinitializer, double 6.)
  ret void
}


declare void @llvm.va_start(ptr)
