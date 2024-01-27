; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT

declare float @llvm.sqrt.f32(float)
declare <2 x float> @llvm.sqrt.v2f32(<2 x float>)
declare float @llvm.experimental.constrained.sqrt.f32(float, metadata, metadata)

define float @ret_sqrt(float %arg0) #0 {
; CHECK-LABEL: define nofpclass(ninf nsub nnorm) float @ret_sqrt
; CHECK-SAME: (float [[ARG0:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(ninf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10:[0-9]+]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_noinf(float nofpclass(inf) %arg0) #0 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_noinf
; CHECK-SAME: (float nofpclass(inf) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_nopinf(float nofpclass(pinf) %arg0) #0 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_nopinf
; CHECK-SAME: (float nofpclass(pinf) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_noninf(float nofpclass(ninf) %arg0) #0 {
; CHECK-LABEL: define nofpclass(ninf nsub nnorm) float @ret_sqrt_noninf
; CHECK-SAME: (float nofpclass(ninf) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(ninf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_nonan(float nofpclass(nan) %arg0) #0 {
; CHECK-LABEL: define nofpclass(snan ninf nsub nnorm) float @ret_sqrt_nonan
; CHECK-SAME: (float nofpclass(nan) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(snan ninf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_nonan_noinf(float nofpclass(nan inf) %arg0) #0 {
; CHECK-LABEL: define nofpclass(snan inf nsub nnorm) float @ret_sqrt_nonan_noinf
; CHECK-SAME: (float nofpclass(nan inf) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(snan inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_nonan_noinf_nozero(float nofpclass(nan inf zero) %arg0) #0 {
; CHECK-LABEL: define nofpclass(snan inf nzero nsub nnorm) float @ret_sqrt_nonan_noinf_nozero
; CHECK-SAME: (float nofpclass(nan inf zero) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(snan inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_noinf_nozero(float nofpclass(inf zero) %arg0) #0 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_noinf_nozero
; CHECK-SAME: (float nofpclass(inf zero) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #0 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_positive_source(i32 %arg) #0 {
; CHECK-LABEL: define nofpclass(nan inf nzero nsub nnorm) float @ret_sqrt_positive_source
; CHECK-SAME: (i32 [[ARG:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[UITOFP:%.*]] = uitofp i32 [[ARG]] to float
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(nan inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[UITOFP]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %uitofp = uitofp i32 %arg to float
  %call = call float @llvm.sqrt.f32(float %uitofp)
  ret float %call
}

; Could produce a nan because we don't know if the multiply is negative.
define float @ret_sqrt_unknown_sign(float nofpclass(nan) %arg0, float nofpclass(nan) %arg1) #0 {
; CHECK-LABEL: define nofpclass(snan ninf nsub nnorm) float @ret_sqrt_unknown_sign
; CHECK-SAME: (float nofpclass(nan) [[ARG0:%.*]], float nofpclass(nan) [[ARG1:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    [[UNKNOWN_SIGN_NOT_NAN:%.*]] = fmul nnan float [[ARG0]], [[ARG1]]
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(snan ninf nsub nnorm) float @llvm.sqrt.f32(float [[UNKNOWN_SIGN_NOT_NAN]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %unknown.sign.not.nan = fmul nnan float %arg0, %arg1
  %call = call float @llvm.sqrt.f32(float %unknown.sign.not.nan)
  ret float %call
}

define float @ret_sqrt_daz_noinf_nozero(float nofpclass(inf zero) %arg0) #1 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_daz_noinf_nozero
; CHECK-SAME: (float nofpclass(inf zero) [[ARG0:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define <2 x float> @ret_sqrt_daz_noinf_nozero_v2f32(<2 x float> nofpclass(inf zero) %arg0) #1 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) <2 x float> @ret_sqrt_daz_noinf_nozero_v2f32
; CHECK-SAME: (<2 x float> nofpclass(inf zero) [[ARG0:%.*]]) #[[ATTR3]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) <2 x float> @llvm.sqrt.v2f32(<2 x float> [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret <2 x float> [[CALL]]
;
  %call = call <2 x float> @llvm.sqrt.v2f32(<2 x float> %arg0)
  ret <2 x float> %call
}

define float @ret_sqrt_daz_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #1 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_daz_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR3]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_dapz_noinf_nozero(float nofpclass(inf zero) %arg0) #2 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_dapz_noinf_nozero
; CHECK-SAME: (float nofpclass(inf zero) [[ARG0:%.*]]) #[[ATTR4:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_dapz_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #2 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_dapz_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR4]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_dynamic_noinf_nozero(float nofpclass(inf zero) %arg0) #3 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_dynamic_noinf_nozero
; CHECK-SAME: (float nofpclass(inf zero) [[ARG0:%.*]]) #[[ATTR5:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_dynamic_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #3 {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @ret_sqrt_dynamic_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR5]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_ftz_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #4 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_ftz_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR6:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_ftpz_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #5 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_ftpz_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR7:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @ret_sqrt_ftz_dynamic_noinf_nonegzero(float nofpclass(inf nzero) %arg0) #6 {
; CHECK-LABEL: define nofpclass(inf nzero nsub nnorm) float @ret_sqrt_ftz_dynamic_noinf_nonegzero
; CHECK-SAME: (float nofpclass(inf nzero) [[ARG0:%.*]]) #[[ATTR8:[0-9]+]] {
; CHECK-NEXT:    [[CALL:%.*]] = call nofpclass(inf nzero nsub nnorm) float @llvm.sqrt.f32(float [[ARG0]]) #[[ATTR10]]
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = call float @llvm.sqrt.f32(float %arg0)
  ret float %call
}

define float @constrained_sqrt(float %arg) strictfp {
; CHECK-LABEL: define nofpclass(ninf nsub nnorm) float @constrained_sqrt
; CHECK-SAME: (float [[ARG:%.*]]) #[[ATTR9:[0-9]+]] {
; CHECK-NEXT:    [[VAL:%.*]] = call nofpclass(ninf nsub nnorm) float @llvm.experimental.constrained.sqrt.f32(float [[ARG]], metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR10]]
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %arg, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret float %val
}

define float @constrained_sqrt_nonan(float nofpclass(nan) %arg) strictfp {
; CHECK-LABEL: define nofpclass(snan ninf nsub nnorm) float @constrained_sqrt_nonan
; CHECK-SAME: (float nofpclass(nan) [[ARG:%.*]]) #[[ATTR9]] {
; CHECK-NEXT:    [[VAL:%.*]] = call nofpclass(snan ninf nsub nnorm) float @llvm.experimental.constrained.sqrt.f32(float [[ARG]], metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR10]]
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %arg, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret float %val
}

define float @constrained_sqrt_nopinf(float nofpclass(pinf) %arg) strictfp {
; CHECK-LABEL: define nofpclass(inf nsub nnorm) float @constrained_sqrt_nopinf
; CHECK-SAME: (float nofpclass(pinf) [[ARG:%.*]]) #[[ATTR9]] {
; CHECK-NEXT:    [[VAL:%.*]] = call nofpclass(inf nsub nnorm) float @llvm.experimental.constrained.sqrt.f32(float [[ARG]], metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR10]]
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %arg, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret float %val
}

define float @constrained_sqrt_nonegzero(float nofpclass(nzero) %arg) strictfp {
; CHECK-LABEL: define nofpclass(ninf nzero nsub nnorm) float @constrained_sqrt_nonegzero
; CHECK-SAME: (float nofpclass(nzero) [[ARG:%.*]]) #[[ATTR9]] {
; CHECK-NEXT:    [[VAL:%.*]] = call nofpclass(ninf nzero nsub nnorm) float @llvm.experimental.constrained.sqrt.f32(float [[ARG]], metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR10]]
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %arg, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret float %val
}

define float @constrained_sqrt_nozero(float nofpclass(zero) %arg) strictfp {
; CHECK-LABEL: define nofpclass(ninf nzero nsub nnorm) float @constrained_sqrt_nozero
; CHECK-SAME: (float nofpclass(zero) [[ARG:%.*]]) #[[ATTR9]] {
; CHECK-NEXT:    [[VAL:%.*]] = call nofpclass(ninf nzero nsub nnorm) float @llvm.experimental.constrained.sqrt.f32(float [[ARG]], metadata !"round.dynamic", metadata !"fpexcept.strict") #[[ATTR10]]
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.experimental.constrained.sqrt.f32(float %arg, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret float %val
}

attributes #0 = { "denormal-fp-math"="ieee,ieee" }
attributes #1 = { "denormal-fp-math"="ieee,preserve-sign" }
attributes #2 = { "denormal-fp-math"="ieee,positive-zero" }
attributes #3 = { "denormal-fp-math"="ieee,dynamic" }
attributes #4 = { "denormal-fp-math"="preserve-sign,ieee" }
attributes #5 = { "denormal-fp-math"="positive-zero,ieee" }
attributes #6 = { "denormal-fp-math"="dynamic,ieee" }

;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; TUNIT: {{.*}}
