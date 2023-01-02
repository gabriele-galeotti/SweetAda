
//
// startup.S - Arnewsh SBC5206 startup (QEMU emulator).
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <llutils.h>
#include <coldfire.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

#define INITIALSP 0
#define INITIALPC _start
#include "startup-vectors.S"

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                move.w  #0x2700,%sr                     // supervisor mode, disable interrupts
                // VBR & MBAR programming
                // ColdFire Family PRM, 8-13, "MOVEC"
                move.l  #0,%d0                          // VBR programming
                movec.l %d0,#VBR                        // CFPRM 1.5.3

                // QEMU cannot handle $C0F operations (MCF5206 MBAR)
#if 0
# define MBAR_VALUE 0x10000000  /* Arnewsh SBC5206 board default */
                move.l  #MBAR_VALUE,%d0                 // MBAR programming
                ori.l   #1,%d0                          // valid bit = 1 (validate MBAR)
                movec.l %d0,#MBAR                       // CFPRM 1.5.10
#endif

                // perform static data relocation
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
                // Setup stack pointer.
                //
                lea.l   kernel_stack,%sp

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

