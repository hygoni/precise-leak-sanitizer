; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64 | FileCheck %s

; Test pattern (v4f16 (AArch64NvCast (v2i32 FPR64:$src)))
define void @nvcast_v2i32(ptr %a) #0 {
; CHECK-LABEL: nvcast_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.2s, #171, lsl #16
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  store volatile <4 x half> <half 0xH0000, half 0xH00AB, half 0xH0000, half 0xH00AB>, ptr %a
  ret void
}

; Test pattern (v4f16 (AArch64NvCast (v4i16 FPR64:$src)))
define void @nvcast_v4i16(ptr %a) #0 {
; CHECK-LABEL: nvcast_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.4h, #171
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  store volatile <4 x half> <half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB>, ptr %a
  ret void
}

; Test pattern (v4f16 (AArch64NvCast (v8i8 FPR64:$src)))
define void @nvcast_v8i8(ptr %a) #0 {
; CHECK-LABEL: nvcast_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.8b, #171
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  store volatile <4 x half> <half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB>, ptr %a
  ret void
}

; Test pattern (v4f16 (AArch64NvCast (f64 FPR64:$src)))
define void @nvcast_f64(ptr %a) #0 {
; CHECK-LABEL: nvcast_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi d0, #0000000000000000
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  store volatile <4 x half> zeroinitializer, ptr %a
  ret void
}

; Test pattern (v8f16 (AArch64NvCast (v4i32 FPR128:$src)))
define void @nvcast_v4i32(ptr %a) #0 {
; CHECK-LABEL: nvcast_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.4s, #171, lsl #16
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  store volatile <8 x half> <half 0xH0000, half 0xH00AB, half 0xH0000, half 0xH00AB, half 0xH0000, half 0xH00AB, half 0xH0000, half 0xH00AB>, ptr %a
  ret void
}

; Test pattern (v8f16 (AArch64NvCast (v8i16 FPR128:$src)))
define void @nvcast_v8i16(ptr %a) #0 {
; CHECK-LABEL: nvcast_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.8h, #171
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  store volatile <8 x half> <half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB, half 0xH00AB>, ptr %a
  ret void
}

; Test pattern (v8f16 (AArch64NvCast (v16i8 FPR128:$src)))
define void @nvcast_v16i8(ptr %a) #0 {
; CHECK-LABEL: nvcast_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.16b, #171
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  store volatile <8 x half> <half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB, half 0xHABAB>, ptr %a
  ret void
}

; Test pattern (v8f16 (AArch64NvCast (v2i64 FPR128:$src)))
define void @nvcast_v2i64(ptr %a) #0 {
; CHECK-LABEL: nvcast_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  store volatile <8 x half> zeroinitializer, ptr %a
  ret void
}

attributes #0 = { nounwind }
