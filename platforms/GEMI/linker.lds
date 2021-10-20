
ENTRY(_start)

MEMORY
{
        ROM : ORIGIN = 0x00000000, LENGTH = 128K
        /* RAM : ORIGIN = 0x0FFFE000 LENGTH = 8K */ /* internal RAM */
        RAM : ORIGIN = 0x0A000000, LENGTH = 256K /* external RAM */
}

SECTIONS
{
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        _text_start = .;
        .text : AT(_text_start)
        {
                _stext = .;
                KEEP(*(.vectors))
                *(.startup)
                *(.text)
                *(.text.*)
                *(.rodata)
                *(.rodata.*)
                *(.got1)
                *(.eh_frame)
                . = ALIGN(0x10);
                _etext = .;
        } > ROM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        _data_start = _text_start + SIZEOF(.text);
        .data : AT(_data_start)
        {
                _sdata = .;
                *(.data)
                *(.data.*)
                *(.sdata)
                *(.sdata.*)
                _sdata2 = .;
                *(.sdata2)
                *(.got.plt)
                *(.got)
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
                *(.sbss)
                *(.sbss.*)
                *(.scommon)
                *(.dynbss)
                . = ALIGN(0x10);
                _ebss = .;
        } > RAM
        /**********************************************************************
         *                                                                    *
         **********************************************************************/
        /DISCARD/ :
        {
                *(.comment)
        }
}

