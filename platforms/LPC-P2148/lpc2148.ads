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

   APBDIV_ADDRESS : constant := 16#E01F_C100#;

   APBDIV : aliased APBDIV_Type
      with Address              => System'To_Address (APBDIV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 6: LPC214x Pin connect block
   ----------------------------------------------------------------------------

   -- 6.4.1 Pin function Select register 0 (PINSEL0 - 0xE002 C000)

   type P0_0_Type is new Bits_2;
   P0_0_GPIO     : constant P0_0_Type := 2#00#; -- GPIO Port 0.0
   P0_0_UART0TXD : constant P0_0_Type := 2#01#; -- TXD (UART0)
   P0_0_PWM1     : constant P0_0_Type := 2#10#; -- PWM1
   P0_0_RSVD     : constant P0_0_Type := 2#11#; -- Reserved

   type P0_1_Type is new Bits_2;
   P0_1_GPIO     : constant P0_1_Type := 2#00#; -- GPIO Port 0.1
   P0_1_UART0RXD : constant P0_1_Type := 2#01#; -- RxD (UART0)
   P0_1_PWM3     : constant P0_1_Type := 2#10#; -- PWM3
   P0_1_EINT0    : constant P0_1_Type := 2#11#; -- EINT0

   type P0_2_Type is new Bits_2;
   P0_2_GPIO            : constant P0_2_Type := 2#00#; -- GPIO Port 0.2
   P0_2_I2C0SCL0        : constant P0_2_Type := 2#01#; -- SCL0 (I2C0)
   P0_2_Timer0Capture00 : constant P0_2_Type := 2#10#; -- Capture 0.0 (Timer 0)
   P0_2_RSVD            : constant P0_2_Type := 2#11#; -- Reserved

   type P0_3_Type is new Bits_2;
   P0_3_GPIO          : constant P0_3_Type := 2#00#; -- GPIO Port 0.3
   P0_3_I2C0SDA0      : constant P0_3_Type := 2#01#; -- SDA0 (I2 C0)
   P0_3_Timer0Match00 : constant P0_3_Type := 2#10#; -- Match 0.0 (Timer 0)
   P0_3_EINT1         : constant P0_3_Type := 2#11#; -- EINT1

   type P0_4_Type is new Bits_2;
   P0_4_GPIO            : constant P0_4_Type := 2#00#; -- GPIO Port 0.4
   P0_4_SPI0SCK0        : constant P0_4_Type := 2#01#; -- SCK0 (SPI0)
   P0_4_Timer0Capture01 : constant P0_4_Type := 2#10#; -- Capture 0.1 (Timer 0)
   P0_4_AD06            : constant P0_4_Type := 2#11#; -- AD0.6

   type P0_5_Type is new Bits_2;
   P0_5_GPIO          : constant P0_5_Type := 2#00#; -- GPIO Port 0.5
   P0_5_SPI0MISO0     : constant P0_5_Type := 2#01#; -- MISO0 (SPI0)
   P0_5_Timer0Match01 : constant P0_5_Type := 2#10#; -- Match 0.1 (Timer 0)
   P0_5_AD07          : constant P0_5_Type := 2#11#; -- AD0.7

   type P0_6_Type is new Bits_2;
   P0_6_GPIO            : constant P0_6_Type := 2#00#; -- GPIO Port 0.6
   P0_6_SPI0MOSI0       : constant P0_6_Type := 2#01#; -- MOSI0 (SPI0)
   P0_6_Timer0Capture02 : constant P0_6_Type := 2#10#; -- Capture 0.2 (Timer 0)
   P0_6_RSVD            : constant P0_6_Type := 2#11#; -- Reserved
   P0_6_AD10            : constant P0_6_Type := 2#11#; -- AD1.0

   type P0_7_Type is new Bits_2;
   P0_7_GPIO      : constant P0_7_Type := 2#00#; -- GPIO Port 0.7
   P0_7_SPI0SSEL0 : constant P0_7_Type := 2#01#; -- SSEL0 (SPI0)
   P0_7_PWM2      : constant P0_7_Type := 2#10#; -- PWM2
   P0_7_EINT2     : constant P0_7_Type := 2#11#; -- EINT2

   type P0_8_Type is new Bits_2;
   P0_8_GPIO     : constant P0_8_Type := 2#00#; -- GPIO Port 0.8
   P0_8_UART1TXD : constant P0_8_Type := 2#01#; -- TXD UART1
   P0_8_PWM4     : constant P0_8_Type := 2#10#; -- PWM4
   P0_8_RSVD     : constant P0_8_Type := 2#11#; -- Reserved
   P0_8_AD11     : constant P0_8_Type := 2#11#; -- AD1.1

   type P0_9_Type is new Bits_2;
   P0_9_GPIO     : constant P0_9_Type := 2#00#; -- GPIO Port 0.9
   P0_9_UART1RXD : constant P0_9_Type := 2#01#; -- RxD (UART1)
   P0_9_PWM6     : constant P0_9_Type := 2#10#; -- PWM6
   P0_9_EINT3    : constant P0_9_Type := 2#11#; -- EINT3

   type P0_10_Type is new Bits_2;
   P0_10_GPIO            : constant P0_10_Type := 2#00#; -- GPIO Port 0.10
   P0_10_RSVD1           : constant P0_10_Type := 2#01#; -- Reserved
   P0_10_UART1RTS        : constant P0_10_Type := 2#01#; -- RTS (UART1)
   P0_10_Timer1Capture10 : constant P0_10_Type := 2#10#; -- Capture 1.0 (Timer 1)
   P0_10_RSVD2           : constant P0_10_Type := 2#11#; -- Reserved
   P0_10_AD12            : constant P0_10_Type := 2#11#; -- AD1.2

   type P0_11_Type is new Bits_2;
   P0_11_GPIO            : constant P0_11_Type := 2#00#; -- GPIO Port 0.11
   P0_11_RSVD            : constant P0_11_Type := 2#01#; -- Reserved
   P0_11_UART1CTS        : constant P0_11_Type := 2#01#; -- CTS (UART1)
   P0_11_Timer1Capture11 : constant P0_11_Type := 2#10#; -- Capture 1.1 (Timer 1)
   P0_11_I2C1SCL1        : constant P0_11_Type := 2#11#; -- SCL1 (I2C1)

   type P0_12_Type is new Bits_2;
   P0_12_GPIO          : constant P0_12_Type := 2#00#; -- GPIO Port 0.12
   P0_12_RSVD1         : constant P0_12_Type := 2#01#; -- Reserved
   P0_12_UART1DSR      : constant P0_12_Type := 2#01#; -- DSR (UART1)
   P0_12_Timer1Match10 : constant P0_12_Type := 2#10#; -- Match 1.0 (Timer 1)
   P0_12_RSVD2         : constant P0_12_Type := 2#11#; -- Reserved
   P0_12_AD13          : constant P0_12_Type := 2#11#; -- AD1.3

   type P0_13_Type is new Bits_2;
   P0_13_GPIO          : constant P0_13_Type := 2#00#; -- GPIO Port 0.13
   P0_13_RSVD1         : constant P0_13_Type := 2#01#; -- Reserved
   P0_13_UART1DTR      : constant P0_13_Type := 2#01#; -- DTR (UART1)
   P0_13_Timer1Match11 : constant P0_13_Type := 2#10#; -- Match 1.1 (Timer 1)
   P0_13_RSVD2         : constant P0_13_Type := 2#11#; -- Reserved
   P0_13_AD14          : constant P0_13_Type := 2#11#; -- AD1.4

   type P0_14_Type is new Bits_2;
   P0_14_GPIO     : constant P0_14_Type := 2#00#; -- GPIO Port 0.14
   P0_14_RSVD     : constant P0_14_Type := 2#01#; -- Reserved
   P0_14_UART1DCD : constant P0_14_Type := 2#01#; -- DCD (UART1)
   P0_14_ENIT1    : constant P0_14_Type := 2#10#; -- EINT1
   P0_14_I2C1SDA1 : constant P0_14_Type := 2#11#; -- SDA1 (I2 C1)

   type P0_15_Type is new Bits_2;
   P0_15_GPIO    : constant P0_15_Type := 2#00#; -- GPIO Port 0.15
   P0_15_RSVD1   : constant P0_15_Type := 2#01#; -- Reserved
   P0_15_UART1RI : constant P0_15_Type := 2#01#; -- RI (UART1)
   P0_15_EINT2   : constant P0_15_Type := 2#10#; -- EINT2
   P0_15_RSVD2   : constant P0_15_Type := 2#11#; -- Reserved
   P0_15_AD15    : constant P0_15_Type := 2#11#; -- AD1.5

   type PINSEL0_Type is record
      P0  : P0_0_Type  := P0_0_GPIO;  -- Pin function Select
      P1  : P0_1_Type  := P0_1_GPIO;  -- ''
      P2  : P0_2_Type  := P0_2_GPIO;  -- ''
      P3  : P0_3_Type  := P0_3_GPIO;  -- ''
      P4  : P0_4_Type  := P0_4_GPIO;  -- ''
      P5  : P0_5_Type  := P0_5_GPIO;  -- ''
      P6  : P0_6_Type  := P0_6_GPIO;  -- ''
      P7  : P0_7_Type  := P0_7_GPIO;  -- ''
      P8  : P0_8_Type  := P0_8_GPIO;  -- ''
      P9  : P0_9_Type  := P0_9_GPIO;  -- ''
      P10 : P0_10_Type := P0_10_GPIO; -- ''
      P11 : P0_11_Type := P0_11_GPIO; -- ''
      P12 : P0_12_Type := P0_12_GPIO; -- ''
      P13 : P0_13_Type := P0_13_GPIO; -- ''
      P14 : P0_14_Type := P0_14_GPIO; -- ''
      P15 : P0_15_Type := P0_15_GPIO; -- ''
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PINSEL0_Type use record
      P0  at 0 range  0 ..  1;
      P1  at 0 range  2 ..  3;
      P2  at 0 range  4 ..  5;
      P3  at 0 range  6 ..  7;
      P4  at 0 range  8 ..  9;
      P5  at 0 range 10 .. 11;
      P6  at 0 range 12 .. 13;
      P7  at 0 range 14 .. 15;
      P8  at 0 range 16 .. 17;
      P9  at 0 range 18 .. 19;
      P10 at 0 range 20 .. 21;
      P11 at 0 range 22 .. 23;
      P12 at 0 range 24 .. 25;
      P13 at 0 range 26 .. 27;
      P14 at 0 range 28 .. 29;
      P15 at 0 range 30 .. 31;
   end record;

   PINSEL0_ADDRESS : constant := 16#E002_C000#;

   PINSEL0 : aliased PINSEL0_Type
      with Address              => System'To_Address (PINSEL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.4.2 Pin function Select register 1 (PINSEL1 - 0xE002 C004)

   type P0_16_Type is new Bits_2;
   P0_16_GPIO            : constant P0_16_Type := 2#00#; -- GPIO Port 0.16
   P0_16_EINT0           : constant P0_16_Type := 2#01#; -- EINT0
   P0_16_Timer0Match02   : constant P0_16_Type := 2#10#; -- Match 0.2 (Timer 0)
   P0_16_Timer0Capture02 : constant P0_16_Type := 2#11#; -- Capture 0.2 (Timer 0)

   type P0_17_Type is new Bits_2;
   P0_17_GPIO            : constant P0_17_Type := 2#00#; -- GPIO Port 0.17
   P0_17_Timer1Capture12 : constant P0_17_Type := 2#01#; -- Capture 1.2 (Timer 1)
   P0_17_SSPSCK1         : constant P0_17_Type := 2#10#; -- SCK1 (SSP)
   P0_17_Timer1Match12   : constant P0_17_Type := 2#11#; -- Match 1.2 (Timer 1)

   type P0_18_Type is new Bits_2;
   P0_18_GPIO            : constant P0_18_Type := 2#00#; -- GPIO Port 0.18
   P0_18_Timer1Capture13 : constant P0_18_Type := 2#01#; -- Capture 1.3 (Timer 1)
   P0_18_SSPMISO1        : constant P0_18_Type := 2#10#; -- MISO1 (SSP)
   P0_18_Timer1Match13   : constant P0_18_Type := 2#11#; -- Match 1.3 (Timer 1)

   type P0_19_Type is new Bits_2;
   P0_19_GPIO            : constant P0_19_Type := 2#00#; -- GPIO Port 0.19
   P0_19_Timer1Match12   : constant P0_19_Type := 2#01#; -- Match 1.2 (Timer 1)
   P0_19_SSPMOSI1        : constant P0_19_Type := 2#10#; -- MOSI1 (SSP)
   P0_19_Timer1Capture12 : constant P0_19_Type := 2#11#; -- Capture 1.2 (Timer 1)

   type P0_20_Type is new Bits_2;
   P0_20_GPIO          : constant P0_20_Type := 2#00#; -- GPIO Port 0.20
   P0_20_Timer1Match13 : constant P0_20_Type := 2#01#; -- Match 1.3 (Timer 1)
   P0_20_SSPSSEL1      : constant P0_20_Type := 2#10#; -- SSEL1 (SSP)
   P0_20_EINT3         : constant P0_20_Type := 2#11#; -- EINT3

   type P0_21_Type is new Bits_2;
   P0_21_GPIO            : constant P0_21_Type := 2#00#; -- GPIO Port 0.21
   P0_21_PWM5            : constant P0_21_Type := 2#01#; -- PWM5
   P0_21_RSVD            : constant P0_21_Type := 2#10#; -- Reserved
   P0_21_AD16            : constant P0_21_Type := 2#10#; -- AD1.6
   P0_21_Timer1Capture13 : constant P0_21_Type := 2#11#; -- Capture 1.3 (Timer 1)

   type P0_22_Type is new Bits_2;
   P0_22_GPIO            : constant P0_22_Type := 2#00#; -- GPIO Port 0.22
   P0_22_RSVD            : constant P0_22_Type := 2#01#; -- Reserved
   P0_22_AD17            : constant P0_22_Type := 2#01#; -- AD1.7
   P0_22_Timer0Capture00 : constant P0_22_Type := 2#10#; -- Capture 0.0 (Timer 0)
   P0_22_Timer0Match00   : constant P0_22_Type := 2#11#; -- Match 0.0 (Timer 0)

   type P0_23_Type is new Bits_2;
   P0_23_GPIO  : constant P0_23_Type := 2#00#; -- GPIO Port 0.23
   P0_23_VBUS  : constant P0_23_Type := 2#01#; -- VBUS
   P0_23_RSVD1 : constant P0_23_Type := 2#10#; -- Reserved
   P0_23_RSVD2 : constant P0_23_Type := 2#11#; -- Reserved

   type P0_24_Type is new Bits_2;
   P0_24_RSVD1 : constant P0_24_Type := 2#00#; -- Reserved
   P0_24_RSVD2 : constant P0_24_Type := 2#01#; -- Reserved
   P0_24_RSVD3 : constant P0_24_Type := 2#10#; -- Reserved
   P0_24_RSVD4 : constant P0_24_Type := 2#11#; -- Reserved

   type P0_25_Type is new Bits_2;
   P0_25_GPIO    : constant P0_25_Type := 2#00#; -- GPIO Port 0.25
   P0_25_AD04    : constant P0_25_Type := 2#01#; -- AD0.4
   P0_25_RSVD1   : constant P0_25_Type := 2#10#; -- Reserved
   P0_25_DACAout : constant P0_25_Type := 2#10#; -- Aout(DAC)
   P0_25_RSVD2   : constant P0_25_Type := 2#11#; -- Reserved

   type P0_26_Type is new Bits_2;
   P0_26_RSVD1 : constant P0_26_Type := 2#00#; -- Reserved
   P0_26_RSVD2 : constant P0_26_Type := 2#01#; -- Reserved
   P0_26_RSVD3 : constant P0_26_Type := 2#10#; -- Reserved
   P0_26_RSVD4 : constant P0_26_Type := 2#11#; -- Reserved

   type P0_27_Type is new Bits_2;
   P0_27_RSVD1 : constant P0_27_Type := 2#00#; -- Reserved
   P0_27_RSVD2 : constant P0_27_Type := 2#01#; -- Reserved
   P0_27_RSVD3 : constant P0_27_Type := 2#10#; -- Reserved
   P0_27_RSVD4 : constant P0_27_Type := 2#11#; -- Reserved

   type P0_28_Type is new Bits_2;
   P0_28_GPIO            : constant P0_28_Type := 2#00#; -- GPIO Port 0.28
   P0_28_AD01            : constant P0_28_Type := 2#01#; -- AD0.1
   P0_28_Timer0Capture02 : constant P0_28_Type := 2#10#; -- Capture 0.2 (Timer 0)
   P0_28_Timer0Match02   : constant P0_28_Type := 2#11#; -- Match 0.2 (Timer 0)

   type P0_29_Type is new Bits_2;
   P0_29_GPIO            : constant P0_29_Type := 2#00#; -- GPIO Port 0.29
   P0_29_AD02            : constant P0_29_Type := 2#01#; -- AD0.2
   P0_29_Timer0Capture03 : constant P0_29_Type := 2#10#; -- Capture 0.3 (Timer 0)
   P0_29_Timer0Match03   : constant P0_29_Type := 2#11#; -- Match 0.3 (Timer 0)

   type P0_30_Type is new Bits_2;
   P0_30_GPIO            : constant P0_30_Type := 2#00#; -- GPIO Port 0.30
   P0_30_AD03            : constant P0_30_Type := 2#01#; -- AD0.3
   P0_30_EINT3           : constant P0_30_Type := 2#10#; -- EINT3
   P0_30_Timer0Capture00 : constant P0_30_Type := 2#11#; -- Capture 0.0 (Timer 0)

   type P0_31_Type is new Bits_2;
   P0_31_GPOPortonly : constant P0_31_Type := 2#00#; -- GPO Port only
   P0_31_UPLED       : constant P0_31_Type := 2#01#; -- UP_LED
   P0_31_CONNECT     : constant P0_31_Type := 2#10#; -- CONNECT
   P0_31_RSVD        : constant P0_31_Type := 2#11#; -- Reserved

   type PINSEL1_Type is record
      P16 : P0_16_Type := P0_16_GPIO;        -- Pin function Select
      P17 : P0_17_Type := P0_17_GPIO;        -- ''
      P18 : P0_18_Type := P0_18_GPIO;        -- ''
      P19 : P0_19_Type := P0_19_GPIO;        -- ''
      P20 : P0_20_Type := P0_20_GPIO;        -- ''
      P21 : P0_21_Type := P0_21_GPIO;        -- ''
      P22 : P0_22_Type := P0_22_GPIO;        -- ''
      P23 : P0_23_Type := P0_23_GPIO;        -- ''
      P24 : P0_24_Type := P0_24_RSVD1;       -- ''
      P25 : P0_25_Type := P0_25_GPIO;        -- ''
      P26 : P0_26_Type := P0_26_RSVD1;       -- ''
      P27 : P0_27_Type := P0_27_RSVD1;       -- ''
      P28 : P0_28_Type := P0_28_GPIO;        -- ''
      P29 : P0_29_Type := P0_29_GPIO;        -- ''
      P30 : P0_30_Type := P0_30_GPIO;        -- ''
      P31 : P0_31_Type := P0_31_GPOPortonly; -- ''
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PINSEL1_Type use record
      P16 at 0 range  0 ..  1;
      P17 at 0 range  2 ..  3;
      P18 at 0 range  4 ..  5;
      P19 at 0 range  6 ..  7;
      P20 at 0 range  8 ..  9;
      P21 at 0 range 10 .. 11;
      P22 at 0 range 12 .. 13;
      P23 at 0 range 14 .. 15;
      P24 at 0 range 16 .. 17;
      P25 at 0 range 18 .. 19;
      P26 at 0 range 20 .. 21;
      P27 at 0 range 22 .. 23;
      P28 at 0 range 24 .. 25;
      P29 at 0 range 26 .. 27;
      P30 at 0 range 28 .. 29;
      P31 at 0 range 30 .. 31;
   end record;

   PINSEL1_ADDRESS : constant := 16#E002_C004#;

   PINSEL1 : aliased PINSEL1_Type
      with Address              => System'To_Address (PINSEL1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.4.3 Pin function Select register 2 (PINSEL2 - 0xE002 C014)

   type GPIODEBUG_Type is new Bits_1;
   GPIODEBUG_GPIO  : constant GPIODEBUG_Type := 0; -- Pins P1.36-26 are used as GPIO pins.
   GPIODEBUG_DEBUG : constant GPIODEBUG_Type := 1; -- Pins P1.36-26 are used as a Debug port.

   type GPIOTRACE_Type is new Bits_1;
   GPIOTRACE_GPIO  : constant GPIOTRACE_Type := 0; -- Pins P1.25-16 are used as GPIO pins.
   GPIOTRACE_TRACE : constant GPIOTRACE_Type := 1; -- Pins P1.25-16 are used as a Trace port.

   type PINSEL2_Type is record
      Reserved1 : Bits_2         := 0;
      GPIODEBUG : GPIODEBUG_Type := GPIODEBUG_GPIO; -- Pin function Select
      GPIOTRACE : GPIOTRACE_Type := GPIOTRACE_GPIO; -- ''
      Reserved2 : Bits_28        := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PINSEL2_Type use record
      Reserved1 at 0 range 0 ..  1;
      GPIODEBUG at 0 range 2 ..  2;
      GPIOTRACE at 0 range 3 ..  3;
      Reserved2 at 0 range 4 .. 31;
   end record;

   PINSEL2_ADDRESS : constant := 16#E002_C014#;

   PINSEL2 : aliased PINSEL2_Type
      with Address              => System'To_Address (PINSEL2_ADDRESS),
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

   IO1DIR_ADDRESS : constant := 16#E002_8018#;

   IO1DIR : aliased Bitmap_32
      with Address              => System'To_Address (IO1DIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO0DIR_ADDRESS : constant := 16#3FFF_C000#;

   FIO0DIR : aliased Bitmap_32
      with Address              => System'To_Address (FIO0DIR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO1DIR_ADDRESS : constant := 16#3FFF_C020#;

   FIO1DIR : aliased Bitmap_32
      with Address              => System'To_Address (FIO1DIR_ADDRESS),
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

   IO1PIN_ADDRESS : constant := 16#E002_8010#;

   IO1PIN : aliased Bitmap_32
      with Address              => System'To_Address (IO1PIN_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO0PIN_ADDRESS : constant := 16#3FFF_C014#;

   FIO0PIN : aliased Bitmap_32
      with Address              => System'To_Address (FIO0PIN_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO1PIN_ADDRESS : constant := 16#3FFF_C034#;

   FIO1PIN : aliased Bitmap_32
      with Address              => System'To_Address (FIO1PIN_ADDRESS),
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

   IO1SET_ADDRESS : constant := 16#E002_8014#;

   IO1SET : aliased Bitmap_32
      with Address              => System'To_Address (IO1SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO0SET_ADDRESS : constant := 16#3FFF_C018#;

   FIO0SET : aliased Bitmap_32
      with Address              => System'To_Address (FIO0SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO1SET_ADDRESS : constant := 16#3FFF_C038#;

   FIO1SET : aliased Bitmap_32
      with Address              => System'To_Address (FIO1SET_ADDRESS),
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

   IO1CLR_ADDRESS : constant := 16#E002_801C#;

   IO1CLR : aliased Bitmap_32
      with Address              => System'To_Address (IO1CLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO0CLR_ADDRESS : constant := 16#3FFF_C01C#;

   FIO0CLR : aliased Bitmap_32
      with Address              => System'To_Address (FIO0CLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FIO1CLR_ADDRESS : constant := 16#3FFF_C03C#;

   FIO1CLR : aliased Bitmap_32
      with Address              => System'To_Address (FIO1CLR_ADDRESS),
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
