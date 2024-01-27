; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-annotate-decl-cs  -S < %s | FileCheck %s --check-prefixes=CHECK,TUNIT
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC

%T = type { i32, i32, i32, i32 }
@G = constant %T { i32 0, i32 0, i32 17, i32 25 }

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = constant [[T:%.*]] { i32 0, i32 0, i32 17, i32 25 }
;.
define internal i32 @test(ptr %p) {
; CGSCC: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@test
; CGSCC-SAME: () #[[ATTR0:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    ret i32 42
;
entry:
  %a.gep = getelementptr %T, ptr %p, i64 0, i32 3
  %b.gep = getelementptr %T, ptr %p, i64 0, i32 2
  %a = load i32, ptr %a.gep
  %b = load i32, ptr %b.gep
  %v = add i32 %a, %b
  ret i32 %v
}

define i32 @caller() {
;
; TUNIT: Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
; TUNIT-LABEL: define {{[^@]+}}@caller
; TUNIT-SAME: () #[[ATTR0:[0-9]+]] {
; TUNIT-NEXT:  entry:
; TUNIT-NEXT:    ret i32 42
;
; CGSCC: Function Attrs: mustprogress nofree nosync nounwind willreturn memory(none)
; CGSCC-LABEL: define {{[^@]+}}@caller
; CGSCC-SAME: () #[[ATTR1:[0-9]+]] {
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    [[V:%.*]] = call noundef i32 @test() #[[ATTR2:[0-9]+]]
; CGSCC-NEXT:    ret i32 [[V]]
;
entry:
  %v = call i32 @test(ptr @G)
  ret i32 %v
}
;.
; TUNIT: attributes #[[ATTR0]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
;.
; CGSCC: attributes #[[ATTR0]] = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR1]] = { mustprogress nofree nosync nounwind willreturn memory(none) }
; CGSCC: attributes #[[ATTR2]] = { nofree willreturn }
;.
;; NOTE: These prefixes are unused and the list is autogenerated. Do not add tests below this line:
; CHECK: {{.*}}
