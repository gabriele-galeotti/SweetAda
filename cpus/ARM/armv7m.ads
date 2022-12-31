-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7m.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
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
with ARMv6M;

package ARMv7M is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   -- B3.2.3 CPUID Base Register

   subtype CPUID_Type is ARMv6M.CPUID_Type;
   CPUID : CPUID_Type renames ARMv6M.CPUID;
   function To_U32 (S : CPUID_Type) return Unsigned_32 renames ARMv6M.To_U32;

   -- B3.2.4 Interrupt Control and State Register

   subtype ICSR_Type is ARMv6M.ICSR_Type;
   ICSR : ICSR_Type renames ARMv6M.ICSR;

   -- B3.2.5 Vector Table Offset Register

   subtype VTOR_Type is ARMv6M.VTOR_Type;
   VTOR : VTOR_Type renames ARMv6M.VTOR;

   -- B3.2.6 Application Interrupt and Reset Control Register

   ENDIANNESS_LITTLE : Bits_1 renames ARMv6M.ENDIANNESS_LITTLE;
   ENDIANNESS_BIG    : Bits_1 renames ARMv6M.ENDIANNESS_BIG;

   VECTKEY_KEY : Bits_16 renames ARMv6M.VECTKEY_KEY;

   subtype AIRCR_Type is ARMv6M.AIRCR_Type;
   AIRCR : AIRCR_Type renames ARMv6M.AIRCR;

   -- B3.2.7 System Control Register

   subtype SCR_Type is ARMv6M.SCR_Type;
   SCR : SCR_Type renames ARMv6M.SCR;

   -- B3.2.8 Configuration and Control Register

   BFHFNMIGN_LOCKUP : constant := 0;
   BFHFNMIGN_IGNORE : constant := 1;

   type CCR_Type is
   record
      NONBASETHRDENA : Boolean; -- Controls whether the processor can enter Thread mode with exceptions active.
      USERSETMPEND   : Boolean; -- Controls whether unprivileged software can access the STIR.
      Reserved1      : Bits_1;
      UNALIGN_TRP    : Boolean; -- unaligned word and halfword accesses generate a HardFault exception
      DIV_0_TRP      : Boolean; -- Controls the trap on divide by 0.
      Reserved2      : Bits_3;
      BFHFNMIGN      : Bits_1;  -- Determines the effect of precise data access faults on handlers ...
      STKALIGN       : Boolean; -- On exception entry, the SP ... is adjusted to be 8-byte aligned.
      Reserved3      : Bits_6;
      DC             : Boolean; -- Cache enable bit.
      IC             : Boolean; -- Instruction cache enable bit.
      BP             : Boolean; -- Branch prediction enable bit.
      Reserved4      : Bits_13;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CCR_Type use
   record
      NONBASETHRDENA at 0 range 0 .. 0;
      USERSETMPEND   at 0 range 1 .. 1;
      Reserved1      at 0 range 2 .. 2;
      UNALIGN_TRP    at 0 range 3 .. 3;
      DIV_0_TRP      at 0 range 4 .. 4;
      Reserved2      at 0 range 5 .. 7;
      BFHFNMIGN      at 0 range 8 .. 8;
      STKALIGN       at 0 range 9 .. 9;
      Reserved3      at 0 range 10 .. 15;
      DC             at 0 range 16 .. 16;
      IC             at 0 range 17 .. 17;
      BP             at 0 range 18 .. 18;
      Reserved4      at 0 range 19 .. 31;
   end record;

   CCR_ADDRESS : constant := 16#E000_ED14#;

   CCR : aliased CCR_Type with
      Address              => To_Address (CCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.9 System Handler Priority Register 1

   type SHPR1_Type is
   record
      PRI_4 : Bits_8; -- Priority of system handler 4, MemManage.
      PRI_5 : Bits_8; -- Priority of system handler 5, BusFault.
      PRI_6 : Bits_8; -- Priority of system handler 6, UsageFault.
      PRI_7 : Bits_8; -- Reserved for priority of system handler 7.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SHPR1_Type use
   record
      PRI_4 at 0 range 0 .. 7;
      PRI_5 at 0 range 8 .. 15;
      PRI_6 at 0 range 16 .. 23;
      PRI_7 at 0 range 24 .. 31;
   end record;

   SHPR1_ADDRESS : constant := 16#E000_ED18#;

   SHPR1 : aliased SHPR1_Type with
      Address              => To_Address (SHPR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.11 System Handler Priority Register 2

   type SHPR2_Type is
   record
      PRI_8  : Bits_8; -- Reserved for priority of system handler 8.
      PRI_9  : Bits_8; -- Reserved for priority of system handler 9.
      PRI_10 : Bits_8; -- Reserved for priority of system handler 10.
      PRI_11 : Bits_8; -- Priority of system handler 11, SVCall.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SHPR2_Type use
   record
      PRI_8  at 0 range 0 .. 7;
      PRI_9  at 0 range 8 .. 15;
      PRI_10 at 0 range 16 .. 23;
      PRI_11 at 0 range 24 .. 31;
   end record;

   SHPR2_ADDRESS : constant := 16#E000_ED1C#;

   SHPR2 : aliased SHPR2_Type with
      Address              => To_Address (SHPR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.12 System Handler Priority Register 3

   type SHPR3_Type is
   record
      PRI_12 : Bits_8; -- Priority of system handler 12, DebugMonitor.
      PRI_13 : Bits_8; -- Reserved for priority of system handler 13.
      PRI_14 : Bits_8; -- Priority of system handler 14, PendSV.
      PRI_15 : Bits_8; -- Priority of system handler 15, SysTick.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SHPR3_Type use
   record
      PRI_12 at 0 range 0 .. 7;
      PRI_13 at 0 range 8 .. 15;
      PRI_14 at 0 range 16 .. 23;
      PRI_15 at 0 range 24 .. 31;
   end record;

   SHPR3_ADDRESS : constant := 16#E000_ED20#;

   SHPR3 : aliased SHPR3_Type with
      Address              => To_Address (SHPR3_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.25 Auxiliary Control Register
   -- IMPLEMENTATION DEFINED

   subtype ACTLR_Type is ARMv6M.ACTLR_Type;
   ACTLR_ADDRESS : Integer_Address renames ARMv6M.ACTLR_ADDRESS;

   -- B3.3.3 SysTick Control and Status Register

   CLKSOURCE_EXT : Bits_1 renames ARMv6M.CLKSOURCE_EXT;
   CLKSOURCE_CPU : Bits_1 renames ARMv6M.CLKSOURCE_CPU;

   subtype SYST_CSR_Type is ARMv6M.SYST_CSR_Type;
   SYST_CSR : SYST_CSR_Type renames ARMv6M.SYST_CSR;

   -- B3.3.4 SysTick Reload Value Register

   subtype SYST_RVR_Type is ARMv6M.SYST_RVR_Type;
   SYST_RVR : SYST_RVR_Type renames ARMv6M.SYST_RVR;

   -- B3.3.5 SysTick Current Value Register

   type SYST_CVR_Type is
   record
      CURRENT : Bits_32; -- Current counter value.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYST_CVR_Type use
   record
      CURRENT at 0 range 0 .. 31;
   end record;

   SYST_CVR_ADDRESS : Integer_Address renames ARMv6M.SYST_CVR_ADDRESS;

   SYST_CVR : aliased SYST_CVR_Type with
      Address              => To_Address (SYST_CVR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.3.6 SysTick Calibration Value Register

   subtype SYST_CALIB_Type is ARMv6M.SYST_CALIB_Type;
   SYST_CALIB : SYST_CALIB_Type renames ARMv6M.SYST_CALIB;

   -- C1.6.1 Debug Fault Status Register

   subtype DFSR_Type is ARMv6M.DFSR_Type;
   DFSR : DFSR_Type renames ARMv6M.DFSR;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP renames ARMv6M.NOP;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable  renames ARMv6M.Irq_Enable;
   procedure Irq_Disable renames ARMv6M.Irq_Disable;

end ARMv7M;
