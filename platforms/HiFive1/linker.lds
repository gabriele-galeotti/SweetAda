
ENTRY(_start)

MEMORY
{
        itim       (ARX) : ORIGIN = 0x08000000, LENGTH = 8k
        flash-qspi (RX)  : ORIGIN = 0x20010000, LENGTH = 0x6A120
        dtim       (ARW) : ORIGIN = 0x80000000, LENGTH = 16k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.srodata)
                *(.srodata.*)
                . = ALIGN(0x10);
                _etext = .;
        } > itim
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
        } > dtim
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
        } > dtim
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

