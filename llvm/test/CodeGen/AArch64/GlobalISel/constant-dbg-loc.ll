; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple aarch64 -O0 -stop-after=irtranslator -global-isel -verify-machineinstrs %s -o - 2>&1 | FileCheck %s
target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios5.0.0"

@var1 = common global i32 0, align 4, !dbg !0
@var2 = common global i32 0, align 4, !dbg !6

; We check here that the G_GLOBAL_VALUE has a debug loc with line 0.
define i32 @main() #0 !dbg !14 {
  ; CHECK-LABEL: name: main
  ; CHECK: bb.1.entry:
  ; CHECK:   successors: %bb.2(0x40000000), %bb.3(0x40000000)
  ; CHECK:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 0
  ; CHECK:   [[GV:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @var1, debug-location !DILocation(line: 0, scope: !18)
  ; CHECK:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 1, debug-location !DILocation(line: 0, scope: !18)
  ; CHECK:   [[C2:%[0-9]+]]:_(s32) = G_CONSTANT i32 2, debug-location !DILocation(line: 0, scope: !22)
  ; CHECK:   [[GV1:%[0-9]+]]:_(p0) = G_GLOBAL_VALUE @var2, debug-location !DILocation(line: 0, scope: !22)
  ; CHECK:   [[FRAME_INDEX:%[0-9]+]]:_(p0) = G_FRAME_INDEX %stack.0.retval
  ; CHECK:   G_STORE [[C]](s32), [[FRAME_INDEX]](p0) :: (store 4 into %ir.retval)
  ; CHECK:   [[LOAD:%[0-9]+]]:_(s32) = G_LOAD [[GV]](p0), debug-location !17 :: (load 4 from @var1)
  ; CHECK:   [[ICMP:%[0-9]+]]:_(s1) = G_ICMP intpred(eq), [[LOAD]](s32), [[C1]], debug-location !19
  ; CHECK:   G_BRCOND [[ICMP]](s1), %bb.2, debug-location !20
  ; CHECK:   G_BR %bb.3, debug-location !20
  ; CHECK: bb.2.if.then:
  ; CHECK:   successors: %bb.3(0x80000000)
  ; CHECK:   G_STORE [[C2]](s32), [[GV1]](p0), debug-location !21 :: (store 4 into @var2)
  ; CHECK: bb.3.if.end:
  ; CHECK:   $w0 = COPY [[C]](s32), debug-location !24
  ; CHECK:   RET_ReallyLR implicit $w0, debug-location !24
entry:
  %retval = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %0 = load i32, i32* @var1, align 4, !dbg !17
  %cmp = icmp eq i32 %0, 1, !dbg !19
  br i1 %cmp, label %if.then, label %if.end, !dbg !20

if.then:
  store i32 2, i32* @var2, align 4, !dbg !21
  br label %if.end, !dbg !23

if.end:
  ret i32 0, !dbg !24
}

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12}
!llvm.ident = !{!13}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "var1", scope: !2, file: !3, line: 1, type: !8, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5, nameTableKind: GNU)
!3 = !DIFile(filename: "dbg.c", directory: "/")
!4 = !{}
!5 = !{!0, !6}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "var2", scope: !2, file: !3, line: 2, type: !8, isLocal: false, isDefinition: true)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 2, !"Dwarf Version", i32 2}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{!"clang"}
!14 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 3, type: !15, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!15 = !DISubroutineType(types: !16)
!16 = !{!8}
!17 = !DILocation(line: 4, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !14, file: !3, line: 4, column: 7)
!19 = !DILocation(line: 4, column: 12, scope: !18)
!20 = !DILocation(line: 4, column: 7, scope: !14)
!21 = !DILocation(line: 5, column: 10, scope: !22)
!22 = distinct !DILexicalBlock(scope: !18, file: !3, line: 4, column: 18)
!23 = !DILocation(line: 6, column: 3, scope: !22)
!24 = !DILocation(line: 7, column: 3, scope: !14)
