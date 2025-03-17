-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ s5d9.ads                                                                                                  --
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

package S5D9
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
   -- S5D9 Microcontroller Group User's Manual
   -- Renesas Synergy(TM) Platform
   -- Synergy Microcontrollers S5 Series
   -- Rev.1.30 Aug 2019
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 6. Resets
   ----------------------------------------------------------------------------

   -- 6.2.1 Reset Status Register 0 (RSTSR0)

   type RSTSR0_Type is record
      PORF     : Boolean;      -- Power-On Reset Detect Flag
      LVD0RF   : Boolean;      -- Voltage Monitor 0 Reset Detect Flag
      LVD1RF   : Boolean;      -- Voltage Monitor 1 Reset Detect Flag
      LVD2RF   : Boolean;      -- Voltage Monitor 2 Reset Detect Flag
      Reserved : Bits_3  := 0;
      DPSRSTF  : Boolean;      -- Deep Software Standby Reset Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RSTSR0_Type use record
      PORF     at 0 range 0 .. 0;
      LVD0RF   at 0 range 1 .. 1;
      LVD1RF   at 0 range 2 .. 2;
      LVD2RF   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 6;
      DPSRSTF  at 0 range 7 .. 7;
   end record;

   RSTSR0_ADDRESS : constant := 16#4001_E410#;

   RSTSR0 : aliased RSTSR0_Type
      with Address              => System'To_Address (RSTSR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.2.2 Reset Status Register 1 (RSTSR1)

   type RSTSR1_Type is record
      IWDTRF    : Boolean;      -- Independent Watchdog Timer Reset Detect Flag
      WDTRF     : Boolean;      -- Watchdog Timer Reset Detect Flag
      SWRF      : Boolean;      -- Software Reset Detect Flag
      Reserved1 : Bits_5  := 0;
      RPERF     : Boolean;      -- SRAM Parity Error Reset Detect Flag
      REERF     : Boolean;      -- SRAM ECC Error Reset Detect Flag
      BUSSRF    : Boolean;      -- Bus Slave MPU Error Reset Detect Flag
      BUSMRF    : Boolean;      -- Bus Master MPU Error Reset Detect Flag
      SPERF     : Boolean;      -- SP Error Reset Detect Flag
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for RSTSR1_Type use record
      IWDTRF    at 0 range  0 ..  0;
      WDTRF     at 0 range  1 ..  1;
      SWRF      at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  7;
      RPERF     at 0 range  8 ..  8;
      REERF     at 0 range  9 ..  9;
      BUSSRF    at 0 range 10 .. 10;
      BUSMRF    at 0 range 11 .. 11;
      SPERF     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   RSTSR1_ADDRESS : constant := 16#4001_E0C0#;

   RSTSR1 : aliased RSTSR1_Type with
      Address              => System'To_Address (RSTSR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 6.2.3 Reset Status Register 2 (RSTSR2)

   type RSTSR2_Type is record
      CWSF     : Boolean;      -- Cold/Warm Start Determination Flag
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RSTSR2_Type use record
      CWSF     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   RSTSR2_ADDRESS : constant := 16#4001_E411#;

   RSTSR2 : aliased RSTSR2_Type
      with Address              => System'To_Address (RSTSR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 9. Clock Generation Circuit
   ----------------------------------------------------------------------------

   -- 9.2.1 System Clock Division Control Register (SCKDIVCR)

   SCKDIVCR_DIV1  : constant := 2#000#; -- ×1/1
   SCKDIVCR_DIV2  : constant := 2#001#; -- ×1/2
   SCKDIVCR_DIV4  : constant := 2#010#; -- ×1/4
   SCKDIVCR_DIV8  : constant := 2#011#; -- ×1/8
   SCKDIVCR_DIV16 : constant := 2#100#; -- ×1/16
   SCKDIVCR_DIV32 : constant := 2#101#; -- ×1/32
   SCKDIVCR_DIV64 : constant := 2#110#; -- ×1/64.

   type SCKDIVCR_Type is record
      PCKD      : Bits_3 := SCKDIVCR_DIV4; -- Peripheral Module Clock D
      Reserved1 : Bits_1 := 0;
      PCKC      : Bits_3 := SCKDIVCR_DIV4; -- Peripheral Module Clock C
      Reserved2 : Bits_1 := 0;
      PCKB      : Bits_3 := SCKDIVCR_DIV4; -- Peripheral Module Clock B
      Reserved3 : Bits_1 := 0;
      PCKA      : Bits_3 := SCKDIVCR_DIV4; -- Peripheral Module Clock A
      Reserved4 : Bits_1 := 0;
      BCK       : Bits_3 := SCKDIVCR_DIV4; -- External Bus Clock
      Reserved5 : Bits_5 := 0;
      ICK       : Bits_3 := SCKDIVCR_DIV4; -- System Clock
      Reserved6 : Bits_1 := 0;
      FCK       : Bits_3 := SCKDIVCR_DIV4; -- Flash Interface Clock
      Reserved7 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCKDIVCR_Type use record
      PCKD      at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PCKC      at 0 range  4 ..  6;
      Reserved2 at 0 range  7 ..  7;
      PCKB      at 0 range  8 .. 10;
      Reserved3 at 0 range 11 .. 11;
      PCKA      at 0 range 12 .. 14;
      Reserved4 at 0 range 15 .. 15;
      BCK       at 0 range 16 .. 18;
      Reserved5 at 0 range 19 .. 23;
      ICK       at 0 range 24 .. 26;
      Reserved6 at 0 range 27 .. 27;
      FCK       at 0 range 28 .. 30;
      Reserved7 at 0 range 31 .. 31;
   end record;

   SCKDIVCR_ADDRESS : constant := 16#4001_E020#;

   SCKDIVCR : aliased SCKDIVCR_Type
      with Address              => System'To_Address (SCKDIVCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.2 System Clock Division Control Register 2 (SCKDIVCR2)

   UCK_DIV3 : constant := 2#010#; -- ×1/3
   UCK_DIV4 : constant := 2#011#; -- ×1/4
   UCK_DIV5 : constant := 2#100#; -- ×1/5.

   type SCKDIVCR2_Type is record
      Reserved1 : Bits_4 := 0;
      UCK       : Bits_3 := UCK_DIV5; -- USB Clock (UCLK) Select
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SCKDIVCR2_Type use record
      Reserved1 at 0 range 0 .. 3;
      UCK       at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   SCKDIVCR2_ADDRESS : constant := 16#4001_E024#;

   SCKDIVCR2 : aliased SCKDIVCR2_Type
      with Address              => System'To_Address (SCKDIVCR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.3 System Clock Source Control Register (SCKSCR)

   CKSEL_HOCO : constant := 2#000#; -- High-speed on-chip oscillator
   CKSEL_MOCO : constant := 2#001#; -- Middle-speed on-chip oscillator
   CKSEL_LOCO : constant := 2#010#; -- Low-speed on-chip oscillator
   CKSEL_MOSC : constant := 2#011#; -- Main clock oscillator
   CKSEL_SOSC : constant := 2#100#; -- Sub-clock oscillator
   CKSEL_PLL  : constant := 2#101#; -- PLL

   type SCKSCR_Type is record
      CKSEL     : Bits_3 := CKSEL_MOCO; -- Clock Source Select
      Reserved1 : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SCKSCR_Type use record
      CKSEL     at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 7;
   end record;

   SCKSCR_ADDRESS : constant := 16#4001_E026#;

   SCKSCR : aliased SCKSCR_Type
      with Address              => System'To_Address (SCKSCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.4 PLL Clock Control Register (PLLCCR)

   PLIDIV_DIV1 : constant := 2#00#;
   PLIDIV_DIV2 : constant := 2#01#;
   PLIDIV_DIV3 : constant := 2#10#;

   PLSRCSEL_MOSC : constant := 2#0#;
   PLSRCSEL_HOCO : constant := 2#1#;

   PLLMUL_x_10_0 : constant := 2#010011#;
   PLLMUL_x_10_5 : constant := 2#010100#;
   PLLMUL_x_11_0 : constant := 2#010101#;
   PLLMUL_x_11_5 : constant := 2#010110#;
   PLLMUL_x_12_0 : constant := 2#010111#;
   PLLMUL_x_12_5 : constant := 2#011000#;
   PLLMUL_x_13_0 : constant := 2#011001#;
   PLLMUL_x_13_5 : constant := 2#011010#;
   PLLMUL_x_14_0 : constant := 2#011011#;
   PLLMUL_x_14_5 : constant := 2#011100#;
   PLLMUL_x_15_0 : constant := 2#011101#;
   PLLMUL_x_15_5 : constant := 2#011110#;
   PLLMUL_x_16_0 : constant := 2#011111#;
   PLLMUL_x_16_5 : constant := 2#100000#;
   PLLMUL_x_17_0 : constant := 2#100001#;
   PLLMUL_x_17_5 : constant := 2#100010#;
   PLLMUL_x_18_0 : constant := 2#100011#;
   PLLMUL_x_18_5 : constant := 2#100100#;
   PLLMUL_x_19_0 : constant := 2#100101#;
   PLLMUL_x_19_5 : constant := 2#100110#;
   PLLMUL_x_20_0 : constant := 2#100111#;
   PLLMUL_x_20_5 : constant := 2#101000#;
   PLLMUL_x_21_0 : constant := 2#101001#;
   PLLMUL_x_21_5 : constant := 2#101010#;
   PLLMUL_x_22_0 : constant := 2#101011#;
   PLLMUL_x_22_5 : constant := 2#101100#;
   PLLMUL_x_23_0 : constant := 2#101101#;
   PLLMUL_x_23_5 : constant := 2#101110#;
   PLLMUL_x_24_0 : constant := 2#101111#;
   PLLMUL_x_24_5 : constant := 2#110000#;
   PLLMUL_x_25_0 : constant := 2#110001#;
   PLLMUL_x_25_5 : constant := 2#110010#;
   PLLMUL_x_26_0 : constant := 2#110011#;
   PLLMUL_x_26_5 : constant := 2#110100#;
   PLLMUL_x_27_0 : constant := 2#110101#;
   PLLMUL_x_27_5 : constant := 2#110110#;
   PLLMUL_x_28_0 : constant := 2#110111#;
   PLLMUL_x_28_5 : constant := 2#111000#;
   PLLMUL_x_29_0 : constant := 2#111001#;
   PLLMUL_x_29_5 : constant := 2#111010#;
   PLLMUL_x_30_0 : constant := 2#111011#;

   type PLLCCR_Type is record
      PLIDIV    : Bits_2 := PLIDIV_DIV1;   -- PLL Input Frequency Division Ratio Select
      Reserved1 : Bits_2 := 0;
      PLSRCSEL  : Bits_1 := PLSRCSEL_MOSC; -- PLL Clock Source Select
      Reserved2 : Bits_3 := 0;
      PLLMUL    : Bits_6 := PLLMUL_x_10_0; -- PLL Frequency Multiplication Factor Select
      Reserved3 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PLLCCR_Type use record
      PLIDIV    at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  3;
      PLSRCSEL  at 0 range  4 ..  4;
      Reserved2 at 0 range  5 ..  7;
      PLLMUL    at 0 range  8 .. 13;
      Reserved3 at 0 range 14 .. 15;
   end record;

   PLLCCR_ADDRESS : constant := 16#4001_E028#;

   PLLCCR : aliased PLLCCR_Type
      with Address              => System'To_Address (PLLCCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.5 PLL Control Register (PLLCR)

   type PLLCR_Type is record
      PLLSTP   : Boolean := True; -- PLL Stop Control
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PLLCR_Type use record
      PLLSTP   at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   PLLCR_ADDRESS : constant := 16#4001_E02A#;

   PLLCR : aliased PLLCR_Type
      with Address              => System'To_Address (PLLCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.6 External Bus Clock Control Register (BCKCR)

   BCLKDIV_DIV1 : constant := 0; -- BCLK
   BCLKDIV_DIV2 : constant := 1; -- BCLK/2.

   type BCKCR_Type is record
      BCLKDIV  : Bits_1 := BCLKDIV_DIV1; -- EBCLK Pin Output Select
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for BCKCR_Type use record
      BCLKDIV  at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   BCKCR_ADDRESS : constant := 16#4001_E030#;

   BCKCR : aliased BCKCR_Type
      with Address              => System'To_Address (BCKCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.7 Main Clock Oscillator Control Register (MOSCCR)

   type MOSCCR_Type is record
      MOSTP    : Boolean := True; -- Main Clock Oscillator Stop
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MOSCCR_Type use record
      MOSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   MOSCCR_ADDRESS : constant := 16#4001_E032#;

   MOSCCR : aliased MOSCCR_Type
      with Address              => System'To_Address (MOSCCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.8 Subclock Oscillator Control Register (SOSCCR)

   type SOSCCR_Type is record
      SOSTP    : Boolean := False; -- Sub-Clock Oscillator Stop
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SOSCCR_Type use record
      SOSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   SOSCCR_ADDRESS : constant := 16#4001_E480#;

   SOSCCR : aliased SOSCCR_Type
      with Address              => System'To_Address (SOSCCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.9 Low-Speed On-Chip Oscillator Control Register (LOCOCR)

   type LOCOCR_Type is record
      LCSTP    : Boolean := False; -- LOCO Stop
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LOCOCR_Type use record
      LCSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   LOCOCR_ADDRESS : constant := 16#4001_E490#;

   LOCOCR : aliased LOCOCR_Type
      with Address              => System'To_Address (LOCOCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.10 High-Speed On-Chip Oscillator Control Register (HOCOCR)

   type HOCOCR_Type is record
      HCSTP    : Boolean;      -- HOCO Stop
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for HOCOCR_Type use record
      HCSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   HOCOCR_ADDRESS : constant := 16#4001_E036#;

   HOCOCR : aliased HOCOCR_Type
      with Address              => System'To_Address (HOCOCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.11 High-Speed On-Chip Oscillator Wait Control Register (HOCOWTCR)

   type HOCOWTCR_Type is record
      HSTS     : Bits_3 := 2#010#; -- HOCO Wait Time Setting
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for HOCOWTCR_Type use record
      HSTS     at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   HOCOWTCR_ADDRESS : constant := 16#4001_E0A5#;

   HOCOWTCR : aliased HOCOWTCR_Type
      with Address              => System'To_Address (HOCOWTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.12 Middle-Speed On-Chip Oscillator Control Register (MOCOCR)

   type MOCOCR_Type is record
      MCSTP    : Boolean := False; -- MOCO Stop
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MOCOCR_Type use record
      MCSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   MOCOCR_ADDRESS : constant := 16#4001_E038#;

   MOCOCR : aliased MOCOCR_Type
      with Address              => System'To_Address (MOCOCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.13 FLL Control Register 1 (FLLCR1)

   type FLLCR1_Type is record
      FLLEN    : Boolean := False; -- FLL Enable
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FLLCR1_Type use record
      FLLEN    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   FLLCR1_ADDRESS : constant := 16#4001_E039#;

   FLLCR1 : aliased FLLCR1_Type
      with Address              => System'To_Address (FLLCR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.14 FLL Control Register 2 (FLLCR2)

   type FLLCR2_Type is record
      FLLCNTL  : Bits_11 := 0; -- FLL Enable
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for FLLCR2_Type use record
      FLLCNTL  at 0 range  0 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   FLLCR2_ADDRESS : constant := 16#4001_E03A#;

   FLLCR2 : aliased FLLCR2_Type
      with Address              => System'To_Address (FLLCR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.15 Oscillation Stabilization Flag Register (OSCSF)

   type OSCSF_Type is record
      HOCOSF    : Boolean; -- HOCO Clock Oscillation Stabilization Flag
      Reserved1 : Bits_2;
      MOSCSF    : Boolean; -- Main Clock Oscillation Stabilization Flag
      Reserved2 : Bits_1;
      PLLSF     : Boolean; -- PLL Clock Oscillation Stabilization Flag
      Reserved3 : Bits_2;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OSCSF_Type use record
      HOCOSF    at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 2;
      MOSCSF    at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      PLLSF     at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 7;
   end record;

   OSCSF_ADDRESS : constant := 16#4001_E03C#;

   OSCSF : aliased OSCSF_Type
      with Address              => System'To_Address (OSCSF_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.16 Oscillation Stop Detection Control Register (OSTDCR)

   type OSTDCR_Type is record
      OSTDIE   : Boolean := False; -- Oscillation Stop Detection Interrupt Enable
      Reserved : Bits_6  := 0;
      OSTDE    : Boolean := False; -- Oscillation Stop Detection Function Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OSTDCR_Type use record
      OSTDIE   at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 6;
      OSTDE    at 0 range 7 .. 7;
   end record;

   OSTDCR_ADDRESS : constant := 16#4001_E040#;

   OSTDCR : aliased OSTDCR_Type
      with Address              => System'To_Address (OSTDCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.17 Oscillation Stop Detection Status Register (OSTDSR)

   type OSTDSR_Type is record
      OSTDF    : Boolean := False; -- Oscillation Stop Detection Flag
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OSTDSR_Type use record
      OSTDF    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   OSTDSR_ADDRESS : constant := 16#4001_E041#;

   OSTDSR : aliased OSTDSR_Type
      with Address              => System'To_Address (OSTDSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;


   -- 9.2.18 Main Clock Oscillator Wait Control Register (MOSCWTCR)

   --                                           MOMCR.AUTODRVEN = 0        MOMCR.AUTODRVEN
   MSTS_1 : constant := 2#0001#; -- Wait time = 35 cycles (133.5 μs)       36 cycles (137.3 μs)
   MSTS_2 : constant := 2#0010#; -- Wait time = 67 cycles (255.6 μs)       68 cycles (259.4 μs)
   MSTS_3 : constant := 2#0011#; -- Wait time = 131 cycles (499.7 μs)      132 cycles (503.5 μs)
   MSTS_4 : constant := 2#0100#; -- Wait time = 259 cycles (988.0 μs)      260 cycles (991.8 μs)
   MSTS_5 : constant := 2#0101#; -- Wait time = 547 cycles (2086.6 μs)     548 cycles (2090.5 μs)
   MSTS_6 : constant := 2#0110#; -- Wait time = 1059 cycles (4039.8 μs)    1060 cycles (4043.6 μs)
   MSTS_7 : constant := 2#0111#; -- Wait time = 2147 cycles (8190.2 μs)    2148 cycles (8194.0 μs)
   MSTS_8 : constant := 2#1000#; -- Wait time = 4291 cycles (16368.9 μs)   4292 cycles (16372.7 μs)
   MSTS_9 : constant := 2#1001#; -- Wait time = 8163 cycles (31139.4 μs).  8164 cycles (31143.2 μs).

   type MOSCWTCR_Type is record
      MSTS      : Bits_4 := MSTS_5; -- Main Clock Oscillator Wait Time Setting
      Reserved  : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MOSCWTCR_Type use record
      MSTS      at 0 range 0 .. 3;
      Reserved  at 0 range 4 .. 7;
   end record;

   MOSCWTCR_ADDRESS : constant := 16#4001_E0A2#;

   MOSCWTCR : aliased MOSCWTCR_Type
      with Address              => System'To_Address (MOSCWTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.2.19 Main Clock Oscillator Mode Oscillation Control Register (MOMCR)

   MODRV_20_24 : constant := 2#00#; -- 20 to 24 MHz
   MODRV_16_20 : constant := 2#01#; -- 16 to 20 MHz
   MODRV_8_16  : constant := 2#10#; -- 8 to 16 MHz
   MODRV_8     : constant := 2#11#; -- 8 MHz

   MOSEL_RES : constant := 0; -- Resonator
   MOSEL_EXT : constant := 1; -- External clock input.

   type MOMCR_Type is record
      Reserved  : Bits_4  := 0;
      MODRV     : Bits_2  := MODRV_20_24; -- Main Clock Oscillator Drive Capability 0 Switching
      MOSEL     : Bits_1  := MOSEL_RES;   -- Main Clock Oscillator Switching
      AUTODRVEN : Boolean := False;       -- PLL Clock Oscillation Stabilization Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MOMCR_Type use record
      Reserved  at 0 range 0 .. 3;
      MODRV     at 0 range 4 .. 5;
      MOSEL     at 0 range 6 .. 6;
      AUTODRVEN at 0 range 7 .. 7;
   end record;

   MOMCR_ADDRESS : constant := 16#4001_E413#;

   MOMCR : aliased MOMCR_Type
      with Address              => System'To_Address (MOMCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 11. Low Power Modes
   ----------------------------------------------------------------------------

   -- 11.2.1 Standby Control Register (SBYCR)

   type SBYCR_Type is record
      Reserved : Bits_14 := 0;
      OPE      : Boolean := True;  -- Output Port Enable
      SSBY     : Boolean := False; -- Software Standby
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for SBYCR_Type use record
      Reserved at 0 range  0 .. 13;
      OPE      at 0 range 14 .. 14;
      SSBY     at 0 range 15 .. 15;
   end record;

   SBYCR_ADDRESS : constant := 16#4001_E00C#;

   SBYCR : aliased SBYCR_Type
      with Address              => System'To_Address (SBYCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.2.2 Module Stop Control Register A (MSTPCRA)

   type MSTPCRA_Type is record
      MSTPA0    : Boolean := False;    -- SRAM0 Module Stop
      MSTPA1    : Boolean := False;    -- SRAM1 Module Stop
      Reserved1 : Bits_3  := 16#07#;
      MSTPA5    : Boolean := False;    -- High-Speed SRAM Module Stop
      MSTPA6    : Boolean := False;    -- ECC SRAM Module Stop
      MSTPA7    : Boolean := False;    -- Standby SRAM Module Stop
      Reserved2 : Bits_14 := 16#3FFF#;
      MSTPA22   : Boolean := False;    -- DMA Controller/Data Transfer Controller Module Stop
      Reserved3 : Bits_9  := 16#1FF#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MSTPCRA_Type use record
      MSTPA0    at 0 range  0 ..  0;
      MSTPA1    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  4;
      MSTPA5    at 0 range  5 ..  5;
      MSTPA6    at 0 range  6 ..  6;
      MSTPA7    at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 21;
      MSTPA22   at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 31;
   end record;

   MSTPCRA_ADDRESS : constant := 16#4001_E01C#;

   MSTPCRA : aliased MSTPCRA_Type
      with Address              => System'To_Address (MSTPCRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.2.3 Module Stop Control Register B (MSTPCRB)

   type MSTPCRB_Type is record
      Reserved1 : Bits_1  := 1;
      MSTPB1    : Boolean := True;  -- Controller Area Network 1 Module Stop
      MSTPB2    : Boolean := True;  -- Controller Area Network 0 Module Stop
      Reserved2 : Bits_2  := 2#11#;
      MSTPB5    : Boolean := True;  -- IrDA Module Stop
      MSTPB6    : Boolean := True;  -- Quad Serial Peripheral Interface Module Stop
      MSTPB7    : Boolean := True;  -- I2C Bus Interface 2 Module Stop
      MSTPB8    : Boolean := True;  -- I2C Bus Interface 1 Module Stop
      MSTPB9    : Boolean := True;  -- I2C Bus Interface 0 Module Stop
      Reserved3 : Bits_1  := 1;
      MSTPB11   : Boolean := True;  -- Universal Serial Bus 2.0 FS Interface Module Stop
      MSTPB12   : Boolean := True;  -- Universal Serial Bus 2.0 HS Interface Module Stop
      MSTPB13   : Boolean := True;  -- EPTPC and PTPEDMAC Module Stop
      Reserved4 : Bits_1  := 1;
      MSTPB15   : Boolean := True;  -- ETHERC0 and EDMAC0 Controller Module Stop
      Reserved5 : Bits_2  := 2#11#;
      MSTPB18   : Boolean := True;  -- Serial Peripheral Interface 1 Module Stop
      MSTPB19   : Boolean := True;  -- Serial Peripheral Interface 0 Module Stop
      Reserved6 : Bits_2  := 2#11#;
      MSTPB22   : Boolean := True;  -- Serial Communication Interface 9 Module Stop
      MSTPB23   : Boolean := True;  -- Serial Communication Interface 8 Module Stop
      MSTPB24   : Boolean := True;  -- Serial Communication Interface 7 Module Stop
      MSTPB25   : Boolean := True;  -- Serial Communication Interface 6 Module Stop
      MSTPB26   : Boolean := True;  -- Serial Communication Interface 5 Module Stop
      MSTPB27   : Boolean := True;  -- Serial Communication Interface 4 Module Stop
      MSTPB28   : Boolean := True;  -- Serial Communication Interface 3 Module Stop
      MSTPB29   : Boolean := True;  -- Serial Communication Interface 2 Module Stop
      MSTPB30   : Boolean := True;  -- Serial Communication Interface 1 Module Stop
      MSTPB31   : Boolean := True;  -- Serial Communication Interface 0 Module Stop
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MSTPCRB_Type use record
      Reserved1 at 0 range  0 ..  0;
      MSTPB1    at 0 range  1 ..  1;
      MSTPB2    at 0 range  2 ..  2;
      Reserved2 at 0 range  3 ..  4;
      MSTPB5    at 0 range  5 ..  5;
      MSTPB6    at 0 range  6 ..  6;
      MSTPB7    at 0 range  7 ..  7;
      MSTPB8    at 0 range  8 ..  8;
      MSTPB9    at 0 range  9 ..  9;
      Reserved3 at 0 range 10 .. 10;
      MSTPB11   at 0 range 11 .. 11;
      MSTPB12   at 0 range 12 .. 12;
      MSTPB13   at 0 range 13 .. 13;
      Reserved4 at 0 range 14 .. 14;
      MSTPB15   at 0 range 15 .. 15;
      Reserved5 at 0 range 16 .. 17;
      MSTPB18   at 0 range 18 .. 18;
      MSTPB19   at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 21;
      MSTPB22   at 0 range 22 .. 22;
      MSTPB23   at 0 range 23 .. 23;
      MSTPB24   at 0 range 24 .. 24;
      MSTPB25   at 0 range 25 .. 25;
      MSTPB26   at 0 range 26 .. 26;
      MSTPB27   at 0 range 27 .. 27;
      MSTPB28   at 0 range 28 .. 28;
      MSTPB29   at 0 range 29 .. 29;
      MSTPB30   at 0 range 30 .. 30;
      MSTPB31   at 0 range 31 .. 31;
   end record;

   MSTPCRB_ADDRESS : constant := 16#4004_7000#;

   MSTPCRB : aliased MSTPCRB_Type
      with Address              => System'To_Address (MSTPCRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.2.4 Module Stop Control Register C (MSTPCRC)

   type MSTPCRC_Type is record
      MSTPC0    : Boolean := True;     -- Clock Frequency Accuracy Measurement Circuit Module Stop
      MSTPC1    : Boolean := True;     -- Cyclic Redundancy Check Calculator Module Stop
      MSTPC2    : Boolean := True;     -- Parallel Data Capture Module Stop
      MSTPC3    : Boolean := True;     -- Capacitive Touch Sensing Unit Module Stop
      MSTPC4    : Boolean := True;     -- Graphics LCD Controller Module Stop
      MSTPC5    : Boolean := True;     -- JPEG Codec Engine Module Stop
      MSTPC6    : Boolean := True;     -- 2D Drawing Engine Module Stop
      MSTPC7    : Boolean := True;     -- Serial Sound Interface Enhanced (channel 1) Module Stop
      MSTPC8    : Boolean := True;     -- Serial Sound Interface Enhanced (channel 0) Module Stop
      MSTPC9    : Boolean := True;     -- Sampling Rate Converter Module Stop
      Reserved1 : Bits_1  := 1;
      MSTPC11   : Boolean := True;     -- Secure Digital Host IF/MultiMediaCard 1 Module Stop
      MSTPC12   : Boolean := True;     -- Secure Digital Host IF/MultiMediaCard 0 Module Stop
      MSTPC13   : Boolean := True;     -- Data Operation Circuit Module Stop
      MSTPC14   : Boolean := True;     -- Event Link Controller Module Stop
      Reserved2 : Bits_1  := 1;
      Reserved3 : Bits_15 := 16#7FFF#;
      MSTPC31   : Boolean := True;     -- SCE7 Module Stop
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MSTPCRC_Type use record
      MSTPC0    at 0 range  0 ..  0;
      MSTPC1    at 0 range  1 ..  1;
      MSTPC2    at 0 range  2 ..  2;
      MSTPC3    at 0 range  3 ..  3;
      MSTPC4    at 0 range  4 ..  4;
      MSTPC5    at 0 range  5 ..  5;
      MSTPC6    at 0 range  6 ..  6;
      MSTPC7    at 0 range  7 ..  7;
      MSTPC8    at 0 range  8 ..  8;
      MSTPC9    at 0 range  9 ..  9;
      Reserved1 at 0 range 10 .. 10;
      MSTPC11   at 0 range 11 .. 11;
      MSTPC12   at 0 range 12 .. 12;
      MSTPC13   at 0 range 13 .. 13;
      MSTPC14   at 0 range 14 .. 14;
      Reserved2 at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 30;
      MSTPC31   at 0 range 31 .. 31;
   end record;

   MSTPCRC_ADDRESS : constant := 16#4004_7004#;

   MSTPCRC : aliased MSTPCRC_Type
      with Address              => System'To_Address (MSTPCRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 11.2.5 Module Stop Control Register D (MSTPCRD)

   type MSTPCRD_Type is record
      Reserved1 : Bits_2  := 2#11#;
      MSTPD2    : Boolean := True;   -- Asynchronous General Purpose Timer 1 Module Stop
      MSTPD3    : Boolean := True;   -- Asynchronous General Purpose Timer 0 Module Stop
      Reserved2 : Bits_1  := 1;
      MSTPD5    : Boolean := True;   -- General PWM Timer 32EH0 to 32EH3 and 32E4 to 32E7 and PWM Delay Gen Circuit Module Stop
      MSTPD6    : Boolean := True;   -- General PWM Timer 328 to 3213 Module Stop
      Reserved3 : Bits_7  := 16#7F#;
      MSTPD14   : Boolean := True;   -- Port Output Enable for GPT Module Stop
      MSTPD15   : Boolean := True;   -- 12-Bit A/D Converter 1 Module Stop
      MSTPD16   : Boolean := True;   -- 12-Bit A/D Converter 0 Module Stop
      Reserved4 : Bits_3  := 16#7#;
      MSTPD20   : Boolean := True;   -- 12-Bit D/A Converter Module Stop
      Reserved5 : Bits_1  := 1;
      MSTPD22   : Boolean := True;   -- Temperature Sensor Module Stop
      MSTPD23   : Boolean := True;   -- High-Speed Analog Comparator 5 Module Stop
      MSTPD24   : Boolean := True;   -- High-Speed Analog Comparator 4 Module Stop
      MSTPD25   : Boolean := True;   -- High-Speed Analog Comparator 3 Module Stop
      MSTPD26   : Boolean := True;   -- High-Speed Analog Comparator 2 Module Stop
      MSTPD27   : Boolean := True;   -- High-Speed Analog Comparator 1 Module Stop
      MSTPD28   : Boolean := True;   -- High-Speed Analog Comparator 0 Module Stop
      Reserved6 : Bits_3  := 16#7#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MSTPCRD_Type use record
      Reserved1 at 0 range  0 ..  1;
      MSTPD2    at 0 range  2 ..  2;
      MSTPD3    at 0 range  3 ..  3;
      Reserved2 at 0 range  4 ..  4;
      MSTPD5    at 0 range  5 ..  5;
      MSTPD6    at 0 range  6 ..  6;
      Reserved3 at 0 range  7 .. 13;
      MSTPD14   at 0 range 14 .. 14;
      MSTPD15   at 0 range 15 .. 15;
      MSTPD16   at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 19;
      MSTPD20   at 0 range 20 .. 20;
      Reserved5 at 0 range 21 .. 21;
      MSTPD22   at 0 range 22 .. 22;
      MSTPD23   at 0 range 23 .. 23;
      MSTPD24   at 0 range 24 .. 24;
      MSTPD25   at 0 range 25 .. 25;
      MSTPD26   at 0 range 26 .. 26;
      MSTPD27   at 0 range 27 .. 27;
      MSTPD28   at 0 range 28 .. 28;
      Reserved6 at 0 range 29 .. 31;
   end record;

   MSTPCRD_ADDRESS : constant := 16#4004_7008#;

   MSTPCRD : aliased MSTPCRD_Type
      with Address              => System'To_Address (MSTPCRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 13. Register Write Protection
   ----------------------------------------------------------------------------

   -- 13.2.1 Protect Register (PRCR)

   PRCR_KEY_CODE : constant := 16#A5#;

   type PRCR_Type is record
      PRC0      : Boolean    := False; -- Protect Bit 0
      PRC1      : Boolean    := False; -- Protect Bit 1
      Reserved1 : Bits_1     := 0;
      PRC3      : Boolean    := False; -- Protect Bit 3
      Reserved2 : Bits_4     := 0;
      PRKEY     : Unsigned_8 := 0;     -- PRC Key Code
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PRCR_Type use record
      PRC0      at 0 range 0 ..  0;
      PRC1      at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  2;
      PRC3      at 0 range 3 ..  3;
      Reserved2 at 0 range 4 ..  7;
      PRKEY     at 0 range 8 .. 15;
   end record;

   PRCR_ADDRESS : constant := 16#4001_E3FE#;

   PRCR : aliased PRCR_Type
      with Address              => System'To_Address (PRCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 14. Interrupt Controller Unit (ICU)
   ----------------------------------------------------------------------------

   -- 14.2.1 IRQ Control Register i (IRQCRi) (i = 0 to 15)

   IRQMD_EDGEFALL : constant := 2#00#; -- Falling edge
   IRQMD_EDGERISE : constant := 2#01#; -- Rising edge
   IRQMD_EDGEBOTH : constant := 2#10#; -- Rising and falling edges
   IRQMD_LOW      : constant := 2#11#; -- Low level.

   FCLKSEL_DIV1  : constant := 2#00#; -- PCLKB
   FCLKSEL_DIV8  : constant := 2#01#; -- PCLKB/8
   FCLKSEL_DIV32 : constant := 2#10#; -- PCLKB/32
   FCLKSEL_DIV64 : constant := 2#11#; -- PCLKB/64.

   type IRQCR_Type is record
      IRQMD     : Bits_2  := IRQMD_EDGEFALL; -- IRQi Detection Sense Select
      Reserved1 : Bits_2  := 0;
      FCLKSEL   : Bits_2  := FCLKSEL_DIV1;   -- IRQi Digital Filter Sampling Clock Select
      Reserved2 : Bits_1  := 0;
      FLTEN     : Boolean := False;          -- IRQi Digital Filter Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 8,
           Volatile_Full_Access => True;
   for IRQCR_Type use record
      IRQMD     at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      FCLKSEL   at 0 range 4 .. 5;
      Reserved2 at 0 range 6 .. 6;
      FLTEN     at 0 range 7 .. 7;
   end record;

   -- 14.2.2 Non-Maskable Interrupt Status Register (NMISR)

   type NMISR_Type is record
      IWDTST    : Boolean := False; -- IWDT Underflow/Refresh Error Status Flag
      WDTST     : Boolean := False; -- WDT Underflow/Refresh Error Status Flag
      LVD1ST    : Boolean := False; -- Voltage Monitor 1 Interrupt Status Flag
      LVD2ST    : Boolean := False; -- Voltage Monitor 2 Interrupt Status Flag
      Reserved1 : Bits_2  := 0;
      OSTST     : Boolean := False; -- Main Oscillation Stop Detection Interrupt Status Flag
      NMIST     : Boolean := False; -- NMI Status Flag
      RPEST     : Boolean := False; -- SRAM Parity Error Interrupt Status Flag
      RECCST    : Boolean := False; -- SRAM ECC Error Interrupt Status Flag
      BUSSST    : Boolean := False; -- MPU Bus Slave Error Interrupt Status Flag
      BUSMST    : Boolean := False; -- MPU Bus Master Error Interrupt Status Flag
      SPEST     : Boolean := False; -- CPU Stack Pointer Monitor Interrupt Status Flag
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for NMISR_Type use record
      IWDTST    at 0 range  0 ..  0;
      WDTST     at 0 range  1 ..  1;
      LVD1ST    at 0 range  2 ..  2;
      LVD2ST    at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  5;
      OSTST     at 0 range  6 ..  6;
      NMIST     at 0 range  7 ..  7;
      RPEST     at 0 range  8 ..  8;
      RECCST    at 0 range  9 ..  9;
      BUSSST    at 0 range 10 .. 10;
      BUSMST    at 0 range 11 .. 11;
      SPEST     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.3 Non-Maskable Interrupt Enable Register (NMIER)

   type NMIER_Type is record
      IWDTEN    : Boolean := False; -- IWDT Underflow/Refresh Error Interrupt Enable
      WDTEN     : Boolean := False; -- WDT Underflow/Refresh Error Interrupt Enable
      LVD1EN    : Boolean := False; -- Voltage Monitor 1 Interrupt Enable
      LVD2EN    : Boolean := False; -- Voltage Monitor 2 Interrupt Enable
      Reserved1 : Bits_2  := 0;
      OSTEN     : Boolean := False; -- Main Oscillation Stop Detection Interrupt Enable
      NMIEN     : Boolean := False; -- NMI Interrupt Enable
      RPEEN     : Boolean := False; -- SRAM Parity Error Interrupt Enable
      RECCEN    : Boolean := False; -- SRAM ECC Error Interrupt Enable
      BUSSEN    : Boolean := False; -- MPU Bus Slave Error Interrupt Enable
      BUSMEN    : Boolean := False; -- MPU Bus Master Error Interrupt Enable
      SPEEN     : Boolean := False; -- CPU Stack Pointer Monitor Interrupt Enable
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for NMIER_Type use record
      IWDTEN    at 0 range  0 ..  0;
      WDTEN     at 0 range  1 ..  1;
      LVD1EN    at 0 range  2 ..  2;
      LVD2EN    at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  5;
      OSTEN     at 0 range  6 ..  6;
      NMIEN     at 0 range  7 ..  7;
      RPEEN     at 0 range  8 ..  8;
      RECCEN    at 0 range  9 ..  9;
      BUSSEN    at 0 range 10 .. 10;
      BUSMEN    at 0 range 11 .. 11;
      SPEEN     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.4 Non-Maskable Interrupt Status Clear Register (NMICLR)

   type NMICLR_Type is record
      IWDTCLR   : Boolean := False; -- IWDT Clear
      WDTCLR    : Boolean := False; -- WDT Clear
      LVD1CLR   : Boolean := False; -- LVD1 Clear
      LVD2CLR   : Boolean := False; -- LVD2 Clear
      Reserved1 : Bits_2  := 0;
      OSTCLR    : Boolean := False; -- OSR Clear
      NMICLR    : Boolean := False; -- NMI Clear
      RPECLR    : Boolean := False; -- SRAM Parity Error Clear
      RECCCLR   : Boolean := False; -- SRAM ECC Error Clear
      BUSSCLR   : Boolean := False; -- Bus Slave Error Clear
      BUSMCLR   : Boolean := False; -- Bus Master Error Clear
      SPECLR    : Boolean := False; -- CPU Stack Pointer Monitor Interrupt Clear
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for NMICLR_Type use record
      IWDTCLR   at 0 range  0 ..  0;
      WDTCLR    at 0 range  1 ..  1;
      LVD1CLR   at 0 range  2 ..  2;
      LVD2CLR   at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  5;
      OSTCLR    at 0 range  6 ..  6;
      NMICLR    at 0 range  7 ..  7;
      RPECLR    at 0 range  8 ..  8;
      RECCCLR   at 0 range  9 ..  9;
      BUSSCLR   at 0 range 10 .. 10;
      BUSMCLR   at 0 range 11 .. 11;
      SPECLR    at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.5 NMI Pin Interrupt Control Register (NMICR)

   NMIMD_FALL : constant := 0; -- Falling edge
   NMIMD_RISE : constant := 1; -- Rising edge.

   NFCLKSEL_DIV1  : constant := 2#00#; -- PCLKB
   NFCLKSEL_DIV8  : constant := 2#01#; -- PCLKB/8
   NFCLKSEL_DIV32 : constant := 2#10#; -- PCLKB/32
   NFCLKSEL_DIV64 : constant := 2#11#; -- PCLKB/64.

   type NMICR_Type is record
      NMIMD     : Bits_1  := NMIMD_FALL;    -- NMI Detection Set
      Reserved1 : Bits_3  := 0;
      NFCLKSEL  : Bits_2  := NFCLKSEL_DIV1; -- NMI Digital Filter Sampling Clock Select
      Reserved2 : Bits_1  := 0;
      NFLTEN    : Boolean := False;         -- NMI Digital Filter Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for NMICR_Type use record
      NMIMD     at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      NFCLKSEL  at 0 range 4 .. 5;
      Reserved2 at 0 range 6 .. 6;
      NFLTEN    at 0 range 7 .. 7;
   end record;

   -- 14.2.6 ICU Event Link Setting Register n (IELSRn) (n = 0 to 95)

   IELS_DISABLE : constant := 0; -- Disable interrupts to the associated NVIC or DTC module

   type IELSR_Type is record
      IELS      : Bits_9  := IELS_DISABLE; -- ICU Event Link Select
      Reserved1 : Bits_7  := 0;
      IR        : Boolean := False;        -- Interrupt Status Flag
      Reserved2 : Bits_7  := 0;
      DTCE      : Boolean := False;        -- DTC Activation Enable
      Reserved3 : Bits_7  := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for IELSR_Type use record
      IELS      at 0 range  0 ..  8;
      Reserved1 at 0 range  9 .. 15;
      IR        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 23;
      DTCE      at 0 range 24 .. 24;
      Reserved3 at 0 range 25 .. 31;
   end record;

   -- 14.2.7 DMAC Event Link Setting Register n (DELSRn) (n = 0 to 7)

   DELS_DISABLE : constant := 0; -- Disable DMA start requests to the associated DMAC module

   type DELSR_Type is record
      DELS      : Bits_9  := DELS_DISABLE; -- DMAC Event Link Select
      Reserved1 : Bits_7  := 0;
      IR        : Boolean := False;        -- Interrupt Status Flag for DMAC
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for DELSR_Type use record
      DELS      at 0 range  0 ..  8;
      Reserved1 at 0 range  9 .. 15;
      IR        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   -- 14.2.8 SYS Event Link Setting Register (SELSR0)

   SELS_DISABLE : constant := 0; -- Disable event output to the associated low power mode module

   type SELSR0_Type is record
      SELS     : Bits_9 := SELS_DISABLE; -- SYS Event Link Select
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for SELSR0_Type use record
      SELS     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 15;
   end record;

   -- 14.2.9 Wake Up Interrupt Enable Register (WUPEN)

   type WUPEN_Type is record
      IRQWUPEN     : Bitmap_16 := [others => False]; -- IRQ Interrupt Software Standby Returns Enable
      IWDTWUPEN    : Boolean   := False;             -- IWDT Interrupt Software Standby Returns Enable
      KEYWUPEN     : Boolean   := False;             -- Key Interrupt Software Standby Returns Enable
      LVD1WUPEN    : Boolean   := False;             -- LVD1 Interrupt Software Standby Returns Enable
      LVD2WUPEN    : Boolean   := False;             -- LVD2 Interrupt Software Standby Returns Enable
      Reserved1    : Bits_2    := 0;
      ACMPHS0WUPEN : Boolean   := False;             -- ACMPHS0 Interrupt Software Standby Returns Enable
      Reserved2    : Bits_1    := 0;
      RTCALMWUPEN  : Boolean   := False;             -- RTC Alarm Interrupt Software Standby Returns Enable
      RTCPRDWUPEN  : Boolean   := False;             -- RTC Period Interrupt Software Standby Returns Enable
      USBHSWUPEN   : Boolean   := False;             -- USBHS Interrupt Software Standby Returns Enable
      USBFSWUPEN   : Boolean   := False;             -- USBFS Interrupt Software Standby Returns Enable
      AGT1UDWUPEN  : Boolean   := False;             -- AGT1 Underflow Interrupt Software Standby Returns Enable
      AGT1CAWUPEN  : Boolean   := False;             -- AGT1 Compare Match A Interrupt Software Standby Returns Enable
      AGT1CBWUPEN  : Boolean   := False;             -- AGT1 Compare Match B Interrupt Software Standby Returns Enable
      IIC0WUPEN    : Boolean   := False;             -- IIC0 Address Match Interrupt Software Standby Returns Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for WUPEN_Type use record
      IRQWUPEN     at 0 range  0 .. 15;
      IWDTWUPEN    at 0 range 16 .. 16;
      KEYWUPEN     at 0 range 17 .. 17;
      LVD1WUPEN    at 0 range 18 .. 18;
      LVD2WUPEN    at 0 range 19 .. 19;
      Reserved1    at 0 range 20 .. 21;
      ACMPHS0WUPEN at 0 range 22 .. 22;
      Reserved2    at 0 range 23 .. 23;
      RTCALMWUPEN  at 0 range 24 .. 24;
      RTCPRDWUPEN  at 0 range 25 .. 25;
      USBHSWUPEN   at 0 range 26 .. 26;
      USBFSWUPEN   at 0 range 27 .. 27;
      AGT1UDWUPEN  at 0 range 28 .. 28;
      AGT1CAWUPEN  at 0 range 29 .. 29;
      AGT1CBWUPEN  at 0 range 30 .. 30;
      IIC0WUPEN    at 0 range 31 .. 31;
   end record;

   -- 14.3.2 Event Numbers

   EVENT_NONE          : constant := 16#000#;
   PORT_IRQ0           : constant := 16#001#;
   PORT_IRQ1           : constant := 16#002#;
   PORT_IRQ2           : constant := 16#003#;
   PORT_IRQ3           : constant := 16#004#;
   PORT_IRQ4           : constant := 16#005#;
   PORT_IRQ5           : constant := 16#006#;
   PORT_IRQ6           : constant := 16#007#;
   PORT_IRQ7           : constant := 16#008#;
   PORT_IRQ8           : constant := 16#009#;
   PORT_IRQ9           : constant := 16#00A#;
   PORT_IRQ10          : constant := 16#00B#;
   PORT_IRQ11          : constant := 16#00C#;
   PORT_IRQ12          : constant := 16#00D#;
   PORT_IRQ13          : constant := 16#00E#;
   PORT_IRQ14          : constant := 16#00F#;
   PORT_IRQ15          : constant := 16#010#;
   DMAC0_INT           : constant := 16#020#;
   DMAC1_INT           : constant := 16#021#;
   DMAC2_INT           : constant := 16#022#;
   DMAC3_INT           : constant := 16#023#;
   DMAC4_INT           : constant := 16#024#;
   DMAC5_INT           : constant := 16#025#;
   DMAC6_INT           : constant := 16#026#;
   DMAC7_INT           : constant := 16#027#;
   DTC_COMPLETE        : constant := 16#029#;
   ICU_SNZCANCEL       : constant := 16#02D#;
   FCU_FIFERR          : constant := 16#030#;
   FCU_FRDYI           : constant := 16#031#;
   LVD_LVD1            : constant := 16#038#;
   LVD_LVD2            : constant := 16#039#;
   MOSC_STOP           : constant := 16#03B#;
   SYSTEM_SNZREQ       : constant := 16#03C#;
   AGT0_AGTI           : constant := 16#040#;
   AGT0_AGTCMAI        : constant := 16#041#;
   AGT0_AGTCMBI        : constant := 16#042#;
   AGT1_AGTI           : constant := 16#043#;
   AGT1_AGTCMAI        : constant := 16#044#;
   AGT1_AGTCMBI        : constant := 16#045#;
   IWDT_NMIUNDF        : constant := 16#046#;
   WDT_NMIUNDF         : constant := 16#047#;
   RTC_ALM             : constant := 16#048#;
   RTC_PRD             : constant := 16#049#;
   RTC_CUP             : constant := 16#04A#;
   ADC120_ADI          : constant := 16#04B#;
   ADC120_GBADI        : constant := 16#04C#;
   ADC120_CMPAI        : constant := 16#04D#;
   ADC120_CMPBI        : constant := 16#04E#;
   ADC120_WCMPM        : constant := 16#04F#;
   ADC120_WCMPUM       : constant := 16#050#;
   ADC121_ADI          : constant := 16#051#;
   ADC121_GBADI        : constant := 16#052#;
   ADC121_CMPAI        : constant := 16#053#;
   ADC121_CMPBI        : constant := 16#054#;
   ADC121_WCMPM        : constant := 16#055#;
   ADC121_WCMPUM       : constant := 16#056#;
   ACMP_HS0            : constant := 16#057#;
   ACMP_HS1            : constant := 16#058#;
   ACMP_HS2            : constant := 16#059#;
   ACMP_HS3            : constant := 16#05A#;
   ACMP_HS4            : constant := 16#05B#;
   ACMP_HS5            : constant := 16#05C#;
   USBFS_D0FIFO        : constant := 16#05F#;
   USBFS_D1FIFO        : constant := 16#060#;
   USBFS_USBI          : constant := 16#061#;
   USBFS_USBR          : constant := 16#062#;
   IIC0_RXI            : constant := 16#063#;
   IIC0_TXI            : constant := 16#064#;
   IIC0_TEI            : constant := 16#065#;
   IIC0_EEI            : constant := 16#066#;
   IIC0_WUI            : constant := 16#067#;
   IIC1_RXI            : constant := 16#068#;
   IIC1_TXI            : constant := 16#069#;
   IIC1_TEI            : constant := 16#06A#;
   IIC1_EEI            : constant := 16#06B#;
   IIC2_RXI            : constant := 16#06D#;
   IIC2_TXI            : constant := 16#06E#;
   IIC2_TEI            : constant := 16#06F#;
   IIC2_EEI            : constant := 16#070#;
   SSIE0_SSITXI        : constant := 16#072#;
   SSIE0_SSIRXI        : constant := 16#073#;
   SSIE0_SSIF          : constant := 16#075#;
   SSIE1_SSIRT         : constant := 16#078#;
   SSIE1_SSIF          : constant := 16#079#;
   SRC_IDEI            : constant := 16#07A#;
   SRC_ODFI            : constant := 16#07B#;
   SRC_OVFI            : constant := 16#07C#;
   SRC_UDFI            : constant := 16#07D#;
   SRC_CEFI            : constant := 16#07E#;
   PDC_PCDFI           : constant := 16#07F#;
   PDC_PCFEI           : constant := 16#080#;
   PDC_PCERI           : constant := 16#081#;
   CTSU_CTSUWR         : constant := 16#082#;
   CTSU_CTSURD         : constant := 16#083#;
   CTSU_CTSUFN         : constant := 16#084#;
   KEY_INTKR           : constant := 16#085#;
   DOC_DOPCI           : constant := 16#086#;
   CAC_FERRI           : constant := 16#087#;
   CAC_MENDI           : constant := 16#088#;
   CAC_OVFI            : constant := 16#089#;
   CAN0_ERS            : constant := 16#08A#;
   CAN0_RXF            : constant := 16#08B#;
   CAN0_TXF            : constant := 16#08C#;
   CAN0_RXM            : constant := 16#08D#;
   CAN0_TXM            : constant := 16#08E#;
   CAN1_ERS            : constant := 16#08F#;
   CAN1_RXF            : constant := 16#090#;
   CAN1_TXF            : constant := 16#091#;
   CAN1_RXM            : constant := 16#092#;
   CAN1_TXM            : constant := 16#093#;
   IOPORT_GROUP1       : constant := 16#094#;
   IOPORT_GROUP2       : constant := 16#095#;
   IOPORT_GROUP3       : constant := 16#096#;
   IOPORT_GROUP4       : constant := 16#097#;
   ELC_SWEVT0          : constant := 16#098#;
   ELC_SWEVT1          : constant := 16#099#;
   POEG_GROUP0         : constant := 16#09A#;
   POEG_GROUP1         : constant := 16#09B#;
   POEG_GROUP2         : constant := 16#09C#;
   POEG_GROUP3         : constant := 16#09D#;
   GPT0_CCMPA          : constant := 16#0B0#;
   GPT0_CCMPB          : constant := 16#0B1#;
   GPT0_CMPC           : constant := 16#0B2#;
   GPT0_CMPD           : constant := 16#0B3#;
   GPT0_CMPE           : constant := 16#0B4#;
   GPT0_CMPF           : constant := 16#0B5#;
   GPT0_OVF            : constant := 16#0B6#;
   GPT0_UDF            : constant := 16#0B7#;
   GPT0_ADTRGA         : constant := 16#0B8#;
   GPT0_ADTRGB         : constant := 16#0B9#;
   GPT1_CCMPA          : constant := 16#0BA#;
   GPT1_CCMPB          : constant := 16#0BB#;
   GPT1_CMPC           : constant := 16#0BC#;
   GPT1_CMPD           : constant := 16#0BD#;
   GPT1_CMPE           : constant := 16#0BE#;
   GPT1_CMPF           : constant := 16#0BF#;
   GPT1_OVF            : constant := 16#0C0#;
   GPT1_UDF            : constant := 16#0C1#;
   GPT1_ADTRGA         : constant := 16#0C2#;
   GPT1_ADTRGB         : constant := 16#0C3#;
   GPT2_CCMPA          : constant := 16#0C4#;
   GPT2_CCMPB          : constant := 16#0C5#;
   GPT2_CMPC           : constant := 16#0C6#;
   GPT2_CMPD           : constant := 16#0C7#;
   GPT2_CMPE           : constant := 16#0C8#;
   GPT2_CMPF           : constant := 16#0C9#;
   GPT2_OVF            : constant := 16#0CA#;
   GPT2_UDF            : constant := 16#0CB#;
   GPT2_ADTRGA         : constant := 16#0CC#;
   GPT2_ADTRGB         : constant := 16#0CD#;
   GPT3_CCMPA          : constant := 16#0CE#;
   GPT3_CCMPB          : constant := 16#0CF#;
   GPT3_CMPC           : constant := 16#0D0#;
   GPT3_CMPD           : constant := 16#0D1#;
   GPT3_CMPE           : constant := 16#0D2#;
   GPT3_CMPF           : constant := 16#0D3#;
   GPT3_OVF            : constant := 16#0D4#;
   GPT3_UDF            : constant := 16#0D5#;
   GPT3_ADTRGA         : constant := 16#0D6#;
   GPT3_ADTRGB         : constant := 16#0D7#;
   GPT4_CCMPA          : constant := 16#0D8#;
   GPT4_CCMPB          : constant := 16#0D9#;
   GPT4_CMPC           : constant := 16#0DA#;
   GPT4_CMPD           : constant := 16#0DB#;
   GPT4_CMPE           : constant := 16#0DC#;
   GPT4_CMPF           : constant := 16#0DD#;
   GPT4_OVF            : constant := 16#0DE#;
   GPT4_UDF            : constant := 16#0DF#;
   GPT4_ADTRGA         : constant := 16#0E0#;
   GPT4_ADTRGB         : constant := 16#0E1#;
   GPT5_CCMPA          : constant := 16#0E2#;
   GPT5_CCMPB          : constant := 16#0E3#;
   GPT5_CMPC           : constant := 16#0E4#;
   GPT5_CMPD           : constant := 16#0E5#;
   GPT5_CMPE           : constant := 16#0E6#;
   GPT5_CMPF           : constant := 16#0E7#;
   GPT5_OVF            : constant := 16#0E8#;
   GPT5_UDF            : constant := 16#0E9#;
   GPT5_ADTRGA         : constant := 16#0EA#;
   GPT5_ADTRGB         : constant := 16#0EB#;
   GPT6_CCMPA          : constant := 16#0EC#;
   GPT6_CCMPB          : constant := 16#0ED#;
   GPT6_CMPC           : constant := 16#0EE#;
   GPT6_CMPD           : constant := 16#0EF#;
   GPT6_CMPE           : constant := 16#0F0#;
   GPT6_CMPF           : constant := 16#0F1#;
   GPT6_OVF            : constant := 16#0F2#;
   GPT6_UDF            : constant := 16#0F3#;
   GPT6_ADTRGA         : constant := 16#0F4#;
   GPT6_ADTRGB         : constant := 16#0F5#;
   GPT7_CCMPA          : constant := 16#0F6#;
   GPT7_CCMPB          : constant := 16#0F7#;
   GPT7_CMPC           : constant := 16#0F8#;
   GPT7_CMPD           : constant := 16#0F9#;
   GPT7_CMPE           : constant := 16#0FA#;
   GPT7_CMPF           : constant := 16#0FB#;
   GPT7_OVF            : constant := 16#0FC#;
   GPT7_UDF            : constant := 16#0FD#;
   GPT7_ADTRGA         : constant := 16#0FE#;
   GPT7_ADTRGB         : constant := 16#0FF#;
   GPT8_CCMPA          : constant := 16#100#;
   GPT8_CCMPB          : constant := 16#101#;
   GPT8_CMPC           : constant := 16#102#;
   GPT8_CMPD           : constant := 16#103#;
   GPT8_CMPE           : constant := 16#104#;
   GPT8_CMPF           : constant := 16#105#;
   GPT8_OVF            : constant := 16#106#;
   GPT8_UDF            : constant := 16#107#;
   GPT9_CCMPA          : constant := 16#10A#;
   GPT9_CCMPB          : constant := 16#10B#;
   GPT9_CMPC           : constant := 16#10C#;
   GPT9_CMPD           : constant := 16#10D#;
   GPT9_CMPE           : constant := 16#10E#;
   GPT9_CMPF           : constant := 16#10F#;
   GPT9_OVF            : constant := 16#110#;
   GPT9_UDF            : constant := 16#111#;
   GPT10_CCMPA         : constant := 16#114#;
   GPT10_CCMPB         : constant := 16#115#;
   GPT10_CMPC          : constant := 16#116#;
   GPT10_CMPD          : constant := 16#117#;
   GPT10_CMPE          : constant := 16#118#;
   GPT10_CMPF          : constant := 16#119#;
   GPT10_OVF           : constant := 16#11A#;
   GPT10_UDF           : constant := 16#11B#;
   GPT11_CCMPA         : constant := 16#11E#;
   GPT11_CCMPB         : constant := 16#11F#;
   GPT11_CMPC          : constant := 16#120#;
   GPT11_CMPD          : constant := 16#121#;
   GPT11_CMPE          : constant := 16#122#;
   GPT11_CMPF          : constant := 16#123#;
   GPT11_OVF           : constant := 16#124#;
   GPT11_UDF           : constant := 16#125#;
   GPT12_CCMPA         : constant := 16#128#;
   GPT12_CCMPB         : constant := 16#129#;
   GPT12_CMPC          : constant := 16#12A#;
   GPT12_CMPD          : constant := 16#12B#;
   GPT12_CMPE          : constant := 16#12C#;
   GPT12_CMPF          : constant := 16#12D#;
   GPT12_OVF           : constant := 16#12E#;
   GPT12_UDF           : constant := 16#12F#;
   GPT13_CCMPA         : constant := 16#132#;
   GPT13_CCMPB         : constant := 16#133#;
   GPT13_CMPC          : constant := 16#134#;
   GPT13_CMPD          : constant := 16#135#;
   GPT13_CMPE          : constant := 16#136#;
   GPT13_CMPF          : constant := 16#137#;
   GPT13_OVF           : constant := 16#138#;
   GPT13_UDF           : constant := 16#139#;
   GPT_UVWEDGE         : constant := 16#150#;
   ETHER_IPLS          : constant := 16#160#;
   ETHER_MINT          : constant := 16#161#;
   ETHER_PINT          : constant := 16#162#;
   ETHER_EINT0         : constant := 16#163#;
   USBHS_D0FIFO        : constant := 16#171#;
   USBHS_D1FIFO        : constant := 16#172#;
   USBHS_USBIR         : constant := 16#173#;
   SCI0_RXI            : constant := 16#174#;
   SCI0_TXI            : constant := 16#175#;
   SCI0_TEI            : constant := 16#176#;
   SCI0_ERI            : constant := 16#177#;
   SCI0_AM             : constant := 16#178#;
   SCI0_RXI_OR_ERI     : constant := 16#179#;
   SCI1_RXI            : constant := 16#17A#;
   SCI1_TXI            : constant := 16#17B#;
   SCI1_TEI            : constant := 16#17C#;
   SCI1_ERI            : constant := 16#17D#;
   SCI1_AM             : constant := 16#17E#;
   SCI2_RXI            : constant := 16#180#;
   SCI2_TXI            : constant := 16#181#;
   SCI2_TEI            : constant := 16#182#;
   SCI2_ERI            : constant := 16#183#;
   SCI2_AM             : constant := 16#184#;
   SCI3_RXI            : constant := 16#186#;
   SCI3_TXI            : constant := 16#187#;
   SCI3_TEI            : constant := 16#188#;
   SCI3_ERI            : constant := 16#189#;
   SCI3_AM             : constant := 16#18A#;
   SCI4_RXI            : constant := 16#18C#;
   SCI4_TXI            : constant := 16#18D#;
   SCI4_TEI            : constant := 16#18E#;
   SCI4_ERI            : constant := 16#18F#;
   SCI4_AM             : constant := 16#190#;
   SCI5_RXI            : constant := 16#192#;
   SCI5_TXI            : constant := 16#193#;
   SCI5_TEI            : constant := 16#194#;
   SCI5_ERI            : constant := 16#195#;
   SCI5_AM             : constant := 16#196#;
   SCI6_RXI            : constant := 16#198#;
   SCI6_TXI            : constant := 16#199#;
   SCI6_TEI            : constant := 16#19A#;
   SCI6_ERI            : constant := 16#19B#;
   SCI6_AM             : constant := 16#19C#;
   SCI7_RXI            : constant := 16#19E#;
   SCI7_TXI            : constant := 16#19F#;
   SCI7_TEI            : constant := 16#1A0#;
   SCI7_ERI            : constant := 16#1A1#;
   SCI7_AM             : constant := 16#1A2#;
   SCI8_RXI            : constant := 16#1A4#;
   SCI8_TXI            : constant := 16#1A5#;
   SCI8_TEI            : constant := 16#1A6#;
   SCI8_ERI            : constant := 16#1A7#;
   SCI8_AM             : constant := 16#1A8#;
   SCI9_RXI            : constant := 16#1AA#;
   SCI9_TXI            : constant := 16#1AB#;
   SCI9_TEI            : constant := 16#1AC#;
   SCI9_ERI            : constant := 16#1AD#;
   SCI9_AM             : constant := 16#1AE#;
   SPI0_SPRI           : constant := 16#1BC#;
   SPI0_SPTI           : constant := 16#1BD#;
   SPI0_SPII           : constant := 16#1BE#;
   SPI0_SPEI           : constant := 16#1BF#;
   SPI0_SPTEND         : constant := 16#1C0#;
   SPI1_SPRI           : constant := 16#1C1#;
   SPI1_SPTI           : constant := 16#1C2#;
   SPI1_SPII           : constant := 16#1C3#;
   SPI1_SPEI           : constant := 16#1C4#;
   SPI1_SPTEND         : constant := 16#1C5#;
   QSPI_INTR           : constant := 16#1C6#;
   SDHI_MMC0_ACCS      : constant := 16#1C7#;
   SDHI_MMC0_SDIO      : constant := 16#1C8#;
   SDHI_MMC0_CARD      : constant := 16#1C9#;
   SDHI_MMC0_ODMSDBREQ : constant := 16#1CA#;
   SDHI_MMC1_ACCS      : constant := 16#1CB#;
   SDHI_MMC1_SDIO      : constant := 16#1CC#;
   SDHI_MMC1_CARD      : constant := 16#1CD#;
   SDHI_MMC1_ODMSDBREQ : constant := 16#1CE#;
   GLCDC_VPOS          : constant := 16#1FA#;
   GLCDC_L1UNDF        : constant := 16#1FB#;
   GLCDC_L2UNDF        : constant := 16#1FC#;
   DRW_IRQ             : constant := 16#1FD#;
   JPEG_JEDI           : constant := 16#1FE#;
   JPEG_JDTI           : constant := 16#1FF#;

   -- ICU layout

   type IRQCR_Array_Type is array (0 .. 15) of IRQCR_Type
      with Pack => True;
   type IELSR_Array_Type is array (0 .. 95) of IELSR_Type
      with Pack => True;
   type DELSR_Array_Type is array (0 .. 7) of DELSR_Type
      with Pack => True;

