
//
// mode64.S - Protected-mode x86 64-bit driver.
//
// Copyright (C) 2020, 2021, 2022 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

////////////////////////////////////////////////////////////////////////////////

                .code32

                //
                // Setup data segments.
                //
                movw    $SELECTOR_KDATA,%ax
                movw    %ax,%ds
                movw    %ax,%es

                //
                // In 64-bit Long Mode, every page table holds 512 8-byte entries.
                //
                // 1 PT holds 512 4k entries, 512 * 4k = 2 MB address space
                // 1 PDT holds 512 PT entries, 512 * 2 MB = 1 GB address space
                // 1 PDPT holds 512 PDT entries, 512 * 1 GB = 512 GB address space
                // 1 PML4T holds 512 PDPT entries, 512 * 512 GB = 256 TB address space
                //

                //
                // PML4T
                // Clear table and make first entry points to a PDPT page.
                //
                movl    $pml4t,%edx
                movl    %edx,%edi               // EDI --> PML4T
                movl    $0x0400,%ecx            // clear 0x1000 bytes = 0x400 32-bit words
                xorl    %eax,%eax
            rep stosl
                movl    %edx,%edi               // EDI --> PML4T
                movl    $pdpt,%eax
                andl    $0xFFFFF000,%eax
                orl     $0x3,%eax               // PAGE_PRESENT|PAGE_WRITE
                movl    %eax,(%edi)

                //
                // PDPT
                // Clear table and make first entry points to a PDT page.
                //
                movl    $pdpt,%edx
                movl    %edx,%edi               // EDI --> PDPT
                movl    $0x0400,%ecx            // clear 0x1000 bytes = 0x400 32-bit words
                xorl    %eax,%eax
            rep stosl
                movl    %edx,%edi               // EDI --> PDPT
                movl    $pdt,%eax
                andl    $0xFFFFF000,%eax
                orl     $0x3,%eax               // PAGE_PRESENT|PAGE_WRITE
                movl    %eax,(%edi)

                //
                // PDT
                // Clear table and make first entry points to a PT page.
                //
                movl    $pdt,%edx
                movl    %edx,%edi               // EDI --> PDT
                movl    $0x0400,%ecx            // clear 0x1000 bytes = 0x400 32-bit words
                xorl    %eax,%eax
            rep stosl
                movl    %edx,%edi               // EDI --> PDT
                movl    $pt,%eax
                andl    $0xFFFFF000,%eax
                orl     $0x3,%eax               // PAGE_PRESENT|PAGE_WRITE
                movl    %eax,(%edi)

                //
                // PT
                // Clear table and map all 512 entries 1-1.
                // 1 page entry = 4 k (0x1000) --> 512 entries = 2 MB
                // PT size = 512 8-byte entries = 0x1000 bytes
                //
                movl    $pt,%edx
                movl    %edx,%edi               // EDI --> PT
                movl    $0x0400,%ecx            // clear 0x1000 bytes = 0x400 32-bit words
                xorl    %eax,%eax
            rep stosl
                movl    %edx,%edi               // EDI --> PT
                movl    $512,%ecx               // 512 entries
                movl    $0x3,%eax               // PAGE_PRESENT|PAGE_WRITE
1:              movl    %eax,(%edi)
                addl    $0x00001000,%eax        // next page address
                addl    $8,%edi                 // next entry
                loop    1b

                //
                // Enable PAE (required for 64-bit Long Mode) and PGE.
                //
                movl    %cr4,%eax
                orl     $(CR4_PAE|CR4_PGE),%eax
                movl    %eax,%cr4

                //
                // Enable Long Mode.
                //
                movl    $0xC0000080,%ecx        // select EFER MSR
                rdmsr
                orl     $(1<<8),%eax            // set LME
                wrmsr

                //
                // Enable paging, CR3 points to PML4T.
                //
                movl    $pml4t,%eax
                movl    %eax,%cr3
                movl    %cr0,%eax
                orl     $CR0_PG,%eax
                movl    %eax,%cr0

                //
                // Load GDT and jump to Long Mode code.
                //
                lgdtl   gdtdsc64
                .extern _longmode
                ljmpl   $SELECTOR_KCODE64,$_longmode

                .align  2,0
gdtdsc64:       .word   3*8-1                   // bytes 0..1 GDT limit in bytes
                .long   gdt64                   // bytes 2..5 GDT linear base address

                .align  GDT_ALIGNMENT,0
gdt64:
                // selector #0x00 invalid entry
                .quad   0
                // selector #0x08 DPL0 64-bit 4k code RX
                .word   LIMITL(SELECTOR_KCODE64_LIMIT)
                .word   BASEL(SELECTOR_KCODE64_BASE)
                .byte   BASEM(SELECTOR_KCODE64_BASE)
                .byte   SEG_PRESENT|SEG_PL0|SEG_CODE_DATA|CODE_ER
                .byte   SEG_GRAN4k|SEG_64|LIMITH(SELECTOR_KCODE64_LIMIT)
                .byte   BASEH(SELECTOR_KCODE64_BASE)
                // selector #0x10 DPL0 64-bit 4k data RW
                .word   LIMITL(SELECTOR_KDATA64_LIMIT)
                .word   BASEL(SELECTOR_KDATA64_BASE)
                .byte   BASEM(SELECTOR_KDATA64_BASE)
                .byte   SEG_PRESENT|SEG_PL0|SEG_CODE_DATA|DATA_RW
                .byte   SEG_GRAN4k|SEG_64|LIMITH(SELECTOR_KDATA64_LIMIT)
                .byte   BASEH(SELECTOR_KDATA64_BASE)

////////////////////////////////////////////////////////////////////////////////

                .pushsection .pagetables

                .align  4096

pml4t:          .space  0x1000

pdpt:           .space  0x1000

pdt:            .space  0x1000

pt:             .space  0x1000

                .popsection

////////////////////////////////////////////////////////////////////////////////

