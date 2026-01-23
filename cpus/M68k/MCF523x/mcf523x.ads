-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf523x.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package MCF523x
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
   -- MCF5235 Reference Manual
   -- Document Number: MCF5235RM Rev. 2 07/2006
   ----------------------------------------------------------------------------

   IPSBAR_BASEADDRESS : constant := 16#4000_0000#;

   ----------------------------------------------------------------------------
   -- Chapter 7 Clock Module
   ----------------------------------------------------------------------------

   -- 7.3.1.1 Synthesizer Control Register (SYNCR)

   DEPTH_0 : constant := 2#00#; -- Modulation Depth (% of fsys/2) = 0
   DEPTH_1 : constant := 2#01#; -- Modulation Depth (% of fsys/2) = 1.0 ± 0.2
   DEPTH_2 : constant := 2#10#; -- Modulation Depth (% of fsys/2) = 2.0 ± 0.2

   RATE_DIV80 : constant := 2#0#; -- Fm = Fref / 80
   RATE_DIV40 : constant := 2#1#; -- Fm = Fref / 40

   RFD_DIV1   : constant := 2#000#; -- Reduced frequency divider field
   RFD_DIV2   : constant := 2#001#;
   RFD_DIV4   : constant := 2#010#;
   RFD_DIV8   : constant := 2#011#;
   RFD_DIV16  : constant := 2#100#;
   RFD_DIV32  : constant := 2#101#;
   RFD_DIV64  : constant := 2#110#;
   RFD_DIV128 : constant := 2#111#;

   MFD_4X  : constant := 2#000#; -- Multiplication factor divider
   MFD_6X  : constant := 2#001#;
   MFD_8X  : constant := 2#010#;
   MFD_10X : constant := 2#011#;
   MFD_12X : constant := 2#100#;
   MFD_14X : constant := 2#101#;
   MFD_16X : constant := 2#110#;
   MFD_18X : constant := 2#111#;

   type SYNCR_Type is record
      EXP       : Bits_10 := 0;          -- Expected difference value
      DEPTH     : Bits_2  := DEPTH_0;    -- Frequency modulation depth and enable
      RATE      : Bits_1  := RATE_DIV80; -- Modulation rate
      LOCIRQ    : Boolean := False;      -- Loss-of-clock interrupt request
      LOLIRQ    : Boolean := False;      -- Loss-of-lock interrupt request
      DISCLK    : Boolean := False;      -- Disable CLKOUT
      LOCRE     : Boolean := False;      -- Loss-of-clock reset enable
      LOLRE     : Boolean := False;      -- Loss-of-lock reset enable
      LOCEN     : Boolean := False;      -- Enables the loss-of-clock function
      RFD       : Bits_3  := RFD_DIV4;   -- Reduced frequency divider field
      Reserved1 : Bits_2  := 0;
      MFD       : Bits_3  := MFD_6X;     -- Multiplication factor divider
      Reserved2 : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYNCR_Type use record
      EXP       at 0 range  0 ..  9;
      DEPTH     at 0 range 10 .. 11;
      RATE      at 0 range 12 .. 12;
      LOCIRQ    at 0 range 13 .. 13;
      LOLIRQ    at 0 range 14 .. 14;
      DISCLK    at 0 range 15 .. 15;
      LOCRE     at 0 range 16 .. 16;
      LOLRE     at 0 range 17 .. 17;
      LOCEN     at 0 range 18 .. 18;
      RFD       at 0 range 19 .. 21;
      Reserved1 at 0 range 22 .. 23;
      MFD       at 0 range 24 .. 26;
      Reserved2 at 0 range 27 .. 31;
   end record;

   SYNCR : aliased SYNCR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0012_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function To_U32
      (Value : SYNCR_Type)
      return Unsigned_32
      with Inline => True;
   function To_SYNCR
      (Value : Unsigned_32)
      return SYNCR_Type
      with Inline => True;

   -- 7.3.1.2 Synthesizer Status Register (SYNSR)

   PLLREF_EXT  : constant := 0; -- External clock reference
   PLLREF_XTAL : constant := 1; -- Crystal clock reference

   PLLSEL_11  : constant := 0; -- 1:1 PLL mode
   PLLSEL_PLL : constant := 1; -- Normal PLL mode (see Table 7-7)

   PLLMODE_EXT : constant := 0; -- External clock mode
   PLLMODE_PLL : constant := 1; -- PLL clock mode

   type SYNSR_Type is record
      CALPASS  : Boolean := False;       -- Calibration passed
      CALDONE  : Boolean := False;       -- Calibration complete
      LOCF     : Boolean := False;       -- Loss-of-clock flag
      LOCK     : Boolean := False;       -- PLL lock status bit
      LOCKS    : Boolean := False;       -- Sticky indication of PLL lock status
      PLLREF   : Bits_1  := PLLREF_EXT;  -- PLL clock reference source
      PLLSEL   : Bits_1  := PLLSEL_11;   -- PLL mode select
      PLLMODE  : Bits_1  := PLLMODE_EXT; -- Clock mode
      LOC      : Boolean := False;       -- Loss-of-clock status
      LOLF     : Boolean := False;       -- Loss-of-lock flag
      Reserved : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYNSR_Type use record
      CALPASS  at 0 range  0 ..  0;
      CALDONE  at 0 range  1 ..  1;
      LOCF     at 0 range  2 ..  2;
      LOCK     at 0 range  3 ..  3;
      LOCKS    at 0 range  4 ..  4;
      PLLREF   at 0 range  5 ..  5;
      PLLSEL   at 0 range  6 ..  6;
      PLLMODE  at 0 range  7 ..  7;
      LOC      at 0 range  8 ..  8;
      LOLF     at 0 range  9 ..  9;
      Reserved at 0 range 10 .. 31;
   end record;

   SYNSR : aliased SYNSR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0012_0004#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function To_U32
      (Value : SYNSR_Type)
      return Unsigned_32
      with Inline => True;
   function To_SYNSR
      (Value : Unsigned_32)
      return SYNSR_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Chapter 8 Power Management
   ----------------------------------------------------------------------------

   -- 8.2.1.1 Low-Power Interrupt Control Register (LPICR)

   XLPM_IPL_ANY : constant := 2#000#; -- Any interrupt request exits low-power mode
   XLPM_IPL_2_7 : constant := 2#001#; -- Interrupt request levels [2-7] exit low-power mode
   XLPM_IPL_3_7 : constant := 2#010#; -- Interrupt request levels [3-7] exit low-power mode
   XLPM_IPL_4_7 : constant := 2#011#; -- Interrupt request levels [4-7] exit low-power mode
   XLPM_IPL_5_7 : constant := 2#100#; -- Interrupt request levels [5-7] exit low-power mode
   XLPM_IPL_6_7 : constant := 2#101#; -- Interrupt request levels [6-7] exit low-power mode
   XLPM_IPL_7   : constant := 2#110#; -- Interrupt request level [7] exits low-power mode
   XLPM_IPL_7_2 : constant := 2#111#; -- Interrupt request level [7] exits low-power mode

   type LPICR_Type is record
      Reserved : Bits_4  := 0;
      XLPM_IPL : Bits_3  := XLPM_IPL_ANY; -- Exit low-power mode interrupt priority level.
      ENBSTOP  : Boolean := False;        -- Enable low-power stop mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LPICR_Type use record
      Reserved at 0 range 0 .. 3;
      XLPM_IPL at 0 range 4 .. 6;
      ENBSTOP  at 0 range 7 .. 7;
   end record;

   LPICR : aliased LPICR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0012#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.1.2 Low-Power Control Register (LPCR)

   STPMD_ENABLE  : constant := 0; -- CLKOUT enabled during stop mode.
   STPMD_DISABLE : constant := 1; -- CLKOUT disabled during stop mode.

   LPMD_RUN  : constant := 2#00#; -- RUN
   LPMD_DOZE : constant := 2#01#; -- DOZE
   LPMD_WAIT : constant := 2#10#; -- WAIT
   LPMD_STOP : constant := 2#11#; -- STOP

   type LPCR_Type is record
      Reserved1 : Bits_3 := 0;
      STPMD     : Bits_1 := STPMD_ENABLE; -- CLKOUT stop mode.
      Reserved2 : Bits_2 := 0;
      LPMD      : Bits_2 := LPMD_RUN;     -- Low-power mode select.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LPCR_Type use record
      Reserved1 at 0 range 0 .. 2;
      STPMD     at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 5;
      LPMD      at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Chapter 9 Chip Configuration Module (CCM)
   ----------------------------------------------------------------------------

   -- 9.3.3.3 Chip Identification Register (CIR)

   type CIR_Type is record
      PRN : Bits_6;  -- Part revision number
      PIN : Bits_10; -- Part identification number
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for CIR_Type use record
      PRN at 0 range 0 ..  5;
      PIN at 0 range 6 .. 15;
   end record;

   CIR : aliased CIR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0011_000A#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 11 System Control Module (SCM)
   ----------------------------------------------------------------------------

   -- 11.2.1.1 Internal Peripheral System Base Address Register (IPSBAR)

   BA_0 : constant := 2#00#; -- internal peripherals @ 0x0000_0000
   BA_1 : constant := 2#01#; -- internal peripherals @ 0x4000_0000 (default)
   BA_2 : constant := 2#10#; -- internal peripherals @ 0x8000_0000
   BA_3 : constant := 2#11#; -- internal peripherals @ 0xC000_0000

   type IPSBAR_Type is record
      V        : Boolean := True; -- Valid
      Reserved : Bits_29 := 0;
      BA       : Bits_2  := BA_1; -- Base address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for IPSBAR_Type use record
      V        at 0 range  0 ..  0;
      Reserved at 0 range  1 .. 29;
      BA       at 0 range 30 .. 31;
   end record;

   IPSBAR : aliased IPSBAR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function To_U32
      (Value : IPSBAR_Type)
      return Unsigned_32
      with Inline => True;
   function To_IPSBAR
      (Value : Unsigned_32)
      return IPSBAR_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Chapter 12 General Purpose I/O Module
   ----------------------------------------------------------------------------

   -- 0x10_0007 (PODR_FECI2C)
   -- 0x10_0017 (PDDR_FECI2C)
   -- 0x10_0027 (PPDSDR_FECI2C)
   -- 0x10_0037 (PCLRR_FECI2C)

   -- 12.3.1.5.6 FEC/I2C Pin Assignment Register (PAR_FECI2C)

   ----------------------------------------------------------------------------
   -- Chapter 13 Interrupt Controller Modules
   ----------------------------------------------------------------------------

   -- NOTE: the line order of interrupt sources is inverted (w.r.t. the manual)
   -- to allow indexing inside a big-endian bitmap by means of an enumerate
   -- subscript

   -- INTC0

   -- interrupt source number = 64 + SOURCE
   type INTC0_Source_Type is (
                                -- SOURCE/MODULE/SOURCE DESCRIPTION
      NOTUSED4,                 -- 63 Not used
      NOTUSED3,                 -- 62 Not used
      NOTUSED2,                 -- 61 Not used
      FLEXCAN1_BOFF_INT,        -- 60 FLEXCAN1 Bus-Off Interrupt
      FLEXCAN1_ERR_INT,         -- 59 FLEXCAN1 Error Interrupt
      FLEXCAN1_BUF15I,          -- 58 FLEXCAN1 Message Buffer 15 Interrupt
      FLEXCAN1_BUF14I,          -- 57 FLEXCAN1 Message Buffer 14 Interrupt
      FLEXCAN1_BUF13I,          -- 56 FLEXCAN1 Message Buffer 13 Interrupt
      FLEXCAN1_BUF12I,          -- 55 FLEXCAN1 Message Buffer 12 Interrupt
      FLEXCAN1_BUF11I,          -- 54 FLEXCAN1 Message Buffer 11 Interrupt
      FLEXCAN1_BUF10I,          -- 53 FLEXCAN1 Message Buffer 10 Interrupt
      FLEXCAN1_BUF9I,           -- 52 FLEXCAN1 Message Buffer 9 Interrupt
      FLEXCAN1_BUF8I,           -- 51 FLEXCAN1 Message Buffer 8 Interrupt
      FLEXCAN1_BUF7I,           -- 50 FLEXCAN1 Message Buffer 7 Interrupt
      FLEXCAN1_BUF6I,           -- 49 FLEXCAN1 Message Buffer 6 Interrupt
      FLEXCAN1_BUF5I,           -- 48 FLEXCAN1 Message Buffer 5 Interrupt
      FLEXCAN1_BUF4I,           -- 47 FLEXCAN1 Message Buffer 4 Interrupt
      FLEXCAN1_BUF3I,           -- 46 FLEXCAN1 Message Buffer 3 Interrupt
      FLEXCAN1_BUF2I,           -- 45 FLEXCAN1 Message Buffer 2 Interrupt
      FLEXCAN1_BUF1I,           -- 44 FLEXCAN1 Message Buffer 1 Interrupt
      FLEXCAN1_BUF0I,           -- 43 FLEXCAN1 Message Buffer 0 Interrupt
      MDHA_MI,                  -- 42 MDHA     MDHA interrupt flag
      SKHA_INT,                 -- 41 SKHA     SKHA interrupt flag
      RNG_EI,                   -- 40 RNG      RNG interrupt flag
      PIT3_PIF,                 -- 39 PIT3     PIT interrupt flag
      PIT2_PIF,                 -- 38 PIT2     PIT interrupt flag
      PIT1_PIF,                 -- 37 PIT1     PIT interrupt flag
      PIT0_PIF,                 -- 36 PIT0     PIT interrupt flag
      FEC_BABR,                 -- 35 FEC      Babbling receive error
      FEC_BABT,                 -- 34 FEC      Babbling transmit error
      FEC_EBERR,                -- 33 FEC      Ethernet bus error
      FEC_GRA,                  -- 32 FEC      Graceful stop complete
      FEC_HBERR,                -- 31 FEC      Heartbeat error
      FEC_LC,                   -- 30 FEC      Late collision
      FEC_MII,                  -- 29 FEC      MII interrupt
      FEC_R_INTB,               -- 28 FEC      Receive buffer interrupt
      FEC_R_INTF,               -- 27 FEC      Receive frame interrupt
      FEC_RL,                   -- 26 FEC      Collision retry limit
      FEC_UN,                   -- 25 FEC      Transmit FIFO underrun
      FEC_X_INTB,               -- 24 FEC      Transmit buffer interrupt
      FEC_X_INTF,               -- 23 FEC      Transmit frame interrupt
      TMR3_INT,                 -- 22 TMR3     TMR3 interrupt
      TMR2_INT,                 -- 21 TMR2     TMR2 interrupt
      TMR1_INT,                 -- 20 TMR1     TMR1 interrupt
      TMR0_INT,                 -- 19 TMR0     TMR0 interrupt
      QSPI_INT,                 -- 18 QSPI     QSPI interrupt
      I2C_IIF,                  -- 17 I2C      I2C interrupt
      NOTUSED1,                 -- 16 Not used
      UART2_INT,                -- 15 UART2    UART2 interrupt
      UART1_INT,                -- 14 UART1    UART1 interrupt
      UART0_INT,                -- 13 UART0    UART0 interrupt
      DMA3_DONE,                -- 12 DMA      DMA Channel 3 transfer complete
      DMA2_DONE,                -- 11 DMA      DMA Channel 2 transfer complete
      DMA1_DONE,                -- 10 DMA      DMA Channel 1 transfer complete
      DMA0_DONE,                -- 9  DMA      DMA Channel 0 transfer complete
      SCM_SWTI,                 -- 8  SCM      Software watchdog timeout
      EPORT_EPF7,               -- 7  EPORT    Edge port flag 7
      EPORT_EPF6,               -- 6  EPORT    Edge port flag 6
      EPORT_EPF5,               -- 5  EPORT    Edge port flag 5
      EPORT_EPF4,               -- 4  EPORT    Edge port flag 4
      EPORT_EPF3,               -- 3  EPORT    Edge port flag 3
      EPORT_EPF2,               -- 2  EPORT    Edge port flag 2
      EPORT_EPF1,               -- 1  EPORT    Edge port flag 1
      NOTIMPLEMENTED            -- 0  Not implemented
      );

   MASKALL0 : constant INTC0_Source_Type := NOTIMPLEMENTED;

   type IPR0_Type is array (INTC0_Source_Type range <>) of Boolean
      with Pack => True;

   IPRH0 : aliased IPR0_Type (INTC0_Source_Type range NOTUSED4 .. FEC_GRA)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0C00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IPRL0 : aliased IPR0_Type (INTC0_Source_Type range FEC_HBERR .. NOTIMPLEMENTED)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0C04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IMR0_Type is array (INTC0_Source_Type range <>) of Boolean
      with Pack => True;

   IMRH0 : aliased IMR0_Type (INTC0_Source_Type range NOTUSED4 .. FEC_GRA)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0C08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IMRL0 : aliased IMR0_Type (INTC0_Source_Type range FEC_HBERR .. MASKALL0)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0C0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- INTC1

   -- interrupt source number = 128 + SOURCE
   type INTC1_Source_Type is (
                                -- SOURCE/MODULE/SOURCE DESCRIPTION
      NOTUSED12,                -- 63 Not used
      NOTUSED11,                -- 62 Not used
      NOTUSED10,                -- 61 Not used
      NOTUSED9,                 -- 60 Not used
      ETPU_TGIF,                -- 59 ETPU     ETPU global interrupt flag
      ETPU_TC31F,               -- 58 ETPU     ETPU channel interrupt flag
      ETPU_TC30F,               -- 57 ETPU     ETPU channel interrupt flag
      ETPU_TC29F,               -- 56 ETPU     ETPU channel interrupt flag
      ETPU_TC28F,               -- 55 ETPU     ETPU channel interrupt flag
      ETPU_TC27F,               -- 54 ETPU     ETPU channel interrupt flag
      ETPU_TC26F,               -- 53 ETPU     ETPU channel interrupt flag
      ETPU_TC25F,               -- 52 ETPU     ETPU channel interrupt flag
      ETPU_TC24F,               -- 51 ETPU     ETPU channel interrupt flag
      ETPU_TC23F,               -- 50 ETPU     ETPU channel interrupt flag
      ETPU_TC22F,               -- 49 ETPU     ETPU channel interrupt flag
      ETPU_TC21F,               -- 48 ETPU     ETPU channel interrupt flag
      ETPU_TC20F,               -- 47 ETPU     ETPU channel interrupt flag
      ETPU_TC19F,               -- 46 ETPU     ETPU channel interrupt flag
      ETPU_TC18F,               -- 45 ETPU     ETPU channel interrupt flag
      ETPU_TC17F,               -- 44 ETPU     ETPU channel interrupt flag
      ETPU_TC16F,               -- 43 ETPU     ETPU channel interrupt flag
      ETPU_TC15F,               -- 42 ETPU     ETPU channel interrupt flag
      ETPU_TC14F,               -- 41 ETPU     ETPU channel interrupt flag
      ETPU_TC13F,               -- 40 ETPU     ETPU channel interrupt flag
      ETPU_TC12F,               -- 39 ETPU     ETPU channel interrupt flag
      ETPU_TC11F,               -- 38 ETPU     ETPU channel interrupt flag
      ETPU_TC10F,               -- 37 ETPU     ETPU channel interrupt flag
      ETPU_TC9F,                -- 36 ETPU     ETPU channel interrupt flag
      ETPU_TC8F,                -- 35 ETPU     ETPU channel interrupt flag
      ETPU_TC7F,                -- 34 ETPU     ETPU channel interrupt flag
      ETPU_TC6F,                -- 33 ETPU     ETPU channel interrupt flag
      ETPU_TC5F,                -- 32 ETPU     ETPU channel interrupt flag
      ETPU_TC4F,                -- 31 ETPU     ETPU channel interrupt flag
      ETPU_TC3F,                -- 30 ETPU     ETPU channel interrupt flag
      ETPU_TC2F,                -- 29 ETPU     ETPU channel interrupt flag
      ETPU_TC1F,                -- 28 ETPU     ETPU channel interrupt flag
      ETPU_TC0F,                -- 27 ETPU     ETPU channel interrupt flag
      NOTUSED8,                 -- 26 Not used
      FLEXCAN0_BOFF_INT,        -- 25 FLEXCAN0 Bus-Off Interrupt
      FLEXCAN0_ERR_INT,         -- 24 FLEXCAN0 Error Interrupt
      FLEXCAN0_BUF15I,          -- 23 FLEXCAN0 Message Buffer 15 Interrupt
      FLEXCAN0_BUF14I,          -- 22 FLEXCAN0 Message Buffer 14 Interrupt
      FLEXCAN0_BUF13I,          -- 21 FLEXCAN0 Message Buffer 13 Interrupt
      FLEXCAN0_BUF12I,          -- 20 FLEXCAN0 Message Buffer 12 Interrupt
      FLEXCAN0_BUF11I,          -- 19 FLEXCAN0 Message Buffer 11 Interrupt
      FLEXCAN0_BUF10I,          -- 18 FLEXCAN0 Message Buffer 10 Interrupt
      FLEXCAN0_BUF9I,           -- 17 FLEXCAN0 Message Buffer 9 Interrupt
      FLEXCAN0_BUF8I,           -- 16 FLEXCAN0 Message Buffer 8 Interrupt
      FLEXCAN0_BUF7I,           -- 15 FLEXCAN0 Message Buffer 7 Interrupt
      FLEXCAN0_BUF6I,           -- 14 FLEXCAN0 Message Buffer 6 Interrupt
      FLEXCAN0_BUF5I,           -- 13 FLEXCAN0 Message Buffer 5 Interrupt
      FLEXCAN0_BUF4I,           -- 12 FLEXCAN0 Message Buffer 4 Interrupt
      FLEXCAN0_BUF3I,           -- 11 FLEXCAN0 Message Buffer 3 Interrupt
      FLEXCAN0_BUF2I,           -- 10 FLEXCAN0 Message Buffer 2 Interrupt
      FLEXCAN0_BUF1I,           -- 9  FLEXCAN0 Message Buffer 1 Interrupt
      FLEXCAN0_BUF0I,           -- 8  FLEXCAN0 Message Buffer 0 Interrupt
      NOTUSED7,                 -- 7  Not used
      NOTUSED6,                 -- 6  Not used
      NOTUSED5,                 -- 5  Not used
      NOTUSED4,                 -- 4  Not used
      NOTUSED3,                 -- 3  Not used
      NOTUSED2,                 -- 2  Not used
      NOTUSED1,                 -- 1  Not used
      NOTIMPLEMENTED            -- 0  Not implemented
      );

   MASKALL1 : constant INTC1_Source_Type := NOTIMPLEMENTED;

   type IPR1_Type is array (INTC1_Source_Type range <>) of Boolean
      with Pack => True;

   IPRH1 : aliased IPR1_Type (INTC1_Source_Type range NOTUSED12 .. ETPU_TC5F)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0D00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IPRL1 : aliased IPR1_Type (INTC1_Source_Type range ETPU_TC4F .. NOTIMPLEMENTED)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0D04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IMR1_Type is array (INTC1_Source_Type range <>) of Boolean
      with Pack => True;

   IMRH1 : aliased IMR1_Type (INTC1_Source_Type range NOTUSED12 .. ETPU_TC5F)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0D08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IMRL1 : aliased IMR1_Type (INTC1_Source_Type range ETPU_TC4F .. MASKALL1)
      with Address              => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0D0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type ICR_Type is record
      IP       : Bits_3 := 0; -- Interrupt priority.
      IL       : Bits_3 := 0; -- Interrupt level.
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 8,
           Volatile_Full_Access => True;
   for ICR_Type use record
      IP       at 0 range 0 .. 2;
      IL       at 0 range 3 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   -- ICR0/1

   ICR0 : aliased array (0 .. 63) of ICR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0C40#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ICR1 : aliased array (0 .. 63) of ICR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0D40#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function IRQ_Index
      (IRQ       : INTC0_Source_Type;
       VTHandler : Boolean)
      return Natural
      with Inline => True;

   function IRQ_Index
      (IRQ       : INTC1_Source_Type;
       VTHandler : Boolean)
      return Natural
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Chapter 19 Fast Ethernet Controller (FEC)
   ----------------------------------------------------------------------------

   -- 19.2.4.1 Ethernet Interrupt Event Register (EIR)

   type EIR_Type is record
      Reserved : Bits_19 := 0;
      UN       : Boolean := False; -- Transmit FIFO underrun.
      RL       : Boolean := False; -- Collision retry limit.
      LC       : Boolean := False; -- Late collision.
      EBERR    : Boolean := False; -- Ethernet bus error.
      MII      : Boolean := False; -- MII interrupt.
      RXB      : Boolean := False; -- Receive buffer interrupt.
      RXF      : Boolean := False; -- Receive frame interrupt.
      TXB      : Boolean := False; -- Transmit buffer interrupt.
      TXF      : Boolean := False; -- Transmit frame interrupt.
      GRA      : Boolean := False; -- Graceful stop complete.
      BABT     : Boolean := False; -- Babbling transmit error.
      BABR     : Boolean := False; -- Babbling receive error.
      HBERR    : Boolean := False; -- Heartbeat error.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EIR_Type use record
      Reserved at 0 range  0 .. 18;
      UN       at 0 range 19 .. 19;
      RL       at 0 range 20 .. 20;
      LC       at 0 range 21 .. 21;
      EBERR    at 0 range 22 .. 22;
      MII      at 0 range 23 .. 23;
      RXB      at 0 range 24 .. 24;
      RXF      at 0 range 25 .. 25;
      TXB      at 0 range 26 .. 26;
      TXF      at 0 range 27 .. 27;
      GRA      at 0 range 28 .. 28;
      BABT     at 0 range 29 .. 29;
      BABR     at 0 range 30 .. 30;
      HBERR    at 0 range 31 .. 31;
   end record;

   EIR : aliased EIR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_1004#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 19.2.4.2 Interrupt Mask Register (EIMR)

   type EIMR_Type is record
      Reserved : Bits_19 := 0;
      UN       : Boolean := False; -- Transmit FIFO underrun.
      RL       : Boolean := False; -- Collision retry limit.
      LC       : Boolean := False; -- Late collision.
      EBERR    : Boolean := False; -- Ethernet bus error.
      MII      : Boolean := False; -- MII interrupt.
      RXB      : Boolean := False; -- Receive buffer interrupt.
      RXF      : Boolean := False; -- Receive frame interrupt.
      TXB      : Boolean := False; -- Transmit buffer interrupt.
      TXF      : Boolean := False; -- Transmit frame interrupt.
      GRA      : Boolean := False; -- Graceful stop complete.
      BABT     : Boolean := False; -- Babbling transmit error.
      BABR     : Boolean := False; -- Babbling receive error.
      HBERR    : Boolean := False; -- Heartbeat error.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EIMR_Type use record
      Reserved at 0 range  0 .. 18;
      UN       at 0 range 19 .. 19;
      RL       at 0 range 20 .. 20;
      LC       at 0 range 21 .. 21;
      EBERR    at 0 range 22 .. 22;
      MII      at 0 range 23 .. 23;
      RXB      at 0 range 24 .. 24;
      RXF      at 0 range 25 .. 25;
      TXB      at 0 range 26 .. 26;
      TXF      at 0 range 27 .. 27;
      GRA      at 0 range 28 .. 28;
      BABT     at 0 range 29 .. 29;
      BABR     at 0 range 30 .. 30;
      HBERR    at 0 range 31 .. 31;
   end record;

   EIMR : aliased EIMR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_1008#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 19.2.4.6 MII Management Frame Register (MMFR)

   OP_WRITE : constant := 2#01#; -- OP write
   OP_READ  : constant := 2#10#; -- OP read

   type MMFR_Type is record
      DATA : Bits_16 := 0;     -- Management frame data.
      TA   : Bits_2  := 2#10#; -- Turn around.
      RA   : Bits_5;           -- Register address.
      PA   : Bits_5;           -- PHY address.
      OP   : Bits_2;           -- Operation code.
      ST   : Bits_2  := 2#01#; -- Start of frame delimiter.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MMFR_Type use record
      DATA at 0 range  0 .. 15;
      TA   at 0 range 16 .. 17;
      RA   at 0 range 18 .. 22;
      PA   at 0 range 23 .. 27;
      OP   at 0 range 28 .. 29;
      ST   at 0 range 30 .. 31;
   end record;

   -- "MDATA"
   MMFR : aliased MMFR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_1040#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 19.2.4.7 MII Speed Control Register (MSCR)

   MII_SPEED_TURNOFF : constant := 0;

   type MSCR_Type is record
      Reserved1 : Bits_1  := 0;
      MII_SPEED : Bits_6  := MII_SPEED_TURNOFF; -- MII_SPEED controls the frequency of the MII management interface clock (EMDC) relative to the system clock.
      DIS_PRE   : Boolean := False;             -- Asserting this bit will cause preamble (321’s) not to be prepended to the MII management frame.
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MSCR_Type use record
      Reserved1 at 0 range 0 ..  0;
      MII_SPEED at 0 range 1 ..  6;
      DIS_PRE   at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   MSCR : aliased MSCR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_1044#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 23 Programmable Interrupt Timer Modules (PIT0–PIT3)
   ----------------------------------------------------------------------------

   -- 23.2.1.1 PIT Control and Status Register (PCSRn)

   PRE_DIV1   : constant := 2#0000#; -- div by 2^0
   PRE_DIV2   : constant := 2#0001#; -- div by 2^1
   PRE_DIV4   : constant := 2#0010#; -- div by 2^2
   PRE_DIV8   : constant := 2#0011#; -- div by 2^3
   PRE_DIV16  : constant := 2#0100#; -- div by 2^4
   PRE_DIV32  : constant := 2#0101#; -- div by 2^5
   PRE_DIV64  : constant := 2#0110#; -- div by 2^6
   PRE_DIV128 : constant := 2#0111#; -- div by 2^7
   PRE_DIV256 : constant := 2#1000#; -- div by 2^8
   PRE_DIV512 : constant := 2#1001#; -- div by 2^9
   PRE_DIV1k  : constant := 2#1010#; -- div by 2^10
   PRE_DIV2k  : constant := 2#1011#; -- div by 2^11
   PRE_DIV4k  : constant := 2#1100#; -- div by 2^12
   PRE_DIV8k  : constant := 2#1101#; -- div by 2^13
   PRE_DIV16k : constant := 2#1110#; -- div by 2^14
   PRE_DIV32k : constant := 2#1111#; -- div by 2^15

   type PCSR_Type is record
      EN        : Boolean := False;    -- PIT enable bit.
      RLD       : Boolean := False;    -- Reload bit.
      PIF       : Boolean := False;    -- PIT interrupt flag.
      PIE       : Boolean := False;    -- PIT interrupt enable.
      OVW       : Boolean := False;    -- Overwrite.
      DBG       : Boolean := False;    -- Debug mode bit.
      DOZE      : Boolean := False;    -- Doze mode bit.
      Reserved1 : Bits_1  := 0;
      PRE       : Bits_4  := PRE_DIV1; -- Prescaler.
      Reserved2 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PCSR_Type use record
      EN        at 0 range  0 ..  0;
      RLD       at 0 range  1 ..  1;
      PIF       at 0 range  2 ..  2;
      PIE       at 0 range  3 ..  3;
      OVW       at 0 range  4 ..  4;
      DBG       at 0 range  5 ..  5;
      DOZE      at 0 range  6 ..  6;
      Reserved1 at 0 range  7 ..  7;
      PRE       at 0 range  8 .. 11;
      Reserved2 at 0 range 12 .. 15;
   end record;

   -- 23.2.1.2 PIT Modulus Register (PMRn)

   type PMR_Type is record
      PM : Unsigned_16 := 16#FFFF#; -- timer modulus
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PMR_Type use record
      PM at 0 range 0 .. 15;
   end record;

   -- 23.2.1.3 PIT Count Register (PCNTRn)

   type PCNTR_Type is record
      PC : Unsigned_16; -- counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PCNTR_Type use record
      PC at 0 range 0 .. 15;
   end record;

   -- 23.2 Memory Map/Register Definition

   type PIT_Type is record
      PCSR  : PCSR_Type  with Volatile_Full_Access => True;
      PMR   : PMR_Type   with Volatile_Full_Access => True;
      PCNTR : PCNTR_Type with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16 * 3;
   for PIT_Type use record
      PCSR  at 0 range 0 .. 15;
      PMR   at 2 range 0 .. 15;
      PCNTR at 4 range 0 .. 15;
   end record;

   PIT0 : aliased PIT_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0015_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PIT1 : aliased PIT_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0016_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PIT2 : aliased PIT_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0017_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PIT3 : aliased PIT_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0018_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 26 UART Modules
   ----------------------------------------------------------------------------

   -- 26.3.3 UART Status Registers (USRn)

   type USR_Type is record
      RXRDY : Boolean; -- Receiver ready
      FFULL : Boolean; -- FIFO full
      TXRDY : Boolean; -- Transmitter ready
      TXEMP : Boolean; -- Transmitter empty
      OE    : Boolean; -- Overrun error
      PE    : Boolean; -- Parity error
      FE    : Boolean; -- Framing error
      RB    : Boolean; -- Received break
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for USR_Type use record
      RXRDY at 0 range 0 .. 0;
      FFULL at 0 range 1 .. 1;
      TXRDY at 0 range 2 .. 2;
      TXEMP at 0 range 3 .. 3;
      OE    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      FE    at 0 range 6 .. 6;
      RB    at 0 range 7 .. 7;
   end record;

   USR0 : aliased USR_Type
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_0204#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 26.3.6 UART Receive Buffers (URBn)

   URB0 : aliased Unsigned_8
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_020C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 26.3.7 UART Transmit Buffers (UTBn)

   UTB0 : aliased Unsigned_8
      with Address    => System'To_Address (IPSBAR_BASEADDRESS + 16#0000_020C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end MCF523x;
