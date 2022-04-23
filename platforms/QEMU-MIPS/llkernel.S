
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <mips.h>

////////////////////////////////////////////////////////////////////////////////

//
// Exception Vectors.
//

                .sect   .vectors,"ax"
                .set    noreorder

                //
                // RESET entry point
                //
                .global reset
reset:
                .extern _start
                j       _start
                move    $k0,$0

                //
                // BFC00200: R4000 tlbmiss
                //
                .align  9
                j       tlb_miss
                nop

                //
                // BFC00280: R4000 xtlbmiss
                //
                .align  7
                j       x_tlb_miss
                nop

                //
                // BFC00300: R4000 cache error
                //
                .align  7
                j       cache_err
                nop

                //
                // BFC00380: R4000 general
                //
                .align  7
                j       gen_exc
                nop

tlb_miss:
                j       handle_exc
                nop

x_tlb_miss:
                j       handle_exc
                nop

cache_err:
                j       handle_exc
                nop

gen_exc:
                j       handle_exc
                nop

handle_exc:
                j       .

