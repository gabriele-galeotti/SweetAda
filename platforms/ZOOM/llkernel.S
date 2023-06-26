
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

//
// 14.2.9.1 Interrupt Sources
// 14.3.1.3 Interrupt Vector Determination
//

                .global vector_table
vector_table:

reset_sp:       .long   0
                .extern _start
reset_pc:       .long   _start
                .space  (64-2)*4
                // Table 14-15. Interrupt Source Assignment For INTC0
                .space  (64)*4                          // INTC0 vectors 0..63 (+64)
                // Table 14-16. Interrupt Source Assignment for INTC1
                .space  (40)*4                          // INTC1 vectors 0..39 (+128) Not Used
                .long   0                               // INTC1 vector 40 (+128) RNG
                .long   0                               // INTC1 vector 41 (+128) SKHA
                .long   0                               // INTC1 vector 42 (+128) MDHA
                .long   pit0_handler                    // INTC1 vector 43 (+128) PIT0

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

pit0_handler:
                //pea     PIT0_IRQID
                jmp     irq_entry
                // __FIX__ original instructions
                // movem.l %d0-%d1/%a0-%a1,%sp@-
                // movem.l %sp@+,%d0-%d1/%a0-%a1
irq_entry:
                // stack frame handling - init
                lea     -16(%sp),%sp                    // 4 regs x 4 bytes/reg = 16 bytes
                movem.l %d0-%d1/%a0-%a1,0(%sp)          // store registers low addresses -> high addresses
                move.l  16(%sp),%d0                     // get exception identifier
                move.l  %sp,%d1
                move.l  %d1,%sp@-                       // push as 2nd argument
                move.l  %d0,%sp@-                       // push as 1st argument
                //.extern exception_handler
                //jsr     exception_handler
                addq.l  #8,%sp                          // unstacks the arguments
                movem.l 0(%sp),%d0-%d1/%a0-%a1          // restore registers
                lea     16(%sp),%sp
                // stack frame handling - end
                addq.l  #4,%sp                          // unstack identifier pushed by "pea" instruction in stub handler
                rte

