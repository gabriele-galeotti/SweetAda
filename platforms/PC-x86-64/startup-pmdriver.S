
//
// startup-pmdriver.S - Protected-mode x86 driver.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
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
                movl    %eax,%ebx               // save BIST
                movl    %cs,%eax                // DS = CS
                movl    %eax,%ds
#if 1
                movl    %cr0,%eax
                orl     $(CR0_CD|CR0_NW),%eax   // disable cache memory and write-through logic
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

                .align  GDT_ALIGNMENT,0
gdtdsc32:       .word   3*8-1                   // bytes 0..1 GDT limit in bytes
                .long   gdt32                   // bytes 2..5 GDT linear base address
                .align  GDT_ALIGNMENT,0
gdt32:          .quad   0x0000000000000000      // selector #0x00 invalid entry
                .quad   0x00CF9A000000FFFF      // selector #0x08 DPL0 32-bit 4GB 4k code r/e @ 0x0
                .quad   0x00CF92000000FFFF      // selector #0x10 DPL0 32-bit 4GB 4k data r/w @ 0x0

