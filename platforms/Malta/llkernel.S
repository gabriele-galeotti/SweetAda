
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

                .sect   .vectors,"ax"

                .set    noreorder

                .global _start
_start:

                //
                // SR:TS = 0
                // SR:BEV = 1
                // SR:ERL = 1 (processor is in Kernel mode)
                // PC = 0xBFC0_0000 (VA), PA = 0xBFC0_00000 & 0x1FFF_FFFF = 0x1FC0_0000 (KSEG1, unmapped, uncached)
                //
                .extern _init
                b       _init                   // +0x00
                nop                             // +0x04
                nop                             // +0x08
                nop                             // +0x0C
                nop                             // +0x10 QEMU here patches the revision ID
                .set    reorder

////////////////////////////////////////////////////////////////////////////////

                .extern exception_process

                //
                // TLB refill.
                //
                .org    0x0200

                //
                // General exception.
                //
                .org    0x0380
                // interrupts may be generated during the use of at register,
                // we have to save it
                .set    noat
                move    $k1,$at
                .set    at
                // temporary registers; not preserved across function calls
                sw      $k1,saveat
                sw      $v0,savev0
                sw      $v1,savev1
                sw      $a0,savea0
                sw      $a1,savea1
                sw      $a2,savea2
                sw      $a3,savea3
                sw      $t0,savet0
                sw      $t1,savet1
                sw      $t2,savet2
                sw      $t3,savet3
                sw      $t4,savet4
                sw      $t5,savet5
                sw      $t6,savet6
                sw      $t7,savet7
                sw      $t8,savet8
                sw      $t9,savet9
                sw      $gp,savegp
                sw      $sp,savesp
                sw      $s8,saves8
                sw      $fp,savefp
                sw      $ra,savera
                // high-level management
                la      $k0,exception_process
                jalr    $k0
                nop
                lw      $k1,saveat
                lw      $v0,savev0
                lw      $v1,savev1
                lw      $a0,savea0
                lw      $a1,savea1
                lw      $a2,savea2
                lw      $a3,savea3
                lw      $t0,savet0
                lw      $t1,savet1
                lw      $t2,savet2
                lw      $t3,savet3
                lw      $t4,savet4
                lw      $t5,savet5
                lw      $t6,savet6
                lw      $t7,savet7
                lw      $t8,savet8
                lw      $t9,savet9
                lw      $gp,savegp
                lw      $sp,savesp
                lw      $s8,saves8
                lw      $fp,savefp
                lw      $ra,savera
                .set    noat
                move    $at,$k1
                .set    at
                // load return address
                mfc0    $k0,$14
                nop
                // clear CP0_Cause
                //mtc0    $0,CP0_Cause
                //nop
                eret
                nop

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

saveat:         .long 0
savev0:         .long 0
savev1:         .long 0
savea0:         .long 0
savea1:         .long 0
savea2:         .long 0
savea3:         .long 0
savet0:         .long 0
savet1:         .long 0
savet2:         .long 0
savet3:         .long 0
savet4:         .long 0
savet5:         .long 0
savet6:         .long 0
savet7:         .long 0
savet8:         .long 0
savet9:         .long 0
savegp:         .long 0
savesp:         .long 0
saves8:         .long 0
savefp:         .long 0
savera:         .long 0

