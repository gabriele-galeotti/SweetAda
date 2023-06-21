-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7m.ads                                                                                                --
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

   ----------------------------------------------------------------------------
   -- B1.4 Registers
   ----------------------------------------------------------------------------

   -- B1.4.2 The special-purpose Program Status Registers, xPSR

   type APSR_Type is
   record
      Reserved1 : Bits_16 := 0;
      GE        : Bits_4;       -- [DSP extension only] Greater than or Equal flags.
      Reserved2 : Bits_7 := 0;
      Q         : Boolean;      -- Set to 1 if a SSAT or USAT instr changes the input value for the s or uns range of the result.
      V         : Boolean;      -- Overflow condition flag.
      C         : Boolean;      -- Carry condition flag.
      Z         : Boolean;      -- Zero condition flag.
      N         : Boolean;      -- Negative condition flag.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for APSR_Type use
   record
      Reserved1 at 0 range 0 .. 15;
      GE        at 0 range 16 .. 19;
      Reserved2 at 0 range 20 .. 26;
      Q         at 0 range 27 .. 27;
      V         at 0 range 28 .. 28;
      C         at 0 range 29 .. 29;
      Z         at 0 range 30 .. 30;
      N         at 0 range 31 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- B3.2 System Control Space (SCS)
   ----------------------------------------------------------------------------

   -- B3.2.2 System control and ID registers

   ACTLR_ADDRESS renames ARMv6M.ACTLR_ADDRESS;
   CPUID_ADDRESS renames ARMv6M.CPUID_ADDRESS;
   ICSR_ADDRESS  renames ARMv6M.ICSR_ADDRESS;
   VTOR_ADDRESS  renames ARMv6M.VTOR_ADDRESS;
   AIRCR_ADDRESS renames ARMv6M.AIRCR_ADDRESS;
   SCR_ADDRESS   renames ARMv6M.SCR_ADDRESS;
   CCR_ADDRESS   renames ARMv6M.CCR_ADDRESS;
   SHPR1_ADDRESS : constant := 16#E000_ED18#;
   SHPR2_ADDRESS renames ARMv6M.SHPR2_ADDRESS;
   SHPR3_ADDRESS renames ARMv6M.SHPR3_ADDRESS;
   SHCSR_ADDRESS renames ARMv6M.SHCSR_ADDRESS;
   DFSR_ADDRESS  renames ARMv6M.DFSR_ADDRESS;

   -- B3.2.3 CPUID Base Register

   subtype CPUID_Type is ARMv6M.CPUID_Type;
   CPUID : CPUID_Type renames ARMv6M.CPUID;
   function To_U32 (S : CPUID_Type) return Unsigned_32 renames ARMv6M.To_U32;

   -- B3.2.4 Interrupt Control and State Register, ICSR

   subtype ICSR_Type is ARMv6M.ICSR_Type;
   ICSR : ICSR_Type renames ARMv6M.ICSR;

   -- B3.2.5 Vector Table Offset Register, VTOR

   subtype VTOR_Type is ARMv6M.VTOR_Type;
   VTOR : VTOR_Type renames ARMv6M.VTOR;

   -- B3.2.6 Application Interrupt and Reset Control Register, AIRCR

   ENDIANNESS_LITTLE renames ARMv6M.ENDIANNESS_LITTLE;
   ENDIANNESS_BIG    renames ARMv6M.ENDIANNESS_BIG;

   VECTKEY_KEY renames ARMv6M.VECTKEY_KEY;

   subtype AIRCR_Type is ARMv6M.AIRCR_Type;
   AIRCR : AIRCR_Type renames ARMv6M.AIRCR;

   -- B3.2.7 System Control Register, SCR

   subtype SCR_Type is ARMv6M.SCR_Type;
   SCR : SCR_Type renames ARMv6M.SCR;

   -- B3.2.8 Configuration and Control Register, CCR

   BFHFNMIGN_LOCKUP : constant := 0;
   BFHFNMIGN_IGNORE : constant := 1;

   type CCR_Type is
   record
      NONBASETHRDENA : Boolean;      -- Controls whether the processor can enter Thread mode with exceptions active.
      USERSETMPEND   : Boolean;      -- Controls whether unprivileged software can access the STIR.
      Reserved1      : Bits_1 := 0;
      UNALIGN_TRP    : Boolean;      -- unaligned word and halfword accesses generate a HardFault exception
      DIV_0_TRP      : Boolean;      -- Controls the trap on divide by 0.
      Reserved2      : Bits_3 := 0;
      BFHFNMIGN      : Bits_1;       -- Determines the effect of precise data access faults on handlers ...
      STKALIGN       : Boolean;      -- On exception entry, the SP ... is adjusted to be 8-byte aligned.
      Reserved3      : Bits_6 := 0;
      DC             : Boolean;      -- Cache enable bit.
      IC             : Boolean;      -- Instruction cache enable bit.
      BP             : Boolean;      -- Branch prediction enable bit.
      Reserved4      : Bits_13 := 0;
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

   CCR : aliased CCR_Type with
      Address              => To_Address (CCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.10 System Handler Priority Register 1, SHPR1

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

   SHPR1 : aliased SHPR1_Type with
      Address              => To_Address (SHPR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.11 System Handler Priority Register 2, SHPR2

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

   SHPR2 : aliased SHPR2_Type with
      Address              => To_Address (ARMv6M.SHPR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.12 System Handler Priority Register 3, SHPR3

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

   SHPR3 : aliased SHPR3_Type with
      Address              => To_Address (SHPR3_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.13 System Handler Control and State Register, SHCSR

   type SHCSR_Type is
   record
      MEMFAULTACT    : Boolean;      -- MemManage active.
      BUSFAULTACT    : Boolean;      -- BusFault active.
      Reserved1      : Bits_1 := 0;
      USGFAULTACT    : Boolean;      -- UsageFault active.
      Reserved2      : Bits_3 := 0;
      SVCALLACT      : Boolean;      -- SVCall active.
      MONITORACT     : Boolean;      -- Monitor active.
      Reserved3      : Bits_1 := 0;
      PENDSVACT      : Boolean;      -- PendSV active.
      SYSTICKACT     : Boolean;      -- SysTick active.
      USGFAULTPENDED : Boolean;      -- UsageFault pending.
      MEMFAULTPENDED : Boolean;      -- MemManage pending.
      BUSFAULTPENDED : Boolean;      -- BusFault pending.
      SVCALLPENDED   : Boolean;      -- SVCall pending.
      MEMFAULTENA    : Boolean;      -- Enable MemManage fault.
      BUSFAULTENA    : Boolean;      -- Enable BusFault.
      USGFAULTENA    : Boolean;      -- Enable UsageFault.
      Reserved4      : Bits_13 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SHCSR_Type use
   record
      MEMFAULTACT    at 0 range 0 .. 0;
      BUSFAULTACT    at 0 range 1 .. 1;
      Reserved1      at 0 range 2 .. 2;
      USGFAULTACT    at 0 range 3 .. 3;
      Reserved2      at 0 range 4 .. 6;
      SVCALLACT      at 0 range 7 .. 7;
      MONITORACT     at 0 range 8 .. 8;
      Reserved3      at 0 range 9 .. 9;
      PENDSVACT      at 0 range 10 .. 10;
      SYSTICKACT     at 0 range 11 .. 11;
      USGFAULTPENDED at 0 range 12 .. 12;
      MEMFAULTPENDED at 0 range 13 .. 13;
      BUSFAULTPENDED at 0 range 14 .. 14;
      SVCALLPENDED   at 0 range 15 .. 15;
      MEMFAULTENA    at 0 range 16 .. 16;
      BUSFAULTENA    at 0 range 17 .. 17;
      USGFAULTENA    at 0 range 18 .. 18;
      Reserved4      at 0 range 19 .. 31;
   end record;

   SHCSR : aliased SHCSR_Type with
      Address              => To_Address (SHCSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.24 Interrupt Controller Type Register, ICTR

   type ICTR_Type is
   record
      INTLINESNUM : Bits_4;  -- The total number of interrupt lines supported by an implementation, defined in groups of 32.
      Reserved    : Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICTR_Type use
   record
      INTLINESNUM at 0 range 0 .. 3;
      Reserved    at 0 range 4 .. 31;
   end record;

   ICTR_ADDRESS : constant := 16#E000_E004#;

   ICTR : aliased ICTR_Type with
      Address              => To_Address (ICTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.25 Auxiliary Control Register, ACTLR
   -- IMPLEMENTATION DEFINED

   subtype ACTLR_Type is ARMv6M.ACTLR_Type;

   -- B3.2.26 Software Triggered Interrupt Register, STIR

   type STIR_Type is
   record
      INTID    : Bits_9;       -- Indicates the interrupt to be triggered.
      Reserved : Bits_23 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for STIR_Type use
   record
      INTID    at 0 range 0 .. 8;
      Reserved at 0 range 9 .. 31;
   end record;

   STIR_ADDRESS : constant := 16#E000_EF00#;

   STIR : aliased STIR_Type with
      Address              => To_Address (STIR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- B3.3 The system timer, SysTick
   ----------------------------------------------------------------------------

   -- B3.3.2 System timer register support in the SCS

   SYST_CSR_ADDRESS   renames ARMv6M.SYST_CSR_ADDRESS;
   SYST_RVR_ADDRESS   renames ARMv6M.SYST_RVR_ADDRESS;
   SYST_CVR_ADDRESS   renames ARMv6M.SYST_CVR_ADDRESS;
   SYST_CALIB_ADDRESS renames ARMv6M.SYST_CALIB_ADDRESS;

   -- B3.3.3 SysTick Control and Status Register, SYST_CSR

   CLKSOURCE_EXT renames ARMv6M.CLKSOURCE_EXT;
   CLKSOURCE_CPU renames ARMv6M.CLKSOURCE_CPU;

   subtype SYST_CSR_Type is ARMv6M.SYST_CSR_Type;
   SYST_CSR : SYST_CSR_Type renames ARMv6M.SYST_CSR;

   -- B3.3.4 SysTick Reload Value Register, SYST_RVR

   subtype SYST_RVR_Type is ARMv6M.SYST_RVR_Type;
   SYST_RVR : SYST_RVR_Type renames ARMv6M.SYST_RVR;

   -- B3.3.5 SysTick Current Value Register, SYST_CVR

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

   SYST_CVR : aliased SYST_CVR_Type with
      Address              => To_Address (SYST_CVR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.3.6 SysTick Calibration Value Register, SYST_CALIB

   subtype SYST_CALIB_Type is ARMv6M.SYST_CALIB_Type;
   SYST_CALIB : SYST_CALIB_Type renames ARMv6M.SYST_CALIB;

   ----------------------------------------------------------------------------
   -- B3.4 Nested Vectored Interrupt Controller, NVIC
   ----------------------------------------------------------------------------

   -- B3.4.4 Interrupt Set-Enable Registers, NVIC_ISER0-NVIC_ISER15
   -- B3.4.5 Interrupt Clear-Enable Registers, NVIC_ICER0-NVIC_ICER15
   -- B3.4.6 Interrupt Set-Pending Registers, NVIC_ISPR0-NVIC_ISPR15
   -- B3.4.7 Interrupt Clear-Pending Registers, NVIC_ICPR0-NVIC_ICPR15
   -- B3.4.8 Interrupt Active Bit Registers, NVIC_IABR0-NVIC_IABR15

   type NVIC_Array_Type is array (Natural range <>) of ARMv6M.NVIC_Bitmap_Type with
      Pack => True;

   -- B3.4.9 Interrupt Priority Registers, NVIC_IPR0-NVIC_IPR123

   NVIC_ISER_ADDRESS renames ARMv6M.NVIC_ISER_ADDRESS;
   NVIC_ICER_ADDRESS renames ARMv6M.NVIC_ICER_ADDRESS;
   NVIC_ISPR_ADDRESS renames ARMv6M.NVIC_ISPR_ADDRESS;
   NVIC_ICPR_ADDRESS renames ARMv6M.NVIC_ICPR_ADDRESS;
   NVIC_IABR_ADDRESS : constant := 16#E000_E300#;
   NVIC_IPR_ADDRESS  renames ARMv6M.NVIC_IPR_ADDRESS;

   NVIC_ISER : aliased NVIC_Array_Type (0 .. 15) with
      Address    => To_Address (NVIC_ISER_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   NVIC_ICER : aliased NVIC_Array_Type (0 .. 15) with
      Address    => To_Address (NVIC_ICER_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   NVIC_ISPR : aliased NVIC_Array_Type (0 .. 15) with
      Address    => To_Address (NVIC_ISPR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   NVIC_ICPR : aliased NVIC_Array_Type (0 .. 15) with
      Address    => To_Address (NVIC_ICPR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   NVIC_IABR : aliased NVIC_Array_Type (0 .. 15) with
      Address    => To_Address (NVIC_IABR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   NVIC_IPR  : aliased ARMv6M.NVIC_IPR_Array_Type (0 .. 123) with
      Address    => To_Address (NVIC_IPR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- C1.6 Debug system registers
   ----------------------------------------------------------------------------

   -- C1.6.1 Debug Fault Status Register, DFSR

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
