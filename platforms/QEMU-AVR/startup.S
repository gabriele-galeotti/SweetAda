
//
// startup.S - QEMU-AVR startup.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#define RAMPZ  0x3B
#define SPL    0x3D
#define SPH    0x3E
#define RAMEND 0x8FF

////////////////////////////////////////////////////////////////////////////////

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                //
                // Setup stack pointer.
                //
                ldi     r16,lo8(RAMEND)         // load low byte of RAMEND into r16
                out     SPL,r16                 // store r16 in stack pointer low
                ldi     r16,hi8(RAMEND)         // load high byte of RAMEND into r16
                out     SPH,r16                 // store r16 in stack pointer high

#if __AVR_ENHANCED__ == 1
                //
                // .data ROM -> RAM relocation.
                //
                ldi     r17,hi8(_edata)
                ldi     r26,lo8(_sdata)         // X = _sdata
                ldi     r27,hi8(_sdata)
                ldi     r30,lo8(_etext)         // Z = _etext
                ldi     r31,hi8(_etext)
                ldi     r16,hh8(_etext)
                rjmp    2f
1:              lpm     r0,Z+
                st      X+,r0
2:              cpi     r26,lo8(_edata)
                cpc     r27,r17                 // r17 = hi8(_edata)
                brne    1b
#endif

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main

dead:           jmp     .

                .size   _start,.-_start

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

