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
   -- 5. Memory Mirror Function (MMF)
   ----------------------------------------------------------------------------

   -- 5.2.1 MemMirror Special Function Register (MMSFR)
   -- 5.2.2 MemMirror Enable Register (MMEN)

   ----------------------------------------------------------------------------
   -- 6. Resets
   ----------------------------------------------------------------------------

   -- 6.2.1 Reset Status Register 0 (RSTSR0)

   type RSTSR0_Type is record
      PORF     : Boolean := True; -- Power-On Reset Detect Flag
      LVD0RF   : Boolean := True; -- Voltage Monitor 0 Reset Detect Flag
      LVD1RF   : Boolean := True; -- Voltage Monitor 1 Reset Detect Flag
      LVD2RF   : Boolean := True; -- Voltage Monitor 2 Reset Detect Flag
      Reserved : Bits_3  := 0;
      DPSRSTF  : Boolean := True; -- Deep Software Standby Reset Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      IWDTRF    : Boolean := True; -- Independent Watchdog Timer Reset Detect Flag
      WDTRF     : Boolean := True; -- Watchdog Timer Reset Detect Flag
      SWRF      : Boolean := True; -- Software Reset Detect Flag
      Reserved1 : Bits_5  := 0;
      RPERF     : Boolean := True; -- SRAM Parity Error Reset Detect Flag
      REERF     : Boolean := True; -- SRAM ECC Error Reset Detect Flag
      BUSSRF    : Boolean := True; -- Bus Slave MPU Error Reset Detect Flag
      BUSMRF    : Boolean := True; -- Bus Master MPU Error Reset Detect Flag
      SPERF     : Boolean := True; -- SP Error Reset Detect Flag
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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

   CWSF_COLD : constant := 0; -- Cold start
   CWSF_WARM : constant := 1; -- Warm start.

   type RSTSR2_Type is record
      CWSF     : Bits_1 := CWSF_COLD; -- Cold/Warm Start Determination Flag
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
   -- 7. Option-Setting Memory
   ----------------------------------------------------------------------------

   -- 7.2.1 Option Function Select Register 0 (OFS0)

   IWDTSTRT_ENABLE  : constant := 0; -- Automatically activate IWDT after a reset (auto start mode)
   IWDTSTRT_DISABLE : constant := 1; -- Disable IWDT.

   IWDTTOPS_128  : constant := 2#00#; -- 128 cycles (007Fh)
   IWDTTOPS_512  : constant := 2#01#; -- 512 cycles (01FFh)
   IWDTTOPS_1024 : constant := 2#10#; -- 1024 cycles (03FFh)
   IWDTTOPS_2048 : constant := 2#11#; -- 2048 cycles (07FFh).

   IWDTCKS_DIV1   : constant := 2#0000#; -- × 1
   IWDTCKS_DIV16  : constant := 2#0010#; -- × 1/16
   IWDTCKS_DIV32  : constant := 2#0011#; -- × 1/32
   IWDTCKS_DIV64  : constant := 2#0100#; -- × 1/64
   IWDTCKS_DIV128 : constant := 2#1111#; -- × 1/128
   IWDTCKS_DIV256 : constant := 2#0101#; -- × 1/256.

   IWDTRPES_75 : constant := 2#00#; -- 75%
   IWDTRPES_50 : constant := 2#01#; -- 50%
   IWDTRPES_25 : constant := 2#10#; -- 25%
   IWDTRPES_0  : constant := 2#11#; -- 0% (no window end position setting).

   IWDTRPSS_25  : constant := 2#00#; -- 25%
   IWDTRPSS_50  : constant := 2#01#; -- 50%
   IWDTRPSS_75  : constant := 2#10#; -- 75%
   IWDTRPSS_100 : constant := 2#11#; -- 100% (no window start position setting).

   IWDTRSTIRQS_NMIIRQ : constant := 0; -- Enable non-maskable interrupt requests or interrupt requests
   IWDTRSTIRQS_RESETS : constant := 1; -- Enable resets.

   IWDTSTPCTL_CONT : constant := 0; -- Continue counting
   IWDTSTPCTL_STOP : constant := 1; -- Stop counting when in Sleep, Snooze mode, Software Standby, or Deep Software Standby mode.

   WDTSTRT_ENABLE : constant := 0; -- Automatically activate WDT after a reset (auto start mode)
   WDTSTRT_STOP   : constant := 1; -- Stop WDT after a reset (register start mode).

   WDTTOPS_1k  : constant := 2#00#; -- 1024 cycles (03FFh)
   WDTTOPS_4k  : constant := 2#01#; -- 4096 cycles (0FFFh)
   WDTTOPS_8k  : constant := 2#10#; -- 8192 cycles (1FFFh)
   WDTTOPS_16k : constant := 2#11#; -- 16384 cycles (3FFFh).

   WDTCKS_DIV4    : constant := 2#0001#; -- PCLKB divided by 4
   WDTCKS_DIV64   : constant := 2#0100#; -- PCLKB divided by 64
   WDTCKS_DIV128  : constant := 2#1111#; -- PCLKB divided by 128
   WDTCKS_DIV512  : constant := 2#0110#; -- PCLKB divided by 512
   WDTCKS_DIV2048 : constant := 2#0111#; -- PCLKB divided by 2048
   WDTCKS_DIV8192 : constant := 2#1000#; -- PCLKB divided by 8192.

   WDTRPES_75 : constant := 2#00#; -- 75%
   WDTRPES_50 : constant := 2#01#; -- 50%
   WDTRPES_25 : constant := 2#10#; -- 25%
   WDTRPES_0  : constant := 2#11#; -- 0% (No window end position setting).

   WDTRPSS_25  : constant := 2#00#; -- 25%
   WDTRPSS_50  : constant := 2#01#; -- 50%
   WDTRPSS_75  : constant := 2#10#; -- 75%
   WDTRPSS_100 : constant := 2#11#; -- 100% (No window start position setting).

   WDTRSTIRQS_NMI   : constant := 0; -- NMI
   WDTRSTIRQS_RESET : constant := 1; -- Reset.

   WDTSTPCTL_CONT : constant := 0; -- Continue counting
   WDTSTPCTL_STOP : constant := 1; -- Stop counting when entering Sleep mode.

   type OFS0_Type is record
      Reserved1   : Bits_1 := 1;
      IWDTSTRT    : Bits_1;          -- IWDT Start Mode Select
      IWDTTOPS    : Bits_2;          -- IWDT Timeout Period Select
      IWDTCKS     : Bits_4;          -- IWDT-Dedicated Clock Frequency Division Ratio Select
      IWDTRPES    : Bits_2;          -- IWDT Window End Position Select
      IWDTRPSS    : Bits_2;          -- IWDT Window Start Position Select
      IWDTRSTIRQS : Bits_1;          -- IWDT Reset Interrupt Request Select
      Reserved2   : Bits_1 := 1;
      IWDTSTPCTL  : Bits_1;          -- IWDT Stop Control
      Reserved3   : Bits_2 := 2#11#;
      WDTSTRT     : Bits_1;          -- WDT Start Mode Select
      WDTTOPS     : Bits_2;          -- WDT Timeout Period Select
      WDTCKS      : Bits_4;          -- WDT Clock Frequency Division Ratio Select
      WDTRPES     : Bits_2;          -- WDT Window End Position Select
      WDTRPSS     : Bits_2;          -- WDT Window Start Position Select
      WDTRSTIRQS  : Bits_1;          -- WDT Reset Interrupt Request Select
      Reserved4   : Bits_1 := 1;
      WDTSTPCTL   : Bits_1;          -- WDT Stop Control
      Reserved5   : Bits_1 := 1;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for OFS0_Type use record
      Reserved1   at 0 range  0 ..  0;
      IWDTSTRT    at 0 range  1 ..  1;
      IWDTTOPS    at 0 range  2 ..  3;
      IWDTCKS     at 0 range  4 ..  7;
      IWDTRPES    at 0 range  8 ..  9;
      IWDTRPSS    at 0 range 10 .. 11;
      IWDTRSTIRQS at 0 range 12 .. 12;
      Reserved2   at 0 range 13 .. 13;
      IWDTSTPCTL  at 0 range 14 .. 14;
      Reserved3   at 0 range 15 .. 16;
      WDTSTRT     at 0 range 17 .. 17;
      WDTTOPS     at 0 range 18 .. 19;
      WDTCKS      at 0 range 20 .. 23;
      WDTRPES     at 0 range 24 .. 25;
      WDTRPSS     at 0 range 26 .. 27;
      WDTRSTIRQS  at 0 range 28 .. 28;
      Reserved4   at 0 range 29 .. 29;
      WDTSTPCTL   at 0 range 30 .. 30;
      Reserved5   at 0 range 31 .. 31;
   end record;

   OFS0_ADDRESS : constant := 16#0000_0400#;

   OFS0 : aliased OFS0_Type
      with Address              => System'To_Address (OFS0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.2 Option Function Select Register 1 (OFS1)

   VDSEL0_RSVD : constant := 2#00#; -- Setting prohibited
   VDSEL0_2V94 : constant := 2#01#; -- Select 2.94 V
   VDSEL0_2V87 : constant := 2#10#; -- Select 2.87 V
   VDSEL0_2V80 : constant := 2#11#; -- Select 2.80 V.

   HOCOFRQ0_16   : constant := 2#00#; -- 16 MHz
   HOCOFRQ0_18   : constant := 2#01#; -- 18 MHz
   HOCOFRQ0_20   : constant := 2#10#; -- 20 MHz
   HOCOFRQ0_RSVD : constant := 2#11#; -- Setting prohibited.

   type OFS1_Type is record
      VDSEL0    : Bits_2;                 -- Voltage Detection 0 Level Select
      LVDAS     : Bits_1;                 -- Voltage Detection 0 Circuit Start
      Reserved1 : Bits_5   := 16#1F#;
      HOCOEN    : NBoolean;               -- HOCO Oscillation Enable
      HOCOFRQ0  : Bits_2;                 -- HOCO Frequency Setting 0
      Reserved2 : Bits_21  := 16#1FFFFF#;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for OFS1_Type use record
      VDSEL0    at 0 range  0 ..  1;
      LVDAS     at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  7;
      HOCOEN    at 0 range  8 ..  8;
      HOCOFRQ0  at 0 range  9 .. 10;
      Reserved2 at 0 range 11 .. 31;
   end record;

   OFS1_ADDRESS : constant := 16#0000_0404#;

   OFS1 : aliased OFS1_Type
      with Address              => System'To_Address (OFS1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.3 Access Window Setting Register (AWS)

   type AWS_Type is record
      FAWS      : Bits_11;             -- Access Window Start Block Address
      Reserved1 : Bits_4   := 2#1111#;
      FSPR      : Boolean;             -- Protection of Access Window and Startup Area Select Function
      FAWE      : Bits_11;             -- Access Window End Block Address
      Reserved2 : Bits_4   := 2#1111#;
      BTFLG     : NBoolean;            -- Startup Area Select Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for AWS_Type use record
      FAWS      at 0 range  0 .. 10;
      Reserved1 at 0 range 11 .. 14;
      FSPR      at 0 range 15 .. 15;
      FAWE      at 0 range 16 .. 26;
      Reserved2 at 0 range 27 .. 30;
      BTFLG     at 0 range 31 .. 31;
   end record;

   AWS_ADDRESS : constant := 16#0100_A164#;

   AWS : aliased AWS_Type
      with Address              => System'To_Address (AWS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.2.4 OCD/Serial Programmer ID Setting Register (OSIS)

   type OSIS_Type is record
      ID0 : Unsigned_32 with Volatile_Full_Access => True; -- ID code protection of the OCD/serial programmer
      ID1 : Unsigned_32 with Volatile_Full_Access => True; -- ''
      ID2 : Unsigned_32 with Volatile_Full_Access => True; -- ''
      ID3 : Unsigned_32 with Volatile_Full_Access => True; -- ''
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 4 * 32;
   for OSIS_Type use record
      ID0 at 16#0# range 0 .. 31;
      ID1 at 16#4# range 0 .. 31;
      ID2 at 16#8# range 0 .. 31;
      ID3 at 16#C# range 0 .. 31;
   end record;

   OSIS_ADDRESS : constant := 16#0100_A150#;

   OSIS : aliased OSIS_Type
      with Address    => System'To_Address (OSIS_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 8. Low Voltage Detection (LVD)
   ----------------------------------------------------------------------------

   -- 8.2.1 Voltage Monitor 1 Circuit Control Register 1 (LVD1CR1)

   IDTSEL_VCCRISE : constant := 2#00#; -- When VCC >= Vdet1 (rise) is detected
   IDTSEL_VCCFALL : constant := 2#01#; -- When VCC < Vdet1 (fall) is detected
   IDTSEL_VCCBOTH : constant := 2#10#; -- When fall and rise are detected
   IDTSEL_RSVD    : constant := 2#11#; -- Settings prohibited.

   IRQSEL_NONMASKINT : constant := 0; -- Non-maskable interrupt
   IRQSEL_MASKINT    : constant := 1; -- Maskable interrupt.

   type LVD1CR1_Type is record
      IDTSEL   : Bits_2 := IDTSEL_VCCFALL;    -- Voltage Monitor 1 Interrupt Generation Condition Select
      IRQSEL   : Bits_1 := IRQSEL_NONMASKINT; -- Voltage Monitor 1 Interrupt Type Select
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD1CR1_Type use record
      IDTSEL   at 0 range 0 .. 1;
      IRQSEL   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   LVD1CR1_ADDRESS : constant := 16#4001_E0E0#;

   LVD1CR1 : aliased LVD1CR1_Type
      with Address    => System'To_Address (LVD1CR1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.2 Voltage Monitor 1 Circuit Status Register (LVD1SR)

   type LVD1SR_Type is record
      DET      : Boolean := False; -- Voltage Monitor 1 Voltage Change Detection Flag
      MON      : Boolean := True;  -- Voltage Monitor 1 Signal Monitor Flag
      Reserved : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD1SR_Type use record
      DET      at 0 range 0 .. 0;
      MON      at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   LVD1SR_ADDRESS : constant := 16#4001_E0E1#;

   LVD1SR : aliased LVD1SR_Type
      with Address    => System'To_Address (LVD1SR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.3 Voltage Monitor 2 Circuit Control Register 1 (LVD2CR1)

   -- IDTSEL_* already defined at 8.2.1

   -- IRQSEL_* already defined at 8.2.1

   type LVD2CR1_Type is record
      IDTSEL   : Bits_2 := IDTSEL_VCCFALL;    -- Voltage Monitor 2 Interrupt Generation Condition Select
      IRQSEL   : Bits_1 := IRQSEL_NONMASKINT; -- Voltage Monitor 2 Interrupt Type Select
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD2CR1_Type use record
      IDTSEL   at 0 range 0 .. 1;
      IRQSEL   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   LVD2CR1_ADDRESS : constant := 16#4001_E0E2#;

   LVD2CR1 : aliased LVD2CR1_Type
      with Address    => System'To_Address (LVD2CR1_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.4 Voltage Monitor 2 Circuit Status Register (LVD2SR)

   type LVD2SR_Type is record
      DET      : Boolean := False; -- Voltage Monitor 2 Voltage Change Detection Flag
      MON      : Boolean := True;  -- Voltage Monitor 2 Signal Monitor Flag
      Reserved : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD2SR_Type use record
      DET      at 0 range 0 .. 0;
      MON      at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   LVD2SR_ADDRESS : constant := 16#4001_E0E3#;

   LVD2SR : aliased LVD2SR_Type
      with Address    => System'To_Address (LVD2SR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.5 Voltage Monitor Circuit Control Register (LVCMPCR)

   type LVCMPCR_Type is record
      Reserved1 : Bits_5  := 0;
      LVD1E     : Boolean := False; -- Voltage Detection 1 Enable
      LVD2E     : Boolean := False; -- Voltage Detection 2 Enable
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVCMPCR_Type use record
      Reserved1 at 0 range 0 .. 4;
      LVD1E     at 0 range 5 .. 5;
      LVD2E     at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   LVCMPCR_ADDRESS : constant := 16#4001_E417#;

   LVCMPCR : aliased LVCMPCR_Type
      with Address    => System'To_Address (LVCMPCR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.6 Voltage Detection Level Select Register (LVDLVLR)

   LVD1LVL_2V99 : constant := 2#10001#; -- 2.99 V (Vdet1_1 )
   LVD1LVL_2V92 : constant := 2#10010#; -- 2.92 V (Vdet1_2 )
   LVD1LVL_2V85 : constant := 2#10011#; -- 2.85 V (Vdet1_3 ).

   LVD2LVL_2V99 : constant := 2#101#; -- 2.99 V (Vdet2_1)
   LVD2LVL_2V92 : constant := 2#110#; -- 2.92 V (Vdet2_2)
   LVD2LVL_2V85 : constant := 2#111#; -- 2.85 V Vdet2_3).

   type LVDLVLR_Type is record
      LVD1LVL : Bits_5 := LVD1LVL_2V85; -- Voltage Detection 1 Level Select
      LVD2LVL : Bits_3 := LVD2LVL_2V85; -- Voltage Detection 2 Level Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVDLVLR_Type use record
      LVD1LVL at 0 range 0 .. 4;
      LVD2LVL at 0 range 5 .. 7;
   end record;

   LVDLVLR_ADDRESS : constant := 16#4001_E418#;

   LVDLVLR : aliased LVDLVLR_Type
      with Address    => System'To_Address (LVDLVLR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.7 Voltage Monitor 1 Circuit Control Register 0 (LVD1CR0)

   FSAMP_LOC0DIV2  : constant := 2#00#; -- 1/2 LOCO frequency
   FSAMP_LOC0DIV4  : constant := 2#01#; -- 1/4 LOCO frequency
   FSAMP_LOC0DIV8  : constant := 2#10#; -- 1/8 LOCO frequency
   FSAMP_LOC0DIV16 : constant := 2#11#; -- 1/16 LOCO frequency.

   RI_VM1INT : constant := 0; -- Generate voltage monitor 1 interrupt on Vdet1 passage
   RI_VM1RST : constant := 1; -- Enable voltage monitor 1 reset when the voltage falls to and below V det1.

   RN_VCCGTVDET1 : constant := 0; -- Negate after a stabilization time (tLVD1) when VCC > Vdet1 is detected
   RN_LVD1RST    : constant := 1; -- Negate after a stabilization time (tLVD1) on assertion of the LVD1 reset.

   type LVD1CR0_Type is record
      RIE      : Boolean  := False;          -- Voltage Monitor 1 Interrupt/Reset Enable
      DFDIS    : NBoolean := NFalse;         -- Voltage Monitor 1 Digital Filter Disable Mode Select
      CMPE     : Boolean  := False;          -- Voltage Monitor 1 Circuit Comparison Result Output Enable
      Reserved : Bits_1   := 0;
      FSAMP    : Bits_2   := FSAMP_LOC0DIV2; -- Sampling Clock Select
      RI       : Bits_1   := RI_VM1INT;      -- Voltage Monitor 1 Circuit Mode Select
      RN       : Bits_1   := RN_LVD1RST;     -- Voltage Monitor 1 Reset Negate Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD1CR0_Type use record
      RIE      at 0 range 0 .. 0;
      DFDIS    at 0 range 1 .. 1;
      CMPE     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 3;
      FSAMP    at 0 range 4 .. 5;
      RI       at 0 range 6 .. 6;
      RN       at 0 range 7 .. 7;
   end record;

   LVD1CR0_ADDRESS : constant := 16#4001_E41A#;

   LVD1CR0 : aliased LVD1CR0_Type
      with Address    => System'To_Address (LVD1CR0_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 8.2.8 Voltage Monitor 2 Circuit Control Register 0 (LVD2CR0)

   -- FSAMP_* already defined at 8.2.7

   RI_VM2INT : constant := 0; -- Generate voltage monitor 2 interrupt on Vdet2 passage
   RI_VM2RST : constant := 1; -- Enable voltage monitor 2 reset when the voltage falls to and below Vdet2.

   RN_VCCGTVDET2 : constant := 0; -- Negate after a stabilization time (tLVD2) when VCC > Vdet2 is detected
   RN_LVD2RST    : constant := 1; -- Negate after a stabilization time (tLVD2) on assertion of the LVD2 reset.

   type LVD2CR0_Type is record
      RIE      : Boolean  := False;          -- Voltage Monitor 2 Interrupt/Reset Enable
      DFDIS    : NBoolean := NFalse;         -- Voltage Monitor 2 Digital Filter Disable Mode Select
      CMPE     : Boolean  := False;          -- Voltage Monitor 2 Circuit Comparison Result Output Enable
      Reserved : Bits_1   := 0;
      FSAMP    : Bits_2   := FSAMP_LOC0DIV2; -- Sampling Clock Select
      RI       : Bits_1   := RI_VM2INT;      -- Voltage Monitor 2 Circuit Mode Select
      RN       : Bits_1   := RN_LVD2RST;     -- Voltage Monitor 2 Reset Negate Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for LVD2CR0_Type use record
      RIE      at 0 range 0 .. 0;
      DFDIS    at 0 range 1 .. 1;
      CMPE     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 3;
      FSAMP    at 0 range 4 .. 5;
      RI       at 0 range 6 .. 6;
      RN       at 0 range 7 .. 7;
   end record;

   LVD2CR0_ADDRESS : constant := 16#4001_E41B#;

   LVD2CR0 : aliased LVD2CR0_Type
      with Address    => System'To_Address (LVD2CR0_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   -- 9.2.20 Subclock Oscillator Mode Control Register (SOMCR)

   SODRV1_STANDARD : constant := 0; -- Standard
   SODRV1_LOW      : constant := 1; -- Low.

   type SOMCR_Type is record
      Reserved1 : Bits_1 := 0;
      SODRV1    : Bits_1 := SODRV1_STANDARD; -- Sub-Clock Oscillator Drive Capability Switching
      Reserved2 : Bits_6 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SOMCR_Type use record
      Reserved1 at 0 range 0 .. 0;
      SODRV1    at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 7;
   end record;

   SOMCR_ADDRESS : constant := 16#4001_E481#;

   SOMCR : aliased SOMCR_Type
      with Address              => System'To_Address (SOMCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 10. Clock Frequency Accuracy Measurement Circuit (CAC)
   ----------------------------------------------------------------------------

   -- 10.2.1 CAC Control Register 0 (CACR0)
   -- 10.2.2 CAC Control Register 1 (CACR1)
   -- 10.2.3 CAC Control Register 2 (CACR2)
   -- 10.2.4 CAC Interrupt Control Register (CAICR)
   -- 10.2.5 CAC Status Register (CASTR)
   -- 10.2.6 CAC Upper-Limit Value Setting Register (CAULVR)
   -- 10.2.7 CAC Lower-Limit Value Setting Register (CALLVR)
   -- 10.2.8 CAC Counter Buffer Register (CACNTBR)

   ----------------------------------------------------------------------------
   -- 11. Low Power Modes
   ----------------------------------------------------------------------------

   -- 11.2.1 Standby Control Register (SBYCR)

   type SBYCR_Type is record
      Reserved : Bits_14 := 0;
      OPE      : Boolean := True;  -- Output Port Enable
      SSBY     : Boolean := False; -- Software Standby
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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

   -- 11.2.6 Operating Power Control Register (OPCCR)
   -- 11.2.7 Sub Operating Power Control Register (SOPCCR)
   -- 11.2.8 Snooze Control Register (SNZCR)
   -- 11.2.9 Snooze End Control Register (SNZEDCR)
   -- 11.2.10 Snooze Request Control Register (SNZREQCR)
   -- 11.2.11 Deep Software Standby Control Register (DPSBYCR)
   -- 11.2.12 Deep Software Standby Interrupt Enable Register 0 (DPSIER0)
   -- 11.2.13 Deep Software Standby Interrupt Enable Register 1 (DPSIER1)
   -- 11.2.14 Deep Software Standby Interrupt Enable Register 2 (DPSIER2)
   -- 11.2.15 Deep Software Standby Interrupt Enable Register 3 (DPSIER3)
   -- 11.2.16 Deep Software Standby Interrupt Flag Register 0 (DPSIFR0)
   -- 11.2.17 Deep Software Standby Interrupt Flag Register 1 (DPSIFR1)
   -- 11.2.18 Deep Software Standby Interrupt Flag Register 2 (DPSIFR2)
   -- 11.2.19 Deep Software Standby Interrupt Flag Register 3 (DPSIFR3)
   -- 11.2.20 Deep Software Standby Interrupt Edge Register 0 (DPSIEGR0)
   -- 11.2.21 Deep Software Standby Interrupt Edge Register 1 (DPSIEGR1)
   -- 11.2.22 Deep Software Standby Interrupt Edge Register 2 (DPSIEGR2)
   -- 11.2.23 System Control OCD Control Register (SYOCDCR)
   -- 11.2.24 Standby Condition Register (STCONR)

   ----------------------------------------------------------------------------
   -- 12. Battery Backup Function
   ----------------------------------------------------------------------------

   -- 12.2.1 VBATT Backup Register (VBTBKRn) (n = 0 to 511)
   -- 12.2.2 VBATT Input Control Register (VBTICTLR)

   ----------------------------------------------------------------------------
   -- 13. Register Write Protection
   ----------------------------------------------------------------------------

   -- 13.2.1 Protect Register (PRCR)

   PRKEY_PRCKEYCODE : constant := 16#A5#;

   type PRCR_Type is record
      PRC0      : Boolean    := False; -- Protect Bit 0
      PRC1      : Boolean    := False; -- Protect Bit 1
      Reserved1 : Bits_1     := 0;
      PRC3      : Boolean    := False; -- Protect Bit 3
      Reserved2 : Bits_4     := 0;
      PRKEY     : Unsigned_8 := 0;     -- PRC Key Code
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
           Object_Size          => 8,
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
           Object_Size          => 32,
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
           Object_Size          => 32,
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Object_Size => 16 * 8;
   type IELSR_Array_Type is array (0 .. 95) of IELSR_Type
      with Object_Size => 96 * 32;
   type DELSR_Array_Type is array (0 .. 7) of DELSR_Type
      with Object_Size => 8 * 32;

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
      with Object_Size => 16#F00# * 8;
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
   -- 15. Buses
   ----------------------------------------------------------------------------

   -- 15.3.1 CSn Control Register (CSnCR) (n = 0 to 7)
   -- 15.3.2 CSn Recovery Cycle Register (CSnREC) (n = 0 to 7)
   -- 15.3.3 CS Recovery Cycle Insertion Enable Register (CSRECEN)
   -- 15.3.4 CSn Mode Register (CSnMOD) (n = 0 to 7)
   -- 15.3.5 CSn Wait Control Register 1 (CSnWCR1) (n = 0 to 7)
   -- 15.3.6 CSn Wait Control Register 2 (CSnWCR2) (n = 0 to 7)
   -- 15.3.7 SDC Control Register (SDCCR)
   -- 15.3.8 SDC Mode Register (SDCMOD)
   -- 15.3.9 SDRAM Access Mode Register (SDAMOD)
   -- 15.3.10 SDRAM Self-Refresh Control Register (SDSELF)
   -- 15.3.11 SDRAM Refresh Control Register (SDRFCR)
   -- 15.3.12 SDRAM Auto-Refresh Control Register (SDRFEN)
   -- 15.3.13 SDRAM Initialization Sequence Control Register (SDICR)
   -- 15.3.14 SDRAM Initialization Register (SDIR)
   -- 15.3.15 SDRAM Address Register (SDADR)
   -- 15.3.16 SDRAM Timing Register (SDTR)
   -- 15.3.17 SDRAM Mode Register (SDMOD)
   -- 15.3.18 SDRAM Status Register (SDSR)
   -- 15.3.19 Master Bus Control Register (BUSMCNT<master>)
   -- 15.3.20 Slave Bus Control Register (BUSSCNT<slave>)
   -- 15.3.21 Bus Error Address Register (BUSnERRADD) (n = 1 to 11)
   -- 15.3.22 Bus Error Status Register (BUSnERRSTAT) (n = 1 to 11)

   ----------------------------------------------------------------------------
   -- 16. Memory Protection Unit (MPU)
   ----------------------------------------------------------------------------

   -- 16.2.1.1 Main Stack Pointer Monitor Start Address Register (MSPMPUSA)
   -- 16.2.1.2 Main Stack Pointer Monitor End Address Register (MSPMPUEA)
   -- 16.2.1.3 Process Stack Pointer Monitor Start Address Register (PSPMPUSA)
   -- 16.2.1.4 Process Stack Pointer Monitor End Address Register (PSPMPUEA)
   -- 16.2.1.5 Stack Pointer Monitor Operation After Detection Register (MSPMPUOAD, PSPMPUOAD)
   -- 16.2.1.6 Stack Pointer Monitor Access Control Register (MSPMPUCTL, PSPMPUCTL)
   -- 16.2.1.7 Stack Pointer Monitor Protection Register (MSPMPUPT, PSPMPUPT)

   -- 16.4.1.1 Group m Region n Start Address Register (MMPUSmn) (m = A to C; n = 0 to 31)
   -- 16.4.1.2 Group m Region n End Address Register (MMPUEmn) (m = A to C; n = 0 to 31)
   -- 16.4.1.3 Group m Region n Access Control Register (MMPUACmn) (m = A to C; n = 0 to 31)
   -- 16.4.1.4 Bus Master MPU Control Register (MMPUCTLm) (m = A to C)
   -- 16.4.1.5 Group m Protection of Register (MMPUPTm) (m = A to C)

   -- 16.5.1.1 Access Control Register for Memory Bus 3 (SMPUMBIU)
   -- 16.5.1.2 Access Control Register for Internal Peripheral Bus 9 (SMPUFBIU)
   -- 16.5.1.3 Access Control Register for Memory Bus 4 (SMPUSRAM0)
   -- 16.5.1.4 Access Control Register for Memory Bus 5 (SMPUSRAM1)
   -- 16.5.1.5 Access Control Register for Internal Peripheral Bus 1 (SMPUP0BIU)
   -- 16.5.1.6 Access Control Register for Internal Peripheral Bus 3 (SMPUP2BIU)
   -- 16.5.1.7 Access Control Register for Internal Peripheral Bus 7 (SMPUP6BIU)
   -- 16.5.1.8 Access Control Register for Internal Peripheral Bus 8 (SMPUP7BIU)
   -- 16.5.1.9 Access Control Register for CS Area and SDRAM Area (SMPUEXBIU)
   -- 16.5.1.10 Access Control Register for QSPI Area (SMPUEXBIU2)
   -- 16.5.1.11 Slave MPU Control Register (SMPUCTL)

   -- 16.6.1.1 Security MPU Program Counter Start Address Register (SECMPUPCSn) (n = 0, 1)
   -- 16.6.1.2 Security MPU Program Counter End Address Register (SECMPUPCEn) (n = 0, 1)
   -- 16.6.1.3 Security MPU Region 0 Start Address Register (SECMPUS0)
   -- 16.6.1.4 Security MPU Region 0 End Address Register (SECMPUE0)
   -- 16.6.1.5 Security MPU Region 1 Start Address Register (SECMPUS1)
   -- 16.6.1.6 Security MPU Region 1 End Address Register (SECMPUE1)
   -- 16.6.1.7 Security MPU Region 2 Start Address Register (SECMPUS2)
   -- 16.6.1.8 Security MPU Region 2 End Address Register (SECMPUE2)
   -- 16.6.1.9 Security MPU Region 3 Start Address Register (SECMPUS3)
   -- 16.6.1.10 Security MPU Region 3 End Address Register (SECMPUE3)
   -- 16.6.1.11 Security MPU Access Control Register (SECMPUAC)

   ----------------------------------------------------------------------------
   -- 17. DMA Controller (DMAC)
   ----------------------------------------------------------------------------

   -- 17.2.1 DMA Source Address Register (DMSAR)

   type DMSAR_Type is record
      DMSA : Unsigned_32 := 0; -- Specifies the transfer source start address
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMSAR_Type use record
      DMSA at 0 range 0 .. 31;
   end record;

   -- 17.2.2 DMA Destination Address Register (DMDAR)

   type DMDAR_Type is record
      DMDA : Unsigned_32 := 0; -- Specifies the transfer destination start address
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMDAR_Type use record
      DMDA at 0 range 0 .. 31;
   end record;

   -- 17.2.3 DMA Transfer Count Register (DMCRA)

   type DMCRA_Type is record
      DMCRAL : Unsigned_16 := 0; -- Lower bits of transfer count
      DMCRAH : Unsigned_16 := 0; -- Upper bits of transfer count
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMCRA_Type use record
      DMCRAL at 0 range  0 .. 15;
      DMCRAH at 0 range 16 .. 31;
   end record;

  -- 17.2.4 DMA Block Transfer Count Register (DMCRB)

   type DMCRB_Type is record
      DMCRB : Unsigned_16 := 0; -- Specifies the number of block or repeat transfer operations
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for DMCRB_Type use record
      DMCRB at 0 range 0 .. 15;
   end record;

   -- 17.2.5 DMA Transfer Mode Register (DMTMD)

   DCTG_SOFT  : constant := 2#00#; -- Software
   DCTG_INT   : constant := 2#01#; -- Interrupts from peripheral modules or external interrupt input pins
   DCTG_RSVD1 : constant := 2#10#; -- Setting prohibited
   DCTG_RSVD2 : constant := 2#11#; -- Setting prohibited.

   SZ_8    : constant := 2#00#; -- 8 bits
   SZ_16   : constant := 2#01#; -- 16 bits
   SZ_32   : constant := 2#10#; -- 32 bits
   SZ_RSVD : constant := 2#11#; -- Setting prohibited.

   DTS_DST  : constant := 2#00#; -- Specify destination as the repeat area or block area
   DTS_SRC  : constant := 2#01#; -- Specify source as the repeat area or block area
   DTS_NONE : constant := 2#10#; -- Do not specify repeat area or block area
   DTS_RSVD : constant := 2#11#; -- Setting prohibited.

   MD_NORMAL : constant := 2#00#; -- Normal transfer
   MD_REPEAT : constant := 2#01#; -- Repeat transfer
   MD_BLOCK  : constant := 2#10#; -- Block transfer
   MD_RSVD   : constant := 2#11#; -- Setting prohibited.

   type DMTMD_Type is record
      DCTG      : Bits_2 := DCTG_SOFT; -- Transfer Request Source Select
      Reserved1 : Bits_6 := 0;
      SZ        : Bits_2 := SZ_8;      -- Transfer Data Size Select
      Reserved2 : Bits_2 := 0;
      DTS       : Bits_2 := DTS_DST;   -- Repeat Area Select
      MD        : Bits_2 := MD_NORMAL; -- Transfer Mode Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for DMTMD_Type use record
      DCTG      at 0 range  0 ..  1;
      Reserved1 at 0 range  2 ..  7;
      SZ        at 0 range  8 ..  9;
      Reserved2 at 0 range 10 .. 11;
      DTS       at 0 range 12 .. 13;
      MD        at 0 range 14 .. 15;
   end record;

   -- 17.2.6 DMA Interrupt Setting Register (DMINT)

   type DMINT_Type is record
      DARIE    : Boolean := False; -- Destination Address Extended Repeat Area Overflow Interrupt Enable
      SARIE    : Boolean := False; -- Source Address Extended Repeat Area Overflow Interrupt Enable
      RPTIE    : Boolean := False; -- Repeat Size End Interrupt Enable
      ESIE     : Boolean := False; -- Transfer Escape End Interrupt Enable
      DTIE     : Boolean := False; -- Transfer End Interrupt Enable
      Reserved : Bits_3 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for DMINT_Type use record
      DARIE    at 0 range 0 .. 0;
      SARIE    at 0 range 1 .. 1;
      RPTIE    at 0 range 2 .. 2;
      ESIE     at 0 range 3 .. 3;
      DTIE     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 17.2.7 DMA Address Mode Register (DMAMD)

   DARA_NONE  : constant := 2#00000#; -- Not specified
   DARA_2     : constant := 2#00001#; -- 2 bytes specified as extended repeat area by the lower 1 bit of the address
   DARA_4     : constant := 2#00010#; -- 4 bytes specified as extended repeat area by the lower 2 bits of the address
   DARA_8     : constant := 2#00011#; -- 8 bytes specified as extended repeat area by the lower 3 bits of the address
   DARA_16    : constant := 2#00100#; -- 16 bytes specified as extended repeat area by the lower 4 bits of the address
   DARA_32    : constant := 2#00101#; -- 32 bytes specified as extended repeat area by the lower 5 bits of the address
   DARA_64    : constant := 2#00110#; -- 64 bytes specified as extended repeat area by the lower 6 bits of the address
   DARA_128   : constant := 2#00111#; -- 128 bytes specified as extended repeat area by the lower 7 bits of the address
   DARA_256   : constant := 2#01000#; -- 256 bytes specified as extended repeat area by the lower 8 bits of the address
   DARA_512   : constant := 2#01001#; -- 512 bytes specified as extended repeat area by the lower 9 bits of the address
   DARA_1KB   : constant := 2#01010#; -- 1 KB specified as extended repeat area by the lower 10 bits of the address
   DARA_2KB   : constant := 2#01011#; -- 2 KB specified as extended repeat area by the lower 11 bits of the address
   DARA_4KB   : constant := 2#01100#; -- 4 KB specified as extended repeat area by the lower 12 bits of the address
   DARA_8KB   : constant := 2#01101#; -- 8 KB specified as extended repeat area by the lower 13 bits of the address
   DARA_16K   : constant := 2#01110#; -- 16 KB specified as extended repeat area by the lower 14 bits of the address
   DARA_32KB  : constant := 2#01111#; -- 32 KB specified as extended repeat area by the lower 15 bits of the address
   DARA_64KB  : constant := 2#10000#; -- 64 KB specified as extended repeat area by the lower 16 bits of the address
   DARA_128KB : constant := 2#10001#; -- 128 KB specified as extended repeat area by the lower 17 bits of the address
   DARA_256KB : constant := 2#10010#; -- 256 KB specified as extended repeat area by the lower 18 bits of the address
   DARA_512KB : constant := 2#10011#; -- 512 KB specified as extended repeat area by the lower 19 bits of the address
   DARA_1MB   : constant := 2#10100#; -- 1 MB specified as extended repeat area by the lower 20 bits of the address
   DARA_2MB   : constant := 2#10101#; -- 2 MB specified as extended repeat area by the lower 21 bits of the address
   DARA_4MB   : constant := 2#10110#; -- 4 MB specified as extended repeat area by the lower 22 bits of the address
   DARA_8MB   : constant := 2#10111#; -- 8 MB specified as extended repeat area by the lower 23 bits of the address
   DARA_16MB  : constant := 2#11000#; -- 16 MB specified as extended repeat area by the lower 24 bits of the address
   DARA_32MB  : constant := 2#11001#; -- 32 MB specified as extended repeat area by the lower 25 bits of the address
   DARA_64MB  : constant := 2#11010#; -- 64 MB specified as extended repeat area by the lower 26 bits of the address
   DARA_128MB : constant := 2#11011#; -- 128 MB specified as extended repeat area by the lower 27 bits of the address
   DARA_RSVD1 : constant := 2#11100#; -- Setting prohibited
   DARA_RSVD2 : constant := 2#11101#; -- Setting prohibited
   DARA_RSVD3 : constant := 2#11110#; -- Setting prohibited
   DARA_RSVD4 : constant := 2#11111#; -- Setting prohibited

   DM_FIXED  : constant := 2#00#; -- Fixed address
   DM_OFFSET : constant := 2#01#; -- Offset addition
   DM_INCR   : constant := 2#10#; -- Incremented address
   DM_DECR   : constant := 2#11#; -- Decremented address.

   SARA_NONE  renames DARA_NONE;
   SARA_2     renames DARA_2;
   SARA_4     renames DARA_4;
   SARA_8     renames DARA_8;
   SARA_16    renames DARA_16;
   SARA_32    renames DARA_32;
   SARA_64    renames DARA_64;
   SARA_128   renames DARA_128;
   SARA_256   renames DARA_256;
   SARA_512   renames DARA_512;
   SARA_1KB   renames DARA_1KB;
   SARA_2KB   renames DARA_2KB;
   SARA_4KB   renames DARA_4KB;
   SARA_8KB   renames DARA_8KB;
   SARA_16K   renames DARA_16K;
   SARA_32KB  renames DARA_32KB;
   SARA_64KB  renames DARA_64KB;
   SARA_128KB renames DARA_128KB;
   SARA_256KB renames DARA_256KB;
   SARA_512KB renames DARA_512KB;
   SARA_1MB   renames DARA_1MB;
   SARA_2MB   renames DARA_2MB;
   SARA_4MB   renames DARA_4MB;
   SARA_8MB   renames DARA_8MB;
   SARA_16MB  renames DARA_16MB;
   SARA_32MB  renames DARA_32MB;
   SARA_64MB  renames DARA_64MB;
   SARA_128MB renames DARA_128MB;
   SARA_RSVD1 renames DARA_RSVD1;
   SARA_RSVD2 renames DARA_RSVD2;
   SARA_RSVD3 renames DARA_RSVD3;
   SARA_RSVD4 renames DARA_RSVD4;

   SM_FIXED  renames DM_FIXED;
   SM_OFFSET renames DM_OFFSET;
   SM_INCR   renames DM_INCR;
   SM_DECR   renames DM_DECR;

   type DMAMD_Type is record
      DARA      : Bits_5 := DARA_NONE; -- Destination Address Extended Repeat Area
      Reserved1 : Bits_1 := 0;
      DM        : Bits_2 := DM_FIXED;  -- Destination Address Update Mode
      SARA      : Bits_5 := SARA_NONE; -- Source Address Extended Repeat Area
      Reserved2 : Bits_1 := 0;
      SM        : Bits_2 := SM_FIXED;  -- Source Address Update Mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for DMAMD_Type use record
      DARA      at 0 range  0 ..  4;
      Reserved1 at 0 range  5 ..  5;
      DM        at 0 range  6 ..  7;
      SARA      at 0 range  8 .. 12;
      Reserved2 at 0 range 13 .. 13;
      SM        at 0 range 14 .. 15;
   end record;

   -- 17.2.8 DMA Offset Register (DMOFR)

   type DMOFR_Type is record
      DMOF : Unsigned_32 := 0; -- Specifies the offset when offset addition is selected as the address update mode for transfer source or destination
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for DMOFR_Type use record
      DMOF at 0 range 0 .. 31;
   end record;

   -- 17.2.9 DMA Transfer Enable Register (DMCNT)

   type DMCNT_Type is record
      DTE      : Boolean := False; -- DMA Transfer Enable
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for DMCNT_Type use record
      DTE      at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- 17.2.10 DMA Software Start Register (DMREQ)

   type DMREQ_Type is record
      SWREQ     : Boolean := False; -- DMA Software Start
      Reserved1 : Bits_3  := 0;
      CLRS      : Boolean := False; -- DMA Software Start Bit Auto Clear Select
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for DMREQ_Type use record
      SWREQ     at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      CLRS      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
   end record;

   -- 17.2.11 DMA Status Register (DMSTS)

   type DMSTS_Type is record
      ESIF      : Boolean := False; -- Transfer Escape End Interrupt Flag
      Reserved1 : Bits_3  := 0;
      DTIF      : Boolean := False; -- Transfer End Interrupt Flag
      Reserved2 : Bits_2  := 0;
      ACT       : Boolean := False; -- DMA Active Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for DMSTS_Type use record
      ESIF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      DTIF      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 6;
      ACT       at 0 range 7 .. 7;
   end record;

   -- 17.2.12 DMAC Module Activation Register (DMAST)

   type DMAST_Type is record
      DMST     : Boolean := False; -- DMAC Operation Enable
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for DMAST_Type use record
      DMST     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- DMAC0 .. DMAC7 memory-mapped array

