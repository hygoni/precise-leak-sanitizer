; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

define i1 @andn_icmp_eq_i8(i8 signext %a, i8 signext %b) nounwind {
; LA32-LABEL: andn_icmp_eq_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_eq_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    ret
  %and = and i8 %a, %b
  %cmpeq = icmp eq i8 %and, %b
  ret i1 %cmpeq
}

define i1 @andn_icmp_eq_i16(i16 signext %a, i16 signext %b) nounwind {
; LA32-LABEL: andn_icmp_eq_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_eq_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    ret
  %and = and i16 %a, %b
  %cmpeq = icmp eq i16 %and, %b
  ret i1 %cmpeq
}

define i1 @andn_icmp_eq_i32(i32 signext %a, i32 signext %b) nounwind {
; LA32-LABEL: andn_icmp_eq_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_eq_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    ret
  %and = and i32 %a, %b
  %cmpeq = icmp eq i32 %and, %b
  ret i1 %cmpeq
}

define i1 @andn_icmp_eq_i64(i64 %a, i64 %b) nounwind {
; LA32-LABEL: andn_icmp_eq_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a1, $a3, $a1
; LA32-NEXT:    andn $a0, $a2, $a0
; LA32-NEXT:    or $a0, $a0, $a1
; LA32-NEXT:    sltui $a0, $a0, 1
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_eq_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltui $a0, $a0, 1
; LA64-NEXT:    ret
  %and = and i64 %a, %b
  %cmpeq = icmp eq i64 %and, %b
  ret i1 %cmpeq
}

define i1 @andn_icmp_ne_i8(i8 signext %a, i8 signext %b) nounwind {
; LA32-LABEL: andn_icmp_ne_i8:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_ne_i8:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    ret
  %and = and i8 %a, %b
  %cmpne = icmp ne i8 %and, %b
  ret i1 %cmpne
}

define i1 @andn_icmp_ne_i16(i16 signext %a, i16 signext %b) nounwind {
; LA32-LABEL: andn_icmp_ne_i16:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_ne_i16:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    ret
  %and = and i16 %a, %b
  %cmpne = icmp ne i16 %and, %b
  ret i1 %cmpne
}

define i1 @andn_icmp_ne_i32(i32 signext %a, i32 signext %b) nounwind {
; LA32-LABEL: andn_icmp_ne_i32:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a0, $a1, $a0
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_ne_i32:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    ret
  %and = and i32 %a, %b
  %cmpne = icmp ne i32 %and, %b
  ret i1 %cmpne
}

define i1 @andn_icmp_ne_i64(i64 %a, i64 %b) nounwind {
; LA32-LABEL: andn_icmp_ne_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    andn $a1, $a3, $a1
; LA32-NEXT:    andn $a0, $a2, $a0
; LA32-NEXT:    or $a0, $a0, $a1
; LA32-NEXT:    sltu $a0, $zero, $a0
; LA32-NEXT:    ret
;
; LA64-LABEL: andn_icmp_ne_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    andn $a0, $a1, $a0
; LA64-NEXT:    sltu $a0, $zero, $a0
; LA64-NEXT:    ret
  %and = and i64 %a, %b
  %cmpne = icmp ne i64 %and, %b
  ret i1 %cmpne
}
