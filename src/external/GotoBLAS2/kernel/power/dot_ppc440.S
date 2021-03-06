/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"
	
#define N	r3
#define X	r4
#define INCX	r5
#define Y	r6
#define INCY	r7
#define PRE	r8

#define FZERO	f0

#define STACKSIZE 96

	PROLOGUE
	PROFCODE

	addi	SP, SP, -STACKSIZE
	li	r0,   0

	stfd	f14,    0(SP)
	stfd	f15,    8(SP)
	stfd	f16,   16(SP)
	stfd	f17,   24(SP)

	stfd	f18,   32(SP)
	stfd	f19,   40(SP)
	stfd	f20,   48(SP)
	stfd	f21,   56(SP)

	stfd	f22,   64(SP)
	stfd	f23,   72(SP)

	stw	r0,    80(SP)
	lfs	FZERO, 80(SP)

#ifdef F_INTERFACE
	LDINT	N,    0(N)
	LDINT	INCX, 0(INCX)
	LDINT	INCY, 0(INCY)
#endif

	slwi	INCX, INCX, BASE_SHIFT
	slwi	INCY, INCY, BASE_SHIFT

	fmr	f1,  FZERO
	fmr	f2,  FZERO
	fmr	f3,  FZERO
	fmr	f4,  FZERO
	fmr	f5,  FZERO
	fmr	f6,  FZERO
	fmr	f7,  FZERO

	li	PRE, 3 * 16 * SIZE

	cmpwi	cr0, N, 0
	ble-	LL(999)

#ifdef F_INTERFACE
	cmpwi	cr0, INCX, 0
	bge+	LL(102)

	subi	r0, N, 1
	mullw	r0, r0, INCX
	sub	X, X, r0
	.align 4

LL(102):
	cmpwi	cr0, INCY, 0
	bge+	LL(104)

	subi	r0, N, 1
	mullw	r0, r0, INCY
	sub	Y, Y, r0
	.align 4

LL(104):
#endif
	sub	X, X, INCX
	sub	Y, Y, INCY

	srawi.	r0, N, 4
	mtspr	CTR,  r0
	beq-	LL(150)

	LFDUX	f8,    X, INCX
	LFDUX	f16,   Y, INCY
	LFDUX	f9,    X, INCX
	LFDUX	f17,   Y, INCY

	LFDUX	f10,   X, INCX
	LFDUX	f18,   Y, INCY
	LFDUX	f11,   X, INCX
	LFDUX	f19,   Y, INCY

	LFDUX	f12,   X, INCX
	LFDUX	f20,   Y, INCY
	LFDUX	f13,   X, INCX
	LFDUX	f21,   Y, INCY

	LFDUX	f14,   X, INCX
	LFDUX	f22,   Y, INCY
	LFDUX	f15,   X, INCX
	LFDUX	f23,   Y, INCY
	bdz	LL(120)
	.align 4

LL(110):
	FMADD	f0,  f8,  f16, f0
	LFDUX	f8,    X, INCX
	LFDUX	f16,   Y, INCY
#ifdef PPCG4
	dcbt	X, PRE
#endif
	FMADD	f1,  f9,  f17, f1
	LFDUX	f9,    X, INCX
	LFDUX	f17,   Y, INCY
	FMADD	f2,  f10, f18, f2
	LFDUX	f10,   X, INCX
	LFDUX	f18,   Y, INCY
#ifdef PPCG4
	dcbt	Y, PRE
#endif
	FMADD	f3,  f11, f19, f3
	LFDUX	f11,   X, INCX
	LFDUX	f19,   Y, INCY

	FMADD	f4,  f12, f20, f4
	LFDUX	f12,   X, INCX
	LFDUX	f20,   Y, INCY
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	X, PRE
#endif
	FMADD	f5,  f13, f21, f5
	LFDUX	f13,   X, INCX
	LFDUX	f21,   Y, INCY
	FMADD	f6,  f14, f22, f6
	LFDUX	f14,   X, INCX
	LFDUX	f22,   Y, INCY
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	Y, PRE
#endif
	FMADD	f7,  f15, f23, f7
	LFDUX	f15,   X, INCX
	LFDUX	f23,   Y, INCY

	FMADD	f0,  f8,  f16, f0
	LFDUX	f8,    X, INCX
	LFDUX	f16,   Y, INCY
