
/*
 * ppc405ep.h - PowerPC 405EP architecture definitions.
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _PPC405EP_H
#define _PPC405EP_H 1

/* MSR */
#define DR (1 << 4)                     /* MSR Data Relocate */
#define IR (1 << 5)                     /* MSR Instruction Relocate */
#define EE (1 << 15)                    /* MSR enable interrupts */

#define LR              0x008           /* Link Register */
#define CPC0_PLLMR0     0x0F0           /* R/W PLL Mode Register 0 */
#define CPC0_PLLMR1     0x0F4           /* R/W PLL Mode Register 1 */
#define TBL             0x11C           /* Time Base Lower */
#define TBU             0x11D           /* Time Base Upper */
#define PVR             0x11F           /* Processor Version Register */
#define CCR0            0x3B3           /* Core Configuration Register 0 */
#define SGR             0x3B9           /* Storage Guarded Register */
#define DCWR            0x3BA           /* Data Cache Write-through Register */
#define SLER            0x3BB           /* Storage Little Endian Register */
#define ESR             0x3D4           /* Exception Syndrome Register */
#define DEAR            0x3D5           /* Data Exception Address Register */
#define EVPR            0x3D6           /* Exception Vector Prefix Register */
#define TSR             0x3D8           /* Timer Status Register */
#define  PIS            (1 << 27)       /* PIT Interrupt Status */
#define  FIS            (1 << 26)       /* FIT Interrupt Status */
#define TCR             0x3DA           /* Timer Control Register */
#define  PIE            (1 << 26)       /* PIT Interrupt Enable */
#define  FIT_PERIOD_1   0               /* 2^9 clocks, 2.56 us @ 200 MHz */
#define  FIT_PERIOD_2   (1 << 24)       /* 2^13 clocks, 40.96 us @ 200 MHz */
#define  FIT_PERIOD_3   (2 << 24)       /* 2^17 clocks, 0.655 ms @ 200 MHz */
#define  FIT_PERIOD_4   (3 << 24)       /* 2^21 clocks, 10.49 ms @ 200 MHz */
#define  FIE            (1 << 23)       /* FIT Interrupt Enable */
#define  ARE            (1 << 22)       /* PIT Auto Reload Enable */
#define PIT             0x3DB           /* Programmable Interval Timer */
#define DBCR0           0x3F2           /* Debug Control Register 0 */
#define DCCR            0x3FA           /* Data Cache Cachability Register */
#define ICCR            0x3FB           /* Instruction Cache Cachability Register (ICCR) */

/*
 * UIC - Universal Interrupt Controller
 * 10.5 UIC Registers
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

/*
 * Instructions.
 */
#define NOP_INSTRUCTION             0x60000000
#define BREAKPOINT_INSTRUCTION      0x7D821008
#define BREAKPOINT_INSTRUCTION_SIZE 4

#endif /* _PPC405EP_H */

