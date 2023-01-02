
/*
 * armv4.h - ARM architecture definitions.
 *
 * Copyright (C) 2020-2023 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _ARMv4_H
#define _ARMv4_H 1

#define Mode_USR  0x10
#define Mode_FIQ  0x11
#define Mode_IRQ  0x12
#define Mode_SVC  0x13
#define Mode_ABT  0x17
#define Mode_UND  0x1B
#define Mode_SYS  0x1F
#define Mode_MASK 0x1F
#define IF        (1 << 6)
#define IR        (1 << 7)
#define INT_MASK  ((1 << 6) | (1 << 7))
#define N_FLAG(x) ((((x) >> 31) & 0x1) != 0)
#define Z_FLAG(x) ((((x) >> 30) & 0x1) != 0)
#define C_FLAG(x) ((((x) >> 29) & 0x1) != 0)
#define V_FLAG(x) ((((x) >> 28) & 0x1) != 0)

#define RESET_VECTOR_ADDRESS                 0x00
#define UNDEFINED_INSTRUCTION_VECTOR_ADDRESS 0x04
#define SOFTWARE_INTERRUPT_VECTOR_ADDRESS    0x08
#define ABORT_PREFETCH_VECTOR_ADDRESS        0x0C
#define ABORT_DATA_VECTOR_ADDRESS            0x10
#define ADDRESS_EXCEPTION_VECTOR_ADDRESS     0x14
#define IRQ_VECTOR_ADDRESS                   0x18
#define FIQ_VECTOR_ADDRESS                   0x1C

#define OPCODE_NOP             0xE1A00000
#define OPCODE_BREAKPOINT      0xE7FFDEFE
#define OPCODE_BREAKPOINT_SIZE 4

#endif /* _ARMv4_H */

