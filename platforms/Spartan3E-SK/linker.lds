
ENTRY(_start)

MEMORY
{
        VECTORS : ORIGIN = 0x00000000, LENGTH = 8
        LMB     : ORIGIN = 0x00000050, LENGTH = 0x1FB0
        RAM     : ORIGIN = 0x50000000, LENGTH = 1M
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .vectors :
        {
                KEEP(*(.vectors))
        } > VECTORS
        /*
        .vectors : AT(_etext)
        {
                KEEP(*(.vectors))
        } > LMB
        */
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
                *(.gnu.linkonce.t.*)
                *(.gnu.linkonce.r.*)
                . = ALIGN(0x10);
                _etext = .;
        } > LMB
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.gnu.linkonce.d.*)
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
                *(.gnu.linkonce.b.*)
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
        }
}