pragma Warnings (Off);
   type DMAC_Type is record
      DMSAR : DMSAR_Type with Volatile_Full_Access => True;
      DMDAR : DMDAR_Type with Volatile_Full_Access => True;
      DMCRA : DMCRA_Type with Volatile_Full_Access => True;
      DMCRB : DMCRB_Type with Volatile_Full_Access => True;
      DMTMD : DMTMD_Type with Volatile_Full_Access => True;
      DMINT : DMINT_Type with Volatile_Full_Access => True;
      DMAMD : DMAMD_Type with Volatile_Full_Access => True;
      DMOFR : DMOFR_Type with Volatile_Full_Access => True;
      DMCNT : DMCNT_Type with Volatile_Full_Access => True;
      DMREQ : DMREQ_Type with Volatile_Full_Access => True;
      DMSTS : DMSTS_Type with Volatile_Full_Access => True;
   end record
      with Object_Size             => 16#40# * 8,
           Suppress_Initialization => True;
   for DMAC_Type use record
      DMSAR at 16#00# range 0 .. 31;
      DMDAR at 16#04# range 0 .. 31;
      DMCRA at 16#08# range 0 .. 31;
      DMCRB at 16#0C# range 0 .. 15;
      DMTMD at 16#10# range 0 .. 15;
      DMINT at 16#13# range 0 ..  7;
      DMAMD at 16#14# range 0 .. 15;
      DMOFR at 16#18# range 0 .. 31;
      DMCNT at 16#1C# range 0 ..  7;
      DMREQ at 16#1D# range 0 ..  7;
      DMSTS at 16#1E# range 0 ..  7;
   end record;
