; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define i1 @idx_known_positive_via_len_1(i8 %len, i8 %idx) {
; CHECK-LABEL: @idx_known_positive_via_len_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN_POS:%.*]] = icmp sge i8 [[LEN:%.*]], 0
; CHECK-NEXT:    [[IDX_ULT_LEN:%.*]] = icmp ult i8 [[IDX:%.*]], [[LEN]]
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[LEN_POS]], [[IDX_ULT_LEN]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[IDX]], 1
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 1
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], true
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       else:
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    ret i1 [[C_3]]
;
entry:
  %len.pos = icmp sge i8 %len, 0
  %idx.ult.len  = icmp ult i8 %idx, %len
  %and.1 = and i1 %len.pos, %idx.ult.len
  br i1 %and.1, label %then.1, label %else

then.1:
  %t.1 = icmp ult i8 %idx, %len
  %t.2 = icmp sge i8 %idx, 0
  %r.1 = xor i1 %t.1, %t.2

  %c.1 = icmp sge i8 %idx, 1
  %r.2 = xor i1 %r.1, %c.1

  %c.2 = icmp sge i8 %len, 1
  %r.3 = xor i1 %r.2, %c.2
  ret i1 %r.3

else:
  %c.3 = icmp sge i8 %idx, 0
  ret i1 %c.3
}

; Like @idx_known_positive_via_len_1, but with a different order of known facts.
define i1 @idx_known_positive_via_len_2(i8 %len, i8 %idx) {
; CHECK-LABEL: @idx_known_positive_via_len_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_ULT_LEN:%.*]] = icmp ult i8 [[IDX:%.*]], [[LEN:%.*]]
; CHECK-NEXT:    [[LEN_POS:%.*]] = icmp sge i8 [[LEN]], 0
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[IDX_ULT_LEN]], [[LEN_POS]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[IDX]], 1
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_1]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 1
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], true
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       else:
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    ret i1 [[C_3]]
;
entry:
  %idx.ult.len  = icmp ult i8 %idx, %len
  %len.pos = icmp sge i8 %len, 0
  %and.1 = and i1 %idx.ult.len, %len.pos
  br i1 %and.1, label %then.1, label %else

then.1:
  %t.1 = icmp ult i8 %idx, %len
  %t.2 = icmp sge i8 %idx, 0
  %r.1 = xor i1 %t.1, %t.2

  %c.1 = icmp sge i8 %idx, 1
  %r.2 = xor i1 %r.1, %c.1

  %c.2 = icmp sge i8 %len, 1
  %r.3 = xor i1 %r.2, %c.2
  ret i1 %r.3

else:
  %c.3 = icmp sge i8 %idx, 0
  ret i1 %c.3
}


; %len >=u 0 is not enough to determine idx >=s 0.
define i1 @idx_not_known_positive_via_len_uge(i8 %len, i8 %idx) {
; CHECK-LABEL: @idx_not_known_positive_via_len_uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN_POS:%.*]] = icmp uge i8 [[LEN:%.*]], 0
; CHECK-NEXT:    [[IDX_ULT_LEN:%.*]] = icmp ult i8 [[IDX:%.*]], [[LEN]]
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[LEN_POS]], [[IDX_ULT_LEN]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[IDX]], 1
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i8 [[LEN]], 1
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       else:
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    ret i1 [[C_5]]
;
entry:
  %len.pos = icmp uge i8 %len, 0
  %idx.ult.len  = icmp ult i8 %idx, %len
  %and.1 = and i1 %len.pos, %idx.ult.len
  br i1 %and.1, label %then.1, label %else

then.1:
  %c.1 = icmp ult i8 %idx, %len
  %c.2 = icmp sge i8 %idx, 0
  %r.1 = xor i1 %c.1, %c.2

  %c.3 = icmp sge i8 %idx, 1
  %r.2 = xor i1 %r.1, %c.3

  %c.4 = icmp sge i8 %len, 1
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