pragma Warnings (Off);
   type ICU_Type is record
      IRQCR  : IRQCR_Array_Type;
      NMICR  : NMICR_Type        with Volatile_Full_Access => True;
      NMIER  : NMIER_Type        with Volatile_Full_Access => True;
      NMICLR : NMICLR_Type       with Volatile_Full_Access => True;
      NMISR  : NMISR_Type        with Volatile_Full_Access => True;
      WUPEN  : WUPEN_Type        with Volatile_Full_Access => True;
      SELSR0 : SELSR0_Type       with Volatile_Full_Access => True;
      DELSR  : DELSR_Array_Type;
      IELSR  : IELSR_Array_Type;
   end record
      with Size => 16#F00# * 8;
   for ICU_Type use record
      IRQCR  at 0        range 0 .. 16 * 8 - 1;
      NMICR  at 16#0100# range 0 ..  7;
      NMIER  at 16#0120# range 0 .. 15;
      NMICLR at 16#0130# range 0 .. 15;
      NMISR  at 16#0140# range 0 .. 15;
      WUPEN  at 16#01A0# range 0 .. 31;
      SELSR0 at 15#0200# range 0 .. 15;
      DELSR  at 16#0280# range 0 ..  8 * 32 - 1;
      IELSR  at 16#0300# range 0 .. 96 * 32 - 1;
   end record;
