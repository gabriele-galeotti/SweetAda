-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ k61.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package K61
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- K61P256M150SF3RM
   -- Rev. 4, 10/2015
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 3 Chip Configuration
   ----------------------------------------------------------------------------

   -- 3.2.2.3 Interrupt channel assignments

   -- ADDR = Address
   -- VECT = Vector
   -- IRQ  = IRQ
   -- nIPR = NVIC non-IPR register number
   -- IPR  = NVIC IPR register number
   -- SRC  = Source module
   -- DSC  = Source description
   --                                           ADDR            VECT    IRQ     nIPR    IPR     SRC                             DSC
   ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   IRQ_DMA_CH0TC   : constant := 0;   --        0x0000_0040     16      0       0       0       DMA                             DMA channel 0, 16 transfer complete
   IRQ_DMA_CH1TC   : constant := 1;   --        0x0000_0044     17      1       0       0       DMA                             DMA channel 1, 17 transfer complete
   IRQ_DMA_CH2TC   : constant := 2;   --        0x0000_0048     18      2       0       0       DMA                             DMA channel 2, 18 transfer complete
   IRQ_DMA_CH3TC   : constant := 3;   --        0x0000_004C     19      3       0       0       DMA                             DMA channel 3, 19 transfer complete
   IRQ_DMA_CH4TC   : constant := 4;   --        0x0000_0050     20      4       0       1       DMA                             DMA channel 4, 20 transfer complete
   IRQ_DMA_CH5TC   : constant := 5;   --        0x0000_0054     21      5       0       1       DMA                             DMA channel 5, 21 transfer complete
   IRQ_DMA_CH6TC   : constant := 6;   --        0x0000_0058     22      6       0       1       DMA                             DMA channel 6, 22 transfer complete
   IRQ_DMA_CH7TC   : constant := 7;   --        0x0000_005C     23      7       0       1       DMA                             DMA channel 7, 23 transfer complete
   IRQ_DMA_CH8TC   : constant := 8;   --        0x0000_0060     24      8       0       2       DMA                             DMA channel 8, 24 transfer complete
   IRQ_DMA_CH9TC   : constant := 9;   --        0x0000_0064     25      9       0       2       DMA                             DMA channel 9, 25 transfer complete.
   IRQ_DMA_CH10TC  : constant := 10;  --        0x0000_0068     26      10      0       2       DMA                             DMA channel 10, 26 transfer complete
   IRQ_DMA_CH11TC  : constant := 11;  --        0x0000_006C     27      11      0       2       DMA                             DMA channel 11, 27 transfer complete
   IRQ_DMA_CH12TC  : constant := 12;  --        0x0000_0070     28      12      0       3       DMA                             DMA channel 12, 28 transfer complete
   IRQ_DMA_CH13TC  : constant := 13;  --        0x0000_0074     29      13      0       3       DMA                             DMA channel 13, 29 transfer complete
   IRQ_DMA_CH14TC  : constant := 14;  --        0x0000_0078     30      14      0       3       DMA                             DMA channel 14, 30 transfer complete
   IRQ_DMA_CH15TC  : constant := 15;  --        0x0000_007C     31      15      0       3       DMA                             DMA channel 15, 31 transfer complete
   IRQ_DMA_ERROR   : constant := 16;  --        0x0000_0080     32      16      0       4       DMA                             DMA error interrupt channels 0-31
   IRQ_MCM_NORMAL  : constant := 17;  --        0x0000_0084     33      17      0       4       MCM                             Normal interrupt
   IRQ_FLSH_CMD    : constant := 18;  --        0x0000_0088     34      18      0       4       Flash memory                    Command complete
   IRQ_FLSH_RDCOLL : constant := 19;  --        0x0000_008C     35      19      0       4       Flash memory                    Read collision
   IRQ_MODEC_LOW   : constant := 20;  --        0x0000_0090     36      20      0       5       Mode Controller                 Low-voltage detect, low-voltage warning
   IRQ_LLWU_LOW    : constant := 21;  --        0x0000_0094     37      21      0       5       LLWU                            Low Leakage Wakeup
   IRQ_WDOG        : constant := 22;  --        0x0000_0098     38      22      0       5       WDOG                            Watchdog interrupt
   IRQ_RNG         : constant := 23;  --        0x0000_009C     39      23      0       5       RNG                             Randon Number Generator
   IRQ_I2C0        : constant := 24;  --        0x0000_00A0     40      24      0       6       I2C0                            —
   IRQ_I2C1        : constant := 25;  --        0x0000_00A4     41      25      0       6       I2C1                            —
   IRQ_SPI0        : constant := 26;  --        0x0000_00A8     42      26      0       6       SPI0                            Single interrupt vector for all sources
   IRQ_SPI1        : constant := 27;  --        0x0000_00AC     43      27      0       6       SPI1                            Single interrupt vector for all sources
   IRQ_SPI2        : constant := 28;  --        0x0000_00B0     44      28      0       7       SPI2                            Single interrupt vector for all sources
   IRQ_CAN0_MSG    : constant := 29;  --        0x0000_00B4     45      29      0       7       CAN0                            OR'ed Message buffer (0-15)
   IRQ_CAN0_BUSOFF : constant := 30;  --        0x0000_00B8     46      30      0       7       CAN0                            Bus Off
   IRQ_CAN0_ERR    : constant := 31;  --        0x0000_00BC     47      31      0       7       CAN0                            Error
   IRQ_CAN0_TXWARN : constant := 32;  --        0x0000_00C0     48      32      1       8       CAN0                            Transmit Warning
   IRQ_CAN0_RXWARN : constant := 33;  --        0x0000_00C4     49      33      1       8       CAN0                            Receive Warning
   IRQ_CAN0_WAKE   : constant := 34;  --        0x0000_00C8     50      34      1       8       CAN0                            Wake Up
   IRQ_I2S0_TX     : constant := 35;  --        0x0000_00CC     51      35      1       8       I2S0                            Transmit
   IRQ_I2S0_RX     : constant := 36;  --        0x0000_00D0     52      36      1       9       I2S0                            Receive
   IRQ_CAN1_MSG    : constant := 37;  --        0x0000_00D4     53      37      1       9       CAN1                            OR'ed Message buffer (0-15)
   IRQ_CAN1_BUSOFF : constant := 38;  --        0x0000_00D8     54      38      1       9       CAN1                            Bus off
   IRQ_CAN1_ERR    : constant := 39;  --        0x0000_00DC     55      39      1       9       CAN1                            Error
   IRQ_CAN1_TXWARN : constant := 40;  --        0x0000_00E0     56      40      1       10      CAN1                            Transmit Warning
   IRQ_CAN1_RXWARN : constant := 41;  --        0x0000_00E4     57      41      1       10      CAN1                            Receive Warning
   IRQ_CAN1_WAKE   : constant := 42;  --        0x0000_00E8     58      42      1       10      CAN1                            Wake Up
   IRQ_UNKNOWN1    : constant := 43;  --        0x0000_00EC     59      43      1       10      —                               —
   IRQ_UART0_LON   : constant := 44;  --        0x0000_00F0     60      44      1       11      UART0                           Single interrupt vector for UART LON sources
   IRQ_UART0_STS   : constant := 45;  --        0x0000_00F4     61      45      1       11      UART0                           Single interrupt vector for UART status sources
   IRQ_UART0_ERR   : constant := 46;  --        0x0000_00F8     62      46      1       11      UART0                           Single interrupt vector for UART error sources
   IRQ_UART1_STS   : constant := 47;  --        0x0000_00FC     63      47      1       11      UART1                           Single interrupt vector for UART status sources
   IRQ_UART1_ERR   : constant := 48;  --        0x0000_0100     64      48      1       12      UART1                           Single interrupt vector for UART error sources
   IRQ_UART2_STS   : constant := 49;  --        0x0000_0104     65      49      1       12      UART2                           Single interrupt vector for UART status sources
   IRQ_UART2_ERR   : constant := 50;  --        0x0000_0108     66      50      1       12      UART2                           Single interrupt vector for UART error sources
   IRQ_UART3_STS   : constant := 51;  --        0x0000_010C     67      51      1       12      UART3                           Single interrupt vector for UART status sources
   IRQ_UART3_ERR   : constant := 52;  --        0x0000_0110     68      52      1       13      UART3                           Single interrupt vector for UART error sources
   IRQ_UART4_STS   : constant := 53;  --        0x0000_0114     69      53      1       13      UART4                           Single interrupt vector for UART status sources
   IRQ_UART4_ERR   : constant := 54;  --        0x0000_0118     70      54      1       13      UART4                           Single interrupt vector for UART error sources
   IRQ_UART5_STS   : constant := 55;  --        0x0000_011C     71      55      1       13      UART5                           Single interrupt vector for UART status sources
   IRQ_UART6_ERR   : constant := 56;  --        0x0000_0120     72      56      1       14      UART5                           Single interrupt vector for UART error sources
   IRQ_ADC0        : constant := 57;  --        0x0000_0124     73      57      1       14      ADC0                            —
   IRQ_ADC1        : constant := 58;  --        0x0000_0128     74      58      1       14      ADC1                            —
   IRQ_CMP0        : constant := 59;  --        0x0000_012C     75      59      1       14      CMP0                            —
   IRQ_CMP1        : constant := 60;  --        0x0000_0130     76      60      1       15      CMP1                            —
   IRQ_CMP2        : constant := 61;  --        0x0000_0134     77      61      1       15      CMP2                            —
   IRQ_FTM0        : constant := 62;  --        0x0000_0138     78      62      1       15      FTM0                            Single interrupt vector for all sources
   IRQ_FTM1        : constant := 63;  --        0x0000_013C     79      63      1       15      FTM1                            Single interrupt vector for all sources
   IRQ_FTM2        : constant := 64;  --        0x0000_0140     80      64      2       16      FTM2                            Single interrupt vector for all sources
   IRQ_CMT         : constant := 65;  --        0x0000_0144     81      65      2       16      CMT                             —
   IRQ_RTC_ALRM    : constant := 66;  --        0x0000_0148     82      66      2       16      RTC                             Alarm interrupt
   IRQ_RTC_SECS    : constant := 67;  --        0x0000_014C     83      67      2       16      RTC                             Seconds interrupt
   IRQ_PIT_CH0     : constant := 68;  --        0x0000_0150     84      68      2       17      PIT                             Channel 0
   IRQ_PIT_CH1     : constant := 69;  --        0x0000_0154     85      69      2       17      PIT                             Channel 1
   IRQ_PIT_CH2     : constant := 70;  --        0x0000_0158     86      70      2       17      PIT                             Channel 2
   IRQ_PIT_CH3     : constant := 71;  --        0x0000_015C     87      71      2       17      PIT                             Channel 3
   IRQ_PDB         : constant := 72;  --        0x0000_0160     88      72      2       18      PDB                             —
   IRQ_USBOTG      : constant := 73;  --        0x0000_0164     89      73      2       18      USB OTG                         —
   IRQ_USBCHARGE   : constant := 74;  --        0x0000_0168     90      74      2       18      USB Charger Detect              —
   IRQ_ETH_1588TMR : constant := 75;  --        0x0000_016C     91      75      2       18      Ethernet MAC                    IEEE 1588 Timer Interrupt
   IRQ_ETH_TX      : constant := 76;  --        0x0000_0170     92      76      2       19      Ethernet MAC                    Transmit interrupt
   IRQ_ETH_RX      : constant := 77;  --        0x0000_0174     93      77      2       19      Ethernet MAC                    Receive interrupt
   IRQ_ETH_ERRMISC : constant := 78;  --        0x0000_0178     94      78      2       19      Ethernet MAC                    Error and miscellaneous interrupt
   IRQ_UNKNOWN2    : constant := 79;  --        0x0000_017C     95      79      2       19      —                               —
   IRQ_SDHC        : constant := 80;  --        0x0000_0180     96      80      2       20      SDHC                            —
   IRQ_DAC0        : constant := 81;  --        0x0000_0184     97      81      2       20      DAC0                            —
   IRQ_DAC1        : constant := 82;  --        0x0000_0188     98      82      2       20      DAC1                            —
   IRQ_TSI         : constant := 83;  --        0x0000_018C     99      83      2       20      TSI                             Single interrupt vector for all sources
   IRQ_MCG         : constant := 84;  --        0x0000_0190     100     84      2       21      MCG                             —
   IRQ_LPT         : constant := 85;  --        0x0000_0194     101     85      2       21      Low Power Timer                 —
   IRQ_UNKNOWN3    : constant := 86;  --        0x0000_0198     102     86      2       21      —                               —
   IRQ_PORTA       : constant := 87;  --        0x0000_019C     103     87      2       21      Port control module             Pin detect (Port A)
   IRQ_PORTB       : constant := 88;  --        0x0000_01A0     104     88      2       22      Port control module             Pin detect (Port B)
   IRQ_PORTC       : constant := 89;  --        0x0000_01A4     105     89      2       22      Port control module             Pin detect (Port C)
   IRQ_PORTD       : constant := 90;  --        0x0000_01A8     106     90      2       22      Port control module             Pin detect (Port D)
   IRQ_PORTE       : constant := 91;  --        0x0000_01AC     107     91      2       22      Port control module             Pin detect (Port E)
   IRQ_PORTF       : constant := 92;  --        0x0000_01B0     108     92      2       23      Port control module             Pin detect (Port F)
   IRQ_DDR         : constant := 93;  --        0x0000_01B4     109     93      2       23      DDR controller                  —
   IRQ_SOFT        : constant := 94;  --        0x0000_01B8     110     94      2       23      Software                        Software interrupt4
   IRQ_NFC         : constant := 95;  --        0x0000_01BC     111     95      2       23      NAND flash controller (NFC)     —
   IRQ_USBHS       : constant := 96;  --        0x0000_01C0     112     96      3       24      USB HS                          —
   IRQ_UNKNOWN4    : constant := 97;  --        0x0000_01C4     113     97      3       24                                      —
   IRQ_CMP3        : constant := 98;  --        0x0000_01C8     114     98      3       24      CMP3                            —
   IRQ_UNKNOWN5    : constant := 99;  --        0x0000_01CC     115     99      3       24
   IRQ_UNKNOWN6    : constant := 100; --        0x0000_01D0     116     100     3       25      —                               —
   IRQ_FTM3        : constant := 101; --        0x0000_01D4     117     101     3       25      FTM3                            Single interrupt vector for all sources
   IRQ_ADC2        : constant := 102; --        0x0000_01D8     118     102     3       25      ADC2                            —
   IRQ_ADC3        : constant := 103; --        0x0000_01DC     119     103     3       25      ADC3                            —
   IRQ_I2S1_TX     : constant := 104; --        0x0000_01E0     120     104     3       26      I2S1                            Transmit
   IRQ_I2S1_RX     : constant := 105; --        0x0000_01E4     121     105     3       26      I2S1                            Receive

   ----------------------------------------------------------------------------
   -- Chapter 11 Port Control and Interrupts (PORT)
   ----------------------------------------------------------------------------

   PORT_MUXCTRL_BASEADDRESS : constant := 16#4004_9000#;

   -- 11.5.1 Pin Control Register n (PORTx_PCRn)

   PS_PULLDOWN : constant := 0; -- Internal pulldown resistor is enabled on the corresponding pin, if the corresponding PE field is set.
   PS_PULLUP   : constant := 1; -- Internal pullup resistor is enabled on the corresponding pin, if the corresponding PE field is set.

   MUX_DISABLED : constant := 2#000#; -- Pin disabled (analog).
   MUX_ALT1     : constant := 2#001#; -- Alternative 1 (GPIO).
   MUX_ALT2     : constant := 2#010#; -- Alternative 2 (chip-specific).
   MUX_ALT3     : constant := 2#011#; -- Alternative 3 (chip-specific).
   MUX_ALT4     : constant := 2#100#; -- Alternative 4 (chip-specific).
   MUX_ALT5     : constant := 2#101#; -- Alternative 5 (chip-specific).
   MUX_ALT6     : constant := 2#110#; -- Alternative 6 (chip-specific).
   MUX_ALT7     : constant := 2#111#; -- Alternative 7 (chip-specific).
   MUX_GPIO renames MUX_ALT1;

   IRQC_DISABLED   : constant := 2#0000#; -- Flag is disabled.
   IRQC_DMARISING  : constant := 2#0001#; -- Flag and DMA request on rising edge.
   IRQC_DMAFALLING : constant := 2#0010#; -- Flag and DMA request on falling edge.
   IRQC_DMAEITHER  : constant := 2#0011#; -- Flag and DMA request on either edge.
   IRQC_RSVD1      : constant := 2#0100#; -- Reserved.
   IRQC_RSVD2      : constant := 2#0101#; -- Reserved.
   IRQC_RSVD3      : constant := 2#0110#; -- Reserved.
   IRQC_RSVD4      : constant := 2#0111#; -- Reserved.
   IRQC_IRQZERO    : constant := 2#1000#; -- Flag and Interrupt when logic 0.
   IRQC_IRQRISING  : constant := 2#1001#; -- Flag and Interrupt on rising-edge.
   IRQC_IRQFALLING : constant := 2#1010#; -- Flag and Interrupt on falling-edge.
   IRQC_IRQEITHER  : constant := 2#1011#; -- Flag and Interrupt on either edge.
   IRQC_IRQONE     : constant := 2#1100#; -- Flag and Interrupt when logic 1.
   IRQC_RSVD5      : constant := 2#1101#; -- Reserved.
   IRQC_RSVD6      : constant := 2#1110#; -- Reserved.
   IRQC_RSVD7      : constant := 2#1111#; -- Reserved.

   type PORTx_PCRn_Type is record
      PS        : Bits_1;       -- Pull Select
      PE        : Boolean;      -- Pull Enable
      SRE       : Boolean;      -- Slew Rate Enable
      Reserved1 : Bits_1  := 0;
      PFE       : Boolean;      -- Passive Filter Enable
      ODE       : Boolean;      -- Open Drain Enable
      DSE       : Boolean;      -- Drive Strength Enable
      Reserved2 : Bits_1  := 0;
      MUX       : Bits_3;       -- Pin Mux Control
      Reserved3 : Bits_4  := 0;
      LK        : Boolean;      -- Lock Register
      IRQC      : Bits_4;       -- Interrupt Configuration
      Reserved4 : Bits_4  := 0;
      ISF       : Boolean;      -- Interrupt Status Flag
      Reserved5 : Bits_7  := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_PCRn_Type use record
      PS        at 0 range  0 ..  0;
      PE        at 0 range  1 ..  1;
      SRE       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PFE       at 0 range  4 ..  4;
      ODE       at 0 range  5 ..  5;
      DSE       at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      MUX       at 0 range  8 .. 10;
      Reserved3 at 0 range 11 .. 14;
      LK        at 0 range 15 .. 15;
      IRQC      at 0 range 16 .. 19;
      Reserved4 at 0 range 20 .. 23;
      ISF       at 0 range 24 .. 24;
      Reserved5 at 0 range 25 .. 31;
   end record;

   type PORTx_PCR_Type is array (0 .. 31) of PORTx_PCRn_Type
      with Pack => True;

   -- 11.5.2 Global Pin Control Low Register (PORTx_GPCLR)

   type Bitmap_16L is array (0 .. 15) of Boolean
      with Component_Size => 1,
           Size           => 16;

   type PORTx_GPCLR_Type is record
      GPWD : Bits_16    := 0;                 -- Global Pin Write Data
      GPWE : Bitmap_16L := [others => False]; -- Global Pin Write Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_GPCLR_Type use record
      GPWD at 0 range  0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   -- 11.5.3 Global Pin Control High Register (PORTx_GPCHR)

   type Bitmap_16H is array (16 .. 31) of Boolean
      with Component_Size => 1,
           Size           => 16;

   type PORTx_GPCHR_Type is record
      GPWD : Bits_16    := 0;                 -- Global Pin Write Data
      GPWE : Bitmap_16H := [others => False]; -- Global Pin Write Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_GPCHR_Type use record
      GPWD at 0 range  0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   -- 11.5.4 Interrupt Status Flag Register (PORTx_ISFR)

   type PORTx_ISFR_Type is record
      ISF : Bitmap_32; -- Interrupt Status Flag
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_ISFR_Type use record
      ISF at 0 range 0 .. 31;
   end record;

   -- 11.5 Memory map and register definition

   type PORT_MUXCTRL_Type is record
      PCR   : PORTx_PCR_Type;
      GPCLR : PORTx_GPCLR_Type;
      GPCHR : PORTx_GPCHR_Type;
      ISFR  : PORTx_ISFR_Type;
   end record
      with Size => 16#A4# * 8;
   for PORT_MUXCTRL_Type use record
      PCR   at 16#00# range 0 .. 32 * 32 - 1;
      GPCLR at 16#80# range 0 .. 31;
      GPCHR at 16#84# range 0 .. 31;
      ISFR  at 16#A0# range 0 .. 31;
   end record;

   PORTA_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTB_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#1000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTC_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#2000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTD_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#3000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTE_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#4000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTF_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#5000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 12 System integration module (SIM)
   ----------------------------------------------------------------------------

   SIM_BASEADDRESS : constant := 16#4004_7000#;

   -- 12.2.1 System Options Register 1 (SIM_SOPT1)

   RAMSIZE_128 : constant := 2#1001#; -- 128 KB

   OSC32KSEL_SYS : constant := 0; -- System oscillator (OSC32KCLK)
   OSC32KSEL_RTC : constant := 1; -- RTC oscillator

   type SIM_SOPT1_Type is record
      Reserved1 : Bits_6  := 0;
      Reserved2 : Bits_2  := 0;
      Reserved3 : Bits_2  := 0;
      Reserved4 : Bits_2  := 0;
      RAMSIZE   : Bits_4  := RAMSIZE_128;   -- RAM size
      Reserved5 : Bits_3  := 0;
      OSC32KSEL : Bits_1  := OSC32KSEL_SYS; -- 32 kHz oscillator clock select
      Reserved6 : Bits_9  := 0;
      USBVSTBY  : Boolean := False;         -- USB voltage regulator in standby mode during VLPR or VLPW
      USBSSTBY  : Boolean := False;         -- USB voltage regulator in standby mode during Stop, VLPS, LLS or VLLS
      USBREGEN  : Boolean := True;          -- USB voltage regulator enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT1_Type use record
      Reserved1 at 0 range  0 ..  5;
      Reserved2 at 0 range  6 ..  7;
      Reserved3 at 0 range  8 ..  9;
      Reserved4 at 0 range 10 .. 11;
      RAMSIZE   at 0 range 12 .. 15;
      Reserved5 at 0 range 16 .. 18;
      OSC32KSEL at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 28;
      USBVSTBY  at 0 range 29 .. 29;
      USBSSTBY  at 0 range 30 .. 30;
      USBREGEN  at 0 range 31 .. 31;
   end record;

   SIM_SOPT1 : aliased SIM_SOPT1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.2 SOPT1 Configuration Register (SIM_SOPT1CFG)

   type SIM_SOPT1CFG_Type is record
      Reserved1 : Bits_24 := 0;
      URWE      : Boolean := False; -- USB voltage regulator enable write enable
      UVSWE     : Boolean := False; -- USB voltage regulator VLP standby write enable
      USSWE     : Boolean := False; -- USB voltage regulator stop standby write enable
      Reserved2 : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT1CFG_Type use record
      Reserved1 at 0 range  0 .. 23;
      URWE      at 0 range 24 .. 24;
      UVSWE     at 0 range 25 .. 25;
      USSWE     at 0 range 26 .. 26;
      Reserved2 at 0 range 27 .. 31;
   end record;

   SIM_SOPT1CFG : aliased SIM_SOPT1CFG_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.3 System Options Register 2 (SIM_SOPT2)

   USBHSRC_BUS        : constant := 2#00#; -- Bus clock
   USBHSRC_MCGPLL0CLK : constant := 2#01#; -- MCGPLL0CLK
   USBHSRC_MCGPLL1CLK : constant := 2#10#; -- MCGPLL1CLK
   USBHSRC_OSC0ERCLK  : constant := 2#11#; -- OSC0ERCLK

   RTCCLKOUTSEL_1   : constant := 0; -- RTC 1 Hz clock drives RTC CLKOUT.
   RTCCLKOUTSEL_32k : constant := 1; -- RTC 32 kHz oscillator drives RTC CLKOUT.

   CLKOUTSEL_FLEXBUS   : constant := 2#000#; -- FlexBus clock (reset value)
   CLKOUTSEL_RSVD      : constant := 2#001#; -- Reserved
   CLKOUTSEL_FLASH     : constant := 2#010#; -- Flash ungated clock
   CLKOUTSEL_LPO       : constant := 2#011#; -- LPO clock (1 kHz)
   CLKOUTSEL_MCGIRCLK  : constant := 2#100#; -- MCGIRCLK
   CLKOUTSEL_RTC32k    : constant := 2#101#; -- RTC 32 kHz clock
   CLKOUTSEL_OSC0ERCLK : constant := 2#110#; -- OSC0ERCLK
   CLKOUTSEL_OSC1ERCLK : constant := 2#111#; -- OSC1ERCLK

   FBSL_ALL    : constant := 2#00#; -- All off-chip accesses (op code and data) via the FlexBus are disallowed.
   FBSL_OPCODE : constant := 2#10#; -- Off-chip op code accesses are disallowed. Data accesses are allowed.
   FBSL_NONE   : constant := 2#11#; -- Off-chip op code accesses and data accesses are allowed.

   CMTUARTPAD_SINGLE : constant := 0; -- Single-pad drive strength for CMT IRO or UART0_TXD.
   CMTUARTPAD_DUAL   : constant := 1; -- Dual-pad drive strength for CMT IRO or UART0_TXD.

   TRACECLKSEL_MCGCLKOUT : constant := 0; -- MCGCLKOUT
   TRACECLKSEL_CORE      : constant := 1; -- Core/system clock

   NFC_CLKSEL_CLOCKDIV : constant := 0; -- Clock divider NFC clock
   NFC_CLKSEL_EXTAL1   : constant := 1; -- EXTAL1 clock.

   PLLFLLSEL_MCGFLLCLK  : constant := 2#00#; -- MCGFLLCLK
   PLLFLLSEL_MCGPLL0CLK : constant := 2#01#; -- MCGPLL0CLK
   PLLFLLSEL_MCGPLL1CLK : constant := 2#10#; -- MCGPLL1CLK
   PLLFLLSEL_SYS        : constant := 2#11#; -- System Platform clock

   USBF_CLKSEL_EXT    : constant := 0; -- External bypass clock (PTE26)
   USBF_CLKSEL_CLKDIV : constant := 1; -- Clock divider USB FS clock

   TIMESRC_SYS       : constant := 2#00#; -- System platform clock
   TIMESRC_MCG       : constant := 2#01#; -- MCGPLLCLK/MCGFLLCLK selected by PLLFLLSEL[1:0]
   TIMESRC_OSC0ERCLK : constant := 2#10#; -- OSC0ERCLK
   TIMESRC_EXT       : constant := 2#11#; -- External bypass clock (PTE26)

   USBFSRC_MCGSEL     : constant := 2#00#; -- MCGPLLCLK/MCGFLLCLK selected by PLLFLLSEL[1:0]
   USBFSRC_MCGPLL0CLK : constant := 2#01#; -- MCGPLL0CLK
   USBFSRC_MCGPLL1CLK : constant := 2#10#; -- MCGPLL1CLK
   USBFSRC_OSC0ERCLK  : constant := 2#11#; -- OSC0ERCLK

   ESDHCSRC_SYS       : constant := 2#00#; -- Core/system clock
   ESDHCSRC_MCGSEL    : constant := 2#01#; -- MCGPLLCLK/MCGFLLCLK selected by PLLFLLSEL[1:0]
   ESDHCSRC_OSC0ERCLK : constant := 2#10#; -- OSC0ERCLK
   ESDHCSRC_EXT       : constant := 2#11#; -- External bypass clock (PTD11)

   NFCSRC_BUS        : constant := 2#00#; -- Bus clock
   NFCSRC_MCGPLL0CLK : constant := 2#01#; -- MCGPLL0CLK
   NFCSRC_MCGPLL1CLK : constant := 2#10#; -- MCGPLL1CLK
   NFCSRC_OSC0ERCLK  : constant := 2#11#; -- OSC0ERCLK

   type SIM_SOPT2_Type is record
      Reserved1    : Bits_2 := 0;
      USBHSRC      : Bits_2 := USBHSRC_MCGPLL0CLK;  -- USB HS clock source select
      RTCCLKOUTSEL : Bits_1 := RTCCLKOUTSEL_1;      -- RTC clock out select
      CLKOUTSEL    : Bits_3 := CLKOUTSEL_FLEXBUS;   -- Clock out select
      FBSL         : Bits_2 := FBSL_ALL;            -- Flexbus security level
      Reserved2    : Bits_1 := 0;
      CMTUARTPAD   : Bits_1 := CMTUARTPAD_SINGLE;   -- CMT/UART pad drive strength
      TRACECLKSEL  : Bits_1 := TRACECLKSEL_CORE;    -- Debug trace clock select
      Reserved3    : Bits_1 := 0;
      Reserved4    : Bits_1 := 0;
      NFC_CLKSEL   : Bits_1 := NFC_CLKSEL_CLOCKDIV; -- NFC Flash clock select
      PLLFLLSEL    : Bits_2 := PLLFLLSEL_MCGFLLCLK; -- PLL/FLL clock select
      USBF_CLKSEL  : Bits_1 := USBF_CLKSEL_EXT;     -- USB FS clock select
      Reserved5    : Bits_1 := 0;
      TIMESRC      : Bits_2 := TIMESRC_SYS;         -- Ethernet timestamp clock source select
      USBFSRC      : Bits_2 := USBFSRC_MCGSEL;      -- USB FS clock source select
      Reserved6    : Bits_2 := 0;
      Reserved7    : Bits_2 := 2#01#;
      ESDHCSRC     : Bits_2 := ESDHCSRC_SYS;        -- ESDHC perclk source select
      NFCSRC       : Bits_2 := NFCSRC_MCGPLL0CLK;   -- NFC Flash clock source select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT2_Type use record
      Reserved1    at 0 range  0 ..  1;
      USBHSRC      at 0 range  2 ..  3;
      RTCCLKOUTSEL at 0 range  4 ..  4;
      CLKOUTSEL    at 0 range  5 ..  7;
      FBSL         at 0 range  8 ..  9;
      Reserved2    at 0 range 10 .. 10;
      CMTUARTPAD   at 0 range 11 .. 11;
      TRACECLKSEL  at 0 range 12 .. 12;
      Reserved3    at 0 range 13 .. 13;
      Reserved4    at 0 range 14 .. 14;
      NFC_CLKSEL   at 0 range 15 .. 15;
      PLLFLLSEL    at 0 range 16 .. 17;
      USBF_CLKSEL  at 0 range 18 .. 18;
      Reserved5    at 0 range 19 .. 19;
      TIMESRC      at 0 range 20 .. 21;
      USBFSRC      at 0 range 22 .. 23;
      Reserved6    at 0 range 24 .. 25;
      Reserved7    at 0 range 26 .. 27;
      ESDHCSRC     at 0 range 28 .. 29;
      NFCSRC       at 0 range 30 .. 31;
   end record;

   SIM_SOPT2 : aliased SIM_SOPT2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.4 System Options Register 4 (SIM_SOPT4)

   FTMxFLTy_FLT : constant := 0; -- FTM?_FLT? drives FTM ? fault ?.
   FTMxFLTy_CMP : constant := 1; -- CMP? OUT drives FTM ? fault ?.

   FTMxCH0SRC_CH0    : constant := 2#00#; -- FTM?_CH0 pin
   FTMxCH0SRC_CMP0   : constant := 2#01#; -- CMP0 output
   FTMxCH0SRC_CMP1   : constant := 2#10#; -- CMP1 output
   FTMxCH0SRC_USBSOF : constant := 2#11#; -- USB SOF trigger

   FTMxCLKSEL_CLKIN0 : constant := 0; -- FTM? external clock driven by FTM CLKIN0 pin
   FTMxCLKSEL_CLKIN1 : constant := 1; -- FTM? external clock driven by FTM CLKIN1 pin.

   FTMxTRGySRC_CMPPDB : constant := 0; -- CMP0 OUT/PDB output trigger ? drives FTM? hardware trigger ?.
   FTMxTRGySRC_FTM    : constant := 1; -- FTM? channel match trigger drives FTM? hardware trigger ?.

   type SIM_SOPT4_Type is record
      FTM0FLT0    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 0 Fault 0 Select
      FTM0FLT1    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 0 Fault 1 Select
      FTM0FLT2    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 0 Fault 2 Select
      FTM0FLT3    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 0 Fault 3 Select.
      FTM1FLT0    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 1 Fault 0 Select
      Reserved1   : Bits_3 := 0;
      FTM2FLT0    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 2 Fault 0 Select
      Reserved2   : Bits_3 := 0;
      FTM3FLT0    : Bits_1 := FTMxFLTy_FLT;       -- FlexTimer 3 Fault 0 Select.
      Reserved3   : Bits_5 := 0;
      FTM1CH0SRC  : Bits_2 := FTMxCH0SRC_CH0;     -- FlexTimer 1 channel 0 input capture source select
      FTM2CH0SRC  : Bits_2 := FTMxCH0SRC_CH0;     -- FlexTimer 2 channel 0 input capture source select
      Reserved4   : Bits_2 := 0;
      FTM0CLKSEL  : Bits_1 := FTMxCLKSEL_CLKIN0;  -- FlexTimer 0 external clock pin select
      FTM1CLKSEL  : Bits_1 := FTMxCLKSEL_CLKIN0;  -- FlexTimer 1 external clock pin select
      FTM2CLKSEL  : Bits_1 := FTMxCLKSEL_CLKIN0;  -- FlexTimer 2 external clock pin select
      FTM3CLKSEL  : Bits_1 := FTMxCLKSEL_CLKIN0;  -- FlexTimer 3 external clock pin select
      FTM0TRG0SRC : Bits_1 := FTMxTRGySRC_CMPPDB; -- FlexTimer 0 hardware trigger 0 source select
      FTM0TRG1SRC : Bits_1 := FTMxTRGySRC_CMPPDB; -- FlexTimer 0 hardware trigger 1 source select
      FTM3TRG0SRC : Bits_1 := FTMxTRGySRC_CMPPDB; -- FlexTimer 3 hardware trigger 0 source select
      FTM3TRG1SRC : Bits_1 := FTMxTRGySRC_CMPPDB; -- FlexTimer 3 hardware trigger 1 source select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT4_Type use record
      FTM0FLT0    at 0 range  0 ..  0;
      FTM0FLT1    at 0 range  1 ..  1;
      FTM0FLT2    at 0 range  2 ..  2;
      FTM0FLT3    at 0 range  3 ..  3;
      FTM1FLT0    at 0 range  4 ..  4;
      Reserved1   at 0 range  5 ..  7;
      FTM2FLT0    at 0 range  8 ..  8;
      Reserved2   at 0 range  9 .. 11;
      FTM3FLT0    at 0 range 12 .. 12;
      Reserved3   at 0 range 13 .. 17;
      FTM1CH0SRC  at 0 range 18 .. 19;
      FTM2CH0SRC  at 0 range 20 .. 21;
      Reserved4   at 0 range 22 .. 23;
      FTM0CLKSEL  at 0 range 24 .. 24;
      FTM1CLKSEL  at 0 range 25 .. 25;
      FTM2CLKSEL  at 0 range 26 .. 26;
      FTM3CLKSEL  at 0 range 27 .. 27;
      FTM0TRG0SRC at 0 range 28 .. 28;
      FTM0TRG1SRC at 0 range 29 .. 29;
      FTM3TRG0SRC at 0 range 30 .. 30;
      FTM3TRG1SRC at 0 range 31 .. 31;
   end record;

   SIM_SOPT4 : aliased SIM_SOPT4_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#100C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.5 System Options Register 5 (SIM_SOPT5)

   UARTxTXSRC_TXPIN   : constant := 2#00#; -- UART?_TX pin
   UARTxTXSRC_FTM1CH0 : constant := 2#01#; -- UART?_TX pin modulated with FTM1 channel 0 output
   UARTxTXSRC_FTM2CH0 : constant := 2#10#; -- UART?_TX pin modulated with FTM2 channel 0 output
   UARTxTXSRC_RSVD    : constant := 2#11#; -- Reserved

   UARTxRXSRC_RXPIN : constant := 2#00#; -- UART?_RX pin
   UARTxRXSRC_CMP0  : constant := 2#01#; -- CMP0
   UARTxRXSRC_CMP1  : constant := 2#10#; -- CMP1
   UARTxRXSRC_RSVD  : constant := 2#11#; -- Reserved

   type SIM_SOPT5_Type is record
      UART0TXSRC : Bits_2  := UARTxTXSRC_TXPIN; -- UART0 transmit data source select
      UART0RXSRC : Bits_2  := UARTxRXSRC_RXPIN; -- UART0 receive data source select
      UART1TXSRC : Bits_2  := UARTxTXSRC_TXPIN; -- UART1 transmit data source select
      UART1RXSRC : Bits_2  := UARTxRXSRC_RXPIN; -- UART1 receive data source select
      Reserved   : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT5_Type use record
      UART0TXSRC at 0 range 0 ..  1;
      UART0RXSRC at 0 range 2 ..  3;
      UART1TXSRC at 0 range 4 ..  5;
      UART1RXSRC at 0 range 6 ..  7;
      Reserved   at 0 range 8 .. 31;
   end record;

   SIM_SOPT5 : aliased SIM_SOPT5_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.6 System Options Register 6 (SIM_SOPT6)

   type SIM_SOPT6_Type is record
      MCC      : Bits_16 := 0; -- MCC
      PCR      : Bits_4  := 0; -- PCR
      Reserved : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT6_Type use record
      MCC      at 0 range  0 .. 15;
      PCR      at 0 range 16 .. 19;
      Reserved at 0 range 20 .. 31;
   end record;

   SIM_SOPT6 : aliased SIM_SOPT6_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.7 System Options Register 7 (SIM_SOPT7)

   ADCxTRGSEL_EXTTRG  : constant := 2#0000#; -- External trigger
   ADCxTRGSEL_HSC0    : constant := 2#0001#; -- High speed comparator 0 asynchronous interrupt
   ADCxTRGSEL_HSC1    : constant := 2#0010#; -- High speed comparator 1 asynchronous interrupt
   ADCxTRGSEL_HSC2    : constant := 2#0011#; -- High speed comparator 2 asynchronous interrupt
   ADCxTRGSEL_PITTRG0 : constant := 2#0100#; -- PIT trigger 0
   ADCxTRGSEL_PITTRG1 : constant := 2#0101#; -- PIT trigger 1
   ADCxTRGSEL_PITTRG2 : constant := 2#0110#; -- PIT trigger 2
   ADCxTRGSEL_PITTRG3 : constant := 2#0111#; -- PIT trigger 3
   ADCxTRGSEL_FTM0    : constant := 2#1000#; -- FTM0 trigger
   ADCxTRGSEL_FTM1    : constant := 2#1001#; -- FTM1 trigger
   ADCxTRGSEL_FTM2    : constant := 2#1010#; -- FTM2 trigger
   ADCxTRGSEL_FTM3    : constant := 2#1011#; -- FTM3 trigger
   ADCxTRGSEL_RTCALRM : constant := 2#1100#; -- RTC alarm
   ADCxTRGSEL_RTCSEC  : constant := 2#1101#; -- RTC seconds
   ADCxTRGSEL_LPT     : constant := 2#1110#; -- Low-power timer trigger
   ADCxTRGSEL_HSC3    : constant := 2#1111#; -- High speed comparator 3 asynchronous interrupt

   ADCxPRETRGSEL_PRETRGA : constant := 0; -- Pre-trigger A selected for ADC?.
   ADCxPRETRGSEL_PRETRGB : constant := 1; -- Pre-trigger B selected for ADC?.

   ADCxALTTRGEN_PDB : constant := 0; -- PDB trigger selected for ADC?.
   ADCxALTTRGEN_ALT : constant := 1; -- Alternate trigger selected for ADC?.

   type SIM_SOPT7_Type is record
      ADC0TRGSEL    : Bits_4 := ADCxTRGSEL_EXTTRG;     -- ADC0 trigger select
      ADC0PRETRGSEL : Bits_1 := ADCxPRETRGSEL_PRETRGA; -- ADC0 pre-trigger select
      Reserved1     : Bits_2 := 0;
      ADC0ALTTRGEN  : Bits_1 := ADCxALTTRGEN_PDB;      -- ADC0 alternate trigger enable
      ADC1TRGSEL    : Bits_4 := ADCxTRGSEL_EXTTRG;     -- ADC1 trigger select
      ADC1PRETRGSEL : Bits_1 := ADCxPRETRGSEL_PRETRGA; -- ADC1 pre-trigger select
      Reserved2     : Bits_2 := 0;
      ADC1ALTTRGEN  : Bits_1 := ADCxALTTRGEN_PDB;      -- ADC1 alternate trigger enable
      ADC2TRGSEL    : Bits_4 := ADCxTRGSEL_EXTTRG;     -- ADC2 trigger select
      ADC2PRETRGSEL : Bits_1 := ADCxPRETRGSEL_PRETRGA; -- ADC2 pre-trigger select
      Reserved3     : Bits_2 := 0;
      ADC2ALTTRGEN  : Bits_1 := ADCxALTTRGEN_PDB;      -- ADC2 alternate trigger enable
      ADC3TRGSEL    : Bits_4 := ADCxTRGSEL_EXTTRG;     -- ADC3 trigger select
      ADC3PRETRGSEL : Bits_1 := ADCxPRETRGSEL_PRETRGA; -- ADC3 pre-trigger select
      Reserved4     : Bits_2 := 0;
      ADC3ALTTRGEN  : Bits_1 := ADCxALTTRGEN_PDB;      -- ADC3 alternate trigger enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT7_Type use record
      ADC0TRGSEL    at 0 range  0 ..  3;
      ADC0PRETRGSEL at 0 range  4 ..  4;
      Reserved1     at 0 range  5 ..  6;
      ADC0ALTTRGEN  at 0 range  7 ..  7;
      ADC1TRGSEL    at 0 range  8 .. 11;
      ADC1PRETRGSEL at 0 range 12 .. 12;
      Reserved2     at 0 range 13 .. 14;
      ADC1ALTTRGEN  at 0 range 15 .. 15;
      ADC2TRGSEL    at 0 range 16 .. 19;
      ADC2PRETRGSEL at 0 range 20 .. 20;
      Reserved3     at 0 range 21 .. 22;
      ADC2ALTTRGEN  at 0 range 23 .. 23;
      ADC3TRGSEL    at 0 range 24 .. 27;
      ADC3PRETRGSEL at 0 range 28 .. 28;
      Reserved4     at 0 range 29 .. 30;
      ADC3ALTTRGEN  at 0 range 31 .. 31;
   end record;

   SIM_SOPT7 : aliased SIM_SOPT7_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.8 System Device Identification Register (SIM_SDID)

   PINID_144 : constant := 2#1010#; -- 144-pin
   PINID_196 : constant := 2#1100#; -- 196-pin
   PINID_256 : constant := 2#1110#; -- 256-pin

   FAMID_K10 : constant := 2#000#; -- K10
   FAMID_K20 : constant := 2#001#; -- K20
   FAMID_K61 : constant := 2#010#; -- K61
   FAMID_K60 : constant := 2#100#; -- K60
   FAMID_K70 : constant := 2#101#; -- K70

   type SIM_SDID_Type is record
      PINID     : Bits_4;  -- Pincount identification
      FAMID     : Bits_3;  -- Kinetis family identification
      Reserved1 : Bits_1;
      Reserved2 : Bits_1;
      Reserved3 : Bits_1;
      Reserved4 : Bits_2;
      REVID     : Bits_4;  -- Device revision number
      Reserved5 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SDID_Type use record
      PINID     at 0 range  0 ..  3;
      FAMID     at 0 range  4 ..  6;
      Reserved1 at 0 range  7 ..  7;
      Reserved2 at 0 range  8 ..  8;
      Reserved3 at 0 range  9 ..  9;
      Reserved4 at 0 range 10 .. 11;
      REVID     at 0 range 12 .. 15;
      Reserved5 at 0 range 16 .. 31;
   end record;

   SIM_SDID : aliased SIM_SDID_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.9 System Clock Gating Control Register 1 (SIM_SCGC1)

   type SIM_SCGC1_Type is record
      Reserved1 : Bits_5  := 0;
      OSC1      : Boolean := False; -- OSC1 clock gate control
      Reserved2 : Bits_4  := 0;
      UART4     : Boolean := False; -- UART4 clock gate control
      UART5     : Boolean := False; -- UART5 clock gate control
      Reserved3 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC1_Type use record
      Reserved1 at 0 range  0 ..  4;
      OSC1      at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  9;
      UART4     at 0 range 10 .. 10;
      UART5     at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 31;
   end record;

   SIM_SCGC1 : aliased SIM_SCGC1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.10 System Clock Gating Control Register 2 (SIM_SCGC2)

   type SIM_SCGC2_Type is record
      ENET      : Boolean := False; -- ENET clock gate control
      Reserved1 : Bits_11 := 0;
      DAC0      : Boolean := False; -- 12BDAC0 clock gate control
      DAC1      : Boolean := False; -- 12BDAC1 clock gate control
      Reserved2 : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC2_Type use record
      ENET      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 .. 11;
      DAC0      at 0 range 12 .. 12;
      DAC1      at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   SIM_SCGC2 : aliased SIM_SCGC2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#102C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.11 System Clock Gating Control Register 3 (SIM_SCGC3)

   type SIM_SCGC3_Type is record
      RNGA       : Boolean := False; -- RNGA clock gate control
      Reserved1  : Bits_3  := 0;
      FLEXCAN1   : Boolean := False; -- FlexCAN1 clock gate control
      Reserved2  : Bits_3  := 0;
      NFC        : Boolean := False; -- NFC clock gate control
      Reserved3  : Bits_3  := 0;
      DSPI2      : Boolean := False; -- DSPI2 clock gate control
      Reserved4  : Bits_1  := 0;
      DDR        : Boolean := False; -- DDR clock gate control
      SAI1       : Boolean := False; -- SAI1 clock gate control
      Reserved5  : Bits_1  := 0;
      ESDHC      : Boolean := False; -- ESDHC clock gate control
      Reserved6  : Bits_4  := 0;
      Reserved7  : Bits_1  := 0;
      Reserved8  : Bits_1  := 0;
      FTM2       : Boolean := False; -- FTM2 clock gate control
      FTM3       : Boolean := False; -- FTM3 clock gate control
      Reserved9  : Bits_1  := 0;
      ADC1       : Boolean := False; -- ADC1 clock gate control
      ADC3       : Boolean := False; -- ADC3 clock gate control
      Reserved10 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC3_Type use record
      RNGA       at 0 range  0 ..  0;
      Reserved1  at 0 range  1 ..  3;
      FLEXCAN1   at 0 range  4 ..  4;
      Reserved2  at 0 range  5 ..  7;
      NFC        at 0 range  8 ..  8;
      Reserved3  at 0 range  9 .. 11;
      DSPI2      at 0 range 12 .. 12;
      Reserved4  at 0 range 13 .. 13;
      DDR        at 0 range 14 .. 14;
      SAI1       at 0 range 15 .. 15;
      Reserved5  at 0 range 16 .. 16;
      ESDHC      at 0 range 17 .. 17;
      Reserved6  at 0 range 18 .. 21;
      Reserved7  at 0 range 22 .. 22;
      Reserved8  at 0 range 23 .. 23;
      FTM2       at 0 range 24 .. 24;
      FTM3       at 0 range 25 .. 25;
      Reserved9  at 0 range 26 .. 26;
      ADC1       at 0 range 27 .. 27;
      ADC3       at 0 range 28 .. 28;
      Reserved10 at 0 range 29 .. 31;
   end record;

   SIM_SCGC3 : aliased SIM_SCGC3_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1030#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.12 System Clock Gating Control Register 4 (SIM_SCGC4)

   type SIM_SCGC4_Type is record
      Reserved1  : Bits_1  := 0;
      EWM        : Boolean := False; -- EWM clock gate control
      CMT        : Boolean := False; -- CMT clock gate control
      Reserved2  : Bits_1  := 0;
      Reserved3  : Bits_1  := 0;
      Reserved4  : Bits_1  := 0;
      IIC0       : Boolean := False; -- IIC0 clock gate control
      IIC1       : Boolean := False; -- IIC1 clock gate control
      Reserved5  : Bits_2  := 0;
      UART0      : Boolean := False; -- UART0 clock gate control
      UART1      : Boolean := False; -- UART1 clock gate control
      UART2      : Boolean := False; -- UART2 clock gate control
      UART3      : Boolean := False; -- UART3 clock gate control
      Reserved6  : Bits_4  := 0;
      USBFS      : Boolean := False; -- USB FS clock gate control
      CMP        : Boolean := False; -- Comparator clock gate control
      VREF       : Boolean := False; -- VREF clock gate control
      Reserved7  : Bits_7  := 0;
      LLWU       : Boolean := False; -- LLWU Clock Gate Control
      Reserved8  : Bits_1  := 0;
      Reserved9  : Bits_1  := 0;
      Reserved10 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC4_Type use record
      Reserved1  at 0 range  0 ..  0;
      EWM        at 0 range  1 ..  1;
      CMT        at 0 range  2 ..  2;
      Reserved2  at 0 range  3 ..  3;
      Reserved3  at 0 range  4 ..  4;
      Reserved4  at 0 range  5 ..  5;
      IIC0       at 0 range  6 ..  6;
      IIC1       at 0 range  7 ..  7;
      Reserved5  at 0 range  8 ..  9;
      UART0      at 0 range 10 .. 10;
      UART1      at 0 range 11 .. 11;
      UART2      at 0 range 12 .. 12;
      UART3      at 0 range 13 .. 13;
      Reserved6  at 0 range 14 .. 17;
      USBFS      at 0 range 18 .. 18;
      CMP        at 0 range 19 .. 19;
      VREF       at 0 range 20 .. 20;
      Reserved7  at 0 range 21 .. 27;
      LLWU       at 0 range 28 .. 28;
      Reserved8  at 0 range 29 .. 29;
      Reserved9  at 0 range 30 .. 30;
      Reserved10 at 0 range 31 .. 31;
   end record;

   SIM_SCGC4 : aliased SIM_SCGC4_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1034#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.13 System Clock Gating Control Register 5 (SIM_SCGC5)

   type SIM_SCGC5_Type is record
      LPTIMER      : Boolean := False; -- LPTMR clock gate control
      Reserved1    : Bits_1  := 1;
      DRYICE       : Boolean := False; -- Dryice clock gate control
      DRYICESECREG : Boolean := False; -- Dryice secure storage clock gate control
      Reserved2    : Bits_1  := 0;
      TSI          : Boolean := False; -- TSI clock gate control
      Reserved3    : Bits_1  := 0;
      Reserved4    : Bits_1  := 1;
      Reserved5    : Bits_1  := 1;
      PORTA        : Boolean := False; -- PORTA clock gate control
      PORTB        : Boolean := False; -- PORTB clock gate control
      PORTC        : Boolean := False; -- PORTC clock gate control
      PORTD        : Boolean := False; -- PORTD clock gate control
      PORTE        : Boolean := False; -- PORTE clock gate control
      PORTF        : Boolean := False; -- PORTF clock gate control
      Reserved6    : Bits_3  := 0;
      Reserved7    : Bits_1  := 1;
      Reserved8    : Bits_13 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC5_Type use record
      LPTIMER      at 0 range  0 ..  0;
      Reserved1    at 0 range  1 ..  1;
      DRYICE       at 0 range  2 ..  2;
      DRYICESECREG at 0 range  3 ..  3;
      Reserved2    at 0 range  4 ..  4;
      TSI          at 0 range  5 ..  5;
      Reserved3    at 0 range  6 ..  6;
      Reserved4    at 0 range  7 ..  7;
      Reserved5    at 0 range  8 ..  8;
      PORTA        at 0 range  9 ..  9;
      PORTB        at 0 range 10 .. 10;
      PORTC        at 0 range 11 .. 11;
      PORTD        at 0 range 12 .. 12;
      PORTE        at 0 range 13 .. 13;
      PORTF        at 0 range 14 .. 14;
      Reserved6    at 0 range 15 .. 17;
      Reserved7    at 0 range 18 .. 18;
      Reserved8    at 0 range 19 .. 31;
   end record;

   SIM_SCGC5 : aliased SIM_SCGC5_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.14 System Clock Gating Control Register 6 (SIM_SCGC6)

   type SIM_SCGC6_Type is record
      Reserved1 : Bits_1  := 1;
      DMAMUX0   : Boolean := False; -- DMAMUX0 clock gate control
      DMAMUX1   : Boolean := False; -- DMAMUX1 clock gate control
      Reserved2 : Bits_1  := 0;
      FLEXCAN0  : Boolean := False; -- FlexCAN0 clock gate control
      Reserved3 : Bits_7  := 0;
      DSPI0     : Boolean := False; -- DSPI0 clock gate control
      DSPI1     : Boolean := False; -- DSPI1 clock gate control
      Reserved4 : Bits_1  := 0;
      SAI0      : Boolean := False; -- SAI0 clock gate control
      Reserved5 : Bits_2  := 0;
      CRC       : Boolean := False; -- CRC clock gate control
      Reserved6 : Bits_1  := 0;
      USBHS     : Boolean := False; -- USBHS clock gate control
      USBDCD    : Boolean := False; -- USB DCD clock gate control
      PDB       : Boolean := False; -- PDB clock gate control
      PIT       : Boolean := False; -- PIT clock gate control
      FTM0      : Boolean := False; -- FTM0 clock gate control
      FTM1      : Boolean := False; -- FTM1 clock gate control
      Reserved7 : Bits_1  := 0;
      ADC0      : Boolean := False; -- ADC0 clock gate control
      ADC2      : Boolean := False; -- ADC2 clock gate control
      RTC       : Boolean := False; -- RTC clock gate control
      Reserved8 : Bits_1  := 1;
      Reserved9 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC6_Type use record
      Reserved1 at 0 range  0 ..  0;
      DMAMUX0   at 0 range  1 ..  1;
      DMAMUX1   at 0 range  2 ..  2;
      Reserved2 at 0 range  3 ..  3;
      FLEXCAN0  at 0 range  4 ..  4;
      Reserved3 at 0 range  5 .. 11;
      DSPI0     at 0 range 12 .. 12;
      DSPI1     at 0 range 13 .. 13;
      Reserved4 at 0 range 14 .. 14;
      SAI0      at 0 range 15 .. 15;
      Reserved5 at 0 range 16 .. 17;
      CRC       at 0 range 18 .. 18;
      Reserved6 at 0 range 19 .. 19;
      USBHS     at 0 range 20 .. 20;
      USBDCD    at 0 range 21 .. 21;
      PDB       at 0 range 22 .. 22;
      PIT       at 0 range 23 .. 23;
      FTM0      at 0 range 24 .. 24;
      FTM1      at 0 range 25 .. 25;
      Reserved7 at 0 range 26 .. 26;
      ADC0      at 0 range 27 .. 27;
      ADC2      at 0 range 28 .. 28;
      RTC       at 0 range 29 .. 29;
      Reserved8 at 0 range 30 .. 30;
      Reserved9 at 0 range 31 .. 31;
   end record;

   SIM_SCGC6 : aliased SIM_SCGC6_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#103C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.15 System Clock Gating Control Register 7 (SIM_SCGC7)

   type SIM_SCGC7_Type is record
      FLEXBUS   : Boolean := True; -- FlexBus controller clock gate control
      DMA       : Boolean := True; -- DMA controller clock gate control
      MPU       : Boolean := True; -- MPU clock gate control
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC7_Type use record
      FLEXBUS   at 0 range  0 ..  0;
      DMA       at 0 range  1 ..  1;
      MPU       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      Reserved2 at 0 range  4 .. 31;
   end record;

   SIM_SCGC7 : aliased SIM_SCGC7_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1040#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.16 System Clock Divider Register 1 (SIM_CLKDIV1)

   OUTDIVx_DIV1  : constant := 2#0000#; -- Divide-by-1.
   OUTDIVx_DIV2  : constant := 2#0001#; -- Divide-by-2.
   OUTDIVx_DIV3  : constant := 2#0010#; -- Divide-by-3.
   OUTDIVx_DIV4  : constant := 2#0011#; -- Divide-by-4.
   OUTDIVx_DIV5  : constant := 2#0100#; -- Divide-by-5.
   OUTDIVx_DIV6  : constant := 2#0101#; -- Divide-by-6.
   OUTDIVx_DIV7  : constant := 2#0110#; -- Divide-by-7.
   OUTDIVx_DIV8  : constant := 2#0111#; -- Divide-by-8.
   OUTDIVx_DIV9  : constant := 2#1000#; -- Divide-by-9.
   OUTDIVx_DIV10 : constant := 2#1001#; -- Divide-by-10.
   OUTDIVx_DIV11 : constant := 2#1010#; -- Divide-by-11.
   OUTDIVx_DIV12 : constant := 2#1011#; -- Divide-by-12.
   OUTDIVx_DIV13 : constant := 2#1100#; -- Divide-by-13.
   OUTDIVx_DIV14 : constant := 2#1101#; -- Divide-by-14.
   OUTDIVx_DIV15 : constant := 2#1110#; -- Divide-by-15.
   OUTDIVx_DIV16 : constant := 2#1111#; -- Divide-by-16.

   type SIM_CLKDIV1_Type is record
      Reserved : Bits_16 := 0;
      OUTDIV4  : Bits_4  := OUTDIVx_DIV1; -- Clock 4 Output Divider value
      OUTDIV3  : Bits_4  := OUTDIVx_DIV1; -- Clock 3 Output Divider value
      OUTDIV2  : Bits_4  := OUTDIVx_DIV1; -- Clock 2 Output Divider value
      OUTDIV1  : Bits_4  := OUTDIVx_DIV1; -- Clock 1 Output Divider value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_CLKDIV1_Type use record
      Reserved at 0 range  0 .. 15;
      OUTDIV4  at 0 range 16 .. 19;
      OUTDIV3  at 0 range 20 .. 23;
      OUTDIV2  at 0 range 24 .. 27;
      OUTDIV1  at 0 range 28 .. 31;
   end record;

   SIM_CLKDIV1 : aliased SIM_CLKDIV1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1044#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.17 System Clock Divider Register 2 (SIM_CLKDIV2)

   type SIM_CLKDIV2_Type is record
      USBFSFRAC : Bits_1  := 0; -- USB FS clock divider fraction
      USBFSDIV  : Bits_3  := 0; -- USB FS clock divider divisor
      Reserved1 : Bits_4  := 0;
      USBHSFRAC : Bits_1  := 0; -- USB HS clock divider fraction
      USBHSDIV  : Bits_3  := 0; -- USB HS clock divider divisor
      Reserved2 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_CLKDIV2_Type use record
      USBFSFRAC at 0 range  0 ..  0;
      USBFSDIV  at 0 range  1 ..  3;
      Reserved1 at 0 range  4 ..  7;
      USBHSFRAC at 0 range  8 ..  8;
      USBHSDIV  at 0 range  9 .. 11;
      Reserved2 at 0 range 12 .. 31;
   end record;

   SIM_CLKDIV2 : aliased SIM_CLKDIV2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1048#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.18 Flash Configuration Register 1 (SIM_FCFG1)

   -- Table 30-4. FlexNVM partition code field description
   -- DEPART                                   Data flash (KByte) EEPROM backup (KByte)
   DEPART_D256E0     : constant := 2#0000#; -- 256                0
   DEPART_RSVD1      : constant := 2#0001#; -- Reserved           Reserved
   DEPART_RSVD2      : constant := 2#0010#; -- Reserved           Reserved
   DEPART_RSVD3      : constant := 2#0011#; -- Reserved           Reserved
   DEPART_D192E64    : constant := 2#0100#; -- 192                64
   DEPART_D128E128   : constant := 2#0101#; -- 128                128
   DEPART_D0E256     : constant := 2#0110#; -- 0                  256
   DEPART_RSVD4      : constant := 2#0111#; -- Reserved           Reserved
   DEPART_D0E256_2   : constant := 2#1000#; -- 0                  256
   DEPART_RSVD5      : constant := 2#1001#; -- Reserved           Reserved
   DEPART_RSVD6      : constant := 2#1010#; -- Reserved           Reserved
   DEPART_RSVD7      : constant := 2#1011#; -- Reserved           Reserved
   DEPART_D64E192    : constant := 2#1100#; -- 64                 192
   DEPART_D128E128_2 : constant := 2#1101#; -- 128                128
   DEPART_D256E0_2   : constant := 2#1110#; -- 256                0
   DEPART_D256E0_3   : constant := 2#1111#; -- 256                0

   EESIZE_16k   : constant := 2#0000#; -- 16 KB
   EESIZE_8k    : constant := 2#0001#; -- 8 KB
   EESIZE_4k    : constant := 2#0010#; -- 4 KB
   EESIZE_2k    : constant := 2#0011#; -- 2 KB
   EESIZE_1k    : constant := 2#0100#; -- 1 KB
   EESIZE_512   : constant := 2#0101#; -- 512 Bytes
   EESIZE_256   : constant := 2#0110#; -- 256 Bytes
   EESIZE_128   : constant := 2#0111#; -- 128 Bytes
   EESIZE_64    : constant := 2#1000#; -- 64 Bytes
   EESIZE_32    : constant := 2#1001#; -- 32 Bytes
   EESIZE_RSVD1 : constant := 2#1010#; -- Reserved
   EESIZE_RSVD2 : constant := 2#1011#; -- Reserved
   EESIZE_RSVD3 : constant := 2#1100#; -- Reserved
   EESIZE_RSVD4 : constant := 2#1101#; -- Reserved
   EESIZE_RSVD5 : constant := 2#1110#; -- Reserved
   EESIZE_0     : constant := 2#1111#; -- 0 Bytes

   PFSIZE_RSVD1      : constant := 2#0000#; -- Reserved
   PFSIZE_RSVD2      : constant := 2#0001#; -- Reserved
   PFSIZE_RSVD3      : constant := 2#0010#; -- Reserved
   PFSIZE_RSVD4      : constant := 2#0011#; -- Reserved
   PFSIZE_RSVD5      : constant := 2#0100#; -- Reserved
   PFSIZE_RSVD6      : constant := 2#0101#; -- Reserved
   PFSIZE_RSVD7      : constant := 2#0110#; -- Reserved
   PFSIZE_RSVD8      : constant := 2#0111#; -- Reserved
   PFSIZE_RSVD9      : constant := 2#1000#; -- Reserved
   PFSIZE_RSVD10     : constant := 2#1001#; -- Reserved
   PFSIZE_RSVD11     : constant := 2#1010#; -- Reserved
   PFSIZE_512k16p    : constant := 2#1011#; -- 512 KB, 16 KB protection size
   PFSIZE_RSVD12     : constant := 2#1100#; -- Reserved
   PFSIZE_1024k32p   : constant := 2#1101#; -- 1024 KB, 32 KB protection size
   PFSIZE_RSVD13     : constant := 2#1110#; -- Reserved
   PFSIZE_1024k32p_2 : constant := 2#1111#; -- 1024 KB, 32 KB protection size

   NVMSIZE_0k        : constant := 2#0000#; -- 0 KB
   NVMSIZE_RSVD1     : constant := 2#0001#; -- Reserved
   NVMSIZE_RSVD2     : constant := 2#0010#; -- Reserved
   NVMSIZE_RSVD3     : constant := 2#0011#; -- Reserved
   NVMSIZE_RSVD4     : constant := 2#0100#; -- Reserved
   NVMSIZE_RSVD5     : constant := 2#0101#; -- Reserved
   NVMSIZE_RSVD6     : constant := 2#0110#; -- Reserved
   NVMSIZE_RSVD7     : constant := 2#0111#; -- Reserved
   NVMSIZE_RSVD8     : constant := 2#1000#; -- Reserved
   NVMSIZE_RSVD9     : constant := 2#1001#; -- Reserved
   NVMSIZE_RSVD10    : constant := 2#1010#; -- Reserved
   NVMSIZE_512k16p   : constant := 2#1011#; -- 512 KB, 16 KB protection region
   NVMSIZE_RSVD11    : constant := 2#1100#; -- Reserved
   NVMSIZE_RSVD12    : constant := 2#1101#; -- Reserved
   NVMSIZE_RSVD13    : constant := 2#1110#; -- Reserved
   NVMSIZE_512k16p_2 : constant := 2#1111#; -- 512 KB, 16 KB protection region

   type SIM_FCFG1_Type is record
      FTFDIS    : Boolean := False;          -- Disable FTFE
      Reserved1 : Bits_7  := 0;
      DEPART    : Bits_4  := DEPART_D256E0;  -- FlexNVM partition
      Reserved2 : Bits_4  := 0;
      EESIZE    : Bits_4  := EESIZE_16k;     -- EEPROM size
      Reserved3 : Bits_4  := 0;
      PFSIZE    : Bits_4  := PFSIZE_512k16p; -- Program flash size
      NVMSIZE   : Bits_4  := NVMSIZE_0k;     -- FlexNVM size
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_FCFG1_Type use record
      FTFDIS    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      DEPART    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      EESIZE    at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      PFSIZE    at 0 range 24 .. 27;
      NVMSIZE   at 0 range 28 .. 31;
   end record;

   SIM_FCFG1 : aliased SIM_FCFG1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#104C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.19 Flash Configuration Register 2 (SIM_FCFG2)

   type SIM_FCFG2_Type is record
      Reserved1 : Bits_16 := 0;
      MAXADDR23 : Bits_6  := 0;     -- Max address block 2 or 3
      Reserved2 : Bits_1  := 0;
      PFLSH     : Boolean := False; -- Program flash only
      MAXADDR01 : Bits_6  := 0;     -- Max address block 0 or 1
      Reserved3 : Bits_1  := 0;
      SWAPPFLSH : Boolean := False; -- Swap program flash
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_FCFG2_Type use record
      Reserved1 at 0 range  0 .. 15;
      MAXADDR23 at 0 range 16 .. 21;
      Reserved2 at 0 range 22 .. 22;
      PFLSH     at 0 range 23 .. 23;
      MAXADDR01 at 0 range 24 .. 29;
      Reserved3 at 0 range 30 .. 30;
      SWAPPFLSH at 0 range 31 .. 31;
   end record;

   SIM_FCFG2 : aliased SIM_FCFG2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1050#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.20 Unique Identification Register High (SIM_UIDH)

   SIM_UIDH : aliased Unsigned_32
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1054#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.21 Unique Identification Register Mid-High (SIM_UIDMH)

   SIM_UIDMH : aliased Unsigned_32
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1058#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.22 Unique Identification Register Mid Low (SIM_UIDML)

   SIM_UIDML : aliased Unsigned_32
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#105C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.23 Unique Identification Register Low (SIM_UIDL)

   SIM_UIDL : aliased Unsigned_32
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1060#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.24 System Clock Divider Register 4 (SIM_CLKDIV4)

   type SIM_CLKDIV4_Type is record
      TRACEFRAC : Bits_1  := 0;      -- Trace clock divider fraction
      TRACEDIV  : Bits_3  := 2#001#; -- Trace clock divider divisor
      Reserved  : Bits_20 := 0;
      NFCFRAC   : Bits_3  := 0;      -- NFC clock divider fraction
      NFCDIV    : Bits_5  := 0;      -- NFC clock divider divisor
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_CLKDIV4_Type use record
      TRACEFRAC at 0 range  0 ..  0;
      TRACEDIV  at 0 range  1 ..  3;
      Reserved  at 0 range  4 .. 23;
      NFCFRAC   at 0 range 24 .. 26;
      NFCDIV    at 0 range 27 .. 31;
   end record;

   SIM_CLKDIV4 : aliased SIM_CLKDIV4_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1068#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.25 Misc Control Register (SIM_MCR)

   DDRCFG_LPDDRHS : constant := 2#000#; -- LPDDR Half Strength
   DDRCFG_LPDDRFS : constant := 2#001#; -- LPDDR Full Strength
   DDRCFG_DDR2HS  : constant := 2#010#; -- DDR2 Half Strength
   DDRCFG_DDR1    : constant := 2#011#; -- DDR1
   DDRCFG_RSVD1   : constant := 2#100#; -- Reserved
   DDRCFG_RSVD2   : constant := 2#101#; -- Reserved
   DDRCFG_DDR2FS  : constant := 2#110#; -- DDR2 Full Strength
   DDRCFG_RSVD3   : constant := 2#111#; -- Reserved

   type SIM_MCR_Type is record
      DDRSREN     : Boolean := False;          -- DDR self refresh enable
      DDRS        : Boolean := False;          -- DDR Self Refresh Status
      DDRPEN      : Boolean := False;          -- Pin enable for all DDR I/O
      DDRDQSDIS   : Boolean := False;          -- DDR_DQS analog circuit disable
      Reserved1   : Bits_1  := 0;
      DDRCFG      : Bits_3  := DDRCFG_LPDDRHS; -- DDR configuration select
      RCRRSTEN    : Boolean := False;          -- DDR RCR Special Reset Enable
      RCRRST      : Boolean := False;          -- DDR RCR Reset Status
      Reserved2   : Bits_6  := 0;
      Reserved3   : Bits_1  := 0;
      Reserved4   : Bits_12 := 0;
      PDBLOOP     : Boolean := False;          -- PDB Loop Mode
      Reserved5   : Bits_1  := 0;
      TRACECLKDIS : Boolean := False;          -- Trace clock disable.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_MCR_Type use record
      DDRSREN     at 0 range  0 ..  0;
      DDRS        at 0 range  1 ..  1;
      DDRPEN      at 0 range  2 ..  2;
      DDRDQSDIS   at 0 range  3 ..  3;
      Reserved1   at 0 range  4 ..  4;
      DDRCFG      at 0 range  5 ..  7;
      RCRRSTEN    at 0 range  8 ..  8;
      RCRRST      at 0 range  9 ..  9;
      Reserved2   at 0 range 10 .. 15;
      Reserved3   at 0 range 16 .. 16;
      Reserved4   at 0 range 17 .. 28;
      PDBLOOP     at 0 range 29 .. 29;
      Reserved5   at 0 range 30 .. 30;
      TRACECLKDIS at 0 range 31 .. 31;
   end record;

   SIM_MCR : aliased SIM_MCR_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#106C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 17 Miscellaneous Control Module (MCM)
   ----------------------------------------------------------------------------

   MCM_BASEADDRESS : constant := 16#E008_0000#;

   -- 17.2.1 Crossbar Switch (AXBS) Slave Configuration (MCM_PLASC)

   type MCM_PLASC_Type is record
      ASC      : Bitmap_8; -- Each bit in the ASC field indicates whether there is a corresponding connection to the crossbar switch's slave input port.
      Reserved : Bits_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for MCM_PLASC_Type use record
      ASC      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   MCM_PLASC : aliased MCM_PLASC_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.2 Crossbar Switch (AXBS) Master Configuration (MCM_PLAMC)

   type MCM_PLAMC_Type is record
      AMC      : Bitmap_8; -- Each bit in the AMC field indicates whether there is a corresponding connection to the AXBS master input port.
      Reserved : Bits_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for MCM_PLAMC_Type use record
      AMC      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   MCM_PLAMC : aliased MCM_PLAMC_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#0A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.3 Control register (MCM_CR)

   DDRSIZE_NONE : constant := 2#00#; -- DDR address translation is disabled
   DDRSIZE_128M : constant := 2#01#; -- DDR size is 128 Mbytes
   DDRSIZE_256M : constant := 2#10#; -- DDR size is 256 Mbytes
   DDRSIZE_512M : constant := 2#11#; -- DDR size is 512 Mbytes

   SRAMUAP_RR   : constant := 2#00#; -- Round robin
   SRAMUAP_SRR  : constant := 2#01#; -- Special round robin (favors SRAM backoor accesses over the processor)
   SRAMUAP_PROC : constant := 2#10#; -- Fixed priority. Processor has highest, backdoor has lowest
   SRAMUAP_BD   : constant := 2#11#; -- Fixed priority. Backdoor has highest, processor has lowest

   SRAMLAP_RR   : constant := 2#00#; -- Round robin
   SRAMLAP_SRR  : constant := 2#01#; -- Special round robin (favors SRAM backoor accesses over the processor)
   SRAMLAP_PROC : constant := 2#10#; -- Fixed priority. Processor has highest, backdoor has lowest
   SRAMLAP_BD   : constant := 2#11#; -- Fixed priority. Backdoor has highest, processor has lowest

   type MCM_CR_Type is record
      Reserved1 : Bits_9  := 0;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_10 := 0;
      DDRSIZE   : Bits_2  := DDRSIZE_128M; -- DDR address size translation
      Reserved4 : Bits_2  := 0;
      SRAMUAP   : Bits_2  := SRAMUAP_RR;   -- SRAM_U arbitration priority
      SRAMUWP   : Boolean := False;        -- SRAM_U write protect
      Reserved5 : Bits_1  := 0;
      SRAMLAP   : Bits_2  := SRAMLAP_RR;   -- SRAM_L arbitration priority
      SRAMLWP   : Boolean := False;        -- SRAM_L write protect
      Reserved6 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_CR_Type use record
      Reserved1 at 0 range  0 ..  8;
      Reserved2 at 0 range  9 ..  9;
      Reserved3 at 0 range 10 .. 19;
      DDRSIZE   at 0 range 20 .. 21;
      Reserved4 at 0 range 22 .. 23;
      SRAMUAP   at 0 range 24 .. 25;
      SRAMUWP   at 0 range 26 .. 26;
      Reserved5 at 0 range 27 .. 27;
      SRAMLAP   at 0 range 28 .. 29;
      SRAMLWP   at 0 range 30 .. 30;
      Reserved6 at 0 range 31 .. 31;
   end record;

   MCM_CR : aliased MCM_CR_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.4 Interrupt Status and Control Register (MCM_ISCR)

   type MCM_ISCR_Type is record
      Reserved1 : Bits_1  := 0;
      IRQ       : Boolean := False; -- Normal Interrupt Pending
      NMI       : Boolean := False; -- Non-maskable Interrupt Pending
      DHREQ     : Boolean := False; -- Debug Halt Request Indicator
      CWBER     : Boolean := False; -- Cache write buffer error status
      Reserved2 : Bits_3  := 0;
      FIOC      : Boolean := False; -- FPU invalid operation interrupt status
      FDZC      : Boolean := False; -- FPU divide-by-zero interrupt status
      FOFC      : Boolean := False; -- FPU overflow interrupt status
      FUFC      : Boolean := False; -- FPU underflow interrupt status
      FIXC      : Boolean := False; -- FPU inexact interrupt status
      Reserved3 : Bits_2  := 0;
      FIDC      : Boolean := False; -- FPU input denormal interrupt status
      Reserved4 : Bits_4  := 0;
      CWBEE     : Boolean := False; -- Cache write buffer error enable
      Reserved5 : Bits_3  := 0;
      FIOCE     : Boolean := False; -- FPU invalid operation interrupt enable
      FDZCE     : Boolean := False; -- FPU divide-by-zero interrupt enable
      FOFCE     : Boolean := False; -- FPU overflow interrupt enable
      FUFCE     : Boolean := False; -- FPU underflow interrupt enable
      FIXCE     : Boolean := False; -- FPU inexact interrupt enable
      Reserved6 : Bits_2  := 0;
      FIDCE     : Boolean := False; -- FPU input denormal interrupt enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_ISCR_Type use record
      Reserved1 at 0 range  0 ..  0;
      IRQ       at 0 range  1 ..  1;
      NMI       at 0 range  2 ..  2;
      DHREQ     at 0 range  3 ..  3;
      CWBER     at 0 range  4 ..  4;
      Reserved2 at 0 range  5 ..  7;
      FIOC      at 0 range  8 ..  8;
      FDZC      at 0 range  9 ..  9;
      FOFC      at 0 range 10 .. 10;
      FUFC      at 0 range 11 .. 11;
      FIXC      at 0 range 12 .. 12;
      Reserved3 at 0 range 13 .. 14;
      FIDC      at 0 range 15 .. 15;
      Reserved4 at 0 range 16 .. 19;
      CWBEE     at 0 range 20 .. 20;
      Reserved5 at 0 range 21 .. 23;
      FIOCE     at 0 range 24 .. 24;
      FDZCE     at 0 range 25 .. 25;
      FOFCE     at 0 range 26 .. 26;
      FUFCE     at 0 range 27 .. 27;
      FIXCE     at 0 range 28 .. 28;
      Reserved6 at 0 range 29 .. 30;
      FIDCE     at 0 range 31 .. 31;
   end record;

   MCM_ISCR : aliased MCM_ISCR_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.5 ETB Counter Control register (MCM_ETBCC)

   RSPT_NONE  : constant := 2#00#; -- No response when the ETB count expires
   RSPT_IRQ   : constant := 2#01#; -- Generate a normal interrupt when the ETB count expires
   RSPT_NMI   : constant := 2#10#; -- Generate an NMI when the ETB count expires
   RSPT_DHREQ : constant := 2#11#; -- Generate a debug halt when the ETB count expires

   type MCM_ETBCC_Type is record
      CNTEN    : Boolean := False;     -- Counter Enable
      RSPT     : Bits_2  := RSPT_NONE; -- Response Type
      RLRQ     : Boolean := False;     -- Reload Request
      ETDIS    : Boolean := False;     -- ETM-To-TPIU Disable
      ITDIS    : Boolean := False;     -- ITM-To-TPIU Disable
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_ETBCC_Type use record
      CNTEN    at 0 range 0 ..  0;
      RSPT     at 0 range 1 ..  2;
      RLRQ     at 0 range 3 ..  3;
      ETDIS    at 0 range 4 ..  4;
      ITDIS    at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   MCM_ETBCC : aliased MCM_ETBCC_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.6 ETB Reload register (MCM_ETBRL)

   type MCM_ETBRL_Type is record
      RELOAD   : Bits_11 := 0; -- Byte Count Reload Value
      Reserved : Bits_21 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_ETBRL_Type use record
      RELOAD   at 0 range  0 .. 10;
      Reserved at 0 range 11 .. 31;
   end record;

   MCM_ETBRL : aliased MCM_ETBRL_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.7 ETB Counter Value register (MCM_ETBCNT)

   type MCM_ETBCNT_Type is record
      COUNTER  : Bits_11; -- Byte Count Counter Value
      Reserved : Bits_21;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_ETBCNT_Type use record
      COUNTER  at 0 range  0 .. 10;
      Reserved at 0 range 11 .. 31;
   end record;

   MCM_ETBCNT : aliased MCM_ETBCNT_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#1C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.8 Fault address register (MCM_FADR)

   type MCM_FADR_Type is record
      ADDRESS : Unsigned_32; -- Fault address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_FADR_Type use record
      ADDRESS at 0 range 0 .. 31;
   end record;

   MCM_FADR : aliased MCM_FADR_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#20#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.9 Fault attributes register (MCM_FATR)

   BEDA_INSTR : constant := 0; -- Instruction
   BEDA_DATA  : constant := 1; -- Data

   BEMD_USER : constant := 0; -- User mode
   BEMD_SUPV : constant := 1; -- Supervisor/privileged mode

   BESZ_8    : constant := 2#00#; -- 8-bit access
   BESZ_16   : constant := 2#01#; -- 16-bit access
   BESZ_32   : constant := 2#10#; -- 32-bit access
   BESZ_RSVD : constant := 2#11#; -- Reserved

   BEWT_READ  : constant := 0; -- Read access
   BEWT_WRITE : constant := 1; -- Write access

   type MCM_FATR_Type is record
      BEDA      : Bits_1;  -- Bus error access type
      BEMD      : Bits_1;  -- Bus error privilege level
      Reserved1 : Bits_2;
      BESZ      : Bits_2;  -- Bus error size
      Reserved2 : Bits_1;
      BEWT      : Bits_1;  -- Bus error write
      BEMN      : Bits_4;  -- Bus error master number
      Reserved3 : Bits_19;
      BEOVR     : Boolean; -- Bus error overrun
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_FATR_Type use record
      BEDA      at 0 range  0 ..  0;
      BEMD      at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      BESZ      at 0 range  4 ..  5;
      Reserved2 at 0 range  6 ..  6;
      BEWT      at 0 range  7 ..  7;
      BEMN      at 0 range  8 .. 11;
      Reserved3 at 0 range 12 .. 30;
      BEOVR     at 0 range 31 .. 31;
   end record;

   MCM_FATR : aliased MCM_FATR_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#24#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.10 Fault data register (MCM_FDR)

   type MCM_FDR_Type is record
      DATA : Unsigned_32; -- Fault data
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_FDR_Type use record
      DATA at 0 range 0 .. 31;
   end record;

   MCM_FDR : aliased MCM_FDR_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#28#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.2.11 Process ID register (MCM_PID)

   type MCM_PID_Type is record
      PID      : Bits_8  := 0; -- M0_PID And M1_PID For MPU
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_PID_Type use record
      PID      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   MCM_PID : aliased MCM_PID_Type
      with Address              => System'To_Address (MCM_BASEADDRESS + 16#30#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 24 Watchdog Timer (WDOG)
   ----------------------------------------------------------------------------

   WDOG_BASEADDRESS : constant := 16#4005_2000#;

   -- 24.7.1 Watchdog Status and Control Register High (WDOG_STCTRLH)

   type WDOG_STCTRLH_Type is record
      WDOGEN   : Boolean;      -- Enables or disables the WDOG’s operation.
      Reserved : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for WDOG_STCTRLH_Type use record
      WDOGEN   at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   WDOG_STCTRLH : aliased WDOG_STCTRLH_Type
      with Address              => System'To_Address (WDOG_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.7.8 Watchdog Unlock register (WDOG_UNLOCK)

   WDOG_UNLOCK_KEY1 : constant := 16#C520#;
   WDOG_UNLOCK_KEY2 : constant := 16#D928#;

   WDOG_UNLOCK : aliased Unsigned_16
      with Address              => System'To_Address (WDOG_BASEADDRESS + 16#0E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 25 Multipurpose Clock Generator (MCG)
   ----------------------------------------------------------------------------

   MCG_BASEADDRESS : constant := 16#4006_4000#;

   -- 25.3.1 MCG Control 1 Register (MCG_C1)

   IREFS_EXT : constant := 0; -- External reference clock is selected.
   IREFS_INT : constant := 1; -- The slow internal reference clock is selected.

   FRDIV_1_32     : constant := 2#000#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 1; for all other RANGE 0 values, Divide Factor is 32.
   FRDIV_2_64     : constant := 2#001#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 2; for all other RANGE 0 values, Divide Factor is 64.
   FRDIV_4_128    : constant := 2#010#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 4; for all other RANGE 0 values, Divide Factor is 128.
   FRDIV_8_256    : constant := 2#011#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 8; for all other RANGE 0 values, Divide Factor is 256.
   FRDIV_16_512   : constant := 2#100#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 16; for all other RANGE 0 values, Divide Factor is 512.
   FRDIV_32_1024  : constant := 2#101#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 32; for all other RANGE 0 values, Divide Factor is 1024.
   FRDIV_64_1280  : constant := 2#110#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 64; for all other RANGE 0 values, Divide Factor is 1280 .
   FRDIV_128_1536 : constant := 2#111#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 128; for all other RANGE 0 values, Divide Factor is 1536 .

   CLKS_FLLPLLCS : constant := 2#00#; -- Encoding 0 — Output of FLL or PLLCS is selected (depends on PLLS control bit).
   CLKS_INT      : constant := 2#01#; -- Encoding 1 — Internal reference clock is selected.
   CLKS_EXT      : constant := 2#10#; -- Encoding 2 — External reference clock is selected.
   CLKS_RSVD     : constant := 2#11#; -- Encoding 3 — Reserved.

   type MCG_C1_Type is record
      IREFSTEN : Boolean := False;         -- Internal Reference Stop Enable
      IRCLKEN  : Boolean := False;         -- Internal Reference Clock Enable
      IREFS    : Bits_1  := IREFS_INT;     -- Internal Reference Select
      FRDIV    : Bits_3  := FRDIV_1_32;    -- FLL External Reference Divider
      CLKS     : Bits_2  := CLKS_FLLPLLCS; -- Clock Source Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C1_Type use record
      IREFSTEN at 0 range 0 .. 0;
      IRCLKEN  at 0 range 1 .. 1;
      IREFS    at 0 range 2 .. 2;
      FRDIV    at 0 range 3 .. 5;
      CLKS     at 0 range 6 .. 7;
   end record;

   MCG_C1 : aliased MCG_C1_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.2 MCG Control 2 Register (MCG_C2)

   IRCS_SLOW : constant := 0; -- Slow internal reference clock selected.
   IRCS_FAST : constant := 1; -- Fast internal reference clock selected.

   EREFS0_EXT : constant := 0; -- External reference clock requested.
   EREFS0_OSC : constant := 1; -- Oscillator requested.

   RANGE0_LO   : constant := 2#00#; -- Encoding 0 — Low frequency range selected for the crystal oscillator .
   RANGE0_HI   : constant := 2#01#; -- Encoding 1 — High frequency range selected for the crystal oscillator .
   RANGE0_VHI1 : constant := 2#10#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .
   RANGE0_VHI2 : constant := 2#11#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .

   LOCRE0_IRQ : constant := 0; -- Interrupt request is generated on a loss of OSC0 external reference clock.
   LOCRE0_RES : constant := 1; -- Generate a reset request on a loss of OSC0 external reference clock.

   type MCG_C2_Type is record
      IRCS     : Bits_1  := IRCS_SLOW;  -- Internal Reference Clock Select
      LP       : Boolean := False;      -- Low Power Select
      EREFS0   : Bits_1  := EREFS0_EXT; -- External Reference Select
      HGO0     : Boolean := False;      -- High Gain Oscillator Select
      RANGE0   : Bits_2  := RANGE0_LO;  -- Frequency Range Select
      Reserved : Bits_1  := 0;
      LOCRE0   : Bits_1  := LOCRE0_RES; -- Loss of Clock Reset Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C2_Type use record
      IRCS     at 0 range 0 .. 0;
      LP       at 0 range 1 .. 1;
      EREFS0   at 0 range 2 .. 2;
      HGO0     at 0 range 3 .. 3;
      RANGE0   at 0 range 4 .. 5;
      Reserved at 0 range 6 .. 6;
      LOCRE0   at 0 range 7 .. 7;
   end record;

   MCG_C2 : aliased MCG_C2_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#01#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.3 MCG Control 3 Register (MCG_C3)

   type MCG_C3_Type is record
      SCTRIM : Bits_8; -- Slow Internal Reference Clock Trim Setting
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C3_Type use record
      SCTRIM at 0 range 0 .. 7;
   end record;

   MCG_C3 : aliased MCG_C3_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#02#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.4 MCG Control 4 Register (MCG_C4)

                                   -- DMX32  Reference Range    FLL Factor  DCO Range
   DRST_DRS_1 : constant := 2#00#; -- 0      31.25–39.0625 kHz  640         20–25 MHz
                                   -- 1      32.768 kHz         732         24 MHz
   DRST_DRS_2 : constant := 2#01#; -- 0      31.25–39.0625 kHz  1280        40–50 MHz
                                   -- 1      32.768 kHz         1464        48 MHz
   DRST_DRS_3 : constant := 2#10#; -- 0      31.25–39.0625 kHz  1920        60–75 MHz
                                   -- 1      32.768 kHz         2197        72 MHz
   DRST_DRS_4 : constant := 2#11#; -- 0      31.25–39.0625 kHz  2560        80–100 MHz
                                   -- 1      32.768 kHz         2929        96 MHz

   type MCG_C4_Type is record
      SCFTRIM  : Boolean;               -- Slow Internal Reference Clock Fine Trim
      FCTRIM   : Bits_4;                -- Fast Internal Reference Clock Trim Setting
      DRST_DRS : Bits_2  := DRST_DRS_1; -- DCO Range Select
      DMX32    : Boolean := False;      -- DCO Maximum Frequency with 32.768 kHz Reference
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C4_Type use record
      SCFTRIM  at 0 range 0 .. 0;
      FCTRIM   at 0 range 1 .. 4;
      DRST_DRS at 0 range 5 .. 6;
      DMX32    at 0 range 7 .. 7;
   end record;

   MCG_C4 : aliased MCG_C4_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#03#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.5 MCG Control 5 Register (MCG_C5)

   PRDIV0_DIV1 : constant := 2#000#; -- Divide Factor 1
   PRDIV0_DIV2 : constant := 2#001#; -- Divide Factor 2
   PRDIV0_DIV3 : constant := 2#010#; -- Divide Factor 3
   PRDIV0_DIV4 : constant := 2#011#; -- Divide Factor 4
   PRDIV0_DIV5 : constant := 2#100#; -- Divide Factor 5
   PRDIV0_DIV6 : constant := 2#101#; -- Divide Factor 6
   PRDIV0_DIV7 : constant := 2#110#; -- Divide Factor 7
   PRDIV0_DIV8 : constant := 2#111#; -- Divide Factor 8

   PLLREFSEL0_OSC0 : constant := 0; -- Selects OSC0 clock source as its external reference clock.
   PLLREFSEL0_OSC1 : constant := 1; -- Selects OSC1 clock source as its external reference clock.

   type MCG_C5_Type is record
      PRDIV0     : Bits_3  := PRDIV0_DIV1;     -- PLL0 External Reference Divider
      Reserved   : Bits_2  := 0;
      PLLSTEN0   : Boolean := False;           -- PLL0 Stop Enable
      PLLCLKEN0  : Boolean := False;           -- PLL Clock Enable
      PLLREFSEL0 : Bits_1  := PLLREFSEL0_OSC0; -- PLL0 External Reference Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C5_Type use record
      PRDIV0     at 0 range 0 .. 2;
      Reserved   at 0 range 3 .. 4;
      PLLSTEN0   at 0 range 5 .. 5;
      PLLCLKEN0  at 0 range 6 .. 6;
      PLLREFSEL0 at 0 range 7 .. 7;
   end record;

   MCG_C5 : aliased MCG_C5_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.6 MCG Control 6 Register (MCG_C6)

   VDIV0_x16 : constant := 2#00000#; -- Multiply Factor 16
   VDIV0_x17 : constant := 2#00001#; -- Multiply Factor 17
   VDIV0_x18 : constant := 2#00010#; -- Multiply Factor 18
   VDIV0_x19 : constant := 2#00011#; -- Multiply Factor 19
   VDIV0_x20 : constant := 2#00100#; -- Multiply Factor 20
   VDIV0_x21 : constant := 2#00101#; -- Multiply Factor 21
   VDIV0_x22 : constant := 2#00110#; -- Multiply Factor 22
   VDIV0_x23 : constant := 2#00111#; -- Multiply Factor 23
   VDIV0_x24 : constant := 2#01000#; -- Multiply Factor 24
   VDIV0_x25 : constant := 2#01001#; -- Multiply Factor 25
   VDIV0_x26 : constant := 2#01010#; -- Multiply Factor 26
   VDIV0_x27 : constant := 2#01011#; -- Multiply Factor 27
   VDIV0_x28 : constant := 2#01100#; -- Multiply Factor 28
   VDIV0_x29 : constant := 2#01101#; -- Multiply Factor 29
   VDIV0_x30 : constant := 2#01110#; -- Multiply Factor 30
   VDIV0_x31 : constant := 2#01111#; -- Multiply Factor 31
   VDIV0_x32 : constant := 2#10000#; -- Multiply Factor 32
   VDIV0_x33 : constant := 2#10001#; -- Multiply Factor 33
   VDIV0_x34 : constant := 2#10010#; -- Multiply Factor 34
   VDIV0_x35 : constant := 2#10011#; -- Multiply Factor 35
   VDIV0_x36 : constant := 2#10100#; -- Multiply Factor 36
   VDIV0_x37 : constant := 2#10101#; -- Multiply Factor 37
   VDIV0_x38 : constant := 2#10110#; -- Multiply Factor 38
   VDIV0_x39 : constant := 2#10111#; -- Multiply Factor 39
   VDIV0_x40 : constant := 2#11000#; -- Multiply Factor 40
   VDIV0_x41 : constant := 2#11001#; -- Multiply Factor 41
   VDIV0_x42 : constant := 2#11010#; -- Multiply Factor 42
   VDIV0_x43 : constant := 2#11011#; -- Multiply Factor 43
   VDIV0_x44 : constant := 2#11100#; -- Multiply Factor 44
   VDIV0_x45 : constant := 2#11101#; -- Multiply Factor 45
   VDIV0_x46 : constant := 2#11110#; -- Multiply Factor 46
   VDIV0_x47 : constant := 2#11111#; -- Multiply Factor 47

   PLLS_FLL   : constant := 0; -- FLL is selected.
   PLLS_PLLCS : constant := 1; -- PLLCS output clock is selected

   type MCG_C6_Type is record
      VDIV0  : Bits_5  := VDIV0_x16; -- VCO0 Divider
      CME0   : Boolean := False;     -- Clock Monitor Enable
      PLLS   : Bits_1  := PLLS_FLL;  -- PLL Select
      LOLIE0 : Boolean := False;     -- Loss of Lock Interrrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C6_Type use record
      VDIV0  at 0 range 0 .. 4;
      CME0   at 0 range 5 .. 5;
      PLLS   at 0 range 6 .. 6;
      LOLIE0 at 0 range 7 .. 7;
   end record;

   MCG_C6 : aliased MCG_C6_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#05#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.7 MCG Status Register (MCG_S)

   IRCST_SLOW : constant := 0; -- Source of internal reference clock is the slow clock (32 kHz IRC).
   IRCST_FAST : constant := 1; -- Source of internal reference clock is the fast clock (4 MHz IRC).

   CLKST_FLL : constant := 2#00#; -- Encoding 0 — Output of the FLL is selected (reset default).
   CLKST_INT : constant := 2#01#; -- Encoding 1 — Internal reference clock is selected.
   CLKST_EXT : constant := 2#10#; -- Encoding 2 — External reference clock is selected.
   CLKST_PLL : constant := 2#11#; -- Encoding 3 — Output of the PLL is selected.

   IREFST_EXT : constant := 0; -- Source of FLL reference clock is the external reference clock.
   IREFST_INT : constant := 1; -- Source of FLL reference clock is the internal reference clock.

   PLLST_FLL   : constant := 0; -- Source of PLLS clock is FLL clock.
   PLLST_PLLCS : constant := 1; -- Source of PLLS clock is PLL output clock.

   type MCG_S_Type is record
      IRCST    : Bits_1;  -- Internal Reference Clock Status
      OSCINIT0 : Boolean; -- OSC Initialization
      CLKST    : Bits_2;  -- Clock Mode Status
      IREFST   : Bits_1;  -- Internal Reference Status
      PLLST    : Bits_1;  -- PLL Select Status
      LOCK0    : Boolean; -- Lock Status
      LOLS0    : Boolean; -- Loss of Lock Status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_S_Type use record
      IRCST    at 0 range 0 .. 0;
      OSCINIT0 at 0 range 1 .. 1;
      CLKST    at 0 range 2 .. 3;
      IREFST   at 0 range 4 .. 4;
      PLLST    at 0 range 5 .. 5;
      LOCK0    at 0 range 6 .. 6;
      LOLS0    at 0 range 7 .. 7;
   end record;

   MCG_S : aliased MCG_S_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#06#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.8 MCG Status and Control Register (MCG_SC)

   FCRDIV_DIV1   : constant := 2#000#; -- Divide Factor is 1
   FCRDIV_DIV2   : constant := 2#001#; -- Divide Factor is 2.
   FCRDIV_DIV4   : constant := 2#010#; -- Divide Factor is 4.
   FCRDIV_DIV8   : constant := 2#011#; -- Divide Factor is 8.
   FCRDIV_DIV16  : constant := 2#100#; -- Divide Factor is 16
   FCRDIV_DIV32  : constant := 2#101#; -- Divide Factor is 32
   FCRDIV_DIV64  : constant := 2#110#; -- Divide Factor is 64
   FCRDIV_DIV128 : constant := 2#111#; -- Divide Factor is 128.

   ATMS_32k : constant := 0; -- 32 kHz Internal Reference Clock selected.
   ATMS_4M  : constant := 1; -- 4 MHz Internal Reference Clock selected.

   type MCG_SC_Type is record
      LOCS0    : Boolean := False;       -- OSC0 Loss of Clock Status
      FCRDIV   : Bits_3  := FCRDIV_DIV2; -- Fast Clock Internal Reference Divider
      FLTPRSRV : Boolean := False;       -- FLL Filter Preserve Enable
      ATMF     : Boolean := False;       -- Automatic Trim Machine Fail Flag
      ATMS     : Bits_1  := ATMS_32k;    -- Automatic Trim Machine Select
      ATME     : Boolean := False;       -- Automatic Trim Machine Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_SC_Type use record
      LOCS0    at 0 range 0 .. 0;
      FCRDIV   at 0 range 1 .. 3;
      FLTPRSRV at 0 range 4 .. 4;
      ATMF     at 0 range 5 .. 5;
      ATMS     at 0 range 6 .. 6;
      ATME     at 0 range 7 .. 7;
   end record;

   MCG_SC : aliased MCG_SC_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.9 MCG Auto Trim Compare Value High Register (MCG_ATCVH)

   MCG_ATCVH : aliased Unsigned_8
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.10 MCG Auto Trim Compare Value Low Register (MCG_ATCVL)

   MCG_ATCVL : aliased Unsigned_8
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.11 MCG Control 7 Register (MCG_C7)

   OSCSEL_OSC : constant := 0; -- Selects Oscillator (OSCCLK).
   OSCSEL_RTC : constant := 1; -- Selects 32 kHz RTC Oscillator.

   type MCG_C7_Type is record
      OSCSEL    : Bits_1 := OSCSEL_OSC; -- MCG OSC Clock Select
      Reserved1 : Bits_1 := 0;
      Reserved2 : Bits_4 := 0;
      Reserved3 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C7_Type use record
      OSCSEL    at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 5;
      Reserved3 at 0 range 6 .. 7;
   end record;

   MCG_C7 : aliased MCG_C7_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.12 MCG Control 8 Register (MCG_C8)

   LOCRE1_IRQ : constant := 0; -- Interrupt request is generated on a loss of RTC external reference clock.
   LOCRE1_RES : constant := 1; -- Generate a reset request on a loss of RTC external reference clock

   type MCG_C8_Type is record
      LOCS1     : Boolean := False;      -- RTC Loss of Clock Status
      Reserved1 : Bits_4  := 0;
      CME1      : Boolean := False;      -- Clock Monitor Enable1
      Reserved2 : Bits_1  := 0;
      LOCRE1    : Bits_1  := LOCRE1_RES; -- Loss of Clock Reset Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C8_Type use record
      LOCS1     at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 4;
      CME1      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      LOCRE1    at 0 range 7 .. 7;
   end record;

   MCG_C8 : aliased MCG_C8_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0D#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.13 MCG Control 10 Register (MCG_C10)

   EREFS1_EXT : constant := 0; -- External reference clock requested.
   EREFS1_OSC : constant := 1; -- Oscillator requested.

   RANGE1_LO   : constant := 2#00#; -- Encoding 0 — Low frequency range selected for the crystal oscillator .
   RANGE1_HI   : constant := 2#01#; -- Encoding 1 — High frequency range selected for the crystal oscillator .
   RANGE1_VHI1 : constant := 2#10#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .
   RANGE1_VHI2 : constant := 2#11#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .

   LOCRE2_IRQ : constant := 0; -- Interrupt request is generated on a loss of OSC0 external reference clock.
   LOCRE2_RES : constant := 1; -- Generate a reset request on a loss of OSC0 external reference clock.

   type MCG_C10_Type is record
      Reserved1 : Bits_2  := 0;
      EREFS1    : Bits_1  := EREFS1_EXT; -- External Reference Select
      HGO1      : Boolean := False;      -- High Gain Oscillator1 Select
      RANGE1    : Bits_2  := RANGE1_LO;  -- Frequency Range1 Select
      Reserved2 : Bits_1  := 0;
      LOCRE2    : Bits_1  := LOCRE2_RES; -- OSC1 Loss of Clock Reset Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C10_Type use record
      Reserved1 at 0 range 0 .. 1;
      EREFS1    at 0 range 2 .. 2;
      HGO1      at 0 range 3 .. 3;
      RANGE1    at 0 range 4 .. 5;
      Reserved2 at 0 range 6 .. 6;
      LOCRE2    at 0 range 7 .. 7;
   end record;

   MCG_C10 : aliased MCG_C10_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0F#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.14 MCG Control 11 Register (MCG_C11)

   PRDIV1_DIV1 : constant := 2#000#; -- Divide Factor 1
   PRDIV1_DIV2 : constant := 2#001#; -- Divide Factor 2
   PRDIV1_DIV3 : constant := 2#010#; -- Divide Factor 3
   PRDIV1_DIV4 : constant := 2#011#; -- Divide Factor 4
   PRDIV1_DIV5 : constant := 2#100#; -- Divide Factor 5
   PRDIV1_DIV6 : constant := 2#101#; -- Divide Factor 6
   PRDIV1_DIV7 : constant := 2#110#; -- Divide Factor 7
   PRDIV1_DIV8 : constant := 2#111#; -- Divide Factor 8

   PLLCS_PLL0 : constant := 0; -- PLL0 output clock is selected.
   PLLCS_PLL1 : constant := 1; -- PLL1 output clock is selected.

   PLLREFSEL1_OSC0 : constant := 0; -- Selects OSC0 clock source as its external reference clock.
   PLLREFSEL1_OSC1 : constant := 1; -- Selects OSC1 clock source as its external reference clock.

   type MCG_C11_Type is record
      PRDIV1     : Bits_3  := PRDIV1_DIV1;     -- PLL1 External Reference Divider
      Reserved   : Bits_1  := 0;
      PLLCS      : Bits_1  := PLLCS_PLL0;      -- PLL Clock Select
      PLLSTEN1   : Boolean := False;           -- PLL1 Stop Enable
      PLLCLKEN1  : Boolean := False;           -- PLL1 Clock Enable
      PLLREFSEL1 : Bits_1  := PLLREFSEL1_OSC0; -- PLL1 External Reference Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C11_Type use record
      PRDIV1     at 0 range 0 .. 2;
      Reserved   at 0 range 3 .. 3;
      PLLCS      at 0 range 4 .. 4;
      PLLSTEN1   at 0 range 5 .. 5;
      PLLCLKEN1  at 0 range 6 .. 6;
      PLLREFSEL1 at 0 range 7 .. 7;
   end record;

   MCG_C11 : aliased MCG_C11_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.15 MCG Control 12 Register (MCG_C12)

   VDIV1_x16 : constant := 2#00000#; -- Multiply Factor 16
   VDIV1_x17 : constant := 2#00001#; -- Multiply Factor 17
   VDIV1_x18 : constant := 2#00010#; -- Multiply Factor 18
   VDIV1_x19 : constant := 2#00011#; -- Multiply Factor 19
   VDIV1_x20 : constant := 2#00100#; -- Multiply Factor 20
   VDIV1_x21 : constant := 2#00101#; -- Multiply Factor 21
   VDIV1_x22 : constant := 2#00110#; -- Multiply Factor 22
   VDIV1_x23 : constant := 2#00111#; -- Multiply Factor 23
   VDIV1_x24 : constant := 2#01000#; -- Multiply Factor 24
   VDIV1_x25 : constant := 2#01001#; -- Multiply Factor 25
   VDIV1_x26 : constant := 2#01010#; -- Multiply Factor 26
   VDIV1_x27 : constant := 2#01011#; -- Multiply Factor 27
   VDIV1_x28 : constant := 2#01100#; -- Multiply Factor 28
   VDIV1_x29 : constant := 2#01101#; -- Multiply Factor 29
   VDIV1_x30 : constant := 2#01110#; -- Multiply Factor 30
   VDIV1_x31 : constant := 2#01111#; -- Multiply Factor 31
   VDIV1_x32 : constant := 2#10000#; -- Multiply Factor 32
   VDIV1_x33 : constant := 2#10001#; -- Multiply Factor 33
   VDIV1_x34 : constant := 2#10010#; -- Multiply Factor 34
   VDIV1_x35 : constant := 2#10011#; -- Multiply Factor 35
   VDIV1_x36 : constant := 2#10100#; -- Multiply Factor 36
   VDIV1_x37 : constant := 2#10101#; -- Multiply Factor 37
   VDIV1_x38 : constant := 2#10110#; -- Multiply Factor 38
   VDIV1_x39 : constant := 2#10111#; -- Multiply Factor 39
   VDIV1_x40 : constant := 2#11000#; -- Multiply Factor 40
   VDIV1_x41 : constant := 2#11001#; -- Multiply Factor 41
   VDIV1_x42 : constant := 2#11010#; -- Multiply Factor 42
   VDIV1_x43 : constant := 2#11011#; -- Multiply Factor 43
   VDIV1_x44 : constant := 2#11100#; -- Multiply Factor 44
   VDIV1_x45 : constant := 2#11101#; -- Multiply Factor 45
   VDIV1_x46 : constant := 2#11110#; -- Multiply Factor 46
   VDIV1_x47 : constant := 2#11111#; -- Multiply Factor 47

   type MCG_C12_Type is record
      VDIV1    : Bits_5  := VDIV0_x16; -- VCO1 Divider
      CME2     : Boolean := False;     -- Clock Monitor Enable
      Reserved : Bits_1  := 0;
      LOLIE1   : Boolean := False;     -- PLL1 Loss of Lock Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C12_Type use record
      VDIV1    at 0 range 0 .. 4;
      CME2     at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 6;
      LOLIE1   at 0 range 7 .. 7;
   end record;

   MCG_C12 : aliased MCG_C12_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#11#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 25.3.16 MCG Status 2 Register (MCG_S2)

   PLLCST_PLL0 : constant := 0; -- Source of PLLCS is PLL0 clock.
   PLLCST_PLL1 : constant := 1; -- Source of PLLCS is PLL1 clock.

   type MCG_S2_Type is record
      LOCS2     : Boolean; -- OSC1 Loss of Clock Status
      OSCINIT1  : Boolean; -- OSC1 Initialization
      Reserved1 : Bits_2;
      PLLCST    : Bits_1;  -- PLL Clock Select Status
      Reserved2 : Bits_1;
      LOCK1     : Boolean; -- Lock1 Status
      LOLS1     : Boolean; -- Loss of Lock2 Status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_S2_Type use record
      LOCS2     at 0 range 0 .. 0;
      OSCINIT1  at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      PLLCST    at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      LOCK1     at 0 range 6 .. 6;
      LOLS1     at 0 range 7 .. 7;
   end record;

   MCG_S2 : aliased MCG_S2_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#12#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 26 Oscillator (OSC)
   ----------------------------------------------------------------------------

   -- 26.71.1 OSC Control Register (OSCx_CR)

   type OSCx_CR_Type is record
      SC16P     : Boolean := False; -- Oscillator 16 pF Capacitor Load Configure
      SC8P      : Boolean := False; -- Oscillator 8 pF Capacitor Load Configure
      SC4P      : Boolean := False; -- Oscillator 4 pF Capacitor Load Configure
      SC2P      : Boolean := False; -- Oscillator 2 pF Capacitor Load Configure
      Reserved1 : Bits_1  := 0;
      EREFSTEN  : Boolean := False; -- External Reference Stop Enable
      Reserved2 : Bits_1  := 0;
      ERCLKEN   : Boolean := False; -- External Reference Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OSCx_CR_Type use record
      SC16P     at 0 range 0 .. 0;
      SC8P      at 0 range 1 .. 1;
      SC4P      at 0 range 2 .. 2;
      SC2P      at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      EREFSTEN  at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      ERCLKEN   at 0 range 7 .. 7;
   end record;

   OSC0_CR_ADDRESS : constant := 16#4006_5000#;

   OSC0_CR : aliased OSCx_CR_Type
      with Address              => System'To_Address (OSC0_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   OSC1_CR_ADDRESS : constant := 16#400E_5000#;

   OSC1_CR : aliased OSCx_CR_Type
      with Address              => System'To_Address (OSC1_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 34 DDR1/2/LP SDRAM Memory Controller (DDRMC)
   ----------------------------------------------------------------------------

   DDRMC_BASEADDRESS : constant := 16#400A_E000#;

   -- 34.4.1 DDR Control Register 0 (DDR_CR00)

   DDRCLS_DDR   : constant := 2#0000#; -- DDR
   DDRCLS_LPDDR : constant := 2#0001#; -- LPDDR
   DDRCLS_RSVD1 : constant := 2#0010#; -- Reserved
   DDRCLS_RSVD2 : constant := 2#0011#; -- Reserved
   DDRCLS_DDR2  : constant := 2#0100#; -- DDR2
   DDRCLS_RSVD3 : constant := 2#0101#; -- Reserved
   DDRCLS_RSVD4 : constant := 2#0110#; -- Reserved
   DDRCLS_RSVD5 : constant := 2#1111#; -- Reserved

   VERSION_VERSION : constant := 16#2040#;

   type DDR_CR00_Type is record
      START     : Boolean := False;           -- Start
      Reserved1 : Bits_7  := 0;
      DDRCLS    : Bits_4  := DDRCLS_DDR;      -- DRAM Class
      Reserved2 : Bits_4  := 0;
      VERSION   : Bits_16 := VERSION_VERSION; -- Version
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR00_Type use record
      START     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      DDRCLS    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      VERSION   at 0 range 16 .. 31;
   end record;

   DDR_CR00 : aliased DDR_CR00_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.2 DDR Control Register 1 (DDR_CR01)

   type DDR_CR01_Type is record
      MAXROW    : Bits_5  := 2#10000#; -- Maxmum Row
      Reserved1 : Bits_3  := 0;
      MAXCOL    : Bits_4  := 2#1011#;  -- Maximum Column
      Reserved2 : Bits_4  := 0;
      CSMAX     : Bits_2  := 2#10#;    -- Chip Select Maximum
      Reserved3 : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR01_Type use record
      MAXROW    at 0 range  0 ..  4;
      Reserved1 at 0 range  5 ..  7;
      MAXCOL    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      CSMAX     at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 31;
   end record;

   DDR_CR01 : aliased DDR_CR01_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.3 DDR Control Register 2 (DDR_CR02)

   type DDR_CR02_Type is record
      TINIT    : Bits_24 := 0; -- Time Initialization
      INITAREF : Bits_4  := 0; -- Initialization Auto-Refresh
      Reserved : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR02_Type use record
      TINIT    at 0 range  0 .. 23;
      INITAREF at 0 range 24 .. 27;
      Reserved at 0 range 28 .. 31;
   end record;

   DDR_CR02 : aliased DDR_CR02_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.4 DDR Control Register 3 (DDR_CR03)

   type DDR_CR03_Type is record
      LATLIN    : Bits_4 := 0; -- Latency Linear
      Reserved1 : Bits_4 := 0;
      LATGATE   : Bits_4 := 0; -- Latency Gate
      Reserved2 : Bits_4 := 0;
      WRLAT     : Bits_4 := 0;
      Reserved3 : Bits_4 := 0;
      TCCD      : Bits_5 := 0; -- Time CAS-to-CAS Delay
      Reserved4 : Bits_3 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR03_Type use record
      LATLIN    at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      LATGATE   at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      WRLAT     at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      TCCD      at 0 range 24 .. 28;
      Reserved4 at 0 range 29 .. 31;
   end record;

   DDR_CR03 : aliased DDR_CR03_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#00C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.5 DDR Control Register 4 (DDR_CR04)

   type DDR_CR04_Type is record
      TBINT     : Bits_3 := 0; -- Time Burst Interrupt Interval
      Reserved1 : Bits_5 := 0;
      TRRD      : Bits_3 := 0; -- Defines the DRAM activate-to-activate delay for different banks (TRRD) in cycles.
      Reserved2 : Bits_5 := 0;
      TRC       : Bits_6 := 0; -- Defines the DRAM period between active commands for the same bank (TRC) in cycles.
      Reserved3 : Bits_2 := 0;
      TRASMIN   : Bits_8 := 0; -- Time RAS Minimum
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR04_Type use record
      TBINT     at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  7;
      TRRD      at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 15;
      TRC       at 0 range 16 .. 21;
      Reserved3 at 0 range 22 .. 23;
      TRASMIN   at 0 range 24 .. 31;
   end record;

   DDR_CR04 : aliased DDR_CR04_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.6 DDR Control Register 5 (DDR_CR05)

   type DDR_CR05_Type is record
      TWTR      : Bits_4 := 0; -- Time Write-To-Read
      Reserved1 : Bits_4 := 0;
      TRP       : Bits_4 := 0; -- Defines the DRAM precharge command time (TRP) in cycles.
      Reserved2 : Bits_4 := 0;
      TRTP      : Bits_3 := 0; -- Time Read-To-Precharge
      Reserved3 : Bits_5 := 0;
      TMRD      : Bits_5 := 0; -- DRAM TMRD parameter in cycles.
      Reserved4 : Bits_3 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR05_Type use record
      TWTR      at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      TRP       at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      TRTP      at 0 range 16 .. 18;
      Reserved3 at 0 range 19 .. 23;
      TMRD      at 0 range 24 .. 28;
      Reserved4 at 0 range 29 .. 31;
   end record;

   DDR_CR05 : aliased DDR_CR05_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.7 DDR Control Register 6 (DDR_CR06)

   type DDR_CR06_Type is record
      TMOD     : Bits_8  := 0;     -- Time Mode
      TRASMAX  : Bits_16 := 0;     -- Time Row Access Maximum
      INTWBR   : Boolean := False; -- Interrupt Write Burst
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR06_Type use record
      TMOD     at 0 range  0 ..  7;
      TRASMAX  at 0 range  8 .. 23;
      INTWBR   at 0 range 24 .. 24;
      Reserved at 0 range 25 .. 31;
   end record;

   DDR_CR06 : aliased DDR_CR06_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.8 DDR Control Register 7 (DDR_CR07)

   type DDR_CR07_Type is record
      CLKPW     : Bits_3  := 0;     -- Clock Pulse Width
      Reserved1 : Bits_5  := 0;
      TCKESR    : Bits_5  := 0;     -- Time Clock low Self Refresh
      Reserved2 : Bits_3  := 0;
      AP        : Boolean := False; -- Auto Precharge
      Reserved3 : Bits_7  := 0;
      CCAPEN    : Boolean := False; -- Concurrent Auto-Precharge Enable
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR07_Type use record
      CLKPW     at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  7;
      TCKESR    at 0 range  8 .. 12;
      Reserved2 at 0 range 13 .. 15;
      AP        at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 23;
      CCAPEN    at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR07 : aliased DDR_CR07_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#01C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.9 DDR Control Register 8 (DDR_CR08)

   type DDR_CR08_Type is record
      TRAS      : Boolean := False; -- Time RAS lockout
      Reserved1 : Bits_7  := 0;
      TRASDI    : Bits_8  := 0;     -- Time RAS-to-CAS Delay Interval
      TWR       : Bits_5  := 0;     -- Time Write Recovery
      Reserved2 : Bits_3  := 0;
      TDAL      : Bits_5  := 0;     -- Defines the auto-precharge write recovery time when auto-precharge is enabled (CR01[AP] is set), in cycles.
      Reserved3 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR08_Type use record
      TRAS      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      TRASDI    at 0 range  8 .. 15;
      TWR       at 0 range 16 .. 20;
      Reserved2 at 0 range 21 .. 23;
      TDAL      at 0 range 24 .. 28;
      Reserved3 at 0 range 29 .. 31;
   end record;

   DDR_CR08 : aliased DDR_CR08_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.10 DDR Control Register 9 (DDR_CR09)

   type DDR_CR09_Type is record
      TDLL      : Bits_16 := 0;     -- Time DLL
      NOCMD     : Boolean := False; -- No Command
      Reserved1 : Bits_7  := 0;
      BSTLEN    : Bits_3  := 0;     -- Burst Length
      Reserved2 : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR09_Type use record
      TDLL      at 0 range  0 .. 15;
      NOCMD     at 0 range 16 .. 16;
      Reserved1 at 0 range 17 .. 23;
      BSTLEN    at 0 range 24 .. 26;
      Reserved2 at 0 range 27 .. 31;
   end record;

   DDR_CR09 : aliased DDR_CR09_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.11 DDR Control Register 10 (DDR_CR10)

   type DDR_CR10_Type is record
      TFAW      : Bits_6  := 0; -- Time FAW
      Reserved1 : Bits_2  := 0;
      TCPD      : Bits_16 := 0; -- Time Clock Enable to Precharge Delay
      TRPAB     : Bits_4  := 0; -- TRP All Bank
      Reserved2 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR10_Type use record
      TFAW      at 0 range  0 ..  5;
      Reserved1 at 0 range  6 ..  7;
      TCPD      at 0 range  8 .. 23;
      TRPAB     at 0 range 24 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   DDR_CR10 : aliased DDR_CR10_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.12 DDR Control Register 11 (DDR_CR11)

   AREFMODE_NEXTDRAMBURST : constant := 0; -- Issue refresh on the next DRAM burst boundary, even if the current command is not complete
   AREFMODE_NEXTCMD       : constant := 1; -- Issue refresh on the next command boundary.

   type DDR_CR11_Type is record
      REGDIMM   : Boolean := False;                  -- Registered DIMM
      Reserved1 : Bits_7  := 0;
      AREF      : Boolean := False;                  -- Auto Refresh
      Reserved2 : Bits_7  := 0;
      AREFMODE  : Bits_1  := AREFMODE_NEXTDRAMBURST; -- Auto Refresh Mode
      Reserved3 : Bits_7  := 0;
      TREFEN    : Boolean := False;                  -- Enables refresh commands.
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR11_Type use record
      REGDIMM   at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      AREF      at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 15;
      AREFMODE  at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 23;
      TREFEN    at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR11 : aliased DDR_CR11_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#02C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.13 DDR Control Register 12 (DDR_CR12)

   type DDR_CR12_Type is record
      TRFC      : Bits_10 := 0; -- Time Refresh Command
      Reserved1 : Bits_6  := 0;
      TREF      : Bits_14 := 0; -- Time Refresh
      Reserved2 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR12_Type use record
      TRFC      at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 15;
      TREF      at 0 range 16 .. 29;
      Reserved2 at 0 range 30 .. 31;
   end record;

   DDR_CR12 : aliased DDR_CR12_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#030#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

  -- 34.4.14 DDR Control Register 13 (DDR_CR13)

   type DDR_CR13_Type is record
      Reserved1 : Bits_14 := 0;
      Reserved2 : Bits_2  := 0;
      PD        : Boolean := False; -- Power Down
      Reserved3 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR13_Type use record
      Reserved1 at 0 range  0 .. 13;
      Reserved2 at 0 range 14 .. 15;
      PD        at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 31;
   end record;

   DDR_CR13 : aliased DDR_CR13_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#034#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.15 DDR Control Register 14 (DDR_CR14)

   type DDR_CR14_Type is record
      TPDEX : Bits_16 := 0; -- Time Power Down Exit
      TXSR  : Bits_16 := 0; -- Time Exit Self Refresh
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR14_Type use record
      TPDEX at 0 range  0 .. 15;
      TXSR  at 0 range 16 .. 31;
   end record;

   DDR_CR14 : aliased DDR_CR14_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.16 DDR Control Register 15 (DDR_CR15)

   type DDR_CR15_Type is record
      TXSNR     : Bits_16 := 0;     -- TXSNR parameter
      SREF      : Boolean := False; -- Self Refresh
      Reserved1 : Bits_7  := 0;
      PUREF     : Boolean := False; -- Power Up Refresh
      Reserved2 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR15_Type use record
      TXSNR     at 0 range  0 .. 15;
      SREF      at 0 range 16 .. 16;
      Reserved1 at 0 range 17 .. 23;
      PUREF     at 0 range 24 .. 24;
      Reserved2 at 0 range 25 .. 31;
   end record;

   DDR_CR15 : aliased DDR_CR15_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#03C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.17 DDR Control Register 16 (DDR_CR16)

   type DDR_CR16_Type is record
      QKREF        : Boolean := False; -- Quick Refresh
      Reserved1    : Bits_7  := 0;
      CLKDLY       : Bits_3  := 0;     -- Clock Delay
      Reserved2    : Bits_5  := 0;
      LPCTRL_MODE5 : Boolean := False; -- Memory self-refresh with memory and controller clock gating mode (mode 5)
      LPCTRL_MODE4 : Boolean := False; -- Memory self-refresh with memory clock gating mode (mode 4)
      LPCTRL_MODE3 : Boolean := False; -- Memory self-refresh mode (mode 3)
      LPCTRL_MODE2 : Boolean := False; -- Memory power-down with memory clock gating mode (mode 2)
      LPCTRL_MODE1 : Boolean := False; -- Memory power-down mode (mode 1)
      Reserved3    : Bits_11 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR16_Type use record
      QKREF        at 0 range  0 ..  0;
      Reserved1    at 0 range  1 ..  7;
      CLKDLY       at 0 range  8 .. 10;
      Reserved2    at 0 range 11 .. 15;
      LPCTRL_MODE5 at 0 range 16 .. 16;
      LPCTRL_MODE4 at 0 range 17 .. 17;
      LPCTRL_MODE3 at 0 range 18 .. 18;
      LPCTRL_MODE2 at 0 range 19 .. 19;
      LPCTRL_MODE1 at 0 range 20 .. 20;
      Reserved3    at 0 range 21 .. 31;
   end record;

   DDR_CR16 : aliased DDR_CR16_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#040#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.18 DDR Control Register 17 (DDR_CR17)

   type DDR_CR17_Type is record
      LPPDCNT : Bits_16 := 0; -- Low Power Power Down Count
      LPRFCNT : Bits_16 := 0; -- Low Power Refresh Count
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR17_Type use record
      LPPDCNT at 0 range  0 .. 15;
      LPRFCNT at 0 range 16 .. 31;
   end record;

   DDR_CR17 : aliased DDR_CR17_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#044#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.19 DDR Control Register 18 (DDR_CR18)

   type DDR_CR18_Type is record
      LPEXTCNT : Bits_16 := 0; -- Low Power External Count
      LPAUTO   : Bits_5  := 0; -- Low Power Auto
      Reserved : Bits_11 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR18_Type use record
      LPEXTCNT at 0 range  0 .. 15;
      LPAUTO   at 0 range 16 .. 20;
      Reserved at 0 range 21 .. 31;
   end record;

   DDR_CR18 : aliased DDR_CR18_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#048#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.20 DDR Control Register 19 (DDR_CR19)

   type DDR_CR19_Type is record
      LPINTCNT : Bits_16 := 0; -- Low Power Interval Count
      LPRFHOLD : Bits_16 := 0; -- Low Power Refresh Hold
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR19_Type use record
      LPINTCNT at 0 range  0 .. 15;
      LPRFHOLD at 0 range 16 .. 31;
   end record;

   DDR_CR19 : aliased DDR_CR19_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#04C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.21 DDR Control Register 20 (DDR_CR20)

   LPRE_REF   : constant := 2#00#; -- Refreshes occur
   LPRE_NOREF : constant := 2#01#; -- Refreshes do not occur
   LPRE_RSVD1 : constant := 2#10#; -- Reserved
   LPRE_RSVD2 : constant := 2#11#; -- Reserved

   type DDR_CR20_Type is record
      LPRE      : Bits_2  := LPRE_REF; -- Low Power Refresh enable
      Reserved1 : Bits_6  := 0;
      CKSRE     : Bits_4  := 0;        -- Clock hold delay on self refresh entry.
      Reserved2 : Bits_4  := 0;
      CKSRX     : Bits_4  := 0;        -- Clock Self Refresh Exit
      Reserved3 : Bits_4  := 0;
      WRMD      : Boolean := False;    -- Write Mode Register
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR20_Type use record
      LPRE      at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  7;
      CKSRE     at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      CKSRX     at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      WRMD      at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR20 : aliased DDR_CR20_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#050#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.22 DDR Control Register 21 (DDR_CR21)

   type DDR_CR21_Type is record
      MR0DAT0 : Bits_16 := 0; -- Data to program into memory mode register 0 for chip select .
      MR1DAT0 : Bits_16 := 0; -- Data to program into memory mode register 1 for chip select .
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR21_Type use record
      MR0DAT0 at 0 range  0 .. 15;
      MR1DAT0 at 0 range 16 .. 31;
   end record;

   DDR_CR21 : aliased DDR_CR21_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#054#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.23 DDR Control Register 22 (DDR_CR22)

   type DDR_CR22_Type is record
      MR2DAT0 : Bits_16 := 0; -- Data to program into memory mode register 2 for chip select .
      MR3DAT0 : Bits_16 := 0; -- Data to program into memory mode register 3 for chip select .
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR22_Type use record
      MR2DAT0 at 0 range  0 .. 15;
      MR3DAT0 at 0 range 16 .. 31;
   end record;

   DDR_CR22 : aliased DDR_CR22_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#058#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.24 DDR Control Register 23 (DDR_CR23)

   type DDR_CR23_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR23_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR23 : aliased DDR_CR23_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#05C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.25 DDR Control Register 24 (DDR_CR24)

   type DDR_CR24_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR24_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR24 : aliased DDR_CR24_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#060#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.26 DDR Control Register 25 (DDR_CR25)

   BNK8_4 : constant := 0; -- 4 banks
   BNK8_8 : constant := 1; -- 8 banks

   type DDR_CR25_Type is record
      BNK8      : Bits_1 := BNK8_4; -- Eight Bank Mode
      Reserved1 : Bits_7 := 0;
      ADDPINS   : Bits_3 := 0;      -- Address Pins
      Reserved2 : Bits_5 := 0;
      COLSIZ    : Bits_3 := 0;      -- Column Size
      Reserved3 : Bits_5 := 0;
      APREBIT   : Bits_4 := 0;      -- Auto Precharge Bit
      Reserved4 : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR25_Type use record
      BNK8      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      ADDPINS   at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 15;
      COLSIZ    at 0 range 16 .. 18;
      Reserved3 at 0 range 19 .. 23;
      APREBIT   at 0 range 24 .. 27;
      Reserved4 at 0 range 28 .. 31;
   end record;

   DDR_CR25 : aliased DDR_CR25_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#064#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.27 DDR Control Register 26 (DDR_CR26)

   type DDR_CR26_Type is record
      AGECNT    : Bits_8  := 0;     -- Age Count
      CMDAGE    : Bits_8  := 0;     -- Command Age count
      ADDCOL    : Boolean := False; -- Address Collision enable
      Reserved1 : Bits_7  := 0;
      BNKSPT    : Boolean := False; -- Bank Split enable
      Reserved2 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR26_Type use record
      AGECNT    at 0 range  0 ..  7;
      CMDAGE    at 0 range  8 .. 15;
      ADDCOL    at 0 range 16 .. 16;
      Reserved1 at 0 range 17 .. 23;
      BNKSPT    at 0 range 24 .. 24;
      Reserved2 at 0 range 25 .. 31;
   end record;

   DDR_CR26 : aliased DDR_CR26_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#068#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.28 DDR Control Register 27 (DDR_CR27)

   type DDR_CR27_Type is record
      PLEN      : Boolean := False; -- Placement Enable
      Reserved1 : Bits_7  := 0;
      PRIEN     : Boolean := False; -- Priority Enable
      Reserved2 : Bits_7  := 0;
      RWEN      : Boolean := False; -- Read Write same Enable
      Reserved3 : Bits_7  := 0;
      SWPEN     : Boolean := False; -- Swap Enable
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR27_Type use record
      PLEN      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      PRIEN     at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 15;
      RWEN      at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 23;
      SWPEN     at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR27 : aliased DDR_CR27_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#06C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.29 DDR Control Register 28 (DDR_CR28)

   REDUC_16 : constant := 0; -- 16-bit — standard operation using full memory bus
   REDUC_8  : constant := 1; -- 8-bit — Memory datapath width is half of the maximum size.

   BIGEND_LITTLE : constant := 0; -- Little endian
   BIGEND_BIG    : constant := 1; -- Big endian

   type DDR_CR28_Type is record
      CSMAP     : Boolean := False;         -- Chip Select Map
      Reserved1 : Bits_7  := 0;
      REDUC     : Bits_1  := REDUC_16;      -- Controls the width of the memory datapath.
      Reserved2 : Bits_7  := 0;
      BIGEND    : Bits_1  := BIGEND_LITTLE; -- Big Endian Enable
      Reserved3 : Bits_7  := 0;
      CMDLATR   : Boolean := False;         -- Command Latency Reduction Enable
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR28_Type use record
      CSMAP     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      REDUC     at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 15;
      BIGEND    at 0 range 16 .. 16;
      Reserved3 at 0 range 17 .. 23;
      CMDLATR   at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR28 : aliased DDR_CR28_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#070#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.30 DDR Control Register 29 (DDR_CR29)

   FSTWR_BURST   : constant := 0; -- The memory controller issues a write command to the DRAM devices when it has received enough data for one DRAM burst.
   FSTWR_1STWORD : constant := 1; -- The memory controller issues a write command to the DRAM devices after the first word of the write data is received by the memory controller.

   type DDR_CR29_Type is record
      WRLATR    : Boolean := False;       -- Write Latency Reduction enable
      Reserved1 : Bits_7  := 0;
      FSTWR     : Bits_1  := FSTWR_BURST; -- Fast Write
      Reserved2 : Bits_7  := 0;
      QFULL     : Bits_2  := 0;           -- Queue Fullness
      Reserved3 : Bits_6  := 0;
      RESYNC    : Boolean := False;       -- Resyncronize
      Reserved4 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR29_Type use record
      WRLATR    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      FSTWR     at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 15;
      QFULL     at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 23;
      RESYNC    at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 31;
   end record;

   DDR_CR29 : aliased DDR_CR29_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#074#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.31 DDR Control Register 30 (DDR_CR30)

   type DDR_CR30_Type is record
      RSYNCRF    : Boolean := False; -- Resynchroize after Refresh
      Reserved1  : Bits_7  := 0;
      INTSTAT_SA : Boolean := False; -- A single access outside the defined physical memory space detected
      INTSTAT_MA : Boolean := False; -- Multiple accesses outside the defined physical memory space detected
      INTSTAT_DI : Boolean := False; -- DRAM initialization complete
      INTSTAT_DM : Boolean := False; -- Both DDR2 and Mobile modes have been enabled
      INTSTAT_OE : Boolean := False; -- ODT enabled and CAS Latency 3 programmed error detected. This is an unsupported programming option
      INTSTAT_RI : Boolean := False; -- Indicates that a register interface mode register write has finished and that another register interface mode register write may be issued
      INTSTAT_DC : Boolean := False; -- dfi_int_complete state change detected
      INTSTAT_UD : Boolean := False; -- User-initiated DLL resync is finished
      INTSTAT    : Boolean := False; -- Logical OR of INTSTATUS[7:0]
      Reserved2  : Bits_7  := 0;
      INTACK_SA  : Boolean := False; -- ACK for INTSTAT_SA
      INTACK_MA  : Boolean := False; -- ACK for INTSTAT_MA
      INTACK_DI  : Boolean := False; -- ACK for INTSTAT_DI
      INTACK_DM  : Boolean := False; -- ACK for INTSTAT_DM
      INTACK_OE  : Boolean := False; -- ACK for INTSTAT_OE
      INTACK_RI  : Boolean := False; -- ACK for INTSTAT_RI
      INTACK_DC  : Boolean := False; -- ACK for INTSTAT_DC
      INTACK_UD  : Boolean := False; -- ACK for INTSTAT_UD
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR30_Type use record
      RSYNCRF    at 0 range  0 ..  0;
      Reserved1  at 0 range  1 ..  7;
      INTSTAT_SA at 0 range  8 ..  8;
      INTSTAT_MA at 0 range  9 ..  9;
      INTSTAT_DI at 0 range 10 .. 10;
      INTSTAT_DM at 0 range 11 .. 11;
      INTSTAT_OE at 0 range 12 .. 12;
      INTSTAT_RI at 0 range 13 .. 13;
      INTSTAT_DC at 0 range 14 .. 14;
      INTSTAT_UD at 0 range 15 .. 15;
      INTSTAT    at 0 range 16 .. 16;
      Reserved2  at 0 range 17 .. 23;
      INTACK_SA  at 0 range 24 .. 24;
      INTACK_MA  at 0 range 25 .. 25;
      INTACK_DI  at 0 range 26 .. 26;
      INTACK_DM  at 0 range 27 .. 27;
      INTACK_OE  at 0 range 28 .. 28;
      INTACK_RI  at 0 range 29 .. 29;
      INTACK_DC  at 0 range 30 .. 30;
      INTACK_UD  at 0 range 31 .. 31;
   end record;

   DDR_CR30 : aliased DDR_CR30_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#078#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.32 DDR Control Register 31 (DDR_CR31)

   type DDR_CR31_Type is record
      INTMASK_SA : Boolean := False; -- MASK for INTSTAT_SA
      INTMASK_MA : Boolean := False; -- MASK for INTSTAT_MA
      INTMASK_DI : Boolean := False; -- MASK for INTSTAT_DI
      INTMASK_DM : Boolean := False; -- MASK for INTSTAT_DM
      INTMASK_OE : Boolean := False; -- MASK for INTSTAT_OE
      INTMASK_RI : Boolean := False; -- MASK for INTSTAT_RI
      INTMASK_DC : Boolean := False; -- MASK for INTSTAT_DC
      INTMASK_UD : Boolean := False; -- MASK for INTSTAT_UD
      INTMASK    : Boolean := False; -- MASK for INTSTAT
      Reserved   : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR31_Type use record
      INTMASK_SA at 0 range 0 ..  0;
      INTMASK_MA at 0 range 1 ..  1;
      INTMASK_DI at 0 range 2 ..  2;
      INTMASK_DM at 0 range 3 ..  3;
      INTMASK_OE at 0 range 4 ..  4;
      INTMASK_RI at 0 range 5 ..  5;
      INTMASK_DC at 0 range 6 ..  6;
      INTMASK_UD at 0 range 7 ..  7;
      INTMASK    at 0 range 8 ..  8;
      Reserved   at 0 range 9 .. 31;
   end record;

   DDR_CR31 : aliased DDR_CR31_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#07C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.33 DDR Control Register 32 (DDR_CR32)

   type DDR_CR32_Type is record
      OORAD : Unsigned_32 := 0; -- Out Of Range Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR32_Type use record
      OORAD at 0 range 0 .. 31;
   end record;

   DDR_CR32 : aliased DDR_CR32_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#080#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.34 DDR Control Register 33 (DDR_CR33)

   type DDR_CR33_Type is record
      OORLEN    : Bits_10 := 0; -- Out Of Range Length
      Reserved1 : Bits_6  := 0;
      OORTYP    : Bits_6  := 0; -- Out Of Range Type
      Reserved2 : Bits_2  := 0;
      OORID     : Bits_2  := 0; -- Out Of Range source ID
      Reserved3 : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR33_Type use record
      OORLEN    at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 15;
      OORTYP    at 0 range 16 .. 21;
      Reserved2 at 0 range 22 .. 23;
      OORID     at 0 range 24 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   DDR_CR33 : aliased DDR_CR33_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#084#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.35 DDR Control Register 34 (DDR_CR34)

   ODTRDC_RES : constant := 0; -- Reserved ODT termination when CS performs a read
   ODTRDC_ACT : constant := 1; -- CS has active ODT termination when CS performs a read

   ODTWRCS_NO  : constant := 0; -- No ODT termination when CS performs a write
   ODTWRCS_ACT : constant := 1; -- CS has active ODT termination when CS performs a write

   type DDR_CR34_Type is record
      ODTRDC    : Bits_1 := ODTRDC_RES; -- ODT Read map CS
      Reserved1 : Bits_7 := 0;
      ODTWRCS   : Bits_1 := ODTWRCS_NO; -- ODT Write map CS
      Reserved2 : Bits_7 := 0;
      Reserved3 : Bits_2 := 0;
      Reserved4 : Bits_6 := 0;
      Reserved5 : Bits_2 := 0;
      Reserved6 : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR34_Type use record
      ODTRDC    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      ODTWRCS   at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 15;
      Reserved3 at 0 range 16 .. 17;
      Reserved4 at 0 range 18 .. 23;
      Reserved5 at 0 range 24 .. 25;
      Reserved6 at 0 range 26 .. 31;
   end record;

   DDR_CR34 : aliased DDR_CR34_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#088#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.36 DDR Control Register 35 (DDR_CR35)

   type DDR_CR35_Type is record
      R2WSMCS   : Bits_4  := 0; -- Read To Write Same Chip Select
      Reserved1 : Bits_4  := 0;
      W2RSMCS   : Bits_4  := 0; -- Write To Read Same Chip Select
      Reserved2 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR35_Type use record
      R2WSMCS   at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      W2RSMCS   at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 31;
   end record;

   DDR_CR35 : aliased DDR_CR35_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#08C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.37 DDR Control Register 36 (DDR_CR36)

   type DDR_CR36_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR36_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR36 : aliased DDR_CR36_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#090#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.38 DDR Control Register 37 (DDR_CR37)

   type DDR_CR37_Type is record
      R2RSAME   : Bits_3 := 0; -- R2R Same chip select delay
      Reserved1 : Bits_5 := 0;
      R2WSAME   : Bits_3 := 0; -- R2W Same chip select delay
      Reserved2 : Bits_5 := 0;
      W2RSAME   : Bits_3 := 0; -- W2R Same chip select delay
      Reserved3 : Bits_5 := 0;
      W2WSAME   : Bits_3 := 0; -- W2W Same chip select delay
      Reserved4 : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR37_Type use record
      R2RSAME   at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  7;
      R2WSAME   at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 15;
      W2RSAME   at 0 range 16 .. 18;
      Reserved3 at 0 range 19 .. 23;
      W2WSAME   at 0 range 24 .. 26;
      Reserved4 at 0 range 27 .. 31;
   end record;

   DDR_CR37 : aliased DDR_CR37_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#094#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.39 DDR Control Register 38 (DDR_CR38)

   PDNCS_MODE_DEC : constant := 0; -- Decrement OCD settings
   PDNCS_MODE_INC : constant := 1; -- Increment OCD settings

   PUPCS_MODE_DEC : constant := 0; -- Decrement OCD settings
   PUPCS_MODE_INC : constant := 1; -- Increment OCD settings

   type DDR_CR38_Type is record
      PDNCS_NADJ : Bits_4  := 0;              -- OCD Pull Down adjustment Chip Select (Number of OCD adjustment commands to issue)
      PDNCS_MODE : Bits_1  := PDNCS_MODE_DEC; -- OCD Pull Down adjustment Chip Select (Decrement/Increment OCD settings)
      Reserved1  : Bits_3  := 0;
      PUPCS_NADJ : Bits_4  := 0;              -- OCD Pull Up adjustment Chip Select (Number of OCD adjustment commands to issue)
      PUPCS_MODE : Bits_1  := PUPCS_MODE_DEC; -- OCD Pull Up adjustment Chip Select (Decrement/Increment OCD settings)
      Reserved2  : Bits_3  := 0;
      P0WRCNT    : Bits_11 := 0;              -- Port 0 Write Count
      Reserved3  : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR38_Type use record
      PDNCS_NADJ at 0 range  0 ..  3;
      PDNCS_MODE at 0 range  4 ..  4;
      Reserved1  at 0 range  5 ..  7;
      PUPCS_NADJ at 0 range  8 .. 11;
      PUPCS_MODE at 0 range 12 .. 12;
      Reserved2  at 0 range 13 .. 15;
      P0WRCNT    at 0 range 16 .. 26;
      Reserved3  at 0 range 27 .. 31;
   end record;

   DDR_CR38 : aliased DDR_CR38_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#098#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.40 DDR Control Register 39 (DDR_CR39)

   type DDR_CR39_Type is record
      P0RDCNT    : Bits_11 := 0; -- Port 0 Read command Count
      Reserved1  : Bits_5  := 0;
      RP0        : Bits_2  := 0; -- Port 0 Read command Priority
      Reserved2  : Bits_6  := 0;
      WP0        : Bits_2  := 0; -- Port 0 Write command Priority
      Reserved3  : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR39_Type use record
      P0RDCNT   at 0 range  0 .. 10;
      Reserved1 at 0 range 11 .. 15;
      RP0       at 0 range 16 .. 17;
      Reserved2 at 0 range 18 .. 23;
      WP0       at 0 range 24 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   DDR_CR39 : aliased DDR_CR39_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#09C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.41 DDR Control Register 40 (DDR_CR40)

   P0TYP_ASYNC : constant := 2#00#; -- Asynchronous
   P0TYP_RSVD1 : constant := 2#01#; -- Reserved
   P0TYP_RSVD2 : constant := 2#01#; -- Reserved
   P0TYP_SYNC  : constant := 2#11#; -- Synchronous

   type DDR_CR40_Type is record
      P0TYP     : Bits_2  := P0TYP_ASYNC; -- Port 0 Type
      Reserved1 : Bits_6  := 0;
      P1WRCNT   : Bits_11 := 0;           -- Port 1 Write command Count
      Reserved2 : Bits_13 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR40_Type use record
      P0TYP     at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  7;
      P1WRCNT   at 0 range  8 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   DDR_CR40 : aliased DDR_CR40_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0A0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.42 DDR Control Register 41 (DDR_CR41)

   type DDR_CR41_Type is record
      P1RDCNT    : Bits_11 := 0; -- Port 1 Read command Count
      Reserved1  : Bits_5  := 0;
      RP1        : Bits_2  := 0; -- Port 1 Read command Priority
      Reserved2  : Bits_6  := 0;
      WP1        : Bits_2  := 0; -- Port 1 Write command Priority
      Reserved3  : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR41_Type use record
      P1RDCNT   at 0 range  0 .. 10;
      Reserved1 at 0 range 11 .. 15;
      RP1       at 0 range 16 .. 17;
      Reserved2 at 0 range 18 .. 23;
      WP1       at 0 range 24 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   DDR_CR41 : aliased DDR_CR41_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0A4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.43 DDR Control Register 42 (DDR_CR42)

   P1TYP_ASYNC : constant := 2#00#; -- Asynchronous
   P1TYP_RSVD1 : constant := 2#01#; -- Reserved
   P1TYP_RSVD2 : constant := 2#01#; -- Reserved
   P1TYP_SYNC  : constant := 2#11#; -- Synchronous

   type DDR_CR42_Type is record
      P1TYP     : Bits_2  := P1TYP_ASYNC; -- Port 1 Type
      Reserved1 : Bits_6  := 0;
      P2WRCNT   : Bits_11 := 0;           -- Port 2 Write command Count
      Reserved2 : Bits_13 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR42_Type use record
      P1TYP     at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  7;
      P2WRCNT   at 0 range  8 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   DDR_CR42 : aliased DDR_CR42_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0A8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.44 DDR Control Register 43 (DDR_CR43)

   type DDR_CR43_Type is record
      P2RDCNT    : Bits_11 := 0; -- Port 2 Read command Count
      Reserved1  : Bits_5  := 0;
      RP2        : Bits_2  := 0; -- Port 2 Read command Priority
      Reserved2  : Bits_6  := 0;
      WP2        : Bits_2  := 0; -- Port 2 Write command Priority
      Reserved3  : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR43_Type use record
      P2RDCNT   at 0 range  0 .. 10;
      Reserved1 at 0 range 11 .. 15;
      RP2       at 0 range 16 .. 17;
      Reserved2 at 0 range 18 .. 23;
      WP2       at 0 range 24 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   DDR_CR43 : aliased DDR_CR43_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0AC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.45 DDR Control Register 44 (DDR_CR44)

   P2TYP_ASYNC : constant := 2#00#; -- Asynchronous
   P2TYP_RSVD1 : constant := 2#01#; -- Reserved
   P2TYP_RSVD2 : constant := 2#01#; -- Reserved
   P2TYP_SYNC  : constant := 2#11#; -- Synchronous

   WRRLAT_FREERUN : constant := 0; -- Free-running
   WRRLAT_LIMITED : constant := 1; -- Limited

   WRRSHARE_INDPNDNT : constant := 0; -- Port 0 and port 1 are treated independently for arbitration
   WRRSHARE_GROUPED  : constant := 1; -- Port 0 and port 1 are grouped together for arbitration

   type DDR_CR44_Type is record
      P2TYP           : Bits_2  := P2TYP_ASYNC;       -- Port 2 Type
      Reserved1       : Bits_6  := 0;
      WRRLAT          : Bits_1  := WRRLAT_FREERUN;    -- WRR Latency
      Reserved2       : Bits_7  := 0;
      WRRSHARE        : Bits_1  := WRRSHARE_INDPNDNT; -- WRR Shared arbitration
      Reserved3       : Bits_7  := 0;
      WRRERR_NOTUNIQ  : Boolean := False;             -- The port ordering parameters do not all contain unique values.
      WRRERR_ANYZERO  : Boolean := False;             -- Any of the relative priority parameters have been programmed with a zero value.
      WRRERR_RELPNEQ  : Boolean := False;             -- The relative priority values for any of the ports paired through the weighted_round_robin_weight_sharing parameter are not identical.
      WRRERR_PORDNSEQ : Boolean := False;             -- The port ordering parameter values for paired ports is not sequential.
      Reserved4       : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR44_Type use record
      P2TYP           at 0 range  0 ..  1;
      Reserved1       at 0 range  2 ..  7;
      WRRLAT          at 0 range  8 ..  8;
      Reserved2       at 0 range  9 .. 15;
      WRRSHARE        at 0 range 16 .. 16;
      Reserved3       at 0 range 17 .. 23;
      WRRERR_NOTUNIQ  at 0 range 24 .. 24;
      WRRERR_ANYZERO  at 0 range 25 .. 25;
      WRRERR_RELPNEQ  at 0 range 26 .. 26;
      WRRERR_PORDNSEQ at 0 range 27 .. 27;
      Reserved4       at 0 range 28 .. 31;
   end record;

   DDR_CR44 : aliased DDR_CR44_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0B0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.46 DDR Control Register 45 (DDR_CR45)

   type DDR_CR45_Type is record
      P0PRI0    : Bits_4 := 0; -- Port 0 Priority 0 commands
      Reserved1 : Bits_4 := 0;
      P0PRI1    : Bits_4 := 0; -- Port 0 Priority 1 commands
      Reserved2 : Bits_4 := 0;
      P0PRI2    : Bits_4 := 0; -- Port 0 Priority 2 commands
      Reserved3 : Bits_4 := 0;
      P0PRI3    : Bits_4 := 0; -- Port 0 Priority 3 commands
      Reserved4 : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR45_Type use record
      P0PRI0    at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      P0PRI1    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      P0PRI2    at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      P0PRI3    at 0 range 24 .. 27;
      Reserved4 at 0 range 28 .. 31;
   end record;

   DDR_CR45 : aliased DDR_CR45_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0B4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.47 DDR Control Register 46 (DDR_CR46)

   type DDR_CR46_Type is record
      P0ORD     : Bits_2  := 0; -- Port 0 Order
      Reserved1 : Bits_6  := 0;
      P0PRIRLX  : Bits_10 := 0; -- Port 0 Priority Relax
      Reserved2 : Bits_6  := 0;
      P1PRI0    : Bits_4  := 0; -- Port 1 Priority 0 commands
      Reserved3 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR46_Type use record
      P0ORD     at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  7;
      P0PRIRLX  at 0 range  8 .. 17;
      Reserved2 at 0 range 18 .. 23;
      P1PRI0    at 0 range 24 .. 27;
      Reserved3 at 0 range 28 .. 31;
   end record;

   DDR_CR46 : aliased DDR_CR46_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0B8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.48 DDR Control Register 47 (DDR_CR47)

   type DDR_CR47_Type is record
      P1PRI1    : Bits_4 := 0; -- Port 1 Priority 1 commands
      Reserved1 : Bits_4 := 0;
      P1PRI2    : Bits_4 := 0; -- Port 1 Priority 2 commands
      Reserved2 : Bits_4 := 0;
      P1PRI3    : Bits_4 := 0; -- Port 1 Priority 3 commands
      Reserved3 : Bits_4 := 0;
      P1ORD     : Bits_2 := 0; -- Port 1 Order
      Reserved4 : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR47_Type use record
      P1PRI1    at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      P1PRI2    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      P1PRI3    at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      P1ORD     at 0 range 24 .. 25;
      Reserved4 at 0 range 26 .. 31;
   end record;

   DDR_CR47 : aliased DDR_CR47_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0BC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.49 DDR Control Register 48 (DDR_CR48)

   type DDR_CR48_Type is record
      P1PRIRLX  : Bits_10 := 0; -- Port 1 Priority Relax
      Reserved1 : Bits_6  := 0;
      P2PRI0    : Bits_4  := 0; -- Port 2 Priority 0 commands
      Reserved2 : Bits_4  := 0;
      P2PRI1    : Bits_4  := 0; -- Port 2 Priority 1 commands
      Reserved3 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR48_Type use record
      P1PRIRLX  at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 15;
      P2PRI0    at 0 range 16 .. 19;
      Reserved2 at 0 range 20 .. 23;
      P2PRI1    at 0 range 24 .. 27;
      Reserved3 at 0 range 28 .. 31;
   end record;

   DDR_CR48 : aliased DDR_CR48_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0C0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.50 DDR Control Register 49 (DDR_CR49)

   type DDR_CR49_Type is record
      P2PRI2    : Bits_4  := 0; -- Port 2 Priority 2 commands
      Reserved1 : Bits_4  := 0;
      P2PRI3    : Bits_4  := 0; -- Port 2 Priority 3 commands
      Reserved2 : Bits_4  := 0;
      P2ORD     : Bits_2  := 0; -- Port 2 Order
      Reserved3 : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR49_Type use record
      P2PRI2    at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      P2PRI3    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      P2ORD     at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 31;
   end record;

   DDR_CR49 : aliased DDR_CR49_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0C4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.51 DDR Control Register 50 (DDR_CR50)

   type DDR_CR50_Type is record
      P2PRIRLX  : Bits_10 := 0;     -- Port 2 Priority Relax
      Reserved1 : Bits_6  := 0;
      CLKSTATUS : Boolean := False; -- Clock Status
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR50_Type use record
      P2PRIRLX  at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 15;
      CLKSTATUS at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   DDR_CR50 : aliased DDR_CR50_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0C8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.52 DDR Control Register 51 (DDR_CR51)

   type DDR_CR51_Type is record
      DLLRSTDLY : Bits_16 := 0; -- DLL Reset Delay
      DLLRADLY  : Bits_8  := 0; -- DLL Reset Adjust Delay
      PHYWRLAT  : Bits_4  := 0; -- PHY Write Latency
      Reserved  : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR51_Type use record
      DLLRSTDLY at 0 range  0 .. 15;
      DLLRADLY  at 0 range 16 .. 23;
      PHYWRLAT  at 0 range 24 .. 27;
      Reserved  at 0 range 28 .. 31;
   end record;

   DDR_CR51 : aliased DDR_CR51_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0CC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.53 DDR Control Register 52 (DDR_CR52)

   type DDR_CR52_Type is record
      PYWRLTBS  : Bits_4 := 0; -- PHY Write Latency Base
      Reserved1 : Bits_4 := 0;
      PHYRDLAT  : Bits_4 := 0; -- PHY Read Latency
      Reserved2 : Bits_4 := 0;
      RDDATAEN  : Bits_4 := 0; -- Read Data Enable
      Reserved3 : Bits_4 := 0;
      RDDTENBAS : Bits_4 := 0; -- Read Data Enable Base
      Reserved4 : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR52_Type use record
      PYWRLTBS  at 0 range  0 ..  3;
      Reserved1 at 0 range  4 ..  7;
      PHYRDLAT  at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      RDDATAEN  at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      RDDTENBAS at 0 range 24 .. 27;
      Reserved4 at 0 range 28 .. 31;
   end record;

   DDR_CR52 : aliased DDR_CR52_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0D0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.54 DDR Control Register 53 (DDR_CR53)

   type DDR_CR53_Type is record
      CLKDISCS  : Boolean := False; -- DRAM Clock Disable for chip select
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_6  := 0;
      Reserved3 : Bits_4  := 0;
      Reserved4 : Bits_4  := 0;
      Reserved5 : Bits_14 := 0;
      Reserved6 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR53_Type use record
      CLKDISCS  at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  7;
      Reserved3 at 0 range  8 .. 11;
      Reserved4 at 0 range 12 .. 15;
      Reserved5 at 0 range 16 .. 29;
      Reserved6 at 0 range 30 .. 31;
   end record;

   DDR_CR53 : aliased DDR_CR53_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0D4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.55 DDR Control Register 54 (DDR_CR54)

   type DDR_CR54_Type is record
      Reserved1 : Bits_14 := 0;
      Reserved2 : Bits_2  := 0;
      Reserved3 : Bits_14 := 0;
      Reserved4 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR54_Type use record
      Reserved1 at 0 range  0 .. 13;
      Reserved2 at 0 range 14 .. 15;
      Reserved3 at 0 range 16 .. 29;
      Reserved4 at 0 range 30 .. 31;
   end record;

   DDR_CR54 : aliased DDR_CR54_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0D8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.56 DDR Control Register 55 (DDR_CR55)

   type DDR_CR55_Type is record
      Reserved1 : Bits_14 := 0;
      Reserved2 : Bits_2  := 0;
      Reserved3 : Bits_14 := 0;
      Reserved4 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR55_Type use record
      Reserved1 at 0 range  0 .. 13;
      Reserved2 at 0 range 14 .. 15;
      Reserved3 at 0 range 16 .. 29;
      Reserved4 at 0 range 30 .. 31;
   end record;

   DDR_CR55 : aliased DDR_CR55_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0DC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.57 DDR Control Register 56 (DDR_CR56)

   type DDR_CR56_Type is record
      Reserved1 : Bits_14 := 0;
      Reserved2 : Bits_2  := 0;
      RDLATADJ  : Bits_4  := 0; -- Read Latency Adjust
      Reserved3 : Bits_4  := 0;
      WRLATADJ  : Bits_4  := 0; -- Write Latency Adjust
      Reserved4 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR56_Type use record
      Reserved1 at 0 range  0 .. 13;
      Reserved2 at 0 range 14 .. 15;
      RDLATADJ  at 0 range 16 .. 19;
      Reserved3 at 0 range 20 .. 23;
      WRLATADJ  at 0 range 24 .. 27;
      Reserved4 at 0 range 28 .. 31;
   end record;

   DDR_CR56 : aliased DDR_CR56_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0E0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.58 DDR Control Register 57 (DDR_CR57)

   type DDR_CR57_Type is record
      Reserved1 : Bits_4  := 0;
      Reserved2 : Bits_4  := 0;
      Reserved3 : Bits_5  := 0;
      Reserved4 : Bits_3  := 0;
      Reserved5 : Bits_4  := 0;
      Reserved6 : Bits_4  := 0;
      ODTALTEN  : Boolean := False; -- ODT Alternate Enable
      Reserved7 : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR57_Type use record
      Reserved1 at 0 range  0 ..  3;
      Reserved2 at 0 range  4 ..  7;
      Reserved3 at 0 range  8 .. 12;
      Reserved4 at 0 range 13 .. 15;
      Reserved5 at 0 range 16 .. 19;
      Reserved6 at 0 range 20 .. 23;
      ODTALTEN  at 0 range 24 .. 24;
      Reserved7 at 0 range 25 .. 31;
   end record;

   DDR_CR57 : aliased DDR_CR57_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0E4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.59 DDR Control Register 58 (DDR_CR58)

   type DDR_CR58_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR58_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR58 : aliased DDR_CR58_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0E8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.60 DDR Control Register 59 (DDR_CR59)

   type DDR_CR59_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR59_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR59 : aliased DDR_CR59_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0EC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.61 DDR Control Register 60 (DDR_CR60)

   type DDR_CR60_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR60_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR60 : aliased DDR_CR60_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0F0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.62 DDR Control Register 61 (DDR_CR61)

   type DDR_CR61_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR61_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR61 : aliased DDR_CR61_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0F4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.63 DDR Control Register 62 (DDR_CR62)

   type DDR_CR62_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR62_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR62 : aliased DDR_CR62_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0F8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.64 DDR Control Register 63 (DDR_CR63)

   type DDR_CR63_Type is record
      Reserved1 : Bits_16 := 0;
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_CR63_Type use record
      Reserved1 at 0 range  0 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   DDR_CR63 : aliased DDR_CR63_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#0FC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.65 RCR Control Register (DDR_RCR)

   type DDR_RCR_Type is record
      Reserved1 : Bits_30 := 0;
      RST       : Boolean := False; -- Reset
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_RCR_Type use record
      Reserved1 at 0 range  0 .. 29;
      RST       at 0 range 30 .. 30;
      Reserved2 at 0 range 31 .. 31;
   end record;

   DDR_RCR : aliased DDR_RCR_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#180#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.66 I/O Pad Control Register (DDR_PAD_CTRL)

   SPARE_DLY_CTRL_NONE : constant := 2#0000#; -- No buffer, only mux delay
   SPARE_DLY_CTRL_4    : constant := 2#0001#; -- 4 buffers
   SPARE_DLY_CTRL_7    : constant := 2#0010#; -- 7 buffers
   SPARE_DLY_CTRL_10   : constant := 2#0011#; -- 10 buffers

   PAD_ODT_CS0_DISABLE  : constant := 2#00#; -- ODT Disabled
   PAD_ODT_CS0_150OHM   : constant := 2#01#; -- 150 Ohms
   PAD_ODT_CS0_150OHM_2 : constant := 2#10#; -- 150 Ohms
   PAD_ODT_CS0_75OHM    : constant := 2#11#; -- 75 Ohms

   type DDR_PAD_CTRL_Type is record
      SPARE_DLY_CTRL : Bits_4 := SPARE_DLY_CTRL_NONE; -- These SPARE_DLY_CTRL[3:0]bits set the delay chains in the spare logic.
      Reserved1      : Bits_4 := 0;
      Reserved2      : Bits_8 := 2#00000010#;
      Reserved3      : Bits_2 := 0;
      Reserved4      : Bits_2 := 0;
      Reserved5      : Bits_1 := 0;
      Reserved6      : Bits_3 := 0;
      PAD_ODT_CS0    : Bits_2 := PAD_ODT_CS0_DISABLE; -- Required to enable ODT and configure ODT resistor value in the pad.
      Reserved7      : Bits_2 := 0;
      Reserved8      : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DDR_PAD_CTRL_Type use record
      SPARE_DLY_CTRL at 0 range  0 ..  3;
      Reserved1      at 0 range  4 ..  7;
      Reserved2      at 0 range  8 .. 15;
      Reserved3      at 0 range 16 .. 17;
      Reserved4      at 0 range 18 .. 19;
      Reserved5      at 0 range 20 .. 20;
      Reserved6      at 0 range 21 .. 23;
      PAD_ODT_CS0    at 0 range 24 .. 25;
      Reserved7      at 0 range 26 .. 27;
      Reserved8      at 0 range 28 .. 31;
   end record;

   DDR_PAD_CTRL : aliased DDR_PAD_CTRL_Type
      with Address              => System'To_Address (DDRMC_BASEADDRESS + 16#1AC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 44 Periodic Interrupt Timer (PIT)
   ----------------------------------------------------------------------------

   -- 44.3.1 PIT Module Control Register (PIT_MCR)

   type PIT_MCR_Type is record
      FRZ       : Boolean := False; -- Freeze
      MDIS      : Boolean := True;  -- Module Disable - (PIT section)
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_MCR_Type use record
      FRZ       at 0 range 0 ..  0;
      MDIS      at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  2;
      Reserved2 at 0 range 3 .. 31;
   end record;

   -- 44.3.2 Timer Load Value Register (PIT_LDVALn)

   type PIT_LDVALn_Type is record
      TSV : Unsigned_32 := 0; -- Timer Start Value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_LDVALn_Type use record
      TSV at 0 range 0 .. 31;
   end record;

   -- 44.3.3 Current Timer Value Register (PIT_CVALn)

   type PIT_CVALn_Type is record
      TVL : Unsigned_32; -- Current Timer Value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_CVALn_Type use record
      TVL at 0 range 0 .. 31;
   end record;

   -- 44.3.4 Timer Control Register (PIT_TCTRLn)

   type PIT_TCTRLn_Type is record
      TEN      : Boolean := False; -- Timer Enable
      TIE      : Boolean := False; -- Timer Interrupt Enable
      CHN      : Boolean := False; -- Chain Mode
      Reserved : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_TCTRLn_Type use record
      TEN      at 0 range 0 ..  0;
      TIE      at 0 range 1 ..  1;
      CHN      at 0 range 2 ..  2;
      Reserved at 0 range 3 .. 31;
   end record;

   -- 44.3.5 Timer Flag Register (PIT_TFLGn)

   type PIT_TFLGn_Type is record
      TIF      : Boolean := False; -- Timer Interrupt Flag
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_TFLGn_Type use record
      TIF      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 44.3 Memory map/register description

   type PITn_Type is record
      LDVAL : PIT_LDVALn_Type with Volatile_Full_Access => True;
      CVAL  : PIT_CVALn_Type  with Volatile_Full_Access => True;
      TCTRL : PIT_TCTRLn_Type with Volatile_Full_Access => True;
      TFLG  : PIT_TFLGn_Type  with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;

   type PITn_Array_Type is array (0 .. 3) of PITn_Type
      with Pack     => True,
           Volatile => True;

   type PIT_Type is record
      MCR : PIT_MCR_Type;
      PIT : PITn_Array_Type;
   end record
      with Volatile => True;
   for PIT_Type use record
      MCR at 16#000# range 0 .. 31;
      PIT at 16#100# range 0 .. 4 * 4 * 32 - 1;
   end record;

   PIT : aliased PIT_Type
      with Address    => System'To_Address (16#4003_7000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 54 Serial Peripheral Interface (SPI)
   ----------------------------------------------------------------------------

   -- 54.3.1 Module Configuration Register (SPIx_MCR)

   SMPL_PT_0    : constant := 2#00#; -- 0 protocol clock cycles between SCK edge and SIN sample
   SMPL_PT_1    : constant := 2#01#; -- 1 protocol clock cycle between SCK edge and SIN sample
   SMPL_PT_2    : constant := 2#10#; -- 2 protocol clock cycles between SCK edge and SIN sample
   SMPL_PT_RSVD : constant := 2#11#; -- Reserved

   PCSIS_LOW  : constant := 0; -- The inactive state of PCSx is low.
   PCSIS_HIGH : constant := 1; -- The inactive state of PCSx is high.

   DCONF_SPI   : constant := 2#00#; -- SPI
   DCONF_RSVD1 : constant := 2#01#; -- Reserved
   DCONF_RSVD2 : constant := 2#10#; -- Reserved
   DCONF_RSVD3 : constant := 2#11#; -- Reserved

   type SPIx_MCR_Type is record
      HALT      : Boolean := False;     -- Halt
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_5  := 0;
      SMPL_PT   : Bits_2  := SMPL_PT_0; -- Sample Point
      CLR_RXF   : Boolean := False;     -- CLR_RXF
      CLR_TXF   : Boolean := False;     -- Clear TX FIFO
      DIS_RXF   : Boolean := False;     -- Disable Receive FIFO
      DIS_TXF   : Boolean := False;     -- Disable Transmit FIFO
      MDIS      : Boolean := True;      -- Module Disable
      DOZE      : Boolean := False;     -- Doze Enable
      PCSIS0    : Bits_1  := PCSIS_LOW; -- Peripheral Chip Select x Inactive State
      PCSIS1    : Bits_1  := PCSIS_LOW; -- ''
      PCSIS2    : Bits_1  := PCSIS_LOW; -- ''
      PCSIS3    : Bits_1  := PCSIS_LOW; -- ''
      PCSIS4    : Bits_1  := PCSIS_LOW; -- ''
      PCSIS5    : Bits_1  := PCSIS_LOW; -- ''
      Reserved4 : Bits_2  := 0;
      ROOE      : Boolean := False;     -- Receive FIFO Overflow Overwrite Enable
      PCSSE     : Boolean := False;     -- Peripheral Chip Select Strobe Enable
      MTFE      : Boolean := False;     -- Modified Transfer Format Enable
      FRZ       : Boolean := False;     -- Freeze
      DCONF     : Bits_2  := DCONF_SPI; -- SPI Configuration.
      CONT_SCKE : Boolean := False;     -- Continuous SCK Enable
      MSTR      : Boolean := False;     -- Master/Slave Mode Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_MCR_Type use record
      HALT      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  2;
      Reserved3 at 0 range  3 ..  7;
      SMPL_PT   at 0 range  8 ..  9;
      CLR_RXF   at 0 range 10 .. 10;
      CLR_TXF   at 0 range 11 .. 11;
      DIS_RXF   at 0 range 12 .. 12;
      DIS_TXF   at 0 range 13 .. 13;
      MDIS      at 0 range 14 .. 14;
      DOZE      at 0 range 15 .. 15;
      PCSIS0    at 0 range 16 .. 16;
      PCSIS1    at 0 range 17 .. 17;
      PCSIS2    at 0 range 18 .. 18;
      PCSIS3    at 0 range 19 .. 19;
      PCSIS4    at 0 range 20 .. 20;
      PCSIS5    at 0 range 21 .. 21;
      Reserved4 at 0 range 22 .. 23;
      ROOE      at 0 range 24 .. 24;
      PCSSE     at 0 range 25 .. 25;
      MTFE      at 0 range 26 .. 26;
      FRZ       at 0 range 27 .. 27;
      DCONF     at 0 range 28 .. 29;
      CONT_SCKE at 0 range 30 .. 30;
      MSTR      at 0 range 31 .. 31;
   end record;

   -- 54.3.2 Transfer Count Register (SPIx_TCR)

   type SPIx_TCR_Type is record
      Reserved : Bits_16     := 0;
      SPI_TCNT : Unsigned_16 := 0; -- SPI Transfer Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_TCR_Type use record
      Reserved at 0 range  0 .. 15;
      SPI_TCNT at 0 range 16 .. 31;
   end record;

   -- 54.3.3 Clock and Transfer Attributes Register (In Master Mode) (SPIx_CTARn)
   -- 54.3.4Clock and Transfer Attributes Register (In Slave Mode) (SPIx_CTARn_SLAVE)

   BR_DIV2   : constant := 2#0000#; -- Baud Rate Scaler Value = 2
   BR_DIV4   : constant := 2#0001#; -- Baud Rate Scaler Value = 4
   BR_DIV6   : constant := 2#0010#; -- Baud Rate Scaler Value = 6
   BR_DIV8   : constant := 2#0011#; -- Baud Rate Scaler Value = 8
   BR_DIV16  : constant := 2#0100#; -- Baud Rate Scaler Value = 16
   BR_DIV32  : constant := 2#0101#; -- Baud Rate Scaler Value = 32
   BR_DIV64  : constant := 2#0110#; -- Baud Rate Scaler Value = 64
   BR_DIV128 : constant := 2#0111#; -- Baud Rate Scaler Value = 128
   BR_DIV256 : constant := 2#1000#; -- Baud Rate Scaler Value = 256
   BR_DIV512 : constant := 2#1001#; -- Baud Rate Scaler Value = 512
   BR_DIV1k  : constant := 2#1010#; -- Baud Rate Scaler Value = 1024
   BR_DIV2k  : constant := 2#1011#; -- Baud Rate Scaler Value = 2048
   BR_DIV4k  : constant := 2#1100#; -- Baud Rate Scaler Value = 4096
   BR_DIV8k  : constant := 2#1101#; -- Baud Rate Scaler Value = 8192
   BR_DIV16k : constant := 2#1110#; -- Baud Rate Scaler Value = 16384
   BR_DIV32k : constant := 2#1111#; -- Baud Rate Scaler Value = 32768

   CSSCK_2   : constant := 2#0000#; -- Delay Scaler Value = 2
   CSSCK_4   : constant := 2#0001#; -- Delay Scaler Value = 4
   CSSCK_8   : constant := 2#0010#; -- Delay Scaler Value = 8
   CSSCK_16  : constant := 2#0011#; -- Delay Scaler Value = 16
   CSSCK_32  : constant := 2#0100#; -- Delay Scaler Value = 32
   CSSCK_64  : constant := 2#0101#; -- Delay Scaler Value = 64
   CSSCK_128 : constant := 2#0110#; -- Delay Scaler Value = 128
   CSSCK_256 : constant := 2#0111#; -- Delay Scaler Value = 256
   CSSCK_512 : constant := 2#1000#; -- Delay Scaler Value = 512
   CSSCK_1k  : constant := 2#1001#; -- Delay Scaler Value = 1024
   CSSCK_2k  : constant := 2#1010#; -- Delay Scaler Value = 2048
   CSSCK_4k  : constant := 2#1011#; -- Delay Scaler Value = 4096
   CSSCK_8k  : constant := 2#1100#; -- Delay Scaler Value = 8192
   CSSCK_16k : constant := 2#1101#; -- Delay Scaler Value = 16384
   CSSCK_32k : constant := 2#1110#; -- Delay Scaler Value = 32768
   CSSCK_64k : constant := 2#1111#; -- Delay Scaler Value = 65536

   PBR_2 : constant := 2#00#; -- Baud Rate Prescaler value is 2.
   PBR_3 : constant := 2#01#; -- Baud Rate Prescaler value is 3.
   PBR_5 : constant := 2#10#; -- Baud Rate Prescaler value is 5.
   PBR_7 : constant := 2#11#; -- Baud Rate Prescaler value is 7.

   PDT_1 : constant := 2#00#; -- Delay after Transfer Prescaler value is 1.
   PDT_3 : constant := 2#01#; -- Delay after Transfer Prescaler value is 3.
   PDT_5 : constant := 2#10#; -- Delay after Transfer Prescaler value is 5.
   PDT_7 : constant := 2#11#; -- Delay after Transfer Prescaler value is 7.

   PASC_1 : constant := 2#00#; -- Delay after Transfer Prescaler value is 1.
   PASC_3 : constant := 2#01#; -- Delay after Transfer Prescaler value is 3.
   PASC_5 : constant := 2#10#; -- Delay after Transfer Prescaler value is 5.
   PASC_7 : constant := 2#11#; -- Delay after Transfer Prescaler value is 7.

   PCSSCK_1 : constant := 2#00#; -- PCS to SCK Prescaler value is 1.
   PCSSCK_3 : constant := 2#01#; -- PCS to SCK Prescaler value is 3.
   PCSSCK_5 : constant := 2#10#; -- PCS to SCK Prescaler value is 5.
   PCSSCK_7 : constant := 2#11#; -- PCS to SCK Prescaler value is 7.

   CPHA_CAPLCHGF : constant := 0; -- Data is captured on the leading edge of SCK and changed on the following edge.
   CPHA_CHGLCAPF : constant := 1; -- Data is changed on the leading edge of SCK and captured on the following edge.

   CPOL_LOW  : constant := 0; -- The inactive state value of SCK is low.
   CPOL_HIGH : constant := 1; -- The inactive state value of SCK is high.

   FMSZ_4  : constant := 2#0011#; -- Frame Size = 4
   FMSZ_5  : constant := 2#0100#; -- Frame Size = 5
   FMSZ_6  : constant := 2#0101#; -- Frame Size = 6
   FMSZ_7  : constant := 2#0110#; -- Frame Size = 7
   FMSZ_8  : constant := 2#0111#; -- Frame Size = 8
   FMSZ_9  : constant := 2#1000#; -- Frame Size = 9
   FMSZ_10 : constant := 2#1001#; -- Frame Size = 10
   FMSZ_11 : constant := 2#1010#; -- Frame Size = 11
   FMSZ_12 : constant := 2#1011#; -- Frame Size = 12
   FMSZ_13 : constant := 2#1100#; -- Frame Size = 13
   FMSZ_14 : constant := 2#1101#; -- Frame Size = 14
   FMSZ_15 : constant := 2#1110#; -- Frame Size = 15
   FMSZ_16 : constant := 2#1111#; -- Frame Size = 16

   type SPIx_CTARn_Type is record
      BR     : Bits_4  := BR_DIV2;       -- Baud Rate Scaler
      DT     : Bits_4  := 0;             -- Delay After Transfer Scaler
      ASC    : Bits_4  := 0;             -- After SCK Delay Scaler
      CSSCK  : Bits_4  := CSSCK_2;       -- PCS to SCK Delay Scaler
      PBR    : Bits_2  := PBR_2;         -- Baud Rate Prescaler
      PDT    : Bits_2  := PDT_1;         -- Delay after Transfer Prescaler
      PASC   : Bits_2  := PASC_1;        -- After SCK Delay Prescaler
      PCSSCK : Bits_2  := PCSSCK_1;      -- PCS to SCK Delay Prescaler
      LSBFE  : Boolean := False;         -- LSB First
      CPHA   : Bits_1  := CPHA_CAPLCHGF; -- Clock Phase
      CPOL   : Bits_1  := CPOL_LOW;      -- Clock Polarity
      FMSZ   : Bits_4  := FMSZ_16;       -- Frame Size
      DBR    : Boolean := False;         -- Double Baud Rate
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_CTARn_Type use record
      BR     at 0 range  0 ..  3;
      DT     at 0 range  4 ..  7;
      ASC    at 0 range  8 .. 11;
      CSSCK  at 0 range 12 .. 15;
      PBR    at 0 range 16 .. 17;
      PDT    at 0 range 18 .. 19;
      PASC   at 0 range 20 .. 21;
      PCSSCK at 0 range 22 .. 23;
      LSBFE  at 0 range 24 .. 24;
      CPHA   at 0 range 25 .. 25;
      CPOL   at 0 range 26 .. 26;
      FMSZ   at 0 range 27 .. 30;
      DBR    at 0 range 31 .. 31;
   end record;

   -- 54.3.5 Status Register (SPIx_SR)

   type SPIx_SR_Type is record
      POPNXTPTR : Bits_4  := 0;     -- Pop Next Pointer
      RXCTR     : Bits_4  := 0;     -- RX FIFO Counter
      TXNXTPTR  : Bits_4  := 0;     -- Transmit Next Pointer
      TXCTR     : Bits_4  := 0;     -- TX FIFO Counter
      Reserved1 : Bits_1  := 0;
      RFDF      : Boolean := False; -- Receive FIFO Drain Flag
      Reserved2 : Bits_1  := 0;
      RFOF      : Boolean := False; -- Receive FIFO Overflow Flag
      Reserved3 : Bits_1  := 0;
      Reserved4 : Bits_1  := 0;
      Reserved5 : Bits_1  := 0;
      Reserved6 : Bits_1  := 0;
      Reserved7 : Bits_1  := 0;
      TFFF      : Boolean := True;  -- Transmit FIFO Fill Flag
      Reserved8 : Bits_1  := 0;
      TFUF      : Boolean := False; -- Transmit FIFO Underflow Flag
      EOQF      : Boolean := False; -- End of Queue Flag
      Reserved9 : Bits_1  := 0;
      TXRXS     : Boolean := False; -- TX and RX Status
      TCF       : Boolean := False; -- Transfer Complete Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_SR_Type use record
      POPNXTPTR at 0 range  0 ..  3;
      RXCTR     at 0 range  4 ..  7;
      TXNXTPTR  at 0 range  8 .. 11;
      TXCTR     at 0 range 12 .. 15;
      Reserved1 at 0 range 16 .. 16;
      RFDF      at 0 range 17 .. 17;
      Reserved2 at 0 range 18 .. 18;
      RFOF      at 0 range 19 .. 19;
      Reserved3 at 0 range 20 .. 20;
      Reserved4 at 0 range 21 .. 21;
      Reserved5 at 0 range 22 .. 22;
      Reserved6 at 0 range 23 .. 23;
      Reserved7 at 0 range 24 .. 24;
      TFFF      at 0 range 25 .. 25;
      Reserved8 at 0 range 26 .. 26;
      TFUF      at 0 range 27 .. 27;
      EOQF      at 0 range 28 .. 28;
      Reserved9 at 0 range 29 .. 29;
      TXRXS     at 0 range 30 .. 30;
      TCF       at 0 range 31 .. 31;
   end record;

   -- 54.3.6 DMA/Interrupt Request Select and Enable Register (SPIx_RSER)

   RFDF_DIRS_IRQ : constant := 0; -- Interrupt request.
   RFDF_DIRS_DMA : constant := 1; -- DMA request.

   TFFF_DIRS_IRQ : constant := 0; -- TFFF flag generates interrupt requests.
   TFFF_DIRS_DMA : constant := 1; -- TFFF flag generates DMA requests.

   type SPIx_RSER_Type is record
      Reserved1  : Bits_14 := 0;
      Reserved2  : Bits_1  := 0;
      Reserved3  : Bits_1  := 0;
      RFDF_DIRS  : Bits_1  := RFDF_DIRS_IRQ; -- Receive FIFO Drain DMA or Interrupt Request Select
      RFDF_RE    : Boolean := False;         -- Receive FIFO Drain Request Enable
      Reserved4  : Bits_1  := 0;
      RFOF_RE    : Boolean := False;         -- Receive FIFO Overflow Request Enable
      Reserved5  : Bits_1  := 0;
      Reserved6  : Bits_1  := 0;
      Reserved7  : Bits_1  := 0;
      Reserved8  : Bits_1  := 0;
      TFFF_DIRS  : Bits_1  := TFFF_DIRS_IRQ; -- Transmit FIFO Fill DMA or Interrupt Request Select
      TFFF_RE    : Boolean := False;         -- Transmit FIFO Fill Request Enable
      Reserved9  : Bits_1  := 0;
      TFUF_RE    : Boolean := False;         -- Transmit FIFO Underflow Request Enable
      EOQF_RE    : Boolean := False;         -- Finished Request Enable
      Reserved10 : Bits_1  := 0;
      Reserved11 : Bits_1  := 0;
      TCF_RE     : Boolean := False;         -- Transmission Complete Request Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_RSER_Type use record
      Reserved1  at 0 range  0 .. 13;
      Reserved2  at 0 range 14 .. 14;
      Reserved3  at 0 range 15 .. 15;
      RFDF_DIRS  at 0 range 16 .. 16;
      RFDF_RE    at 0 range 17 .. 17;
      Reserved4  at 0 range 18 .. 18;
      RFOF_RE    at 0 range 19 .. 19;
      Reserved5  at 0 range 20 .. 20;
      Reserved6  at 0 range 21 .. 21;
      Reserved7  at 0 range 22 .. 22;
      Reserved8  at 0 range 23 .. 23;
      TFFF_DIRS  at 0 range 24 .. 24;
      TFFF_RE    at 0 range 25 .. 25;
      Reserved9  at 0 range 26 .. 26;
      TFUF_RE    at 0 range 27 .. 27;
      EOQF_RE    at 0 range 28 .. 28;
      Reserved10 at 0 range 29 .. 29;
      Reserved11 at 0 range 30 .. 30;
      TCF_RE     at 0 range 31 .. 31;
   end record;

   -- 54.3.7 PUSH TX FIFO Register In Master Mode (SPIx_PUSHR)
   -- 54.3.8 PUSH TX FIFO Register In Slave Mode (SPIx_PUSHR_SLAVE)

   PCS_NEGATE : constant := 0; -- Negate the PCS[x] signal.
   PCS_ASSERT : constant := 1; -- Assert the PCS[x] signal.

   CTAS_CTAR0 : constant := 2#000#; -- CTAR0
   CTAS_CTAR1 : constant := 2#001#; -- CTAR1
   CTAS_RSVD1 : constant := 2#010#; -- Reserved
   CTAS_RSVD2 : constant := 2#011#; -- ''
   CTAS_RSVD3 : constant := 2#100#; -- ''
   CTAS_RSVD4 : constant := 2#101#; -- ''
   CTAS_RSVD5 : constant := 2#110#; -- ''
   CTAS_RSVD6 : constant := 2#111#; -- ''

   type SPIx_PUSHR_Type is record
      TXDATA    : Bits_16;               -- Transmit Data
      PCS0      : Bits_1  := PCS_NEGATE; -- Select which PCS signals are to be asserted for the transfer.
      PCS1      : Bits_1  := PCS_NEGATE; -- ''
      PCS2      : Bits_1  := PCS_NEGATE; -- ''
      PCS3      : Bits_1  := PCS_NEGATE; -- ''
      PCS4      : Bits_1  := PCS_NEGATE; -- ''
      PCS5      : Bits_1  := PCS_NEGATE; -- ''
      Reserved1 : Bits_2  := 0;
      Reserved2 : Bits_2  := 0;
      CTCNT     : Boolean := False;      -- Clear Transfer Counter
      EOQ       : Boolean := False;      -- End Of Queue
      CTAS      : Bits_3  := CTAS_CTAR0; -- Clock and Transfer Attributes Select
      CONT      : Boolean := False;      -- Continuous Peripheral Chip Select Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_PUSHR_Type use record
      TXDATA    at 0 range  0 .. 15;
      PCS0      at 0 range 16 .. 16;
      PCS1      at 0 range 17 .. 17;
      PCS2      at 0 range 18 .. 18;
      PCS3      at 0 range 19 .. 19;
      PCS4      at 0 range 20 .. 20;
      PCS5      at 0 range 21 .. 21;
      Reserved1 at 0 range 22 .. 23;
      Reserved2 at 0 range 24 .. 25;
      CTCNT     at 0 range 26 .. 26;
      EOQ       at 0 range 27 .. 27;
      CTAS      at 0 range 28 .. 30;
      CONT      at 0 range 31 .. 31;
   end record;

   -- 54.3.9 POP RX FIFO Register (SPIx_POPR)

   type SPIx_POPR_Type is record
      RXDATA : Bits_32 := 0; -- Received Data
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_POPR_Type use record
      RXDATA at 0 range 0 .. 31;
   end record;

   -- 54.3.10 Transmit FIFO Registers (SPIx_TXFRn)

   type SPIx_TXFRn_Type is record
      TXDATA       : Bits_16; -- Transmit Data
      TXCMD_TXDATA : Bits_16; -- Transmit Command or Transmit Data
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_TXFRn_Type use record
      TXDATA       at 0 range  0 .. 15;
      TXCMD_TXDATA at 0 range 16 .. 31;
   end record;

   -- 54.3.11 Receive FIFO Registers (SPIx_RXFRn)

   type SPIx_RXFRn_Type is record
      RXDATA : Bits_32; -- Receive Data
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPIx_RXFRn_Type use record
      RXDATA at 0 range 0 .. 31;
   end record;

   -- 54.3 Memory Map/Register Definition

   type SPI_Type is record
      MCR   : SPIx_MCR_Type   with Volatile_Full_Access => True;
      TCR   : SPIx_TCR_Type   with Volatile_Full_Access => True;
      CTAR0 : SPIx_CTARn_Type with Volatile_Full_Access => True;
      CTAR1 : SPIx_CTARn_Type with Volatile_Full_Access => True;
      SR    : SPIx_SR_Type    with Volatile_Full_Access => True;
      RSER  : SPIx_RSER_Type  with Volatile_Full_Access => True;
      PUSHR : SPIx_PUSHR_Type with Volatile_Full_Access => True;
      POPR  : SPIx_POPR_Type  with Volatile_Full_Access => True;
      TXFR0 : SPIx_TXFRn_Type with Volatile_Full_Access => True;
      TXFR1 : SPIx_TXFRn_Type with Volatile_Full_Access => True;
      TXFR2 : SPIx_TXFRn_Type with Volatile_Full_Access => True;
      TXFR3 : SPIx_TXFRn_Type with Volatile_Full_Access => True;
      RXFR0 : SPIx_RXFRn_Type with Volatile_Full_Access => True;
      RXFR1 : SPIx_RXFRn_Type with Volatile_Full_Access => True;
      RXFR2 : SPIx_RXFRn_Type with Volatile_Full_Access => True;
      RXFR3 : SPIx_RXFRn_Type with Volatile_Full_Access => True;
   end record
      with Size => 16#8C# * 8;
   for SPI_Type use record
      MCR   at 16#00# range 0 .. 31;
      TCR   at 16#08# range 0 .. 31;
      CTAR0 at 16#0C# range 0 .. 31;
      CTAR1 at 16#10# range 0 .. 31;
      SR    at 16#2C# range 0 .. 31;
      RSER  at 16#30# range 0 .. 31;
      PUSHR at 16#34# range 0 .. 31;
      POPR  at 16#38# range 0 .. 31;
      TXFR0 at 16#3C# range 0 .. 31;
      TXFR1 at 16#40# range 0 .. 31;
      TXFR2 at 16#44# range 0 .. 31;
      TXFR3 at 16#48# range 0 .. 31;
      RXFR0 at 16#7C# range 0 .. 31;
      RXFR1 at 16#80# range 0 .. 31;
      RXFR2 at 16#84# range 0 .. 31;
      RXFR3 at 16#88# range 0 .. 31;
   end record;

   SPI0 : aliased SPI_Type
      with Address    => System'To_Address (16#4002_C000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   SPI1 : aliased SPI_Type
      with Address    => System'To_Address (16#4002_D000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   SPI2 : aliased SPI_Type
      with Address    => System'To_Address (16#400A_C000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 55 Inter-Integrated Circuit (I2C)
   ----------------------------------------------------------------------------

   -- 55.3.1 I2C Address Register 1 (I2Cx_A1)

   type I2Cx_A1_Type is record
      Reserved : Bits_1 := 0;
      AD       : Bits_7 := 0; -- Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_A1_Type use record
      Reserved at 0 range 0 .. 0;
      AD       at 0 range 1 .. 7;
   end record;

   -- 55.3.2 I2C Frequency Divider register (I2Cx_F)

   MULT_1    : constant := 2#00#; -- mul = 1
   MULT_2    : constant := 2#01#; -- mul = 2
   MULT_4    : constant := 2#10#; -- mul = 4
   MULT_RSVD : constant := 2#11#; -- Reserved

   type I2Cx_F_Type is record
      ICR  : Bits_6 := 0;      -- ClockRate
      MULT : Bits_2 := MULT_1; -- Multiplier Factor
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_F_Type use record
      ICR  at 0 range 0 .. 5;
      MULT at 0 range 6 .. 7;
   end record;

   -- 55.3.3 I2C Control Register 1 (I2Cx_C1)

   TXAK_ACK : constant := 0; -- An acknowledge signal is sent to the bus on the following receiving byte (if FACK is cleared) or the current receiving byte (if FACK is set).
   TXAK_NAK : constant := 1; -- No acknowledge signal is sent to the bus on the following receiving data byte (if FACK is cleared) or the current receiving data byte (if FACK is set).

   TX_RX : constant := 0; -- Receive
   TX_TX : constant := 1; -- Transmit

   MST_SLV : constant := 0; -- Slave mode
   MST_MST : constant := 1; -- Master mode

   type I2Cx_C1_Type is record
      DMAEN : Boolean := False;    -- DMA Enable
      WUEN  : Boolean := False;    -- Wakeup Enable
      RSTA  : Boolean := False;    -- Repeat START
      TXAK  : Bits_1  := TXAK_ACK; -- Transmit Acknowledge Enable
      TX    : Bits_1  := TX_RX;    -- Transmit Mode Select
      MST   : Bits_1  := MST_MST;  -- Master Mode Select
      IICIE : Boolean := False;    -- I2C Interrupt Enable
      IICEN : Boolean := False;    -- I2C Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_C1_Type use record
      DMAEN at 0 range 0 .. 0;
      WUEN  at 0 range 1 .. 1;
      RSTA  at 0 range 2 .. 2;
      TXAK  at 0 range 3 .. 3;
      TX    at 0 range 4 .. 4;
      MST   at 0 range 5 .. 5;
      IICIE at 0 range 6 .. 6;
      IICEN at 0 range 7 .. 7;
   end record;

   -- 55.3.4 I2C Status register (I2Cx_S)

   RXAK_ACK : constant := 0; -- Acknowledge signal was received after the completion of one byte of data transmission on the bus
   RXAK_NAK : constant := 1; -- No acknowledge signal detected

   SRW_MSTWR_SLVRX : constant := 0; -- Slave receive, master writing to slave
   SRW_MSTRD_SLVTX : constant := 1; -- Slave transmit, master reading from slave

   type I2Cx_S_Type is record
      RXAK  : Bits_1  := RXAK_ACK;        -- Receive Acknowledge
      IICIF : Boolean := False;           -- Interrupt Flag
      SRW   : Bits_1  := SRW_MSTWR_SLVRX; -- Slave Read/Write
      RAM   : Boolean := False;           -- Range Address Match
      ARBL  : Boolean := False;           -- Arbitration Lost
      BUSY  : Boolean := False;           -- Bus Busy
      IAAS  : Boolean := False;           -- Addressed As A Slave
      TCF   : Boolean := True;            -- Transfer Complete Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_S_Type use record
      RXAK  at 0 range 0 .. 0;
      IICIF at 0 range 1 .. 1;
      SRW   at 0 range 2 .. 2;
      RAM   at 0 range 3 .. 3;
      ARBL  at 0 range 4 .. 4;
      BUSY  at 0 range 5 .. 5;
      IAAS  at 0 range 6 .. 6;
      TCF   at 0 range 7 .. 7;
   end record;

   -- 55.3.5 I2C Data I/O register (I2Cx_D)

   -- 55.3.6 I2C Control Register 2 (I2Cx_C2)

   SBRC_FOLLOW : constant := 0; -- The slave baud rate follows the master baud rate and clock stretching may occur
   SBRC_NOTDEP : constant := 1; -- Slave baud rate is independent of the master baud rate

   ADEXT_7  : constant := 0; -- 7-bit address scheme
   ADEXT_10 : constant := 1; -- 10-bit address scheme

   type I2Cx_C2_Type is record
      AD    : Bits_3  := 0;           -- Slave Address
      RMEN  : Boolean := False;       -- Range Address Matching Enable
      SBRC  : Bits_1  := SBRC_FOLLOW; -- Slave Baud Rate Control
      HDRS  : Boolean := False;       -- High Drive Select
      ADEXT : Bits_1  := ADEXT_7;     -- Address Extension
      GCAEN : Boolean := False;       -- General Call Address Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_C2_Type use record
      AD    at 0 range 0 .. 2;
      RMEN  at 0 range 3 .. 3;
      SBRC  at 0 range 4 .. 4;
      HDRS  at 0 range 5 .. 5;
      ADEXT at 0 range 6 .. 6;
      GCAEN at 0 range 7 .. 7;
   end record;

   -- 55.3.7 I2C Programmable Input Glitch Filter Register (I2Cx_FLT)

   FLT_BYPASS : constant := 0; -- No filter/bypass

   type I2Cx_FLT_Type is record
      FLT       : Bits_5 := FLT_BYPASS; -- I2C Programmable Filter Factor
      Reserved1 : Bits_2 := 0;
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_FLT_Type use record
      FLT       at 0 range 0 .. 4;
      Reserved1 at 0 range 5 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- 55.3.8 I2C Range Address register (I2Cx_RA)

   type I2Cx_RA_Type is record
      Reserved : Bits_1 := 0;
      RAD      : Bits_7 := 0; -- Range Slave Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_RA_Type use record
      Reserved at 0 range 0 .. 0;
      RAD      at 0 range 1 .. 7;
   end record;

   -- 55.3.9 I2C SMBus Control and Status register (I2Cx_SMB)

   TCKSEL_DIV64 : constant := 0; -- Timeout counter counts at the frequency of the I2C module clock / 64
   TCKSEL_DIV1  : constant := 1; -- Timeout counter counts at the frequency of the I2C module clock

   type I2Cx_SMB_Type is record
      SHTF2IE : Boolean := False;        -- SHTF2 Interrupt Enable
      SHTF2   : Boolean := False;        -- SCL High Timeout Flag 2
      SHTF1   : Boolean := False;        -- SCL High Timeout Flag 1
      SLTF    : Boolean := False;        -- SCL Low Timeout Flag
      TCKSEL  : Bits_1  := TCKSEL_DIV64; -- Timeout Counter Clock Select
      SIICAEN : Boolean := False;        -- Second I2C Address Enable
      ALERTEN : Boolean := False;        -- SMBus Alert Response Address Enable
      FACK    : Boolean := False;        -- Fast NACK/ACK Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_SMB_Type use record
      SHTF2IE at 0 range 0 .. 0;
      SHTF2   at 0 range 1 .. 1;
      SHTF1   at 0 range 2 .. 2;
      SLTF    at 0 range 3 .. 3;
      TCKSEL  at 0 range 4 .. 4;
      SIICAEN at 0 range 5 .. 5;
      ALERTEN at 0 range 6 .. 6;
      FACK    at 0 range 7 .. 7;
   end record;

   -- 55.3.10 I2C Address Register 2 (I2Cx_A2)

   type I2Cx_A2_Type is record
      Reserved : Bits_1 := 0;
      SAD      : Bits_7 := 2#1100001#; -- SMBus Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_A2_Type use record
      Reserved at 0 range 0 .. 0;
      SAD      at 0 range 1 .. 7;
   end record;

   -- 55.3 Memory map/register definition

   type I2C_Type is record
      A1   : I2Cx_A1_Type  with Volatile_Full_Access => True;
      F    : I2Cx_F_Type   with Volatile_Full_Access => True;
      C1   : I2Cx_C1_Type  with Volatile_Full_Access => True;
      S    : I2Cx_S_Type   with Volatile_Full_Access => True;
      D    : Unsigned_8    with Volatile_Full_Access => True;
      C2   : I2Cx_C2_Type  with Volatile_Full_Access => True;
      FLT  : I2Cx_FLT_Type with Volatile_Full_Access => True;
      RA   : I2Cx_RA_Type  with Volatile_Full_Access => True;
      SMB  : I2Cx_SMB_Type with Volatile_Full_Access => True;
      A2   : I2Cx_A2_Type  with Volatile_Full_Access => True;
      SLTH : Unsigned_8    with Volatile_Full_Access => True;
      SLTL : Unsigned_8    with Volatile_Full_Access => True;
   end record
      with Size => 16#C# * 8;
   for I2C_Type use record
      A1   at 16#0# range 0 .. 7;
      F    at 16#1# range 0 .. 7;
      C1   at 16#2# range 0 .. 7;
      S    at 16#3# range 0 .. 7;
      D    at 16#4# range 0 .. 7;
      C2   at 16#5# range 0 .. 7;
      FLT  at 16#6# range 0 .. 7;
      RA   at 16#7# range 0 .. 7;
      SMB  at 16#8# range 0 .. 7;
      A2   at 16#9# range 0 .. 7;
      SLTH at 16#A# range 0 .. 7;
      SLTL at 16#B# range 0 .. 7;
   end record;

   I2C0 : aliased I2C_Type
      with Address    => System'To_Address (16#4006_6000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   I2C1 : aliased I2C_Type
      with Address    => System'To_Address (16#4006_7000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 56 Universal Asynchronous Receiver/Transmitter (UART)
   ----------------------------------------------------------------------------

   -- 56.3.1 UART Baud Rate Registers: High (UARTx_BDH)

   type UARTx_BDH_Type is record
      SBR      : Bits_5  := 0;     -- UART Baud Rate Bits
      Reserved : Bits_1  := 0;
      RXEDGIE  : Boolean := False; -- RxD Input Active Edge Interrupt Enable
      LBKDIE   : Boolean := False; -- LIN Break Detect Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_BDH_Type use record
      SBR      at 0 range 0 .. 4;
      Reserved at 0 range 5 .. 5;
      RXEDGIE  at 0 range 6 .. 6;
      LBKDIE   at 0 range 7 .. 7;
   end record;

   -- 56.3.2 UART Baud Rate Registers: Low (UARTx_BDL)

   type UARTx_BDL_Type is record
      SBR : Bits_8 := 4; -- UART Baud Rate Bits
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_BDL_Type use record
      SBR at 0 range 0 .. 7;
   end record;

   -- 56.3.3 UART Control Register 1 (UARTx_C1)

   PT_EVEN : constant := 0; -- Even parity.
   PT_ODD  : constant := 1; -- Odd parity.

   ILT_START : constant := 0; -- Idle character bit count starts after start bit.
   ILT_STOP  : constant := 1; -- Idle character bit count starts after stop bit.

   WAKE_IDLE : constant := 0; -- Idle line wakeup.
   WAKE_ADDR : constant := 1; -- Address mark wakeup.

   M_8 : constant := 0; -- Normal—start + 8 data bits (MSB/LSB first as determined by MSBF) + stop.
   M_9 : constant := 1; -- Use—start + 9 data bits (MSB/LSB first as determined by MSBF) + stop.

   RSRC_INTLOOPBACK : constant := 0; -- Selects internal loop back mode. The receiver input is internally connected to transmitter output.
   RSRC_SINGLEWIRE  : constant := 1; -- Single wire UART mode where the receiver input is connected to the transmit pin input signal.

   UARTSWAI_CONT   : constant := 0; -- UART clock continues to run in Wait mode.
   UARTSWAI_FREEZE : constant := 1; -- UART clock freezes while CPU is in Wait mode.

   type UARTx_C1_Type is record
      PT       : Bits_1  := PT_EVEN;          -- Parity Type
      PE       : Boolean := False;            -- Parity Enable
      ILT      : Bits_1  := ILT_START;        -- Idle Line Type Select
      WAKE     : Bits_1  := WAKE_IDLE;        -- Receiver Wakeup Method Select
      M        : Bits_1  := M_8;              -- 9-bit or 8-bit Mode Select
      RSRC     : Bits_1  := RSRC_INTLOOPBACK; -- Receiver Source Select
      UARTSWAI : Bits_1  := UARTSWAI_CONT;    -- UART Stops in Wait Mode
      LOOPS    : Boolean := False;            -- Loop Mode Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C1_Type use record
      PT       at 0 range 0 .. 0;
      PE       at 0 range 1 .. 1;
      ILT      at 0 range 2 .. 2;
      WAKE     at 0 range 3 .. 3;
      M        at 0 range 4 .. 4;
      RSRC     at 0 range 5 .. 5;
      UARTSWAI at 0 range 6 .. 6;
      LOOPS    at 0 range 7 .. 7;
   end record;

   -- 56.3.4 UART Control Register 2 (UARTx_C2)

   type UARTx_C2_Type is record
      SBK  : Boolean := False; -- Send Break
      RWU  : Boolean := False; -- Receiver Wakeup Control
      RE   : Boolean := False; -- Receiver Enable
      TE   : Boolean := False; -- Transmitter Enable
      ILIE : Boolean := False; -- Idle Line Interrupt Enable
      RIE  : Boolean := False; -- Receiver Full Interrupt or DMA Transfer Enable
      TCIE : Boolean := False; -- Transmission Complete Interrupt Enable
      TIE  : Boolean := False; -- Transmitter Interrupt or DMA Transfer Enable.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C2_Type use record
      SBK  at 0 range 0 .. 0;
      RWU  at 0 range 1 .. 1;
      RE   at 0 range 2 .. 2;
      TE   at 0 range 3 .. 3;
      ILIE at 0 range 4 .. 4;
      RIE  at 0 range 5 .. 5;
      TCIE at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 56.3.5 UART Status Register 1 (UARTx_S1)

   type UARTx_S1_Type is record
      PF   : Boolean; -- Parity Error Flag
      FE   : Boolean; -- Framing Error Flag
      NF   : Boolean; -- Noise Flag
      OVR  : Boolean; -- Receiver Overrun Flag
      IDLE : Boolean; -- Idle Line Flag
      RDRF : Boolean; -- Receive Data Register Full Flag
      TC   : Boolean; -- Transmit Complete Flag
      TDRE : Boolean; -- Transmit Data Register Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_S1_Type use record
      PF   at 0 range 0 .. 0;
      FE   at 0 range 1 .. 1;
      NF   at 0 range 2 .. 2;
      OVR  at 0 range 3 .. 3;
      IDLE at 0 range 4 .. 4;
      RDRF at 0 range 5 .. 5;
      TC   at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   -- 56.3.6 UART Status Register 2 (UARTx_S2)

   type UARTx_S2_Type is record
      RAF     : Boolean := False; -- Receiver Active Flag
      LBKDE   : Boolean := False; -- LIN Break Detection Enable
      BRK13   : Boolean := False; -- Break Transmit Character Length
      RWUID   : Boolean := False; -- Receive Wakeup Idle Detect
      RXINV   : Boolean := False; -- Receive Data Inversion
      MSBF    : Boolean := False; -- Most Significant Bit First
      RXEDGIF : Boolean := False; -- RxD Pin Active Edge Interrupt Flag
      LBKDIF  : Boolean := False; -- LIN Break Detect Interrupt Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_S2_Type use record
      RAF     at 0 range 0 .. 0;
      LBKDE   at 0 range 1 .. 1;
      BRK13   at 0 range 2 .. 2;
      RWUID   at 0 range 3 .. 3;
      RXINV   at 0 range 4 .. 4;
      MSBF    at 0 range 5 .. 5;
      RXEDGIF at 0 range 6 .. 6;
      LBKDIF  at 0 range 7 .. 7;
   end record;

   -- 56.3.7 UART Control Register 3 (UARTx_C3)

   TXDIR_SWIN  : constant := 0; -- TXD pin is an input in single wire mode.
   TXDIR_SWOUT : constant := 1; -- TXD pin is an output in single wire mode.

   type UARTx_C3_Type is record
      PEIE  : Boolean := False;      -- Parity Error Interrupt Enable
      FEIE  : Boolean := False;      -- Framing Error Interrupt Enable
      NEIE  : Boolean := False;      -- Noise Error Interrupt Enable
      ORIE  : Boolean := False;      -- Overrun Error Interrupt Enable
      TXINV : Boolean := False;      -- Transmit Data Inversion.
      TXDIR : Bits_1  := TXDIR_SWIN; -- Transmitter Pin Data Direction in Single-Wire mode
      T8    : Bits_1  := 0;          -- Transmit Bit 8
      R8    : Bits_1  := 0;          -- Received Bit 8
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C3_Type use record
      PEIE  at 0 range 0 .. 0;
      FEIE  at 0 range 1 .. 1;
      NEIE  at 0 range 2 .. 2;
      ORIE  at 0 range 3 .. 3;
      TXINV at 0 range 4 .. 4;
      TXDIR at 0 range 5 .. 5;
      T8    at 0 range 6 .. 6;
      R8    at 0 range 7 .. 7;
   end record;

   -- 56.3.8 UART Data Register (UARTx_D)

   type UARTx_D_Type is record
      RT : Unsigned_8; -- Reads return the contents of the read-only receive data register and writes go to the write-only transmit data register.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_D_Type use record
      RT at 0 range 0 .. 7;
   end record;

   -- 56.3.9 UART Match Address Registers 1 (UARTx_MA1)

   type UARTx_MA1_Type is record
      MA : Unsigned_8 := 0; -- Match Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_MA1_Type use record
      MA at 0 range 0 .. 7;
   end record;

   -- 56.3.10 UART Match Address Registers 2 (UARTx_MA2)

   type UARTx_MA2_Type is record
      MA : Unsigned_8 := 0; -- Match Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_MA2_Type use record
      MA at 0 range 0 .. 7;
   end record;

   -- 56.3.11 UART Control Register 4 (UARTx_C4)

   OSR_4x  : constant := 2#00011#; -- oversampling ratio for the receiver = 4x
   OSR_8x  : constant := 2#00111#; -- oversampling ratio for the receiver = 8x
   OSR_16x : constant := 2#01111#; -- oversampling ratio for the receiver = 16x
   OSR_32x : constant := 2#11111#; -- oversampling ratio for the receiver = 32x

   type UARTx_C4_Type is record
      BRFA  : Bits_5  := OSR_16x; -- Baud Rate Fine Adjust
      M10   : Boolean := False;   -- 10-bit Mode select
      MAEN2 : Boolean := False;   -- Match Address Mode Enable 2
      MAEN1 : Boolean := False;   -- Match Address Mode Enable 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C4_Type use record
      BRFA  at 0 range 0 .. 4;
      M10   at 0 range 5 .. 5;
      MAEN2 at 0 range 6 .. 6;
      MAEN1 at 0 range 7 .. 7;
   end record;

   -- 56.3.12 UART Control Register 5 (UARTx_C5)

   type UARTx_C5_Type is record
      Reserved1 : Bits_4  := 0;
      Reserved2 : Bits_1  := 0;
      RDMAS     : Boolean := False; -- Receiver Full DMA Select
      Reserved3 : Bits_1  := 0;
      TDMAS     : Boolean := False; -- Transmitter DMA Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C5_Type use record
      Reserved1 at 0 range 0 .. 3;
      Reserved2 at 0 range 4 .. 4;
      RDMAS     at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 6;
      TDMAS     at 0 range 7 .. 7;
   end record;

   -- 56.3.13 UART Extended Data Register (UARTx_ED)

   type UARTx_ED_Type is record
      Reserved : Bits_6;
      PARITYE  : Boolean; -- The current received dataword contained in D and C3[R8] was received with a parity error.
      NOISY    : Boolean; -- The current received dataword contained in D and C3[R8] was received with noise.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_ED_Type use record
      Reserved at 0 range 0 .. 5;
      PARITYE  at 0 range 6 .. 6;
      NOISY    at 0 range 7 .. 7;
   end record;

   -- 56.3.14 UART Modem Register (UARTx_MODEM)

   TXRTSPOL_LO : constant := 0; -- Transmitter RTS is active low.
   TXRTSPOL_HI : constant := 1; -- Transmitter RTS is active high.

   type UARTx_MODEM_Type is record
      TXCTSE   : Boolean := False;       -- Transmitter clear-to-send enable
      TXRTSE   : Boolean := False;       -- Transmitter request-to-send enable
      TXRTSPOL : Bits_1  := TXRTSPOL_LO; -- Transmitter request-to-send polarity
      RXRTSE   : Boolean := False;       -- Receiver request-to-send enable
      Reserved : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_MODEM_Type use record
      TXCTSE   at 0 range 0 .. 0;
      TXRTSE   at 0 range 1 .. 1;
      TXRTSPOL at 0 range 2 .. 2;
      RXRTSE   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   -- 56.3.15 UART Infrared Register (UARTx_IR)

   TNP_3DIV16 : constant := 2#00#; -- 3/16.
   TNP_1DIV16 : constant := 2#01#; -- 1/16.
   TNP_1DIV32 : constant := 2#10#; -- 1/32.
   TNP_1DIV4  : constant := 2#11#; -- 1/4.

   type UARTx_IR_Type is record
      TNP      : Bits_2  := TNP_3DIV16; -- Transmitter narrow pulse
      IREN     : Boolean := False;      -- Infrared enable
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_IR_Type use record
      TNP      at 0 range 0 .. 1;
      IREN     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 56.3.16 UART FIFO Parameters (UARTx_PFIFO)

   RXFIFOSIZE_1    : constant := 2#000#; -- Receive FIFO/Buffer depth = 1 dataword.
   RXFIFOSIZE_4    : constant := 2#001#; -- Receive FIFO/Buffer depth = 4 datawords.
   RXFIFOSIZE_8    : constant := 2#010#; -- Receive FIFO/Buffer depth = 8 datawords.
   RXFIFOSIZE_16   : constant := 2#011#; -- Receive FIFO/Buffer depth = 16 datawords.
   RXFIFOSIZE_32   : constant := 2#100#; -- Receive FIFO/Buffer depth = 32 datawords.
   RXFIFOSIZE_64   : constant := 2#101#; -- Receive FIFO/Buffer depth = 64 datawords.
   RXFIFOSIZE_128  : constant := 2#110#; -- Receive FIFO/Buffer depth = 128 datawords.
   RXFIFOSIZE_RSVD : constant := 2#111#; -- Reserved.

   TXFIFOSIZE_1    : constant := 2#000#; -- Transmit FIFO/Buffer depth = 1 dataword.
   TXFIFOSIZE_4    : constant := 2#001#; -- Transmit FIFO/Buffer depth = 4 datawords.
   TXFIFOSIZE_8    : constant := 2#010#; -- Transmit FIFO/Buffer depth = 8 datawords.
   TXFIFOSIZE_16   : constant := 2#011#; -- Transmit FIFO/Buffer depth = 16 datawords.
   TXFIFOSIZE_32   : constant := 2#100#; -- Transmit FIFO/Buffer depth = 32 datawords.
   TXFIFOSIZE_64   : constant := 2#101#; -- Transmit FIFO/Buffer depth = 64 datawords.
   TXFIFOSIZE_128  : constant := 2#110#; -- Transmit FIFO/Buffer depth = 128 datawords.
   TXFIFOSIZE_RSVD : constant := 2#111#; -- Reserved.

   type UARTx_PFIFO_Type is record
      RXFIFOSIZE : Bits_3  := RXFIFOSIZE_1; -- Receive FIFO. Buffer Depth
      RXFE       : Boolean := False;        -- Receive FIFO Enable
      TXFIFOSIZE : Bits_3  := TXFIFOSIZE_1; -- Transmit FIFO. Buffer Depth
      TXFE       : Boolean := False;        -- Transmit FIFO Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_PFIFO_Type use record
      RXFIFOSIZE at 0 range 0 .. 2;
      RXFE       at 0 range 3 .. 3;
      TXFIFOSIZE at 0 range 4 .. 6;
      TXFE       at 0 range 7 .. 7;
   end record;

   -- 56.3.17 UART FIFO Control Register (UARTx_CFIFO)

   type UARTx_CFIFO_Type is record
      RXUFE    : Boolean := False; -- Receive FIFO Underflow Interrupt Enable
      TXOFE    : Boolean := False; -- Transmit FIFO Overflow Interrupt Enable
      RXOFE    : Boolean := False; -- Receive FIFO Overflow Interrupt Enable
      Reserved : Bits_3  := 0;
      RXFLUSH  : Boolean := False; -- Receive FIFO/Buffer Flush
      TXFLUSH  : Boolean := False; -- Transmit FIFO/Buffer Flush
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_CFIFO_Type use record
      RXUFE    at 0 range 0 .. 0;
      TXOFE    at 0 range 1 .. 1;
      RXOFE    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 5;
      RXFLUSH  at 0 range 6 .. 6;
      TXFLUSH  at 0 range 7 .. 7;
   end record;

   -- 56.3.18 UART FIFO Status Register (UARTx_SFIFO)

   type UARTx_SFIFO_Type is record
      RXUF     : Boolean := False; -- Receiver Buffer Underflow Flag
      TXOF     : Boolean := False; -- Transmitter Buffer Overflow Flag
      RXOF     : Boolean := False; -- Receiver Buffer Overflow Flag
      Reserved : Bits_3  := 0;
      RXEMPT   : Boolean := True;  -- Receive Buffer/FIFO Empty
      TXEMPT   : Boolean := True;  -- Transmit Buffer/FIFO Empty
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_SFIFO_Type use record
      RXUF     at 0 range 0 .. 0;
      TXOF     at 0 range 1 .. 1;
      RXOF     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 5;
      RXEMPT   at 0 range 6 .. 6;
      TXEMPT   at 0 range 7 .. 7;
   end record;

   -- 56.3.19 UART FIFO Transmit Watermark (UARTx_TWFIFO)

   type UARTx_TWFIFO_Type is record
      TXWATER : Unsigned_8 := 0; -- Transmit Watermark
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_TWFIFO_Type use record
      TXWATER at 0 range 0 .. 7;
   end record;

   -- 56.3.20 UART FIFO Transmit Count (UARTx_TCFIFO)

   type UARTx_TCFIFO_Type is record
      TXCOUNT : Unsigned_8; -- Transmit Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_TCFIFO_Type use record
      TXCOUNT at 0 range 0 .. 7;
   end record;

   -- 56.3.21 UART FIFO Receive Watermark (UARTx_RWFIFO)

   type UARTx_RWFIFO_Type is record
      RXWATER : Unsigned_8 := 1; -- Receive Watermark
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_RWFIFO_Type use record
      RXWATER at 0 range 0 .. 7;
   end record;

   -- 56.3.22 UART FIFO Receive Count (UARTx_RCFIFO)

   type UARTx_RCFIFO_Type is record
      RXCOUNT : Unsigned_8; -- Receive Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_RCFIFO_Type use record
      RXCOUNT at 0 range 0 .. 7;
   end record;

   -- 56.3 Memory map and registers

   type UART_Type is record
      BDH    : UARTx_BDH_Type    with Volatile_Full_Access => True;
      BDL    : UARTx_BDL_Type    with Volatile_Full_Access => True;
      C1     : UARTx_C1_Type     with Volatile_Full_Access => True;
      C2     : UARTx_C2_Type     with Volatile_Full_Access => True;
      S1     : UARTx_S1_Type     with Volatile_Full_Access => True;
      S2     : UARTx_S2_Type     with Volatile_Full_Access => True;
      C3     : UARTx_C3_Type     with Volatile_Full_Access => True;
      D      : UARTx_D_Type      with Volatile_Full_Access => True;
      MA1    : UARTx_MA1_Type    with Volatile_Full_Access => True;
      MA2    : UARTx_MA2_Type    with Volatile_Full_Access => True;
      C4     : UARTx_C4_Type     with Volatile_Full_Access => True;
      C5     : UARTx_C5_Type     with Volatile_Full_Access => True;
      ED     : UARTx_ED_Type     with Volatile_Full_Access => True;
      MODEM  : UARTx_MODEM_Type  with Volatile_Full_Access => True;
      IR     : UARTx_IR_Type     with Volatile_Full_Access => True;
      PFIFO  : UARTx_PFIFO_Type  with Volatile_Full_Access => True;
      CFIFO  : UARTx_CFIFO_Type  with Volatile_Full_Access => True;
      SFIFO  : UARTx_SFIFO_Type  with Volatile_Full_Access => True;
      TWFIFO : UARTx_TWFIFO_Type with Volatile_Full_Access => True;
      TCFIFO : UARTx_TCFIFO_Type with Volatile_Full_Access => True;
      RWFIFO : UARTx_RWFIFO_Type with Volatile_Full_Access => True;
      RCFIFO : UARTx_RCFIFO_Type with Volatile_Full_Access => True;
   end record
      with Size => 16#17# * 8;
   for UART_Type use record
      BDH    at 16#00# range 0 .. 7;
      BDL    at 16#01# range 0 .. 7;
      C1     at 16#02# range 0 .. 7;
      C2     at 16#03# range 0 .. 7;
      S1     at 16#04# range 0 .. 7;
      S2     at 16#05# range 0 .. 7;
      C3     at 16#06# range 0 .. 7;
      D      at 16#07# range 0 .. 7;
      MA1    at 16#08# range 0 .. 7;
      MA2    at 16#09# range 0 .. 7;
      C4     at 16#0A# range 0 .. 7;
      C5     at 16#0B# range 0 .. 7;
      ED     at 16#0C# range 0 .. 7;
      MODEM  at 16#0D# range 0 .. 7;
      IR     at 16#0E# range 0 .. 7;
      PFIFO  at 16#10# range 0 .. 7;
      CFIFO  at 16#11# range 0 .. 7;
      SFIFO  at 16#12# range 0 .. 7;
      TWFIFO at 16#13# range 0 .. 7;
      TCFIFO at 16#14# range 0 .. 7;
      RWFIFO at 16#15# range 0 .. 7;
      RCFIFO at 16#16# range 0 .. 7;
   end record;

   UART0 : aliased UART_Type
      with Address    => System'To_Address (16#4006_A000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   UART1 : aliased UART_Type
      with Address    => System'To_Address (16#4006_B000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   UART2 : aliased UART_Type
      with Address    => System'To_Address (16#4006_C000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   UART3 : aliased UART_Type
      with Address    => System'To_Address (16#4006_D000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   UART4 : aliased UART_Type
      with Address    => System'To_Address (16#400E_A000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   UART5 : aliased UART_Type
      with Address    => System'To_Address (16#400E_B000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 59 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   GPIO_BASEADDRESS : constant := 16#400F_F000#;

   -- 59.2.1 Port Data Output Register (GPIOx_PDOR)
   -- 59.2.2 Port Set Output Register (GPIOx_PSOR)
   -- 59.2.3 Port Clear Output Register (GPIOx_PCOR)
   -- 59.2.4 Port Toggle Output Register (GPIOx_PTOR)
   -- 59.2.5 Port Data Input Register (GPIOx_PDIR)
   -- 59.2.6 Port Data Direction Register (GPIOx_PDDR)

   type GPIO_PORT_Type is record
      PDOR : Bitmap_32 with Volatile_Full_Access => True;
      PSOR : Bitmap_32 with Volatile_Full_Access => True;
      PCOR : Bitmap_32 with Volatile_Full_Access => True;
      PTOR : Bitmap_32 with Volatile_Full_Access => True;
      PDIR : Bitmap_32 with Volatile_Full_Access => True;
      PDDR : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 16#18# * 8;
   for GPIO_PORT_Type use record
      PDOR at 16#00# range 0 .. 31;
      PSOR at 16#04# range 0 .. 31;
      PCOR at 16#08# range 0 .. 31;
      PTOR at 16#0C# range 0 .. 31;
      PDIR at 16#10# range 0 .. 31;
      PDDR at 16#14# range 0 .. 31;
   end record;

   -- 59.2 Memory map and register definition

   GPIOA : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#040#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#080#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#0C0#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOF : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#140#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end K61;
