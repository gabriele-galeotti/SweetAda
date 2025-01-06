
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <i386.h>
#include <selectors.h>
#include <configure.h>

////////////////////////////////////////////////////////////////////////////////

                // macros for calling code without using the stack

                .macro  fcall address
                movl    $Lfcall\@,%esp
                jmp     \address
Lfcall\@:       // next instruction
                .endm

                .macro  fret
                jmp     *%esp
                .endm

////////////////////////////////////////////////////////////////////////////////

#if defined(MODE32)
# include "mode32.h"
#endif

////////////////////////////////////////////////////////////////////////////////

                .code32

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                cli
                cld

                //
                // Setup segments.
                //
                movw    $SELECTOR_KDATA,%ax
                movw    %ax,%ds                 // DS=ES=FS=GS=SS
                movw    %ax,%es
                movw    %ax,%fs
                movw    %ax,%gs
                movw    %ax,%ss

                // disable cache
#define IA32_MTRR_DEF_TYPE 0x2FF
                xorl    %eax,%eax
                xorl    %edx,%edx
                movl    $IA32_MTRR_DEF_TYPE,%ecx
                wrmsr

////////////////////////////////////////////////////////////////////////////////

#if defined(STARTUP_MEMORY)
# include "startup-memory.h"
#endif

////////////////////////////////////////////////////////////////////////////////

                jmp     post_kbdinit
#include "i8042.h"
post_kbdinit:
                //
                // Initialize 8042 keyboard controller.
                //
                fcall   kbd_init
#if defined(ENABLE_A20)
                //
                // Enable A20 line.
                //
                // write i8042 output port
                movb    $0xD1,%al
                outb    %al,$0x64
                KBDIBUFRDY
                // A20 line on
                movb    $0xDF,%al
                outb    %al,$0x60
                KBDIBUFRDY
                // check if enabled:
                // keep writing (different!) values in 0x000000, reading
                // from 0x100000; when the value differs we are ok
                xorl    %eax,%eax
1:              movl    %eax,%ebx               // save EAX, fcall will clobber the register
                movl    $100,%ecx               // 10 ms delay
                fcall   delay
                movl    %ebx,%eax               // restore EAX
                incl    %eax
                movl    %eax,0x000000
                cmpl    %eax,0x100000
                je      1b
#endif

#if defined(CODE_RELOC)
                fcall   movcode
#endif
#if defined(DATA_RELOC)
                fcall   movdata
#endif

                //
                // Initialize .bss section.
                //
                fcall   zerobss

                //
                // Setup stack pointer.
                //
                movl    $kernel_stack,%esp

                //
                // Setup a null stack frame.
                //
                xorl    %ebp,%ebp

                //
                // FPU initialization.
                //
                finit

                //
                // Jump to high-level code.
                //
                .extern _ada_main
                call    _ada_main

dead:           jmp     .

                .size   _start,.-_start

#if defined(CODE_RELOC)
////////////////////////////////////////////////////////////////////////////////
// movcode                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movcode:
                .extern _text_start
                .extern _stext
                .extern _etext
                movl    $_stext,%edi
                movl    $_etext,%ecx
                subl    %edi,%ecx
                movl    $_text_start,%esi
            rep movsb
                fret
#endif

#if defined(DATA_RELOC)
////////////////////////////////////////////////////////////////////////////////
// movdata                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

movdata:
                .extern _etext
                .extern _sdata
                .extern _edata
                movl    $_sdata,%edi
                movl    $_edata,%ecx
                subl    %edi,%ecx
                movl    $_etext,%esi
            rep movsb
                fret
#endif

////////////////////////////////////////////////////////////////////////////////
// zerobss                                                                    //
//                                                                            //
// This function does not need a stack.                                       //
////////////////////////////////////////////////////////////////////////////////

zerobss:
                .extern _sbss
                .extern _ebss
                xorb    %al,%al
                movl    $_sbss,%edi
                movl    $_ebss,%ecx
                subl    %edi,%ecx
            rep stosb
                fret

////////////////////////////////////////////////////////////////////////////////
// delay                                                                      //
//                                                                            //
// 300 us delay * ECX                                                         //
// PIT timer input frequency: 1.193182 MHz, t = 0.838 us                      //
// 100 us --> count = 119.33 = 0x77 (0x76 because the timer counts N + 1)     //
// COUNTER0, MODE 0, INTERRUPT ON TERMINAL COUNT, monitor COUNT               //
////////////////////////////////////////////////////////////////////////////////

#define PITCOUNT 0x0076

delay:
                movb    $0x30,%al               // COUNTER0, CNT_BOTH_BYTE, MODE0, COUNT_BINARY
                outb    %al,$0x43
                // 100 us timing
                movb    $(PITCOUNT&0xFF),%al
                outb    %al,$0x40
                movb    $(PITCOUNT>>8),%al
                outb    %al,$0x40
                // read-back
1:              movb    $0xD2,%al               // LATCH COUNT
                outb    %al,$0x43
                inb     $0x40,%al               // read COUNTL from COUNTER0
                movb    %al,%bl
                inb     $0x40,%al               // read COUNTH from COUNTER0
                movb    %al,%bh
                cmpw    $0,%bx
                jg      1b
                loop    delay
                fret

////////////////////////////////////////////////////////////////////////////////

                .sect   .data

////////////////////////////////////////////////////////////////////////////////

                .sect   .bss

                .balign 8
                .space  KERNEL_STACK_SIZE
kernel_stack:

