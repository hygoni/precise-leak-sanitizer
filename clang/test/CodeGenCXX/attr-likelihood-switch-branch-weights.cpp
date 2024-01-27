// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %clang_cc1 -O1 -disable-llvm-passes -emit-llvm %s -o - -triple=x86_64-linux-gnu | FileCheck %s

extern volatile int i;

// CHECK-LABEL: @_Z8OneCaseLv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2:![0-9]+]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !6
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void OneCaseL() {
  switch (i) {
    [[likely]] case 1: break;
  }
}

// CHECK-LABEL: @_Z8OneCaseUv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
// CHECK-NEXT:    ], !prof !7
// CHECK:       sw.bb:
// CHECK-NEXT:    [[TMP1:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP1]], 1
// CHECK-NEXT:    store volatile i32 [[INC]], ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void OneCaseU() {
  switch (i) {
    [[unlikely]] case 1: ++i; break;
  }
}

// CHECK-LABEL: @_Z10TwoCasesLNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !8
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesLN() {
  switch (i) {
    [[likely]] case 1: break;
    case 2: break;
  }
}

// CHECK-LABEL: @_Z10TwoCasesUNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !9
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesUN() {
  switch (i) {
    [[unlikely]] case 1: break;
    case 2: break;
  }
}

// CHECK-LABEL: @_Z10TwoCasesLUv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !10
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesLU() {
  switch (i) {
    [[likely]] case 1: break;
    [[unlikely]] case 2: break;
  }
}

// CHECK-LABEL: @_Z20CasesFallthroughNNLNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_BB]]
// CHECK-NEXT:    i32 3, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 4, label [[SW_BB1]]
// CHECK-NEXT:    ], !prof !11
// CHECK:       sw.bb:
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughNNLN() {
  switch (i) {
    case 1:
    case 2:
    [[likely]] case 3:
    case 4: break;
  }
}

// CHECK-LABEL: @_Z20CasesFallthroughNNUNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_BB]]
// CHECK-NEXT:    i32 3, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 4, label [[SW_BB1]]
// CHECK-NEXT:    ], !prof !12
// CHECK:       sw.bb:
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughNNUN() {
  switch (i) {
    case 1:
    case 2:
    [[unlikely]] case 3:
    case 4: break;
  }
}

// CHECK-LABEL: @_Z28CasesFallthroughRangeSmallLNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_BB]]
// CHECK-NEXT:    i32 3, label [[SW_BB]]
// CHECK-NEXT:    i32 4, label [[SW_BB]]
// CHECK-NEXT:    i32 5, label [[SW_BB]]
// CHECK-NEXT:    i32 102, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 103, label [[SW_BB2:%.*]]
// CHECK-NEXT:    i32 104, label [[SW_BB2]]
// CHECK-NEXT:    ], !prof !13
// CHECK:       sw.bb:
// CHECK-NEXT:    [[TMP1:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP1]], 1
// CHECK-NEXT:    store volatile i32 [[INC]], ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_BB2]]
// CHECK:       sw.bb2:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughRangeSmallLN() {
  switch (i) {
    case 1 ... 5: ++i;
    case 102:
    [[likely]] case 103:
    case 104: break;
  }
}

// CHECK-LABEL: @_Z28CasesFallthroughRangeSmallUNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_EPILOG:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_BB]]
// CHECK-NEXT:    i32 3, label [[SW_BB]]
// CHECK-NEXT:    i32 4, label [[SW_BB]]
// CHECK-NEXT:    i32 5, label [[SW_BB]]
// CHECK-NEXT:    i32 102, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 103, label [[SW_BB2:%.*]]
// CHECK-NEXT:    i32 104, label [[SW_BB2]]
// CHECK-NEXT:    ], !prof !14
// CHECK:       sw.bb:
// CHECK-NEXT:    [[TMP1:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[TMP1]], 1
// CHECK-NEXT:    store volatile i32 [[INC]], ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_BB2]]
// CHECK:       sw.bb2:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughRangeSmallUN() {
  switch (i) {
    case 1 ... 5: ++i;
    case 102:
    [[unlikely]] case 103:
    case 104: break;
  }
}

