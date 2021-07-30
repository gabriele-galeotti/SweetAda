
//
// startup.S - LEON3 startup (QEMU emulator).
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sparcv8.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                // disable traps
                mov     %psr,%l0
                and     %l0,0xFFFFFFDF,%l4
                mov     %l4,%psr
                NOP3

                //
                // Initialize Y.
                //
                mov     %g0,%y
                NOP3

                // https://github.com/openbios/openbios/blob/master/arch/sparc32/entry.S

                set     0xFFFFFF00,%g1
                mov     %g1,%wim
                NOP3

                //ba      _start
                nop
                set     kernel_stack,%sp

                mov     %sp,%fp
                add     %sp,-96,%sp

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                call    adainit
                nop

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main
                nop

                //set     _a,%l0
                ld      [%l0],%l1       // load _a into %l1
                add     %l1,1,%l1       // _a = _a + 1
                st      %l1,[%l0]       // write value back into _a
                //set     str,%o0
                ld      [%l0],%o1
                //call    _printf         // nop       ! printf("%d\n", _a);
                ret                     // restore

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

