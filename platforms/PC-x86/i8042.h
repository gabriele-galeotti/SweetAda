
                // input buffer status (0 = empty, 1 = full)
                .macro  KBDIBUFRDY
                movw    $0x64,%dx
1:              inb     %dx,%al
                testb   $0x2,%al
                jnz     1b
                .endm

                // output buffer status (0 = empty, 1 = full)
                .macro  KBDOBUFRDY
                movw    $0x64,%dx
1:              inb     %dx,%al
                testb   $0x1,%al
                jz      1b
                .endm

kbd_init:
                // flush OBUF
                inb     $0x60,%al
                // self-test
                movw    $0x64,%dx
                movb    $0xAA,%al
                outb    %al,%dx
                KBDIBUFRDY
                KBDOBUFRDY
                movw    $0x60,%dx
                inb     %dx,%al
                cmpb    $0x55,%al
                jne     .
                // interface test
                movw    $0x64,%dx
                movb    $0xAB,%al
                outb    %al,%dx
                KBDIBUFRDY
                KBDOBUFRDY
                movw    $0x60,%dx
                inb     %dx,%al
                cmpb    $0x00,%al
                jne     .
                // keyboard reset
                movw    $0x64,%dx
                movb    $0x60,%al
                outb    %al,%dx
                KBDIBUFRDY
                movw    $0x60,%dx
                movb    $0x60,%al
                outb    %al,%dx
                KBDIBUFRDY
                movw    $0x60,%dx
                movb    $0xFF,%al
                outb    %al,%dx
                KBDIBUFRDY
                KBDOBUFRDY
                movw    $0x60,%dx
                inb     %dx,%al
                cmpb    $0xFA,%al
                jne     .
                fret

