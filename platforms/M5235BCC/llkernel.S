
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

//
// Exception Vector Table.
// 13.1.2.3 Interrupt Vector Determination
//

                .global vector_table
vector_table:

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

