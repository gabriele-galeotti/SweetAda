
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sh.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global vector_table
vector_table:

                .extern _start
                .long   _start          //   0 Power-on reset PC
                .long   0               //   1 Power-on reset SP
                .long   _start          //   2 Manual reset PC
                .long   0               //   3 Manual reset SP
                .long   0               //   4 General illegal instruction
                .long   0               //   5 (Reserved for system use)
                .long   0               //   6 Illegal slot instruction
                .long   0               //   7 (Reserved for system use)
                .long   0               //   8 ''
                .long   0               //   9 CPU address error
                .long   0               //  10 DMA address error
                .long   0               //  11 NMI
                .long   0               //  12 User break
                .long   0               //  13 (Reserved for system use)
                .long   0               //  14 ''
                .long   0               //  15 ''
                .long   0               //  16 ''
                .long   0               //  17 ''
                .long   0               //  18 ''
                .long   0               //  19 ''
                .long   0               //  20 ''
                .long   0               //  21 ''
                .long   0               //  22 ''
                .long   0               //  23 ''
                .long   0               //  24 ''
                .long   0               //  25 ''
                .long   0               //  26 ''
                .long   0               //  27 ''
                .long   0               //  28 ''
                .long   0               //  29 ''
                .long   0               //  30 ''
                .long   0               //  31 ''
                .long   0               //  32 Trap instruction (user vectors)
                .long   0               //  33 ''
                .long   0               //  34 ''
                .long   0               //  35 ''
                .long   0               //  36 ''
                .long   0               //  37 ''
                .long   0               //  38 ''
                .long   0               //  39 ''
                .long   0               //  40 ''
                .long   0               //  41 ''
                .long   0               //  42 ''
                .long   0               //  43 ''
                .long   0               //  44 ''
                .long   0               //  45 ''
                .long   0               //  46 ''
                .long   0               //  47 ''
                .long   0               //  48 ''
                .long   0               //  49 ''
                .long   0               //  50 ''
                .long   0               //  51 ''
                .long   0               //  52 ''
                .long   0               //  53 ''
                .long   0               //  54 ''
                .long   0               //  55 ''
                .long   0               //  56 ''
                .long   0               //  57 ''
                .long   0               //  58 ''
                .long   0               //  59 ''
                .long   0               //  60 ''
                .long   0               //  61 ''
                .long   0               //  62 ''
                .long   0               //  63 ''
                .long   0               //  64 IRQ0
                .long   0               //  65 IRQ1
                .long   0               //  66 IRQ2
                .long   0               //  67 IRQ3
                .long   0               //  68 IRQ4
                .long   0               //  69 IRQ5
                .long   0               //  70 IRQ6
                .long   0               //  71 IRQ7
                .long   0               //  72 DMAC0 DEI0
                .long   0               //  73 Reserved
                .long   0               //  74 DMAC1 DEI1
                .long   0               //  75 Reserved
                .long   0               //  76 DMAC2 DEI2
                .long   0               //  77 Reserved
                .long   0               //  78 DMAC3 DEI3
                .long   0               //  79 Reserved
                .long   0               //  80 ITU0 IMIA0
                .long   0               //  81 ITU0 IMIB0
                .long   0               //  82 ITU0 OVI0
                .long   0               //  83 Reserved
                .long   0               //  84 ITU1 IMIA1
                .long   0               //  85 ITU1 IMIB1
                .long   0               //  86 ITU1 OVI1
                .long   0               //  87 Reserved
                .long   irq_itu2_imia2  //  88 ITU2 IMIA2
                .long   0               //  89 ITU2 IMIB2
                .long   0               //  90 ITU2 OVI2
                .long   0               //  91 Reserved
                .long   0               //  92 ITU3 IMIA3
                .long   0               //  93 ITU3 IMIB3
                .long   0               //  94 ITU3 OVI3
                .long   0               //  95 Reserved
                .long   0               //  96 ITU4 IMIA4
                .long   0               //  97 ITU4 IMIB4
                .long   0               //  98 ITU4 OVI4
                .long   0               //  99 Reserved
                .long   0               // 100 SCI0 ERI0
                .long   0               // 101 SCI0 RxI0
                .long   0               // 102 SCI0 TxI0
                .long   0               // 103 SCI0 TEI0
                .long   0               // 104 SCI1 ERI1
                .long   0               // 105 SCI1 RxI1
                .long   0               // 106 SCI1 TxI1
                .long   0               // 107 SCI1 TEI1
                .long   0               // 108 PRT PEI
                .long   0               // 109 A/D ITI
                .long   0               // 110 Reserved
                .long   0               // 111 Reserved
                .long   0               // 112 WDT ITI
                .long   0               // 113 REF CMI
                .long   0               // 114 Reserved
                .long   0               // 115 Reserved
                .space  140*4           // 116 .. 255

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

irq_itu2_imia2:
                mov.l   r0,@-r15
                mov.l   r1,@-r15
                mov.l   r2,@-r15
                mov.l   r3,@-r15
                mov.l   r4,@-r15
                mov.l   r5,@-r15
                mov.l   r6,@-r15
                mov.l   r7,@-r15
                sts.l   pr,@-r15
                mov.l   REF(irq_timer_process),r0
                jsr     @r0
                nop
                lds.l   @r15+,pr
                mov.l   @r15+,r7
                mov.l   @r15+,r6
                mov.l   @r15+,r5
                mov.l   @r15+,r4
                mov.l   @r15+,r3
                mov.l   @r15+,r2
                mov.l   @r15+,r1
                mov.l   @r15+,r0
                rte
                nop

DEF_EREFL(irq_timer_process)

