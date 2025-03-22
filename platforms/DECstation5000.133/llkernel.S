
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

#define SAVEREG sw
#define LOADREG lw

#define REGISTER_AREA_SIZE 76

#define SAVE_REGISTERS                           \
                SAVEREG $at, 0($sp)             ;\
                SAVEREG $v0, 4($sp)             ;\
                SAVEREG $v1, 8($sp)             ;\
                SAVEREG $a0,12($sp)             ;\
                SAVEREG $a1,16($sp)             ;\
                SAVEREG $a2,20($sp)             ;\
                SAVEREG $a3,24($sp)             ;\
                SAVEREG $t0,28($sp)             ;\
                SAVEREG $t1,32($sp)             ;\
                SAVEREG $t2,36($sp)             ;\
                SAVEREG $t3,40($sp)             ;\
                SAVEREG $t4,44($sp)             ;\
                SAVEREG $t5,48($sp)             ;\
                SAVEREG $t6,52($sp)             ;\
                SAVEREG $t7,56($sp)             ;\
                SAVEREG $t8,60($sp)             ;\
                SAVEREG $t9,64($sp)             ;\
                SAVEREG $gp,68($sp)             ;\
                SAVEREG $ra,72($sp)

#define RESTORE_REGISTERS                        \
                LOADREG $at, 0($sp)             ;\
                LOADREG $v0, 4($sp)             ;\
                LOADREG $v1, 8($sp)             ;\
                LOADREG $a0,12($sp)             ;\
                LOADREG $a1,16($sp)             ;\
                LOADREG $a2,20($sp)             ;\
                LOADREG $a3,24($sp)             ;\
                LOADREG $t0,28($sp)             ;\
                LOADREG $t1,32($sp)             ;\
                LOADREG $t2,36($sp)             ;\
                LOADREG $t3,40($sp)             ;\
                LOADREG $t4,44($sp)             ;\
                LOADREG $t5,48($sp)             ;\
                LOADREG $t6,52($sp)             ;\
                LOADREG $t7,56($sp)             ;\
                LOADREG $t8,60($sp)             ;\
                LOADREG $t9,64($sp)             ;\
                LOADREG $gp,68($sp)             ;\
                LOADREG $ra,72($sp)

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
                subu    $sp,$sp,REGISTER_AREA_SIZE
                SAVE_REGISTERS
                .extern irq_process
                la      $t0,irq_process
                jalr    $t0
                nop
                RESTORE_REGISTERS
                addu    $sp,$sp,REGISTER_AREA_SIZE
                mtc0    $zero,CP0_CAUSE
                nop
                mfc0    $k0,CP0_EPC
                nop
                jr      $k0
                rfe

