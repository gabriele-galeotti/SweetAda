
ENTRY(_start)

MEMORY
{
        ROM : ORIGIN = 0x20000000, LENGTH = 0x4000000
        RAM : ORIGIN = 0x80000000, LENGTH = 1M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                *(.text)
                *(.text.*)
                *(.vectors)
                *(.rodata)
                *(.rodata.*)
                *(.srodata)
                *(.srodata.*)
                *(.riscv.attributes)
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(0x10);
                _etext = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.sdata)
                *(.sdata.*)
                *(.sdata2)
                *(.sdata2.*)
                . = ALIGN(0x10);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(.sbss)
                *(.sbss.*)
                *(COMMON)
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     : { *(.debug_info) }
        .debug_abbrev   : { *(.debug_abbrev) }
        .debug_aranges  : { *(.debug_aranges) }
        .debug_line     : { *(.debug_line) }
        .debug_line_str : { *(.debug_line_str) }
        .debug_ranges   : { *(.debug_ranges) }
        .debug_rnglists : { *(.debug_rnglists) }
        .debug_str      : { *(.debug_str) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

