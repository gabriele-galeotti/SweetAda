
//
// startup.S - Integrator/CP startup (QEMU emulator).
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .global V_Reset
                .global V_UndInstr
                .global V_SWI
                .global V_AbortP
                .global V_AbortD
                .global V_AddrExc
                .global V_IRQ
                .global V_FIQ
                .extern undinstr_handler
                .extern swi_handler
                .extern abortp_handler
                .extern abortd_handler
                .extern addrexc_handler
                .extern irq_handler
                .extern fiq_handler

                ldr     pc,V_Reset                      // 0x00 Reset
                ldr     pc,V_UndInstr                   // 0x04 Undefined Instruction
                ldr     pc,V_SWI                        // 0x08 Software Interrupt
                ldr     pc,V_AbortP                     // 0x0C Abort (Prefetch)
                ldr     pc,V_AbortD                     // 0x10 Abort (Data)
                ldr     pc,V_AddrExc                    // 0x14 Address Exception -- reserved
                ldr     pc,V_IRQ                        // 0x18 IRQ
                ldr     pc,V_FIQ                        // 0x1C FIQ
V_Reset:        .word   _start
V_UndInstr:     //.word   undinstr_handler
V_SWI:          //.word   swi_handler
V_AbortP:       //.word   abortp_handler
V_AbortD:       //.word   abortd_handler
V_AddrExc:      //.word   addrexc_handler
V_IRQ:          //.word   irq_handler
V_FIQ:          //.word   fiq_handler

                .type   _start,%function
                .global _start
_start:

                //
                // After reset, CPU is in supervisor mode.
                // __REF__ http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.faqs/ka3761.html
                //

                ldr     r0,=SVC_stack
                mov     sp,r0

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                bl      adainit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                bl      _ada_main

dead:           b       .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// Perform high-level language data relocation.                               //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                // registers used: r0-r3
                .extern _etext
                .extern _sdata
                .extern _edata
                ldr     r1,=_etext
                ldr     r2,=_sdata
                ldr     r3,=_edata
                cmp     r2,r3
                movcs   pc,lr
1:              ldr     r0,[r1],#4
                str     r0,[r2],#4
                cmp     r2,r3
                blt     1b
                mov     pc,lr

////////////////////////////////////////////////////////////////////////////////
// zerobss                                                                    //
//                                                                            //
// Perform a cleanup of the .bss area.                                        //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

zerobss:
                // registers used: r0-r2
                .extern _sbss
                .extern _ebss
                ldr     r1,=_sbss
                ldr     r2,=_ebss
                cmp     r1,r2
                movcs   pc,lr
                ldr     r0,=0
1:              str     r0,[r1],#4
                cmp     r1,r2
                blt     1b
                mov     pc,lr

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  8
                .space  1024
FIQ_stack:
                .align  8
                .space  1024
IRQ_stack:
                .align  8
                .space  1024
ABT_stack:
                .align  8
                .space  1024
UND_stack:
                .align  8
                .space  2048
SVC_stack:
                .align  8
                .space  4096
USR_stack:

