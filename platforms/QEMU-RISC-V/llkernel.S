
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#if   __riscv_xlen == 32
# define SAVEREG sw
# define LOADREG lw
# define X2 1
#elif __riscv_xlen == 64
# define SAVEREG sd
# define LOADREG ld
# define X2 2
#endif

////////////////////////////////////////////////////////////////////////////////

                .option arch,+zicsr,+zifencei

                .sect   .vectors,"ax"

                .p2align 2

                .global vectors
vectors:

                // 0x00 Reserved (User Software Interrupt)
                .p2align 2
                j       exc_handler
                // 0x04 Supervisor Software Interrupt
                .p2align 2
                j       exc_handler
                // 0x08 Reserved
                .p2align 2
                j       exc_handler
                // 0x0C Machine Software Interrupt
                .p2align 2
                j       exc_handler

                // 0x10 Reserved (User Timer Interrupt)
                .p2align 2
                j       exc_handler
                // 0x14 Supervisor Timer Interrupt
                .p2align 2
                j       exc_handler
                // 0x18 Reserved
                .p2align 2
                j       exc_handler
                // 0x1C Machine Timer Interrupt
                .p2align 2
                j       exc_handler

                // 0x20 Reserved (User External Interrupt)
                .p2align 2
                j       exc_handler
                // 0x24 Supervisor External Interrupt
                .p2align 2
                j       exc_handler
                // 0x28 Reserved
                .p2align 2
                j       exc_handler
                // 0x2C Machine External Interrupt
                .p2align 2
                j       exc_handler

                // 0x30/0x34/0x38/0x3C Reserved
                .p2align 2
                .space  4*4

                .sect   .text,"ax"

exc_handler:
                addi    sp,sp,-64*X2

                SAVEREG ra,( 0*X2)(sp)
                SAVEREG t0,( 4*X2)(sp)
                SAVEREG t1,( 8*X2)(sp)
                SAVEREG t2,(12*X2)(sp)
                SAVEREG t3,(16*X2)(sp)
                SAVEREG t4,(20*X2)(sp)
                SAVEREG t5,(24*X2)(sp)
                SAVEREG t6,(28*X2)(sp)
                SAVEREG a0,(32*X2)(sp)
                SAVEREG a1,(36*X2)(sp)
                SAVEREG a2,(40*X2)(sp)
                SAVEREG a3,(44*X2)(sp)
                SAVEREG a4,(48*X2)(sp)
                SAVEREG a5,(52*X2)(sp)
                SAVEREG a6,(56*X2)(sp)
                SAVEREG a7,(60*X2)(sp)

                .extern exception_process
                jal     exception_process

                LOADREG ra,( 0*X2)(sp)
                LOADREG t0,( 4*X2)(sp)
                LOADREG t1,( 8*X2)(sp)
                LOADREG t2,(12*X2)(sp)
                LOADREG t3,(16*X2)(sp)
                LOADREG t4,(20*X2)(sp)
                LOADREG t5,(24*X2)(sp)
                LOADREG t6,(28*X2)(sp)
                LOADREG a0,(32*X2)(sp)
                LOADREG a1,(36*X2)(sp)
                LOADREG a2,(40*X2)(sp)
                LOADREG a3,(44*X2)(sp)
                LOADREG a4,(48*X2)(sp)
                LOADREG a5,(52*X2)(sp)
                LOADREG a6,(56*X2)(sp)
                LOADREG a7,(60*X2)(sp)

                addi    sp,sp,64*X2
                mret

