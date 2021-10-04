
//
// startup.S - Arduino Uno startup.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
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

                //
                // .data ROM -> RAM relocation.
                //
                ldi     r17,hi8(_edata)
                ldi     r26,lo8(_sdata)
                ldi     r27,hi8(_sdata)
                ldi     r30,lo8(_etext)
                ldi     r31,hi8(_etext)
#if defined(__AVR_ENHANCED__)
                ldi     r16,hh8(_etext)
#else
                ldi     r16,hh8(_etext-0x10000)
1:
                inc     r16
#endif
                rjmp    3f
2:
#if defined(__AVR_ENHANCED__)
                elpm    r0,Z+
#else
                elpm
#endif
                st      X+,r0
#if !defined(__AVR_ENHANCED__)
                adiw    r30,1
                brcs    1b
#endif
3:
                cpi     r26,lo8(_edata)
                cpc     r27,r17                 // r17 = hi8(_edata)
                brne    2b

                //
                // Call "adainit" procedure.
                //
                .extern adainit
                call    adainit

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

