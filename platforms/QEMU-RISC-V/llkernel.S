
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

                .option arch,+zicsr,+zifencei

                .sect   .vectors,"ax"

                .align  8

                .global vectors
vectors:

                addi    sp,sp,-256
                sw      ra,0(sp)
                //sw      sp,4(sp)
                sw      gp,8(sp)
                sw      tp,12(sp)
                sw      t0,16(sp)
                sw      t1,20(sp)
                sw      t2,24(sp)
                sw      t3,28(sp)
                sw      t4,32(sp)
                sw      t5,36(sp)
                sw      t6,40(sp)
                sw      a0,44(sp)
                sw      a1,48(sp)
                sw      a2,52(sp)
                sw      a3,56(sp)
                sw      a4,60(sp)
                sw      a5,64(sp)
                sw      a6,68(sp)
                sw      a7,72(sp)

                .extern exception_process
                call    exception_process

                lw      ra,0(sp)
                //lw      sp,4(sp)
                lw      gp,8(sp)
                lw      tp,12(sp)
                lw      t0,16(sp)
                lw      t1,20(sp)
                lw      t2,24(sp)
                lw      t3,28(sp)
                lw      t4,32(sp)
                lw      t5,36(sp)
                lw      t6,40(sp)
                lw      a0,44(sp)
                lw      a1,48(sp)
                lw      a2,52(sp)
                lw      a3,56(sp)
                lw      a4,60(sp)
                lw      a5,64(sp)
                lw      a6,68(sp)
                lw      a7,72(sp)
                addi    sp,sp,256
                mret

