
//
// startup.S - MIPS R4300 startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .set    noreorder
                .set    noat

                .global _start
_start:

                //
                // Initialize essential CP0 registers.
                //
                mtc0    $0,C0_CAUSE
                nop
                mtc0    $0,C0_WATCHLO
                nop
                mtc0    $0,C0_WATCHHI
                nop

                //
                // Static data relocation.
                //
                .extern _sdata
                .extern _edata
                .extern _etext
                lui     $t0,%hi(_sdata)
                ori     $t0,%lo(_sdata)
                lui     $t1,%hi(_edata)
                ori     $t1,%lo(_edata)
                lui     $t2,%hi(_etext)
                ori     $t2,%lo(_etext)
1:              lb      $t3,0($t2)
                nop                             // load delay slot
                sb      $t3,0($t0)
                addiu   $t0,$t0,1
                addiu   $t2,$t2,1
                bne     $t0,$t1,1b
                nop

                //
                // Setup stack pointer.
                //
                la      $sp,kernel_stack

                //
                // Setup global pointer.
                //
                .extern _gp
                lui     $gp,%hi(_gp)
                ori     $gp,%lo(_gp)

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                la      $t0,_ada_main
                jalr    $t0
                nop

dead:           b       .
                nop

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

