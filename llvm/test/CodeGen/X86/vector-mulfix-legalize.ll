; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O1 -mtriple=x86_64-unknown-unknown -o - | FileCheck %s

; We used to assert on widening the SMULFIX/UMULFIX/SMULFIXSAT node result,
; so primiary goal with the test is to see that we support legalization for
; such vectors.

declare <4 x i16> @llvm.smul.fix.v4i16(<4 x i16>, <4 x i16>, i32 immarg)
declare <4 x i16> @llvm.umul.fix.v4i16(<4 x i16>, <4 x i16>, i32 immarg)
declare <4 x i16> @llvm.smul.fix.sat.v4i16(<4 x i16>, <4 x i16>, i32 immarg)

define <4 x i16> @smulfix(<4 x i16> %a) {
; CHECK-LABEL: smulfix:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa {{.*#+}} xmm1 = <1,2,3,4,u,u,u,u>
; CHECK-NEXT:    movdqa %xmm0, %xmm2
; CHECK-NEXT:    pmullw %xmm1, %xmm2
; CHECK-NEXT:    psrlw $15, %xmm2
; CHECK-NEXT:    pmulhw %xmm1, %xmm0
; CHECK-NEXT:    psllw $1, %xmm0
; CHECK-NEXT:    por %xmm2, %xmm0
; CHECK-NEXT:    retq
  %t = call <4 x i16> @llvm.smul.fix.v4i16(<4 x i16> <i16 1, i16 2, i16 3, i16 4>, <4 x i16> %a, i32 15)
  ret <4 x i16> %t
}

define <4 x i16> @umulfix(<4 x i16> %a) {
; CHECK-LABEL: umulfix:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa {{.*#+}} xmm1 = <1,2,3,4,u,u,u,u>
; CHECK-NEXT:    movdqa %xmm0, %xmm2
; CHECK-NEXT:    pmullw %xmm1, %xmm2
; CHECK-NEXT:    psrlw $15, %xmm2
; CHECK-NEXT:    pmulhuw %xmm1, %xmm0
; CHECK-NEXT:    psllw $1, %xmm0
; CHECK-NEXT:    por %xmm2, %xmm0
; CHECK-NEXT:    retq
  %t = call <4 x i16> @llvm.umul.fix.v4i16(<4 x i16> <i16 1, i16 2, i16 3, i16 4>, <4 x i16> %a, i32 15)
  ret <4 x i16> %t
}

define <4 x i16> @smulfixsat(<4 x i16> %a) {
; CHECK-LABEL: smulfixsat:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movdqa %xmm0, %xmm1
; CHECK-NEXT:    pextrw $1, %xmm0, %eax
; CHECK-NEXT:    cwtl
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    shrl $15, %ecx
; CHECK-NEXT:    leal (%rax,%rax), %edx
; CHECK-NEXT:    shrdw $15, %cx, %dx
; CHECK-NEXT:    sarl $15, %eax
; CHECK-NEXT:    cmpl $16383, %eax # imm = 0x3FFF
; CHECK-NEXT:    movl $32767, %ecx # imm = 0x7FFF
; CHECK-NEXT:    cmovgl %ecx, %edx
; CHECK-NEXT:    cmpl $-16384, %eax # imm = 0xC000
; CHECK-NEXT:    movl $32768, %eax # imm = 0x8000
; CHECK-NEXT:    cmovll %eax, %edx
; CHECK-NEXT:    movd %edx, %xmm2
; CHECK-NEXT:    movd %xmm0, %edx
; CHECK-NEXT:    movswl %dx, %edx
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    shrl $16, %esi
; CHECK-NEXT:    shldw $1, %dx, %si
; CHECK-NEXT:    sarl $16, %edx
; CHECK-NEXT:    cmpl $16383, %edx # imm = 0x3FFF
; CHECK-NEXT:    cmovgl %ecx, %esi
; CHECK-NEXT:    cmpl $-16384, %edx # imm = 0xC000
; CHECK-NEXT:    cmovll %eax, %esi
; CHECK-NEXT:    movd %esi, %xmm0
; CHECK-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; CHECK-NEXT:    pextrw $2, %xmm1, %edx
; CHECK-NEXT:    movswl %dx, %edx
; CHECK-NEXT:    leal (%rdx,%rdx,2), %edx
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    shrl $16, %esi
; CHECK-NEXT:    shldw $1, %dx, %si
; CHECK-NEXT:    sarl $16, %edx
; CHECK-NEXT:    cmpl $16383, %edx # imm = 0x3FFF
; CHECK-NEXT:    cmovgl %ecx, %esi
; CHECK-NEXT:    cmpl $-16384, %edx # imm = 0xC000
; CHECK-NEXT:    cmovll %eax, %esi
; CHECK-NEXT:    movd %esi, %xmm2
; CHECK-NEXT:    pextrw $3, %xmm1, %edx
; CHECK-NEXT:    movswl %dx, %edx
; CHECK-NEXT:    movl %edx, %esi
; CHECK-NEXT:    shrl $14, %esi
; CHECK-NEXT:    leal (,%rdx,4), %edi
; CHECK-NEXT:    shrdw $15, %si, %di
; CHECK-NEXT:    sarl $14, %edx
; CHECK-NEXT:    cmpl $16383, %edx # imm = 0x3FFF
; CHECK-NEXT:    cmovgl %ecx, %edi
; CHECK-NEXT:    cmpl $-16384, %edx # imm = 0xC000
; CHECK-NEXT:    cmovll %eax, %edi
; CHECK-NEXT:    movd %edi, %xmm1
; CHECK-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    shrdw $15, %dx, %dx
; CHECK-NEXT:    movl $16383, %esi # imm = 0x3FFF
; CHECK-NEXT:    negl %esi
; CHECK-NEXT:    cmovgl %ecx, %edx
; CHECK-NEXT:    movl $-16384, %ecx # imm = 0xC000
; CHECK-NEXT:    negl %ecx
; CHECK-NEXT:    cmovll %eax, %edx
; CHECK-NEXT:    movd %edx, %xmm1
; CHECK-NEXT:    punpcklwd {{.*#+}} xmm1 = xmm1[0,0,1,1,2,2,3,3]
; CHECK-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0,0,1,1]
; CHECK-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; CHECK-NEXT:    retq
  %t = call <4 x i16> @llvm.smul.fix.sat.v4i16(<4 x i16> <i16 1, i16 2, i16 3, i16 4>, <4 x i16> %a, i32 15)
  ret <4 x i16> %t
}