pragma Warnings (On);

   ICU_ADDRESS : constant := 16#4000_6000#;

   ICU : aliased ICU_Type
      with Address    => System'To_Address (ICU_ADDRESS),
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 20. I/O Ports
   ----------------------------------------------------------------------------

   -- 20.2.1 Port Control Register 1 (PCNTR1/PODR/PDR)
   -- 20.2.2 Port Control Register 2 (PCNTR2/EIDR/PIDR)
   -- 20.2.3 Port Control Register 3 (PCNTR3/PORR/POSR)
   -- 20.2.4 Port Control Register 4 (PCNTR4/EORR/EOSR)

pragma Warnings (Off);
   type PORT_Type is record
      PODR : Bitmap_16 with Volatile_Full_Access => True;
      PDR  : Bitmap_16 with Volatile_Full_Access => True;
      EIDR : Bitmap_16 with Volatile_Full_Access => True;
      PIDR : Bitmap_16 with Volatile_Full_Access => True;
      POR  : Bitmap_16 with Volatile_Full_Access => True;
      POSR : Bitmap_16 with Volatile_Full_Access => True;
      EORR : Bitmap_16 with Volatile_Full_Access => True;
      EOSR : Bitmap_16 with Volatile_Full_Access => True;
   end record
      with Size                    => 16#20# * 8,
           Suppress_Initialization => True;
   for PORT_Type use record
      PODR at 16#00# range 0 .. 15;
      PDR  at 16#02# range 0 .. 15;
      EIDR at 16#04# range 0 .. 15;
      PIDR at 16#06# range 0 .. 15;
      POR  at 16#08# range 0 .. 15;
      POSR at 16#0A# range 0 .. 15;
      EORR at 16#0C# range 0 .. 15;
      EOSR at 16#0E# range 0 .. 15;
   end record;
