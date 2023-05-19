
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
        .sdram:      { } > SDRAM */
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /*.vectors :
        {
                *(.vectors)
                . = ALIGN(0x10);
        } > SDRAM*/
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
                *(.bss)
                *(.bss.*)
                *(COMMON)
                . = ALIGN(0x10);
        } > SDRAM
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

