
/*
 * ppc405ep.h - PowerPC 405EP architecture definitions.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _PPC405EP_H
#define _PPC405EP_H 1

/*
 * SPRs
 */
#define SGR   0x3B9 /* Storage Guarded Register */
#define DCWR  0x3BA /* Data Cache Write-through Register */
#define SLER  0x3BB /* Storage Little Endian Register */
#define EVPR  0x3D6 /* Exception Vector Prefix Register */
#define TSR   0x3D8 /* Timer Status Register */
#define TCR   0x3DA /* Timer Control Register */
#define PIT   0x3DB /* Programmable Interval Timer */
#define DBCR0 0x3F2 /* Debug Control Register 0 */
#define DCCR  0x3FA /* Data Cache Cachability Register */
#define ICCR  0x3FB /* Instruction Cache Cachability Register (ICCR) */

/*
 * DCRs
 */
#define CPC0_PLLMR0 0x0F0 /* R/W PLL Mode Register 0 */
#define CPC0_PLLMR1 0x0F4 /* R/W PLL Mode Register 1 */

/*
 * UIC - Universal Interrupt Controller
 */
#define UIC0_SR  0x0C0  /* UIC Status Register */
#define  U0IS (1 << 31) /* UART0 Interrupt Status */
#define UIC0_ER  0x0C2  /* UIC Enable Register */
#define UIC0_CR  0x0C3  /* UIC Critical Register */
#define UIC0_PR  0x0C4  /* UIC Polarity Register */
#define UIC0_TR  0x0C5  /* UIC Trigger Register */
#define UIC0_MSR 0x0C6  /* UIC Masked Status Register */
#define UIC0_VR  0x0C7  /* UIC Vector Register */
#define UIC0_VCR 0x0C8  /* UIC Vector Configuration Register */

#endif /* _PPC405EP_H */

