
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <mcf5373.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Supervisor mode, disable interrupts.
                //
                move.w  #0x2700,%sr

                //
                // Disable the watchdog.
                //
                clr.w   WCR

                //
                // Disable CACR and the ACRs.
                //
                moveq.l #0,%d0
                movec.l %d0,%acr0
                movec.l %d0,%acr1
                movec.l %d0,%cacr

                //
                // Setup stack pointer.
                //
                lea.l   kernel_stack,%sp

#if defined(DATA_RELOC)
                //
                // Static data relocation.
                //
                .extern _etext
                .extern _sdata
                .extern _edata
                move.l  #_etext,%a0
                move.l  #_sdata,%a1
                move.l  #_edata,%a2
                bra.s   2f
1:              move.b  %a0@+,%a1@+
2:              cmp.l   %a1,%a2
                bne.s   1b
#endif

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

