
//
// startup.S - Macintosh Quadra 800 startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

#define INITIALSP 0
#define INITIALPC (_start-0x40800000)
#include "startup-vectors.h"

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Supervisor mode, disable interrupts.
                //
                move.w  #0x2700,%sr

                //
                // Setup stack pointer.
                //
                lea.l   kernel_stack,%sp

                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
                move.l  #_etext,%a0
                move.l  #_sdata,%a1
                move.l  #_edata,%a2
1:              cmp.l   %a1,%a2
                beq.s   2f
                move.b  %a0@+,%a1@+
                bra.s   1b
2:

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                move.l  #_sbss,%a0
                move.l  #_ebss,%a1
                bra.s   2f
1:              clr.b   %a0@+
2:              cmp.l   %a0,%a1
                bne.s   1b

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                jsr     _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

