
/*
 * sparcv8.h - SPARC V8 architecture definitions.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _SPARCV8_H
#define _SPARCV8_H 1

/* pipeline delay after PSR/WIM write */
#define NOP3  nop ; nop ; nop
#define NOP10 NOP3 ; NOP3 ; NOP3 ; nop

#define PSR_EF     (1 << 12)
#define PSR_PIL(x) (((x) & 0xF) << 8)
#define PSR_S      (1 << 7)
#define PSR_PS     (1 << 6)
#define PSR_ET     (1 << 5)
#define PSR_CWP(x) ((x) & 0x1F)

#define BOOTMODE (1 << 14)

#endif /* _SPARCV8_H */

