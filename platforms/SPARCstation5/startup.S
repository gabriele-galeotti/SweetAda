
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

#define ASI_MMUREGS    0x04
#define ASI_BYPASS     0x20
#define ASI_SCRATCHPAD 0x20

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                //
                // The SPARC Architecture Manual Version 8
                // Chapter 7 - Traps pg. 75 "Reset Trap"
                //
                // Boot ROM (0xFFD00000) is remapped @ 0x00000000.
                //

                .type   _start,@function
                .global _start
                .align  16
_start:

                //
                // Disable "Boot mode" and MMU.
                //
                // When in ROM mode, disabling the "Boot mode" bit will make
                // the address translation disappear, so we need to explicitly
                // perform a jump in the 0x70000000 ROM area.
                //
                lda     [%g0]ASI_MMUREGS,%g2
                sethi   %hi(0xFFFFBFFE),%g3             // ~MMU_CR_BM, ~MMU_CR_E
                or      %g3,%lo(0xFFFFBFFE),%g3
                and     %g2,%g3,%g2
                sethi   %hi(bm),%g1
                or      %g1,%lo(bm),%g1
                jmp     %g1
                sta     %g2,[%g0]ASI_MMUREGS

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

bm:
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
                // Check if we are running under QEMU.
                //
#define CFG_ADDR         0x00000510
#define FW_CFG_SIGNATURE 0x0000
#define CFG_ASI          0x2D
                clr     %g1
                set     CFG_ADDR,%g5
                mov     FW_CFG_SIGNATURE,%g2
                stha    %g2,[%g5]CFG_ASI
                add     %g5,2,%g5
                lduba   [%g5]CFG_ASI,%g2
                cmp     %g2,'Q'
                bne     1f
                nop
                lduba   [%g5]CFG_ASI,%g2
                cmp     %g2,'E'
                bne     1f
                nop
                lduba   [%g5]CFG_ASI,%g2
                cmp     %g2,'M'
                bne     1f
                nop
                lduba   [%g5]CFG_ASI,%g2
                cmp     %g2,'U'
                bne     1f
                nop
                or      %g1,1,%g1
1:              sethi   %hi(qemu),%g2
                or      %g2,%lo(qemu),%g2
                stuba   %g1,[%g2]ASI_SCRATCHPAD

#if RELOCATE_DATA == 1
                //
                // Perform static data relocation.
                //
                call    movdata
                nop
#endif

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

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// Perform high-level language data relocation.                               //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                //.extern _etext
                //.extern _sdata
                //.extern _edata
                set     (0xFFD00000+_etext),%g1
                //set     (0xFFD00000+_sdata),%g2
                //set     (0xFFD00000+_edata),%g3
                //set     _etext,%g1
                set     _sdata,%g2
                set     _edata,%g3
                cmp     %g2,%g3
                be      2f
                nop
1:              //ldda    [%g1]ASI_SCRATCHPAD,%g4
                //stda    %g4,[%g2]ASI_SCRATCHPAD
                add     %g2,4,%g2                       // ++_sdata
                cmp     %g2,%g3                         // _sdata = _edata ?
                blu     1b
                add     %g1,4,%g1                       // ++_etext, executed in delay slot
2:              retl
                nop

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

