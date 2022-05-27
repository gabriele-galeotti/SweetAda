
//
// startup.S - SPARCstation 5 startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <configure.h>
#include <sparcv8.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
                .align  16
_start:

                //
                // Disable MMU and "Boot mode".
                //
                // Boot ROM is located @ 0xFFD00000, temporarily mapped @
                // 0x00000000 when the machine is powered-up. Disabling BM
                // will make the translation disappear. The ROM is also
                // aliased @ 0x70000000.
                //
                lda     [%g0]ASI_N,%g2
                sethi   %hi(~(MMU_CR_BM|MMU_CR_E)),%g3
                or      %g3,%lo(~(MMU_CR_BM|MMU_CR_E)),%g3
                and     %g2,%g3,%g2
                sethi   %hi(initcpu),%g1
                or      %g1,%lo(initcpu),%g1
                jmp     %g1
                sta     %g2,[%g0]ASI_N

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

initcpu:
                //
                // The SPARC Architecture Manual Version 8
                // 4.2. IU Control/Status Registers
                //
#define PSR_INIT (PSR_EF|PSR_PIL(0xF)|PSR_S|PSR_PS|PSR_ET|PSR_CWP(0))
                mov     %psr,%g1
                sethi   %hi(PSR_impl|PSR_ver|PSR_S),%g2       // preserve ver, impl
                or      %g2,%lo(PSR_impl|PSR_ver|PSR_S),%g2
                sethi   %hi(PSR_INIT),%g3
                or      %g3,%lo(PSR_INIT),%g3
                and     %g1,%g2,%g1
                or      %g1,%g3,%g1
                mov     %g1,%psr
                NOP3
                //
                // Setup TBR.
                //
                sethi   %hi(trap_table),%g1
                or      %g1,%lo(trap_table),%g1
                mov     %g1,%tbr
                NOP3
                //
                // Initialize Y.
                //
                mov     %g0,%y
                NOP3

#if RELOCATE_DATA == 1
                //
                // Perform static data relocation.
                //
                call    movdata
                nop
#endif

                //
                // Detect # of implemented CPU windows.
                //
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
                // force 8 windows
                set     0xFFFFFF00,%g1
                mov     %g1,%wim
                NOP3

                //
                // Clear registers.
                //
                clr     %g1
                clr     %g2
                clr     %g3
                clr     %g4
                clr     %g5
                clr     %g6
                clr     %g7

                //
                // Setup stack pointer.
                //
                sethi   %hi(kernel_stack),%sp
                or      %sp,%lo(kernel_stack),%sp

                //
                // Create a stack frame.
                //
                mov     %sp,%fp
                add     %sp,-96,%sp

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main
                nop

dead:           b       .
                nop

#if RELOCATE_DATA == 1
////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// Perform .data section relocation.                                          //
////////////////////////////////////////////////////////////////////////////////

movdata:
                .extern _etext
                .extern _sdata
                .extern _edata
                set     _etext,%g1
                set     _sdata,%g2
                set     _edata,%g3
                cmp     %g2,%g3
                be      2f
                nop
1:              lda     [%g1]ASI_SCRATCHPAD,%g4
                sta     %g4,[%g2]ASI_SCRATCHPAD
                add     %g2,4,%g2
                cmp     %g2,%g3
                blu     1b
                add     %g1,4,%g1
2:              retl
                nop
#endif

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

                .align  4
                .global nwindows
nwindows:       .space  4
                .global qemu
qemu:           .space  1

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  4
                .space  4096
kernel_stack:

