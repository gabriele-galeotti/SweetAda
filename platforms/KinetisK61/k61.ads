-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ k61.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
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
   -- Chapter 11 Port Control and Interrupts (PORT)
   ----------------------------------------------------------------------------

   PORT_PCR_BASEADDRESS : constant := 16#4004_9000#;

   -- 11.5.1 Pin Control Register n (PORTx_PCRn)

   PS_PULLDOWN : constant := 0; -- Internal pulldown resistor is enabled on the corresponding pin, if the corresponding PE field is set.
   PS_PULLUP   : constant := 1; -- Internal pullup resistor is enabled on the corresponding pin, if the corresponding PE field is set.

   type PORT_PCR_Pin_Type is record
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
   for PORT_PCR_Pin_Type use record
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

   type PORT_PCR_Pins_Type is array (0 .. 31) of PORT_PCR_Pin_Type
      with Pack => True;

   type PORT_PCR_Type is record
      Pins  : PORT_PCR_Pins_Type;
      GPCLR : Unsigned_32        with Volatile_Full_Access => True;
      GPCHR : Unsigned_32        with Volatile_Full_Access => True;
      ISFR  : Unsigned_32        with Volatile_Full_Access => True;
   end record
      with Size => 16#A4# * 8;
   for PORT_PCR_Type use record
      Pins  at 16#00# range 0 .. 32 * 32 - 1;
      GPCLR at 16#80# range 0 .. 31;
      GPCHR at 16#84# range 0 .. 31;
      ISFR  at 16#A0# range 0 .. 31;
   end record;

   PORTA_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#0000#),
           Import     => True,
           Convention => Ada;
   PORTB_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#1000#),
           Import     => True,
           Convention => Ada;
   PORTC_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#2000#),
           Import     => True,
           Convention => Ada;
   PORTD_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#3000#),
           Import     => True,
           Convention => Ada;
   PORTE_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#4000#),
           Import     => True,
           Convention => Ada;
   PORTF_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#5000#),
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
   -- 12.2.5 System Options Register 5 (SIM_SOPT5)
   -- 12.2.6 System Options Register 6 (SIM_SOPT6)
   -- 12.2.7 System Options Register 7 (SIM_SOPT7)
   -- 12.2.8 System Device Identification Register (SIM_SDID)

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
      LPTIMER      : Boolean;      -- LPTMR clock gate control
      Reserved1    : Bits_1  := 1;
      DRYICE       : Boolean;      -- Dryice clock gate control
      DRYICESECREG : Boolean;      -- Dryice secure storage clock gate control
      Reserved2    : Bits_1  := 0;
      TSI          : Boolean;      -- TSI clock gate control
      Reserved3    : Bits_1  := 0;
      Reserved4    : Bits_1  := 1;
      Reserved5    : Bits_1  := 1;
      PORTA        : Boolean;      -- PORTA clock gate control
      PORTB        : Boolean;      -- PORTB clock gate control
      PORTC        : Boolean;      -- PORTC clock gate control
      PORTD        : Boolean;      -- PORTD clock gate control
      PORTE        : Boolean;      -- PORTE clock gate control
      PORTF        : Boolean;      -- PORTF clock gate control
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
   -- 12.2.15 System Clock Gating Control Register 7 (SIM_SCGC7)

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
   -- 12.2.18 Flash Configuration Register 1 (SIM_FCFG1)
   -- 12.2.19 Flash Configuration Register 2 (SIM_FCFG2)
   -- 12.2.20 Unique Identification Register High (SIM_UIDH)
   -- 12.2.21 Unique Identification Register Mid-High (SIM_UIDMH)
   -- 12.2.22 Unique Identification Register Mid Low (SIM_UIDML)
   -- 12.2.23 Unique Identification Register Low (SIM_UIDL)
   -- 12.2.24 System Clock Divider Register 4 (SIM_CLKDIV4)
   -- 12.2.25 Misc Control Register (SIM_MCR)

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

   PRDIV0_DIV1  : constant := 2#00000#; -- Divide Factor 1
   PRDIV0_DIV2  : constant := 2#00001#; -- Divide Factor 2
   PRDIV0_DIV3  : constant := 2#00010#; -- Divide Factor 3
   PRDIV0_DIV4  : constant := 2#00011#; -- Divide Factor 4
   PRDIV0_DIV5  : constant := 2#00100#; -- Divide Factor 5
   PRDIV0_DIV6  : constant := 2#00101#; -- Divide Factor 6
   PRDIV0_DIV7  : constant := 2#00110#; -- Divide Factor 7
   PRDIV0_DIV8  : constant := 2#00111#; -- Divide Factor 8

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

   PRDIV1_DIV1  : constant := 2#00000#; -- Divide Factor 1
   PRDIV1_DIV2  : constant := 2#00001#; -- Divide Factor 2
   PRDIV1_DIV3  : constant := 2#00010#; -- Divide Factor 3
   PRDIV1_DIV4  : constant := 2#00011#; -- Divide Factor 4
   PRDIV1_DIV5  : constant := 2#00100#; -- Divide Factor 5
   PRDIV1_DIV6  : constant := 2#00101#; -- Divide Factor 6
   PRDIV1_DIV7  : constant := 2#00110#; -- Divide Factor 7
   PRDIV1_DIV8  : constant := 2#00111#; -- Divide Factor 8

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
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#10#),
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

   DDR_CONTROLLER_BASEADDRESS : constant := 16#400A_E000#;

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
      with Size => 32;
   for DDR_CR00_Type use record
      START     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      DDRCLS    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      VERSION   at 0 range 16 .. 31;
   end record;

   DDR_CR00 : aliased DDR_CR00_Type
      with Address              => System'To_Address (DDR_CONTROLLER_BASEADDRESS + 16#00#),
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
      with Size => 32;
   for DDR_CR01_Type use record
      MAXROW    at 0 range  0 ..  4;
      Reserved1 at 0 range  5 ..  7;
      MAXCOL    at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
      CSMAX     at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 31;
   end record;

   DDR_CR01 : aliased DDR_CR01_Type
      with Address              => System'To_Address (DDR_CONTROLLER_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.3 DDR Control Register 2 (DDR_CR02)

   type DDR_CR02_Type is record
      TINIT    : Bits_24 := 0; -- Time Initialization
      INITAREF : Bits_4  := 0; -- Initialization Auto-Refresh
      Reserved : Bits_4  := 0;
   end record
      with Size => 32;
   for DDR_CR02_Type use record
      TINIT    at 0 range  0 .. 23;
      INITAREF at 0 range 24 .. 27;
      Reserved at 0 range 28 .. 31;
   end record;

   DDR_CR02 : aliased DDR_CR02_Type
      with Address              => System'To_Address (DDR_CONTROLLER_BASEADDRESS + 16#08#),
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
      with Size => 32;
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
      with Address              => System'To_Address (DDR_CONTROLLER_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.4.5 DDR Control Register 4 (DDR_CR04)
   -- 34.4.6 DDR Control Register 5 (DDR_CR05)
   -- 34.4.7 DDR Control Register 6 (DDR_CR06)
   -- 34.4.8 DDR Control Register 7 (DDR_CR07)
   -- 34.4.9 DDR Control Register 8 (DDR_CR08)
   -- 34.4.10 DDR Control Register 9 (DDR_CR09)
   -- 34.4.11 DDR Control Register 10 (DDR_CR10)
   -- 34.4.12 DDR Control Register 11 (DDR_CR11)
   -- 34.4.13 DDR Control Register 12 (DDR_CR12)
   -- 34.4.14 DDR Control Register 13 (DDR_CR13)
   -- 34.4.15 DDR Control Register 14 (DDR_CR14)
   -- 34.4.16 DDR Control Register 15 (DDR_CR15)
   -- 34.4.17 DDR Control Register 16 (DDR_CR16)
   -- 34.4.18 DDR Control Register 17 (DDR_CR17)
   -- 34.4.19 DDR Control Register 18 (DDR_CR18)
   -- 34.4.20 DDR Control Register 19 (DDR_CR19)
   -- 34.4.21 DDR Control Register 20 (DDR_CR20)
   -- 34.4.22 DDR Control Register 21 (DDR_CR21)
   -- 34.4.23 DDR Control Register 22 (DDR_CR22)
   -- 34.4.24 DDR Control Register 23 (DDR_CR23)
   -- 34.4.25 DDR Control Register 24 (DDR_CR24)
   -- 34.4.26 DDR Control Register 25 (DDR_CR25)
   -- 34.4.27 DDR Control Register 26 (DDR_CR26)
   -- 34.4.28 DDR Control Register 27 (DDR_CR27)
   -- 34.4.29 DDR Control Register 28 (DDR_CR28)
   -- 34.4.30 DDR Control Register 29 (DDR_CR29)
   -- 34.4.31 DDR Control Register 30 (DDR_CR30)
   -- 34.4.32 DDR Control Register 31 (DDR_CR31)
   -- 34.4.33 DDR Control Register 32 (DDR_CR32)
   -- 34.4.34 DDR Control Register 33 (DDR_CR33)
   -- 34.4.35 DDR Control Register 34 (DDR_CR34)
   -- 34.4.36 DDR Control Register 35 (DDR_CR35)
   -- 34.4.37 DDR Control Register 36 (DDR_CR36)
   -- 34.4.38 DDR Control Register 37 (DDR_CR37)
   -- 34.4.39 DDR Control Register 38 (DDR_CR38)
   -- 34.4.40 DDR Control Register 39 (DDR_CR39)
   -- 34.4.41 DDR Control Register 40 (DDR_CR40)
   -- 34.4.42 DDR Control Register 41 (DDR_CR41)
   -- 34.4.43 DDR Control Register 42 (DDR_CR42)
   -- 34.4.44 DDR Control Register 43 (DDR_CR43)
   -- 34.4.45 DDR Control Register 44 (DDR_CR44)
   -- 34.4.46 DDR Control Register 45 (DDR_CR45)
   -- 34.4.47 DDR Control Register 46 (DDR_CR46)
   -- 34.4.48 DDR Control Register 47 (DDR_CR47)
   -- 34.4.49 DDR Control Register 48 (DDR_CR48)
   -- 34.4.50 DDR Control Register 49 (DDR_CR49)
   -- 34.4.51 DDR Control Register 50 (DDR_CR50)
   -- 34.4.52 DDR Control Register 51 (DDR_CR51)
   -- 34.4.53 DDR Control Register 52 (DDR_CR52)
   -- 34.4.54 DDR Control Register 53 (DDR_CR53)
   -- 34.4.55 DDR Control Register 54 (DDR_CR54)
   -- 34.4.56 DDR Control Register 55 (DDR_CR55)
   -- 34.4.57 DDR Control Register 56 (DDR_CR56)
   -- 34.4.58 DDR Control Register 57 (DDR_CR57)
   -- 34.4.59 DDR Control Register 58 (DDR_CR58)
   -- 34.4.60 DDR Control Register 59 (DDR_CR59)
   -- 34.4.61 DDR Control Register 60 (DDR_CR60)
   -- 34.4.62 DDR Control Register 61 (DDR_CR61)
   -- 34.4.63 DDR Control Register 62 (DDR_CR62)
   -- 34.4.64 DDR Control Register 63 (DDR_CR63)
   -- 34.4.65 RCR Control Register (DDR_RCR)
   -- 34.4.66 I/O Pad Control Register (DDR_PAD_CTRL)

   ----------------------------------------------------------------------------
   -- Chapter 59 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   GPIO_BASEADDRESS : constant := 16#400F_F000#;

   type GPIO_PORT_Type is record
      GPIO_PDOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PSOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PCOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PTOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDIR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDDR : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 16#18# * 8;
   for GPIO_PORT_Type use record
      GPIO_PDOR at 16#00# range 0 .. 31;
      GPIO_PSOR at 16#04# range 0 .. 31;
      GPIO_PCOR at 16#08# range 0 .. 31;
      GPIO_PTOR at 16#0C# range 0 .. 31;
      GPIO_PDIR at 16#10# range 0 .. 31;
      GPIO_PDDR at 16#14# range 0 .. 31;
   end record;

   GPIOA : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#000#),
           Import     => True,
           Convention => Ada;
   GPIOB : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#040#),
           Import     => True,
           Convention => Ada;
   GPIOC : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#080#),
           Import     => True,
           Convention => Ada;
   GPIOD : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#0C0#),
           Import     => True,
           Convention => Ada;
   GPIOE : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#100#),
           Import     => True,
           Convention => Ada;
   GPIOF : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#140#),
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end K61;
