-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lpc2148.ads                                                                                               --
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
with System.Storage_Elements;
with Interfaces;
with Definitions;
with Bits;

package LPC2148
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
   use Definitions;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- UM10139
   -- LPC214x User manual
   -- Rev. 4 — 23 April 2012
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 4: LPC214x System control
   ----------------------------------------------------------------------------

   -- 4.8.2 PLL Control register

   type PLLxCON_Type is record
      PLLE     : Boolean := False; -- PLL Enable.
      PLLC     : Boolean := False; -- PLL Connect.
      Reserved : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PLLxCON_Type use record
      PLLE     at 0 range 0 .. 0;
      PLLC     at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   PLL0CON_ADDRESS : constant := 16#E01F_C080#;

   PLL0CON : aliased PLLxCON_Type
      with Address              => System'To_Address (PLL0CON_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PLL1CON_ADDRESS : constant := 16#E01F_C0A0#;

   PLL1CON : aliased PLLxCON_Type
      with Address              => System'To_Address (PLL1CON_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.8.3 PLL Configuration register

   MSEL_M1  : constant := 2#00000#; -- Value of M = 1
   MSEL_M2  : constant := 2#00001#; -- Value of M = 2
   MSEL_M3  : constant := 2#00010#; -- Value of M = 3
   MSEL_M4  : constant := 2#00011#; -- Value of M = 4
   MSEL_M5  : constant := 2#00100#; -- Value of M = 5
   MSEL_M6  : constant := 2#00101#; -- Value of M = 6
   MSEL_M7  : constant := 2#00110#; -- Value of M = 7
   MSEL_M8  : constant := 2#00111#; -- Value of M = 8
   MSEL_M9  : constant := 2#01000#; -- Value of M = 9
   MSEL_M10 : constant := 2#01001#; -- Value of M = 10
   MSEL_M11 : constant := 2#01010#; -- Value of M = 11
   MSEL_M12 : constant := 2#01011#; -- Value of M = 12
   MSEL_M13 : constant := 2#01100#; -- Value of M = 13
   MSEL_M14 : constant := 2#01101#; -- Value of M = 14
   MSEL_M15 : constant := 2#01110#; -- Value of M = 15
   MSEL_M16 : constant := 2#01111#; -- Value of M = 16
   MSEL_M17 : constant := 2#10000#; -- Value of M = 17
   MSEL_M18 : constant := 2#10001#; -- Value of M = 18
   MSEL_M19 : constant := 2#10010#; -- Value of M = 19
   MSEL_M20 : constant := 2#10011#; -- Value of M = 20
   MSEL_M21 : constant := 2#10100#; -- Value of M = 21
   MSEL_M22 : constant := 2#10101#; -- Value of M = 22
   MSEL_M23 : constant := 2#10110#; -- Value of M = 23
   MSEL_M24 : constant := 2#10111#; -- Value of M = 24
   MSEL_M25 : constant := 2#11000#; -- Value of M = 25
   MSEL_M26 : constant := 2#11001#; -- Value of M = 26
   MSEL_M27 : constant := 2#11010#; -- Value of M = 27
   MSEL_M28 : constant := 2#11011#; -- Value of M = 28
   MSEL_M29 : constant := 2#11100#; -- Value of M = 29
   MSEL_M30 : constant := 2#11101#; -- Value of M = 30
   MSEL_M31 : constant := 2#11110#; -- Value of M = 31
   MSEL_M32 : constant := 2#11111#; -- Value of M = 32

   PSEL_P1 : constant := 2#00#; -- Value of P = 1
   PSEL_P2 : constant := 2#01#; -- Value of P = 2
   PSEL_P4 : constant := 2#10#; -- Value of P = 4
   PSEL_P8 : constant := 2#11#; -- Value of P = 8

   type PLLxCFG_Type is record
      MSEL     : Bits_5 := MSEL_M1; -- PLL Multiplier value.
      PSEL     : Bits_2 := PSEL_P1; -- PLL Divider value.
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PLLxCFG_Type use record
      MSEL     at 0 range 0 .. 4;
      PSEL     at 0 range 5 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   PLL0CFG_ADDRESS : constant := 16#E01F_C084#;

   PLL0CFG : aliased PLLxCFG_Type
      with Address              => System'To_Address (PLL0CFG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PLL1CFG_ADDRESS : constant := 16#E01F_C0A4#;

   PLL1CFG : aliased PLLxCFG_Type
      with Address              => System'To_Address (PLL1CFG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.8.4 PLL Status register

   -- MSEL_* already defined at 4.8.3

   -- PSEL_* already defined at 4.8.3

   type PLLxSTAT_Type is record
      MSEL      : Bits_5;  -- Read-back for the PLL Multiplier value.
      PSEL      : Bits_2;  -- Read-back for the PLL Divider value.
      Reserved1 : Bits_1;
      PLLE      : Boolean; -- Read-back for the PLL Enable bit.
      PLLC      : Boolean; -- Read-back for the PLL Connect bit.
      PLOCK     : Boolean; -- Reflects the PLL Lock status.
      Reserved2 : Bits_5;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PLLxSTAT_Type use record
      MSEL      at 0 range  0 ..  4;
      PSEL      at 0 range  5 ..  6;
      Reserved1 at 0 range  7 ..  7;
      PLLE      at 0 range  8 ..  8;
      PLLC      at 0 range  9 ..  9;
      PLOCK     at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 15;
   end record;

   PLL0STAT_ADDRESS : constant := 16#E01F_C088#;

   PLL0STAT : aliased PLLxSTAT_Type
      with Address              => System'To_Address (PLL0STAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PLL1STAT_ADDRESS : constant := 16#E01F_C0A8#;

   PLL1STAT : aliased PLLxSTAT_Type
      with Address              => System'To_Address (PLL1STAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.8.7 PLL Feed register

   PLL0FEED_ADDRESS : constant := 16#E01F_C08C#;

   PLL0FEED : aliased Unsigned_8
      with Address              => System'To_Address (PLL0FEED_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PLL1FEED_ADDRESS : constant := 16#E01F_C0AC#;

   PLL1FEED : aliased Unsigned_8
      with Address              => System'To_Address (PLL1FEED_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 8: LPC214x GPIO
   ----------------------------------------------------------------------------

   -- 8.4.1 GPIO port Direction register

   IO0DIR_ADDRESS : constant := 16#E002_8008#;

   IO0DIR : aliased Bitmap_32
      with Address              => System'To_Address (IO0DIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.3 GPIO port Pin value register

   IO0PIN_ADDRESS : constant := 16#E002_8000#;

   IO0PIN : aliased Bitmap_32
      with Address              => System'To_Address (IO0PIN_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.4 GPIO port output Set register

   IO0SET_ADDRESS : constant := 16#E002_8004#;

   IO0SET : aliased Bitmap_32
      with Address              => System'To_Address (IO0SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.5 GPIO port output Clear register

   IO0CLR_ADDRESS : constant := 16#E002_800C#;

   IO0CLR : aliased Bitmap_32
      with Address              => System'To_Address (IO0CLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 10: LPC214x UART0
   ----------------------------------------------------------------------------

   UART0_BASEADDRESS : constant := 16#E000_C000#;

   ----------------------------------------------------------------------------
   -- Chapter 11: LPC214x UART1
   ----------------------------------------------------------------------------

   UART1_BASEADDRESS : constant := 16#E001_0000#;

pragma Style_Checks (On);

end LPC2148;
