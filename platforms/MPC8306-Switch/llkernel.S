
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <e300.h>
#include <mpc83xx.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectortable,"ax"

#if defined(USE_INTERRUPTS)

//
// Interrupt vector table.
// Table 5-2. Interrupts and Exception Conditions
//
ivtable:
                // System reset
                . = 0x0100
                // Machine check
                . = 0x0200
                // DSI
                . = 0x0300
                // ISI
                . = 0x0400
                // External interrupt
                . = 0x0500
                b       EXTINT_handler
                // Alignment
                . = 0x0600
                // Program
                . = 0x0700
                // Floating-point unavailable
                . = 0x0800
                // Decrementer
                . = 0x0900
                // Critical interrupt
                . = 0x0A00
                // Reserved
                . = 0x0C00
                // System call
                . = 0x0C00
                // Trace
                . = 0x0D00
                // Reserved
                . = 0x0E00
                // Performance monitor
                . = 0x0F00
                // Instruction translate miss
                . = 0x1000
                // Data load translate miss
                . = 0x1100
                // Data store translate miss
                . = 0x1200
                // Instruction address breakpoint
                . = 0x1300
                // System management interrupt
                . = 0x1400

EXTINT_handler:

#endif

