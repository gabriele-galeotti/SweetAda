
/*
 * riscv.h - RISC-V architecture definitions.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _RISCV_H
#define _RISCV_H 1

#if   __riscv_xlen == 32
# define SAVEREG    sw
# define LOADREG    lw
# define XLEN_ORDER 2
#elif __riscv_xlen == 64
# define SAVEREG    sd
# define LOADREG    ld
# define XLEN_ORDER 3
#else
# error "__riscv_xlen: value not recognized"
#endif

#endif /* _RISCV_H */

