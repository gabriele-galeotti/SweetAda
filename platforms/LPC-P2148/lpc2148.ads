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
with Interfaces;
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
   use Interfaces;
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

   -- 4.8.2 PLL Control register (PLL0CON - 0xE01F C080, PLL1CON - 0xE01F C0A0)

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

   -- 4.8.3 PLL Configuration register (PLL0CFG - 0xE01F C084, PLL1CFG - 0xE01F C0A4)

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

   -- 4.8.4 PLL Status register (PLL0STAT - 0xE01F C088, PLL1STAT - 0xE01F C0A8)

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

   -- 4.8.7 PLL Feed register (PLL0FEED - 0xE01F C08C, PLL1FEED - 0xE01F C0AC)

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

   -- 4.9.2 Power Control register (PCON - 0xE01F C0C0)

   type PCON_Type is record
      IDL      : Boolean := False; -- Idle mode control.
      PD       : Boolean := False; -- Power-down mode control.
      BODPDM   : Boolean := False; -- Brown Out Power-down Mode.
      BOGD     : Boolean := False; -- Brown Out Global Disable.
      BORD     : Boolean := False; -- Brown Out Reset Disable.
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PCON_Type use record
      IDL      at 0 range 0 .. 0;
      PD       at 0 range 1 .. 1;
      BODPDM   at 0 range 2 .. 2;
      BOGD     at 0 range 3 .. 3;
      BORD     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   PCON_ADDRESS : constant := 16#E01F_C0C0#;

   PCON : aliased PCON_Type
      with Address              => System'To_Address (PCON_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.9.3 Power Control for Peripherals register (PCONP - 0xE01F C0C4)

   type PCONP_Type is record
      Reserved1 : Bits_1  := 0;
      PCTIM0    : Boolean := True;  -- Timer/Counter 0 power/clock control bit.
      PCTIM1    : Boolean := True;  -- Timer/Counter 1 power/clock control bit.
      PCUART0   : Boolean := True;  -- UART0 power/clock control bit.
      PCUART1   : Boolean := True;  -- UART1 power/clock control bit.
      PCPWM0    : Boolean := True;  -- PWM0 power/clock control bit.
      Reserved2 : Bits_1  := 0;
      PCI2C0    : Boolean := True;  -- The I2C0 interface power/clock control bit.
      PCSPI0    : Boolean := True;  -- The SPI0 interface power/clock control bit.
      PCRTC     : Boolean := True;  -- The RTC power/clock control bit.
      PCSPI1    : Boolean := True;  -- The SSP interface power/clock control bit.
      Reserved3 : Bits_1  := 0;
      PCAD0     : Boolean := True;  -- A/D converter 0 (ADC0) power/clock control bit.
      Reserved4 : Bits_6  := 0;
      PCI2C1    : Boolean := True;  -- The I2C1 interface power/clock control bit.
      PCAD1     : Boolean := True;  -- A/D converter 1 (ADC1) power/clock control bit.
      Reserved5 : Bits_10 := 0;
      PUSB      : Boolean := False; -- USB power/clock control bit.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PCONP_Type use record
      Reserved1 at 0 range  0 ..  0;
      PCTIM0    at 0 range  1 ..  1;
      PCTIM1    at 0 range  2 ..  2;
      PCUART0   at 0 range  3 ..  3;
      PCUART1   at 0 range  4 ..  4;
      PCPWM0    at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      PCI2C0    at 0 range  7 ..  7;
      PCSPI0    at 0 range  8 ..  8;
      PCRTC     at 0 range  9 ..  9;
      PCSPI1    at 0 range 10 .. 10;
      Reserved3 at 0 range 11 .. 11;
      PCAD0     at 0 range 12 .. 12;
      Reserved4 at 0 range 13 .. 18;
      PCI2C1    at 0 range 19 .. 19;
      PCAD1     at 0 range 20 .. 20;
      Reserved5 at 0 range 21 .. 30;
      PUSB      at 0 range 31 .. 31;
   end record;

   PCONP_ADDRESS : constant := 16#E01F_C0C4#;

   PCONP : aliased PCONP_Type
      with Address              => System'To_Address (PCONP_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.10.1 Reset Source Identification Register (RSIR - 0xE01F C180)

   type RSIR_Type is record
      POR      : Boolean; -- Power-On Reset (POR) event sets this bit, and clears all of the other bits in this register.
      EXTR     : Boolean; -- Assertion of the /RESET signal sets this bit.
      WDTR     : Boolean; -- This bit is set when the Watchdog Timer times out and the WDTRESET bit in the Watchdog Mode Register is 1.
      BODR     : Boolean; -- This bit is set when the 3.3 V power reaches a level below 2.6 V.
      Reserved : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RSIR_Type use record
      POR      at 0 range 0 .. 0;
      EXTR     at 0 range 1 .. 1;
      WDTR     at 0 range 2 .. 2;
      BODR     at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   RSIR_ADDRESS : constant := 16#E01F_C180#;

   RSIR : aliased RSIR_Type
      with Address              => System'To_Address (RSIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.11.2 APBDIV register (APBDIV - 0xE01F C100)

   APBDIV_DIV4 : constant := 2#00#; -- APB bus clock is one fourth of the processor clock.
   APBDIV_NONE : constant := 2#01#; -- APB bus clock is the same as the processor clock.
   APBDIV_DIV2 : constant := 2#10#; -- APB bus clock is one half of the processor clock.
   APBDIV_RSVD : constant := 2#11#; -- Reserved.

   type APBDIV_Type is record
      APBDIV   : Bits_2 := APBDIV_DIV4; -- APB bus clock
      Reserved : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for APBDIV_Type use record
      APBDIV   at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   APBDIV_ADDRESS : constant := 16#E01F_C180#;

   APBDIV : aliased APBDIV_Type
      with Address              => System'To_Address (APBDIV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 8: LPC214x GPIO
   ----------------------------------------------------------------------------

   -- 8.4.1 GPIO port Direction register (IODIR, Port 0: IO0DIR - 0xE002 8008 and Port 1: IO1DIR - 0xE002 8018; FIODIR, Port 0: FIO0DIR - 0x3FFF C000 and Port 1:FIO1DIR - 0x3FFF C020)

   IO0DIR_ADDRESS : constant := 16#E002_8008#;

   IO0DIR : aliased Bitmap_32
      with Address              => System'To_Address (IO0DIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.2 Fast GPIO port Mask register (FIOMASK, Port 0: FIO0MASK - 0x3FFF C010 and Port 1:FIO1MASK - 0x3FFF C030)

   FIO0MASK_ADDRESS : constant := 16#3FFF_C010#;

   FIO0MASK : aliased Bitmap_32
      with Address              => System'To_Address (FIO0MASK_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO1MASK_ADDRESS : constant := 16#3FFF_C030#;

   FIO1MASK : aliased Bitmap_32
      with Address              => System'To_Address (FIO1MASK_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.3 GPIO port Pin value register (IOPIN, Port 0: IO0PIN - 0xE002 8000 and Port 1: IO1PIN - 0xE002 8010; FIOPIN, Port 0: FIO0PIN - 0x3FFF C014 and Port 1: FIO1PIN - 0x3FFF C034)

   IO0PIN_ADDRESS : constant := 16#E002_8000#;

   IO0PIN : aliased Bitmap_32
      with Address              => System'To_Address (IO0PIN_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.4 GPIO port output Set register (IOSET, Port 0: IO0SET - 0xE002 8004 and Port 1: IO1SET - 0xE002 8014; FIOSET, Port 0: FIO0SET - 0x3FFF C018 and Port 1: FIO1SET - 0x3FFF C038)

   IO0SET_ADDRESS : constant := 16#E002_8004#;

   IO0SET : aliased Bitmap_32
      with Address              => System'To_Address (IO0SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.4.5 GPIO port output Clear register (IOCLR, Port 0: IO0CLR - 0xE002 800C and Port 1: IO1CLR - 0xE002 801C; FIOCLR, Port 0: FIO0CLR - 0x3FFF C01C and Port 1: FIO1CLR - 0x3FFF C03C)

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
