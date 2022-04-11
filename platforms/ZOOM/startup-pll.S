
                //
                // Enter LIMP mode, program the PLL, and return back
                // to normal "PLL drives internal clocks".
                //
                // Peripheral bus clock frequency is fsys/3.
                // Warning! SDRAM will be unprogrammed!
                //
                move.w  #0x10F1,%d0                     // enable LIMP mode
                move.w  %d0,MISCCR
                move.b  #0x26,%d0                       // 7.2.1 must be fixed at 0x26
                move.b  %d0,MCF_CLOCK_PODR
                move.b  #CLOCK_MULTIPLIER,%d0
                move.b  %d0,MCF_CLOCK_PFDR
                move.b  #0,%d0
                move.b  %d0,MCF_CLOCK_PCR
                move.w  #0x00F1,%d0                     // exit from LIMP mode
                move.w  %d0,MISCCR
1:              move.w  MISCCR,%d0                      // wait for PLL lock
                andi.l  #0x2000,%d0
                beq.b   1b
                nop
                nop
                nop
                nop

