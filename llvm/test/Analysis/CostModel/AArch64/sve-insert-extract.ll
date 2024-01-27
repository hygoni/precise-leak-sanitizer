; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py

; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -S < %s | FileCheck --check-prefix=CHECK-DEFAULT %s
; RUN: opt -aarch64-insert-extract-base-cost=0 -passes="print<cost-model>" 2>&1 -disable-output -S < %s | FileCheck --check-prefix=CHECK-LOW %s
; RUN: opt -aarch64-insert-extract-base-cost=100000 -passes="print<cost-model>" 2>&1 -disable-output -S < %s | FileCheck --check-prefix=CHECK-HIGH %s

target triple = "aarch64-unknown-linux-gnu"
target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define void @ins_el0() #0 {
; CHECK-DEFAULT-LABEL: 'ins_el0'
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-LOW-LABEL: 'ins_el0'
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-HIGH-LABEL: 'ins_el0'
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100001 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 0, i64 0
  %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 0
  %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 0
  %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 0
  %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 0
  %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0., i64 0
  %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0., i64 0
  ret void
}

define void @ins_el1() #0 {
; CHECK-DEFAULT-LABEL: 'ins_el1'
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-LOW-LABEL: 'ins_el1'
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-HIGH-LABEL: 'ins_el1'
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100001 for instruction: %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 false, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0.000000e+00, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0.000000e+00, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %vi1 = insertelement <vscale x 16 x i1> zeroinitializer, i1 0, i64 1
  %v0 = insertelement <vscale x 16 x i8> zeroinitializer, i8 0, i64 1
  %v1 = insertelement <vscale x 8 x i16> zeroinitializer, i16 0, i64 1
  %v2 = insertelement <vscale x 4 x i32> zeroinitializer, i32 0, i64 1
  %v3 = insertelement <vscale x 2 x i64> zeroinitializer, i64 0, i64 1
  %v4 = insertelement <vscale x 4 x float> zeroinitializer, float 0., i64 1
  %v5 = insertelement <vscale x 2 x double> zeroinitializer, double 0., i64 1
  ret void
}


define void @ext_el0() #0 {
; CHECK-DEFAULT-LABEL: 'ext_el0'
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 0
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-LOW-LABEL: 'ext_el0'
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 0
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-HIGH-LABEL: 'ext_el0'
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100001 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 0
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 0
  %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 0
  %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 0
  %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 0
  %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 0
  %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 0
  %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 0
  ret void
}

define void @ext_el1() #0 {
; CHECK-DEFAULT-LABEL: 'ext_el1'
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-LOW-LABEL: 'ext_el1'
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-HIGH-LABEL: 'ext_el1'
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100001 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
  %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
  %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
  %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
  %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
  %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
  %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
  ret void
}


; Test the behaviour in the presence of a CPU-specific override in AArch64Subtarget (via attribute set).
define void @test_override_cpu_given() #1 {
; CHECK-DEFAULT-LABEL: 'test_override_cpu_given'
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-DEFAULT-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-LOW-LABEL: 'test_override_cpu_given'
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-LOW-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-HIGH-LABEL: 'test_override_cpu_given'
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100001 for instruction: %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 100000 for instruction: %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
; CHECK-HIGH-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %vi1 = extractelement <vscale x 16 x i1> zeroinitializer, i64 1
  %v0 = extractelement <vscale x 16 x i8> zeroinitializer, i64 1
  %v1 = extractelement <vscale x 8 x i16> zeroinitializer, i64 1
  %v2 = extractelement <vscale x 4 x i32> zeroinitializer, i64 1
  %v3 = extractelement <vscale x 2 x i64> zeroinitializer, i64 1
  %v4 = extractelement <vscale x 4 x float> zeroinitializer, i64 1
  %v5 = extractelement <vscale x 2 x double> zeroinitializer, i64 1
  ret void
}





attributes #0 = { "target-features"="+sve" vscale_range(1, 16) }
attributes #1 = { "target-features"="+sve" vscale_range(1, 16) "target-cpu"="kryo" }
