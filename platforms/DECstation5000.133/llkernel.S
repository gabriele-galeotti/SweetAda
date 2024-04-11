
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

#define SAVE_REGS                        \
                sw      $at,  0($k1)    ;\
                sw      $v0,  4($k1)    ;\
                sw      $v1,  8($k1)    ;\
                sw      $a0, 12($k1)    ;\
                sw      $a1, 16($k1)    ;\
                sw      $a2, 20($k1)    ;\
                sw      $a3, 24($k1)    ;\
                sw      $t0, 28($k1)    ;\
                sw      $t1, 32($k1)    ;\
                sw      $t2, 36($k1)    ;\
                sw      $t3, 40($k1)    ;\
                sw      $t4, 44($k1)    ;\
                sw      $t5, 48($k1)    ;\
                sw      $t6, 52($k1)    ;\
                sw      $t7, 56($k1)    ;\
                sw      $s0, 60($k1)    ;\
                sw      $s1, 64($k1)    ;\
                sw      $s2, 68($k1)    ;\
                sw      $s3, 72($k1)    ;\
                sw      $s4, 76($k1)    ;\
                sw      $s5, 80($k1)    ;\
                sw      $s6, 84($k1)    ;\
                sw      $s7, 88($k1)    ;\
                sw      $t8, 92($k1)    ;\
                sw      $t9, 96($k1)    ;\
                sw      $gp,100($k1)    ;\
                sw      $sp,104($k1)    ;\
                sw      $fp,108($k1)    ;\
                sw      $ra,112($k1)

#define RESTORE_REGS                     \
                lw      $at,  0($k1)    ;\
                lw      $v0,  4($k1)    ;\
                lw      $v1,  8($k1)    ;\
                lw      $a0, 12($k1)    ;\
                lw      $a1, 16($k1)    ;\
                lw      $a2, 20($k1)    ;\
                lw      $a3, 24($k1)    ;\
                lw      $t0, 28($k1)    ;\
                lw      $t1, 32($k1)    ;\
                lw      $t2, 36($k1)    ;\
                lw      $t3, 40($k1)    ;\
                lw      $t4, 44($k1)    ;\
                lw      $t5, 48($k1)    ;\
                lw      $t6, 52($k1)    ;\
                lw      $t7, 56($k1)    ;\
                lw      $s0, 60($k1)    ;\
                lw      $s1, 64($k1)    ;\
                lw      $s2, 68($k1)    ;\
                lw      $s3, 72($k1)    ;\
                lw      $s4, 76($k1)    ;\
                lw      $s5, 80($k1)    ;\
                lw      $s6, 84($k1)    ;\
                lw      $s7, 88($k1)    ;\
                lw      $t8, 92($k1)    ;\
                lw      $t9, 96($k1)    ;\
                lw      $gp,100($k1)    ;\
                lw      $sp,104($k1)    ;\
                lw      $fp,108($k1)    ;\
                lw      $ra,112($k1)

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
                break   0
                nop
                //
                // Uncached alternative for all other exceptions (used if SR
                // bit BEV set).
                //
                .org    0x0180
                j       irq_handler
                nop

irq_handler:
                la      $k1,savearea
                SAVE_REGS
                .extern irq_process
                la      $t0,irq_process
                jalr    $t0
                nop
                RESTORE_REGS
                mtc0    $0,CP0_CAUSE
                nop
                mfc0    $k0,CP0_EPC
                nop
                jr      $k0
                rfe

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

savearea:       .space  29*4