pragma Warnings (On);

   DMAC_BASEADDRESS : constant := 16#4000_5000#;

   DMAC : aliased array (0 .. 7) of DMAC_Type
      with Address    => System'To_Address (DMAC_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   DMAST : aliased DMAST_Type
      with Address    => System'To_Address (DMAC_BASEADDRESS + 16#200#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 18. Data Transfer Controller (DTC)
   ----------------------------------------------------------------------------

   -- 18.2.1 DTC Mode Register A (MRA)
   -- 18.2.2 DTC Mode Register B (MRB)
   -- 18.2.3 DTC Transfer Source Register (SAR)
   -- 18.2.4 DTC Transfer Destination Register (DAR)
   -- 18.2.5 DTC Transfer Count Register A (CRA)
   -- 18.2.6 DTC Transfer Count Register B (CRB)
   -- 18.2.7 DTC Control Register (DTCCR)
   -- 18.2.8 DTC Vector Base Register (DTCVBR)
   -- 18.2.9 DTC Module Start Register (DTCST)
   -- 18.2.10 DTC Status Register (DTCSTS)

   ----------------------------------------------------------------------------
   -- 19. Event Link Controller (ELC)
   ----------------------------------------------------------------------------

   -- 19.2.1 Event Link Controller Register (ELCR)
   -- 19.2.2 Event Link Software Event Generation Register n (ELSEGRn) (n = 0, 1)
   -- 19.2.3 Event Link Setting Register n (ELSRn) (n = 0 to 18)

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
      with Object_Size             => 16#20# * 8,
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
      PODR      : Boolean := False;             -- Port Output Data
      PIDR      : Boolean := False;             -- Pmn State
      PDR       : Bits_1  := PDR_PORTIN;        -- Port Direction
      Reserved1 : Bits_1  := 0;
      PCR       : Boolean := False;             -- Pull-up Control
      Reserved2 : Bits_1  := 0;
      NCODR     : Bits_1  := NCODR_CMOS;        -- N-Channel Open-Drain Control
      Reserved3 : Bits_3  := 0;
      DSCR      : Bits_2  := DSCR_LowDrive;     -- Port Drive Capability
      EOFEOR    : Bits_2  := EOFEOR_Dontcare;   -- Event on Falling/Event on Rising
      ISEL      : Boolean := False;             -- IRQ Input Enable
      ASEL      : Boolean := False;             -- Analog Input Enable
      PMR       : Boolean := False;             -- Port Mode Control
      Reserved4 : Bits_7  := 0;
      PSEL      : Bits_5  := PSEL_HiZ_JTAG_SWD; -- Peripheral Select
      Reserved5 : Bits_3  := 0;
   end record
      with Bit_Order               => Low_Order_First,
           Object_Size             => 32,
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
      PFSWE    : Boolean := False; -- PmnPFS Register Write Enable
      B0WI     : Boolean := True;  -- PFSWE Bit Write Disable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
   -- 21. Key Interrupt Function (KINT)
   ----------------------------------------------------------------------------

   -- 21.2.1 Key Return Control Register (KRCTL)
   -- 21.2.2 Key Return Flag Register (KRF)
   -- 21.2.3 Key Return Mode Register (KRM)

   ----------------------------------------------------------------------------
   -- 22. Port Output Enable for GPT (POEG)
   ----------------------------------------------------------------------------

   -- 22.2.1 POEG Group n Setting Register (POEGGn) (n = A to D)

   ----------------------------------------------------------------------------
   -- 23. General PWM Timer (GPT)
   ----------------------------------------------------------------------------

   -- 23.2.1 General PWM Timer Write-Protection Register (GTWP)
   -- 23.2.2 General PWM Timer Software Start Register (GTSTR)
   -- 23.2.3 General PWM Timer Software Stop Register (GTSTP)
   -- 23.2.4 General PWM Timer Software Clear Register (GTCLR)
   -- 23.2.5 General PWM Timer Start Source Select Register (GTSSR)
   -- 23.2.6 General PWM Timer Stop Source Select Register (GTPSR)
   -- 23.2.7 General PWM Timer Clear Source Select Register (GTCSR)
   -- 23.2.8 General PWM Timer Up Count Source Select Register (GTUPSR)
   -- 23.2.9 General PWM Timer Down Count Source Select Register (GTDNSR)
   -- 23.2.10 General PWM Timer Input Capture Source Select Register A (GTICASR)
   -- 23.2.11 General PWM Timer Input Capture Source Select Register B (GTICBSR)
   -- 23.2.12 General PWM Timer Control Register (GTCR)
   -- 23.2.13 General PWM Timer Count Direction and Duty Setting Register (GTUDDTYC)
   -- 23.2.14 General PWM Timer I/O Control Register (GTIOR)
   -- 23.2.15 General PWM Timer Interrupt Output Setting Register (GTINTAD)
   -- 23.2.16 General PWM Timer Status Register (GTST)
   -- 23.2.17 General PWM Timer Buffer Enable Register (GTBER)
   -- 23.2.18 General PWM Timer Interrupt and A/D Converter Start Request Skipping Setting Register (GTITC)
   -- 23.2.19 General PWM Timer Counter (GTCNT)
   -- 23.2.20 General PWM Timer Compare Capture Register n (GTCCRn) (n = A to F)
   -- 23.2.21 General PWM Timer Cycle Setting Register (GTPR)
   -- 23.2.22 General PWM Timer Cycle Setting Buffer Register (GTPBR)
   -- 23.2.23 General PWM Timer Cycle Setting Double-Buffer Register (GTPDBR)
   -- 23.2.24 A/D Converter Start Request Timing Register n (GTADTRn) (n = A, B)
   -- 23.2.25 A/D Converter Start Request Timing Buffer Register n (GTADTBRn) (n = A, B)
   -- 23.2.26 A/D Converter Start Request Timing Double-Buffer Register n (GTADTDBRn) (n = A, B)
   -- 23.2.27 General PWM Timer Dead Time Control Register (GTDTCR)
   -- 23.2.28 General PWM Timer Dead Time Value Register n (GTDVn) (n = U, D)
   -- 23.2.29 General PWM Timer Dead Time Buffer Register n (GTDBn) (n = U, D)
   -- 23.2.30 General PWM Timer Output Protection Function Status Register (GTSOS)
   -- 23.2.31 General PWM Timer Output Protection Function Temporary Release Register (GTSOTR)
   -- 23.2.32 Output Phase Switching Control Register (OPSCR)

   ----------------------------------------------------------------------------
   -- 24. PWM Delay Generation Circuit
   ----------------------------------------------------------------------------

   -- 24.2.1 PWM Output Delay Control Register (GTDLYCR)
   -- 24.2.2 PWM Output Delay Control Register 2 (GTDLYCR2)
   -- 24.2.3 GTIOCnA Rising Output Delay Register (GTDLYRnA) (n = 0 to 3)
   -- 24.2.4 GTIOCnA Falling Output Delay Register (GTDLYFnA) (n = 0 to 3)
   -- 24.2.5 GTIOCnB Rising Output Delay Register (GTDLYRnB) (n = 0 to 3)
   -- 24.2.6 GTIOCnB Falling Output Delay Register (GTDLYFnB) (n = 0 to 3)

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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for AGTMR1_Type use record
      TMOD     at 0 range 0 .. 2;
      TEDGPL   at 0 range 3 .. 3;
      TCK      at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   -- 25.2.6 AGT Mode Register 2 (AGTMR2)

   CKS_PCLKB_DIV1   : constant := 2#000#;
   CKS_PCLKB_DIV2   : constant := 2#001#;
   CKS_PCLKB_DIV4   : constant := 2#010#;
   CKS_PCLKB_DIV8   : constant := 2#011#;
   CKS_PCLKB_DIV16  : constant := 2#100#;
   CKS_PCLKB_DIV32  : constant := 2#101#;
   CKS_PCLKB_DIV64  : constant := 2#110#;
   CKS_PCLKB_DIV128 : constant := 2#111#;

   type AGTMR2_Type is record
      CKS      : Bits_3  := CKS_PCLKB_DIV1; -- AGTSCLK/AGTLCLK Count Source Clock Frequency Division Ratio
      Reserved : Bits_4  := 0;
      LPM      : Boolean := False;          -- Low Power Mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Object_Size => 16 * 8;
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
   -- 26. Realtime Clock (RTC)
   ----------------------------------------------------------------------------

   -- 26.2.1 64-Hz Counter (R64CNT)

   type R64CNT_Type is record
      F64HZ    : Boolean; -- 64 Hz
      F32HZ    : Boolean; -- 32 Hz
      F16HZ    : Boolean; -- 16 Hz
      F8HZ     : Boolean; -- 8 Hz
      F4HZ     : Boolean; -- 4 Hz
      F2HZ     : Boolean; -- 2 Hz
      F1HZ     : Boolean; -- 1 Hz
      Reserved : Bits_1;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for R64CNT_Type use record
      F64HZ    at 0 range 0 .. 0;
      F32HZ    at 0 range 1 .. 1;
      F16HZ    at 0 range 2 .. 2;
      F8HZ     at 0 range 3 .. 3;
      F4HZ     at 0 range 4 .. 4;
      F2HZ     at 0 range 5 .. 5;
      F1HZ     at 0 range 6 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   R64CNT_ADDRESS : constant := 16#4004_4000#;

   R64CNT : aliased R64CNT_Type
      with Address              => System'To_Address (R64CNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.2 Second Counter (RSECCNT)/Binary Counter 0 (BCNT0)

   type RSECCNT_Type is record
      SEC1     : Bits_4;      -- 1-Second Count
      SEC10    : Bits_3;      -- 10-Second Count
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RSECCNT_Type use record
      SEC1     at 0 range 0 .. 3;
      SEC10    at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   RSECCNT_ADDRESS : constant := 16#4004_4002#;

   RSECCNT : aliased RSECCNT_Type
      with Address              => System'To_Address (RSECCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.3 Minute Counter (RMINCNT)/Binary Counter 1 (BCNT1)

   type RMINCNT_Type is record
      MIN1     : Bits_4;      -- 1-Minute Count
      MIN10    : Bits_3;      -- 10-Minute Count
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RMINCNT_Type use record
      MIN1     at 0 range 0 .. 3;
      MIN10    at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   RMINCNT_ADDRESS : constant := 16#4004_4004#;

   RMINCNT : aliased RMINCNT_Type
      with Address              => System'To_Address (RMINCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.4 Hour Counter (RHRCNT)/Binary Counter 2 (BCNT2)

   type RHRCNT_Type is record
      HR1      : Bits_4;      -- 1-Hour Count
      HR10     : Bits_3;      -- 10-Hour Count
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RHRCNT_Type use record
      HR1      at 0 range 0 .. 3;
      HR10     at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   RHRCNT_ADDRESS : constant := 16#4004_4006#;

   RHRCNT : aliased RHRCNT_Type
      with Address              => System'To_Address (RHRCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.5 Day-of-Week Counter (RWKCNT)/Binary Counter 3 (BCNT3)

   DAYW_SUN  : constant := 2#000#; -- Sunday
   DAYW_MON  : constant := 2#001#; -- Monday
   DAYW_TUE  : constant := 2#010#; -- Tuesday
   DAYW_WED  : constant := 2#011#; -- Wednesday
   DAYW_THU  : constant := 2#100#; -- Thursday
   DAYW_FRI  : constant := 2#101#; -- Friday
   DAYW_SAT  : constant := 2#110#; -- Saturday
   DAYW_RSVD : constant := 2#111#; -- Setting prohibited.

   type RWKCNT_Type is record
      DAYW     : Bits_3;      -- Day-of-Week Counting
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RWKCNT_Type use record
      DAYW     at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   RWKCNT_ADDRESS : constant := 16#4004_4008#;

   RWKCNT : aliased RWKCNT_Type
      with Address              => System'To_Address (RWKCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.6 Day Counter (RDAYCNT)

   type RDAYCNT_Type is record
      DATE1    : Bits_4;      -- 1-Day Count
      DATE10   : Bits_2;      -- 10-Day Count
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RDAYCNT_Type use record
      DATE1    at 0 range 0 .. 3;
      DATE10   at 0 range 4 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   RDAYCNT_ADDRESS : constant := 16#4004_400A#;

   RDAYCNT : aliased RDAYCNT_Type
      with Address              => System'To_Address (RDAYCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.7 Month Counter (RMONCNT)

   type RMONCNT_Type is record
      MON1     : Bits_4;      -- 1-Month Count
      MON10    : Bits_1;      -- 10-Month Count
      Reserved : Bits_3 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RMONCNT_Type use record
      MON1     at 0 range 0 .. 3;
      MON10    at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   RMONCNT_ADDRESS : constant := 16#4004_400C#;

   RMONCNT : aliased RMONCNT_Type
      with Address              => System'To_Address (RMONCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.8 Year Counter (RYRCNT)

   type RYRCNT_Type is record
      YR1      : Bits_4;      -- 1-Year Count
      YR10     : Bits_4;      -- 10-Year Count
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for RYRCNT_Type use record
      YR1      at 0 range 0 ..  3;
      YR10     at 0 range 4 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   RYRCNT_ADDRESS : constant := 16#4004_400E#;

   RYRCNT : aliased RYRCNT_Type
      with Address              => System'To_Address (RYRCNT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.9 Second Alarm Register (RSECAR)/Binary Counter 0 Alarm Register (BCNT0AR)
   -- 26.2.10 Minute Alarm Register (RMINAR)/Binary Counter 1 Alarm Register (BCNT1AR)
   -- 26.2.11 Hour Alarm Register (RHRAR)/Binary Counter 2 Alarm Register (BCNT2AR)
   -- 26.2.12 Day-of-Week Alarm Register (RWKAR)/Binary Counter 3 Alarm Register (BCNT3AR)
   -- 26.2.13 Date Alarm Register (RDAYAR)/Binary Counter 0 Alarm Enable Register (BCNT0AER)
   -- 26.2.14 Month Alarm Register (RMONAR)/Binary Counter 1 Alarm Enable Register (BCNT1AER)
   -- 26.2.15 Year Alarm Register (RYRAR)/Binary Counter 2 Alarm Enable Register (BCNT2AER)
   -- 26.2.16 Year Alarm Enable Register (RYRAREN)/Binary Counter 3 Alarm Enable Register (BCNT3AER)

   -- 26.2.17 RTC Control Register 1 (RCR1)

   RTCOS_1HZ  : constant := 0; -- RTCOUT outputs 1 Hz
   RTCOS_64HZ : constant := 1; -- RTCOUT outputs 64 Hz.

   PES_RSVD1  : constant := 2#0000#;
   PES_RSVD2  : constant := 2#0001#;
   PES_RSVD3  : constant := 2#0010#;
   PES_RSVD4  : constant := 2#0011#;
   PES_RSVD5  : constant := 2#0100#;
   PES_RSVD6  : constant := 2#0101#;
   PES_DIV256 : constant := 2#0110#; -- Generate periodic interrupt every 1/256 second
   PES_DIV128 : constant := 2#0111#; -- Generate periodic interrupt every 1/128 second
   PES_DIV64  : constant := 2#1000#; -- Generate periodic interrupt every 1/64 second
   PES_DIV32  : constant := 2#1001#; -- Generate periodic interrupt every 1/32 second
   PES_DIV16  : constant := 2#1010#; -- Generate periodic interrupt every 1/16 second
   PES_DIV8   : constant := 2#1011#; -- Generate periodic interrupt every 1/8 second
   PES_DIV4   : constant := 2#1100#; -- Generate periodic interrupt every 1/4 second
   PES_DIV2   : constant := 2#1101#; -- Generate periodic interrupt every 1/2 second
   PES_1      : constant := 2#1110#; -- Generate periodic interrupt every 1 second
   PES_2      : constant := 2#1111#; -- Generate periodic interrupt every 2 seconds.

   type RCR1_Type is record
      AIE   : Boolean := False;     -- Alarm Interrupt Enable
      CIE   : Boolean := False;     -- Carry Interrupt Enable
      PIE   : Boolean := False;     -- Periodic Interrupt Enable
      RTCOS : Bits_1  := RTCOS_1HZ; -- RTCOUT Output Select
      PES   : Bits_4  := PES_1;     -- Periodic Interrupt Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RCR1_Type use record
      AIE   at 0 range 0 .. 0;
      CIE   at 0 range 1 .. 1;
      PIE   at 0 range 2 .. 2;
      RTCOS at 0 range 3 .. 3;
      PES   at 0 range 4 .. 7;
   end record;

   RCR1_ADDRESS : constant := 16#4004_4022#;

   RCR1 : aliased RCR1_Type
      with Address              => System'To_Address (RCR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.18 RTC Control Register 2 (RCR2)

   CNTMD_CALENDAR : constant := 0; -- Calendar count mode
   CNTMD_BINARY   : constant := 1; -- Binary count mode.

   type RCR2_Type is record
      START    : Boolean := False;          -- Start
      RESET    : Boolean := False;          -- RTC Software Reset
      Reserved : Bits_5  := 0;
      CNTMD    : Bits_1  := CNTMD_CALENDAR; -- Count Mode Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RCR2_Type use record
      START    at 0 range 0 .. 0;
      RESET    at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 6;
      CNTMD    at 0 range 7 .. 7;
   end record;

   RCR2_ADDRESS : constant := 16#4004_4024#;

   RCR2 : aliased RCR2_Type
      with Address              => System'To_Address (RCR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.19 RTC Control Register 4 (RCR4)

   RCKSEL_SOSC : constant := 0; -- Sub-clock oscillator is selected
   RCKSEL_LOC0 : constant := 1; -- LOCO is selected.

   type RCR4_Type is record
      RCKSEL   : Bits_1 := RCKSEL_SOSC; -- Count Source Select
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RCR4_Type use record
      RCKSEL   at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   RCR4_ADDRESS : constant := 16#4004_4028#;

   RCR4 : aliased RCR4_Type
      with Address              => System'To_Address (RCR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.20 Frequency Register (RFRH/RFRL)
   -- 26.2.21 Time Error Adjustment Register (RADJ)
   -- 26.2.22 Time Capture Control Register y (RTCCRy) (y = 0 to 2)
   -- 26.2.23 Second Capture Register y (RSECCPy) (y = 0 to 2)/BCNT0 Capture Register y (BCNT0CPy) (y = 0 to 2)
   -- 26.2.24 Minute Capture Register y (RMINCPy) (y = 0 to 2)/BCNT1 Capture Register y (BCNT1CPy) (y = 0 to 2)
   -- 26.2.25 Hour Capture Register y (RHRCPy) (y = 0 to 2)/BCNT2 Capture Register y (BCNT2CPy) (y = 0 to 2)
   -- 26.2.26 Date Capture Register y (RDAYCPy) (y = 0 to 2)/BCNT3 Capture Register y (BCNT3CPy) (y = 0 to 2)
   -- 26.2.27 Month Capture Register y (RMONCPy) (y = 0 to 2)

   ----------------------------------------------------------------------------
   -- 27. Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

   -- 27.2.1 WDT Refresh Register (WDTRR)
   -- 27.2.2 WDT Control Register (WDTCR)
   -- 27.2.3 WDT Status Register (WDTSR)
   -- 27.2.4 WDT Reset Control Register (WDTRCR)
   -- 27.2.5 WDT Count Stop Control Register (WDTCSTPR)
   -- 27.2.6 Option Function Select Register 0 (OFS0)

   ----------------------------------------------------------------------------
   -- 28. Independent Watchdog Timer (IWDT)
   ----------------------------------------------------------------------------

   -- 28.2.1 IWDT Refresh Register (IWDTRR)
   -- 28.2.2 IWDT Status Register (IWDTSR)
   -- 28.2.3 Option Function Select Register 0 (OFS0)

   ----------------------------------------------------------------------------
   -- 29. Ethernet MAC Controller (ETHERC)
   ----------------------------------------------------------------------------

   -- 29.2.1 ETHERC Mode Register (ECMR)
   -- 29.2.2 Receive Frame Maximum Length Register (RFLR)
   -- 29.2.3 ETHERC Status Register (ECSR)
   -- 29.2.4 ETHERC Interrupt Enable Register (ECSIPR)

   -- 29.2.5 PHY Interface Register (PIR)

   type PIR_Type is record
      MDC      : Bits_1  := 0; -- MII/RMII Management Data Clock
      MMD      : Bits_1  := 0; -- MII/RMII Management Mode
      MDO      : Bits_1  := 0; -- MII/RMII Management Data-Out
      MDI      : Bits_1  := 0; -- MII/RMII Management Data-In
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for PSR_Type use record
      LMON     at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 29.2.7 Random Number Generation Counter Upper Limit Setting Register (RDMLR)
   -- 29.2.8 Interpacket Gap Register (IPGR)
   -- 29.2.9 Automatic PAUSE Frame Register (APR)
   -- 29.2.10 Manual PAUSE Frame Register (MPR)
   -- 29.2.11 Received PAUSE Frame Counter (RFCF)
   -- 29.2.12 PAUSE Frame Retransmit Count Setting Register (TPAUSER)
   -- 29.2.13 PAUSE Frame Retransmit Counter (TPAUSECR)
   -- 29.2.14 Broadcast Frame Receive Count Setting Register (BCFRR)
   -- 29.2.15 MAC Address Upper Bit Register (MAHR)
   -- 29.2.16 MAC Address Lower Bit Register (MALR)
   -- 29.2.17 Transmit Retry Over Counter Register (TROCR)
   -- 29.2.18 Late Collision Detect Counter Register (CDCR)
   -- 29.2.19 Lost Carrier Counter Register (LCCR)
   -- 29.2.20 Carrier Not Detect Counter Register (CNDCR)
   -- 29.2.21 CRC Error Frame Receive Counter Register (CEFCR)
   -- 29.2.22 Frame Receive Error Counter Register (FRECR)
   -- 29.2.23 Too-Short Frame Receive Counter Register (TSFRCR)
   -- 29.2.24 Too-Long Frame Receive Counter Register (TLFRCR)
   -- 29.2.25 Received Alignment Error Frame Counter Register (RFCR)
   -- 29.2.26 Multicast Address Frame Receive Counter Register (MAFCR)

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
   -- 30. Ethernet PTP Controller (EPTPC)
   ----------------------------------------------------------------------------

   -- 30.2.1 ETHER_MINT Interrupt Source Status Register (MIESR)
   -- 30.2.2 ETHER_MINT Interrupt Request Enable Register (MIEIPR)
   -- 30.2.3 ELC Output/ETHER_IPLS Interrupt Request Permission Register (ELIPPR)
   -- 30.2.4 ELC Output/ETHER_IPLS Interrupt Permission Automatic Clearing Register (ELIPACR)
   -- 30.2.5 STCA Status Register (STSR)
   -- 30.2.6 STCA Status Notification Enable Register (STIPR)
   -- 30.2.7 STCA Clock Frequency Setting Register (STCFR)
   -- 30.2.8 STCA Operating Mode Register (STMR)
   -- 30.2.9 Sync Message Reception Timeout Register (SYNTOR)
   -- 30.2.10 ETHER_IPLS Interrupt Request Timer Select Register (IPTSELR)
   -- 30.2.11 ETHER_MINT Interrupt Request Timer Select Register (MITSELR)
   -- 30.2.12 ELC Output Timer Select Register (ELTSELR)
   -- 30.2.13 Time Synchronization Channel Select Register (STCHSELR)
   -- 30.2.14 Slave Time Synchronization Start Register (SYNSTARTR)
   -- 30.2.15 Local Clock Counter Initial Value Load Directive Register (LCIVLDR)
   -- 30.2.16 Synchronization Loss Detection Threshold Register (SYNTDARU, SYNTDARL)
   -- 30.2.17 Synchronization Detection Threshold Register (SYNTDBRU, SYNTDBRL)
   -- 30.2.18 Local Clock Counter Initial Value Register (LCIVRU, LCIVRM, LCIVRL)
   -- 30.2.19 Worst 10 Acquisition Directive Register (GETW10R)
   -- 30.2.20 Positive Gradient Limit Register (PLIMITRU, PLIMITRM, PLIMITRL)
   -- 30.2.21 Negative Gradient Limit Register (MLIMITRU, MLIMITRM, MLIMITRL)
   -- 30.2.22 Statistical Information Retention Control Register (GETINFOR)
   -- 30.2.23 Local Clock Counter (LCCVRU, LCCVRM, LCCVRL)
   -- 30.2.24 Positive Gradient Worst 10 Value Register (PW10VRU, PW10VRM, PW10VRL)
   -- 30.2.25 Negative Gradient Worst 10 Value Register (MW10RU, MW10RM, MW10RL)
   -- 30.2.26 Timer Start Time Setting Register m (TMSTTRUm, TMSTTRLm) (m = 0 to 5)
   -- 30.2.27 Timer Cycle Setting Registers m (TMCYCRm) (m = 0 to 5)
   -- 30.2.28 Timer Pulse Width Setting Register m (TMPLSRm) (m = 0 to 5)
   -- 30.2.29 Timer Start Register (TMSTARTR)
   -- 30.2.30 SYNFP Status Register (SYSR)
   -- 30.2.31 SYNFP Status Notification Enable Register (SYIPR)
   -- 30.2.32 SYNFP MAC Address Registers (SYMACRU, SYMACRL)
   -- 30.2.33 SYNFP LLC-CTL Value Register (SYLLCCTLR)
   -- 30.2.34 SYNFP Local IP Address Register (SYIPADDRR)
   -- 30.2.35 SYNFP Specification Version Setting Register (SYSPVRR)
   -- 30.2.36 SYNFP Domain Number Setting Register (SYDOMR)
   -- 30.2.37 Announce Message Flag Field Setting Register (ANFR)
   -- 30.2.38 Sync Message Flag Field Setting Register (SYNFR)
   -- 30.2.39 Delay_Req Message Flag Field Setting Register (DYRQFR)
   -- 30.2.40 Delay_Resp Message Flag Field Setting Register (DYRPFR)
   -- 30.2.41 SYNFP Local Clock ID Register (SYCIDRU, SYCIDRL)
   -- 30.2.42 SYNFP Local Port Number Register (SYPNUMR)
   -- 30.2.43 SYNFP Register Value Load Directive Register (SYRVLDR)
   -- 30.2.44 SYNFP Reception Filter Register 1 (SYRFL1R)
   -- 30.2.45 SYNFP Reception Filter Register 2 (SYRFL2R)
   -- 30.2.46 SYNFP Transmission Enable Register (SYTRENR)
   -- 30.2.47 Master Clock ID Register (MTCIDU, MTCIDL)
   -- 30.2.48 Master Clock Port Number Register (MTPID)
   -- 30.2.49 SYNFP Transmission Interval Setting Register (SYTLIR)
   -- 30.2.50 SYNFP Received logMessageInterval Value Indication Register (SYRLIR)
   -- 30.2.51 offsetFromMaster Value Register (OFMRU, OFMRL)
   -- 30.2.52 meanPathDelay Value Register (MPDRU, MPDRL)
   -- 30.2.53 grandmasterPriority Field Setting Register (GMPR)
   -- 30.2.54 grandmasterClockQuality Field Setting Register (GMCQR)
   -- 30.2.55 grandmasterIdentity Field Setting Register (GMIDRU, GMIDRL)
   -- 30.2.56 currentUtcOffset/timeSource Field Setting Register (CUOTSR)
   -- 30.2.57 stepsRemoved Field Setting Register (SRR)
   -- 30.2.58 PTP-primary Message Destination MAC Address Setting Register (PPMACRU, PPMACRL)
   -- 30.2.59 PTP-pdelay Message MAC Address Setting Register (PDMACRU, PDMACRL)
   -- 30.2.60 PTP Message Ethertype Setting Register (PETYPER)
   -- 30.2.61 PTP-primary Message Destination IP Address Setting Register (PPIPR)
   -- 30.2.62 PTP-pdelay Message Destination IP Address Setting Register (PDIPR)
   -- 30.2.63 PTP Event Message TOS Setting Register (PETOSR)
   -- 30.2.64 PTP general Message TOS Setting Register (PGTOSR)
   -- 30.2.65 PTP-primary Message TTL Setting Register (PPTTLR)
   -- 30.2.66 PTP-pdelay Message TTL Setting Register (PDTTLR)
   -- 30.2.67 PTP Event Message UDP Destination Port Number Setting Register (PEUDPR)
   -- 30.2.68 PTP general Message UDP Destination Port Number Setting Register (PGUDPR)
   -- 30.2.69 Frame Reception Filter Setting Register (FFLTR)
   -- 30.2.70 Frame Reception Filter MAC Address 0 Setting Register (FMAC0RU, FMAC0RL)
   -- 30.2.71 Frame Reception Filter MAC Address 1 Setting Register (FMAC1RU, FMAC1RL)
   -- 30.2.72 Asymmetric Delay Setting Register (DASYMRU, DASYMRL)
   -- 30.2.73 Timestamp Latency Setting Register (TSLATR)
   -- 30.2.74 SYNFP Operation Setting Register (SYCONFR)
   -- 30.2.75 SYNFP Frame Format Setting Register (SYFORMR)
   -- 30.2.76 Response Message Reception Timeout Register (RSTOUTR)
   -- 30.2.77 PTP Reset Register (PTRSTR)
   -- 30.2.78 STCA Clock Select Register (STCSELR)
   -- 30.2.79 Bypass 1588 Module Register (BYPASS)

   ----------------------------------------------------------------------------
   -- 31. Ethernet DMA Controller (EDMAC)
   ----------------------------------------------------------------------------

   -- 31.2.1 EDMAC Mode Register (EDMR)
   -- 31.2.2 EDMAC Transmit Request Register (EDTRR)
   -- 31.2.3 EDMAC Receive Request Register (EDRRR)
   -- 31.2.4 Transmit Descriptor List Start Address Register (TDLAR)
   -- 31.2.5 Receive Descriptor List Start Address Register (RDLAR)
   -- 31.2.6 ETHERC/EDMAC Status Register (EDMAC0.EESR)
   -- 31.2.7 PTP/EDMAC Status Register (PTPEDMAC.EESR)
   -- 31.2.8 ETHERC/EDMAC Status Interrupt Enable Register (EDMAC0.EESIPR)
   -- 31.2.9 PTP/EDMAC Status Interrupt Enable Register (PTPEDMAC.EESIPR)
   -- 31.2.10 ETHERC/EDMAC Transmit/Receive Status Copy Enable Register (EDMAC0.TRSCER)
   -- 31.2.11 Missed-Frame Counter Register (RMFCR)
   -- 31.2.12 Transmit FIFO Threshold Register (TFTR)
   -- 31.2.13 FIFO Depth Register (FDR)
   -- 31.2.14 Receive Method Control Register (RMCR)
   -- 31.2.15 Transmit FIFO Underflow Counter (TFUCR)
   -- 31.2.16 Receive FIFO Overflow Counter (RFOCR)
   -- 31.2.17 Independent Output Signal Setting Register (IOSR)
   -- 31.2.18 Flow Control Start FIFO Threshold Setting Register (FCFTR)
   -- 31.2.19 Receive Data Padding Insert Register (RPADIR)
   -- 31.2.20 Transmit Interrupt Setting Register (TRIMD)
   -- 31.2.21 Receive Buffer Write Address Register (RBWAR)
   -- 31.2.22 Receive Descriptor Fetch Address Register (RDFAR)
   -- 31.2.23 Transmit Buffer Read Address Register (TBRAR)
   -- 31.2.24 Transmit Descriptor Fetch Address Register (TDFAR)

   ----------------------------------------------------------------------------
   -- 32. USB 2.0 Full-Speed Module (USBFS)
   ----------------------------------------------------------------------------

   -- 32.2.1 System Configuration Control Register (SYSCFG)
   -- 32.2.2 System Configuration Status Register 0 (SYSSTS0)
   -- 32.2.3 Device State Control Register 0 (DVSTCTR0)
   -- 32.2.4 CFIFO Port Register (CFIFO/CFIFOL) D0FIFO Port Register (D0FIFO/D0FIFOL) D1FIFO Port Register (D1FIFO/D1FIFOL)
   -- 32.2.5 CFIFO Port Select Register (CFIFOSEL) D0FIFO Port Select Register (D0FIFOSEL) D1FIFO Port Select Register (D1FIFOSEL)
   -- 32.2.6 CFIFO Port Control Register (CFIFOCTR) D0FIFO Port Control Register (D0FIFOCTR) D1FIFO Port Control Register (D1FIFOCTR)
   -- 32.2.7 Interrupt Enable Register 0 (INTENB0)
   -- 32.2.8 Interrupt Enable Register 1 (INTENB1)
   -- 32.2.9 BRDY Interrupt Enable Register (BRDYENB)
   -- 32.2.10 NRDY Interrupt Enable Register (NRDYENB)
   -- 32.2.11 BEMP Interrupt Enable Register (BEMPENB)
   -- 32.2.12 SOF Output Configuration Register (SOFCFG)
   -- 32.2.13 Interrupt Status Register 0 (INTSTS0)
   -- 32.2.14 Interrupt Status Register 1 (INTSTS1)
   -- 32.2.15 BRDY Interrupt Status Register (BRDYSTS)
   -- 32.2.16 NRDY Interrupt Status Register (NRDYSTS)
   -- 32.2.17 BEMP Interrupt Status Register (BEMPSTS)
   -- 32.2.18 Frame Number Register (FRMNUM)
   -- 32.2.19 Device State Change Register (DVCHGR)
   -- 32.2.20 USB Address Register (USBADDR)
   -- 32.2.21 USB Request Type Register (USBREQ)
   -- 32.2.22 USB Request Value Register (USBVAL)
   -- 32.2.23 USB Request Index Register (USBINDX)
   -- 32.2.24 USB Request Length Register (USBLENG)
   -- 32.2.25 DCP Configuration Register (DCPCFG)
   -- 32.2.26 DCP Maximum Packet Size Register (DCPMAXP)
   -- 32.2.27 DCP Control Register (DCPCTR)
   -- 32.2.28 Pipe Window Select Register (PIPESEL)
   -- 32.2.29 Pipe Configuration Register (PIPECFG)
   -- 32.2.30 Pipe Maximum Packet Size Register (PIPEMAXP)
   -- 32.2.31 Pipe Cycle Control Register (PIPEPERI)
   -- 32.2.32 PIPEn Control Registers (PIPEnCTR) (n = 1 to 9) PIPEnCTR (n = 1 to 5)
   -- 32.2.33 PIPEn Transaction Counter Enable Register (PIPEnTRE) (n = 1 to 5)
   -- 32.2.34 PIPEn Transaction Counter Register (PIPEnTRN) (n = 1 to 5)
   -- 32.2.35 Device Address n Configuration Register (DEVADDn) (n = 0 to 5)
   -- 32.2.36 PHY Cross Point Adjustment Register (PHYSLEW)
   -- 32.2.37 Deep Software Standby USB Transceiver Control/Pin Monitor Register (DPUSR0R)
   -- 32.2.38 Deep Software Standby USB Suspend/Resume Interrupt Register (DPUSR1R)

   ----------------------------------------------------------------------------
   -- 33. USB 2.0 High-Speed Module (USBHS)
   ----------------------------------------------------------------------------

   -- 33.2.1 System Configuration Control Register (SYSCFG)
   -- 33.2.2 CPU Bus Wait Register (BUSWAIT)
   -- 33.2.3 System Configuration Status Register (SYSSTS0)
   -- 33.2.4 PLL Status Register (PLLSTA)
   -- 33.2.5 Device State Control Register 0 (DVSTCTR0)
   -- 33.2.6 USB Test Mode Register (TESTMODE)
   -- 33.2.7 CFIFO Port Register (CFIFO) D0FIFO Port Register (D0FIFO) D1FIFO Port Register (D1FIFO)
   -- 33.2.8 CFIFO Port Selection Register (CFIFOSEL)
   -- 33.2.9 D0FIFO Port Selection Register (D0FIFOSEL) D1FIFO Port Selection Register (D1FIFOSEL)
   -- 33.2.10 CFIFO Port Control Register (CFIFOCTR) D0FIFO Port Control Register (D0FIFOCTR) D1FIFO Port Control Register (D1FIFOCTR)
   -- 33.2.11 Interrupt Enable Register 0 (INTENB0)
   -- 33.2.12 Interrupt Enable Register 1 (INTENB1)
   -- 33.2.13 BRDY Interrupt Enable Register (BRDYENB)
   -- 33.2.14 NRDY Interrupt Enable Register (NRDYENB)
   -- 33.2.15 BEMP Interrupt Enable Register (BEMPENB)
   -- 33.2.16 SOF Output Configuration Register (SOFCFG)
   -- 33.2.17 PHY Setting Register (PHYSET)
   -- 33.2.18 Interrupt Status Register 0 (INTSTS0)
   -- 33.2.19 Interrupt Status Register 1 (INTSTS1)
   -- 33.2.20 BRDY Interrupt Status Register (BRDYSTS)
   -- 33.2.21 NRDY Interrupt Status Register (NRDYSTS)
   -- 33.2.22 BEMP Interrupt Status Register (BEMPSTS)
   -- 33.2.23 Frame Number Register (FRMNUM)
   -- 33.2.24 μFrame Number Register (UFRMNUM)
   -- 33.2.25 USB Address Register (USBADDR)
   -- 33.2.26 USB Request Type Register (USBREQ)
   -- 33.2.27 USB Request Value Register (USBVAL)
   -- 33.2.28 USB Request Index Register (USBINDX)
   -- 33.2.29 USB Request Length Register (USBLENG)
   -- 33.2.30 DCP Configuration Register (DCPCFG)
   -- 33.2.31 DCP Maximum Packet Size Register (DCPMAXP)
   -- 33.2.32 DCP Control Register (DCPCTR)
   -- 33.2.33 Pipe Window Select Register (PIPESEL)
   -- 33.2.34 Pipe Configuration Register (PIPECFG)
   -- 33.2.35 Pipe Buffer Register (PIPEBUF)
   -- 33.2.36 Pipe Maximum Packet Size Register (PIPEMAXP)
   -- 33.2.37 Pipe Cycle Control Register (PIPEPERI)
   -- 33.2.38 Pipe n Control Register (PIPEnCTR) (n = 1 to 9)
   -- 33.2.39 Pipe n Transaction Counter Enable Register (PIPEnTRE) (n = 1 to 5)
   -- 33.2.40 Pipe n Transaction Counter Register (PIPEnTRN) (n = 1 to 5)
   -- 33.2.41 Device Address m Configuration Register (DEVADDm) (m = 0 to A)
   -- 33.2.42 Low Power Control Register (LPCTRL)
   -- 33.2.43 Low Power Status Register (LPSTS)
   -- 33.2.44 Battery Charging Control Register (BCCTRL)
   -- 33.2.45 Function L1 Control Register 1 (PL1CTRL1)
   -- 33.2.46 Function L1 Control Register 2 (PL1CTRL2)
   -- 33.2.47 Host L1 Control Register 1 (HL1CTRL1)
   -- 33.2.48 Host L1 Control Register 2 (HL1CTRL2)
   -- 33.2.49 Deep Software Standby USB Transceiver Control/Pin Monitor Register (DPUSR0R)
   -- 33.2.50 Deep Software Standby USB Suspend/Resume Interrupt Register (DPUSR1R)
   -- 33.2.51 Deep Software Standby USB Suspend/Resume Interrupt Register (DPUSR2R)
   -- 33.2.52 Deep Software Standby USB Suspend/Resume Command Register (DPUSRCR)

   ----------------------------------------------------------------------------
   -- 34. Serial Communications Interface (SCI)
   ----------------------------------------------------------------------------

   type SCI_Mode is (NORMAL, FIFO, SMIF);

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

   -- 34.2.2 Receive Data Register (RDR)

   type RDR_Type is record
      DATA : Unsigned_8; -- data
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RDR_Type use record
      DATA at 0 range 0 .. 7;
   end record;

   -- 34.2.4 Receive FIFO Data Register H, L, HL (FRDRH, FRDRL, FRDRHL)

   MPB_DATA : constant := 0;
   MPB_ID   : constant := 1;

   type FRDRHL_Type is record
      RDAT     : Bits_9  := 0;        -- Serial Receive Data
      MPB      : Bits_1  := MPB_DATA; -- Multi-Processor Bit Flag
      DR       : Boolean := False;    -- Receive Data Ready Flag
      PER      : Boolean := False;    -- Parity Error Flag
      FER      : Boolean := False;    -- Framing Error Flag
      ORER     : Boolean := False;    -- Overrun Error Flag
      RDF      : Boolean := False;    -- Receive FIFO Data Full Flag
      Reserved : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for FRDRHL_Type use record
      RDAT     at 0 range  0 ..  8;
      MPB      at 0 range  9 ..  9;
      DR       at 0 range 10 .. 10;
      PER      at 0 range 11 .. 11;
      FER      at 0 range 12 .. 12;
      ORER     at 0 range 13 .. 13;
      RDF      at 0 range 14 .. 14;
      Reserved at 0 range 15 .. 15;
   end record;

   -- 34.2.5 Transmit Data Register (TDR)

   type TDR_Type is record
      DATA : Unsigned_8; -- data
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TDR_Type use record
      DATA at 0 range 0 .. 7;
   end record;

   -- 34.2.7 Transmit FIFO Data Register H, L, HL (FTDRH, FTDRL, FTDRHL)

   MPBT_DATA : constant := 0;
   MPBT_ID   : constant := 1;

   type FTDRHL_Type is record
      TDAT     : Bits_9 := 16#1FF#;   -- Serial Transmit Data
      MPBT     : Bits_1 := MPBT_ID;   -- Multi-Processor Transfer Bit Flag
      Reserved : Bits_6 := 2#111111#;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for FTDRHL_Type use record
      TDAT     at 0 range  0 ..  8;
      MPBT     at 0 range  9 ..  9;
      Reserved at 0 range 10 .. 15;
   end record;

   -- 34.2.9 Serial Mode Register (SMR) for Non-Smart Card Interface Mode (SCMR.SMIF = 0)
   -- 34.2.10 Serial Mode Register for Smart Card Interface Mode (SMR_SMCI) (SCMR.SMIF = 1)

   CKS_PCLKA_DIV1  : constant := 2#00#; -- PCLKA clock (n = 0)
   CKS_PCLKA_DIV4  : constant := 2#01#; -- PCLKA/4 clock (n = 1)
   CKS_PCLKA_DIV16 : constant := 2#10#; -- PCLKA/16 clock (n = 2)
   CKS_PCLKA_DIV64 : constant := 2#11#; -- PCLKA/64 clock (n = 3)

   STOP_1 : constant := 0; -- 1 stop bit
   STOP_2 : constant := 1; -- 2 stop bit

   PM_EVEN : constant := 0; -- even parity
   PM_ODD  : constant := 1; -- odd parity

   CM_ASYNC : constant := 0; -- Asynchronous mode or simple IIC mode
   CM_SYNC  : constant := 1; -- Clock synchronous mode or simple SPI mode

   type SMR_NORMAL_Type is record
      CKS  : Bits_2  := CKS_PCLKA_DIV1; -- Clock Select
      MP   : Boolean := False;          -- Multi-Processor Mode
      STOP : Bits_1  := STOP_1;         -- Stop Bit Length
      PM   : Bits_1  := PM_EVEN;        -- Parity Mode
      PE   : Boolean := False;          -- Parity Enable
      CHR  : Bits_1  := CHR_8.CHR;      -- Character Length
      CM   : Bits_1  := CM_ASYNC;       -- Communication Mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      CKS   : Bits_2  := CKS_PCLKA_DIV1; -- Clock Select
      BCP10 : Bits_2  := BCP_32.BCP10;   -- Base Clock Pulse
      PM    : Bits_1  := PM_EVEN;        -- Parity Mode
      PE    : Boolean := False;          -- Parity Enable
      BLK   : Boolean := False;          -- Block Transfer Mode
      GM    : Boolean := False;          -- GSM Mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SMR_SMIF_Type use record
      CKS   at 0 range 0 .. 1;
      BCP10 at 0 range 2 .. 3;
      PM    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      BLK   at 0 range 6 .. 6;
      GM    at 0 range 7 .. 7;
   end record;

   type SMR_Type (S : SCI_Mode := NORMAL) is record
      case S is
         when NORMAL | FIFO => NORMAL : SMR_NORMAL_Type;
         when SMIF          => SMIF   : SMR_SMIF_Type;
      end case;
   end record
      with Pack            => True,
           Unchecked_Union => True;

   -- 34.2.11 Serial Control Register (SCR) for Non-Smart Card Interface Mode (SCMR.SMIF = 0)
   -- 34.2.12 Serial Control Register for Smart Card Interface Mode (SCR_SMCI) (SCMR.SMIF = 1)

   -- Asynchronous mode:
   CKE_ASYNC_ONCHIP_SCK_IO  : constant := 2#00#; -- On-chip baud rate generator The SCKn pin is available for use as an I/O port based on the I/O port settings
   CKE_ASYNC_ONCHIP_SCK_CLK : constant := 2#01#; -- On-chip baud rate generator A clock with the same frequency as the bit rate is output from the SCKn pin
   CKE_ASYNC_EXT_BRG        : constant := 2#10#; -- External clock
   CKE_ASYNC_EXT_BRG_2      : constant := 2#11#; -- ''
   -- Clock synchronous mode:
   CKE_SYNC_INT_CLK         : constant := 2#00#; -- Internal clock
   CKE_SYNC_INT_CLK_2       : constant := 2#01#; -- ''
   CKE_SYNC_EXT_CLK         : constant := 2#10#; -- External clock.
   CKE_SYNC_EXT_CLK_2       : constant := 2#11#; -- ''

   -- When SMR_SMCI.GM = 0:
   CKE_DisableOutput : constant := 2#00#; -- Disable output
   CKE_OutputClock   : constant := 2#01#; -- Output clock
   CKE_RSVD1         : constant := 2#10#; -- Setting prohibited.
   CKE_RSVD2         : constant := 2#11#; -- ''
   -- When SMR_SMCI.GM = 1:
   CKE_FIXLOW        : constant := 2#00#; -- Fix output low
   CKE_OUTCLK        : constant := 2#01#; -- Output clock
   CKE_OUTCLK_2      : constant := 2#11#; -- ''
   CKE_OUTHIGH       : constant := 2#10#; -- Fix output high.

   type SCR_Type is record
      CKE  : Bits_2  := CKE_ASYNC_ONCHIP_SCK_IO; -- Clock Enable
      TEIE : Boolean := False;                   -- Transmit End Interrupt Enable
      MPIE : Boolean := False;                   -- Multi-Processor Interrupt Enable
      RE   : Boolean := False;                   -- Receive Enable
      TE   : Boolean := False;                   -- Transmit Enable
      RIE  : Boolean := False;                   -- Receive Interrupt Enable
      TIE  : Boolean := False;                   -- Transmit Interrupt Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   -- MPBT_* already defined at 34.2.7

   -- MPB_* already defined at 34.2.4

   type SSR_NORMAL_Type is
   record
      MPBT : Bits_1  := MPBT_DATA; -- Multi-Processor Bit Transfer
      MPB  : Bits_1  := MPB_DATA;  -- Multi-Processor
      TEND : Boolean := True;      -- Transmit End Flag
      PER  : Boolean := False;     -- Parity Error Flag
      FER  : Boolean := False;     -- Framing Error Flag
      ORER : Boolean := False;     -- Overrun Error Flag
      RDRF : Boolean := False;     -- Receive Data Full Flag
      TDRE : Boolean := True;      -- Transmit Data Empty Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      DR       : Boolean := False; -- Receive Data Ready Flag
      Reserved : Bits_1  := 1;
      TEND     : Boolean := False; -- Transmit End Flag
      PER      : Boolean := False; -- Parity Error Flag
      FER      : Boolean := False; -- Framing Error Flag
      ORER     : Boolean := False; -- Overrun Error Flag
      RDF      : Boolean := False; -- Receive FIFO Data Full Flag
      TDFE     : Boolean := True;  -- Transmit FIFO Data Empty Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      MPBT : Bits_1  := MPBT_DATA; -- Multi-Processor Bit Transfer
      MPB  : Bits_1  := MPB_DATA;  -- Multi-Processor
      TEND : Boolean := True;      -- Transmit End Flag
      PER  : Boolean := False;     -- Parity Error Flag
      ERS  : Boolean := False;     -- Error Signal Status Flag
      ORER : Boolean := False;     -- Overrun Error Flag
      RDRF : Boolean := False;     -- Receive Data Full Flag
      TDRE : Boolean := True;      -- Transmit Data Empty Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   type SSR_Type (S : SCI_Mode := NORMAL) is record
      case S is
         when NORMAL => NORMAL : SSR_NORMAL_Type;
         when FIFO   => FIFO   : SSR_FIFO_Type;
         when SMIF   => SMIF   : SSR_SMIF_Type;
      end case;
   end record
      with Pack            => True,
           Unchecked_Union => True;

   -- 34.2.16 Smart Card Mode Register (SCMR)

   SINV_NO  : constant := 0; -- TDR register contents are transmitted as they are.
   SINV_YES : constant := 1; -- TDR register contents are inverted before transmission.

   SDIR_LSB : constant := 0; -- Transfer LSB-first
   SDIR_MSB : constant := 1; -- Transfer MSB-first.

   type SCMR_Type is record
      SMIF      : Boolean := False;       -- Smart Card Interface Mode Select
      Reserved1 : Bits_1  := 1;
      SINV      : Bits_1  := SINV_NO;     -- Transmitted/Received Data Invert
      SDIR      : Bits_1  := SDIR_LSB;    -- Transmitted/Received Data Transfer Direction
      CHR1      : Bits_1  := CHR_8.CHR1;  -- Character Length 1
      Reserved2 : Bits_2  := 2#11#;
      BCP2      : Bits_1  := BCP_32.BCP2; -- Base Clock Pulse 2
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SCMR_Type use record
      SMIF      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      SINV      at 0 range 2 .. 2;
      SDIR      at 0 range 3 .. 3;
      CHR1      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 6;
      BCP2      at 0 range 7 .. 7;
   end record;

   -- 34.2.17 Bit Rate Register (BRR)

   type BRR_Type is record
      BITRATE : Unsigned_8 := 16#FF#; -- bit rate
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for BRR_Type use record
      BITRATE at 0 range 0 .. 7;
   end record;

   -- 34.2.18 Modulation Duty Register (MDDR)

   type MDDR_Type is record
      BITRATE : Unsigned_8 := 16#FF#; -- bit rate adjusted
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for MDDR_Type use record
      BITRATE at 0 range 0 .. 7;
   end record;

   -- 34.2.19 Serial Extended Mode Register (SEMR)

   type SEMR_Type is record
      Reserved : Bits_2  := 0;
      BRME     : Boolean := False; -- Bit Rate Modulation Enable
      ABCSE    : Boolean := False; -- Asynchronous Mode Extended Base Clock Select 1
      ABCS     : Boolean := False; -- Asynchronous Mode Base Clock Select
      NFEN     : Boolean := False; -- Digital Noise Filter Function Enable
      BGDM     : Boolean := False; -- Baud Rate Generator Double-Speed Mode Select
      RXDESEL  : Boolean := False; -- Asynchronous Start Bit Edge Detection Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      NFCS     : Bits_3 := NFCS_ASYNC_1; -- Noise Filter Clock Select
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SNFR_Type use record
      NFCS     at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 34.2.21 IIC Mode Register 1 (SIMR1)

   type SIMR1_Type is record
      IICM     : Boolean := False; -- Simple IIC Mode Select
      Reserved : Bits_2  := 0;
      IICDL    : Bits_5  := 0;     -- SDA Delay Output Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SIMR1_Type use record
      IICM     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 2;
      IICDL    at 0 range 3 .. 7;
   end record;

   -- 34.2.22 IIC Mode Register 2 (SIMR2)

   IICINTM_ACKNACK : constant := 0; -- Use ACK/NACK interrupts
   IICINTM_RXTX    : constant := 1; -- Use reception and transmission interrupts.

   IICACKT_ACK  : constant := 0; -- ACK transmission
   IICACKT_NACK : constant := 1; -- NACK transmission and ACK/NACK reception.

   type SIMR2_Type is record
      IICINTM   : Bits_1  := IICINTM_ACKNACK; -- IIC Interrupt Mode Select
      IICCSC    : Boolean := False;           -- Clock Synchronization
      Reserved1 : Bits_3  := 0;
      IICACKT   : Bits_1  := IICACKT_ACK;     -- ACK Transmission Data
      Reserved2 : Bits_2  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SIMR2_Type use record
      IICINTM   at 0 range 0 .. 0;
      IICCSC    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      IICACKT   at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   -- 34.2.23 IIC Mode Register 3 (SIMR3)

   IICSDAS_OUTSER : constant := 2#00#; -- Output serial data
   IICSDAS_GEN    : constant := 2#01#; -- Generate start, restart, or stop condition
   IICSDAS_SDALOW : constant := 2#10#; -- Output low on SDAn pin
   IICSDAS_SDAHIZ : constant := 2#11#; -- Drive SDAn pin to high-impedance state.

   IICSCLS_OUTSER : constant := 2#00#; -- Output serial clock
   IICSCLS_GEN    : constant := 2#01#; -- Generate start, restart, or stop condition
   IICSCLS_SDALOW : constant := 2#10#; -- Output low on SCLn pin
   IICSCLS_SDAHIZ : constant := 2#11#; -- Drive SCLn pin to high-impedance state.

   type SIMR3_Type is record
      IICSTAREQ  : Boolean := False;          -- Start Condition Generation
      IICRSTAREQ : Boolean := False;          -- Restart Condition Generation
      IICSTPREQ  : Boolean := False;          -- Stop Condition Generation
      IICSTIF    : Boolean := False;          -- Issuing of Start, Restart, or Stop Condition Completed Flag
      IICSDAS    : Bits_2  := IICSDAS_OUTSER; -- SDA Output Select
      IICSCLS    : Bits_2  := IICSCLS_OUTSER; -- SCL Output Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      IICACKR  : Boolean; -- ACK Reception Data Flag
      Reserved : Bits_7;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SISR_Type use record
      IICACKR  at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- 34.2.25 SPI Mode Register (SPMR)

   MSS_MASTER : constant := 0; -- Transmit through TXDn pin and receive through RXDn pin (master mode)
   MSS_SLAVE  : constant := 1; -- Receive through TXDn pin and transmit through RXDn pin (slave mode).

   CKPOL_NORMAL : constant := 0; -- Do not invert clock polarity
   CKPOL_INVERT : constant := 1; -- Invert clock polarity.

   CKPH_NORMAL : constant := 0; -- Do not delay clock
   CKPH_DELAY  : constant := 1; -- Delay clock.

   type SPMR_Type is record
      SSE       : Boolean := False;        -- SSn Pin Function Enable
      CTSE      : Boolean := False;        -- CTS Enable
      MSS       : Bits_1  := MSS_MASTER;   -- Master Slave Select
      Reserved1 : Bits_1  := 0;
      MFF       : Boolean := False;        -- Mode Fault Flag
      Reserved2 : Bits_1  := 0;
      CKPOL     : Bits_1  := CKPOL_NORMAL; -- Clock Polarity Select
      CKPH      : Bits_1  := CKPH_NORMAL;  -- Clock Phase Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      FM    : Boolean := False; -- FIFO Mode Select
      RFRST : Boolean := False; -- Receive FIFO Data Register Reset
      TFRST : Boolean := False; -- Transmit FIFO Data Register Reset
      DRES  : Boolean := False; -- Receive Data Ready Error Select Bit
      TTRG  : Bits_4  := 0;     -- Transmit FIFO Data Trigger Number
      RTRG  : Bits_4  := 8;     -- Receive FIFO Data Trigger Number
      RSTRG : Bits_4  := 15;    -- RTS Output Active Trigger Number Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      R         : Bits_5; -- Receive FIFO Data Count
      Reserved1 : Bits_3;
      T         : Bits_5; -- Transmit FIFO Data Count
      Reserved2 : Bits_3;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for FDR_Type use record
      R         at 0 range  0 ..  4;
      Reserved1 at 0 range  5 ..  7;
      T         at 0 range  8 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 34.2.28 Line Status Register (LSR)

   type LSR_Type is record
      ORER      : Boolean; -- Overrun Error Flag
      Reserved1 : Bits_1;
      FNUM      : Bits_5;  -- Framing Error Count
      Reserved2 : Bits_1;
      PNUM      : Bits_5;  -- Parity Error Count
      Reserved3 : Bits_3;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
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
      CMPD     : Bits_9 := 0; -- Compare Match Data
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for CDR_Type use record
      CMPD     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 15;
   end record;

   -- 34.2.30 Data Compare Match Control Register (DCCR)

   IDSEL_ALWAYS  : constant := 0;
   IDSEL_IDFRAME : constant := 1;

   type DCCR_Type is record
      DCMF      : Boolean := False;         -- Data Compare Match Flag
      Reserved1 : Bits_2  := 0;
      DPER      : Boolean := False;         -- Data Compare Match Parity Error Flag
      DFER      : Boolean := False;         -- Data Compare Match Framing Error Flag
      Reserved2 : Bits_1  := 0;
      IDSEL     : Bits_1  := IDSEL_IDFRAME; -- ID Frame Select
      DCME      : Boolean := False;         -- Data Compare Match Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      RXDMON   : Boolean := True;  -- Serial Input Data Monitor
      SPB2DT   : Boolean := True;  -- Serial Port Break Data Select
      SPB2IO   : Boolean := False; -- Serial Port Break I/O
      Reserved : Bits_5  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SPTR_Type use record
      RXDMON   at 0 range 0 .. 0;
      SPB2DT   at 0 range 1 .. 1;
      SPB2IO   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- SCI0 .. SCI9 memory-mapped array

   type SCI_Type is record
      SMR      : SMR_Type    with Volatile_Full_Access => True;
      BRR      : BRR_Type    with Volatile_Full_Access => True;
      SCR      : SCR_Type    with Volatile_Full_Access => True;
      TDR      : TDR_Type    with Volatile_Full_Access => True;
      SSR      : SSR_Type    with Volatile_Full_Access => True;
      RDR      : RDR_Type    with Volatile_Full_Access => True;
      SCMR     : SCMR_Type   with Volatile_Full_Access => True;
      SEMR     : SEMR_Type   with Volatile_Full_Access => True;
      SNFR     : SNFR_Type   with Volatile_Full_Access => True;
      SIMR1    : SIMR1_Type  with Volatile_Full_Access => True;
      SIMR2    : SIMR2_Type  with Volatile_Full_Access => True;
      SIMR3    : SIMR3_Type  with Volatile_Full_Access => True;
      SISR     : SISR_Type   with Volatile_Full_Access => True;
      SPMR     : SPMR_Type   with Volatile_Full_Access => True;
      TDRHL    : FTDRHL_Type with Volatile_Full_Access => True;
      RDRHL    : FRDRHL_Type with Volatile_Full_Access => True;
      MDDR     : MDDR_Type   with Volatile_Full_Access => True;
      DCCR     : DCCR_Type   with Volatile_Full_Access => True;
      FCR      : FCR_Type    with Volatile_Full_Access => True;
      FDR      : FDR_Type    with Volatile_Full_Access => True;
      LSR      : LSR_Type    with Volatile_Full_Access => True;
      CDR      : CDR_Type    with Volatile_Full_Access => True;
      SPTR     : SPTR_Type   with Volatile_Full_Access => True;
      Reserved : Bits_24;
   end record
      with Object_Size             => 16#20# * 8,
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
   -- 35. IrDA Interface
   ----------------------------------------------------------------------------

   -- 35.2.1 IrDA Control Register (IRCR)

   type IRCR_Type is record
      Reserved1 : Bits_2  := 0;
      IRRXINV   : Boolean := False; -- IRRXD Polarity Switching
      IRTXINV   : Boolean := False; -- IRTXD Polarity Switching
      Reserved2 : Bits_3  := 0;
      IRE       : Boolean := False; -- IrDA Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for IRCR_Type use record
      Reserved1 at 0 range 0 .. 1;
      IRRXINV   at 0 range 2 .. 2;
      IRTXINV   at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 6;
      IRE       at 0 range 7 .. 7;
   end record;

   IRCR_ADDRESS : constant := 16#4007_0F00#;

   IRCR : aliased IRCR_Type
      with Address              => System'To_Address (IRCR_ADDRESS),
           Volatile_Full_Access => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 36. I2C Bus Interface (IIC)
   ----------------------------------------------------------------------------

   -- 36.2.1 I2C Bus Control Register 1 (ICCR1)

   type ICCR1_Type is record
      SDAI   : Boolean := True;  -- SDA Line Monitor
      SCLI   : Boolean := True;  -- SCL Line Monitor
      SDAO   : Boolean := True;  -- SDA Output Control/Monitor
      SCLO   : Boolean := True;  -- SCL Output Control/Monitor
      SOWP   : Boolean := True;  -- SCLO/SDAO Write Protect
      CLO    : Boolean := False; -- Extra SCL Clock Cycle Output
      IICRST : Boolean := False; -- IIC-Bus Interface Internal Reset
      ICE    : Boolean := False; -- IIC-Bus Interface Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   TRS_RX : constant := 0; -- Receive mode
   TRS_TX : constant := 1; -- Transmit mode.

   MST_SLAVE  : constant := 0; -- Slave mode
   MST_MASTER : constant := 1; -- Master mode.

   type ICCR2_Type is record
      Reserved1 : Bits_1  := 0;
      ST        : Boolean := False;     -- Start Condition Issuance Request
      RS        : Boolean := False;     -- Restart Condition Issuance Request
      SP        : Boolean := False;     -- Stop Condition Issuance Request
      Reserved2 : Bits_1  := 0;
      TRS       : Bits_1  := TRS_RX;    -- Transmit/Receive Mode
      MST       : Bits_1  := MST_SLAVE; -- Master/Slave Mode
      BBSY      : Boolean := False;     -- Bus Busy Detection Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   BC_9 : constant := 2#000#; -- 9 bits
   BC_2 : constant := 2#001#; -- 2 bits
   BC_3 : constant := 2#010#; -- 3 bits
   BC_4 : constant := 2#011#; -- 4 bits
   BC_5 : constant := 2#100#; -- 5 bits
   BC_6 : constant := 2#101#; -- 6 bits
   BC_7 : constant := 2#110#; -- 7 bits
   BC_8 : constant := 2#111#; -- 8 bits.

   -- CKS_PCLKB_* already defined at 25.2.6

   type ICMR1_Type is record
      BC   : Bits_3  := BC_9;           -- Bit Counter
      BCWP : Boolean := True;           -- BC Write Protect
      CKS  : Bits_3  := CKS_PCLKB_DIV1; -- Internal Reference Clock Select
      MTWP : Boolean := False;          -- MST/TRS Write Protect
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICMR1_Type use record
      BC   at 0 range 0 .. 2;
      BCWP at 0 range 3 .. 3;
      CKS  at 0 range 4 .. 6;
      MTWP at 0 range 7 .. 7;
   end record;

   -- 36.2.4 I2C Bus Mode Register 2 (ICMR2)

   TMOS_LONG  : constant := 0; -- Select long mode
   TMOS_SHORT : constant := 1; -- Select short mode.

   -- When ICMR2.DLCS = 0 (IICphi)
   SDDL_0 : constant := 2#000#; -- No output delay
   SDDL_1 : constant := 2#001#; -- 1 IICphi cycle
   SDDL_2 : constant := 2#010#; -- 2 IICphi cycles
   SDDL_3 : constant := 2#011#; -- 3 IICphi cycles
   SDDL_4 : constant := 2#100#; -- 4 IICphi cycles
   SDDL_5 : constant := 2#101#; -- 5 IICphi cycles
   SDDL_6 : constant := 2#110#; -- 6 IICphi cycles
   SDDL_7 : constant := 2#111#; -- 7 IICphi cycles.
   -- When ICMR2.DLCS = 1 (IICphi/2)
   -- SDDL_0    : constant := 2#000#; -- No output delay
   SDDL_12   : constant := 2#001#; -- 1 or 2 IICphi cycles
   SDDL_34   : constant := 2#010#; -- 3 or 4 IICphi cycles
   SDDL_56   : constant := 2#011#; -- 5 or 6 IICphi cycles
   SDDL_78   : constant := 2#100#; -- 7 or 8 IICphi cycles
   SDDL_910  : constant := 2#101#; -- 9 or 10 IICphi cycles
   SDDL_1112 : constant := 2#110#; -- 11 or 12 IICphi cycles
   SDDL_1314 : constant := 2#111#; -- 13 or 14 IICphi cycles.

   DLCS_DIV1 : constant := 0; -- Select internal reference clock (IICphi) as clock source for SDA output delay counter
   DLCS_DIV2 : constant := 1; -- Select internal reference clock divided by 2 (IICphi/2) as clock source for SDA output delay counter.

   type ICMR2_Type is record
      TMOS     : Bits_1  := TMOS_LONG; -- Timeout Detection Time Select
      TMOL     : Boolean := True;      -- Timeout L Count Control
      TMOH     : Boolean := True;      -- Timeout H Count Control
      Reserved : Bits_1  := 0;
      SDDL     : Bits_3  := SDDL_0;    -- SDA Output Delay Counter
      DLCS     : Bits_1  := DLCS_DIV1; -- SDA Output Delay Clock Source Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   RDRFS_9TH : constant := 0; -- Set the RDRF flag on the rising edge of the ninth SCL clock cycle (no low-hold on the SCLn line on the falling edge of the eighth clock cycle)
   RDRFS_8TH : constant := 1; -- Set the RDRF flag on the rising edge of the eighth SCL clock cycle (low-hold on the SCLn line low on the falling edge of the eighth clock cycle).

   SMBS_I2C   : constant := 0; -- Select I2C bus
   SMBS_SMBus : constant := 1; -- Select SMBus.

   type ICMR3_Type is record
      NF    : Bits_2  := NF_1;      -- Noise Filter Stage Select
      ACKBR : Boolean := False;     -- Receive Acknowledge
      ACKBT : Boolean := False;     -- Transmit Acknowledge
      ACKWP : Boolean := False;     -- ACKBT Write Protect
      RDRFS : Bits_1  := RDRFS_9TH; -- RDRF Flag Set Timing Select
      WAIT  : Boolean := False;     -- WAIT
      SMBS  : Bits_1  := SMBS_I2C;  -- SMBus/IIC-Bus Select
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      TMOE  : Boolean := False; -- Timeout Function Enable
      MALE  : Boolean := True;  -- Master Arbitration-Lost Detection Enable
      NALE  : Boolean := False; -- NACK Transmission Arbitration-Lost Detection Enable
      SALE  : Boolean := False; -- Slave Arbitration-Lost Detection Enable
      NACKE : Boolean := True;  -- NACK Reception Transfer Suspension Enable
      NFE   : Boolean := True;  -- Digital Noise Filter Circuit Enable
      SCLE  : Boolean := True;  -- SCL Synchronous Circuit Enable
      FMPE  : Boolean := False; -- Fast-Mode Plus Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      SAR0E     : Boolean := True;  -- Slave Address Register 0 Enable
      SAR1E     : Boolean := False; -- Slave Address Register 1 Enable
      SAR2E     : Boolean := False; -- Slave Address Register 2 Enable
      GCAE      : Boolean := True;  -- General Call Address Enable
      Reserved1 : Bits_1  := 0;
      DIDE      : Boolean := False; -- Device-ID Address Detection Enable
      Reserved2 : Bits_1  := 0;
      HOAE      : Boolean := False; -- Host Address Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      TMOIE  : Boolean := False; -- Timeout Interrupt Request Enable
      ALIE   : Boolean := False; -- Arbitration-Lost Interrupt Request Enable
      STIE   : Boolean := False; -- Start Condition Detection Interrupt Request Enable
      SPIE   : Boolean := False; -- Stop Condition Detection Interrupt Request Enable
      NACKIE : Boolean := False; -- NACK Reception Interrupt Request Enable
      RIE    : Boolean := False; -- Receive Data Full Interrupt Request Enable
      TEIE   : Boolean := False; -- Transmit End Interrupt Request Enable
      TIE    : Boolean := False; -- Transmit Data Empty Interrupt Request Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      AAS0      : Boolean := False; -- Slave Address 0 Detection Flag
      AAS1      : Boolean := False; -- Slave Address 1 Detection Flag
      AAS2      : Boolean := False; -- Slave Address 2 Detection Flag
      GCA       : Boolean := False; -- General Call Address Detection Flag
      Reserved1 : Bits_1  := 0;
      DID       : Boolean := False; -- Device-ID Address Detection Flag
      Reserved2 : Bits_1  := 0;
      HOA       : Boolean := False; -- Host Address Detection Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      TMOF  : Boolean := False; -- Timeout Detection Flag
      AL    : Boolean := False; -- Arbitration-Lost Flag
      START : Boolean := False; -- Start Condition Detection Flag
      STOP  : Boolean := False; -- Stop Condition Detection Flag
      NACKF : Boolean := False; -- NACK Detection Flag
      RDRF  : Boolean := False; -- Receive Data Full Flag
      TEND  : Boolean := False; -- Transmit End Flag
      TDRE  : Boolean := False; -- Transmit Data Empty Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      WUAFA    : Boolean := False; -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_3  := 0;
      WUACK    : Boolean := True;  -- ACK Bit for Wakeup Mode
      WUF      : Boolean := False; -- Wakeup Event Occurrence Flag
      WUIE     : Boolean := False; -- Wakeup Interrupt Request Enable
      WUE      : Boolean := False; -- Wakeup Function Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      WUSEN    : Boolean := True;   -- Wakeup Analog Filter Additional Selection
      WUASYF   : Boolean := False;  -- Wakeup Analog Filter Additional Selection
      WUSYF    : Boolean := True;   -- Wakeup Analog Filter Additional Selection
      Reserved : Bits_5  := 16#1F#;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICWUR2_Type use record
      WUSEN    at 0 range 0 .. 0;
      WUASYF   at 0 range 1 .. 1;
      WUSYF    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 36.2.13 Slave Address Register L y (SARLy) (y = 0 to 2)

   type SARLy_Type is record
      SVA0 : Bits_1 := 0; -- 10-Bit Address LSB
      SVA  : Bits_7 := 0; -- 7-Bit Address/10-Bit Address Lower Bits
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SARLy_Type use record
      SVA0 at 0 range 0 .. 0;
      SVA  at 0 range 1 .. 7;
   end record;

   -- 36.2.14 Slave Address Register U y (SARUy) (y = 0 to 2)

   FS_7  : constant := 0; -- Select 7-bit address format
   FS_10 : constant := 1; -- Select 10-bit address format.

   type SARUy_Type is record
      FS       : Bits_1 := FS_7; -- 7-Bit/10-Bit Address Format Select
      SVA      : Bits_2 := 0;    -- 10-Bit Address Upper Bits
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SARUy_Type use record
      FS       at 0 range 0 .. 0;
      SVA      at 0 range 1 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- Array types for SAR? registers

   type SARLU_Type is record
      SARL : SARLy_Type with Volatile_Full_Access => True;
      SARU : SARUy_Type with Volatile_Full_Access => True;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for SARLU_Type use record
      SARL at 0 range 0 .. 7;
      SARU at 1 range 0 .. 7;
   end record;

   type SAR_Array_Type is array (0 .. 2) of SARLU_Type
      with Pack => True;

   -- 36.2.15 I2C Bus Bit Rate Low-Level Register (ICBRL)

   type ICBRL_Type is record
      BRL      : Bits_5 := 2#11111#; -- Low-level period of SCL clock.
      Reserved : Bits_3 := 2#111#;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICBRL_Type use record
      BRL      at 0 range 0 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 36.2.16 I2C Bus Bit Rate High-Level Register (ICBRH)

   type ICBRH_Type is record
      BRH      : Bits_5 := 2#11111#; -- High-level period of SCL clock.
      Reserved : Bits_3 := 2#111#;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICBRH_Type use record
      BRH      at 0 range 0 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   -- 36.2.17 I2C Bus Transmit Data Register (ICDRT)

   type ICDRT_Type is record
      DATA : Unsigned_8; -- data
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICDRT_Type use record
      DATA at 0 range 0 .. 7;
   end record;

   -- 36.2.18 I2C Bus Receive Data Register (ICDRR)

   type ICDRR_Type is record
      DATA : Unsigned_8; -- data
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICDRR_Type use record
      DATA at 0 range 0 .. 7;
   end record;

   -- 36.2.19 I2C Bus Shift Register (ICDRS)

   type ICDRS_Type is record
      DATA : Unsigned_8; -- Data
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for ICDRS_Type use record
      DATA at 0 range 0 .. 7;
   end record;

   -- I2C

