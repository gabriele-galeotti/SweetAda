
/*
 * i386.h - i386 architecture definitions.
 *
 * Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _I386_H
#define _I386_H 1

/*
 * Status register (EFLAGS).
 */

#define FLAG_CARRY      (1 << 0)
#define FLAG_PARITY     (1 << 2)
#define FLAG_AUXCARRY   (1 << 4)
#define FLAG_ZERO       (1 << 6)
#define FLAG_SIGN       (1 << 7)
#define FLAG_TRAP       (1 << 8)
#define FLAG_INTERRUPT  (1 << 9)
#define FLAG_DIRECTION  (1 << 10)
#define FLAG_OVERFLOW   (1 << 11)
#define FLAG_NESTEDTASK (1 << 14)
#define FLAG_RESUME     (1 << 16)
#define FLAG_VMODE86    (1 << 17)

/*
 * Exception descriptor types.
 */

#define GATE_TASK      0x05
#define GATE_INTERRUPT 0x0E
#define GATE_TRAP      0x0F

/*
 * LGDT/LIDT macros.
 */

#define GDT_ALIGNMENT 4
#define IDT_ALIGNMENT 4

/*
 * Segmented and paged memory management
 */

#define CR0_PE       (1 << 0)
#define CR0_NE       (1 << 5)
#define CR0_NW       (1 << 29)
#define CR0_CD       (1 << 30)
#define CR0_PG       (1 << 31)

#define PAGE_ENTRIES 1024
#define PAGE_SIZE    4096

#define PG_VALID     (1 << 0)
#define PG_WRITE     (1 << 1)
#define PG_USER      (1 << 2)

#define PAGE2ADDRESS(x) ((x) << 12)
#define ADDRESS2PAGE(x) ((unsigned long)(x) >> 12)

/*
 * Exceptions.
 */

#define DIVISION_BY_0        0
#define DEBUG_EXCEPTION      1
#define NMI_INTERRUPT        2
#define ONE_BYTE_INTERRUPT   3
#define INT_ON_OVERFLOW      4
#define ARRAY_BOUNDS         5
#define INVALID_OPCODE       6
#define DEVICE_NOT_AVAILABLE 7
#define DOUBLE_FAULT         8
#define CP_SEGMENT_OVERRUN   9
#define INVALID_TSS          10
#define SEGMENT_NOT_PRESENT  11
#define STACK_FAULT          12
#define GENERAL_PROTECTION   13
#define PAGE_FAULT           14
#define COPROCESSOR_ERROR    16

/*
 * IRQ exception identifiers.
 */

#define IRQ0  32
#define IRQ1  33
#define IRQ2  34
#define IRQ3  35
#define IRQ4  36
#define IRQ5  37
#define IRQ6  38
#define IRQ7  39
#define IRQ8  40
#define IRQ9  41
#define IRQ10 42
#define IRQ11 43
#define IRQ12 44
#define IRQ13 45
#define IRQ14 46
#define IRQ15 47

/*
 * Breakpoint.
 */

#define OPCODE_NOP             0x90
#define OPCODE_BREAKPOINT      0xCC
#define OPCODE_BREAKPOINT_SIZE 1

#endif /* _I386_H */

