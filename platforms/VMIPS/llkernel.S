
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVEREG sw
#define LOADREG lw

#define SAVE_REGS                        \
                SAVEREG $at, 0($k1)     ;\
                SAVEREG $v0, 4($k1)     ;\
                SAVEREG $v1, 8($k1)     ;\
                SAVEREG $a0,12($k1)     ;\
                SAVEREG $a1,16($k1)     ;\
                SAVEREG $a2,20($k1)     ;\
                SAVEREG $a3,24($k1)     ;\
                SAVEREG $t0,28($k1)     ;\
                SAVEREG $t1,32($k1)     ;\
                SAVEREG $t2,36($k1)     ;\
                SAVEREG $t3,40($k1)     ;\
                SAVEREG $t4,44($k1)     ;\
                SAVEREG $t5,48($k1)     ;\
                SAVEREG $t6,52($k1)     ;\
                SAVEREG $t7,56($k1)     ;\
                SAVEREG $t8,60($k1)     ;\
                SAVEREG $t9,64($k1)     ;\
                SAVEREG $gp,68($k1)     ;\
                SAVEREG $sp,72($k1)     ;\
                SAVEREG $ra,76($k1)

#define RESTORE_REGS                     \
                LOADREG $at, 0($k1)     ;\
                LOADREG $v0, 4($k1)     ;\
                LOADREG $v1, 8($k1)     ;\
                LOADREG $a0,12($k1)     ;\
                LOADREG $a1,16($k1)     ;\
                LOADREG $a2,20($k1)     ;\
                LOADREG $a3,24($k1)     ;\
                LOADREG $t0,28($k1)     ;\
                LOADREG $t1,32($k1)     ;\
                LOADREG $t2,36($k1)     ;\
                LOADREG $t3,40($k1)     ;\
                LOADREG $t4,44($k1)     ;\
                LOADREG $t5,48($k1)     ;\
                LOADREG $t6,52($k1)     ;\
                LOADREG $t7,56($k1)     ;\
                LOADREG $t8,60($k1)     ;\
                LOADREG $t9,64($k1)     ;\
                LOADREG $gp,68($k1)     ;\
                LOADREG $sp,72($k1)     ;\
                LOADREG $ra,76($k1)

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .set    noreorder
                .set    noat

                .global vectors
vectors:

                //
                // The "reset exception".
                //
                .org    0
                .extern _start
                j       _start
                nop
                //
                // Uncached alternative kuseg TLB miss entry point (used if SR
                // bit BEV set).
                //
                .org    0x0100
                break
                //
                // Uncached alternative for all other exceptions (used if SR
                // bit BEV set).
                //
                .org    0x0180
                j       exc_handler
                nop

exc_handler:
                la      $k1,savearea
                SAVE_REGS
                .extern irq_process
                la      $t0,irq_process
                jalr    $t0
                nop
                RESTORE_REGS
                mtc0    $0,C0_CAUSE
                nop
                mfc0    $k0,C0_EPC
                nop
                rfe
                jr      $k0

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .p2align 3
savearea:       .space  80