pragma Warnings (Off);
   type I2C_Type is record
      ICCR1  : ICCR1_Type     with Volatile_Full_Access => True;
      ICCR2  : ICCR2_Type     with Volatile_Full_Access => True;
      ICMR1  : ICMR1_Type     with Volatile_Full_Access => True;
      ICMR2  : ICMR2_Type     with Volatile_Full_Access => True;
      ICMR3  : ICMR3_Type     with Volatile_Full_Access => True;
      ICFER  : ICFER_Type     with Volatile_Full_Access => True;
      ICSER  : ICSER_Type     with Volatile_Full_Access => True;
      ICIER  : ICIER_Type     with Volatile_Full_Access => True;
      ICSR1  : ICSR1_Type     with Volatile_Full_Access => True;
      ICSR2  : ICSR2_Type     with Volatile_Full_Access => True;
      ICWUR  : ICWUR_Type     with Volatile_Full_Access => True;
      ICWUR2 : ICWUR2_Type    with Volatile_Full_Access => True;
      SAR    : SAR_Array_Type;
      ICBRL  : ICBRL_Type     with Volatile_Full_Access => True;
      ICBRH  : ICBRH_Type     with Volatile_Full_Access => True;
      ICDRT  : ICDRT_Type     with Volatile_Full_Access => True;
      ICDRR  : ICDRR_Type     with Volatile_Full_Access => True;
      ICDRS  : ICDRS_Type     with Volatile_Full_Access => True;
   end record
      with Object_Size             => 16#100# * 8,
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
      SAR    at 16#0A# range 0 .. 3 * 16 - 1;
      ICBRL  at 16#10# range 0 .. 7;
      ICBRH  at 16#11# range 0 .. 7;
      ICDRT  at 16#12# range 0 .. 7;
      ICDRR  at 16#13# range 0 .. 7;
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
   -- 37. Controller Area Network (CAN) Module
   ----------------------------------------------------------------------------

   -- 37.2.1 Control Register (CTLR)
   -- 37.2.2 Bit Configuration Register (BCR)
   -- 37.2.3 Mask Register k (MKRk) (k = 0 to 7)
   -- 37.2.4 FIFO Received ID Compare Registers 0 and 1 (FIDCR0 and FIDCR1)
   -- 37.2.5 Mask Invalid Register (MKIVLR)
   -- 37.2.6 Mailbox Register j (MBj_ID, MBj_DL, MBj_Dm, MBj_TS) (j = 0 to 31; m = 0 to 7)
   -- 37.2.7 Mailbox Interrupt Enable Register (MIER)
   -- 37.2.8 Mailbox Interrupt Enable Register for FIFO Mailbox Mode (MIER_FIFO)
   -- 37.2.9 Message Control Register for Transmit (MCTL_TXj) (j = 0 to 31)
   -- 37.2.10 Message Control Register for Receive (MCTL_RXj) (j = 0 to 31)
   -- 37.2.11 Receive FIFO Control Register (RFCR)
   -- 37.2.12 Receive FIFO Pointer Control Register (RFPCR)
   -- 37.2.13 Transmit FIFO Control Register (TFCR)
   -- 37.2.14 Transmit FIFO Pointer Control Register (TFPCR)
   -- 37.2.15 Status Register (STR)
   -- 37.2.16 Mailbox Search Mode Register (MSMR)
   -- 37.2.17 Mailbox Search Status Register (MSSR)
   -- 37.2.18 Channel Search Support Register (CSSR)
   -- 37.2.19 Acceptance Filter Support Register (AFSR)
   -- 37.2.20 Error Interrupt Enable Register (EIER)
   -- 37.2.21 Error Interrupt Factor Judge Register (EIFR)
   -- 37.2.22 Receive Error Count Register (RECR)
   -- 37.2.23 Transmit Error Count Register (TECR)
   -- 37.2.24 Error Code Store Register (ECSR)
   -- 37.2.25 Time Stamp Register (TSR)
   -- 37.2.26 Test Control Register (TCR)

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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   SPLP2_NORMAL   renames SPLP_NORMAL;
   SPLP2_LOOPBACK renames SPLP_LOOPBACK;

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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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

   type SPDR_Width is (Bit8, Bit16, Bit32);

   type SPDR_Type (W : SPDR_Width := Bit8) is record
      case W is
         when Bit8  =>
            SPDR8   : Unsigned_8  with Volatile_Full_Access => True; -- SPDR/SPDR_HA is the interface with the buffers that hold data for transmission and reception by the SPI.
            Unused1 : Bits_24;
         when Bit16 =>
            SPDR16  : Unsigned_16 with Volatile_Full_Access => True; -- SPDR/SPDR_HA is the interface with the buffers that hold data for transmission and reception by the SPI.
            Unused2 : Bits_16;
         when Bit32 =>
            SPDR32  : Unsigned_32 with Volatile_Full_Access => True; -- SPDR/SPDR_HA is the interface with the buffers that hold data for transmission and reception by the SPI.
      end case;
   end record
      with Bit_Order       => Low_Order_First,
           Object_Size     => 32,
           Unchecked_Union => True;
   for SPDR_Type use record
      SPDR8   at 0 range 0 ..  7;
      Unused1 at 1 range 0 .. 23;
      SPDR16  at 0 range 0 .. 15;
      Unused2 at 2 range 0 .. 15;
      SPDR32  at 0 range 0 .. 31;
   end record;

   -- 38.2.6 SPI Sequence Control Register (SPSCR)

   SPSLN_1 : constant := 2#000#; -- 0-->0
   SPSLN_2 : constant := 2#001#; -- 0-->1-->0
   SPSLN_3 : constant := 2#010#; -- 0-->1-->2-->0
   SPSLN_4 : constant := 2#011#; -- 0-->...>3-->0
   SPSLN_5 : constant := 2#100#; -- 0-->...>4-->0
   SPSLN_6 : constant := 2#101#; -- 0-->...>5-->0
   SPSLN_7 : constant := 2#110#; -- 0-->...>6-->0
   SPSLN_8 : constant := 2#111#; -- 0-->...>7-->0

   type SPSCR_Type is record
      SPSLN    : Bits_3 := SPSLN_1; -- SPI Sequence Length Specification
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SPSCR_Type use record
      SPSLN    at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 38.2.7 SPI Sequence Status Register (SPSSR)

   SPCP_SPCMD0 : constant := 2#000#;
   SPCP_SPCMD1 : constant := 2#001#;
   SPCP_SPCMD2 : constant := 2#010#;
   SPCP_SPCMD3 : constant := 2#011#;
   SPCP_SPCMD4 : constant := 2#100#;
   SPCP_SPCMD5 : constant := 2#101#;
   SPCP_SPCMD6 : constant := 2#110#;
   SPCP_SPCMD7 : constant := 2#111#;

   SPECM_SPCMD0 renames SPCP_SPCMD0;
   SPECM_SPCMD1 renames SPCP_SPCMD1;
   SPECM_SPCMD2 renames SPCP_SPCMD2;
   SPECM_SPCMD3 renames SPCP_SPCMD3;
   SPECM_SPCMD4 renames SPCP_SPCMD4;
   SPECM_SPCMD5 renames SPCP_SPCMD5;
   SPECM_SPCMD6 renames SPCP_SPCMD6;
   SPECM_SPCMD7 renames SPCP_SPCMD7;

   type SPSSR_Type is record
      SPCP      : Bits_3 := SPCP_SPCMD0;  -- SPI Command Pointer
      Reserved1 : Bits_1 := 0;
      SPECM     : Bits_3 := SPECM_SPCMD0; -- SPI Error Command
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
           Object_Size          => 16,
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
      with Object_Size => 8 * 16;

   -- 38.2.15 SPI Data Control Register 2 (SPDCR2)

   type SPDCR2_Type is record
      BYSW     : Boolean := False; -- Byte Swap Operating Mode Select
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
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
      SPDR   : SPDR_Type        with Volatile => True;
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
      with Object_Size             => 16#100# * 8,
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMCMD_Type use record
      DCOM     at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- 39.2.7 Communication Status Register (SFMCST)

   type SFMCST_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMCST_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.8 Instruction Code Register (SFMSIC)

   type SFMSIC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMSIC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.9 Address Mode Control Register (SFMSAC)

   type SFMSAC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMSAC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.10 Dummy Cycle Control Register (SFMSDC)

   type SFMSDC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMSDC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.11 SPI Protocol Control Register (SFMSPC)

   type SFMSPC_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMSPC_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.12 Port Control Register (SFMPMD)

   type SFMPMD_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SFMPMD_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   -- 39.2.13 External QSPI Address Register (SFMCNT1)

   type SFMCNT1_Type is record
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
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
      with Object_Size             => 16#808# * 8,
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

   ----------------------------------------------------------------------------
   -- 40. Cyclic Redundancy Check (CRC) Calculator
   ----------------------------------------------------------------------------

   -- 40.2.1 CRC Control Register 0 (CRCCR0)
   -- 40.2.2 CRC Control Register 1 (CRCCR1)
   -- 40.2.3 CRC Data Input Register (CRCDIR/CRCDIR_BY)
   -- 40.2.4 CRC Data Output Register (CRCDOR/CRCDOR_HA/CRCDOR_BY)
   -- 40.2.5 Snoop Address Register (CRCSAR)

   ----------------------------------------------------------------------------
   -- 41. Serial Sound Interface Enhanced (SSIE)
   ----------------------------------------------------------------------------

   -- 41.4.1 Control Register (SSICR)
   -- 41.4.2 Status Register (SSISR)
   -- 41.4.3 FIFO Control Register (SSIFCR)
   -- 41.4.4 FIFO Status Register (SSIFSR)
   -- 41.4.5 Transmit FIFO Data Register (SSIFTDR)
   -- 41.4.6 Receive FIFO Data Register (SSIFRDR)
   -- 41.4.7 Audio Format Register (SSIOFR)
   -- 41.4.8 Status Control Register (SSISCR)

   ----------------------------------------------------------------------------
   -- 42. Sampling Rate Converter (SRC)
   ----------------------------------------------------------------------------

   -- 42.2.1 Input Data Register (SRCID)
   -- 42.2.2 Output Data Register (SRCOD)
   -- 42.2.3 Input Data Control Register (SRCIDCTRL)
   -- 42.2.4 Output Data Control Register (SRCODCTRL)
   -- 42.2.5 Control Register (SRCCTRL)
   -- 42.2.6 Status Register (SRCSTAT)
   -- 42.2.7 Filter Coefficient Table n (SRCFCTRn) (n = 0 to 5551)

   ----------------------------------------------------------------------------
   -- 43. SD/MMC Host Interface (SDHI)
   ----------------------------------------------------------------------------

   -- 43.2.1 Command Type Register (SD_CMD)
   -- 43.2.2 SD Command Argument Register (SD_ARG)
   -- 43.2.3 SD Command Argument Register 1 (SD_ARG1)
   -- 43.2.4 Data Stop Register (SD_STOP)
   -- 43.2.5 Block Count Register (SD_SECCNT)
   -- 43.2.6 SD Card Response Register 10 (SD_RSP10), SD Card Response Register 32 (SD_RSP32), SD Card Response Register 54 (SD_RSP54)
   -- 43.2.7 SD Card Response Register 1 (SD_RSP1), SD Card Response Register 3 (SD_RSP3), SD Card Response Register 5 (SD_RSP5)
   -- 43.2.8 SD Card Response Register 76 (SD_RSP76)
   -- 43.2.9 SD Card Response Register 7 (SD_RSP7)
   -- 43.2.10 SD Card Interrupt Flag Register 1 (SD_INFO1)
   -- 43.2.11 SD Card Interrupt Flag Register 2 (SD_INFO2)
   -- 43.2.12 SD INFO1 Interrupt Mask Register (SD_INFO1_MASK)
   -- 43.2.13 SD INFO2 Interrupt Mask Register (SD_INFO2_MASK)
   -- 43.2.14 SD Clock Control Register (SD_CLK_CTRL)
   -- 43.2.15 Transfer Data Length Register (SD_SIZE)
   -- 43.2.16 SD Card Access Control Option Register (SD_OPTION)
   -- 43.2.17 SD Error Status Register 1 (SD_ERR_STS1)
   -- 43.2.18 SD Error Status Register 2 (SD_ERR_STS2)
   -- 43.2.19 SD Buffer Register (SD_BUF0)
   -- 43.2.20 SDIO Mode Control Register (SDIO_MODE)
   -- 43.2.21 SDIO Interrupt Flag Register (SDIO_INFO1)
   -- 43.2.22 SDIO INFO1 Interrupt Mask Register (SDIO_INFO1_MASK)
   -- 43.2.23 DMA Mode Enable Register (SD_DMAEN)
   -- 43.2.24 Software Reset Register (SOFT_RST)
   -- 43.2.25 SD Interface Mode Setting Register (SDIF_MODE)
   -- 43.2.26 Swap Control Register (EXT_SWAP)

   ----------------------------------------------------------------------------
   -- 44. Parallel Data Capture Unit (PDC)
   ----------------------------------------------------------------------------

   -- 44.2.1 PDC Control Register 0 (PCCR0)
   -- 44.2.2 PDC Control Register 1 (PCCR1)
   -- 44.2.3 PDC Status Register (PCSR)
   -- 44.2.4 PDC Pin Monitor Register (PCMONR)
   -- 44.2.5 PDC Receive Data Register (PCDR)
   -- 44.2.6 Vertical Capture Register (VCR)
   -- 44.2.7 Horizontal Capture Register (HCR)

   ----------------------------------------------------------------------------
   -- 45. Boundary Scan
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 46. Secure Cryptographic Engine (SCE7)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 47. 12-Bit A/D Converter (ADC12)
   ----------------------------------------------------------------------------

   -- 47.2.1 A/D Data Registers y (ADDRy), A/D Data Duplexing Register (ADDBLDR), A/D Data Duplexing Register A (ADDBLDRA), A/D Data Duplexing Register B (ADDBLDRB), A/D Temperature Sensor Data Register (ADTSDR), A/D Internal Reference Voltage Data Register (ADOCDR)
   -- 47.2.2 A/D Self-Diagnosis Data Register (ADRD)
   -- 47.2.3 A/D Control Register (ADCSR)
   -- 47.2.4 A/D Channel Select Register A0 (ADANSA0)
   -- 47.2.5 A/D Channel Select Register A1 (ADANSA1)
   -- 47.2.6 A/D Channel Select Register B0 (ADANSB0)
   -- 47.2.7 A/D Channel Select Register B1 (ADANSB1)
   -- 47.2.8 A/D-Converted Value Addition/Average Channel Select Register 0 (ADADS0)
   -- 47.2.9 A/D-Converted Value Addition/Average Channel Select Register 1 (ADADS1)
   -- 47.2.10 A/D-Converted Value Addition/Average Count Select Register (ADADC)
   -- 47.2.11 A/D Control Extended Register (ADCER)
   -- 47.2.12 A/D Conversion Start Trigger Select Register (ADSTRGR)
   -- 47.2.13 A/D Conversion Extended Input Control Register (ADEXICR)
   -- 47.2.14 A/D Sampling State Register n (ADSSTRn) (n = 00 to 07, L, T, O)
   -- 47.2.15 A/D Sample and Hold Circuit Control Register (ADSHCR)
   -- 47.2.16 A/D Sample and Hold Operation Mode Selection Register (ADSHMSR)
   -- 47.2.17 A/D Disconnection Detection Control Register (ADDISCR)
   -- 47.2.18 A/D Group Scan Priority Control Register (ADGSPCR)
   -- 47.2.19 A/D Compare Function Control Register (ADCMPCR)
   -- 47.2.20 A/D Compare Function Window A Channel Select Register 0 (ADCMPANSR0)
   -- 47.2.21 A/D Compare Function Window A Channel Select Register 1 (ADCMPANSR1)
   -- 47.2.22 A/D Compare Function Window A Extended Input Select Register (ADCMPANSER)
   -- 47.2.23 A/D Compare Function Window A Comparison Condition Setting Register 0 (ADCMPLR0)
   -- 47.2.24 A/D Compare Function Window A Comparison Condition Setting Register 1 (ADCMPLR1)
   -- 47.2.25 A/D Compare Function Window A Extended Input Comparison Condition Setting Register (ADCMPLER)
   -- 47.2.26 A/D Compare Function Window A Lower-Side Level Setting Register (ADCMPDR0), A/D Compare Function Window A Upper-Side Level Setting Register (ADCMPDR1), A/D Compare Function Window B Lower-Side Level Setting Register (ADWINLLB), A/D Compare Function Window B Upper-Side Level Setting Register (ADWINULB)
   -- 47.2.27 A/D Compare Function Window A Channel Status Register 0 (ADCMPSR0)
   -- 47.2.28 A/D Compare Function Window A Channel Status Register1 (ADCMPSR1)
   -- 47.2.29 A/D Compare Function Window A Extended Input Channel Status Register (ADCMPSER)
   -- 47.2.30 A/D Compare Function Window B Channel Select Register (ADCMPBNSR)
   -- 47.2.31 A/D Compare Function Window B Status Register (ADCMPBSR)
   -- 47.2.32 A/D Compare Function Window A/B Status Monitor Register (ADWINMON)
   -- 47.2.33 A/D Programmable Gain Amplifier Control Register (ADPGACR)
   -- 47.2.34 A/D Programmable Gain Amplifier Gain Setting Register 0 (ADPGAGS0)
   -- 47.2.35 A/D Programmable Gain Amplifier Differential Input Control Register (ADPGADCR0)

   ----------------------------------------------------------------------------
   -- 48. 12-Bit D/A Converter (DAC12)
   ----------------------------------------------------------------------------

   -- 48.2.1 D/A Data Register m (DADRm) (m = 0, 1)
   -- 48.2.2 D/A Control Register (DACR)
   -- 48.2.3 DADRm Format Select Register (DADPR)
   -- 48.2.4 D/A A/D Synchronous Start Control Register (DAADSCR)
   -- 48.2.5 D/A Output Amplifier Control Register (DAAMPCR)
   -- 48.2.6 D/A Amplifier Stabilization Wait Control Register (DAASWCR)
   -- 48.2.7 D/A A/D Synchronous Unit Select Register (DAADUSR)

   ----------------------------------------------------------------------------
   -- 49. Temperature Sensor (TSN)
   ----------------------------------------------------------------------------

   -- 49.2.1 Temperature Sensor Control Register (TSCR)

   type TSCR_Type is record
      Reserved1 : Bits_4  := 0;
      TSOE      : Boolean := False; -- Temperature Sensor Output Enable
      Reserved2 : Bits_2  := 0;
      TSEN      : Boolean := False; -- Temperature Sensor Enable
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TSCR_Type use record
      Reserved1 at 0 range 0 .. 3;
      TSOE      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 6;
      TSEN      at 0 range 7 .. 7;
   end record;

   TSCR_ADDRESS : constant := 16#4005_D000#;

   TSCR : aliased TSCR_Type
      with Address              => System'To_Address (TSCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 49.2.2 Temperature Sensor Calibration Data Register(TSCDR)

   type TSCDR_Type is record
      DATA     : Bits_12; -- temperature sensor calibration data measured for each MCU at factory shipment.
      Reserved : Bits_20;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for TSCDR_Type use record
      DATA     at 0 range  0 .. 11;
      Reserved at 0 range 12 .. 31;
   end record;

   TSCDR_ADDRESS : constant := 16#407F_B17C#;

   TSCDR : aliased TSCDR_Type
      with Address              => System'To_Address (TSCDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 50. High-Speed Analog Comparator (ACMPHS)
   ----------------------------------------------------------------------------

   -- 50.2.1 Comparator Control Register (CMPCTL)
   -- 50.2.2 Comparator Input Select Register (CMPSEL0)
   -- 50.2.3 Comparator Reference Voltage Select Register (CMPSEL1)
   -- 50.2.4 Comparator Output Monitor Register (CMPMON)
   -- 50.2.5 Comparator Output Control Register (CPIOC)

   ----------------------------------------------------------------------------
   -- 51. Capacitive Touch Sensing Unit (CTSU)
   ----------------------------------------------------------------------------

   -- 51.2.1 CTSU Control Register 0 (CTSUCR0)
   -- 51.2.2 CTSU Control Register 1 (CTSUCR1)
   -- 51.2.3 CTSU Synchronous Noise Reduction Setting Register (CTSUSDPRS)
   -- 51.2.4 CTSU Sensor Stabilization Wait Control Register (CTSUSST)
   -- 51.2.5 CTSU Measurement Channel Register 0 (CTSUMCH0)
   -- 51.2.6 CTSU Measurement Channel Register 1 (CTSUMCH1)
   -- 51.2.7 CTSU Channel Enable Control Register 0 (CTSUCHAC0)
   -- 51.2.8 CTSU Channel Enable Control Register 1 (CTSUCHAC1)
   -- 51.2.9 CTSU Channel Enable Control Register 2 (CTSUCHAC2)
   -- 51.2.10 CTSU Channel Transmit/Receive Control Register 0 (CTSUCHTRC0)
   -- 51.2.11 CTSU Channel Transmit/Receive Control Register 1 (CTSUCHTRC1)
   -- 51.2.12 CTSU Channel Transmit/Receive Control Register 2 (CTSUCHTRC2)
   -- 51.2.13 CTSU High-Pass Noise Reduction Control Register (CTSUDCLKC)
   -- 51.2.14 CTSU Status Register (CTSUST)
   -- 51.2.15 CTSU High-Pass Noise Reduction Spectrum Diffusion Control Register (CTSUSSC)
   -- 51.2.16 CTSU Sensor Offset Register 0 (CTSUSO0)
   -- 51.2.17 CTSU Sensor Offset Register 1 (CTSUSO1)
   -- 51.2.18 CTSU Sensor Counter (CTSUSC)
   -- 51.2.19 CTSU Reference Counter (CTSURC)
   -- 51.2.20 CTSU Error Status Register (CTSUERRS)

   ----------------------------------------------------------------------------
   -- 52. Data Operation Circuit (DOC)
   ----------------------------------------------------------------------------

   -- 52.2.1 DOC Control Register (DOCR)
   -- 52.2.2 DOC Data Input Register (DODIR)
   -- 52.2.3 DOC Data Setting Register (DODSR)

   ----------------------------------------------------------------------------
   -- 53. SRAM
   ----------------------------------------------------------------------------

   -- 53.2.1 SRAM Parity Error Operation After Detection Register (PARIOAD)
   -- 53.2.2 SRAM Protection Register (SRAMPRCR)
   -- 53.2.3 SRAM Wait State Control Register (SRAMWTSC)
   -- 53.2.4 ECC Operating Mode Control Register (ECCMODE)
   -- 53.2.5 ECC 2-Bit Error Status Register (ECC2STS)
   -- 53.2.6 ECC 1-Bit Error Information Update Enable Register (ECC1STSEN)
   -- 53.2.7 ECC 1-Bit Error Status Register (ECC1STS)
   -- 53.2.8 ECC Protection Register (ECCPRCR)
   -- 53.2.9 ECC Test Control Register (ECCETST)
   -- 53.2.10 SRAM ECC Error Operation After Detection Register (ECCOAD)

   ----------------------------------------------------------------------------
   -- 54. Standby SRAM
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 55. Flash Memory
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 56. 2D Drawing Engine (DRW)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 57. JPEG Codec (JPEG)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 58. Graphics LCD Controller (GLCDC)
   ----------------------------------------------------------------------------

pragma Style_Checks (On);

end S5D9;
