
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
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
                set     ~(MMU_CR_BM|MMU_CR_E),%g3
                and     %g2,%g3,%g2
                set     _init,%g1
                jmp     %g1
                sta     %g2,[%g0]ASI_N

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .global _init
_init:

                //
                // The SPARC Architecture Manual Version 8
                // 4.2. IU Control/Status Registers
                //
#define PSR_INIT (PSR_EF|PSR_PIL(0xF)|PSR_S|PSR_PS|PSR_ET|PSR_CWP(0))
                rd      %psr,%g1
                set     (PSR_impl|PSR_ver|PSR_S),%g2            // preserve ver, impl
                set     PSR_INIT,%g3
                and     %g1,%g2,%g1
                or      %g1,%g3,%g1
                wr      %g1,%psr
                NOP3
                //
                // Setup TBR.
                //
                .extern trap_table
                set     trap_table,%g1
                wr      %g1,%tbr
                NOP3
                //
                // Initialize Y.
                //
                wr      %g0,%y
                NOP3

#if RELOCATE_DATA == 1
                //
                // Static data relocation.
                //
                call    movdata
                nop
#endif

                //
                // Detect # of implemented CPU windows.
                //
                // A WRWIM with all bits set to 1, followed by a RDWIM, yields
                // a bit vector in which the implemented windows (and only the
                // implemented windows) are indicated by 1s.
                //
                set     0xFFFFFFFF,%g1
                mov     %g1,%g3
                wr      %g1,%wim
                NOP3
                rd      %wim,%g1
                xor     %g1,%g3,%g3
                clr     %g2
1:              cmp     %g1,0
                beq     2f
                nop
                inc     %g2
                b       1b
                srl     %g1,1,%g1
2:

                //
                // Save NWINDOWS.
                // %g2=NWINDOWS
                //
                set     nwindows,%g1
                sta     %g2,[%g1]ASI_SCRATCHPAD

                //
                // Recover ~WIM and create and inverse mask, 1st window is
                // invalid.
                // %g3=~WIM
                //
                sra     %g3,1,%g1
                wr      %g1,%wim
                NOP3

                //
                // Update PSR with CWP=NWINDOWS-1 and stack=trap_stack.
                // %g2=NWINDOWS
                //
                rd      %psr,%g1
                set     PSR_CWP(-1),%g3
                andn    %g1,%g3,%g1
                sub     %g2,1,%g2
                or      %g1,%g2,%g1
                wr      %g1,%psr
                NOP3
                .extern trap_stack
                set     trap_stack,%sp

                //
                // Update PSR with CWP=0.
                //
                rd      %psr,%g1
                set     PSR_CWP(-1),%g3
                andn    %g1,%g3,%g1
                wr      %g1,%psr
                NOP3

                //
                // Initialize .bss section.
                //
                .extern _sbss
                .extern _ebss
                set     _sbss,%g1
                set     _ebss,%g2
                add     %g1,1,%g1
1:              stb     %g0,[%g1]
                subcc   %g1,%g2,%g0
                bl      1b
                add     %g1,1,%g1

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
                set     kernel_stack,%sp

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

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  4096
kernel_stack:

