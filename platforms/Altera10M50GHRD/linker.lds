
ENTRY(_start)

MEMORY
{
        /* RAM is @ 0x08000000, memory is aliased @ 0xC0000000 */
        RAM (RWX) : ORIGIN = 0xC8000000, LENGTH = 128M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text : ALIGN(4)
        {
                _stext = .;
                KEEP(*(.vectors))
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                . = ALIGN(4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(16);
                _etext = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : ALIGN(16)
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.sdata)
                _gp = ALIGN(4) + 0x7FF0;
                *(.sdata.*)
                . = ALIGN(16);
                _edata = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss ADDR(.data) + SIZEOF(.data) (NOLOAD) : ALIGN(16)
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
        .debug_ranges   : { *(.debug_ranges) }
        .debug_line     : { *(.debug_line) }
        .debug_str      : { *(.debug_str) }
        .debug_line_str : { *(.debug_line_str) }
        .debug_rnglists : { *(.debug_rnglists) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

