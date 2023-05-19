
ENTRY(_start16)

MEMORY
{
        RAM : ORIGIN = 0x00000000, LENGTH = 256k
        ROM : ORIGIN = 0x00040000, LENGTH = 256k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .init : AT(ORIGIN(ROM))
        {
                *(.init16)
                . = ALIGN(0x10);
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                _stext = .;
                . = ALIGN(0x10);
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.gnu.linkonce.t.*)
                *(.gnu.linkonce.r.*)
                . = ALIGN(0x4);
                PROVIDE(_debug_flag = .);
                BYTE(0x00);
                . = ALIGN(0x10);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data : AT(_etext)
        {
                _sdata = .;
                . = ALIGN(0x10);
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
                *(.eh_frame)
        }
}