// CHECK-LABEL: @_Z29CasesFallthroughRangeLargeLLNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_CASERANGE:%.*]] [
// CHECK-NEXT:    i32 1003, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 104, label [[SW_BB1]]
// CHECK-NEXT:    ], !prof !8
// CHECK:       sw.bb:
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_EPILOG:%.*]]
// CHECK:       sw.caserange:
// CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], 0
// CHECK-NEXT:    [[INBOUNDS:%.*]] = icmp ule i32 [[TMP1]], 64
// CHECK-NEXT:    [[INBOUNDS_EXPVAL:%.*]] = call i1 @llvm.expect.i1(i1 [[INBOUNDS]], i1 true)
// CHECK-NEXT:    br i1 [[INBOUNDS_EXPVAL]], label [[SW_BB:%.*]], label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughRangeLargeLLN() {
  switch (i) {
    [[likely]] case 0 ... 64:
    [[likely]] case 1003:
    case 104: break;
  }
}

// CHECK-LABEL: @_Z29CasesFallthroughRangeLargeUUNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_CASERANGE:%.*]] [
// CHECK-NEXT:    i32 1003, label [[SW_BB1:%.*]]
// CHECK-NEXT:    i32 104, label [[SW_BB1]]
// CHECK-NEXT:    ], !prof !9
// CHECK:       sw.bb:
// CHECK-NEXT:    br label [[SW_BB1]]
// CHECK:       sw.bb1:
// CHECK-NEXT:    br label [[SW_EPILOG:%.*]]
// CHECK:       sw.caserange:
// CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], 0
// CHECK-NEXT:    [[INBOUNDS:%.*]] = icmp ule i32 [[TMP1]], 64
// CHECK-NEXT:    [[INBOUNDS_EXPVAL:%.*]] = call i1 @llvm.expect.i1(i1 [[INBOUNDS]], i1 false)
// CHECK-NEXT:    br i1 [[INBOUNDS_EXPVAL]], label [[SW_BB:%.*]], label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void CasesFallthroughRangeLargeUUN() {
  switch (i) {
    [[unlikely]] case 0 ... 64:
    [[unlikely]] case 1003:
    case 104: break;
  }
}

// CHECK-LABEL: @_Z15OneCaseDefaultLv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG:%.*]]
// CHECK-NEXT:    ], !prof !15
// CHECK:       sw.default:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void OneCaseDefaultL() {
  switch (i) {
    case 1: break;
    [[likely]] default: break;
  }
}

// CHECK-LABEL: @_Z15OneCaseDefaultUv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG:%.*]]
// CHECK-NEXT:    ], !prof !16
// CHECK:       sw.default:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void OneCaseDefaultU() {
  switch (i) {
    case 1: break;
    [[unlikely]] default: break;
  }
}

// CHECK-LABEL: @_Z18TwoCasesDefaultLNLv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !17
// CHECK:       sw.default:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesDefaultLNL() {
  switch (i) {
    [[likely]] case 1: break;
    case 2: break;
    [[likely]] default: break;
  }
}

// CHECK-LABEL: @_Z18TwoCasesDefaultLNNv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !8
// CHECK:       sw.default:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesDefaultLNN() {
  switch (i) {
    [[likely]] case 1: break;
    case 2: break;
    default: break;
  }
}

// CHECK-LABEL: @_Z18TwoCasesDefaultLNUv(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[TMP0:%.*]] = load volatile i32, ptr @i, align 4, !tbaa [[TBAA2]]
// CHECK-NEXT:    switch i32 [[TMP0]], label [[SW_DEFAULT:%.*]] [
// CHECK-NEXT:    i32 1, label [[SW_EPILOG:%.*]]
// CHECK-NEXT:    i32 2, label [[SW_EPILOG]]
// CHECK-NEXT:    ], !prof !18
// CHECK:       sw.default:
// CHECK-NEXT:    br label [[SW_EPILOG]]
// CHECK:       sw.epilog:
// CHECK-NEXT:    ret void
//
void TwoCasesDefaultLNU() {
  switch (i) {
    [[likely]] case 1: break;
    case 2: break;
    [[unlikely]] default: break;
  }
}
