; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -mtriple=aarch64 < %s | FileCheck %s --check-prefix=RECIP
; RUN: opt -passes="print<cost-model>" 2>&1 -disable-output -cost-kind=code-size -mtriple=aarch64 < %s | FileCheck %s --check-prefix=SIZE

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

declare <2 x i64>  @llvm.abs.v2i64(<2 x i64>, i1)
declare <4 x i64>  @llvm.abs.v4i64(<4 x i64>, i1)
declare <8 x i64>  @llvm.abs.v8i64(<8 x i64>, i1)

declare <2 x i32>  @llvm.abs.v2i32(<2 x i32>, i1)
declare <4 x i32>  @llvm.abs.v4i32(<4 x i32>, i1)
declare <8 x i32>  @llvm.abs.v8i32(<8 x i32>, i1)
declare <16 x i32> @llvm.abs.v16i32(<16 x i32>, i1)

declare <2 x i16>  @llvm.abs.v2i16(<2 x i16>, i1)
declare <4 x i16>  @llvm.abs.v4i16(<4 x i16>, i1)
declare <8 x i16>  @llvm.abs.v8i16(<8 x i16>, i1)
declare <16 x i16> @llvm.abs.v16i16(<16 x i16>, i1)
declare <32 x i16> @llvm.abs.v32i16(<32 x i16>, i1)

declare <2 x i8>   @llvm.abs.v2i8(<2 x i8>, i1)
declare <4 x i8>   @llvm.abs.v4i8(<4 x i8>, i1)
declare <8 x i8>   @llvm.abs.v8i8(<8 x i8>, i1)
declare <16 x i8>  @llvm.abs.v16i8(<16 x i8>, i1)
declare <32 x i8>  @llvm.abs.v32i8(<32 x i8>, i1)
declare <64 x i8>  @llvm.abs.v64i8(<64 x i8>, i1)

define i32 @abs(i32 %arg) {
; RECIP-LABEL: 'abs'
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.abs.v2i64(<2 x i64> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.abs.v4i64(<4 x i64> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.abs.v8i64(<8 x i64> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.abs.v2i32(<2 x i32> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.abs.v4i32(<4 x i32> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.abs.v8i32(<8 x i32> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.abs.v16i32(<16 x i32> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I16 = call <2 x i16> @llvm.abs.v2i16(<2 x i16> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.abs.v4i16(<4 x i16> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.abs.v8i16(<8 x i16> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.abs.v16i16(<16 x i16> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.abs.v32i16(<32 x i16> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.abs.v8i8(<8 x i8> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.abs.v16i8(<16 x i8> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.abs.v32i8(<32 x i8> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.abs.v64i8(<64 x i8> undef, i1 false)
; RECIP-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; SIZE-LABEL: 'abs'
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I64 = call <2 x i64> @llvm.abs.v2i64(<2 x i64> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V4I64 = call <4 x i64> @llvm.abs.v4i64(<4 x i64> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V8I64 = call <8 x i64> @llvm.abs.v8i64(<8 x i64> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I32 = call <2 x i32> @llvm.abs.v2i32(<2 x i32> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I32 = call <4 x i32> @llvm.abs.v4i32(<4 x i32> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V8I32 = call <8 x i32> @llvm.abs.v8i32(<8 x i32> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V16I32 = call <16 x i32> @llvm.abs.v16i32(<16 x i32> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V2I16 = call <2 x i16> @llvm.abs.v2i16(<2 x i16> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V4I16 = call <4 x i16> @llvm.abs.v4i16(<4 x i16> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I16 = call <8 x i16> @llvm.abs.v8i16(<8 x i16> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V16I16 = call <16 x i16> @llvm.abs.v16i16(<16 x i16> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V32I16 = call <32 x i16> @llvm.abs.v32i16(<32 x i16> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V8I8 = call <8 x i8> @llvm.abs.v8i8(<8 x i8> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %V16I8 = call <16 x i8> @llvm.abs.v16i8(<16 x i8> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %V32I8 = call <32 x i8> @llvm.abs.v32i8(<32 x i8> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %V64I8 = call <64 x i8> @llvm.abs.v64i8(<64 x i8> undef, i1 false)
; SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret i32 undef
;
  %V2I64 = call <2 x i64> @llvm.abs.v2i64(<2 x i64> undef, i1 false)
  %V4I64 = call <4 x i64> @llvm.abs.v4i64(<4 x i64> undef, i1 false)
  %V8I64 = call <8 x i64> @llvm.abs.v8i64(<8 x i64> undef, i1 false)

  %V2I32  = call <2 x i32>  @llvm.abs.v2i32(<2 x i32> undef, i1 false)
  %V4I32  = call <4 x i32>  @llvm.abs.v4i32(<4 x i32> undef, i1 false)
  %V8I32  = call <8 x i32>  @llvm.abs.v8i32(<8 x i32> undef, i1 false)
  %V16I32 = call <16 x i32> @llvm.abs.v16i32(<16 x i32> undef, i1 false)

  %V2I16  = call <2 x i16>  @llvm.abs.v2i16(<2 x i16> undef, i1 false)
  %V4I16  = call <4 x i16>  @llvm.abs.v4i16(<4 x i16> undef, i1 false)
  %V8I16  = call <8 x i16>  @llvm.abs.v8i16(<8 x i16> undef, i1 false)
  %V16I16 = call <16 x i16> @llvm.abs.v16i16(<16 x i16> undef, i1 false)
  %V32I16 = call <32 x i16> @llvm.abs.v32i16(<32 x i16> undef, i1 false)

  %V8I8  = call <8 x i8>  @llvm.abs.v8i8(<8 x i8> undef, i1 false)
  %V16I8 = call <16 x i8> @llvm.abs.v16i8(<16 x i8> undef, i1 false)
  %V32I8 = call <32 x i8> @llvm.abs.v32i8(<32 x i8> undef, i1 false)
  %V64I8 = call <64 x i8> @llvm.abs.v64i8(<64 x i8> undef, i1 false)

  ret i32 undef
}
