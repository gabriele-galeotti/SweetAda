
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

                .global reset
reset:

                //
                // Reset
                // SR:TS = 0
                // SR:BEV = 1
                // SR:ERL = 1 (processor is in Kernel mode)
                // PC = 0xBFC00000 (KSEG1, unmapped, uncached)
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
                mfc0    $k1,CP0_CONTEXT
                lw      $k0,0($k1)              // EntryLo0
                lw      $k1,8($k1)              // EntryLo1
                mtc0    $k0,CP0_ENTRYLO0
                mtc0    $k1,CP0_ENTRYLO1
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
                mtc0    $0,CP0_CAUSE
                eret

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .p2align 3
savearea:       .space  80