else:
  %c.5 = icmp sge i8 %idx, 0
  ret i1 %c.5
}

; There's no information about %len which could be used to determine %len >=s 0.
define i1 @idx_not_known_positive_via_len(i8 %len, i8 %idx) {
; CHECK-LABEL: @idx_not_known_positive_via_len(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_ULT_LEN:%.*]] = icmp ult i8 [[IDX:%.*]], [[LEN:%.*]]
; CHECK-NEXT:    br i1 [[IDX_ULT_LEN]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    [[R_1:%.*]] = xor i1 true, [[C_2]]
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[IDX]], 1
; CHECK-NEXT:    [[R_2:%.*]] = xor i1 [[R_1]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i8 [[LEN]], 1
; CHECK-NEXT:    [[R_3:%.*]] = xor i1 [[R_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[R_3]]
; CHECK:       else:
; CHECK-NEXT:    [[C_5:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    ret i1 [[C_5]]
;
entry:
  %idx.ult.len  = icmp ult i8 %idx, %len
  br i1 %idx.ult.len, label %then.1, label %else

then.1:
  %c.1 = icmp ult i8 %idx, %len
  %c.2 = icmp sge i8 %idx, 0
  %r.1 = xor i1 %c.1, %c.2

  %c.3 = icmp sge i8 %idx, 1
  %r.2 = xor i1 %r.1, %c.3

  %c.4 = icmp sge i8 %len, 1
  %r.3 = xor i1 %r.2, %c.4
  ret i1 %r.3

else:
  %c.5 = icmp sge i8 %idx, 0
  ret i1 %c.5
}

define i1 @ult_signed_pos_constant(i8 %a) {
; CHECK-LABEL: @ult_signed_pos_constant(
; CHECK-NEXT:    [[A_ULT_4:%.*]] = icmp ult i8 [[A:%.*]], 4
; CHECK-NEXT:    br i1 [[A_ULT_4]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[T_0:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[T_1:%.*]] = icmp slt i8 [[A]], 4
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 true, true
; CHECK-NEXT:    [[C_0:%.*]] = icmp slt i8 [[A]], 5
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], true
; CHECK-NEXT:    ret i1 [[RES_2]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[C_3:%.*]] = icmp slt i8 [[A]], 4
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[C_2]], [[C_3]]
; CHECK-NEXT:    [[C_4:%.*]] = icmp slt i8 [[A]], 5
; CHECK-NEXT:    [[RES_4:%.*]] = xor i1 [[RES_3]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_4]]
;
  %a.ult.4 = icmp ult i8 %a, 4
  br i1 %a.ult.4, label %then, label %else

then:
  %t.0 = icmp sge i8 %a, 0
  %t.1 = icmp slt i8 %a, 4
  %res.1 = xor i1 %t.0, %t.1

  %c.0 = icmp slt i8 %a, 5
  %res.2 = xor i1 %res.1, %c.0
  ret i1 %res.2

else:
  %c.2 = icmp sge i8 %a, 0
  %c.3 = icmp slt i8 %a, 4
  %res.3 = xor i1 %c.2, %c.3

  %c.4 = icmp slt i8 %a, 5
  %res.4 = xor i1 %res.3, %c.4

  ret i1 %res.4
}

define i1 @ult_signed_neg_constant(i8 %a) {
; CHECK-LABEL: @ult_signed_neg_constant(
; CHECK-NEXT:    [[A_ULT_4:%.*]] = icmp ult i8 [[A:%.*]], -2
; CHECK-NEXT:    br i1 [[A_ULT_4]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[C_0:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[C_1:%.*]] = icmp slt i8 [[A]], -2
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_0]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_1]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.ult.4 = icmp ult i8 %a, -2
  br i1 %a.ult.4, label %then, label %else

then:
  %c.0 = icmp sge i8 %a, 0
  %c.1 = icmp slt i8 %a, -2
  %res.1 = xor i1 %c.0, %c.1
  ret i1 %res.1

else:
  ret i1 0
}
