; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=arm64-apple-ios %s -o - -global-isel -global-isel-abort=1 -stop-after=irtranslator | FileCheck %s

define i128 @func_i128(ptr %ptr) {

  ; CHECK-LABEL: name: func_i128
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(s128) = G_LOAD [[COPY]](p0) :: (load (s128) from %ir.ptr)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s64), [[UV1:%[0-9]+]]:_(s64) = G_UNMERGE_VALUES [[LOAD]](s128)
  ; CHECK-NEXT:   $x0 = COPY [[UV]](s64)
  ; CHECK-NEXT:   $x1 = COPY [[UV1]](s64)
  ; CHECK-NEXT:   RET_ReallyLR implicit $x0, implicit $x1
  %val = load i128, ptr %ptr
  ret i128 %val
}

define <8 x float> @func_v8f32(ptr %ptr) {

  ; CHECK-LABEL: name: func_v8f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(<8 x s32>) = G_LOAD [[COPY]](p0) :: (load (<8 x s32>) from %ir.ptr)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(<4 x s32>), [[UV1:%[0-9]+]]:_(<4 x s32>) = G_UNMERGE_VALUES [[LOAD]](<8 x s32>)
  ; CHECK-NEXT:   $q0 = COPY [[UV]](<4 x s32>)
  ; CHECK-NEXT:   $q1 = COPY [[UV1]](<4 x s32>)
  ; CHECK-NEXT:   RET_ReallyLR implicit $q0, implicit $q1
  %val = load <8 x float>, ptr %ptr
  ret <8 x float> %val
}

; A bit weird, but s0-s5 is what SDAG does too.
define <6 x float> @func_v6f32(ptr %ptr) {

  ; CHECK-LABEL: name: func_v6f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $x0
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(p0) = COPY $x0
  ; CHECK-NEXT:   [[LOAD:%[0-9]+]]:_(<6 x s32>) = G_LOAD [[COPY]](p0) :: (load (<6 x s32>) from %ir.ptr, align 32)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32), [[UV3:%[0-9]+]]:_(s32), [[UV4:%[0-9]+]]:_(s32), [[UV5:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[LOAD]](<6 x s32>)
  ; CHECK-NEXT:   $s0 = COPY [[UV]](s32)
  ; CHECK-NEXT:   $s1 = COPY [[UV1]](s32)
  ; CHECK-NEXT:   $s2 = COPY [[UV2]](s32)
  ; CHECK-NEXT:   $s3 = COPY [[UV3]](s32)
  ; CHECK-NEXT:   $s4 = COPY [[UV4]](s32)
  ; CHECK-NEXT:   $s5 = COPY [[UV5]](s32)
  ; CHECK-NEXT:   RET_ReallyLR implicit $s0, implicit $s1, implicit $s2, implicit $s3, implicit $s4, implicit $s5
  %val = load <6 x float>, ptr %ptr
  ret <6 x float> %val
}

define i128 @ABIi128(i128 %arg1) {
  ; CHECK-LABEL: name: ABIi128
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $x0, $x1
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:_(s64) = COPY $x0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:_(s64) = COPY $x1
  ; CHECK-NEXT:   [[MV:%[0-9]+]]:_(s128) = G_MERGE_VALUES [[COPY]](s64), [[COPY1]](s64)
  ; CHECK-NEXT:   [[FPTOUI:%[0-9]+]]:_(s128) = G_FPTOUI [[MV]](s128)
  ; CHECK-NEXT:   [[UV:%[0-9]+]]:_(s64), [[UV1:%[0-9]+]]:_(s64) = G_UNMERGE_VALUES [[FPTOUI]](s128)
  ; CHECK-NEXT:   $x0 = COPY [[UV]](s64)
  ; CHECK-NEXT:   $x1 = COPY [[UV1]](s64)
  ; CHECK-NEXT:   RET_ReallyLR implicit $x0, implicit $x1
  %farg1 =       bitcast i128 %arg1 to fp128
  %res = fptoui fp128 %farg1 to i128
  ret i128 %res
}
