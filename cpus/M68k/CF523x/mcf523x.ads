-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf523x.ads                                                                                               --
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
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- MCF523x definitions
   ----------------------------------------------------------------------------

   IPSBAR_BASEADDRESS : constant := 16#4000_0000#;

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
      EXP       : Bits_10; -- Expected difference value
      DEPTH     : Bits_2;  -- Frequency modulation depth and enable
      RATE      : Bits_1;  -- Modulation rate
      LOCIRQ    : Boolean; -- Loss-of-clock interrupt request
      LOLIRQ    : Boolean; -- Loss-of-lock interrupt request
      DISCLK    : Boolean; -- Disable CLKOUT
      LOCRE     : Boolean; -- Loss-of-clock reset enable
      LOLRE     : Boolean; -- Loss-of-lock reset enable
      LOCEN     : Boolean; -- Enables the loss-of-clock function
      RFD       : Bits_3;  -- Reduced frequency divider field
      Reserved1 : Bits_2;
      MFD       : Bits_3;  -- Multiplication factor divider
      Reserved2 : Bits_5;
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
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0012_0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 7.3.1.2 Synthesizer Status Register (SYNSR)

   PLLREF_EXT  : constant := 0; -- External clock reference
   PLLREF_XTAL : constant := 1; -- Crystal clock reference

   PLLSEL_11  : constant := 0; -- 1:1 PLL mode
   PLLSEL_PLL : constant := 1; -- Normal PLL mode (see Table 7-7)

   PLLMODE_EXT : constant := 0; -- External clock mode
   PLLMODE_PLL : constant := 1; -- PLL clock mode

   type SYNSR_Type is record
      CALPASS  : Boolean; -- Calibration passed
      CALDONE  : Boolean; -- Calibration complete
      LOCF     : Boolean; -- Loss-of-clock flag
      LOCK     : Boolean; -- PLL lock status bit
      LOCKS    : Boolean; -- Sticky indication of PLL lock status
      PLLREF   : Bits_1;  -- PLL clock reference source
      PLLSEL   : Bits_1;  -- PLL mode select
      PLLMODE  : Bits_1;  -- Clock mode
      LOC      : Boolean; -- Loss-of-clock status
      LOLF     : Boolean; -- Loss-of-lock flag
      Reserved : Bits_22;
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
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0012_0004#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

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
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0011_000A#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 11.2.1.1 Internal Peripheral System Base Address Register (IPSBAR)

   BA_0 : constant := 2#00#; -- internal peripherals @ 0x0000_0000
   BA_1 : constant := 2#01#; -- internal peripherals @ 0x4000_0000 (default)
   BA_2 : constant := 2#10#; -- internal peripherals @ 0x8000_0000
   BA_3 : constant := 2#11#; -- internal peripherals @ 0xC000_0000

   type IPSBAR_Type is record
      V        : Boolean; -- Valid
      Reserved : Bits_29;
      BA       : Bits_2;  -- Base address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for IPSBAR_Type use record
      V        at 0 range  0 ..  0;
      Reserved at 0 range  1 .. 29;
      BA       at 0 range 30 .. 31;
   end record;

   IPSBAR : aliased IPSBAR_Type
      with Address    => To_Address (IPSBAR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function To_U32 is new Ada.Unchecked_Conversion (IPSBAR_Type, Unsigned_32);
   function To_IPSBAR is new Ada.Unchecked_Conversion (Unsigned_32, IPSBAR_Type);

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
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0000_0204#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 26.3.6 UART Receive Buffers (URBn)

   URB0 : aliased Unsigned_8
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0000_020C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 26.3.7 UART Transmit Buffers (UTBn)

   UTB0 : aliased Unsigned_8
      with Address    => To_Address (IPSBAR_BASEADDRESS + 16#0000_020C#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end MCF523x;
