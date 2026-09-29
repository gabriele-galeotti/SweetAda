
//
// Winbond W83977TF setup.
//

#define EFER 0x03F0
#define EFIR 0x03F0
#define EFDR 0x03F1
#define CR02 0x02       // Soft Reset
#define CR07 0x07       // index
#define CR20 0x20       // Device ID
#define CR21 0x21       // Device Rev

                //
                // Enter configuration mode.
                //
                movw    $EFER,%dx
                movb    $0x87,%al
                outb    %al,%dx
                outb    %al,%dx

                //
                // Soft reset.
                //
                movw    $EFIR,%dx
                movb    $CR02,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x01,%al
                outb    %al,%dx
                movb    $0x00,%al
                outb    %al,%dx

                //
                // Device 1: PPI.
                //
                movw    $EFIR,%dx
                movb    $CR07,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x01,%al
                outb    %al,%dx
                // address 0x0378
                movw    $EFIR,%dx
                movb    $0x60,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x03,%al
                outb    %al,%dx
                movw    $EFIR,%dx
                movb    $0x61,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x78,%al
                outb    %al,%dx
                // activate
                movw    $EFIR,%dx
                movb    $0x30,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x01,%al
                outb    %al,%dx

                //
                // Device 5: KBD.
                //
                movw    $EFIR,%dx
                movb    $0x07,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x05,%al
                outb    %al,%dx
                // address 0x0060
                movw    $EFIR,%dx
                movb    $0x60,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x00,%al
                outb    %al,%dx
                movw    $EFIR,%dx
                movb    $0x61,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x60,%al
                outb    %al,%dx
                // address 0x0064
                movw    $EFIR,%dx
                movb    $0x62,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x00,%al
                outb    %al,%dx
                movw    $EFIR,%dx
                movb    $0x63,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x64,%al
                outb    %al,%dx
                // activate
                movw    $EFIR,%dx
                movb    $0x30,%al
                outb    %al,%dx
                movw    $EFDR,%dx
                movb    $0x01,%al
                outb    %al,%dx

                //
                // Exit configuration mode.
                //
                movw    $EFER,%dx
                movb    $0xAA,%al
                outb    %al,%dx

