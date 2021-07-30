
//
// pmdriver.S - Protected-mode x86 driver.
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
#if defined(__i586__)
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
                //
                // Intel 80386 Reference Programmer''s Manual
                // 17.2 Instruction Format "m16 & 32"
                // LGDT/LIDT -- Load Global/Interrupt Descriptor Table Register
                // LGDT, prefixed with 0x66, specifies a 32-bit operand, where
                // "operand" is the structure pointed to (the GDT), not the
                // address encoded in the instruction. Note that LGDT supports
                // only "m16 & 32" addressing, so it is not possible to load
                // the GDT by means of a relative address, or an address
                // specified in a register.
                //
                lgdtl   %cs:((gdtdsc32-_start16)&0xFFFF)  // avoid problems with 16-bit relocations
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

