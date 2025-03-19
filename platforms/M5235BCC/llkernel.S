
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .macro SAVE_REGISTERS
                lea     %sp@(-16),%sp           // space for 4 registers
                movem.l %d0-%d1/%a0-%a1,%sp@
                .endm

                .macro RESTORE_REGISTERS
                movem.l %sp@,%d0-%d1/%a0-%a1
                lea     %sp@(16),%sp            // space for 4 registers
                .endm

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .p2align 20

                .extern _start

                .global vectors_table
vectors_table:
                                                // #   offset
initialsp:      .long   0                       // 000 0x0000 -
initialpc:      .long   _start                  // 001 0x0004 -
accesserr:      .long   VH_accesserr            // 002 0x0008 -
addresserr:     .long   VH_addresserr           // 003 0x000C -
illinstr:       .long   VH_illinstr             // 004 0x0010 -
div0:           .long   VH_div0                 // 005 0x0014 -
reserved1:      .long   VH_default              // 006 0x0018 -
reserved2:      .long   VH_default              // 007 0x001C -
privilegev:     .long   VH_privilegev           // 008 0x0020 -
trace:          .long   VH_trace                // 009 0x0024 -
lineA:          .long   VH_lineA                // 010 0x0028 -
lineF:          .long   VH_lineF                // 011 0x002C -
debugint:       .long   VH_debugint             // 012 0x0030 -
reserved3:      .long   VH_default              // 013 0x0034 -
formaterr:      .long   VH_formaterr            // 014 0x0038 -
reserved4:      .long   VH_default              // 015 0x003C -
reserved5:      .long   VH_default              // 016 0x0040 -
reserved6:      .long   VH_default              // 017 0x0044 -
reserved7:      .long   VH_default              // 018 0x0048 -
reserved8:      .long   VH_default              // 019 0x004C -
reserved9:      .long   VH_default              // 020 0x0050 -
reserved10:     .long   VH_default              // 021 0x0054 -
reserved11:     .long   VH_default              // 022 0x0058 -
reserved12:     .long   VH_default              // 023 0x005C -
spuriousint:    .long   VH_spuriousint          // 024 0x0060 -
reserved13:     .long   VH_default              // 025 0x0064 -
reserved14:     .long   VH_default              // 026 0x0068 -
reserved15:     .long   VH_default              // 027 0x006C -
reserved16:     .long   VH_default              // 028 0x0070 -
reserved17:     .long   VH_default              // 029 0x0074 -
reserved18:     .long   VH_default              // 030 0x0078 -
reserved19:     .long   VH_default              // 031 0x007C -
trap0:          .long   VH_trap0                // 032 0x0080 -
trap1:          .long   VH_trap1                // 033 0x0084 -
trap2:          .long   VH_trap2                // 034 0x0088 -
trap3:          .long   VH_trap3                // 035 0x008C -
trap4:          .long   VH_trap4                // 036 0x0090 -
trap5:          .long   VH_trap5                // 037 0x0094 -
trap6:          .long   VH_trap6                // 038 0x0098 -
trap7:          .long   VH_trap7                // 039 0x009C -
trap8:          .long   VH_trap8                // 040 0x00A0 -
trap9:          .long   VH_trap9                // 041 0x00A4 -
trap10:         .long   VH_trap10               // 042 0x00A8 -
trap11:         .long   VH_trap11               // 043 0x00AC -
trap12:         .long   VH_trap12               // 044 0x00B0 -
trap13:         .long   VH_trap13               // 045 0x00B4 -
trap14:         .long   VH_trap14               // 046 0x00B8 -
trap15:         .long   VH_trap15               // 047 0x00BC -
reserved20:     .long   VH_default              // 048 0x00C0 -
reserved21:     .long   VH_default              // 049 0x00C4 -
reserved22:     .long   VH_default              // 050 0x00C8 -
reserved23:     .long   VH_default              // 051 0x00CC -
reserved24:     .long   VH_default              // 052 0x00D0 -
reserved25:     .long   VH_default              // 053 0x00D4 -
reserved26:     .long   VH_default              // 054 0x00D8 -
reserved27:     .long   VH_default              // 055 0x00DC -
reserved28:     .long   VH_default              // 056 0x00E0 -
reserved29:     .long   VH_default              // 057 0x00E4 -
reserved30:     .long   VH_default              // 058 0x00E8 -
reserved31:     .long   VH_default              // 059 0x00EC -
reserved32:     .long   VH_default              // 060 0x00F0 -
reserved33:     .long   VH_default              // 061 0x00F4 -
reserved34:     .long   VH_default              // 062 0x00F8 -
reserved35:     .long   VH_default              // 063 0x00FC -

