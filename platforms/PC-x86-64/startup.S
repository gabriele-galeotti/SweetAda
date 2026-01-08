
//
// startup.S - Low-level startup.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <x86-64.h>
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

                .code64

                .sect   .startup,"ax"

                .type   _start,@function
                .global _start
_start:

                .code32

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

                //
                // Check for BSP or AP.
                //
                movl    $0x1B,%ecx
                rdmsr
                testl   $(1<<8),%eax
                jne     2f
1:              hlt
                jmp     1b
2:

#if defined(ENABLE_A20)
                //
                // Enable A20 line.
                //
                fcall   reset_8042
                movb    $0xD1,%al               // Write Output Port: next byte written to port 60h is placed in the 8042 output port
                outb    %al,$0x64
                fcall   reset_8042
                movb    $0xDF,%al               // A20 line on
                outb    %al,$0x60
                fcall   reset_8042
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

#if defined(STARTUP_MEMORY)
# include "startup-memory.h"
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
                // Enter 64-bit mode setup.
                //
                jmp     _start64

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

#if defined(ENABLE_A20)
////////////////////////////////////////////////////////////////////////////////
// reset_8042                                                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////

reset_8042:     movl    %esp,%ebp               // save return address
1:              movl    $10,%ecx                // 1 ms delay
                fcall   delay
                inb     $0x64,%al               // status port
                testb   $1,%al                  // data present?
                jz      2f
                movl    $10,%ecx                // 1 ms delay
                fcall   delay
                inb     $0x60,%al               // flush data
                jmp     1b
2:              testb   $2,%al                  // is input buffer full?
                jnz     1b                      // yes, loop again
                movl    %ebp,%esp
                fret
#endif

////////////////////////////////////////////////////////////////////////////////
// delay                                                                      //
//                                                                            //
// 100 us delay * ECX                                                         //
// PIT timer input frequency: 1.193182 MHz, t = 0.838 us                      //
// 100 us --> count = 119.33 = 0x77 (0x76 because the timer counts N + 1)     //
// COUNTER0, MODE 0, INTERRUPT ON TERMINAL COUNT, monitor OUT pin             //
////////////////////////////////////////////////////////////////////////////////

delay:          movw    $0x43,%dx               // CONTROL_WORD_REGISTER
                movb    $30,%al                 // COUNTER0, CNT_BOTH_BYTE, MODE0, COUNT_BINARY
                outb    %al,%dx
                // 100 us timing
                movw    $0x40,%dx
                movb    $0x76,%al
                outb    %al,%dx
                movb    $0x00,%al
                outb    %al,%dx
                // read-back OUT state
1:              movw    $0x43,%dx               // CONTROL_WORD_REGISTER
                movb    $0xE2,%al               // LATCH STATUS
                outb    %al,%dx
                movw    $0x40,%dx               // read STATUS from COUNTER0
                inb     %dx,%al
                testb   $0x80,%al               // OUT is active?
                jne     1b
                loop    delay
                fret

////////////////////////////////////////////////////////////////////////////////

_start64:

#if defined(MODE64)
# include "mode64.h"
#endif

////////////////////////////////////////////////////////////////////////////////

                .code64

                .global _longmode
_longmode:

                cli
                cld
                xorq    %rax,%rax
                xorq    %rbx,%rbx
                xorq    %rcx,%rcx
                xorq    %rdx,%rdx
                xorq    %rbp,%rbp
                xorq    %rsi,%rsi
                xorq    %rdi,%rdi

                //
                // Setup segments. In 64-bit Long Mode DS,ES,SS are not used.
                //
                movw    $SELECTOR_KDATA64,%ax
                movw    %ax,%fs
                movw    %ax,%gs

                //
                // Setup stack pointer.
                //
                movq    $kernel_stack,%rsp
                movq    %rsp,%rbp

#if defined(SSE_ENABLE)
                //
                // Enable SSE.
                //
                movq    %cr0,%rax
                andw    $~(1<<2),%ax            // clear CR0.EM
                orw     $(1<<1),%ax             // set CR0.MP
                movq    %rax,%cr0
                movq    %cr4,%rax
                orw     $(3<<9),%ax             // set CR4.OSFXSR and CR4.OSXMMEXCPT
                movq    %rax,%cr4
#endif

smpboot:
                //
                // IPI broadcast INIT, all-except-self
                //
                movl    $0x000C4500,%eax
                movl    %eax,0xFEE00300
                //
                // IPI broadcast Startup, all-except-self
                //
                movl    $(0x000C4600|(AP_ENTRYPOINT>>12)),%eax
                movl    %eax,0xFEE00300

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

                .balign 8
                .space  KERNEL_STACK_SIZE
kernel_stack:

