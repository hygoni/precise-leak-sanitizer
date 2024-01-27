; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 --mattr=+d < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 --mattr=+d < %s | FileCheck %s --check-prefix=LA64

;; TODO: Add more test cases after ABI implementation for ilp32f and lp64f.

declare float @llvm.sin.f32(float)
declare float @llvm.cos.f32(float)
declare float @llvm.pow.f32(float, float)
declare double @llvm.sin.f64(double)
declare double @llvm.cos.f64(double)
declare double @llvm.pow.f64(double, double)

define float @sin_f32(float %a) nounwind {
; LA32-LABEL: sin_f32:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(sinf)
;
; LA64-LABEL: sin_f32:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(sinf)
  %1 = call float @llvm.sin.f32(float %a)
  ret float %1
}

define float @cos_f32(float %a) nounwind {
; LA32-LABEL: cos_f32:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(cosf)
;
; LA64-LABEL: cos_f32:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(cosf)
  %1 = call float @llvm.cos.f32(float %a)
  ret float %1
}

define float @sincos_f32(float %a) nounwind {
; LA32-LABEL: sincos_f32:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -32
; LA32-NEXT:    st.w $ra, $sp, 28 # 4-byte Folded Spill
; LA32-NEXT:    fst.d $fs0, $sp, 16 # 8-byte Folded Spill
; LA32-NEXT:    fst.d $fs1, $sp, 8 # 8-byte Folded Spill
; LA32-NEXT:    fmov.s $fs0, $fa0
; LA32-NEXT:    bl %plt(sinf)
; LA32-NEXT:    fmov.s $fs1, $fa0
; LA32-NEXT:    fmov.s $fa0, $fs0
; LA32-NEXT:    bl %plt(cosf)
; LA32-NEXT:    fadd.s $fa0, $fs1, $fa0
; LA32-NEXT:    fld.d $fs1, $sp, 8 # 8-byte Folded Reload
; LA32-NEXT:    fld.d $fs0, $sp, 16 # 8-byte Folded Reload
; LA32-NEXT:    ld.w $ra, $sp, 28 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 32
; LA32-NEXT:    ret
;
; LA64-LABEL: sincos_f32:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $sp, $sp, -32
; LA64-NEXT:    st.d $ra, $sp, 24 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs0, $sp, 16 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs1, $sp, 8 # 8-byte Folded Spill
; LA64-NEXT:    fmov.s $fs0, $fa0
; LA64-NEXT:    bl %plt(sinf)
; LA64-NEXT:    fmov.s $fs1, $fa0
; LA64-NEXT:    fmov.s $fa0, $fs0
; LA64-NEXT:    bl %plt(cosf)
; LA64-NEXT:    fadd.s $fa0, $fs1, $fa0
; LA64-NEXT:    fld.d $fs1, $sp, 8 # 8-byte Folded Reload
; LA64-NEXT:    fld.d $fs0, $sp, 16 # 8-byte Folded Reload
; LA64-NEXT:    ld.d $ra, $sp, 24 # 8-byte Folded Reload
; LA64-NEXT:    addi.d $sp, $sp, 32
; LA64-NEXT:    ret
  %1 = call float @llvm.sin.f32(float %a)
  %2 = call float @llvm.cos.f32(float %a)
  %3 = fadd float %1, %2
  ret float %3
}

define float @pow_f32(float %a, float %b) nounwind {
; LA32-LABEL: pow_f32:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(powf)
;
; LA64-LABEL: pow_f32:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(powf)
  %1 = call float @llvm.pow.f32(float %a, float %b)
  ret float %1
}

define float @frem_f32(float %a, float %b) nounwind {
; LA32-LABEL: frem_f32:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(fmodf)
;
; LA64-LABEL: frem_f32:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(fmodf)
  %1 = frem float %a, %b
  ret float %1
}

define double @sin_f64(double %a) nounwind {
; LA32-LABEL: sin_f64:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(sin)
;
; LA64-LABEL: sin_f64:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(sin)
  %1 = call double @llvm.sin.f64(double %a)
  ret double %1
}

define double @cos_f64(double %a) nounwind {
; LA32-LABEL: cos_f64:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(cos)
;
; LA64-LABEL: cos_f64:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(cos)
  %1 = call double @llvm.cos.f64(double %a)
  ret double %1
}

define double @sincos_f64(double %a) nounwind {
; LA32-LABEL: sincos_f64:
; LA32:       # %bb.0:
; LA32-NEXT:    addi.w $sp, $sp, -32
; LA32-NEXT:    st.w $ra, $sp, 28 # 4-byte Folded Spill
; LA32-NEXT:    fst.d $fs0, $sp, 16 # 8-byte Folded Spill
; LA32-NEXT:    fst.d $fs1, $sp, 8 # 8-byte Folded Spill
; LA32-NEXT:    fmov.d $fs0, $fa0
; LA32-NEXT:    bl %plt(sin)
; LA32-NEXT:    fmov.d $fs1, $fa0
; LA32-NEXT:    fmov.d $fa0, $fs0
; LA32-NEXT:    bl %plt(cos)
; LA32-NEXT:    fadd.d $fa0, $fs1, $fa0
; LA32-NEXT:    fld.d $fs1, $sp, 8 # 8-byte Folded Reload
; LA32-NEXT:    fld.d $fs0, $sp, 16 # 8-byte Folded Reload
; LA32-NEXT:    ld.w $ra, $sp, 28 # 4-byte Folded Reload
; LA32-NEXT:    addi.w $sp, $sp, 32
; LA32-NEXT:    ret
;
; LA64-LABEL: sincos_f64:
; LA64:       # %bb.0:
; LA64-NEXT:    addi.d $sp, $sp, -32
; LA64-NEXT:    st.d $ra, $sp, 24 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs0, $sp, 16 # 8-byte Folded Spill
; LA64-NEXT:    fst.d $fs1, $sp, 8 # 8-byte Folded Spill
; LA64-NEXT:    fmov.d $fs0, $fa0
; LA64-NEXT:    bl %plt(sin)
; LA64-NEXT:    fmov.d $fs1, $fa0
; LA64-NEXT:    fmov.d $fa0, $fs0
; LA64-NEXT:    bl %plt(cos)
; LA64-NEXT:    fadd.d $fa0, $fs1, $fa0
; LA64-NEXT:    fld.d $fs1, $sp, 8 # 8-byte Folded Reload
; LA64-NEXT:    fld.d $fs0, $sp, 16 # 8-byte Folded Reload
; LA64-NEXT:    ld.d $ra, $sp, 24 # 8-byte Folded Reload
; LA64-NEXT:    addi.d $sp, $sp, 32
; LA64-NEXT:    ret
  %1 = call double @llvm.sin.f64(double %a)
  %2 = call double @llvm.cos.f64(double %a)
  %3 = fadd double %1, %2
  ret double %3
}

define double @pow_f64(double %a, double %b) nounwind {
; LA32-LABEL: pow_f64:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(pow)
;
; LA64-LABEL: pow_f64:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(pow)
  %1 = call double @llvm.pow.f64(double %a, double %b)
  ret double %1
}

define double @frem_f64(double %a, double %b) nounwind {
; LA32-LABEL: frem_f64:
; LA32:       # %bb.0:
; LA32-NEXT:    b %plt(fmod)
;
; LA64-LABEL: frem_f64:
; LA64:       # %bb.0:
; LA64-NEXT:    b %plt(fmod)
  %1 = frem double %a, %b
  ret double %1
}
