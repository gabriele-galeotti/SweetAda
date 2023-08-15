
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

                .align  8

                .global vectors
vectors:


                addi    sp,sp,-256
                SAVEREG ra,(0*X2)(sp)
                //SAVEREG sp,(4*X2)(sp)
                SAVEREG gp,(8*X2)(sp)
                SAVEREG tp,(12*X2)(sp)
                SAVEREG t0,(16*X2)(sp)
                SAVEREG t1,(20*X2)(sp)
                SAVEREG t2,(24*X2)(sp)
                SAVEREG t3,(28*X2)(sp)
                SAVEREG t4,(32*X2)(sp)
                SAVEREG t5,(36*X2)(sp)
                SAVEREG t6,(40*X2)(sp)
                SAVEREG a0,(44*X2)(sp)
                SAVEREG a1,(48*X2)(sp)
                SAVEREG a2,(52*X2)(sp)
                SAVEREG a3,(56*X2)(sp)
                SAVEREG a4,(60*X2)(sp)
                SAVEREG a5,(64*X2)(sp)
                SAVEREG a6,(68*X2)(sp)
                SAVEREG a7,(72*X2)(sp)

                .extern exception_process
                jal     exception_process

                LOADREG ra,(0*X2)(sp)
                //LOADREG sp,(4*X2)(sp)
                LOADREG gp,(8*X2)(sp)
                LOADREG tp,(12*X2)(sp)
                LOADREG t0,(16*X2)(sp)
                LOADREG t1,(20*X2)(sp)
                LOADREG t2,(24*X2)(sp)
                LOADREG t3,(28*X2)(sp)
                LOADREG t4,(32*X2)(sp)
                LOADREG t5,(36*X2)(sp)
                LOADREG t6,(40*X2)(sp)
                LOADREG a0,(44*X2)(sp)
                LOADREG a1,(48*X2)(sp)
                LOADREG a2,(52*X2)(sp)
                LOADREG a3,(56*X2)(sp)
                LOADREG a4,(60*X2)(sp)
                LOADREG a5,(64*X2)(sp)
                LOADREG a6,(68*X2)(sp)
                LOADREG a7,(72*X2)(sp)
                addi    sp,sp,256
                mret

