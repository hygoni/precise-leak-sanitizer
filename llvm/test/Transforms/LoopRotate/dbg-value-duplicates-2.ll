; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=loop-rotate -S | FileCheck %s

define dso_local i16 @main() local_unnamed_addr #0 !dbg !7 {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i16 9, metadata !12, metadata !DIExpression()), !dbg !13
; CHECK-NEXT:    br label [[BB2:%.*]], !dbg !14
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i16 [ 9, [[ENTRY:%.*]] ], [ [[TMP5:%.*]], [[BB2]] ]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i16 [[TMP1]], metadata !12, metadata !DIExpression()), !dbg !13
; CHECK-NEXT:    [[TMP4:%.*]] = call i16 @wibble(i16 [[TMP1]]), !dbg !14
; CHECK-NEXT:    [[TMP5]] = add nsw i16 [[TMP4]], [[TMP1]], !dbg !14
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i16 [[TMP5]], metadata !12, metadata !DIExpression()), !dbg !13
; CHECK-NEXT:    [[TMP6:%.*]] = call i16 @wibble(i16 [[TMP4]]), !dbg !14
; CHECK-NEXT:    [[TMP7:%.*]] = mul nsw i16 [[TMP6]], 3, !dbg !14
; CHECK-NEXT:    [[TMP8:%.*]] = call i16 @wibble(i16 [[TMP7]]), !dbg !14
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i16 [[TMP5]], 17, !dbg !14
; CHECK-NEXT:    br i1 [[TMP2]], label [[BB2]], label [[BB3:%.*]], !dbg !14
; CHECK:       bb3:
; CHECK-NEXT:    [[TMP10:%.*]] = call i16 @wibble(i16 8), !dbg !14
; CHECK-NEXT:    ret i16 [[TMP10]], !dbg !14
;
entry:
  call void @llvm.dbg.value(metadata i16 9, metadata !12, metadata !DIExpression()), !dbg !13
  br label %bb1, !dbg !14

bb1:
  %tmp = phi i16 [ 9, %entry ], [ %tmp5, %bb2 ], !dbg !13
  call void @llvm.dbg.value(metadata i16 %tmp, metadata !12, metadata !DIExpression()), !dbg !13
  %tmp2 = icmp slt i16 %tmp, 17, !dbg !16
  br i1 %tmp2, label %bb2, label %bb3, !dbg !16

bb2:
  %tmp4 = call i16 @wibble(i16 %tmp), !dbg !16
  %tmp5 = add nsw i16 %tmp4, %tmp, !dbg !16
  call void @llvm.dbg.value(metadata i16 %tmp5, metadata !12, metadata !DIExpression()), !dbg !13
  %tmp6 = call i16 @wibble(i16 %tmp4), !dbg !16
  %tmp7 = mul nsw i16 %tmp6, 3, !dbg !16
  %tmp8 = call i16 @wibble(i16 %tmp7), !dbg !16
  br label %bb1, !dbg !16

bb3:
  %tmp10 = call i16 @wibble(i16 8), !dbg !16
  ret i16 %tmp10, !dbg !16
}

declare void @llvm.dbg.value(metadata, metadata, metadata) #1

declare i16 @wibble(i16) #2

attributes #0 = { noinline nounwind }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { noinline nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, globals: !2, nameTableKind: None)
!1 = !DIFile(filename: "foo.c", directory: "")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 1}
!6 = !{!"clang version 10.0.0"}
!7 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 8, type: !8, scopeLine: 8, flags: DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !11)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 16, encoding: DW_ATE_signed)
!11 = !{!12}
!12 = !DILocalVariable(name: "x", scope: !7, file: !1, line: 9, type: !10)
!13 = !DILocation(line: 0, scope: !7)
!14 = !DILocation(line: 11, column: 8, scope: !15)
!15 = distinct !DILexicalBlock(scope: !7, file: !1, line: 11, column: 3)
!16 = !DILocation(line: 11, column: 21, scope: !17)
!17 = distinct !DILexicalBlock(scope: !15, file: !1, line: 11, column: 3)
