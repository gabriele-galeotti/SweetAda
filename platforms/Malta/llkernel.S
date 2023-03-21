
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
#include <llutils.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVE_REGS                        \
                sw      $k0,0($t0)      ;\
                sw      $v0,4($t0)      ;\
                sw      $v1,8($t0)      ;\
                sw      $a0,12($t0)     ;\
                sw      $a1,16($t0)     ;\
                sw      $a2,20($t0)     ;\
                sw      $a3,24($t0)     ;\
                sw      $k1,28($t0)     ;\
                sw      $t1,32($t0)     ;\
                sw      $t2,36($t0)     ;\
                sw      $t3,40($t0)     ;\
                sw      $t4,44($t0)     ;\
                sw      $t5,48($t0)     ;\
                sw      $t6,52($t0)     ;\
                sw      $t7,56($t0)     ;\
                sw      $t8,60($t0)     ;\
                sw      $t9,64($t0)     ;\
                sw      $gp,68($t0)     ;\
                sw      $sp,72($t0)     ;\
                sw      $fp,76($t0)     ;\
                sw      $ra,80($t0)

#define RESTORE_REGS                     \
                lw      $k0,0($t0)      ;\
                lw      $v0,4($t0)      ;\
                lw      $v1,8($t0)      ;\
                lw      $a0,12($t0)     ;\
                lw      $a1,16($t0)     ;\
                lw      $a2,20($t0)     ;\
                lw      $a3,24($t0)     ;\
                lw      $k1,28($t0)     ;\
                lw      $t1,32($t0)     ;\
                lw      $t2,36($t0)     ;\
                lw      $t3,40($t0)     ;\
                lw      $t4,44($t0)     ;\
                lw      $t5,48($t0)     ;\
                lw      $t6,52($t0)     ;\
                lw      $t7,56($t0)     ;\
                lw      $t8,60($t0)     ;\
                lw      $t9,64($t0)     ;\
                lw      $gp,68($t0)     ;\
                lw      $sp,72($t0)     ;\
                lw      $fp,76($t0)     ;\
                lw      $ra,80($t0)

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global _start
_start:

                .set    noreorder
                //
                // Reset
                // SR:TS = 0
                // SR:BEV = 1
                // SR:ERL = 1 (processor is in Kernel mode)
                // PC = 0xBFC0_0000 (KSEG1, unmapped, uncached)
                //
                .extern _init
                b       _init                   // +0x00
                nop                             // +0x04
                nop                             // +0x08
                nop                             // +0x0C
                nop                             // +0x10 QEMU patches the revision ID here
                //
                // TLB refill.
                //
                .org    0x0200
exception0200:  b       tlbmiss
                nop
                //
                // General exception.
                //
                .org    0x0380
exception0380:  b       irqhandle
                nop
                .set    reorder

tlbmiss:
                .set    noreorder
                mfc0    $k1,CP0_Context
                lw      $k0,0($k1)              // EntryLo0
                lw      $k1,8($k1)              // EntryLo1
                mtc0    $k0,CP0_EntryLo0
                mtc0    $k1,CP0_EntryLo1
                ehb
                tlbwr
                eret
                .set    reorder

irqhandle:
                .set    noreorder
                .set    noat
                move    $k0,$at
                .set    at
                move    $k1,$t0
                la      $t0,savearea
                SAVE_REGS
                .extern exception_process
                la      $t0,exception_process
                jalr    $t0
                nop
                la      $t0,savearea
                RESTORE_REGS
                .set    noat
                move    $at,$k0
                .set    at
                move    $t0,$k1
                // clear CP0_Cause
                mtc0    $0,CP0_Cause
                eret
                .set    reorder

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

savearea:       .space  21*4