// User Defined Vectors

                .long   VH_default              // 064 INTC0 0  Not implemented
                .long   VH_default              // 065 INTC0 1  EPORT    Edge port flag 1
                .long   VH_default              // 066 INTC0 2  EPORT    Edge port flag 2
                .long   VH_default              // 067 INTC0 3  EPORT    Edge port flag 3
                .long   VH_default              // 068 INTC0 4  EPORT    Edge port flag 4
                .long   VH_default              // 069 INTC0 5  EPORT    Edge port flag 5
                .long   VH_default              // 070 INTC0 6  EPORT    Edge port flag 6
                .long   VH_default              // 071 INTC0 7  EPORT    Edge port flag 7
                .long   VH_default              // 072 INTC0 8  SCM      Software watchdog timeout
                .long   VH_default              // 073 INTC0 9  DMA      DMA Channel 0 transfer complete
                .long   VH_default              // 074 INTC0 10 DMA      DMA Channel 1 transfer complete
                .long   VH_default              // 075 INTC0 11 DMA      DMA Channel 2 transfer complete
                .long   VH_default              // 076 INTC0 12 DMA      DMA Channel 3 transfer complete
                .long   VH_default              // 077 INTC0 13 UART0    UART0 interrupt
                .long   VH_default              // 078 INTC0 14 UART1    UART1 interrupt
                .long   VH_default              // 079 INTC0 15 UART2    UART2 interrupt
                .long   VH_default              // 080 INTC0 16 Not used
                .long   VH_default              // 081 INTC0 17 I2C      I2C interrupt
                .long   VH_default              // 082 INTC0 18 QSPI     QSPI interrupt
                .long   VH_default              // 083 INTC0 19 TMR0     TMR0 interrupt
                .long   VH_default              // 084 INTC0 20 TMR1     TMR1 interrupt
                .long   VH_default              // 085 INTC0 21 TMR2     TMR2 interrupt
                .long   VH_default              // 086 INTC0 22 TMR3     TMR3 interrupt
                .long   VH_default              // 087 INTC0 23 FEC      Transmit frame interrupt
                .long   VH_default              // 088 INTC0 24 FEC      Transmit buffer interrupt
                .long   VH_default              // 089 INTC0 25 FEC      Transmit FIFO underrun
                .long   VH_default              // 090 INTC0 26 FEC      Collision retry limit
                .long   VH_default              // 091 INTC0 27 FEC      Receive frame interrupt
                .long   VH_default              // 092 INTC0 28 FEC      Receive buffer interrupt
                .long   VH_default              // 093 INTC0 29 FEC      MII interrupt
                .long   VH_default              // 094 INTC0 30 FEC      Late collision
                .long   VH_default              // 095 INTC0 31 FEC      Heartbeat error
                .long   VH_default              // 096 INTC0 32 FEC      Graceful stop complete
                .long   VH_default              // 097 INTC0 33 FEC      Ethernet bus error
                .long   VH_default              // 098 INTC0 34 FEC      Babbling transmit error
                .long   VH_default              // 099 INTC0 35 FEC      Babbling receive error
                .long   VH_default              // 100 INTC0 36 PIT0     PIT interrupt flag
                .long   VH_default              // 101 INTC0 37 PIT1     PIT interrupt flag
                .long   VH_default              // 102 INTC0 38 PIT2     PIT interrupt flag
                .long   VH_default              // 103 INTC0 39 PIT3     PIT interrupt flag
                .long   VH_default              // 104 INTC0 40 RNG      RNG interrupt flag
                .long   VH_default              // 105 INTC0 41 SKHA     SKHA interrupt flag
                .long   VH_default              // 106 INTC0 42 MDHA     MDHA interrupt flag
                .long   VH_default              // 107 INTC0 43 FLEXCAN1 Message Buffer 0 Interrupt
                .long   VH_default              // 108 INTC0 44 FLEXCAN1 Message Buffer 1 Interrupt
                .long   VH_default              // 109 INTC0 45 FLEXCAN1 Message Buffer 2 Interrupt
                .long   VH_default              // 110 INTC0 46 FLEXCAN1 Message Buffer 3 Interrupt
                .long   VH_default              // 111 INTC0 47 FLEXCAN1 Message Buffer 4 Interrupt
                .long   VH_default              // 112 INTC0 48 FLEXCAN1 Message Buffer 5 Interrupt
                .long   VH_default              // 113 INTC0 49 FLEXCAN1 Message Buffer 6 Interrupt
                .long   VH_default              // 114 INTC0 50 FLEXCAN1 Message Buffer 7 Interrupt
                .long   VH_default              // 115 INTC0 51 FLEXCAN1 Message Buffer 8 Interrupt
                .long   VH_default              // 116 INTC0 52 FLEXCAN1 Message Buffer 9 Interrupt
                .long   VH_default              // 117 INTC0 53 FLEXCAN1 Message Buffer 10 Interrupt
                .long   VH_default              // 118 INTC0 54 FLEXCAN1 Message Buffer 11 Interrupt
                .long   VH_default              // 119 INTC0 55 FLEXCAN1 Message Buffer 12 Interrupt
                .long   VH_default              // 120 INTC0 56 FLEXCAN1 Message Buffer 13 Interrupt
                .long   VH_default              // 121 INTC0 57 FLEXCAN1 Message Buffer 14 Interrupt
                .long   VH_default              // 122 INTC0 58 FLEXCAN1 Message Buffer 15 Interrupt
                .long   VH_default              // 123 INTC0 59 FLEXCAN1 Error Interrupt
                .long   VH_default              // 124 INTC0 60 FLEXCAN1 Bus-Off Interrupt
                .long   VH_default              // 125 INTC0 61 Not used
                .long   VH_default              // 126 INTC0 62 Not used
                .long   VH_default              // 127 INTC0 63 Not used
                .long   VH_default              // 128 INTC1 0  Not implemented
                .long   VH_default              // 129 INTC1 1  Not used
                .long   VH_default              // 130 INTC1 2  Not used
                .long   VH_default              // 131 INTC1 3  Not used
                .long   VH_default              // 132 INTC1 4  Not used
                .long   VH_default              // 133 INTC1 5  Not used
                .long   VH_default              // 134 INTC1 6  Not used
                .long   VH_default              // 135 INTC1 7  Not used
                .long   VH_default              // 136 INTC1 8  FLEXCAN0 Message Buffer 0 Interrupt
                .long   VH_default              // 137 INTC1 9  FLEXCAN0 Message Buffer 1 Interrupt
                .long   VH_default              // 138 INTC1 10 FLEXCAN0 Message Buffer 2 Interrupt
                .long   VH_default              // 139 INTC1 11 FLEXCAN0 Message Buffer 3 Interrupt
                .long   VH_default              // 140 INTC1 12 FLEXCAN0 Message Buffer 4 Interrupt
                .long   VH_default              // 141 INTC1 13 FLEXCAN0 Message Buffer 5 Interrupt
                .long   VH_default              // 142 INTC1 14 FLEXCAN0 Message Buffer 6 Interrupt
                .long   VH_default              // 143 INTC1 15 FLEXCAN0 Message Buffer 7 Interrupt
                .long   VH_default              // 144 INTC1 16 FLEXCAN0 Message Buffer 8 Interrupt
                .long   VH_default              // 145 INTC1 17 FLEXCAN0 Message Buffer 9 Interrupt
                .long   VH_default              // 146 INTC1 18 FLEXCAN0 Message Buffer 10 Interrupt
                .long   VH_default              // 147 INTC1 19 FLEXCAN0 Message Buffer 11 Interrupt
                .long   VH_default              // 148 INTC1 20 FLEXCAN0 Message Buffer 12 Interrupt
                .long   VH_default              // 149 INTC1 21 FLEXCAN0 Message Buffer 13 Interrupt
                .long   VH_default              // 150 INTC1 22 FLEXCAN0 Message Buffer 14 Interrupt
                .long   VH_default              // 151 INTC1 23 FLEXCAN0 Message Buffer 15 Interrupt
                .long   VH_default              // 152 INTC1 24 FLEXCAN0 Error Interrupt
                .long   VH_default              // 153 INTC1 25 FLEXCAN0 Bus-Off Interrupt
                .long   VH_default              // 154 INTC1 26 Not used
                .long   VH_default              // 155 INTC1 27 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 156 INTC1 28 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 157 INTC1 29 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 158 INTC1 30 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 159 INTC1 31 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 160 INTC1 32 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 161 INTC1 33 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 162 INTC1 34 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 163 INTC1 35 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 164 INTC1 36 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 165 INTC1 37 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 166 INTC1 38 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 167 INTC1 39 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 168 INTC1 40 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 169 INTC1 41 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 170 INTC1 42 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 171 INTC1 43 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 172 INTC1 44 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 173 INTC1 45 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 174 INTC1 46 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 175 INTC1 47 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 176 INTC1 48 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 177 INTC1 49 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 178 INTC1 50 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 179 INTC1 51 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 180 INTC1 52 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 181 INTC1 53 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 182 INTC1 54 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 183 INTC1 55 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 184 INTC1 56 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 185 INTC1 57 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 186 INTC1 58 ETPU     ETPU channel interrupt flag
                .long   VH_default              // 187 INTC1 59 ETPU     ETPU global interrupt flag
                .long   VH_default              // 188 INTC1 60 Not used
                .long   VH_default              // 189 INTC1 61 Not used
                .long   VH_default              // 190 INTC1 62 Not used
                .long   VH_default              // 191 INTC1 63 Not used

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .extern exception_process
                .extern irq_process

VH_accesserr:
VH_addresserr:
VH_illinstr:
VH_div0:
VH_privilegev:
VH_trace:
VH_lineA:
VH_lineF:
VH_debugint:
VH_formaterr:
VH_spuriousint:
VH_trap0:
VH_trap1:
VH_trap2:
VH_trap3:
VH_trap4:
VH_trap5:
VH_trap6:
VH_trap7:
VH_trap8:
VH_trap9:
VH_trap10:
VH_trap11:
VH_trap12:
VH_trap13:
VH_trap14:
VH_trap15:
                jmp     exception_process

                .global VH_PIT0
VH_PIT0:
                SAVE_REGISTERS
                jsr     irq_process
                RESTORE_REGISTERS
                rte

VH_default:
                jmp     .

