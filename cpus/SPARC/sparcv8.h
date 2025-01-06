
/*
 * sparcv8.h - SPARC V8 architecture definitions.
 *
 * Copyright (C) 2020-2025 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _SPARCV8_H
#define _SPARCV8_H 1

/* pipeline delay after PSR/WIM write */
#define NOP3  nop ; nop ; nop
#define NOP10 NOP3 ; NOP3 ; NOP3 ; nop

#define PSR_ET     (1 << 5)
#define PSR_PS     (1 << 6)
#define PSR_S      (1 << 7)
#define PSR_PIL(x) (((x) & 0xF) << 8)
#define PSR_EF     (1 << 12)
#define PSR_CWP(x) ((x) & 0x1F)
#define PSR_ver    (0xF << 24)
#define PSR_impl   (0xF << 28)

#define MMU_CR_E  (1 << 0)
#define MMU_CR_BM (1 << 14)

#define ASI_IMPLICIT   0x00
#define ASI_N          0x04     /* MMU registers RW single-size */
#define ASI_SCRATCHPAD 0x20     /* reference MMU bypass RW */

#endif /* _SPARCV8_H */

