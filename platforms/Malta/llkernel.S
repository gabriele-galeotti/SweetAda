
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
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

                .global _reset
_reset:

                //
                // Reset
                // SR:TS = 0
                // SR:BEV = 1
                // SR:ERL = 1 (processor is in Kernel mode)
                // PC = 0xBFC0_0000 (KSEG1, unmapped, uncached)
                //
                .org    0
                .extern _start
                j       _start                  // +0x00
                nop                             // +0x04
                nop                             // +0x08
                nop                             // +0x0C
                nop                             // +0x10 QEMU patches the revision ID here

                //
                // TLB refill.
                //
                .org    0x0200
exception0200:  j       tlbmiss
                nop

                //
                // General exception.
                //
                .org    0x0380
exception0380:  j       irqhandle
                nop

tlbmiss:
                mfc0    $k1,C0_CONTEXT
                lw      $k0,0($k1)              // EntryLo0
                lw      $k1,8($k1)              // EntryLo1
                mtc0    $k0,C0_ENTRYLO0
                mtc0    $k1,C0_ENTRYLO1
                ehb
                tlbwr
                eret

irqhandle:
                la      $k1,savearea
                SAVE_REGS
                .extern exception_process
                la      $t0,exception_process
                jalr    $t0
                nop
                RESTORE_REGS
                mtc0    $0,C0_CAUSE
                eret

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

savearea:       .space  29*4

