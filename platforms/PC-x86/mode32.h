
//
// mode32.S - Protected-mode x86 32-bit driver.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

                .code16

                .sect   .init16,"ax"

                //
                // _start16 *MUST* be in the form:
                // CS:IP = XXXX:0000
                // (i.e., at the start of a real-mode segment)
                //

                .type   _start16,@function
                .global _start16
_start16:

                //
                // Protected mode driver.
                //
                cli                             // disable interrupts
                movw    %cs,%ax                 // DS = CS
                movw    %ax,%ds
#if defined(__i586__)
                movl    %cr0,%eax
                orl     $CR0_CD,%eax            // set cache disable
                andl    $~(CR0_NW),%eax         // disable write-back, enable write-through logic
                movl    %eax,%cr0
                wbinvd
#endif
                movl    %cr0,%eax               // disable paging
                andl    $~CR0_PG,%eax
                movl    %eax,%cr0
                xorl    %eax,%eax               // invalidate TLB
                movl    %eax,%cr3
                lgdt    gdtdsc32-_start16
                movl    %cr0,%eax
                orl     $CR0_PE,%eax            // turn on protected mode
                movl    %eax,%cr0
                // flush prefetch queue (invalidate old-mode already-decoded
                // instructions) and load code segment descriptor
                .extern _start
                ljmpl   $SELECTOR_KCODE,$_start

                .balign 2,0
gdtdsc32:       .word   3*8-1                   // bytes 0..1 GDT limit in bytes
                .long   gdt32                   // bytes 2..5 GDT linear base address

                .balign GDT_ALIGNMENT,0
gdt32:
                // selector index #0x00 invalid entry
                .quad   0
                // selector index #0x08 DPL0 32-bit 4GB 4k code RX @ 0x0
                .word   LIMITL(SELECTOR_KCODE_LIMIT)
                .word   BASEL(SELECTOR_KCODE_BASE)
                .byte   BASEM(SELECTOR_KCODE_BASE)
                .byte   SEG_PRESENT|SEG_PL0|SEG_CODE_DATA|CODE_ER
                .byte   SEG_GRAN4k|SEG_OP32|SEG_32|LIMITH(SELECTOR_KCODE_LIMIT)
                .byte   BASEH(SELECTOR_KCODE_BASE)
                // selector index #0x10 DPL0 32-bit 4GB 4k data RW @ 0x0
                .word   LIMITL(SELECTOR_KDATA_LIMIT)
                .word   BASEL(SELECTOR_KDATA_BASE)
                .byte   BASEM(SELECTOR_KDATA_BASE)
                .byte   SEG_PRESENT|SEG_PL0|SEG_CODE_DATA|DATA_RW
                .byte   SEG_GRAN4k|SEG_OP32|SEG_32|LIMITH(SELECTOR_KDATA_LIMIT)
                .byte   BASEH(SELECTOR_KDATA_BASE)

