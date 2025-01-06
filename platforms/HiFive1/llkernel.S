
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#define SAVEREG sw
#define LOADREG lw

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .p2align 8

                .global vectors
vectors:

                addi    sp,sp,-64

                SAVEREG ra,( 0)(sp)
                SAVEREG t0,( 4)(sp)
                SAVEREG t1,( 8)(sp)
                SAVEREG t2,(12)(sp)
                SAVEREG t3,(16)(sp)
                SAVEREG t4,(20)(sp)
                SAVEREG t5,(24)(sp)
                SAVEREG t6,(28)(sp)
                SAVEREG a0,(32)(sp)
                SAVEREG a1,(36)(sp)
                SAVEREG a2,(40)(sp)
                SAVEREG a3,(44)(sp)
                SAVEREG a4,(48)(sp)
                SAVEREG a5,(52)(sp)
                SAVEREG a6,(56)(sp)
                SAVEREG a7,(60)(sp)

                .extern exception_process
                jal     exception_process

                LOADREG ra,( 0)(sp)
                LOADREG t0,( 4)(sp)
                LOADREG t1,( 8)(sp)
                LOADREG t2,(12)(sp)
                LOADREG t3,(16)(sp)
                LOADREG t4,(20)(sp)
                LOADREG t5,(24)(sp)
                LOADREG t6,(28)(sp)
                LOADREG a0,(32)(sp)
                LOADREG a1,(36)(sp)
                LOADREG a2,(40)(sp)
                LOADREG a3,(44)(sp)
                LOADREG a4,(48)(sp)
                LOADREG a5,(52)(sp)
                LOADREG a6,(56)(sp)
                LOADREG a7,(60)(sp)

                addi    sp,sp,64
                mret

