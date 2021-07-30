
/*
 * m68k.h - M680X0 architecture definitions.
 *
 * Copyright (C) 2020, 2021 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#ifndef _M68K_H
#define _M68K_H 1

/*
 * Exception/vector table.
 */

#define RESET_INITIAL_INTERRUPT_STACK_POINTER   0
#define RESET_INITIAL_PROGRAM_COUNTER           1
#define BUS_ERROR                               2
#define ADDRESS_ERROR                           3
#define ILLEGAL_INSTRUCTION                     4
#define ZERO_DIVIDE                             5
#define CHK_CHK2_INSTRUCTION                    6
#define CPTRAPCC_TRAPCC_TRAPV_INSTRUCTIONS      7
#define PRIVILEGE_VIOLATION                     8
#define TRACE                                   9
#define LINE_1010_EMULATOR                      10
#define LINE_1111_EMULATOR                      11
#define UNASSIGNED_RESERVED_1                   12
#define COPROCESSOR_PROTOCOL_VIOLATION          13
#define FORMAT_ERROR                            14
#define UNINITIALIZED_INTERRUPT                 15
#define UNASSIGNED_RESERVED_2                   16
#define UNASSIGNED_RESERVED_3                   17
#define UNASSIGNED_RESERVED_4                   18
#define UNASSIGNED_RESERVED_5                   19
#define UNASSIGNED_RESERVED_6                   20
#define UNASSIGNED_RESERVED_7                   21
#define UNASSIGNED_RESERVED_8                   22
#define UNASSIGNED_RESERVED_9                   23
#define SPURIOUS_INTERRUPT                      24
#define LEVEL1_INTERRUPT_AUTOVECTOR             25
#define LEVEL2_INTERRUPT_AUTOVECTOR             26
#define LEVEL3_INTERRUPT_AUTOVECTOR             27
#define LEVEL4_INTERRUPT_AUTOVECTOR             28
#define LEVEL5_INTERRUPT_AUTOVECTOR             29
#define LEVEL6_INTERRUPT_AUTOVECTOR             30
#define LEVEL7_INTERRUPT_AUTOVECTOR             31
#define TRAP_0                                  32
#define TRAP_1                                  33
#define TRAP_2                                  34
#define TRAP_3                                  35
#define TRAP_4                                  36
#define TRAP_5                                  37
#define TRAP_6                                  38
#define TRAP_7                                  39
#define TRAP_8                                  40
#define TRAP_9                                  41
#define TRAP_10                                 42
#define TRAP_11                                 43
#define TRAP_12                                 44
#define TRAP_13                                 45
#define TRAP_14                                 46
#define TRAP_15                                 47
#define FP_BRANCH_OR_SET_ON_UNORDERED_CONDITION 48
#define FP_INEXACT_RESULT                       49
#define FP_DIVIDE_BY_ZERO                       50
#define FP_UNDERFLOW                            51
#define FP_OPERAND_ERROR                        52
#define FP_OVERFLOW                             53
#define FP_SIGNALING_NAN                        54
#define FP_UNIMPLEMENTED_DATA_TYPE              55
#define MMU_CONFIGURATION_ERROR                 56
#define MMU_ILLEGAL_OPERATION_ERROR             57
#define MMU_ACCESS_LEVEL_VIOLATION_ERROR        58
#define UNASSIGNED_RESERVED_10                  59
#define UNASSIGNED_RESERVED_11                  60
#define UNASSIGNED_RESERVED_12                  61
#define UNASSIGNED_RESERVED_13                  62
#define UNASSIGNED_RESERVED_14                  63

#define TRACE_FRAME_SIZE 12
#define TRAP_FRAME_SIZE  8

/*
 * Status register.
 *
 */
#define FLAG_CARRY    (1 << 0)
#define FLAG_OVERFLOW (1 << 1)
#define FLAG_ZERO     (1 << 2)
#define FLAG_NEGATIVE (1 << 3)
#define FLAG_EXTEND   (1 << 4)
#define MBIT          (1 << 12)
#define SBIT          (1 << 13)
#define FLAG_T0       (1 << 14)
#define FLAG_T1       (1 << 15)

#define NOP_INSTRUCTION             0x4E71
#define BREAKPOINT_INSTRUCTION      0x4E4F /* TRAP #15 */
#define BREAKPOINT_INSTRUCTION_SIZE 2

#endif /* _M68K_H */

