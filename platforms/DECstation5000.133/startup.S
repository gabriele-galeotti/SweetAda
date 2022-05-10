
//
// startup.S - DECstation 5000/133 MIPS R3000 startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .set    noreorder
                .set    noat

                .org    0
                j       _start
                nop
                .org    0x100
                break   0
                .org    0x180
                break   0
                .org    0x200

////////////////////////////////////////////////////////////////////////////////

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                lui     $sp,%hi(kernel_stack)
                ori     $sp,%lo(kernel_stack)

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
                // Jump to high-level code.
                //
                .extern _ada_main
                jal     _ada_main
                nop

dead:           b       .
                nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

