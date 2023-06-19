-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ s5d9.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package S5D9 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Warnings (Off);

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   -- S5D9 Microcontroller Group User''s Manual
   -- Renesas Synergy(TM) Platform
   -- Synergy Microcontrollers S5 Series

   ----------------------------------------------------------------------------
   -- 6. Resets
   ----------------------------------------------------------------------------

   -- 6.2.1 Reset Status Register 0 (RSTSR0)

   type RSTSR0_Type is
   record
      PORF     : Boolean;     -- Power-On Reset Detect Flag
      LVD0RF   : Boolean;     -- Voltage Monitor 0 Reset Detect Flag
      LVD1RF   : Boolean;     -- Voltage Monitor 1 Reset Detect Flag
      LVD2RF   : Boolean;     -- Voltage Monitor 2 Reset Detect Flag
      Reserved : Bits_3 := 0;
      DPSRSTF  : Boolean;     -- Deep Software Standby Reset Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RSTSR0_Type use
   record
      PORF     at 0 range 0 .. 0;
      LVD0RF   at 0 range 1 .. 1;
      LVD1RF   at 0 range 2 .. 2;
      LVD2RF   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 6;
      DPSRSTF  at 0 range 7 .. 7;
   end record;

   RSTSR0_ADDRESS : constant := 16#4001_E410#;

   RSTSR0 : aliased RSTSR0_Type with
      Address              => To_Address (RSTSR0_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 6.2.2 Reset Status Register 1 (RSTSR1)

   type RSTSR1_Type is
   record
      IWDTRF    : Boolean;     -- Independent Watchdog Timer Reset Detect Flag
      WDTRF     : Boolean;     -- Watchdog Timer Reset Detect Flag
      SWRF      : Boolean;     -- Software Reset Detect Flag
      Reserved1 : Bits_5 := 0;
      RPERF     : Boolean;     -- SRAM Parity Error Reset Detect Flag
      REERF     : Boolean;     -- SRAM ECC Error Reset Detect Flag
      BUSSRF    : Boolean;     -- Bus Slave MPU Error Reset Detect Flag
      BUSMRF    : Boolean;     -- Bus Master MPU Error Reset Detect Flag
      SPERF     : Boolean;     -- SP Error Reset Detect Flag
      Reserved2 : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for RSTSR1_Type use
   record
      IWDTRF    at 0 range 0 .. 0;
      WDTRF     at 0 range 1 .. 1;
      SWRF      at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 7;
      RPERF     at 0 range 8 .. 8;
      REERF     at 0 range 9 .. 9;
      BUSSRF    at 0 range 10 .. 10;
      BUSMRF    at 0 range 11 .. 11;
      SPERF     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   RSTSR1_ADDRESS : constant := 16#4001_E0C0#;

   RSTSR1 : aliased RSTSR1_Type with
      Address              => To_Address (RSTSR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 6.2.3 Reset Status Register 2 (RSTSR2)

   type RSTSR2_Type is
   record
      CWSF     : Boolean;     -- Cold/Warm Start Determination Flag
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RSTSR2_Type use
   record
      CWSF     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   RSTSR2_ADDRESS : constant := 16#4001_E411#;

   RSTSR2 : aliased RSTSR2_Type with
      Address              => To_Address (RSTSR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 9. Clock Generation Circuit
   ----------------------------------------------------------------------------

   -- 9.2.1 System Clock Division Control Register (SCKDIVCR)

   CLOCK_NODIV  : constant := 2#000#; -- ×1/1
   CLOCK_DIV_2  : constant := 2#001#; -- ×1/2
   CLOCK_DIV_4  : constant := 2#010#; -- ×1/4
   CLOCK_DIV_8  : constant := 2#011#; -- ×1/8
   CLOCK_DIV_16 : constant := 2#100#; -- ×1/16
   CLOCK_DIV_32 : constant := 2#101#; -- ×1/32
   CLOCK_DIV_64 : constant := 2#110#; -- ×1/64.

   type SCKDIVCR_Type is
   record
      PCKD      : Bits_3;      -- Peripheral Module Clock D
      Reserved1 : Bits_1 := 0;
      PCKC      : Bits_3;      -- Peripheral Module Clock C
      Reserved2 : Bits_1 := 0;
      PCKB      : Bits_3;      -- Peripheral Module Clock B
      Reserved3 : Bits_1 := 0;
      PCKA      : Bits_3;      -- Peripheral Module Clock A
      Reserved4 : Bits_1 := 0;
      BCK       : Bits_3;      -- External Bus Clock
      Reserved5 : Bits_5 := 0;
      ICK       : Bits_3;      -- System Clock
      Reserved6 : Bits_1 := 0;
      FCK       : Bits_3;      -- Flash Interface Clock
      Reserved7 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCKDIVCR_Type use
   record
      PCKD      at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      PCKC      at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
      PCKB      at 0 range 8 .. 10;
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

   SCKDIVCR : aliased SCKDIVCR_Type with
      Address              => To_Address (SCKDIVCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.2 System Clock Division Control Register 2 (SCKDIVCR2)

   UCK_DIV3 : constant := 2#010#; -- ×1/3
   UCK_DIV4 : constant := 2#011#; -- ×1/4
   UCK_DIV5 : constant := 2#100#; -- ×1/5.

   type SCKDIVCR2_Type is
   record
      Reserved1 : Bits_4 := 0;
      UCK       : Bits_3;      -- USB Clock (UCLK) Select
      Reserved2 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SCKDIVCR2_Type use
   record
      Reserved1 at 0 range 0 .. 3;
      UCK       at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   SCKDIVCR2_ADDRESS : constant := 16#4001_E024#;

   SCKDIVCR2 : aliased SCKDIVCR2_Type with
      Address              => To_Address (SCKDIVCR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.3 System Clock Source Control Register (SCKSCR)

   CLK_HOCO : constant := 2#000#; -- High-speed on-chip oscillator
   CLK_MOCO : constant := 2#001#; -- Middle-speed on-chip oscillator
   CLK_LOCO : constant := 2#010#; -- Low-speed on-chip oscillator
   CLK_MOSC : constant := 2#011#; -- Main clock oscillator
   CLK_SOSC : constant := 2#100#; -- Sub-clock oscillator
   CLK_PLL  : constant := 2#101#; -- PLL

   type SCKSCR_Type is
   record
      CKSEL     : Bits_3;      -- Clock Source Select
      Reserved1 : Bits_5 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SCKSCR_Type use
   record
      CKSEL     at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 7;
   end record;

   SCKSCR_ADDRESS : constant := 16#4001_E026#;

   SCKSCR : aliased SCKSCR_Type with
      Address              => To_Address (SCKSCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.4 PLL Clock Control Register (PLLCCR)

   PLIDIV_1 : constant := 2#00#;
   PLIDIV_2 : constant := 2#01#;
   PLIDIV_3 : constant := 2#10#;

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

   type PLLCCR_Type is
   record
      PLIDIV    : Bits_2;      -- PLL Input Frequency Division Ratio Select
      Reserved1 : Bits_2 := 0;
      PLSRCSEL  : Bits_1;      -- PLL Clock Source Select
      Reserved2 : Bits_3 := 0;
      PLLMUL    : Bits_6;      -- PLL Frequency Multiplication Factor Select
      Reserved3 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for PLLCCR_Type use
   record
      PLIDIV    at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      PLSRCSEL  at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
      PLLMUL    at 0 range 8 .. 13;
      Reserved3 at 0 range 14 .. 15;
   end record;

   PLLCCR_ADDRESS : constant := 16#4001_E028#;

   PLLCCR : aliased PLLCCR_Type with
      Address              => To_Address (PLLCCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.5 PLL Control Register (PLLCR)

   type PLLCR_Type is
   record
      PLLSTP   : Boolean;     -- PLL Stop Control
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PLLCR_Type use
   record
      PLLSTP   at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   PLLCR_ADDRESS : constant := 16#4001_E02A#;

   PLLCR : aliased PLLCR_Type with
      Address              => To_Address (PLLCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.7 Main Clock Oscillator Control Register (MOSCCR)

   type MOSCCR_Type is
   record
      MOSTP    : Boolean;     -- Main Clock Oscillator Stop
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MOSCCR_Type use
   record
      MOSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   MOSCCR_ADDRESS : constant := 16#4001_E032#;

   MOSCCR : aliased MOSCCR_Type with
      Address              => To_Address (MOSCCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.8 Subclock Oscillator Control Register (SOSCCR)

   type SOSCCR_Type is
   record
      SOSTP    : Boolean;     -- Sub-Clock Oscillator Stop
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SOSCCR_Type use
   record
      SOSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   SOSCCR_ADDRESS : constant := 16#4001_E480#;

   SOSCCR : aliased SOSCCR_Type with
      Address              => To_Address (SOSCCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.9 Low-Speed On-Chip Oscillator Control Register (LOCOCR)

   type LOCOCR_Type is
   record
      LCSTP    : Boolean;     -- LOCO Stop
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for LOCOCR_Type use
   record
      LCSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   LOCOCR_ADDRESS : constant := 16#4001_E490#;

   LOCOCR : aliased LOCOCR_Type with
      Address              => To_Address (LOCOCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.10 High-Speed On-Chip Oscillator Control Register (HOCOCR)

   type HOCOCR_Type is
   record
      HCSTP    : Boolean;     -- HOCO Stop
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for HOCOCR_Type use
   record
      HCSTP    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   HOCOCR_ADDRESS : constant := 16#4001_E036#;

   HOCOCR : aliased HOCOCR_Type with
      Address              => To_Address (HOCOCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 9.2.15 Oscillation Stabilization Flag Register (OSCSF)

   type OSCSF_Type is
   record
      HOCOSF    : Boolean;     -- HOCO Clock Oscillation Stabilization Flag
      Reserved1 : Bits_2 := 0;
      MOSCSF    : Boolean;     -- Main Clock Oscillation Stabilization Flag
      Reserved2 : Bits_1 := 0;
      PLLSF     : Boolean;     -- PLL Clock Oscillation Stabilization Flag
      Reserved3 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for OSCSF_Type use
      record
      HOCOSF    at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 2;
      MOSCSF    at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      PLLSF     at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 7;
   end record;

   OSCSF_ADDRESS : constant := 16#4001_E03C#;

   OSCSF : aliased OSCSF_Type with
      Address              => To_Address (OSCSF_ADDRESS),
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

   type MOSCWTCR_Type is
   record
      MSTS      : Bits_4;      -- Main Clock Oscillator Wait Time Setting
      Reserved  : Bits_4 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MOSCWTCR_Type use
   record
      MSTS      at 0 range 0 .. 3;
      Reserved  at 0 range 4 .. 7;
   end record;

   MOSCWTCR_ADDRESS : constant := 16#4001_E0A2#;

   MOSCWTCR : aliased MOSCWTCR_Type with
      Address              => To_Address (MOSCWTCR_ADDRESS),
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

   type MOMCR_Type is
   record
      Reserved  : Bits_4 := 0;
      MODRV     : Bits_2;      -- Main Clock Oscillator Drive Capability 0 Switching
      MOSEL     : Bits_1;      -- Main Clock Oscillator Switching
      AUTODRVEN : Boolean;     -- PLL Clock Oscillation Stabilization Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MOMCR_Type use
   record
      Reserved  at 0 range 0 .. 3;
      MODRV     at 0 range 4 .. 5;
      MOSEL     at 0 range 6 .. 6;
      AUTODRVEN at 0 range 7 .. 7;
   end record;

   MOMCR_ADDRESS : constant := 16#4001_E413#;

   MOMCR : aliased MOMCR_Type with
      Address              => To_Address (MOMCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 11. Low Power Modes
   ----------------------------------------------------------------------------

   -- 11.2.1 Standby Control Register (SBYCR)

   type SBYCR_Type is
   record
      Reserved : Bits_14 := 0;
      OPE      : Boolean;      -- Output Port Enable
      SSBY     : Boolean;      -- Software Standby
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SBYCR_Type use
   record
      Reserved at 0 range 0 .. 13;
      OPE      at 0 range 14 .. 14;
      SSBY     at 0 range 15 .. 15;
   end record;

   SBYCR_ADDRESS : constant := 16#4001_E00C#;

   SBYCR : aliased SBYCR_Type with
      Address              => To_Address (SBYCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 11.2.2 Module Stop Control Register A (MSTPCRA)

   type MSTPCRA_Type is
   record
      MSTPA0    : Boolean;             -- SRAM0 Module Stop
      MSTPA1    : Boolean;             -- SRAM1 Module Stop
      Reserved1 : Bits_3 := 16#07#;
      MSTPA5    : Boolean;             -- High-Speed SRAM Module Stop
      MSTPA6    : Boolean;             -- ECC SRAM Module Stop
      MSTPA7    : Boolean;             -- Standby SRAM Module Stop
      Reserved2 : Bits_14 := 16#3FFF#;
      MSTPA22   : Boolean;             -- DMA Controller/Data Transfer Controller Module Stop
      Reserved3 : Bits_9 := 16#1FF#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MSTPCRA_Type use
   record
      MSTPA0    at 0 range 0 .. 0;
      MSTPA1    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      MSTPA5    at 0 range 5 .. 5;
      MSTPA6    at 0 range 6 .. 6;
      MSTPA7    at 0 range 7 .. 7;
      Reserved2 at 0 range 8 .. 21;
      MSTPA22   at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 31;
   end record;

   MSTPCRA_ADDRESS : constant := 16#4001_E01C#;

   MSTPCRA : aliased MSTPCRA_Type with
      Address              => To_Address (MSTPCRA_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 11.2.3 Module Stop Control Register B (MSTPCRB)

   type MSTPCRB_Type is
   record
      Reserved1 : Bits_1 := 1;
      MSTPB1    : Boolean;         -- Controller Area Network 1 Module Stop
      MSTPB2    : Boolean;         -- Controller Area Network 0 Module Stop
      Reserved2 : Bits_2 := 2#11#;
      MSTPB5    : Boolean;         -- IrDA Module Stop
      MSTPB6    : Boolean;         -- Quad Serial Peripheral Interface Module Stop
      MSTPB7    : Boolean;         -- I2C Bus Interface 2 Module Stop
      MSTPB8    : Boolean;         -- I2C Bus Interface 1 Module Stop
      MSTPB9    : Boolean;         -- I2C Bus Interface 0 Module Stop
      Reserved3 : Bits_1 := 1;
      MSTPB11   : Boolean;         -- Universal Serial Bus 2.0 FS Interface Module Stop
      MSTPB12   : Boolean;         -- Universal Serial Bus 2.0 HS Interface Module Stop
      MSTPB13   : Boolean;         -- EPTPC and PTPEDMAC Module Stop
      Reserved4 : Bits_1 := 1;
      MSTPB15   : Boolean;         -- ETHERC0 and EDMAC0 Controller Module Stop
      Reserved5 : Bits_2 := 2#11#;
      MSTPB18   : Boolean;         -- Serial Peripheral Interface 1 Module Stop
      MSTPB19   : Boolean;         -- Serial Peripheral Interface 0 Module Stop
      Reserved6 : Bits_2 := 2#11#;
      MSTPB22   : Boolean;         -- Serial Communication Interface 9 Module Stop
      MSTPB23   : Boolean;         -- Serial Communication Interface 8 Module Stop
      MSTPB24   : Boolean;         -- Serial Communication Interface 7 Module Stop
      MSTPB25   : Boolean;         -- Serial Communication Interface 6 Module Stop
      MSTPB26   : Boolean;         -- Serial Communication Interface 5 Module Stop
      MSTPB27   : Boolean;         -- Serial Communication Interface 4 Module Stop
      MSTPB28   : Boolean;         -- Serial Communication Interface 3 Module Stop
      MSTPB29   : Boolean;         -- Serial Communication Interface 2 Module Stop
      MSTPB30   : Boolean;         -- Serial Communication Interface 1 Module Stop
      MSTPB31   : Boolean;         -- Serial Communication Interface 0 Module Stop
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MSTPCRB_Type use
   record
      Reserved1 at 0 range 0 .. 0;
      MSTPB1    at 0 range 1 .. 1;
      MSTPB2    at 0 range 2 .. 2;
      Reserved2 at 0 range 3 .. 4;
      MSTPB5    at 0 range 5 .. 5;
      MSTPB6    at 0 range 6 .. 6;
      MSTPB7    at 0 range 7 .. 7;
      MSTPB8    at 0 range 8 .. 8;
      MSTPB9    at 0 range 9 .. 9;
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

   MSTPCRB : aliased MSTPCRB_Type with
      Address              => To_Address (MSTPCRB_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 11.2.4 Module Stop Control Register C (MSTPCRC)

   type MSTPCRC_Type is
   record
      MSTPC0    : Boolean;             -- Clock Frequency Accuracy Measurement Circuit Module Stop
      MSTPC1    : Boolean;             -- Cyclic Redundancy Check Calculator Module Stop
      MSTPC2    : Boolean;             -- Parallel Data Capture Module Stop
      MSTPC3    : Boolean;             -- Capacitive Touch Sensing Unit Module Stop
      MSTPC4    : Boolean;             -- Graphics LCD Controller Module Stop
      MSTPC5    : Boolean;             -- JPEG Codec Engine Module Stop
      MSTPC6    : Boolean;             -- 2D Drawing Engine Module Stop
      MSTPC7    : Boolean;             -- Serial Sound Interface Enhanced (channel 1) Module Stop
      MSTPC8    : Boolean;             -- Serial Sound Interface Enhanced (channel 0) Module Stop
      MSTPC9    : Boolean;             -- Sampling Rate Converter Module Stop
      Reserved1 : Bits_1 := 1;
      MSTPC11   : Boolean;             -- Secure Digital Host IF/MultiMediaCard 1 Module Stop
      MSTPC12   : Boolean;             -- Secure Digital Host IF/MultiMediaCard 0 Module Stop
      MSTPC13   : Boolean;             -- Data Operation Circuit Module Stop
      MSTPC14   : Boolean;             -- Event Link Controller Module Stop
      Reserved2 : Bits_1 := 1;
      Reserved3 : Bits_15 := 16#7FFF#;
      MSTPC31   : Boolean;             -- SCE7 Module Stop
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MSTPCRC_Type use
   record
      MSTPC0    at 0 range 0 .. 0;
      MSTPC1    at 0 range 1 .. 1;
      MSTPC2    at 0 range 2 .. 2;
      MSTPC3    at 0 range 3 .. 3;
      MSTPC4    at 0 range 4 .. 4;
      MSTPC5    at 0 range 5 .. 5;
      MSTPC6    at 0 range 6 .. 6;
      MSTPC7    at 0 range 7 .. 7;
      MSTPC8    at 0 range 8 .. 8;
      MSTPC9    at 0 range 9 .. 9;
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

   MSTPCRC : aliased MSTPCRC_Type with
      Address              => To_Address (MSTPCRC_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 11.2.5 Module Stop Control Register D (MSTPCRD)

   type MSTPCRD_Type is
   record
      Reserved1 : Bits_2 := 2#11#;
      MSTPD2    : Boolean;          -- Asynchronous General Purpose Timer 1 Module Stop
      MSTPD3    : Boolean;          -- Asynchronous General Purpose Timer 0 Module Stop
      Reserved2 : Bits_1 := 1;
      MSTPD5    : Boolean;          -- General PWM Timer 32EH0 to 32EH3 and 32E4 to 32E7 and PWM Delay Gen Circuit Module Stop
      MSTPD6    : Boolean;          -- General PWM Timer 328 to 3213 Module Stop
      Reserved3 : Bits_7 := 16#7F#;
      MSTPD14   : Boolean;          -- Port Output Enable for GPT Module Stop
      MSTPD15   : Boolean;          -- 12-Bit A/D Converter 1 Module Stop
      MSTPD16   : Boolean;          -- 12-Bit A/D Converter 0 Module Stop
      Reserved4 : Bits_3 := 16#7#;
      MSTPD20   : Boolean;          -- 12-Bit D/A Converter Module Stop
      Reserved5 : Bits_1 := 1;
      MSTPD22   : Boolean;          -- Temperature Sensor Module Stop
      MSTPD23   : Boolean;          -- High-Speed Analog Comparator 5 Module Stop
      MSTPD24   : Boolean;          -- High-Speed Analog Comparator 4 Module Stop
      MSTPD25   : Boolean;          -- High-Speed Analog Comparator 3 Module Stop
      MSTPD26   : Boolean;          -- High-Speed Analog Comparator 2 Module Stop
      MSTPD27   : Boolean;          -- High-Speed Analog Comparator 1 Module Stop
      MSTPD28   : Boolean;          -- High-Speed Analog Comparator 0 Module Stop
      Reserved6 : Bits_3 := 16#7#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MSTPCRD_Type use
   record
      Reserved1 at 0 range 0 .. 1;
      MSTPD2    at 0 range 2 .. 2;
      MSTPD3    at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      MSTPD5    at 0 range 5 .. 5;
      MSTPD6    at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 13;
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

   MSTPCRD : aliased MSTPCRD_Type with
      Address              => To_Address (MSTPCRD_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 13. Register Write Protection
   ----------------------------------------------------------------------------

   -- 13.2.1 Protect Register (PRCR)

   PRCR_KEY_CODE : constant := 16#A5#;

   type PRCR_Type is
   record
      PRC0      : Boolean;     -- Protect Bit 0
      PRC1      : Boolean;     -- Protect Bit 1
      Reserved1 : Bits_1 := 0;
      PRC3      : Boolean;     -- Protect Bit 3
      Reserved2 : Bits_4 := 0;
      PRKEY     : Unsigned_8;  -- PRC Key Code
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for PRCR_Type use
   record
      PRC0      at 0 range 0 .. 0;
      PRC1      at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      PRC3      at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 7;
      PRKEY     at 0 range 8 .. 15;
   end record;

   PRCR_ADDRESS : constant := 16#4001_E3FE#;

   PRCR : aliased PRCR_Type with
      Address              => To_Address (PRCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 14. Interrupt Controller Unit (ICU)
   ----------------------------------------------------------------------------

   -- 14.2.1 IRQ Control Register i (IRQCRi) (i = 0 to 15)

   type IRQCR_Type is
   record
      IRQMD     : Bits_2;      -- IRQi Detection Sense Select
      Reserved1 : Bits_2 := 0;
      FCLKSEL   : Bits_2;      -- IRQi Digital Filter Sampling Clock Select
      Reserved2 : Bits_1 := 0;
      FLTEN     : Boolean;     -- IRQi Digital Filter Enable
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 8,
      Volatile_Full_Access => True;
   for IRQCR_Type use
   record
      IRQMD     at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      FCLKSEL   at 0 range 4 .. 5;
      Reserved2 at 0 range 6 .. 6;
      FLTEN     at 0 range 7 .. 7;
   end record;

   -- 14.2.2 Non-Maskable Interrupt Status Register (NMISR)

   type NMISR_Type is
   record
      IWDTST    : Boolean; -- IWDT Underflow/Refresh Error Status Flag
      WDTST     : Boolean; -- WDT Underflow/Refresh Error Status Flag
      LVD1ST    : Boolean; -- Voltage Monitor 1 Interrupt Status Flag
      LVD2ST    : Boolean; -- Voltage Monitor 2 Interrupt Status Flag
      Reserved1 : Bits_2;
      OSTST     : Boolean; -- Main Oscillation Stop Detection Interrupt Status Flag
      NMIST     : Boolean; -- NMI Status Flag
      RPEST     : Boolean; -- SRAM Parity Error Interrupt Status Flag
      RECCST    : Boolean; -- SRAM ECC Error Interrupt Status Flag
      BUSSST    : Boolean; -- MPU Bus Slave Error Interrupt Status Flag
      BUSMST    : Boolean; -- MPU Bus Master Error Interrupt Status Flag
      SPEST     : Boolean; -- CPU Stack Pointer Monitor Interrupt Status Flag
      Reserved2 : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for NMISR_Type use
   record
      IWDTST    at 0 range 0 .. 0;
      WDTST     at 0 range 1 .. 1;
      LVD1ST    at 0 range 2 .. 2;
      LVD2ST    at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 5;
      OSTST     at 0 range 6 .. 6;
      NMIST     at 0 range 7 .. 7;
      RPEST     at 0 range 8 .. 8;
      RECCST    at 0 range 9 .. 9;
      BUSSST    at 0 range 10 .. 10;
      BUSMST    at 0 range 11 .. 11;
      SPEST     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.3 Non-Maskable Interrupt Enable Register (NMIER)

   type NMIER_Type is
   record
      IWDTEN    : Boolean;     -- IWDT Underflow/Refresh Error Interrupt Enable
      WDTEN     : Boolean;     -- WDT Underflow/Refresh Error Interrupt Enable
      LVD1EN    : Boolean;     -- Voltage Monitor 1 Interrupt Enable
      LVD2EN    : Boolean;     -- Voltage Monitor 2 Interrupt Enable
      Reserved1 : Bits_2 := 0;
      OSTEN     : Boolean;     -- Main Oscillation Stop Detection Interrupt Enable
      NMIEN     : Boolean;     -- NMI Interrupt Enable
      RPEEN     : Boolean;     -- SRAM Parity Error Interrupt Enable
      RECCEN    : Boolean;     -- SRAM ECC Error Interrupt Enable
      BUSSEN    : Boolean;     -- MPU Bus Slave Error Interrupt Enable
      BUSMEN    : Boolean;     -- MPU Bus Master Error Interrupt Enable
      SPEEN     : Boolean;     -- CPU Stack Pointer Monitor Interrupt Enable
      Reserved2 : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for NMIER_Type use
   record
      IWDTEN    at 0 range 0 .. 0;
      WDTEN     at 0 range 1 .. 1;
      LVD1EN    at 0 range 2 .. 2;
      LVD2EN    at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 5;
      OSTEN     at 0 range 6 .. 6;
      NMIEN     at 0 range 7 .. 7;
      RPEEN     at 0 range 8 .. 8;
      RECCEN    at 0 range 9 .. 9;
      BUSSEN    at 0 range 10 .. 10;
      BUSMEN    at 0 range 11 .. 11;
      SPEEN     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.4 Non-Maskable Interrupt Status Clear Register (NMICLR)

   type NMICLR_Type is
   record
      IWDTCLR   : Boolean;     -- IWDT Clear
      WDTCLR    : Boolean;     -- WDT Clear
      LVD1CLR   : Boolean;     -- LVD1 Clear
      LVD2CLR   : Boolean;     -- LVD2 Clear
      Reserved1 : Bits_2 := 0;
      OSTCLR    : Boolean;     -- OSR Clear
      NMICLR    : Boolean;     -- NMI Clear
      RPECLR    : Boolean;     -- SRAM Parity Error Clear
      RECCCLR   : Boolean;     -- SRAM ECC Error Clear
      BUSSCLR   : Boolean;     -- Bus Slave Error Clear
      BUSMCLR   : Boolean;     -- Bus Master Error Clear
      SPECLR    : Boolean;     -- CPU Stack Pointer Monitor Interrupt Clear
      Reserved2 : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for NMICLR_Type use
   record
      IWDTCLR   at 0 range 0 .. 0;
      WDTCLR    at 0 range 1 .. 1;
      LVD1CLR   at 0 range 2 .. 2;
      LVD2CLR   at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 5;
      OSTCLR    at 0 range 6 .. 6;
      NMICLR    at 0 range 7 .. 7;
      RPECLR    at 0 range 8 .. 8;
      RECCCLR   at 0 range 9 .. 9;
      BUSSCLR   at 0 range 10 .. 10;
      BUSMCLR   at 0 range 11 .. 11;
      SPECLR    at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 14.2.5 NMI Pin Interrupt Control Register (NMICR)

   type NMICR_Type is
   record
      NMIMD     : Bits_1;      -- NMI Detection Set
      Reserved1 : Bits_3 := 0;
      NFCLKSEL  : Bits_2;      -- NMI Digital Filter Sampling Clock Select
      Reserved2 : Bits_1 := 0;
      NFLTEN    : Boolean;     -- NMI Digital Filter Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for NMICR_Type use
   record
      NMIMD     at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      NFCLKSEL  at 0 range 4 .. 5;
      Reserved2 at 0 range 6 .. 6;
      NFLTEN    at 0 range 7 .. 7;
   end record;

   -- 14.2.6 ICU Event Link Setting Register n (IELSRn) (n = 0 to 95)

   type IELSR_Type is
   record
      IELS      : Bits_9;      -- ICU Event Link Select
      Reserved1 : Bits_7 := 0;
      IR        : Boolean;     -- Interrupt Status Flag
      Reserved2 : Bits_7 := 0;
      DTCE      : Boolean;     -- DTC Activation Enable
      Reserved3 : Bits_7 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for IELSR_Type use
   record
      IELS      at 0 range 0 .. 8;
      Reserved1 at 0 range 9 .. 15;
      IR        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 23;
      DTCE      at 0 range 24 .. 24;
      Reserved3 at 0 range 25 .. 31;
   end record;

   -- 14.2.7 DMAC Event Link Setting Register n (DELSRn) (n = 0 to 7)

   type DELSR_Type is
   record
      IELS      : Bits_9;       -- DMAC Event Link Select
      Reserved1 : Bits_7 := 0;
      IR        : Boolean;      -- Interrupt Status Flag for DMAC
      Reserved2 : Bits_15 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for DELSR_Type use
   record
      IELS      at 0 range 0 .. 8;
      Reserved1 at 0 range 9 .. 15;
      IR        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   -- 14.2.8 SYS Event Link Setting Register (SELSR0)

   type SELSR0_Type is
   record
      SELS     : Bits_9;      -- SYS Event Link Select
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SELSR0_Type use
   record
      SELS     at 0 range 0 .. 8;
      Reserved at 0 range 9 .. 15;
   end record;

   -- 14.2.9 Wake Up Interrupt Enable Register (WUPEN)

   type WUPEN_Type is
   record
      IRQWUPEN     : Bitmap_16;   -- IRQ Interrupt Software Standby Returns Enable
      IWDTWUPEN    : Boolean;     -- IWDT Interrupt Software Standby Returns Enable
      KEYWUPEN     : Boolean;     -- Key Interrupt Software Standby Returns Enable
      LVD1WUPEN    : Boolean;     -- LVD1 Interrupt Software Standby Returns Enable
      LVD2WUPEN    : Boolean;     -- LVD2 Interrupt Software Standby Returns Enable
      Reserved1    : Bits_2 := 0;
      ACMPHS0WUPEN : Boolean;     -- ACMPHS0 Interrupt Software Standby Returns Enable
      Reserved2    : Bits_1 := 0;
      RTCALMWUPEN  : Boolean;     -- RTC Alarm Interrupt Software Standby Returns Enable
      RTCPRDWUPEN  : Boolean;     -- RTC Period Interrupt Software Standby Returns Enable
      USBHSWUPEN   : Boolean;     -- USBHS Interrupt Software Standby Returns Enable
      USBFSWUPEN   : Boolean;     -- USBFS Interrupt Software Standby Returns Enable
      AGT1UDWUPEN  : Boolean;     -- AGT1 Underflow Interrupt Software Standby Returns Enable
      AGT1CAWUPEN  : Boolean;     -- AGT1 Compare Match A Interrupt Software Standby Returns Enable
      AGT1CBWUPEN  : Boolean;     -- AGT1 Compare Match B Interrupt Software Standby Returns Enable
      IIC0WUPEN    : Boolean;     -- IIC0 Address Match Interrupt Software Standby Returns Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for WUPEN_Type use
   record
      IRQWUPEN     at 0 range 0 .. 15;
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

   -- ICU layout

   type IRQCR_Array_Type is array (0 .. 15) of IRQCR_Type with
      Pack => True;
   type IELSR_Array_Type is array (0 .. 95) of IELSR_Type with
      Pack => True;
   type DELSR_Array_Type is array (0 .. 7) of DELSR_Type with
      Pack => True;

   type ICU_Type is
   record
      IRQCR  : IRQCR_Array_Type;
      NMICR  : NMICR_Type        with Volatile_Full_Access => True;
      NMIER  : NMIER_Type        with Volatile_Full_Access => True;
      NMICLR : NMICLR_Type       with Volatile_Full_Access => True;
      NMISR  : NMISR_Type        with Volatile_Full_Access => True;
      WUPEN  : WUPEN_Type        with Volatile_Full_Access => True;
      SELSR0 : SELSR0_Type       with Volatile_Full_Access => True;
      DELSR  : DELSR_Array_Type;
      IELSR  : IELSR_Array_Type;
   end record with
      Size => 16#F00# * 8;
   for ICU_Type use
   record
      IRQCR  at 0        range 0 .. 16 * 8 - 1;
      NMICR  at 16#0100# range 0 .. 7;
      NMIER  at 16#0120# range 0 .. 15;
      NMICLR at 16#0130# range 0 .. 15;
      NMISR  at 16#0140# range 0 .. 15;
      WUPEN  at 16#01A0# range 0 .. 31;
      SELSR0 at 15#0200# range 0 .. 15;
      DELSR  at 16#0280# range 0 .. 8 * 32 - 1;
      IELSR  at 16#0300# range 0 .. 96 * 32 - 1;
   end record;

   ICU_ADDRESS : constant := 16#4000_6000#;

   ICU : aliased ICU_Type with
      Address    => To_Address (ICU_ADDRESS),
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 20. I/O Ports
   ----------------------------------------------------------------------------

   -- 20.2.1 Port Control Register 1 (PCNTR1/PODR/PDR)

   type PODR_Type is
   record
      PODR00 : Boolean;
      PODR01 : Boolean;
      PODR02 : Boolean;
      PODR03 : Boolean;
      PODR04 : Boolean;
      PODR05 : Boolean;
      PODR06 : Boolean;
      PODR07 : Boolean;
      PODR08 : Boolean;
      PODR09 : Boolean;
      PODR10 : Boolean;
      PODR11 : Boolean;
      PODR12 : Boolean;
      PODR13 : Boolean;
      PODR14 : Boolean;
      PODR15 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for PODR_Type use
   record
      PODR00 at 0 range 0 .. 0;
      PODR01 at 0 range 1 .. 1;
      PODR02 at 0 range 2 .. 2;
      PODR03 at 0 range 3 .. 3;
      PODR04 at 0 range 4 .. 4;
      PODR05 at 0 range 5 .. 5;
      PODR06 at 0 range 6 .. 6;
      PODR07 at 0 range 7 .. 7;
      PODR08 at 0 range 8 .. 8;
      PODR09 at 0 range 9 .. 9;
      PODR10 at 0 range 10 .. 10;
      PODR11 at 0 range 11 .. 11;
      PODR12 at 0 range 12 .. 12;
      PODR13 at 0 range 13 .. 13;
      PODR14 at 0 range 14 .. 14;
      PODR15 at 0 range 15 .. 15;
   end record;

   type PDR_Type is
   record
      PDR00 : Boolean;
      PDR01 : Boolean;
      PDR02 : Boolean;
      PDR03 : Boolean;
      PDR04 : Boolean;
      PDR05 : Boolean;
      PDR06 : Boolean;
      PDR07 : Boolean;
      PDR08 : Boolean;
      PDR09 : Boolean;
      PDR10 : Boolean;
      PDR11 : Boolean;
      PDR12 : Boolean;
      PDR13 : Boolean;
      PDR14 : Boolean;
      PDR15 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for PDR_Type use
   record
      PDR00 at 0 range 0 .. 0;
      PDR01 at 0 range 1 .. 1;
      PDR02 at 0 range 2 .. 2;
      PDR03 at 0 range 3 .. 3;
      PDR04 at 0 range 4 .. 4;
      PDR05 at 0 range 5 .. 5;
      PDR06 at 0 range 6 .. 6;
      PDR07 at 0 range 7 .. 7;
      PDR08 at 0 range 8 .. 8;
      PDR09 at 0 range 9 .. 9;
      PDR10 at 0 range 10 .. 10;
      PDR11 at 0 range 11 .. 11;
      PDR12 at 0 range 12 .. 12;
      PDR13 at 0 range 13 .. 13;
      PDR14 at 0 range 14 .. 14;
      PDR15 at 0 range 15 .. 15;
   end record;

   -- PORT0 .. PORTB memory-mapped array

   type PORT_Type is
   record
      PODR : PODR_Type   with Volatile_Full_Access => True;
      PDR  : PDR_Type    with Volatile_Full_Access => True;
      EIDR : Unsigned_16 with Volatile_Full_Access => True;
      PIDR : Unsigned_16 with Volatile_Full_Access => True;
      POR  : Unsigned_16 with Volatile_Full_Access => True;
      POSR : Unsigned_16 with Volatile_Full_Access => True;
      EORR : Unsigned_16 with Volatile_Full_Access => True;
      EOSR : Unsigned_16 with Volatile_Full_Access => True;
   end record with
      Size                    => 16#20# * 8,
      Suppress_Initialization => True;
   for PORT_Type use
   record
      PODR at 16#00# range 0 .. 15;
      PDR  at 16#02# range 0 .. 15;
      EIDR at 16#04# range 0 .. 15;
      PIDR at 16#06# range 0 .. 15;
      POR  at 16#08# range 0 .. 15;
      POSR at 16#0A# range 0 .. 15;
      EORR at 16#0C# range 0 .. 15;
      EOSR at 16#0E# range 0 .. 15;
   end record;

   PORT_ADDRESS : constant := 16#4004_0000#;

   PORT : aliased array (0 .. 11) of PORT_Type with
      Address    => To_Address (PORT_ADDRESS),
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

   type PFSR_Type is
   record
      PODR      : Boolean := False;          -- Port Output Data
      PIDR      : Boolean := False;          -- Pmn State
      PDR       : Bits_1 := PDR_PORTIN;      -- Port Direction
      Reserved1 : Bits_1 := 0;
      PCR       : Boolean := False;          -- Pull-up Control
      Reserved2 : Bits_1 := 0;
      NCODR     : Bits_1 := NCODR_CMOS;      -- N-Channel Open-Drain Control
      Reserved3 : Bits_3 := 0;
      DSCR      : Bits_2 := DSCR_LowDrive;   -- Port Drive Capability
      EOFEOR    : Bits_2 := EOFEOR_Dontcare; -- Event on Falling/Event on Rising
      ISEL      : Boolean := False;          -- IRQ Input Enable
      ASEL      : Boolean := False;          -- Analog Input Enable
      PMR       : Boolean := False;          -- Port Mode Control
      Reserved4 : Bits_7 := 0;
      PSEL      : Bits_5;                    -- Peripheral Select
      Reserved5 : Bits_3 := 0;
   end record with
      Bit_Order               => Low_Order_First,
      Size                    => 32,
      Volatile_Full_Access    => True,
      Suppress_Initialization => True;
   for PFSR_Type use
   record
      PODR      at 0 range 0 .. 0;
      PIDR      at 0 range 1 .. 1;
      PDR       at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      PCR       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      NCODR     at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 9;
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

   PFSR_ADDRESS : constant := 16#4004_0800#;

   PFSR : aliased array (0 .. 191) of PFSR_Type with
      Address    => To_Address (PFSR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 20.2.6 Write-Protect Register (PWPR)

   type PWPR_Type is
   record
      Reserved : Bits_6 := 0;
      PFSWE    : Boolean;     -- PmnPFS Register Write Enable
      B0WI     : Boolean;     -- PFSWE Bit Write Disable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PWPR_Type use
   record
      Reserved at 0 range 0 .. 5;
      PFSWE    at 0 range 6 .. 6;
      B0WI     at 0 range 7 .. 7;
   end record;

   PWPR_ADDRESS : constant := 16#4004_0D03#;

   PWPR : aliased PWPR_Type with
      Address              => To_Address (PWPR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 25. Asynchronous General-Purpose Timer (AGT)
   ----------------------------------------------------------------------------

   -- 25.2.4 AGT Control Register (AGTCR)

   AGTCR_TSTART_STOP  : constant := 0;
   AGTCR_TSTART_START : constant := 1;

   AGTCR_TCSTF_STOPPED  : constant := 0;
   AGTCR_TCSTF_PROGRESS : constant := 1;

   AGTCR_TSTOP_WINV : constant := 0;
   AGTCR_TSTOP_STOP : constant := 1;

   type AGTCR_Type is
   record
      TSTART   : Bits_1;      -- AGT Count Start
      TCSTF    : Bits_1;      -- AGT Count Status Flag
      TSTOP    : Bits_1;      -- AGT Count Forced Stop
      Reserved : Bits_1 := 0;
      TEDGF    : Boolean;     -- Active Edge Judgment Flag
      TUNDF    : Boolean;     -- Underflow Flag
      TCMAF    : Boolean;     -- Compare Match A Flag
      TCMBF    : Boolean;     -- Compare Match B Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for AGTCR_Type use
   record
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

   AGTMR1_TMOD_TIMER  : constant := 2#000#;
   AGTMR1_TMOD_PULSE  : constant := 2#001#;
   AGTMR1_TMOD_EVENT  : constant := 2#010#;
   AGTMR1_TMOD_PWMEAS : constant := 2#011#;
   AGTMR1_TMOD_PPMEAS : constant := 2#100#;

   AGTMR1_TEDGPL_SINGLE : constant := 0;
   AGTMR1_TEDGPL_BOTH   : constant := 1;

   AGTMR1_TCK_PCLKB   : constant := 2#000#;
   AGTMR1_TCK_PCLKB8  : constant := 2#001#;
   AGTMR1_TCK_PCLKB2  : constant := 2#011#;
   AGTMR1_TCK_AGTLCLK : constant := 2#100#;
   AGTMR1_TCK_AGT0    : constant := 2#101#;
   AGTMR1_TCK_AGTSCLK : constant := 2#110#;

   type AGTMR1_Type is
   record
      TMOD     : Bits_3;      -- Operating Mode
      TEDGPL   : Bits_1;      -- Edge Polarity
      TCK      : Bits_3;      -- Count Source
      Reserved : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for AGTMR1_Type use
   record
      TMOD     at 0 range 0 .. 2;
      TEDGPL   at 0 range 3 .. 3;
      TCK      at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   -- 25.2.6 AGT Mode Register 2 (AGTMR2)

   AGTMR2_FDIV1   : constant := 2#000#;
   AGTMR2_FDIV2   : constant := 2#001#;
   AGTMR2_FDIV4   : constant := 2#010#;
   AGTMR2_FDIV8   : constant := 2#011#;
   AGTMR2_FDIV16  : constant := 2#100#;
   AGTMR2_FDIV32  : constant := 2#101#;
   AGTMR2_FDIV64  : constant := 2#110#;
   AGTMR2_FDIV128 : constant := 2#111#;

   type AGTMR2_Type is
   record
      CKS      : Bits_3;      -- AGTSCLK/AGTLCLK Count Source Clock Frequency Division Ratio
      Reserved : Bits_4 := 0;
      LPM      : Boolean;     -- Low Power Mode
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for AGTMR2_Type use
   record
      CKS      at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 6;
      LPM      at 0 range 7 .. 7;
   end record;

   -- 25.2.9 AGT Compare Match Function Select Register (AGTCMSR)

   type AGTCMSR_Type is
   record
      TCMEA     : Boolean;     -- Compare Match A Register Enable
      TOEA      : Boolean;     -- AGTOAn Output Enable
      TOPOLA    : Boolean;     -- AGTOAn Polarity Select
      Reserved1 : Bits_1 := 0;
      TCMEB     : Boolean;     -- Compare Match B Register Enable
      TOEB      : Boolean;     -- AGTOBn Output Enable
      TOPOLB    : Boolean;     -- AGTOBn Polarity Select
      Reserved2 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for AGTCMSR_Type use
   record
      TCMEA     at 0 range 0 .. 0;
      TOEA      at 0 range 1 .. 1;
      TOPOLA    at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 3;
      TCMEB     at 0 range 4 .. 4;
      TOEB      at 0 range 5 .. 5;
      TOPOLB    at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- AGT0 .. 1

   type AGT_Type is
   record
      AGTC     : Unsigned_16;
      AGTCMA   : Unsigned_16;
      AGTCMB   : Unsigned_16;
      Pad1     : Unsigned_16;
      AGTCR    : AGTCR_Type;
      AGTMR1   : AGTMR1_Type;
      AGTMR2   : AGTMR2_Type;
      Pad2     : Unsigned_8;
      AGTIOC   : Unsigned_8;
      AGTISR   : Unsigned_8;
      AGTCMSR  : AGTCMSR_Type;
      AGTIOSEL : Unsigned_8;
   end record with
      Size => 16 * 8;
   for AGT_Type use
   record
      AGTC     at 16#00# range 0 .. 15;
      AGTCMA   at 16#02# range 0 .. 15;
      AGTCMB   at 16#04# range 0 .. 15;
      Pad1     at 16#06# range 0 .. 15;
      AGTCR    at 16#08# range 0 .. 7;
      AGTMR1   at 16#09# range 0 .. 7;
      AGTMR2   at 16#0A# range 0 .. 7;
      Pad2     at 16#0B# range 0 .. 7;
      AGTIOC   at 16#0C# range 0 .. 7;
      AGTISR   at 16#0D# range 0 .. 7;
      AGTCMSR  at 16#0E# range 0 .. 7;
      AGTIOSEL at 16#0F# range 0 .. 7;
   end record;

   AGT_ADDRESS : constant := 16#4008_4000#;

   AGT0 : aliased AGT_Type with
      Address    => To_Address (AGT_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   AGT1 : aliased AGT_Type with
      Address    => To_Address (AGT_ADDRESS + 16#0100#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 34. Serial Communications Interface (SCI)
   ----------------------------------------------------------------------------

   type SCI_Kind is (NORMAL, FIFO, SMIF);

   type CHR_Data_Length_Type is
   record
      CHR  : Bits_1;
      CHR1 : Bits_1;
   end record;

   CHR_9 : constant CHR_Data_Length_Type := (0, 0); -- Transmit/receive in 9-bit data length (also (1, 0))
   CHR_8 : constant CHR_Data_Length_Type := (0, 1); -- Transmit/receive in 8-bit data length
   CHR_7 : constant CHR_Data_Length_Type := (1, 1); -- Transmit/receive in 7-bit data length

   type BCP_Type is
   record
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

   SMR_CKS_PCLKA   : constant := 2#00#; -- PCLKA clock (n = 0)
   SMR_CKS_PCLKA4  : constant := 2#01#; -- PCLKA/4 clock (n = 1)
   SMR_CKS_PCLKA16 : constant := 2#10#; -- PCLKA/16 clock (n = 2)
   SMR_CKS_PCLKA64 : constant := 2#11#; -- PCLKA/64 clock (n = 3)

   SMR_STOP_1 : constant := 0; -- 1 stop bit
   SMR_STOP_2 : constant := 1; -- 2 stop bit

   SMR_PM_EVEN : constant := 0; -- even parity
   SMR_PM_ODD  : constant := 1; -- odd parity

   SMR_CM_ASYNC : constant := 0; -- Asynchronous mode or simple IIC mode
   SMR_CM_SYNC  : constant := 1; -- Clock synchronous mode or simple SPI mode

   type SMR_NORMAL_Type is
   record
      CKS  : Bits_2;  -- Clock Select
      MP   : Boolean; -- Multi-Processor Mode
      STOP : Bits_1;  -- Stop Bit Length
      PM   : Bits_1;  -- Parity Mode
      PE   : Boolean; -- Parity Enable
      CHR  : Bits_1;  -- Character Length
      CM   : Bits_1;  -- Communication Mode
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SMR_NORMAL_Type use
   record
      CKS  at 0 range 0 .. 1;
      MP   at 0 range 2 .. 2;
      STOP at 0 range 3 .. 3;
      PM   at 0 range 4 .. 4;
      PE   at 0 range 5 .. 5;
      CHR  at 0 range 6 .. 6;
      CM   at 0 range 7 .. 7;
   end record;

   type SMR_SMIF_Type is
   record
      CKS   : Bits_2;                 -- Clock Select
      BCP10 : Bits_2 := BCP_32.BCP10; -- Base Clock Pulse
      PM    : Bits_1;                 -- Parity Mode
      PE    : Boolean;                -- Parity Enable
      BLK   : Boolean;                -- Block Transfer Mode
      GM    : Boolean;                -- GSM Mode
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SMR_SMIF_Type use
   record
      CKS   at 0 range 0 .. 1;
      BCP10 at 0 range 2 .. 3;
      PM    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      BLK   at 0 range 6 .. 6;
      GM    at 0 range 7 .. 7;
   end record;

   type SMR_Type (S : SCI_Kind := NORMAL) is
   record
      case S is
         when NORMAL | FIFO => NORMAL : SMR_NORMAL_Type;
         when SMIF          => SMIF   : SMR_SMIF_Type;
      end case;
   end record with
      Pack            => True,
      Unchecked_Union => True;

   -- 34.2.11 Serial Control Register (SCR) for Non-Smart Card Interface Mode (SCMR.SMIF = 0)
   -- 34.2.12 Serial Control Register for Smart Card Interface Mode (SCR_SMCI) (SCMR.SMIF = 1)

   CKE_Async_On_Chip_BRG_SCK_IO  : constant := 2#00#;
   CKE_Async_On_Chip_BRG_SCK_CLK : constant := 2#01#;
   CKE_Async_Ext_BRG             : constant := 2#10#; -- also 2#11#
   CKE_Sync_Int_CLK              : constant := 2#00#; -- also 2#01#
   CKE_Sync_Ext_CLK              : constant := 2#10#; -- also 2#11#

   type SCR_Type is
   record
      CKE  : Bits_2;           -- Clock Enable
      TEIE : Boolean;          -- Transmit End Interrupt Enable
      MPIE : Boolean := False; -- Multi-Processor Interrupt Enable
      RE   : Boolean;          -- Receive Enable
      TE   : Boolean;          -- Transmit Enable
      RIE  : Boolean;          -- Receive Interrupt Enable
      TIE  : Boolean;          -- Transmit Interrupt Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SCR_Type use
   record
      CKE  at 0 range 0 .. 1;
      TEIE at 0 range 2 .. 2;
      MPIE at 0 range 3 .. 3;
      RE   at 0 range 4 .. 4;
      TE   at 0 range 5 .. 5;
      RIE  at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 34.2.13 Serial Status Register (SSR) for Non-Smart Card Interface and Non-FIFO Mode (SCMR.SMIF = 0 and FCR.FM = 0)

   SSR_MPBT_DATA : constant := 0;
   SSR_MPBT_ID   : constant := 1;

   SSR_MPB_DATA : constant := 0;
   SSR_MPB_ID   : constant := 1;

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
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SSR_NORMAL_Type use
   record
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

   type SSR_FIFO_Type is
   record
      DR       : Boolean;     -- Receive Data Ready Flag
      Reserved : Bits_1 := 1;
      TEND     : Boolean;     -- Transmit End Flag
      PER      : Boolean;     -- Parity Error Flag
      FER      : Boolean;     -- Framing Error Flag
      ORER     : Boolean;     -- Overrun Error Flag
      RDF      : Boolean;     -- Receive FIFO Data Full Flag
      TDFE     : Boolean;     -- Transmit FIFO Data Empty Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SSR_FIFO_Type use
   record
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

   type SSR_SMIF_Type is
   record
      MPBT : Bits_1;  -- Multi-Processor Bit Transfer
      MPB  : Bits_1;  -- Multi-Processor
      TEND : Boolean; -- Transmit End Flag
      PER  : Boolean; -- Parity Error Flag
      ERS  : Boolean; -- Error Signal Status Flag
      ORER : Boolean; -- Overrun Error Flag
      RDRF : Boolean; -- Receive Data Full Flag
      TDRE : Boolean; -- Transmit Data Empty Flag
   end record with
      Bit_Order => Low_Order_First,
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

   type SSR_Type (S : SCI_Kind := NORMAL) is
   record
      case S is
         when NORMAL => NORMAL : SSR_NORMAL_Type;
         when FIFO   => FIFO   : SSR_FIFO_Type;
         when SMIF   => SMIF   : SSR_SMIF_Type;
      end case;
   end record with
      Pack            => True,
      Unchecked_Union => True;

   -- 34.2.16 Smart Card Mode Register (SCMR)

   SCMR_SINV_NO  : constant := 0;
   SCMR_SINV_YES : constant := 1;

   SCMR_SDIR_LSB : constant := 0;
   SCMR_SDIR_MSB : constant := 1;

   type SCMR_Type is
   record
      SMIF      : Boolean;               -- Smart Card Interface Mode Select
      Reserved1 : Bits_1 := 1;
      SINV      : Bits_1;                -- Transmitted/Received Data Invert
      SDIR      : Bits_1;                -- Transmitted/Received Data Transfer Direction
      CHR1      : Bits_1;                -- Character Length 1
      Reserved2 : Bits_2 := 2#11#;
      BCP2      : Bits_1 := BCP_32.BCP2; -- Base Clock Pulse 2
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SCMR_Type use
   record
      SMIF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      SINV      at 0 range 2 .. 2;
      SDIR      at 0 range 3 .. 3;
      CHR1      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 6;
      BCP2      at 0 range 7 .. 7;
   end record;

   -- 34.2.19 Serial Extended Mode Register (SEMR)

   type SEMR_Type is
   record
      Reserved : Bits_2 := 0;
      BRME     : Boolean;     -- Bit Rate Modulation Enable
      ABCSE    : Boolean;     -- Asynchronous Mode Extended Base Clock Select 1
      ABCS     : Boolean;     -- Asynchronous Mode Base Clock Select
      NFEN     : Boolean;     -- Digital Noise Filter Function Enable
      BGDM     : Boolean;     -- Baud Rate Generator Double-Speed Mode Select
      RXDESEL  : Boolean;     -- Asynchronous Start Bit Edge Detection Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SEMR_Type use
   record
      Reserved at 0 range 0 .. 1;
      BRME     at 0 range 2 .. 2;
      ABCSE    at 0 range 3 .. 3;
      ABCS     at 0 range 4 .. 4;
      NFEN     at 0 range 5 .. 5;
      BGDM     at 0 range 6 .. 6;
      RXDESEL  at 0 range 7 .. 7;
   end record;

   -- 34.2.20 Noise Filter Setting Register (SNFR)

   SNFR_NFCS_ASYNC_1 : constant := 2#000#; -- Use clock signal divided by 1 with noise filter
   SNFR_NFCS_IIC_1   : constant := 2#001#; -- Use clock signal divided by 1 with noise filter
   SNFR_NFCS_IIC_2   : constant := 2#010#; -- Use clock signal divided by 2 with noise filter
   SNFR_NFCS_IIC_4   : constant := 2#011#; -- Use clock signal divided by 4 with noise filter
   SNFR_NFCS_IIC_8   : constant := 2#100#; -- Use clock signal divided by 8 with noise filter.

   type SNFR_Type is
   record
      NFCS     : Bits_3;      -- Noise Filter Clock Select
      Reserved : Bits_5 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SNFR_Type use
   record
      NFCS     at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 34.2.21 IIC Mode Register 1 (SIMR1)

   type SIMR1_Type is
   record
      IICM     : Boolean;     -- Simple IIC Mode Select
      Reserved : Bits_2 := 0;
      IICDL    : Bits_5;      -- SDA Delay Output Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SIMR1_Type use
   record
      IICM     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 2;
      IICDL    at 0 range 3 .. 7;
   end record;

   -- 34.2.22 IIC Mode Register 2 (SIMR2)

   SIMR2_IICINTM_ACKNACK : constant := 0;
   SIMR2_IICINTM_RXTX    : constant := 1;

   SIMR2_IICACKT_ACK  : constant := 0;
   SIMR2_IICACKT_NACK : constant := 1;

   type SIMR2_Type is
   record
      IICINTM   : Bits_1;      -- IIC Interrupt Mode Select
      IICCSC    : Boolean;     -- Clock Synchronization
      Reserved1 : Bits_3 := 0;
      IICACKT   : Bits_1;      -- ACK Transmission Data
      Reserved2 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SIMR2_Type use
   record
      IICINTM   at 0 range 0 .. 0;
      IICCSC    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      IICACKT   at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   -- 34.2.23 IIC Mode Register 3 (SIMR3)

   SIMR3_IICSDAS_OUTSER : constant := 2#00#;
   SIMR3_IICSDAS_GEN    : constant := 2#01#;
   SIMR3_IICSDAS_SDALOW : constant := 2#10#;
   SIMR3_IICSDAS_SDAHIZ : constant := 2#11#;

   SIMR3_IICSCLS_OUTSER : constant := 2#00#;
   SIMR3_IICSCLS_GEN    : constant := 2#01#;
   SIMR3_IICSCLS_SDALOW : constant := 2#10#;
   SIMR3_IICSCLS_SDAHIZ : constant := 2#11#;

   type SIMR3_Type is
   record
      IICSTAREQ  : Boolean; -- Start Condition Generation
      IICRSTAREQ : Boolean; -- Restart Condition Generation
      IICSTPREQ  : Boolean; -- Stop Condition Generation
      IICSTIF    : Boolean; -- Issuing of Start, Restart, or Stop Condition Completed Flag
      IICSDAS    : Bits_2;  -- SDA Output Select
      IICSCLS    : Bits_2;  -- SCL Output Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SIMR3_Type use
   record
      IICSTAREQ  at 0 range 0 .. 0;
      IICRSTAREQ at 0 range 1 .. 1;
      IICSTPREQ  at 0 range 2 .. 2;
      IICSTIF    at 0 range 3 .. 3;
      IICSDAS    at 0 range 4 .. 5;
      IICSCLS    at 0 range 6 .. 7;
   end record;

   -- 34.2.24 IIC Status Register (SISR)

   type SISR_Type is
   record
      IICACKR  : Boolean;          -- ACK Reception Data Flag
      Reserved : Bits_7 := 16#7F#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SISR_Type use
   record
      IICACKR  at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- 34.2.25 SPI Mode Register (SPMR)

   SPMR_MSS_Master : constant := 0;
   SPMR_MSS_Slave  : constant := 1;

   SPMR_CKPOL_NORMAL : constant := 0;
   SPMR_CKPOL_INVERT : constant := 1;

   SPMR_CKPH_NORMAL : constant := 0;
   SPMR_CKPH_DELAY  : constant := 1;

   type SPMR_Type is
   record
      SSE       : Boolean;     -- SSn Pin Function Enable
      CTSE      : Boolean;     -- CTS Enable
      MSS       : Bits_1;      -- Master Slave Select
      Reserved1 : Bits_1 := 0;
      MFF       : Boolean;     -- Mode Fault Flag
      Reserved2 : Bits_1 := 0;
      CKPOL     : Bits_1;      -- Clock Polarity Select
      CKPH      : Bits_1;      -- Clock Phase Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPMR_Type use
   record
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

   type FCR_Type is
   record
      FM    : Boolean; -- FIFO Mode Select
      RFRST : Boolean; -- Receive FIFO Data Register Reset
      TFRST : Boolean; -- Transmit FIFO Data Register Reset
      DRES  : Boolean; -- Receive Data Ready Error Select Bit
      TTRG  : Bits_4;  -- Transmit FIFO Data Trigger Number
      RTRG  : Bits_4;  -- Receive FIFO Data Trigger Number
      RSTRG : Bits_4;  -- RTS Output Active Trigger Number Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for FCR_Type use
   record
      FM    at 0 range 0 .. 0;
      RFRST at 0 range 1 .. 1;
      TFRST at 0 range 2 .. 2;
      DRES  at 0 range 3 .. 3;
      TTRG  at 0 range 4 .. 7;
      RTRG  at 0 range 8 .. 11;
      RSTRG at 0 range 12 .. 15;
   end record;

   -- 34.2.27 FIFO Data Count Register (FDR)

   type FDR_Type is
   record
      R         : Bits_5;      -- Receive FIFO Data Count
      Reserved1 : Bits_3 := 0;
      T         : Bits_5;      -- Transmit FIFO Data Count
      Reserved2 : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for FDR_Type use
   record
      R         at 0 range 0 .. 4;
      Reserved1 at 0 range 5 .. 7;
      T         at 0 range 8 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 34.2.28 Line Status Register (LSR)

   type LSR_Type is
   record
      ORER      : Boolean;     -- Overrun Error Flag
      Reserved1 : Bits_1 := 0;
      FNUM      : Bits_5;      -- Framing Error Count
      Reserved2 : Bits_1 := 0;
      PNUM      : Bits_5;      -- Parity Error Count
      Reserved3 : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for LSR_Type use
   record
      ORER      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      FNUM      at 0 range 2 .. 6;
      Reserved2 at 0 range 7 .. 7;
      PNUM      at 0 range 8 .. 12;
      Reserved3 at 0 range 13 .. 15;
   end record;

   -- 34.2.29 Compare Match Data Register (CDR)

   type CDR_Type is
   record
      CMPD     : Bits_9;      -- Compare Match Data
      Reserved : Bits_7 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for CDR_Type use
   record
      CMPD     at 0 range 0 .. 8;
      Reserved at 0 range 9 .. 15;
   end record;

   -- 34.2.30 Data Compare Match Control Register (DCCR)

   DCCR_IDSEL_Always  : constant := 0;
   DCCR_IDSEL_IDFrame : constant := 1;

   type DCCR_Type is
   record
      DCMF      : Boolean;     -- Data Compare Match Flag
      Reserved1 : Bits_2 := 0;
      DPER      : Boolean;     -- Data Compare Match Parity Error Flag
      DFER      : Boolean;     -- Data Compare Match Framing Error Flag
      Reserved2 : Bits_1 := 0;
      IDSEL     : Bits_1;      -- ID Frame Select
      DCME      : Boolean;     -- Data Compare Match Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DCCR_Type use
   record
      DCMF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 2;
      DPER      at 0 range 3 .. 3;
      DFER      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      IDSEL     at 0 range 6 .. 6;
      DCME      at 0 range 7 .. 7;
   end record;

   -- 34.2.31 Serial Port Register (SPTR)

   type SPTR_Type is
   record
      RXDMON   : Boolean;     -- Serial Input Data Monitor
      SPB2DT   : Boolean;     -- Serial Port Break Data Select
      SPB2IO   : Boolean;     -- Serial Port Break I/O
      Reserved : Bits_5 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPTR_Type use
   record
      RXDMON   at 0 range 0 .. 0;
      SPB2DT   at 0 range 1 .. 1;
      SPB2IO   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- SCI0 .. SCI9 memory-mapped array

   type SCI_Type is
   record
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
   end record with
      Size                    => 16#20# * 8,
      Suppress_Initialization => True;
   for SCI_Type use
   record
      SMR      at 16#00# range 0 .. 7;
      BRR      at 16#01# range 0 .. 7;
      SCR      at 16#02# range 0 .. 7;
      TDR      at 16#03# range 0 .. 7;
      SSR      at 16#04# range 0 .. 7;
      RDR      at 16#05# range 0 .. 7;
      SCMR     at 16#06# range 0 .. 7;
      SEMR     at 16#07# range 0 .. 7;
      SNFR     at 16#08# range 0 .. 7;
      SIMR1    at 16#09# range 0 .. 7;
      SIMR2    at 16#0A# range 0 .. 7;
      SIMR3    at 16#0B# range 0 .. 7;
      SISR     at 16#0C# range 0 .. 7;
      SPMR     at 16#0D# range 0 .. 7;
      TDRHL    at 16#0E# range 0 .. 15;
      RDRHL    at 16#10# range 0 .. 15;
      MDDR     at 16#12# range 0 .. 7;
      DCCR     at 16#13# range 0 .. 7;
      FCR      at 16#14# range 0 .. 15;
      FDR      at 16#16# range 0 .. 15;
      LSR      at 16#18# range 0 .. 15;
      CDR      at 16#1A# range 0 .. 15;
      SPTR     at 16#1C# range 0 .. 7;
      Reserved at 16#1D# range 0 .. 23;
   end record;

   SCI_ADDRESS : constant := 16#4007_0000#;

   SCI : aliased array (0 .. 9) of SCI_Type with
      Address    => To_Address (SCI_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 36. I2C Bus Interface (IIC)
   ----------------------------------------------------------------------------

   -- 36.2.1 I2C Bus Control Register 1 (ICCR1)

   type ICCR1_Type is
   record
      SDAI   : Boolean; -- SDA Line Monitor
      SCLI   : Boolean; -- SCL Line Monitor
      SDAO   : Boolean; -- SDA Output Control/Monitor
      SCLO   : Boolean; -- SCL Output Control/Monitor
      SOWP   : Boolean; -- SCLO/SDAO Write Protect
      CLO    : Boolean; -- Extra SCL Clock Cycle Output
      IICRST : Boolean; -- IIC-Bus Interface Internal Reset
      ICE    : Boolean; -- IIC-Bus Interface Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICCR1_Type use
   record
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

   type ICCR2_Type is
   record
      Reserved1 : Bits_1 := 0;
      ST        : Boolean;     -- Start Condition Issuance Request
      RS        : Boolean;     -- Restart Condition Issuance Request
      SP        : Boolean;     -- Stop Condition Issuance Request
      Reserved2 : Bits_1 := 0;
      TRS       : Boolean;     -- Transmit/Receive Mode
      MST       : Boolean;     -- Master/Slave Mode
      BBSY      : Boolean;     -- Bus Busy Detection Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICCR2_Type use
   record
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

   type ICMR1_Type is
   record
      BC   : Bits_3;  -- Bit Counter
      BCWP : Boolean; -- BC Write Protect
      CKS  : Bits_3;  -- Internal Reference Clock Select
      MTWP : Boolean; -- MST/TRS Write Protect
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICMR1_Type use
   record
      BC   at 0 range 0 .. 2;
      BCWP at 0 range 3 .. 3;
      CKS  at 0 range 4 .. 6;
      MTWP at 0 range 7 .. 7;
   end record;

   -- 36.2.4 I2C Bus Mode Register 2 (ICMR2)

   type ICMR2_Type is
   record
      TMOS     : Boolean;     -- Timeout Detection Time Select
      TMOL     : Boolean;     -- Timeout L Count Control
      TMOH     : Boolean;     -- Timeout H Count Control
      Reserved : Bits_1 := 0;
      SDDL     : Bits_3;      -- SDA Output Delay Counter
      DLCS     : Boolean;     -- SDA Output Delay Clock Source Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICMR2_Type use
   record
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

   type ICMR3_Type is
   record
      NF    : Bits_2;  -- Noise Filter Stage Select
      ACKBR : Boolean; -- Receive Acknowledge
      ACKBT : Boolean; -- Transmit Acknowledge
      ACKWP : Boolean; -- ACKBT Write Protect
      RDRFS : Boolean; -- RDRF Flag Set Timing Select
      WAIT  : Boolean; -- WAIT
      SMBS  : Boolean; -- SMBus/IIC-Bus Select
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICMR3_Type use
   record
      NF    at 0 range 0 .. 1;
      ACKBR at 0 range 2 .. 2;
      ACKBT at 0 range 3 .. 3;
      ACKWP at 0 range 4 .. 4;
      RDRFS at 0 range 5 .. 5;
      WAIT  at 0 range 6 .. 6;
      SMBS  at 0 range 7 .. 7;
   end record;

   -- 36.2.6 I2C Bus Function Enable Register (ICFER)

   type ICFER_Type is
   record
      TMOE  : Boolean; -- Timeout Function Enable
      MALE  : Boolean; -- Master Arbitration-Lost Detection Enable
      NALE  : Boolean; -- NACK Transmission Arbitration-Lost Detection Enable
      SALE  : Boolean; -- Slave Arbitration-Lost Detection Enable
      NACKE : Boolean; -- NACK Reception Transfer Suspension Enable
      NFE   : Boolean; -- Digital Noise Filter Circuit Enable
      SCLE  : Boolean; -- SCL Synchronous Circuit Enable
      FMPE  : Boolean; -- Fast-Mode Plus Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICFER_Type use
   record
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

   type ICSER_Type is
   record
      SAR0E     : Boolean;     -- Slave Address Register 0 Enable
      SAR1E     : Boolean;     -- Slave Address Register 1 Enable
      SAR2E     : Boolean;     -- Slave Address Register 2 Enable
      GCAE      : Boolean;     -- General Call Address Enable
      Reserved1 : Bits_1 := 0;
      DIDE      : Boolean;     -- Device-ID Address Detection Enable
      Reserved2 : Bits_1 := 0;
      HOAE      : Boolean;     -- Host Address Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICSER_Type use
   record
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

   type ICIER_Type is
   record
      TMOIE  : Boolean; -- Timeout Interrupt Request Enable
      ALIE   : Boolean; -- Arbitration-Lost Interrupt Request Enable
      STIE   : Boolean; -- Start Condition Detection Interrupt Request Enable
      SPIE   : Boolean; -- Stop Condition Detection Interrupt Request Enable
      NACKIE : Boolean; -- NACK Reception Interrupt Request Enable
      RIE    : Boolean; -- Receive Data Full Interrupt Request Enable
      TEIE   : Boolean; -- Transmit End Interrupt Request Enable
      TIE    : Boolean; -- Transmit Data Empty Interrupt Request Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICIER_Type use
   record
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

   type ICSR1_Type is
   record
      AAS0      : Boolean;     -- Slave Address 0 Detection Flag
      AAS1      : Boolean;     -- Slave Address 1 Detection Flag
      AAS2      : Boolean;     -- Slave Address 2 Detection Flag
      GCA       : Boolean;     -- General Call Address Detection Flag
      Reserved1 : Bits_1 := 0;
      DID       : Boolean;     -- Device-ID Address Detection Flag
      Reserved2 : Bits_1 := 0;
      HOA       : Boolean;     -- Host Address Detection Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICSR1_Type use
   record
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

   type ICSR2_Type is
   record
      TMOF  : Boolean; -- Timeout Detection Flag
      AL    : Boolean; -- Arbitration-Lost Flag
      START : Boolean; -- Start Condition Detection Flag
      STOP  : Boolean; -- Stop Condition Detection Flag
      NACKF : Boolean; -- NACK Detection Flag
      RDRF  : Boolean; -- Receive Data Full Flag
      TEND  : Boolean; -- Transmit End Flag
      TDRE  : Boolean; -- Transmit Data Empty Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICSR2_Type use
   record
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

   type ICWUR_Type is
   record
      WUAFA    : Boolean;     -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_3 := 0;
      WUACK    : Boolean;     -- ACK Bit for Wakeup Mode
      WUF      : Boolean;     -- Wakeup Event Occurrence Flag
      WUIE     : Boolean;     -- Wakeup Interrupt Request Enable
      WUE      : Boolean;     -- Wakeup Function Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICWUR_Type use
   record
      WUAFA    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 3;
      WUACK    at 0 range 4 .. 4;
      WUF      at 0 range 5 .. 5;
      WUIE     at 0 range 6 .. 6;
      WUE      at 0 range 7 .. 7;
   end record;

   -- 36.2.12 I2C Bus Wakeup Unit Register 2 (ICWUR2)

   type ICWUR2_Type is
   record
      WUSEN    : Boolean;          -- Wakeup Analog Filter Additional Selection
      WUASYF   : Boolean;          -- Wakeup Analog Filter Additional Selection
      WUSYF    : Boolean;          -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_5 := 16#1F#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for ICWUR2_Type use
   record
      WUSEN    at 0 range 0 .. 0;
      WUASYF   at 0 range 1 .. 1;
      WUSYF    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

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

   type SPCR_Type is
   record
      SPMS   : Bits_1;  -- SPI Mode Select
      TXMD   : Bits_1;  -- Communications Operating Mode Select
      MODFEN : Boolean; -- Mode Fault Error Detection Enable
      MSTR   : Bits_1;  -- SPI Master/Slave Mode Select
      SPEIE  : Boolean; -- SPI Error Interrupt Enable
      SPTIE  : Boolean; -- Transmit Buffer Empty Interrupt Enable
      SPE    : Boolean; -- SPI Function Enable
      SPRIE  : Boolean; -- SPI Receive Buffer Full Interrupt Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPCR_Type use
   record
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

   type SSLP_Type is
   record
      SSL0P    : Bits_1;      -- SSL0 Signal Polarity Setting
      SSL1P    : Bits_1;      -- SSL1 Signal Polarity Setting
      SSL2P    : Bits_1;      -- SSL2 Signal Polarity Setting
      SSL3P    : Bits_1;      -- SSL3 Signal Polarity Setting
      Reserved : Bits_4 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SSLP_Type use
   record
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

   MOIFE_PREVIOUS : constant := 0; -- Set MOSI output value to equal final data from previous transfer
   MOIFE_MOIFV    : constant := 1; -- Set MOSI output value to equal value set in the MOIFV bit.

   type SPPCR_Type is
   record
      SPLP      : Bits_1;      -- SPI Loopback
      SPLP2     : Bits_1;      -- SPI Loopback 2
      Reserved1 : Bits_2 := 0;
      MOIFV     : Bits_1;      -- MOSI Idle Fixed Value
      MOIFE     : Bits_1;      -- MOSI Idle Value Fixing Enable
      Reserved2 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPPCR_Type use
   record
      SPLP      at 0 range 0 .. 0;
      SPLP2     at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      MOIFV     at 0 range 4 .. 4;
      MOIFE     at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   -- 38.2.4 SPI Status Register (SPSR)

   type SPSR_Type is
   record
      OVRF     : Boolean;     -- Overrun Error Flag
      IDLNF    : Boolean;     -- SPI Idle Flag
      MODF     : Boolean;     -- Mode Fault Error Flag
      PERF     : Boolean;     -- Parity Error Flag
      UDRF     : Boolean;     -- Underrun Error Flag
      SPTEF    : Boolean;     -- SPI Transmit Buffer Empty Flag
      Reserved : Bits_1 := 0;
      SPRF     : Boolean;     -- SPI Receive Buffer Full Flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPSR_Type use
   record
      OVRF     at 0 range 0 .. 0;
      IDLNF    at 0 range 1 .. 1;
      MODF     at 0 range 2 .. 2;
      PERF     at 0 range 3 .. 3;
      UDRF     at 0 range 4 .. 4;
      SPTEF    at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 6;
      SPRF     at 0 range 7 .. 7;
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

   type SPSCR_Type is
   record
      SPSLN    : Bits_3;      -- SPI Sequence Length Specification
      Reserved : Bits_5 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPSCR_Type use
   record
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

   type SPSSR_Type is
   record
      SPCP      : Bits_3;      -- SPI Command Pointer
      Reserved1 : Bits_1 := 0;
      SPECM     : Bits_3;      -- SPI Error Command
      Reserved2 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPSSR_Type use
   record
      SPCP      at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      SPECM     at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
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

   type SPDCR_Type is
   record
      SPFC      : Bits_2;      -- Number of Frames Specification
      Reserved1 : Bits_2 := 0;
      SPRDTD    : Bits_1;      -- SPI Receive/Transmit Data Select
      SPLW      : Bits_1;      -- SPI Word Access/Halfword Access Specification
      SPBYT     : Bits_1;      -- SPI Byte Access Specification
      Reserved2 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SPDCR_Type use
   record
      SPFC      at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 3;
      SPRDTD    at 0 range 4 .. 4;
      SPLW      at 0 range 5 .. 5;
      SPBYT     at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 39. Quad Serial Peripheral Interface (QSPI)
   ----------------------------------------------------------------------------

   -- 39.2.5 Communication Port Register (SFMCOM)

   type SFMCOM_Type is
   record
      SFMD     : Unsigned_8;   -- Port select for direct communication with the SPI bus
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SFMCOM_Type use
   record
      SFMD     at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 39.2.6 Communication Mode Control Register (SFMCMD)

   DCOM_ROM    : constant := 0; -- ROM access mode
   DCOM_DIRECT : constant := 1; -- Direct communication mode.

   type SFMCMD_Type is
   record
      DCOM     : Bits_1;       -- Mode select for communication with the SPI bus
      Reserved : Bits_31 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SFMCMD_Type use
   record
      DCOM     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- QSPI

   type QSPI_Type is
   record
      SFMCOM : SFMCOM_Type with Volatile_Full_Access => True;
      SFMCMD : SFMCMD_Type with Volatile_Full_Access => True;
   end record with
      Size                    => 16#38# * 8,
      Suppress_Initialization => True;
   for QSPI_Type use
   record
      SFMCOM   at 16#10# range 0 .. 31;
      SFMCMD   at 16#14# range 0 .. 31;
   end record;

   QSPI_ADDRESS : constant := 16#6400_0000#;

   QSPI : aliased QSPI_Type with
      Address    => To_Address (QSPI_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end S5D9;
