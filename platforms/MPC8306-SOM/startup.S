
//
// startup.S - MPC8306SOM startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <e300.h>
#include <mpc8306.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .type   _start,@function
                .global _start
_start:

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .align  3
                .space  4096
kernel_stack:

