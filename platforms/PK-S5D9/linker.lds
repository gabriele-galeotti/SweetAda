
ENTRY(_start)

MEMORY
{
        SRAMHS : ORIGIN = 0x1FFE0000, LENGTH = 128k
        SRAM0  : ORIGIN = 0x20000000, LENGTH = 256k /* 1st 32 kB are under ECC */
        SRAM1  : ORIGIN = 0x20040000, LENGTH = 256k
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
        } > SRAM0
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .ARM.extab :
        {
                *(.ARM.extab*)
                *(.gnu.linkonce.armextab.*)
        } > SRAM0
        .ARM.exidx :
        {
                __exidx_start = .;
                *(.ARM.exidx*)
                *(.gnu.linkonce.armexidx.*)
                __exidx_end = .;
        } > SRAM0
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
        } > SRAM0
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
        } > SRAM0
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     0 : { *(.debug_info) }
        .debug_abbrev   0 : { *(.debug_abbrev) }
        .debug_aranges  0 : { obj/startup.o(.debug_aranges) *(.debug_aranges) }
        .debug_frame    0 : { *(.debug_frame) }
        .debug_line     0 : { *(.debug_line) }
        .debug_line_str 0 : { *(.debug_line_str) }
        .debug_loclists 0 : { *(.debug_loclists) }
        .debug_macro    0 : { *(.debug_macro) }
        .debug_names    0 : { *(.debug_names) }
        .debug_rnglists 0 : { *(.debug_rnglists) }
        .debug_str      0 : { *(.debug_str) }
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(*)
        }
}

