
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

                .global _start
_start:

                //
                // Set up SR and Cause registers.
                //
                mfc0    $t0,CP0_PRId
                mfc0    $v0,CP0_SR
                mtc0    $0,CP0_WatchLo
                mtc0    $0,CP0_WatchHi
                and     $v0,SR_SR                       // preserve Soft Reset
                or      $v0,SR_BEV                      // set Boot Exceptions
                mtc0    $v0,CP0_SR                      // 32 bit, kernel mode, bootstrap
                mtc0    $0,CP0_Cause
                nop

                //
                // Setup stack pointer.
                //
                la      $sp,kernel_stack

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

