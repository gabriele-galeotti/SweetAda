
ENTRY(_start)

MEMORY
{
/*
 * With dBUG, user code may start at 0x40020000 (as dBUG "help" command
 * output says), but we start at 0x40100000 (MiB-boundary for VBR alignment
 * reasons).
 */
        /* vectorarea (RWX) : ORIGIN = 0x40100000, LENGTH = 0x00000400 */
        /* code       (RWX) : ORIGIN = 0x40100400, LENGTH = 0x00003C00 */
        SDRAM  (RWX) : ORIGIN = 0x40100000, LENGTH = 0x00100000 /* 32M - 0x100000 */
        RAMBAR (RWX) : ORIGIN = 0x80000000, LENGTH = 32k
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /* dummy initializations
        .vectorarea: { } > vectorarea
        .code:       { } > code
        .sdram:      { } > SDRAM
        */
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /*
        .vectors :
        {
                *(.vectors)
                . = ALIGN(0x10);
        } > SDRAM
        */
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .text :
        {
                *(.vectors)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                . = ALIGN(0x10);
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .data :
        {
                *(.data)
                *(.data.*)
                . = ALIGN(0x10);
                *(.sdata)
                . = ALIGN(0x10);
                __SDA_BASE = .;
                . = ALIGN(0x10);
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .bss :
        {
                _sbss = .;
                *(.bss)
                *(.bss.*)
                *(COMMON)
                . = ALIGN(0x10);
                _ebss = .;
        } > SDRAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        .debug_info     0 : { *(.debug_info) }
        .debug_abbrev   0 : { *(.debug_abbrev) }
        .debug_aranges  0 : { *(.debug_aranges) }
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

