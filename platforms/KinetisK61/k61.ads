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

   CLKS_FLLPLLCS : constant := 2#00#; -- Encoding 0 — Output of FLL or PLL is selected (depends on PLLS control bit).
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

   MCG_C1_ADDRESS : constant := 16#4006_4000#;

   MCG_C1 : aliased MCG_C1_Type
      with Address              => System'To_Address (MCG_C1_ADDRESS),
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

   MCG_C2_ADDRESS : constant := 16#4006_4001#;

   MCG_C2 : aliased MCG_C2_Type
      with Address              => System'To_Address (MCG_C2_ADDRESS),
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

   MCG_C3_ADDRESS : constant := 16#4006_4002#;

   MCG_C3 : aliased MCG_C3_Type
      with Address              => System'To_Address (MCG_C3_ADDRESS),
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

   MCG_C4_ADDRESS : constant := 16#4006_4003#;

   MCG_C4 : aliased MCG_C4_Type
      with Address              => System'To_Address (MCG_C4_ADDRESS),
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

   PLLST_FLL : constant := 0; -- Source of PLLS clock is FLL clock.
   PLLST_PLL : constant := 1; -- Source of PLLS clock is PLL output clock.

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

   MCG_S_ADDRESS : constant := 16#4006_4006#;

   MCG_S : aliased MCG_S_Type
      with Address              => System'To_Address (MCG_S_ADDRESS),
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

   MCG_SC_ADDRESS : constant := 16#4006_4008#;

   MCG_SC : aliased MCG_SC_Type
      with Address              => System'To_Address (MCG_SC_ADDRESS),
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

   MCG_C7_ADDRESS : constant := 16#4006_400C#;

   MCG_C7 : aliased MCG_C7_Type
      with Address              => System'To_Address (MCG_C7_ADDRESS),
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

   ----------------------------------------------------------------------------
   -- Chapter 59 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   GPIO_BASEADDRESS : constant := 16#400F_F000#;

   type GPIO_PORT is record
      GPIO_PDOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PSOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PCOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PTOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDIR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDDR : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 16#18# * 8;
   for GPIO_PORT use record
      GPIO_PDOR at 16#00# range 0 .. 31;
      GPIO_PSOR at 16#04# range 0 .. 31;
      GPIO_PCOR at 16#08# range 0 .. 31;
      GPIO_PTOR at 16#0C# range 0 .. 31;
      GPIO_PDIR at 16#10# range 0 .. 31;
      GPIO_PDDR at 16#14# range 0 .. 31;
   end record;

   GPIOA : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#000#),
           Import     => True,
           Convention => Ada;
   GPIOB : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#040#),
           Import     => True,
           Convention => Ada;
   GPIOC : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#080#),
           Import     => True,
           Convention => Ada;
   GPIOD : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#0C0#),
           Import     => True,
           Convention => Ada;
   GPIOE : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#100#),
           Import     => True,
           Convention => Ada;
   GPIOF : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#140#),
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end K61;
