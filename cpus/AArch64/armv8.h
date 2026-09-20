
/*
 * armv8.h - ARMv8 architecture definitions.
 *
 * Copyright (C) 2020-2026 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _ARMV8_H
#define _ARMV8_H 1

// ACTLR
#define ACTLR_CPUECTLR (1 << 1)

// CPUECTLR
#define CPUECTLR_SMPEN (1 << 6)

// CPACR
#define CPACR_CP10 (0x3 << 20)

// SCTRL
#define SCTLR_RESERVED ((0x3 << 28) | (0x3 << 22) | (1 << 20) | (1 << 11))
#define SCTLR_M        (1 << 0)
#define SCTLR_C        (1 << 2)
#define SCTLR_I        (1 << 12)

// HCR
#define HCR_RW (1 << 31)

// SCR
#define SCR_RESERVED (0x3 << 4)
#define SCR_NS       (1 << 0)
#define SCR_RW       (1 << 10)
#define SCTLR_WXN    (1 << 19)

// SPSR
#define SPSR_EL1h     (0x5 << 0)
#define SPSR_EL2h     (0x9 << 0)
#define SPSR_MASK_ALL (0x7 << 6)

#endif /* _ARMV8_H */