#ifdef PPCG4
	dcbt	X, PRE
#endif
	FMADD	f1,  f9,  f17, f1
	LFDUX	f9,    X, INCX
	LFDUX	f17,   Y, INCY
	FMADD	f2,  f10, f18, f2
	LFDUX	f10,   X, INCX
	LFDUX	f18,   Y, INCY
#ifdef PPCG4
	dcbt	Y, PRE
#endif
	FMADD	f3,  f11, f19, f3
	LFDUX	f11,   X, INCX
	LFDUX	f19,   Y, INCY

	FMADD	f4,  f12, f20, f4
	LFDUX	f12,   X, INCX
	LFDUX	f20,   Y, INCY
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	X, PRE
#endif
	FMADD	f5,  f13, f21, f5
	LFDUX	f13,   X, INCX
	LFDUX	f21,   Y, INCY
	FMADD	f6,  f14, f22, f6
	LFDUX	f14,   X, INCX
	LFDUX	f22,   Y, INCY
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	Y, PRE
#endif
	FMADD	f7,  f15, f23, f7
	LFDUX	f15,   X, INCX
	LFDUX	f23,   Y, INCY
	bdnz	LL(110)
	.align 4

LL(120):
	FMADD	f0,  f8,  f16, f0
	LFDUX	f8,    X, INCX
	LFDUX	f16,   Y, INCY
	FMADD	f1,  f9,  f17, f1
	LFDUX	f9,    X, INCX
	LFDUX	f17,   Y, INCY
	FMADD	f2,  f10, f18, f2
	LFDUX	f10,   X, INCX
	LFDUX	f18,   Y, INCY
	FMADD	f3,  f11, f19, f3
	LFDUX	f11,   X, INCX
	LFDUX	f19,   Y, INCY

	FMADD	f4,  f12, f20, f4
	LFDUX	f12,   X, INCX
	LFDUX	f20,   Y, INCY
	FMADD	f5,  f13, f21, f5
	LFDUX	f13,   X, INCX
	LFDUX	f21,   Y, INCY
	FMADD	f6,  f14, f22, f6
	LFDUX	f14,   X, INCX
	LFDUX	f22,   Y, INCY
	FMADD	f7,  f15, f23, f7
	LFDUX	f15,   X, INCX
	LFDUX	f23,   Y, INCY

	FMADD	f0,  f8,  f16, f0
	FMADD	f1,  f9,  f17, f1
	FMADD	f2,  f10, f18, f2
	FMADD	f3,  f11, f19, f3
	FMADD	f4,  f12, f20, f4
	FMADD	f5,  f13, f21, f5
	FMADD	f6,  f14, f22, f6
	FMADD	f7,  f15, f23, f7
	.align 4

LL(150):
	andi.	r0,  N, 15
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(160):
	LFDUX	f8,    X, INCX
	LFDUX	f16,   Y, INCY
	FMADD	f0,  f8,  f16, f0
	bdnz	LL(160)
	.align 4

LL(999):
	FADD	f0,  f0,  f1
	FADD	f2,  f2,  f3
	FADD	f4,  f4,  f5
	FADD	f6,  f6,  f7

	FADD	f0,  f0,  f2
	FADD	f4,  f4,  f6
	FADD	f1,  f0,  f4

	lfd	f14,    0(SP)
	lfd	f15,    8(SP)
	lfd	f16,   16(SP)
	lfd	f17,   24(SP)

	lfd	f18,   32(SP)
	lfd	f19,   40(SP)
	lfd	f20,   48(SP)
	lfd	f21,   56(SP)

	lfd	f22,   64(SP)
	lfd	f23,   72(SP)

	addi	SP, SP, STACKSIZE
	blr

	EPILOGUE
