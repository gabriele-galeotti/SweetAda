
//
// startup.S - LEON3 startup (QEMU emulator).
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <sparcv8.h>

////////////////////////////////////////////////////////////////////////////////

#define ASI_MMUREGS    0x04
#define ASI_BYPASS     0x20
#define ASI_SCRATCHPAD 0x20

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // The SPARC Architecture Manual Version 8
                // 4.2. IU Control/Status Registers
                //
                // https://lists.rtems.org/pipermail/users/2006-August/014931.html
                // https://github.com/MISTLab/trap-gen/blob/master/BSP_and_Compiler/sparc
                //
#define PSR_INIT (PSR_EF|PSR_PIL(0xF)|PSR_S|PSR_PS|PSR_ET|PSR_CWP(0))
                mov     %psr,%g1
                sethi   %hi(0xFF000000|PSR_S),%g2       // preserve impl, ver
                or      %g2,%lo(0xFF000000|PSR_S),%g2
                sethi   %hi(PSR_INIT),%g3
                or      %g3,%lo(PSR_INIT),%g3
                and     %g1,%g2,%g1
                or      %g1,%g3,%g1
                mov     %g1,%psr
                NOP3
                // setup TBR
                sethi   %hi(trap_table),%g1
                or      %g1,%lo(trap_table),%g1
                mov     %g1,%tbr
                NOP3
                // initialize Y
                mov     %g0,%y
                NOP3

                //
                // Detect # of CPU windows implemented.
                // A WRWIM with all bits set to 1, followed by a RDWIM, yields
                // a bit vector in which the implemented windows (and only the
                // implemented windows) are indicated by 1?s.
                //
                sethi   %hi(0xFFFFFFFF),%g3
                or      %g3,%lo(0xFFFFFFFF),%g3
                mov     %g3,%wim
                NOP3
                mov     %wim,%g3                        // now g3 contains a mask of all windows
                mov     %g0,%g1                         // clear # of windows
                mov     %g0,%g2                         // g2 will add to g1
1:              and     %g3,1,%g2                       // check if this window is implemented
                add     %g1,%g2,%g1                     // add result to g1
                tst     %g2                             // was it 0?
                bne     1b                              // if yes, windows exahusted, else ...
                srl     %g3,1,%g3                       // shift g3 in the delay slot and cycle
                sethi   %hi(nwindows),%g2
                or      %g2,%lo(nwindows),%g2
                sta     %g1,[%g2]ASI_SCRATCHPAD
                //
                set     0xFFFFFF00,%g1
                mov     %g1,%wim
                NOP3

                //
                // Setup stack pointer.
                //
                sethi   %hi(kernel_stack),%sp
                or      %sp,%lo(kernel_stack),%sp

                //
                // Setup environment.
                //
                mov     %sp,%fp
                add     %sp,-96,%sp
                clr     %g1
                clr     %g2
                clr     %g3
                clr     %g4
                clr     %g5
                clr     %g6
                clr     %g7

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

dead:           b       .
                nop

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

                .align  4
                .global nwindows
nwindows:       .space  4

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