pragma Warnings (On);

   PORT_BASEADDRESS : constant := 16#4004_0000#;

   PORT : aliased array (0 .. 11) of PORT_Type
      with Address    => System'To_Address (PORT_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 20.2.5 Port mn Pin Function Select Register (PmnPFS/PmnPFS_HA/PmnPFS_BY) (m = 0 to 9, A, B; n = 00 to 15)

   PDR_PORTIN  : constant := 0; -- Input (functions as an input pin)
   PDR_PORTOUT : constant := 1; -- Output (functions as an output pin).

   NCODR_CMOS : constant := 0; -- CMOS output
   NCODR_NMOS : constant := 1; -- NMOS open-drain output.

   DSCR_LowDrive    : constant := 2#00#;
   DSCR_MiddleDrive : constant := 2#01#;
   DSCR_HighDrive   : constant := 2#11#;

   EOFEOR_Dontcare : constant := 2#00#;
   EOFEOR_Rising   : constant := 2#01#;
   EOFEOR_Falling  : constant := 2#10#;
   EOFEOR_Both     : constant := 2#11#;

   --                                                0 1 2 3 4 5 6 7 8 9 A B
   PSEL_HiZ_JTAG_SWD      : constant := 2#00000#; -- X X X X X X X X X X X X
   PSEL_AGT               : constant := 2#00001#; -- - X X X X X - X - X - -
   PSEL_GPT1              : constant := 2#00010#; -- - X X X X X - - - - - -
   PSEL_GPT2              : constant := 2#00011#; -- - X X X X X X X - X - -
   PSEL_SCI1              : constant := 2#00100#; -- - X X X X X X - - X X -
   PSEL_SCI2              : constant := 2#00101#; -- - X X X X X X X X - - X
   PSEL_SPI               : constant := 2#00110#; -- - X X X X - - X - - - -
   PSEL_IIC               : constant := 2#00111#; -- - X X - X X - - - - - -
   PSEL_KINT              : constant := 2#01000#; -- - X - - - - - - - - - -
   PSEL_CLKOUT_ACMPHS_RTC : constant := 2#01001#; -- - - X - X - X X - - - -
   PSEL_CAC_ADC12         : constant := 2#01010#; -- - X X X X - X - - - - -
   PSEL_BUS               : constant := 2#01011#; -- - X X X - X X - X X - -
   PSEL_CTSU              : constant := 2#01100#; -- - - X - X - - X - - - -
   PSEL_CAN               : constant := 2#10000#; -- - X X - X X X X - - - -
   PSEL_QSPI              : constant := 2#10001#; -- - - X X - X - - - - - -
   PSEL_SSIE              : constant := 2#10010#; -- - X X - X - - X - - - -
   PSEL_USBFS             : constant := 2#10011#; -- - - X - X X - - - - - -
   PSEL_USBHS             : constant := 2#10100#; -- - - - - X - - X - - - X
   PSEL_SDHI              : constant := 2#10101#; -- - - X X X X - X X - - -
   PSEL_ETHERC_MII        : constant := 2#10110#; -- - - X - X - - X - - - -
   PSEL_ETHERC_RMII       : constant := 2#10111#; -- - - X X X - - X - - - -
   PSEL_PDC               : constant := 2#11000#; -- - - - - X X - X - - - -
   PSEL_GLCDC             : constant := 2#11001#; -- - X X X - X X - X X X -
   PSEL_TraceDebug        : constant := 2#11010#; -- - - - - - - - - - - - -

   type PFSR_Type is record
      PODR      : Boolean := False;           -- Port Output Data
      PIDR      : Boolean := False;           -- Pmn State
      PDR       : Bits_1  := PDR_PORTIN;      -- Port Direction
      Reserved1 : Bits_1  := 0;
      PCR       : Boolean := False;           -- Pull-up Control
      Reserved2 : Bits_1  := 0;
      NCODR     : Bits_1  := NCODR_CMOS;      -- N-Channel Open-Drain Control
      Reserved3 : Bits_3  := 0;
      DSCR      : Bits_2  := DSCR_LowDrive;   -- Port Drive Capability
      EOFEOR    : Bits_2  := EOFEOR_Dontcare; -- Event on Falling/Event on Rising
      ISEL      : Boolean := False;           -- IRQ Input Enable
      ASEL      : Boolean := False;           -- Analog Input Enable
      PMR       : Boolean := False;           -- Port Mode Control
      Reserved4 : Bits_7  := 0;
      PSEL      : Bits_5;                     -- Peripheral Select
      Reserved5 : Bits_3  := 0;
   end record
      with Bit_Order               => Low_Order_First,
           Size                    => 32,
           Volatile_Full_Access    => True,
           Suppress_Initialization => True;
   for PFSR_Type use record
      PODR      at 0 range  0 ..  0;
      PIDR      at 0 range  1 ..  1;
      PDR       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PCR       at 0 range  4 ..  4;
      Reserved2 at 0 range  5 ..  5;
      NCODR     at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  9;
      DSCR      at 0 range 10 .. 11;
      EOFEOR    at 0 range 12 .. 13;
      ISEL      at 0 range 14 .. 14;
      ASEL      at 0 range 15 .. 15;
      PMR       at 0 range 16 .. 16;
      Reserved4 at 0 range 17 .. 23;
      PSEL      at 0 range 24 .. 28;
      Reserved5 at 0 range 29 .. 31;
   end record;

   -- PFS.P000PFS 4004 0800h to PFS.P015PFS 4004 083Ch
   P000 : constant := 000; P001 : constant := 001; P002 : constant := 002; P003 : constant := 003;
   P004 : constant := 004; P005 : constant := 005; P006 : constant := 006; P007 : constant := 007;
   P008 : constant := 008; P009 : constant := 009; P010 : constant := 010; P011 : constant := 011;
   P012 : constant := 012; P013 : constant := 013; P014 : constant := 014; P015 : constant := 015;

   -- PFS.P100PFS 4004 0840h to PFS.P115PFS 4004 087Ch
   P100 : constant := 016; P101 : constant := 017; P102 : constant := 018; P103 : constant := 019;
   P104 : constant := 020; P105 : constant := 021; P106 : constant := 022; P107 : constant := 023;
   P108 : constant := 024; P109 : constant := 025; P110 : constant := 026; P111 : constant := 027;
   P112 : constant := 028; P113 : constant := 029; P114 : constant := 030; P115 : constant := 031;

   -- PFS.P200PFS 4004 0880h to PFS.P214PFS 4004 08B8h
   P200 : constant := 032; P201 : constant := 033; P202 : constant := 034; P203 : constant := 035;
   P204 : constant := 036; P205 : constant := 037; P206 : constant := 038; P207 : constant := 039;
   P208 : constant := 040; P209 : constant := 041; P210 : constant := 042; P211 : constant := 043;
   P212 : constant := 044; P213 : constant := 045; P214 : constant := 046; -- P215 : constant := 047;

   -- PFS.P300PFS 4004 08C0h to PFS.P315PFS 4004 08FCh
   P300 : constant := 048; P301 : constant := 049; P302 : constant := 050; P303 : constant := 051;
   P304 : constant := 052; P305 : constant := 053; P306 : constant := 054; P307 : constant := 055;
   P308 : constant := 056; P309 : constant := 057; P310 : constant := 058; P311 : constant := 059;
   P312 : constant := 060; P313 : constant := 061; P314 : constant := 062; P315 : constant := 063;

   -- PFS.P400PFS 4004 0900h to PFS.P415PFS 4004 093Ch
   P400 : constant := 064; P401 : constant := 065; P402 : constant := 066; P403 : constant := 067;
   P404 : constant := 068; P405 : constant := 069; P406 : constant := 070; P407 : constant := 071;
   P408 : constant := 072; P409 : constant := 073; P410 : constant := 074; P411 : constant := 075;
   P412 : constant := 076; P413 : constant := 077; P414 : constant := 078; P415 : constant := 079;

   -- PFS.P500PFS 4004 0940h to PFS.P513PFS 4004 0974h
   P500 : constant := 080; P501 : constant := 081; P502 : constant := 082; P503 : constant := 083;
   P504 : constant := 084; P505 : constant := 085; P506 : constant := 086; P507 : constant := 087;
   P508 : constant := 088; P509 : constant := 089; P510 : constant := 090; P511 : constant := 091;
   P512 : constant := 092; P513 : constant := 093; -- P514 : constant := 094; P515 : constant := 095;

   -- PFS.P600PFS 4004 0980h to PFS.P615PFS 4004 09BCh
   P600 : constant := 096; P601 : constant := 097; P602 : constant := 098; P603 : constant := 099;
   P604 : constant := 100; P605 : constant := 101; P606 : constant := 102; P607 : constant := 103;
   P608 : constant := 104; P609 : constant := 105; P610 : constant := 106; P611 : constant := 107;
   P612 : constant := 108; P613 : constant := 109; P614 : constant := 110; P615 : constant := 111;

   -- PFS.P700PFS 4004 09C0h to PFS.P713PFS 4004 09F4h
   P700 : constant := 112; P701 : constant := 113; P702 : constant := 114; P703 : constant := 115;
   P704 : constant := 116; P705 : constant := 117; P706 : constant := 118; P707 : constant := 119;
   P708 : constant := 120; P709 : constant := 121; P710 : constant := 122; P711 : constant := 123;
   P712 : constant := 124; P713 : constant := 125; -- P714 : constant := 126; P715 : constant := 127;

   -- PFS.P800PFS 4004 0A00h to PFS.P806PFS 4004 0A18h
   P800 : constant := 128; P801 : constant := 129; P802 : constant := 130; P803 : constant := 131;
   P804 : constant := 132; P805 : constant := 133; P806 : constant := 134; -- P807 : constant := 135;
   -- P808 : constant := 136; P809 : constant := 137; P810 : constant := 138; P811 : constant := 139;
   -- P812 : constant := 140; P813 : constant := 141; P814 : constant := 142; P815 : constant := 143;

   -- PFS.P900PFS 4004 0A40h to PFS.P908PFS 4004 0A60h
   P900 : constant := 144; P901 : constant := 145; P902 : constant := 146; P903 : constant := 147;
   P904 : constant := 148; P905 : constant := 149; P906 : constant := 150; P907 : constant := 151;
   P908 : constant := 152; -- P909 : constant := 153; P910 : constant := 154; P911 : constant := 155;
   -- P912 : constant := 156; P913 : constant := 157; P914 : constant := 158; P915 : constant := 159;

   -- PFS.PA00PFS 4004 0A80h to PFS.PA10PFS 4004 0AA8h
   PA00 : constant := 160; PA01 : constant := 161; PA02 : constant := 162; PA03 : constant := 163;
   PA04 : constant := 164; PA05 : constant := 165; PA06 : constant := 166; PA07 : constant := 167;
   PA08 : constant := 168; PA09 : constant := 169; PA10 : constant := 170; -- PA11 : constant := 171;
   -- PA12 : constant := 172; PA13 : constant := 173; PA14 : constant := 174; PA15 : constant := 175;

   -- PFS.PB00PFS 4004 0AC0h to PFS.PB01PFS 4004 0AC4h
   PB00 : constant := 176; PB01 : constant := 177; -- PB02 : constant := 178; PB03 : constant := 179;
   -- PB04 : constant := 180; PB05 : constant := 181; PB06 : constant := 182; PB07 : constant := 183;
   -- PB08 : constant := 184; PB09 : constant := 185; PB10 : constant := 186; PB11 : constant := 187;
   -- PB12 : constant := 188; PB13 : constant := 189; PB14 : constant := 190; PB15 : constant := 191;

   PFSR_BASEADDRESS : constant := 16#4004_0800#;

   PFSR : aliased array (0 .. 191) of PFSR_Type
      with Address    => System'To_Address (PFSR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 20.2.6 Write-Protect Register (PWPR)

   type PWPR_Type is record
      Reserved : Bits_6  := 0;
      PFSWE    : Boolean;      -- PmnPFS Register Write Enable
      B0WI     : Boolean;      -- PFSWE Bit Write Disable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PWPR_Type use record
      Reserved at 0 range 0 .. 5;
      PFSWE    at 0 range 6 .. 6;
      B0WI     at 0 range 7 .. 7;
   end record;

   PWPR_ADDRESS : constant := 16#4004_0D03#;

   PWPR : aliased PWPR_Type
      with Address              => System'To_Address (PWPR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 25. Asynchronous General-Purpose Timer (AGT)
   ----------------------------------------------------------------------------

   -- 25.2.4 AGT Control Register (AGTCR)

   TSTART_STOP  : constant := 0;
   TSTART_START : constant := 1;

   TCSTF_STOPPED  : constant := 0;
   TCSTF_PROGRESS : constant := 1;

   TSTOP_WINV : constant := 0;
   TSTOP_STOP : constant := 1;

   type AGTCR_Type is record
      TSTART   : Bits_1  := TSTART_STOP;   -- AGT Count Start
      TCSTF    : Bits_1  := TCSTF_STOPPED; -- AGT Count Status Flag
      TSTOP    : Bits_1  := TSTOP_WINV;    -- AGT Count Forced Stop
      Reserved : Bits_1  := 0;
      TEDGF    : Boolean := False;         -- Active Edge Judgment Flag
      TUNDF    : Boolean := False;         -- Underflow Flag
      TCMAF    : Boolean := False;         -- Compare Match A Flag
      TCMBF    : Boolean := False;         -- Compare Match B Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTCR_Type use record
      TSTART   at 0 range 0 .. 0;
      TCSTF    at 0 range 1 .. 1;
      TSTOP    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 3;
      TEDGF    at 0 range 4 .. 4;
      TUNDF    at 0 range 5 .. 5;
      TCMAF    at 0 range 6 .. 6;
      TCMBF    at 0 range 7 .. 7;
   end record;

   -- 25.2.5 AGT Mode Register 1 (AGTMR1)

   TMOD_TIMER  : constant := 2#000#;
   TMOD_PULSE  : constant := 2#001#;
   TMOD_EVENT  : constant := 2#010#;
   TMOD_PWMEAS : constant := 2#011#;
   TMOD_PPMEAS : constant := 2#100#;

   TEDGPL_SINGLE : constant := 0;
   TEDGPL_BOTH   : constant := 1;

   TCK_PCLKB   : constant := 2#000#;
   TCK_PCLKB8  : constant := 2#001#;
   TCK_PCLKB2  : constant := 2#011#;
   TCK_AGTLCLK : constant := 2#100#;
   TCK_AGT0    : constant := 2#101#;
   TCK_AGTSCLK : constant := 2#110#;

   type AGTMR1_Type is record
      TMOD     : Bits_3 := TMOD_TIMER;    -- Operating Mode
      TEDGPL   : Bits_1 := TEDGPL_SINGLE; -- Edge Polarity
      TCK      : Bits_3 := TCK_PCLKB;     -- Count Source
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTMR1_Type use record
      TMOD     at 0 range 0 .. 2;
      TEDGPL   at 0 range 3 .. 3;
      TCK      at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   -- 25.2.6 AGT Mode Register 2 (AGTMR2)

   CKS_DIV1   : constant := 2#000#;
   CKS_DIV2   : constant := 2#001#;
   CKS_DIV4   : constant := 2#010#;
   CKS_DIV8   : constant := 2#011#;
   CKS_DIV16  : constant := 2#100#;
   CKS_DIV32  : constant := 2#101#;
   CKS_DIV64  : constant := 2#110#;
   CKS_DIV128 : constant := 2#111#;

   type AGTMR2_Type is record
      CKS      : Bits_3  := CKS_DIV1; -- AGTSCLK/AGTLCLK Count Source Clock Frequency Division Ratio
      Reserved : Bits_4  := 0;
      LPM      : Boolean := False;    -- Low Power Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTMR2_Type use record
      CKS      at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 6;
      LPM      at 0 range 7 .. 7;
   end record;

   -- 25.2.7 AGT I/O Control Register (AGTIOC)

   -- Pulse output mode
   TEDGSEL_PULSE_HIGH : constant := 0; -- Output is started at high (initialization level: high)
   TEDGSEL_PULSE_LOW  : constant := 1; -- Output is started at low (initialization level: low).
   -- Event counter mode
   TEDGSEL_ECNT_RISING  : constant := 0; -- Count on rising edge
   TEDGSEL_ECNT_FALLING : constant := 1; -- Count on falling edge.
   -- Pulse width measurement mode
   TEDGSEL_PWMEAS_LOW  : constant := 0; -- Low-level width is measured
   TEDGSEL_PWMEAS_HIGH : constant := 1; -- High-level width is measured.
   -- Pulse period measurement mode
   TEDGSEL_PPMEAS_RISING  : constant := 0; -- Measure from one rising edge to the next rising edge
   TEDGSEL_PPMEAS_FALLING : constant := 1; -- Measure from one falling edge to the next falling edge.

   TIPF_NOFILTER   : constant := 2#00#; -- No filter
   TIPF_PCLKB      : constant := 2#01#; -- Filter sampled at PCLKB
   TIPF_PCLKBDIV8  : constant := 2#10#; -- Filter sampled at PCLKB/8
   TIPF_PCLKBDIV32 : constant := 2#11#; -- Filter sampled at PCLKB/32.

   TIOGT_ALWAYS : constant := 2#00#; -- Event is always counted
   TIOGT_AGTEEn : constant := 2#01#; -- Event is counted during polarity period specified for AGTEEn.

   type AGTIOC_Type is record
      TEDGSEL   : Bits_1  := TEDGSEL_PULSE_HIGH; -- I/O Polarity Switch
      Reserved1 : Bits_1  := 0;
      TOE       : Boolean := False;              -- AGTOn Output Enable
      Reserved2 : Bits_1  := 0;
      TIPF      : Bits_2  := TIPF_NOFILTER;      -- Input Filter
      TIOGT     : Bits_2  := TIOGT_ALWAYS;       -- Count Control
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTIOC_Type use record
      TEDGSEL   at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      TOE       at 0 range 2 .. 2;
      Reserved2 at 0 range 3 .. 3;
      TIPF      at 0 range 4 .. 5;
      TIOGT     at 0 range 6 .. 7;
   end record;

   -- 25.2.8 AGT Event Pin Select Register (AGTISR)

   EEPS_LOW  : constant := 0; -- An event is counted during the low-level period
   EEPS_HIGH : constant := 1; -- An event is counted during the high-level period.

   type AGTISR_Type is record
      Reserved1 : Bits_2  := 0;
      EEPS      : Boolean := False; -- AGTEEn Polarity Selection
      Reserved2 : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTISR_Type use record
      Reserved1 at 0 range 0 .. 1;
      EEPS      at 0 range 2 .. 2;
      Reserved2 at 0 range 3 .. 7;
   end record;

   -- 25.2.9 AGT Compare Match Function Select Register (AGTCMSR)

   type AGTCMSR_Type is record
      TCMEA     : Boolean := False; -- Compare Match A Register Enable
      TOEA      : Boolean := False; -- AGTOAn Output Enable
      TOPOLA    : Boolean := False; -- AGTOAn Polarity Select
      Reserved1 : Bits_1  := 0;
      TCMEB     : Boolean := False; -- Compare Match B Register Enable
      TOEB      : Boolean := False; -- AGTOBn Output Enable
      TOPOLB    : Boolean := False; -- AGTOBn Polarity Select
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTCMSR_Type use record
      TCMEA     at 0 range 0 .. 0;
      TOEA      at 0 range 1 .. 1;
      TOPOLA    at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      TCMEB     at 0 range 4 .. 4;
      TOEB      at 0 range 5 .. 5;
      TOPOLB    at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- 25.2.10 AGT Pin Select Register (AGTIOSEL)

   SEL_Pm         : constant := 2#00#; -- Select Pm*2/AGTIO as AGTIO
   SEL_prohibited : constant := 2#01#; -- Setting prohibited
   SEL_P402       : constant := 2#10#; -- Select P402/AGTIO as AGTIO
   SEL_P403       : constant := 2#11#; -- Select P403/AGTIO as AGTIO.

   type AGTIOSEL_Type is record
      SEL       : Bits_2  := SEL_Pm; -- AGTIO Pin Select
      Reserved1 : Bits_2  := 0;
      TIES      : Boolean := False;  -- AGTIO Input Enable
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AGTIOSEL_Type use record
      SEL       at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      TIES      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
   end record;

   -- AGT0 .. 1

   type AGT_Type is record
      AGT      : Unsigned_16   with Volatile_Full_Access => True;
      AGTCMA   : Unsigned_16   with Volatile_Full_Access => True;
      AGTCMB   : Unsigned_16   with Volatile_Full_Access => True;
      Pad1     : Unsigned_16   with Volatile_Full_Access => True;
      AGTCR    : AGTCR_Type    with Volatile_Full_Access => True;
      AGTMR1   : AGTMR1_Type   with Volatile_Full_Access => True;
      AGTMR2   : AGTMR2_Type   with Volatile_Full_Access => True;
      Pad2     : Unsigned_8    with Volatile_Full_Access => True;
      AGTIOC   : AGTIOC_Type   with Volatile_Full_Access => True;
      AGTISR   : AGTISR_Type   with Volatile_Full_Access => True;
      AGTCMSR  : AGTCMSR_Type  with Volatile_Full_Access => True;
      AGTIOSEL : AGTIOSEL_Type with Volatile_Full_Access => True;
   end record
      with Size => 16 * 8;
   for AGT_Type use record
      AGT      at 16#00# range 0 .. 15;
      AGTCMA   at 16#02# range 0 .. 15;
      AGTCMB   at 16#04# range 0 .. 15;
      Pad1     at 16#06# range 0 .. 15;
      AGTCR    at 16#08# range 0 ..  7;
      AGTMR1   at 16#09# range 0 ..  7;
      AGTMR2   at 16#0A# range 0 ..  7;
      Pad2     at 16#0B# range 0 ..  7;
      AGTIOC   at 16#0C# range 0 ..  7;
      AGTISR   at 16#0D# range 0 ..  7;
      AGTCMSR  at 16#0E# range 0 ..  7;
      AGTIOSEL at 16#0F# range 0 ..  7;
   end record;

   AGT_BASEADDRESS : constant := 16#4008_4000#;

   AGT0 : aliased AGT_Type
      with Address    => System'To_Address (AGT_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   AGT1 : aliased AGT_Type
      with Address    => System'To_Address (AGT_BASEADDRESS + 16#0100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 29. Ethernet MAC Controller (ETHERC)
   ----------------------------------------------------------------------------

   -- 29.2.5 PHY Interface Register (PIR)

   type PIR_Type is record
      MDC      : Bits_1  := 0; -- MII/RMII Management Data Clock
      MMD      : Bits_1  := 0; -- MII/RMII Management Mode
      MDO      : Bits_1  := 0; -- MII/RMII Management Data-Out
      MDI      : Bits_1  := 0; -- MII/RMII Management Data-In
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIR_Type use record
      MDC      at 0 range 0 ..  0;
      MMD      at 0 range 1 ..  1;
      MDO      at 0 range 2 ..  2;
      MDI      at 0 range 3 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   -- 29.2.6 PHY Status Register (PSR)

   type PSR_Type is record
      LMON     : Boolean; -- ET0_LINKSTA Pin Status Flag
      Reserved : Bits_31;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSR_Type use record
      LMON     at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   ETHERC_BASEADDRESS : constant := 16#4006_4100#;

   PIR : aliased PIR_Type
      with Address              => System'To_Address (ETHERC_BASEADDRESS + 16#20#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSR : aliased PSR_Type
      with Address              => System'To_Address (ETHERC_BASEADDRESS + 16#28#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 34. Serial Communications Interface (SCI)
   ----------------------------------------------------------------------------

   type SCI_Kind is (NORMAL, FIFO, SMIF);

   type CHR_Data_Length_Type is record
      CHR  : Bits_1;
      CHR1 : Bits_1;
   end record;

   CHR_9 : constant CHR_Data_Length_Type := (0, 0); -- Transmit/receive in 9-bit data length (also (1, 0))
   CHR_8 : constant CHR_Data_Length_Type := (0, 1); -- Transmit/receive in 8-bit data length
   CHR_7 : constant CHR_Data_Length_Type := (1, 1); -- Transmit/receive in 7-bit data length

   type BCP_Type is record
      BCP10 : Bits_2;
      BCP2  : Bits_1;
   end record;

   BCP_93  : constant BCP_Type := (2#00#, 0);
   BCP_128 : constant BCP_Type := (2#01#, 0);
   BCP_186 : constant BCP_Type := (2#10#, 0);
   BCP_512 : constant BCP_Type := (2#11#, 0);
   BCP_32  : constant BCP_Type := (2#00#, 1);
   BCP_64  : constant BCP_Type := (2#01#, 1);
   BCP_372 : constant BCP_Type := (2#10#, 1);
   BCP_256 : constant BCP_Type := (2#11#, 1);

   -- 34.2.9 Serial Mode Register (SMR) for Non-Smart Card Interface Mode (SCMR.SMIF = 0)
   -- 34.2.10 Serial Mode Register for Smart Card Interface Mode (SMR_SMCI) (SCMR.SMIF = 1)

   CKS_PCLKA   : constant := 2#00#; -- PCLKA clock (n = 0)
   CKS_PCLKA4  : constant := 2#01#; -- PCLKA/4 clock (n = 1)
   CKS_PCLKA16 : constant := 2#10#; -- PCLKA/16 clock (n = 2)
   CKS_PCLKA64 : constant := 2#11#; -- PCLKA/64 clock (n = 3)

   STOP_1 : constant := 0; -- 1 stop bit
   STOP_2 : constant := 1; -- 2 stop bit

   PM_EVEN : constant := 0; -- even parity
   PM_ODD  : constant := 1; -- odd parity

   CM_ASYNC : constant := 0; -- Asynchronous mode or simple IIC mode
   CM_SYNC  : constant := 1; -- Clock synchronous mode or simple SPI mode

   type SMR_NORMAL_Type is record
      CKS  : Bits_2;  -- Clock Select
      MP   : Boolean; -- Multi-Processor Mode
      STOP : Bits_1;  -- Stop Bit Length
      PM   : Bits_1;  -- Parity Mode
      PE   : Boolean; -- Parity Enable
      CHR  : Bits_1;  -- Character Length
      CM   : Bits_1;  -- Communication Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMR_NORMAL_Type use record
      CKS  at 0 range 0 .. 1;
      MP   at 0 range 2 .. 2;
      STOP at 0 range 3 .. 3;
      PM   at 0 range 4 .. 4;
      PE   at 0 range 5 .. 5;
      CHR  at 0 range 6 .. 6;
      CM   at 0 range 7 .. 7;
   end record;

   type SMR_SMIF_Type is record
      CKS   : Bits_2;                  -- Clock Select
      BCP10 : Bits_2  := BCP_32.BCP10; -- Base Clock Pulse
      PM    : Bits_1;                  -- Parity Mode
      PE    : Boolean;                 -- Parity Enable
      BLK   : Boolean;                 -- Block Transfer Mode
      GM    : Boolean;                 -- GSM Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMR_SMIF_Type use record
      CKS   at 0 range 0 .. 1;
      BCP10 at 0 range 2 .. 3;
      PM    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      BLK   at 0 range 6 .. 6;
      GM    at 0 range 7 .. 7;
   end record;

   type SMR_Type (S : SCI_Kind := NORMAL) is record
      case S is
         when NORMAL | FIFO => NORMAL : SMR_NORMAL_Type;
         when SMIF          => SMIF   : SMR_SMIF_Type;
      end case;
   end record
      with Pack            => True,
           Unchecked_Union => True;

   -- 34.2.11 Serial Control Register (SCR) for Non-Smart Card Interface Mode (SCMR.SMIF = 0)
   -- 34.2.12 Serial Control Register for Smart Card Interface Mode (SCR_SMCI) (SCMR.SMIF = 1)

   CKE_Async_On_Chip_BRG_SCK_IO  : constant := 2#00#;
   CKE_Async_On_Chip_BRG_SCK_CLK : constant := 2#01#;
   CKE_Async_Ext_BRG             : constant := 2#10#; -- also 2#11#
   CKE_Sync_Int_CLK              : constant := 2#00#; -- also 2#01#
   CKE_Sync_Ext_CLK              : constant := 2#10#; -- also 2#11#

   type SCR_Type is record
      CKE  : Bits_2;           -- Clock Enable
      TEIE : Boolean;          -- Transmit End Interrupt Enable
      MPIE : Boolean := False; -- Multi-Processor Interrupt Enable
      RE   : Boolean;          -- Receive Enable
      TE   : Boolean;          -- Transmit Enable
      RIE  : Boolean;          -- Receive Interrupt Enable
      TIE  : Boolean;          -- Transmit Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SCR_Type use record
      CKE  at 0 range 0 .. 1;
      TEIE at 0 range 2 .. 2;
      MPIE at 0 range 3 .. 3;
      RE   at 0 range 4 .. 4;
      TE   at 0 range 5 .. 5;
      RIE  at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 34.2.13 Serial Status Register (SSR) for Non-Smart Card Interface and Non-FIFO Mode (SCMR.SMIF = 0 and FCR.FM = 0)

   MPBT_DATA : constant := 0;
   MPBT_ID   : constant := 1;

   MPB_DATA : constant := 0;
   MPB_ID   : constant := 1;

   type SSR_NORMAL_Type is
   record
      MPBT : Bits_1;  -- Multi-Processor Bit Transfer
      MPB  : Bits_1;  -- Multi-Processor
      TEND : Boolean; -- Transmit End Flag
      PER  : Boolean; -- Parity Error Flag
      FER  : Boolean; -- Framing Error Flag
      ORER : Boolean; -- Overrun Error Flag
      RDRF : Boolean; -- Receive Data Full Flag
      TDRE : Boolean; -- Transmit Data Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSR_NORMAL_Type use record
      MPBT at 0 range 0 .. 0;
      MPB  at 0 range 1 .. 1;
      TEND at 0 range 2 .. 2;
      PER  at 0 range 3 .. 3;
      FER  at 0 range 4 .. 4;
      ORER at 0 range 5 .. 5;
      RDRF at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   -- 34.2.14 Serial Status Register for Non-Smart Card Interface and FIFO Mode (SSR_FIFO) (SCMR.SMIF = 0 and FCR.FM = 1)

   type SSR_FIFO_Type is record
      DR       : Boolean;      -- Receive Data Ready Flag
      Reserved : Bits_1  := 1;
      TEND     : Boolean;      -- Transmit End Flag
      PER      : Boolean;      -- Parity Error Flag
      FER      : Boolean;      -- Framing Error Flag
      ORER     : Boolean;      -- Overrun Error Flag
      RDF      : Boolean;      -- Receive FIFO Data Full Flag
      TDFE     : Boolean;      -- Transmit FIFO Data Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSR_FIFO_Type use record
      DR       at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 1;
      TEND     at 0 range 2 .. 2;
      PER      at 0 range 3 .. 3;
      FER      at 0 range 4 .. 4;
      ORER     at 0 range 5 .. 5;
      RDF      at 0 range 6 .. 6;
      TDFE     at 0 range 7 .. 7;
   end record;

   -- 34.2.15 Serial Status Register for Smart Card Interface Mode (SSR_SMCI) (SCMR.SMIF = 1)

   type SSR_SMIF_Type is record
      MPBT : Bits_1;  -- Multi-Processor Bit Transfer
      MPB  : Bits_1;  -- Multi-Processor
      TEND : Boolean; -- Transmit End Flag
      PER  : Boolean; -- Parity Error Flag
      ERS  : Boolean; -- Error Signal Status Flag
      ORER : Boolean; -- Overrun Error Flag
      RDRF : Boolean; -- Receive Data Full Flag
      TDRE : Boolean; -- Transmit Data Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSR_SMIF_Type use
   record
      MPBT  at 0 range 0 .. 0;
      MPB   at 0 range 1 .. 1;
      TEND  at 0 range 2 .. 2;
      PER   at 0 range 3 .. 3;
      ERS   at 0 range 4 .. 4;
      ORER  at 0 range 5 .. 5;
      RDRF  at 0 range 6 .. 6;
      TDRE  at 0 range 7 .. 7;
   end record;

   type SSR_Type (S : SCI_Kind := NORMAL) is record
      case S is
         when NORMAL => NORMAL : SSR_NORMAL_Type;
         when FIFO   => FIFO   : SSR_FIFO_Type;
         when SMIF   => SMIF   : SSR_SMIF_Type;
      end case;
   end record
      with Pack            => True,
           Unchecked_Union => True;

   -- 34.2.16 Smart Card Mode Register (SCMR)

   SINV_NO  : constant := 0;
   SINV_YES : constant := 1;

   SDIR_LSB : constant := 0;
   SDIR_MSB : constant := 1;

   type SCMR_Type is record
      SMIF      : Boolean;                -- Smart Card Interface Mode Select
      Reserved1 : Bits_1  := 1;
      SINV      : Bits_1;                 -- Transmitted/Received Data Invert
      SDIR      : Bits_1;                 -- Transmitted/Received Data Transfer Direction
      CHR1      : Bits_1;                 -- Character Length 1
      Reserved2 : Bits_2  := 2#11#;
      BCP2      : Bits_1  := BCP_32.BCP2; -- Base Clock Pulse 2
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SCMR_Type use record
      SMIF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      SINV      at 0 range 2 .. 2;
      SDIR      at 0 range 3 .. 3;
      CHR1      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 6;
      BCP2      at 0 range 7 .. 7;
   end record;

   -- 34.2.19 Serial Extended Mode Register (SEMR)

   type SEMR_Type is record
      Reserved : Bits_2  := 0;
      BRME     : Boolean;      -- Bit Rate Modulation Enable
      ABCSE    : Boolean;      -- Asynchronous Mode Extended Base Clock Select 1
      ABCS     : Boolean;      -- Asynchronous Mode Base Clock Select
      NFEN     : Boolean;      -- Digital Noise Filter Function Enable
      BGDM     : Boolean;      -- Baud Rate Generator Double-Speed Mode Select
      RXDESEL  : Boolean;      -- Asynchronous Start Bit Edge Detection Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SEMR_Type use record
      Reserved at 0 range 0 .. 1;
      BRME     at 0 range 2 .. 2;
      ABCSE    at 0 range 3 .. 3;
      ABCS     at 0 range 4 .. 4;
      NFEN     at 0 range 5 .. 5;
      BGDM     at 0 range 6 .. 6;
      RXDESEL  at 0 range 7 .. 7;
   end record;

   -- 34.2.20 Noise Filter Setting Register (SNFR)

   NFCS_ASYNC_1 : constant := 2#000#; -- Use clock signal divided by 1 with noise filter
   NFCS_IIC_1   : constant := 2#001#; -- Use clock signal divided by 1 with noise filter
   NFCS_IIC_2   : constant := 2#010#; -- Use clock signal divided by 2 with noise filter
   NFCS_IIC_4   : constant := 2#011#; -- Use clock signal divided by 4 with noise filter
   NFCS_IIC_8   : constant := 2#100#; -- Use clock signal divided by 8 with noise filter.

   type SNFR_Type is record
      NFCS     : Bits_3;      -- Noise Filter Clock Select
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SNFR_Type use record
      NFCS     at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 34.2.21 IIC Mode Register 1 (SIMR1)

   type SIMR1_Type is record
      IICM     : Boolean;      -- Simple IIC Mode Select
      Reserved : Bits_2  := 0;
      IICDL    : Bits_5;       -- SDA Delay Output Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SIMR1_Type use record
      IICM     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 2;
      IICDL    at 0 range 3 .. 7;
   end record;

   -- 34.2.22 IIC Mode Register 2 (SIMR2)

   IICINTM_ACKNACK : constant := 0;
   IICINTM_RXTX    : constant := 1;

   IICACKT_ACK  : constant := 0;
   IICACKT_NACK : constant := 1;

   type SIMR2_Type is record
      IICINTM   : Bits_1;       -- IIC Interrupt Mode Select
      IICCSC    : Boolean;      -- Clock Synchronization
      Reserved1 : Bits_3  := 0;
      IICACKT   : Bits_1;       -- ACK Transmission Data
      Reserved2 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SIMR2_Type use record
      IICINTM   at 0 range 0 .. 0;
      IICCSC    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      IICACKT   at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   -- 34.2.23 IIC Mode Register 3 (SIMR3)

   IICSDAS_OUTSER : constant := 2#00#;
   IICSDAS_GEN    : constant := 2#01#;
   IICSDAS_SDALOW : constant := 2#10#;
   IICSDAS_SDAHIZ : constant := 2#11#;

   IICSCLS_OUTSER : constant := 2#00#;
   IICSCLS_GEN    : constant := 2#01#;
   IICSCLS_SDALOW : constant := 2#10#;
   IICSCLS_SDAHIZ : constant := 2#11#;

   type SIMR3_Type is record
      IICSTAREQ  : Boolean; -- Start Condition Generation
      IICRSTAREQ : Boolean; -- Restart Condition Generation
      IICSTPREQ  : Boolean; -- Stop Condition Generation
      IICSTIF    : Boolean; -- Issuing of Start, Restart, or Stop Condition Completed Flag
      IICSDAS    : Bits_2;  -- SDA Output Select
      IICSCLS    : Bits_2;  -- SCL Output Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SIMR3_Type use record
      IICSTAREQ  at 0 range 0 .. 0;
      IICRSTAREQ at 0 range 1 .. 1;
      IICSTPREQ  at 0 range 2 .. 2;
      IICSTIF    at 0 range 3 .. 3;
      IICSDAS    at 0 range 4 .. 5;
      IICSCLS    at 0 range 6 .. 7;
   end record;

   -- 34.2.24 IIC Status Register (SISR)

   type SISR_Type is record
      IICACKR  : Boolean;           -- ACK Reception Data Flag
      Reserved : Bits_7  := 16#7F#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SISR_Type use record
      IICACKR  at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- 34.2.25 SPI Mode Register (SPMR)

   MSS_Master : constant := 0;
   MSS_Slave  : constant := 1;

   CKPOL_NORMAL : constant := 0;
   CKPOL_INVERT : constant := 1;

   CKPH_NORMAL : constant := 0;
   CKPH_DELAY  : constant := 1;

   type SPMR_Type is record
      SSE       : Boolean;      -- SSn Pin Function Enable
      CTSE      : Boolean;      -- CTS Enable
      MSS       : Bits_1;       -- Master Slave Select
      Reserved1 : Bits_1  := 0;
      MFF       : Boolean;      -- Mode Fault Flag
      Reserved2 : Bits_1  := 0;
      CKPOL     : Bits_1;       -- Clock Polarity Select
      CKPH      : Bits_1;       -- Clock Phase Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPMR_Type use record
      SSE       at 0 range 0 .. 0;
      CTSE      at 0 range 1 .. 1;
      MSS       at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      MFF       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      CKPOL     at 0 range 6 .. 6;
      CKPH      at 0 range 7 .. 7;
   end record;

   -- 34.2.26 FIFO Control Register (FCR)

   type FCR_Type is record
      FM    : Boolean; -- FIFO Mode Select
      RFRST : Boolean; -- Receive FIFO Data Register Reset
      TFRST : Boolean; -- Transmit FIFO Data Register Reset
      DRES  : Boolean; -- Receive Data Ready Error Select Bit
      TTRG  : Bits_4;  -- Transmit FIFO Data Trigger Number
      RTRG  : Bits_4;  -- Receive FIFO Data Trigger Number
      RSTRG : Bits_4;  -- RTS Output Active Trigger Number Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for FCR_Type use record
      FM    at 0 range  0 ..  0;
      RFRST at 0 range  1 ..  1;
      TFRST at 0 range  2 ..  2;
      DRES  at 0 range  3 ..  3;
      TTRG  at 0 range  4 ..  7;
      RTRG  at 0 range  8 .. 11;
      RSTRG at 0 range 12 .. 15;
   end record;

   -- 34.2.27 FIFO Data Count Register (FDR)

   type FDR_Type is record
      R         : Bits_5;      -- Receive FIFO Data Count
      Reserved1 : Bits_3 := 0;
      T         : Bits_5;      -- Transmit FIFO Data Count
      Reserved2 : Bits_3 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for FDR_Type use record
      R         at 0 range  0 ..  4;
      Reserved1 at 0 range  5 ..  7;
      T         at 0 range  8 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 34.2.28 Line Status Register (LSR)

   type LSR_Type is record
      ORER      : Boolean;      -- Overrun Error Flag
      Reserved1 : Bits_1  := 0;
      FNUM      : Bits_5;       -- Framing Error Count
      Reserved2 : Bits_1  := 0;
      PNUM      : Bits_5;       -- Parity Error Count
      Reserved3 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for LSR_Type use record
      ORER      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      FNUM      at 0 range  2 ..  6;
      Reserved2 at 0 range  7 ..  7;
      PNUM      at 0 range  8 .. 12;
      Reserved3 at 0 range 13 .. 15;
   end record;

   -- 34.2.29 Compare Match Data Register (CDR)

   type CDR_Type is record
      CMPD     : Bits_9;      -- Compare Match Data
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for CDR_Type use record
      CMPD     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 15;
   end record;

   -- 34.2.30 Data Compare Match Control Register (DCCR)

   IDSEL_Always  : constant := 0;
   IDSEL_IDFrame : constant := 1;

   type DCCR_Type is record
      DCMF      : Boolean;      -- Data Compare Match Flag
      Reserved1 : Bits_2  := 0;
      DPER      : Boolean;      -- Data Compare Match Parity Error Flag
      DFER      : Boolean;      -- Data Compare Match Framing Error Flag
      Reserved2 : Bits_1  := 0;
      IDSEL     : Bits_1;       -- ID Frame Select
      DCME      : Boolean;      -- Data Compare Match Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DCCR_Type use record
      DCMF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 2;
      DPER      at 0 range 3 .. 3;
      DFER      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      IDSEL     at 0 range 6 .. 6;
      DCME      at 0 range 7 .. 7;
   end record;

   -- 34.2.31 Serial Port Register (SPTR)

   type SPTR_Type is record
      RXDMON   : Boolean;      -- Serial Input Data Monitor
      SPB2DT   : Boolean;      -- Serial Port Break Data Select
      SPB2IO   : Boolean;      -- Serial Port Break I/O
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPTR_Type use record
      RXDMON   at 0 range 0 .. 0;
      SPB2DT   at 0 range 1 .. 1;
      SPB2IO   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- SCI0 .. SCI9 memory-mapped array

   type SCI_Type is record
      SMR      : SMR_Type    with Volatile_Full_Access => True;
      BRR      : Unsigned_8  with Volatile_Full_Access => True;
      SCR      : SCR_Type    with Volatile_Full_Access => True;
      TDR      : Unsigned_8  with Volatile_Full_Access => True;
      SSR      : SSR_Type    with Volatile_Full_Access => True;
      RDR      : Unsigned_8  with Volatile_Full_Access => True;
      SCMR     : SCMR_Type   with Volatile_Full_Access => True;
      SEMR     : SEMR_Type   with Volatile_Full_Access => True;
      SNFR     : SNFR_Type   with Volatile_Full_Access => True;
      SIMR1    : SIMR1_Type  with Volatile_Full_Access => True;
      SIMR2    : SIMR2_Type  with Volatile_Full_Access => True;
      SIMR3    : SIMR3_Type  with Volatile_Full_Access => True;
      SISR     : SISR_Type   with Volatile_Full_Access => True;
      SPMR     : SPMR_Type   with Volatile_Full_Access => True;
      TDRHL    : Unsigned_16 with Volatile_Full_Access => True; -- 8/16-bit
      RDRHL    : Unsigned_16 with Volatile_Full_Access => True; -- 8/16-bit
      MDDR     : Unsigned_8  with Volatile_Full_Access => True;
      DCCR     : DCCR_Type   with Volatile_Full_Access => True;
      FCR      : FCR_Type    with Volatile_Full_Access => True;
      FDR      : FDR_Type    with Volatile_Full_Access => True;
      LSR      : LSR_Type    with Volatile_Full_Access => True;
      CDR      : CDR_Type    with Volatile_Full_Access => True;
      SPTR     : SPTR_Type   with Volatile_Full_Access => True;
      Reserved : Bits_24;
   end record
      with Size                    => 16#20# * 8,
           Suppress_Initialization => True;
   for SCI_Type use record
      SMR      at 16#00# range 0 ..  7;
      BRR      at 16#01# range 0 ..  7;
      SCR      at 16#02# range 0 ..  7;
      TDR      at 16#03# range 0 ..  7;
      SSR      at 16#04# range 0 ..  7;
      RDR      at 16#05# range 0 ..  7;
      SCMR     at 16#06# range 0 ..  7;
      SEMR     at 16#07# range 0 ..  7;
      SNFR     at 16#08# range 0 ..  7;
      SIMR1    at 16#09# range 0 ..  7;
      SIMR2    at 16#0A# range 0 ..  7;
      SIMR3    at 16#0B# range 0 ..  7;
      SISR     at 16#0C# range 0 ..  7;
      SPMR     at 16#0D# range 0 ..  7;
      TDRHL    at 16#0E# range 0 .. 15;
      RDRHL    at 16#10# range 0 .. 15;
      MDDR     at 16#12# range 0 ..  7;
      DCCR     at 16#13# range 0 ..  7;
      FCR      at 16#14# range 0 .. 15;
      FDR      at 16#16# range 0 .. 15;
      LSR      at 16#18# range 0 .. 15;
      CDR      at 16#1A# range 0 .. 15;
      SPTR     at 16#1C# range 0 ..  7;
      Reserved at 16#1D# range 0 .. 23;
   end record;

   SCI_BASEADDRESS : constant := 16#4007_0000#;

   SCI : aliased array (0 .. 9) of SCI_Type
      with Address    => System'To_Address (SCI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 36. I2C Bus Interface (IIC)
   ----------------------------------------------------------------------------

   -- 36.2.1 I2C Bus Control Register 1 (ICCR1)

   type ICCR1_Type is record
      SDAI   : Boolean; -- SDA Line Monitor
      SCLI   : Boolean; -- SCL Line Monitor
      SDAO   : Boolean; -- SDA Output Control/Monitor
      SCLO   : Boolean; -- SCL Output Control/Monitor
      SOWP   : Boolean; -- SCLO/SDAO Write Protect
      CLO    : Boolean; -- Extra SCL Clock Cycle Output
      IICRST : Boolean; -- IIC-Bus Interface Internal Reset
      ICE    : Boolean; -- IIC-Bus Interface Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICCR1_Type use record
      SDAI   at 0 range 0 .. 0;
      SCLI   at 0 range 1 .. 1;
      SDAO   at 0 range 2 .. 2;
      SCLO   at 0 range 3 .. 3;
      SOWP   at 0 range 4 .. 4;
      CLO    at 0 range 5 .. 5;
      IICRST at 0 range 6 .. 6;
      ICE    at 0 range 7 .. 7;
   end record;

   -- 36.2.2 I2C Bus Control Register 2 (ICCR2)

   type ICCR2_Type is record
      Reserved1 : Bits_1  := 0;
      ST        : Boolean;      -- Start Condition Issuance Request
      RS        : Boolean;      -- Restart Condition Issuance Request
      SP        : Boolean;      -- Stop Condition Issuance Request
      Reserved2 : Bits_1  := 0;
      TRS       : Boolean;      -- Transmit/Receive Mode
      MST       : Boolean;      -- Master/Slave Mode
      BBSY      : Boolean;      -- Bus Busy Detection Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICCR2_Type use record
      Reserved1 at 0 range 0 .. 0;
      ST        at 0 range 1 .. 1;
      RS        at 0 range 2 .. 2;
      SP        at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      TRS       at 0 range 5 .. 5;
      MST       at 0 range 6 .. 6;
      BBSY      at 0 range 7 .. 7;
   end record;

   -- 36.2.3 I2C Bus Mode Register 1 (ICMR1)

   type ICMR1_Type is record
      BC   : Bits_3;  -- Bit Counter
      BCWP : Boolean; -- BC Write Protect
      CKS  : Bits_3;  -- Internal Reference Clock Select
      MTWP : Boolean; -- MST/TRS Write Protect
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICMR1_Type use record
      BC   at 0 range 0 .. 2;
      BCWP at 0 range 3 .. 3;
      CKS  at 0 range 4 .. 6;
      MTWP at 0 range 7 .. 7;
   end record;

   -- 36.2.4 I2C Bus Mode Register 2 (ICMR2)

   type ICMR2_Type is record
      TMOS     : Boolean;      -- Timeout Detection Time Select
      TMOL     : Boolean;      -- Timeout L Count Control
      TMOH     : Boolean;      -- Timeout H Count Control
      Reserved : Bits_1  := 0;
      SDDL     : Bits_3;       -- SDA Output Delay Counter
      DLCS     : Boolean;      -- SDA Output Delay Clock Source Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICMR2_Type use record
      TMOS     at 0 range 0 .. 0;
      TMOL     at 0 range 1 .. 1;
      TMOH     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 3;
      SDDL     at 0 range 4 .. 6;
      DLCS     at 0 range 7 .. 7;
   end record;

   -- 36.2.5 I2C Bus Mode Register 3 (ICMR3)

   NF_1 : constant := 2#00#; -- Filter out noise of up to 1 IIC cycle (single-stage filter)
   NF_2 : constant := 2#01#; -- Filter out noise of up to 2 IIC cycles (2-stage filter)
   NF_3 : constant := 2#10#; -- Filter out noise of up to 3 IIC cycles (3-stage filter)
   NF_4 : constant := 2#11#; -- Filter out noise of up to 4 IIC cycles (4-stage filter).

   type ICMR3_Type is record
      NF    : Bits_2;  -- Noise Filter Stage Select
      ACKBR : Boolean; -- Receive Acknowledge
      ACKBT : Boolean; -- Transmit Acknowledge
      ACKWP : Boolean; -- ACKBT Write Protect
      RDRFS : Boolean; -- RDRF Flag Set Timing Select
      WAIT  : Boolean; -- WAIT
      SMBS  : Boolean; -- SMBus/IIC-Bus Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICMR3_Type use record
      NF    at 0 range 0 .. 1;
      ACKBR at 0 range 2 .. 2;
      ACKBT at 0 range 3 .. 3;
      ACKWP at 0 range 4 .. 4;
      RDRFS at 0 range 5 .. 5;
      WAIT  at 0 range 6 .. 6;
      SMBS  at 0 range 7 .. 7;
   end record;

   -- 36.2.6 I2C Bus Function Enable Register (ICFER)

   type ICFER_Type is record
      TMOE  : Boolean; -- Timeout Function Enable
      MALE  : Boolean; -- Master Arbitration-Lost Detection Enable
      NALE  : Boolean; -- NACK Transmission Arbitration-Lost Detection Enable
      SALE  : Boolean; -- Slave Arbitration-Lost Detection Enable
      NACKE : Boolean; -- NACK Reception Transfer Suspension Enable
      NFE   : Boolean; -- Digital Noise Filter Circuit Enable
      SCLE  : Boolean; -- SCL Synchronous Circuit Enable
      FMPE  : Boolean; -- Fast-Mode Plus Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICFER_Type use record
      TMOE  at 0 range 0 .. 0;
      MALE  at 0 range 1 .. 1;
      NALE  at 0 range 2 .. 2;
      SALE  at 0 range 3 .. 3;
      NACKE at 0 range 4 .. 4;
      NFE   at 0 range 5 .. 5;
      SCLE  at 0 range 6 .. 6;
      FMPE  at 0 range 7 .. 7;
   end record;

   -- 36.2.7 I2C Bus Status Enable Register (ICSER)

   type ICSER_Type is record
      SAR0E     : Boolean;      -- Slave Address Register 0 Enable
      SAR1E     : Boolean;      -- Slave Address Register 1 Enable
      SAR2E     : Boolean;      -- Slave Address Register 2 Enable
      GCAE      : Boolean;      -- General Call Address Enable
      Reserved1 : Bits_1  := 0;
      DIDE      : Boolean;      -- Device-ID Address Detection Enable
      Reserved2 : Bits_1  := 0;
      HOAE      : Boolean;      -- Host Address Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICSER_Type use record
      SAR0E     at 0 range 0 .. 0;
      SAR1E     at 0 range 1 .. 1;
      SAR2E     at 0 range 2 .. 2;
      GCAE      at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      DIDE      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      HOAE      at 0 range 7 .. 7;
   end record;

   -- 36.2.8 I2C Bus Interrupt Enable Register (ICIER)

   type ICIER_Type is record
      TMOIE  : Boolean; -- Timeout Interrupt Request Enable
      ALIE   : Boolean; -- Arbitration-Lost Interrupt Request Enable
      STIE   : Boolean; -- Start Condition Detection Interrupt Request Enable
      SPIE   : Boolean; -- Stop Condition Detection Interrupt Request Enable
      NACKIE : Boolean; -- NACK Reception Interrupt Request Enable
      RIE    : Boolean; -- Receive Data Full Interrupt Request Enable
      TEIE   : Boolean; -- Transmit End Interrupt Request Enable
      TIE    : Boolean; -- Transmit Data Empty Interrupt Request Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICIER_Type use record
      TMOIE  at 0 range 0 .. 0;
      ALIE   at 0 range 1 .. 1;
      STIE   at 0 range 2 .. 2;
      SPIE   at 0 range 3 .. 3;
      NACKIE at 0 range 4 .. 4;
      RIE    at 0 range 5 .. 5;
      TEIE   at 0 range 6 .. 6;
      TIE    at 0 range 7 .. 7;
   end record;

   -- 36.2.9 I2C Bus Status Register 1 (ICSR1)

   type ICSR1_Type is record
      AAS0      : Boolean;      -- Slave Address 0 Detection Flag
      AAS1      : Boolean;      -- Slave Address 1 Detection Flag
      AAS2      : Boolean;      -- Slave Address 2 Detection Flag
      GCA       : Boolean;      -- General Call Address Detection Flag
      Reserved1 : Bits_1  := 0;
      DID       : Boolean;      -- Device-ID Address Detection Flag
      Reserved2 : Bits_1  := 0;
      HOA       : Boolean;      -- Host Address Detection Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICSR1_Type use record
      AAS0      at 0 range 0 .. 0;
      AAS1      at 0 range 1 .. 1;
      AAS2      at 0 range 2 .. 2;
      GCA       at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      DID       at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      HOA       at 0 range 7 .. 7;
   end record;

   -- 36.2.10 I2C Bus Status Register 2 (ICSR2)

   type ICSR2_Type is record
      TMOF  : Boolean; -- Timeout Detection Flag
      AL    : Boolean; -- Arbitration-Lost Flag
      START : Boolean; -- Start Condition Detection Flag
      STOP  : Boolean; -- Stop Condition Detection Flag
      NACKF : Boolean; -- NACK Detection Flag
      RDRF  : Boolean; -- Receive Data Full Flag
      TEND  : Boolean; -- Transmit End Flag
      TDRE  : Boolean; -- Transmit Data Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICSR2_Type use record
      TMOF  at 0 range 0 .. 0;
      AL    at 0 range 1 .. 1;
      START at 0 range 2 .. 2;
      STOP  at 0 range 3 .. 3;
      NACKF at 0 range 4 .. 4;
      RDRF  at 0 range 5 .. 5;
      TEND  at 0 range 6 .. 6;
      TDRE  at 0 range 7 .. 7;
   end record;

   -- 36.2.11 I2C Bus Wakeup Unit Register (ICWUR)

   type ICWUR_Type is record
      WUAFA    : Boolean;      -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_3  := 0;
      WUACK    : Boolean;      -- ACK Bit for Wakeup Mode
      WUF      : Boolean;      -- Wakeup Event Occurrence Flag
      WUIE     : Boolean;      -- Wakeup Interrupt Request Enable
      WUE      : Boolean;      -- Wakeup Function Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICWUR_Type use record
      WUAFA    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 3;
      WUACK    at 0 range 4 .. 4;
      WUF      at 0 range 5 .. 5;
      WUIE     at 0 range 6 .. 6;
      WUE      at 0 range 7 .. 7;
   end record;

   -- 36.2.12 I2C Bus Wakeup Unit Register 2 (ICWUR2)

   type ICWUR2_Type is record
      WUSEN    : Boolean;           -- Wakeup Analog Filter Additional Selection
      WUASYF   : Boolean;           -- Wakeup Analog Filter Additional Selection
      WUSYF    : Boolean;           -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_5  := 16#1F#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICWUR2_Type use record
      WUSEN    at 0 range 0 .. 0;
      WUASYF   at 0 range 1 .. 1;
      WUSYF    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- I2C

pragma Warnings (Off);
   type I2C_Type is record
      ICCR1  : ICCR1_Type  with Volatile_Full_Access => True;
      ICCR2  : ICCR2_Type  with Volatile_Full_Access => True;
      ICMR1  : ICMR1_Type  with Volatile_Full_Access => True;
      ICMR2  : ICMR2_Type  with Volatile_Full_Access => True;
      ICMR3  : ICMR3_Type  with Volatile_Full_Access => True;
      ICFER  : ICFER_Type  with Volatile_Full_Access => True;
      ICSER  : ICSER_Type  with Volatile_Full_Access => True;
      ICIER  : ICIER_Type  with Volatile_Full_Access => True;
      ICSR1  : ICSR1_Type  with Volatile_Full_Access => True;
      ICSR2  : ICSR2_Type  with Volatile_Full_Access => True;
      ICWUR  : ICWUR_Type  with Volatile_Full_Access => True;
      ICWUR2 : ICWUR2_Type with Volatile_Full_Access => True;
   end record
      with Size                    => 16#100# * 8,
           Suppress_Initialization => True;
   for I2C_Type use record
      ICCR1  at 16#00# range 0 .. 7;
      ICCR2  at 16#01# range 0 .. 7;
      ICMR1  at 16#02# range 0 .. 7;
      ICMR2  at 16#03# range 0 .. 7;
      ICMR3  at 16#04# range 0 .. 7;
      ICFER  at 16#05# range 0 .. 7;
      ICSER  at 16#06# range 0 .. 7;
      ICIER  at 16#07# range 0 .. 7;
      ICSR1  at 16#08# range 0 .. 7;
      ICSR2  at 16#09# range 0 .. 7;
      ICWUR  at 16#16# range 0 .. 7;
      ICWUR2 at 16#17# range 0 .. 7;
   end record;
pragma Warnings (On);

   I2C_BASEADDRESS : constant := 16#4005_3000#;

   I2C : aliased array (0 .. 2) of I2C_Type
      with Address    => System'To_Address (I2C_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 38. Serial Peripheral Interface (SPI)
   ----------------------------------------------------------------------------

   -- 38.2.1 SPI Control Register (SPCR)

   SPMS_SPI4 : constant := 0; -- Select SPI operation (4-wire method)
   SPMS_SPI3 : constant := 1; -- Select clock synchronous operation (3-wire method).

   TXMD_FD : constant := 0; -- Select full-duplex synchronous serial communications
   TXMD_TX : constant := 1; -- Select serial communications with transmit-only.

   MSTR_SLAVE  : constant := 0; -- Select slave mode
   MSTR_MASTER : constant := 1; -- Select master mode.

   type SPCR_Type is record
      SPMS   : Bits_1  := SPMS_SPI4;  -- SPI Mode Select
      TXMD   : Bits_1  := TXMD_FD;    -- Communications Operating Mode Select
      MODFEN : Boolean := False;      -- Mode Fault Error Detection Enable
      MSTR   : Bits_1  := MSTR_SLAVE; -- SPI Master/Slave Mode Select
      SPEIE  : Boolean := False;      -- SPI Error Interrupt Enable
      SPTIE  : Boolean := False;      -- Transmit Buffer Empty Interrupt Enable
      SPE    : Boolean := False;      -- SPI Function Enable
      SPRIE  : Boolean := False;      -- SPI Receive Buffer Full Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPCR_Type use record
      SPMS   at 0 range 0 .. 0;
      TXMD   at 0 range 1 .. 1;
      MODFEN at 0 range 2 .. 2;
      MSTR   at 0 range 3 .. 3;
      SPEIE  at 0 range 4 .. 4;
      SPTIE  at 0 range 5 .. 5;
      SPE    at 0 range 6 .. 6;
      SPRIE  at 0 range 7 .. 7;
   end record;

   -- 38.2.2 SPI Slave Select Polarity Register (SSLP)

   SSL0P_LOW  : constant := 0; -- Set SSL0 signal to active low
   SSL0P_HIGH : constant := 1; -- Set SSL0 signal to active high.

   SSL1P_LOW  : constant := 0; -- Set SSL1 signal to active low
   SSL1P_HIGH : constant := 1; -- Set SSL1 signal to active high.

   SSL2P_LOW  : constant := 0; -- Set SSL2 signal to active low
   SSL2P_HIGH : constant := 1; -- Set SSL2 signal to active high.

   SSL3P_LOW  : constant := 0; -- Set SSL3 signal to active low
   SSL3P_HIGH : constant := 1; -- Set SSL3 signal to active high.

   type SSLP_Type is record
      SSL0P    : Bits_1 := SSL0P_LOW; -- SSL0 Signal Polarity Setting
      SSL1P    : Bits_1 := SSL1P_LOW; -- SSL1 Signal Polarity Setting
      SSL2P    : Bits_1 := SSL2P_LOW; -- SSL2 Signal Polarity Setting
      SSL3P    : Bits_1 := SSL3P_LOW; -- SSL3 Signal Polarity Setting
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSLP_Type use record
      SSL0P    at 0 range 0 .. 0;
      SSL1P    at 0 range 1 .. 1;
      SSL2P    at 0 range 2 .. 2;
      SSL3P    at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   -- 38.2.3 SPI Pin Control Register (SPPCR)

   SPLP_NORMAL   : constant := 0; -- Normal mode
   SPLP_LOOPBACK : constant := 1; -- Loopback mode

   SPLP2_NORMAL   : constant := 0; -- Normal mode
   SPLP2_LOOPBACK : constant := 1; -- Loopback mode

   MOIFV_LOW  : constant := 0; -- Set level output on MOSIn pin during MOSI idling to correspond to low
   MOIFV_HIGH : constant := 1; -- Set level output on MOSIn pin during MOSI idling to correspond to high.

   MOIFE_PREV  : constant := 0; -- Set MOSI output value to equal final data from previous transfer
   MOIFE_MOIFV : constant := 1; -- Set MOSI output value to equal value set in the MOIFV bit.

   type SPPCR_Type is record
      SPLP      : Bits_1 := SPLP_NORMAL;  -- SPI Loopback
      SPLP2     : Bits_1 := SPLP2_NORMAL; -- SPI Loopback 2
      Reserved1 : Bits_2 := 0;
      MOIFV     : Bits_1 := MOIFV_LOW;    -- MOSI Idle Fixed Value
      MOIFE     : Bits_1 := MOIFE_PREV;   -- MOSI Idle Value Fixing Enable
      Reserved2 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPPCR_Type use record
      SPLP      at 0 range 0 .. 0;
      SPLP2     at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      MOIFV     at 0 range 4 .. 4;
      MOIFE     at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   -- 38.2.4 SPI Status Register (SPSR)

   type SPSR_Type is record
      OVRF     : Boolean := False; -- Overrun Error Flag
      IDLNF    : Boolean := False; -- SPI Idle Flag
      MODF     : Boolean := False; -- Mode Fault Error Flag
      PERF     : Boolean := False; -- Parity Error Flag
      UDRF     : Boolean := False; -- Underrun Error Flag
      SPTEF    : Boolean := True;  -- SPI Transmit Buffer Empty Flag
      Reserved : Bits_1  := 0;
      SPRF     : Boolean := False; -- SPI Receive Buffer Full Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPSR_Type use record
      OVRF     at 0 range 0 .. 0;
      IDLNF    at 0 range 1 .. 1;
      MODF     at 0 range 2 .. 2;
      PERF     at 0 range 3 .. 3;
      UDRF     at 0 range 4 .. 4;
      SPTEF    at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 6;
      SPRF     at 0 range 7 .. 7;
   end record;

   -- 38.2.5 SPI Data Register (SPDR/SPDR_HA)

   type SPDR_Type is record
      SPDR : Unsigned_32; -- SPDR/SPDR_HA is the interface with the buffers that hold data for transmission and reception by the SPI.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SPDR_Type use record
      SPDR at 0 range 0 .. 31;
   end record;

   -- 38.2.6 SPI Sequence Control Register (SPSCR)

   SPSLN0 : constant := 2#000#; -- 0-->0
   SPSLN1 : constant := 2#001#; -- 0-->1-->0
   SPSLN2 : constant := 2#010#; -- 0-->1-->2-->0
   SPSLN3 : constant := 2#011#; -- 0-->...>3-->0
   SPSLN4 : constant := 2#100#; -- 0-->...>4-->0
   SPSLN5 : constant := 2#101#; -- 0-->...>5-->0
   SPSLN6 : constant := 2#110#; -- 0-->...>6-->0
   SPSLN7 : constant := 2#111#; -- 0-->...>7-->0

   type SPSCR_Type is record
      SPSLN    : Bits_3 := SPSLN0; -- SPI Sequence Length Specification
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPSCR_Type use record
      SPSLN    at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 38.2.7 SPI Sequence Status Register (SPSSR)

   SPCMD0 : constant := 2#000#;
   SPCMD1 : constant := 2#001#;
   SPCMD2 : constant := 2#010#;
   SPCMD3 : constant := 2#011#;
   SPCMD4 : constant := 2#100#;
   SPCMD5 : constant := 2#101#;
   SPCMD6 : constant := 2#110#;
   SPCMD7 : constant := 2#111#;

   type SPSSR_Type is record
      SPCP      : Bits_3 := SPCMD0; -- SPI Command Pointer
      Reserved1 : Bits_1 := 0;
      SPECM     : Bits_3 := SPCMD0; -- SPI Error Command
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPSSR_Type use record
      SPCP      at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      SPECM     at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- 38.2.8 SPI Bit Rate Register (SPBR)

   type SPBR_Type is record
      SPBR : Bits_8 := 16#FF#; -- SPBR sets the bit rate in master mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPBR_Type use record
      SPBR at 0 range 0 .. 7;
   end record;

   -- 38.2.9 SPI Data Control Register (SPDCR)

   SPFC_1 : constant := 2#00#; -- 1 frame
   SPFC_2 : constant := 2#01#; -- 2 frames
   SPFC_3 : constant := 2#10#; -- 3 frames
   SPFC_4 : constant := 2#11#; -- 4 frames.

   SPRDTD_RB : constant := 0; -- Read SPDR/SPDR_HA values from receive buffer
   SPRDTD_TB : constant := 1; -- Read SPDR/SPDR_HA values from transmit buffer, but only if the transmit buffer is empty.

   SPLW_HALFW : constant := 0; -- Set SPDR_HA to valid for halfword access
   SPLW_FULLW : constant := 1; -- Set SPDR to valid for word access.

   SPBYT_WORD : constant := 0; -- SPDR is accessed in halfword or word (SPLW is valid)
   SPBYT_BYTE : constant := 1; -- SPDR is accessed in byte (SPLW is invalid).

   type SPDCR_Type is record
      SPFC      : Bits_2 := SPFC_1;     -- Number of Frames Specification
      Reserved1 : Bits_2 := 0;
      SPRDTD    : Bits_1 := SPRDTD_RB;  -- SPI Receive/Transmit Data Select
      SPLW      : Bits_1 := SPLW_HALFW; -- SPI Word Access/Halfword Access Specification
      SPBYT     : Bits_1 := SPBYT_WORD; -- SPI Byte Access Specification
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPDCR_Type use record
      SPFC      at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      SPRDTD    at 0 range 4 .. 4;
      SPLW      at 0 range 5 .. 5;
      SPBYT     at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- 38.2.10 SPI Clock Delay Register (SPCKD)

   SCKDL_1RSPCK : constant := 2#000#; -- 1 RSPCK
   SCKDL_2RSPCK : constant := 2#001#; -- 2 RSPCK
   SCKDL_3RSPCK : constant := 2#010#; -- 3 RSPCK
   SCKDL_4RSPCK : constant := 2#011#; -- 4 RSPCK
   SCKDL_5RSPCK : constant := 2#100#; -- 5 RSPCK
   SCKDL_6RSPCK : constant := 2#101#; -- 6 RSPCK
   SCKDL_7RSPCK : constant := 2#110#; -- 7 RSPCK
   SCKDL_8RSPCK : constant := 2#111#; -- 8 RSPCK.

   type SPCKD_Type is record
      SCKDL    : Bits_3 := SCKDL_1RSPCK; -- RSPCK Delay Setting
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPCKD_Type use record
      SCKDL    at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 38.2.11 SPI Slave Select Negation Delay Register (SSLND)

   SLNDL_1RSPCK : constant := 2#000#; -- 1 RSPCK
   SLNDL_2RSPCK : constant := 2#001#; -- 2 RSPCK
   SLNDL_3RSPCK : constant := 2#010#; -- 3 RSPCK
   SLNDL_4RSPCK : constant := 2#011#; -- 4 RSPCK
   SLNDL_5RSPCK : constant := 2#100#; -- 5 RSPCK
   SLNDL_6RSPCK : constant := 2#101#; -- 6 RSPCK
   SLNDL_7RSPCK : constant := 2#110#; -- 7 RSPCK
   SLNDL_8RSPCK : constant := 2#111#; -- 8 RSPCK.

   type SSLND_Type is record
      SLNDL    : Bits_3 := SLNDL_1RSPCK; -- SSL Negation Delay Setting
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSLND_Type use record
      SLNDL    at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 38.2.12 SPI Next-Access Delay Register (SPND)

   SPNDL_1RSPCK : constant := 2#000#; -- 1 RSPCK
   SPNDL_2RSPCK : constant := 2#001#; -- 2 RSPCK
   SPNDL_3RSPCK : constant := 2#010#; -- 3 RSPCK
   SPNDL_4RSPCK : constant := 2#011#; -- 4 RSPCK
   SPNDL_5RSPCK : constant := 2#100#; -- 5 RSPCK
   SPNDL_6RSPCK : constant := 2#101#; -- 6 RSPCK
   SPNDL_7RSPCK : constant := 2#110#; -- 7 RSPCK
   SPNDL_8RSPCK : constant := 2#111#; -- 8 RSPCK.

   type SPND_Type is record
      SPNDL    : Bits_3 := SPNDL_1RSPCK; -- SPI Next-Access Delay Setting
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPND_Type use record
      SPNDL    at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 38.2.13 SPI Control Register 2 (SPCR2)

   SPOE_EVEN : constant := 0; -- Select even parity for transmission and reception
   SPOE_ODD  : constant := 1; -- Select odd parity for transmission and reception.

   type SPCR2_Type is record
      SPPE     : Boolean := False;     -- Parity Enable
      SPOE     : Bits_1  := SPOE_EVEN; -- Parity Mode
      SPIIE    : Boolean := False;     -- SPI Idle Interrupt Enable
      PTE      : Boolean := False;     -- Parity Self-Testing
      SCKASE   : Boolean := False;     -- RSPCK Auto-Stop Function Enable
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPCR2_Type use record
      SPPE     at 0 range 0 .. 0;
      SPOE     at 0 range 1 .. 1;
      SPIIE    at 0 range 2 .. 2;
      PTE      at 0 range 3 .. 3;
      SCKASE   at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 38.2.14 SPI Command Registers 0 to 7 (SPCMD0 to SPCMD7)

   CPHA_LEAD  : constant := 0; -- Select data sampling on leading edge, data change on trailing edge
   CPHA_TRAIL : constant := 1; -- Select data change on leading edge, data sampling on trailing edge.

   CPOL_LOW  : constant := 0; -- Set RSPCK low during idle
   CPOL_HIGH : constant := 1; -- Set RSPCK high during idle.

   BRDV_BASE : constant := 2#00#; -- Base bit rate
   BRDV_DIV2 : constant := 2#01#; -- Base bit rate divided by 2
   BRDV_DIV4 : constant := 2#10#; -- Base bit rate divided by 4
   BRDV_DIV8 : constant := 2#11#; -- Base bit rate divided by 8.

   SSLA_SSL0 : constant := 2#000#; -- SSL0
   SSLA_SSL1 : constant := 2#001#; -- SSL1
   SSLA_SSL2 : constant := 2#010#; -- SSL2
   SSLA_SSL3 : constant := 2#011#; -- SSL3

   SSLKP_NEGATE : constant := 0; -- Negate all SSL signals on completion of transfer
   SSLKP_KEEP   : constant := 1; -- Keep SSL signal level from the end of transfer until the beginning of the next access.

   SPB_8    : constant := 2#0100#; -- 8 bits
   SPB_8_2  : constant := 2#0101#; -- 8 bits
   SPB_8_3  : constant := 2#0110#; -- 8 bits
   SPB_8_4  : constant := 2#0111#; -- 8 bits
   SPB_9    : constant := 2#1000#; -- 9 bits
   SPB_10   : constant := 2#1001#; -- 10 bits
   SPB_11   : constant := 2#1010#; -- 11 bits
   SPB_12   : constant := 2#1011#; -- 12 bits
   SPB_13   : constant := 2#1100#; -- 13 bits
   SPB_14   : constant := 2#1101#; -- 14 bits
   SPB_15   : constant := 2#1110#; -- 15 bits
   SPB_16   : constant := 2#1111#; -- 16 bits
   SPB_20   : constant := 2#0000#; -- 20 bits
   SPB_24   : constant := 2#0001#; -- 24 bits
   SPB_32   : constant := 2#0010#; -- 32 bits.
   SPB_32_2 : constant := 2#0011#; -- 32 bits.

   LSBF_MSB : constant := 0; -- MSB first
   LSBF_LSB : constant := 1; -- LSB first.

   type SPCMD_Type is record
      CPHA   : Bits_1  := CPHA_TRAIL;   -- RSPCK Phase Setting
      CPOL   : Bits_1  := CPOL_HIGH;    -- RSPCK Polarity Setting
      BRDV   : Bits_2  := BRDV_DIV8;    -- Bit Rate Division Setting
      SSLA   : Bits_3  := SSLA_SSL0;    -- SSL Signal Assertion Setting
      SSLKP  : Bits_1  := SSLKP_NEGATE; -- SSL Signal Level Keeping
      SPB    : Bits_4  := SPB_8_4;      -- SPI Data Length Setting
      LSBF   : Bits_1  := LSBF_MSB;     -- SPI LSB First
      SPNDEN : Boolean := False;        -- SPI Next-Access Delay Enable
      SLNDEN : Boolean := False;        -- SSL Negation Delay Setting Enable
      SCKDEN : Boolean := False;        -- RSPCK Delay Setting Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 16,
           Volatile_Full_Access => True;
   for SPCMD_Type use record
      CPHA   at 0 range  0 ..  0;
      CPOL   at 0 range  1 ..  1;
      BRDV   at 0 range  2 ..  3;
      SSLA   at 0 range  4 ..  6;
      SSLKP  at 0 range  7 ..  7;
      SPB    at 0 range  8 .. 11;
      LSBF   at 0 range 12 .. 12;
      SPNDEN at 0 range 13 .. 13;
      SLNDEN at 0 range 14 .. 14;
      SCKDEN at 0 range 15 .. 15;
   end record;

   type SPCMD_Array_Type is array (0 .. 7) of SPCMD_Type
      with Pack => True;

   -- 38.2.15 SPI Data Control Register 2 (SPDCR2)

   type SPDCR2_Type is record
      BYSW     : Boolean := False; -- Byte Swap Operating Mode Select
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPDCR2_Type use record
      BYSW     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- SPI

pragma Warnings (Off);
   type SPI_Type is record
      SPCR   : SPCR_Type        with Volatile_Full_Access => True;
      SSLP   : SSLP_Type        with Volatile_Full_Access => True;
      SPPCR  : SPPCR_Type       with Volatile_Full_Access => True;
      SPSR   : SPSR_Type        with Volatile_Full_Access => True;
      SPDR   : SPDR_Type        with Volatile_Full_Access => True;
      SPSCR  : SPSCR_Type       with Volatile_Full_Access => True;
      SPSSR  : SPSSR_Type       with Volatile_Full_Access => True;
      SPBR   : SPBR_Type        with Volatile_Full_Access => True;
      SPDCR  : SPDCR_Type       with Volatile_Full_Access => True;
      SPCKD  : SPCKD_Type       with Volatile_Full_Access => True;
      SSLND  : SSLND_Type       with Volatile_Full_Access => True;
      SPND   : SPND_Type        with Volatile_Full_Access => True;
      SPCR2  : SPCR2_Type       with Volatile_Full_Access => True;
      SPCMD  : SPCMD_Array_Type with Volatile => True;
      SPDCR2 : SPDCR2_Type      with Volatile_Full_Access => True;
   end record
      with Size                    => 16#100# * 8,
           Suppress_Initialization => True;
   for SPI_Type use record
      SPCR   at 16#00# range 0 ..  7;
      SSLP   at 16#01# range 0 ..  7;
      SPPCR  at 16#02# range 0 ..  7;
      SPSR   at 16#03# range 0 ..  7;
      SPDR   at 16#04# range 0 .. 31;
      SPSCR  at 16#08# range 0 ..  7;
      SPSSR  at 16#09# range 0 ..  7;
      SPBR   at 16#0A# range 0 ..  7;
      SPDCR  at 16#0B# range 0 ..  7;
      SPCKD  at 16#0C# range 0 ..  7;
      SSLND  at 16#0D# range 0 ..  7;
      SPND   at 16#0E# range 0 ..  7;
      SPCR2  at 16#0F# range 0 ..  7;
      SPCMD  at 16#10# range 0 ..  16 * 8 - 1;
      SPDCR2 at 16#20# range 0 ..  7;
   end record;
pragma Warnings (On);

   SPI_BASEADDRESS : constant := 16#4007_2000#;

   SPI : aliased array (0 .. 1) of SPI_Type
      with Address    => System'To_Address (SPI_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 39. Quad Serial Peripheral Interface (QSPI)
   ----------------------------------------------------------------------------

   -- 39.2.1 Transfer Mode Control Register (SFMSMD)

   SFMRM_STD     : constant := 2#000#; -- Standard Read
   SFMRM_FAST    : constant := 2#001#; -- Fast Read
   SFMRM_FASTDO  : constant := 2#010#; -- Fast Read Dual Output
   SFMRM_FASTDIO : constant := 2#011#; -- Fast Read Dual I/O
   SFMRM_FASTQO  : constant := 2#100#; -- Fast Read Quad Output
   SFMRM_FASTQIO : constant := 2#101#; -- Fast Read Quad I/O
   SFMRM_RSVD1   : constant := 2#110#; -- Setting prohibited (unpredictable operation can result)
   SFMRM_RSVD2   : constant := 2#111#; -- Setting prohibited (unpredictable operation can result).

   SFMSE_NONE : constant := 2#00#; -- Do not extend QSSL
   SFMSE_E33  : constant := 2#01#; -- Extend QSSL by 33 QSPCLK
   SFMSE_E129 : constant := 2#10#; -- Extend QSSL by 129 QSPCLK
   SFMSE_EINF : constant := 2#11#; -- Extend QSSL infinitely.

   SFMMD3_MODE0 : constant := 0; -- SPI mode 0
   SFMMD3_MODE3 : constant := 1; -- SPI mode 3.

   SFMCCE_DEFAULT : constant := 0; -- Set default instruction code for each instruction
   SFMCCE_SFMSIC  : constant := 1; -- Write instruction code in the SFMSIC register.

   type SFMSMD_Type is record
      SFMRM     : Bits_3  := SFMRM_STD;      -- Serial interface read mode select
      Reserved1 : Bits_1  := 0;
      SFMSE     : Bits_2  := SFMSE_NONE;     -- QSSL extension function select after SPI bus access
      SFMPFE    : Boolean := False;          -- Prefetch function select
      SFMPAE    : Boolean := False;          -- Function select for stopping prefetch at locations other than on byte boundaries
      SFMMD3    : Bits_1  := SFMMD3_MODE0;   -- SPI mode select.
      SFMOEX    : Boolean := False;          -- Extension select for the I/O buffer output enable signal for the serial interface
      SFMOHW    : Boolean := False;          -- Hold time adjustment for serial transmission
      SFMOSW    : Boolean := False;          -- Setup time adjustment for serial transmission
      Reserved2 : Bits_3  := 0;
      SFMCCE    : Bits_1  := SFMCCE_DEFAULT; -- Read instruction code select
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSMD_Type use record
      SFMRM     at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  3;
      SFMSE     at 0 range  4 ..  5;
      SFMPFE    at 0 range  6 ..  6;
      SFMPAE    at 0 range  7 ..  7;
      SFMMD3    at 0 range  8 ..  8;
      SFMOEX    at 0 range  9 ..  9;
      SFMOHW    at 0 range 10 .. 10;
      SFMOSW    at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 14;
      SFMCCE    at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   -- 39.2.2 Chip Selection Control Register (SFMSSC)

   SFMSW_1  : constant := 2#0000#; -- 1 QSPCLK
   SFMSW_2  : constant := 2#0001#; -- 2 QSPCLK
   SFMSW_3  : constant := 2#0010#; -- 3 QSPCLK
   SFMSW_4  : constant := 2#0011#; -- 4 QSPCLK
   SFMSW_5  : constant := 2#0100#; -- 5 QSPCLK
   SFMSW_6  : constant := 2#0101#; -- 6 QSPCLK
   SFMSW_7  : constant := 2#0110#; -- 7 QSPCLK
   SFMSW_8  : constant := 2#0111#; -- 8 QSPCLK
   SFMSW_9  : constant := 2#1000#; -- 9 QSPCLK
   SFMSW_10 : constant := 2#1001#; -- 10 QSPCLK
   SFMSW_11 : constant := 2#1010#; -- 11 QSPCLK
   SFMSW_12 : constant := 2#1011#; -- 12 QSPCLK
   SFMSW_13 : constant := 2#1100#; -- 13 QSPCLK
   SFMSW_14 : constant := 2#1101#; -- 14 QSPCLK
   SFMSW_15 : constant := 2#1110#; -- 15 QSPCLK
   SFMSW_16 : constant := 2#1111#; -- 16 QSPCLK.

   SFMSHD_05 : constant := 0; -- Release QSSL 0.5 QSPCLK cycles after the last rising edge of QSPCLK
   SFMSHD_15 : constant := 1; -- Release QSSL 1.5 QSPCLK cycles after the last rising edge of QSPCLK.

   SFMSLD_05 : constant := 0; -- Output QSSL 0.5 QSPCLK cycles before the first rising edge of QSPCLK
   SFMSLD_15 : constant := 1; -- Output QSSL 1.5 QSPCLK cycles before the first rising edge of QSPCLK.

   type SFMSSC_Type is record
      SFMSW    : Bits_4  := SFMSW_7;   -- Minimum high-level width select for QSSL signal
      SFMSHD   : Bits_1  := SFMSHD_15; -- QSSL signal release timing select
      SFMSLD   : Bits_1  := SFMSLD_15; -- QSSL signal output timing select
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSSC_Type use record
      SFMSW    at 0 range 0 ..  3;
      SFMSHD   at 0 range 4 ..  4;
      SFMSLD   at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- 39.2.3 Clock Control Register (SFMSKC)

   SFMDV_2  : constant := 2#00000#; -- 2 PCLKA
   SFMDV_3  : constant := 2#00001#; -- 3 PCLKA (multiplied by an odd number)*1
   SFMDV_4  : constant := 2#00010#; -- 4 PCLKA
   SFMDV_5  : constant := 2#00011#; -- 5 PCLKA (multiplied by an odd number)*1
   SFMDV_6  : constant := 2#00100#; -- 6 PCLKA
   SFMDV_7  : constant := 2#00101#; -- 7 PCLKA (multiplied by an odd number)*1
   SFMDV_8  : constant := 2#00110#; -- 8 PCLKA
   SFMDV_9  : constant := 2#00111#; -- 9 PCLKA (multiplied by an odd number)*1
   SFMDV_10 : constant := 2#01000#; -- 10 PCLKA
   SFMDV_11 : constant := 2#01001#; -- 11 PCLKA (multiplied by an odd number)*1
   SFMDV_12 : constant := 2#01010#; -- 12 PCLKA
   SFMDV_13 : constant := 2#01011#; -- 13 PCLKA (multiplied by an odd number)*1
   SFMDV_14 : constant := 2#01100#; -- 14 PCLKA
   SFMDV_15 : constant := 2#01101#; -- 15 PCLKA (multiplied by an odd number)*1
   SFMDV_16 : constant := 2#01110#; -- 16 PCLKA
   SFMDV_17 : constant := 2#01111#; -- 17 PCLKA (multiplied by an odd number)*1
   SFMDV_18 : constant := 2#10000#; -- 18 PCLKA
   SFMDV_20 : constant := 2#10001#; -- 20 PCLKA
   SFMDV_22 : constant := 2#10010#; -- 22 PCLKA
   SFMDV_24 : constant := 2#10011#; -- 24 PCLKA
   SFMDV_26 : constant := 2#10100#; -- 26 PCLKA
   SFMDV_28 : constant := 2#10101#; -- 28 PCLKA
   SFMDV_30 : constant := 2#10110#; -- 30 PCLKA
   SFMDV_32 : constant := 2#10111#; -- 32 PCLKA
   SFMDV_34 : constant := 2#11000#; -- 34 PCLKA
   SFMDV_36 : constant := 2#11001#; -- 36 PCLKA
   SFMDV_38 : constant := 2#11010#; -- 38 PCLKA
   SFMDV_40 : constant := 2#11011#; -- 40 PCLKA
   SFMDV_42 : constant := 2#11100#; -- 42 PCLKA
   SFMDV_44 : constant := 2#11101#; -- 44 PCLKA
   SFMDV_46 : constant := 2#11110#; -- 46 PCLKA
   SFMDV_48 : constant := 2#11111#; -- 48 PCLKA.

   type SFMSKC_Type is record
      SFMDV    : Bits_5  := SFMDV_10; -- Serial interface reference cycle select.
      SFMDTY   : Boolean := False;    -- Duty ratio correction function select for the QSPCLK signal
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSKC_Type use record
      SFMDV    at 0 range 0 ..  4;
      SFMDTY   at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- 39.2.4 Status Register (SFMSST)

   PFCNT_0  : constant := 2#00000#; -- 0 bytes
   PFCNT_1  : constant := 2#00001#; -- 1 byte
   PFCNT_2  : constant := 2#00010#; -- 2 bytes
   PFCNT_3  : constant := 2#00011#; -- 3 bytes
   PFCNT_4  : constant := 2#00100#; -- 4 bytes
   PFCNT_5  : constant := 2#00101#; -- 5 bytes
   PFCNT_6  : constant := 2#00110#; -- 6 bytes
   PFCNT_7  : constant := 2#00111#; -- 7 bytes
   PFCNT_8  : constant := 2#01000#; -- 8 bytes
   PFCNT_9  : constant := 2#01001#; -- 9 bytes
   PFCNT_10 : constant := 2#01010#; -- 10 bytes
   PFCNT_11 : constant := 2#01011#; -- 11 bytes
   PFCNT_12 : constant := 2#01100#; -- 12 bytes
   PFCNT_13 : constant := 2#01101#; -- 13 bytes
   PFCNT_14 : constant := 2#01110#; -- 14 bytes
   PFCNT_15 : constant := 2#01111#; -- 15 bytes
   PFCNT_16 : constant := 2#10000#; -- 16 bytes
   PFCNT_17 : constant := 2#10001#; -- 17 bytes
   PFCNT_18 : constant := 2#10010#; -- 18 bytes.

   type SFMSST_Type is record
      PFCNT     : Bits_5;  -- Number of bytes of prefetched data
      Reserved1 : Bits_1;
      PFFUL     : Boolean; -- Prefetch buffer state
      PFOFF     : Boolean; -- Prefetch function operating state
      Reserved2 : Bits_24;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSST_Type use record
      PFCNT     at 0 range 0 ..  4;
      Reserved1 at 0 range 5 ..  5;
      PFFUL     at 0 range 6 ..  6;
      PFOFF     at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   -- 39.2.5 Communication Port Register (SFMCOM)

   type SFMCOM_Type is record
      SFMD     : Unsigned_8;      -- Port select for direct communication with the SPI bus
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMCOM_Type use record
      SFMD     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 39.2.6 Communication Mode Control Register (SFMCMD)

   DCOM_ROM    : constant := 0; -- ROM access mode
   DCOM_DIRECT : constant := 1; -- Direct communication mode.

   type SFMCMD_Type is record
      DCOM     : Bits_1  := DCOM_ROM; -- Mode select for communication with the SPI bus
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMCMD_Type use record
      DCOM     at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 39.2.7 Communication Status Register (SFMCST)

   type SFMCST_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMCST_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.8 Instruction Code Register (SFMSIC)

   type SFMSIC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSIC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.9 Address Mode Control Register (SFMSAC)

   type SFMSAC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSAC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.10 Dummy Cycle Control Register (SFMSDC)

   type SFMSDC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSDC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.11 SPI Protocol Control Register (SFMSPC)

   type SFMSPC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMSPC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.12 Port Control Register (SFMPMD)

   type SFMPMD_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMPMD_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.13 External QSPI Address Register (SFMCNT1)

   type SFMCNT1_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFMCNT1_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- QSPI

pragma Warnings (Off);
   type QSPI_Type is record
      SFMSMD  : SFMSMD_Type  with Volatile_Full_Access => True;
      SFMSSC  : SFMSSC_Type  with Volatile_Full_Access => True;
      SFMSKC  : SFMSKC_Type  with Volatile_Full_Access => True;
      SFMSST  : SFMSST_Type  with Volatile_Full_Access => True;
      SFMCOM  : SFMCOM_Type  with Volatile_Full_Access => True;
      SFMCMD  : SFMCMD_Type  with Volatile_Full_Access => True;
      SFMCST  : SFMCST_Type  with Volatile_Full_Access => True;
      SFMSIC  : SFMSIC_Type  with Volatile_Full_Access => True;
      SFMSAC  : SFMSAC_Type  with Volatile_Full_Access => True;
      SFMSDC  : SFMSDC_Type  with Volatile_Full_Access => True;
      SFMSPC  : SFMSPC_Type  with Volatile_Full_Access => True;
      SFMPMD  : SFMPMD_Type  with Volatile_Full_Access => True;
      SFMCNT1 : SFMCNT1_Type with Volatile_Full_Access => True;
   end record
      with Size                    => 16#808# * 8,
           Suppress_Initialization => True;
   for QSPI_Type use record
      SFMSMD  at 16#000# range 0 .. 31;
      SFMSSC  at 16#004# range 0 .. 31;
      SFMSKC  at 16#008# range 0 .. 31;
      SFMSST  at 16#00C# range 0 .. 31;
      SFMCOM  at 16#010# range 0 .. 31;
      SFMCMD  at 16#014# range 0 .. 31;
      SFMCST  at 16#018# range 0 .. 31;
      SFMSIC  at 16#020# range 0 .. 31;
      SFMSAC  at 16#024# range 0 .. 31;
      SFMSDC  at 16#028# range 0 .. 31;
      SFMSPC  at 16#030# range 0 .. 31;
      SFMPMD  at 16#034# range 0 .. 31;
      SFMCNT1 at 16#804# range 0 .. 31;
   end record;
pragma Warnings (On);

   QSPI_ADDRESS : constant := 16#6400_0000#;

   QSPI : aliased QSPI_Type
      with Address    => System'To_Address (QSPI_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end S5D9;
