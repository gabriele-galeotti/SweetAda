
ENTRY(_start)

MEMORY
{
        RAM : ORIGIN = 0x01000000, LENGTH = 0x8000
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
                *(COMMON)
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     : { *(.debug_info) }
        .debug_abbrev   : { *(.debug_abbrev) }
        .debug_aranges  : { *(.debug_aranges) }
        .debug_frame    : { *(.debug_frame) }
        .debug_line     : { *(.debug_line) }
        .debug_line_str : { *(.debug_line_str) }
        .debug_loclists : { *(.debug_loclists) }
        .debug_macro    : { *(.debug_macro) }
        .debug_names    : { *(.debug_names) }
        .debug_rnglists : { *(.debug_rnglists) }
        .debug_str      : { *(.debug_str) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(.comment)
                *(.ARM.exidx*)
                *(.ARM.extab*)
        }
}

