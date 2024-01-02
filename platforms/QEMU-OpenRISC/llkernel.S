
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

                .sect   .vectors,"ax"

                .global vectors
vectors:

                // 0x0100: RESET exception
                .org    0x0100
reset:
                .extern _start
                l.movhi r2,hi(_start)
                l.ori   r2,r2,lo(_start)
                l.jr    r2
                l.nop

                .space  0x1E00

