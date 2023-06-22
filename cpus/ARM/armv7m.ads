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
with Ada.Unchecked_Conversion;
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

   -- B1.4.1 The Arm core registers

   function MSP_Read return Unsigned_32         renames ARMv6M.MSP_Read;
   procedure MSP_Write (Value : in Unsigned_32) renames ARMv6M.MSP_Write;

   function PSP_Read return Unsigned_32         renames ARMv6M.PSP_Read;
   procedure PSP_Write (Value : in Unsigned_32) renames ARMv6M.PSP_Write;

   -- B1.4.2 The special-purpose Program Status Registers, xPSR

   type APSR_Type is
   record
      Reserved1 : Bits_16;
      GE        : Bits_4;  -- Greater than or Equal flags.
      Reserved2 : Bits_7;
      Q         : Boolean; -- [DSP extension], the processor sets this bit to 1 to indicate an overflow on some multiplies.
      V         : Boolean; -- Overflow condition flag.
      C         : Boolean; -- Carry condition flag.
      Z         : Boolean; -- Zero condition flag.
      N         : Boolean; -- Negative condition flag.
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

   function To_U32 is new Ada.Unchecked_Conversion (APSR_Type, Unsigned_32);
   function To_APSR is new Ada.Unchecked_Conversion (Unsigned_32, APSR_Type);

   function APSR_Read return APSR_Type with
      Inline => True;
   procedure APSR_Write (Value : in APSR_Type) with
      Inline => True;

   type IPSR_Type is
   record
      Exception_Number : Bits_9;  -- in Handler mode, holds the exception number of the currently-executing exception
      Reserved         : Bits_23;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for IPSR_Type use
   record
      Exception_Number at 0 range 0 .. 8;
      Reserved         at 0 range 9 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (IPSR_Type, Unsigned_32);
   function To_IPSR is new Ada.Unchecked_Conversion (Unsigned_32, IPSR_Type);

   function IPSR_Read return IPSR_Type with
      Inline => True;
   procedure IPSR_Write (Value : in IPSR_Type) with
      Inline => True;

   type EPSR_Type is
   record
      Reserved1 : Bits_9;
      A         : Boolean; -- reserved, but when the processor stacks the PSR, it uses this bit to indicate the stack alignment
      ICIIT1    : Bits_6;  -- saved exception-continuable instruction state or saved IT state
      Reserved2 : Bits_8;
      T         : Boolean; -- Thumb state
      ICIIT2    : Bits_2;  -- saved exception-continuable instruction state or saved IT state
      Reserved3 : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for EPSR_Type use
   record
      Reserved1 at 0 range 0 .. 8;
      A         at 0 range 9 .. 9;
      ICIIT1    at 0 range 10 .. 15;
      Reserved2 at 0 range 16 .. 23;
      T         at 0 range 24 .. 24;
      ICIIT2    at 0 range 25 .. 26;
      Reserved3 at 0 range 27 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (EPSR_Type, Unsigned_32);
   function To_EPSR is new Ada.Unchecked_Conversion (Unsigned_32, EPSR_Type);

   function EPSR_Read return EPSR_Type with
      Inline => True;
   procedure EPSR_Write (Value : in EPSR_Type) with
      Inline => True;

   -- B1.4.3 The special-purpose mask registers

   subtype PRIMASK_Type is ARMv6M.PRIMASK_Type;
   function PRIMASK_Read return PRIMASK_Type         renames ARMv6M.PRIMASK_Read;
   procedure PRIMASK_Write (Value : in PRIMASK_Type) renames ARMv6M.PRIMASK_Write;

   type BASEPRI_Type is
   record
      BASEPRI  : Unsigned_8;   -- The base priority mask
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for BASEPRI_Type use
   record
      BASEPRI  at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   function BASEPRI_Read return BASEPRI_Type;
   procedure BASEPRI_Write (Value : in BASEPRI_Type);

   type FAULTMASK_Type is
   record
      FM       : Boolean;      -- The fault mask
      Reserved : Bits_31 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for FAULTMASK_Type use
   record
      FM       at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 31;
   end record;

   function FAULTMASK_Read return FAULTMASK_Type;
   procedure FAULTMASK_Write (Value : in FAULTMASK_Type);

   -- B1.4.4 The special-purpose CONTROL register

   SPSEL_SP_main    : constant := 0; -- Use SP_main as the current stack
   SPSEL_SP_process : constant := 1; -- In Thread mode, use SP_process as the current stack.

   type CONTROL_Type is
   record
      nPRIV    : Boolean; -- defines the execution privilege in Thread mode
      SPSEL    : Bits_1;  -- Defines the stack to be used
      FPCA     : Boolean; -- if the processor includes the FP extension
      Reserved : Bits_29;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CONTROL_Type use
   record
      nPRIV    at 0 range 0 .. 0;
      SPSEL    at 0 range 1 .. 1;
      FPCA     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 31;
   end record;

   function CONTROL_Read return CONTROL_Type;
   procedure CONTROL_Write (Value : in CONTROL_Type);

   ----------------------------------------------------------------------------
   -- B3.2 System Control Space (SCS)
   ----------------------------------------------------------------------------

   -- B3.2.2 System control and ID registers

   ICTR_ADDRESS   : constant := 16#E000_E004#;
   ACTLR_ADDRESS  renames ARMv6M.ACTLR_ADDRESS;
   CPUID_ADDRESS  renames ARMv6M.CPUID_ADDRESS;
   ICSR_ADDRESS   renames ARMv6M.ICSR_ADDRESS;
   VTOR_ADDRESS   renames ARMv6M.VTOR_ADDRESS;
   AIRCR_ADDRESS  renames ARMv6M.AIRCR_ADDRESS;
   SCR_ADDRESS    renames ARMv6M.SCR_ADDRESS;
   CCR_ADDRESS    renames ARMv6M.CCR_ADDRESS;
   SHPR1_ADDRESS  : constant := 16#E000_ED18#;
   SHPR2_ADDRESS  renames ARMv6M.SHPR2_ADDRESS;
   SHPR3_ADDRESS  renames ARMv6M.SHPR3_ADDRESS;
   SHCSR_ADDRESS  renames ARMv6M.SHCSR_ADDRESS;
   CFSR_ADDRESS   : constant := 16#E000_ED28#;
   HFSR_ADDRESS   : constant := 16#E000_ED2C#;
   DFSR_ADDRESS   renames ARMv6M.DFSR_ADDRESS;
   MMFAR_ADDRESS  : constant := 16#E000_ED34#;
   BFAR_ADDRESS   : constant := 16#E000_ED38#;
   AFSR_ADDRESS   : constant := 16#E000_ED3C#;
   CPACR_ADDRESS  : constant := 16#E000_ED88#;
   FPCCR_ADDRESS  : constant := 16#E000_EF34#;
   FPCAR_ADDRESS  : constant := 16#E000_EF38#;
   FPDSCR_ADDRESS : constant := 16#E000_EF3C#;

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

   type CCR_Type is
   record
      NONBASETHRDENA : Boolean; -- Controls whether the processor can enter Thread mode with exceptions active.
      USERSETMPEND   : Boolean; -- Controls whether unprivileged software can access the STIR.
      Reserved1      : Bits_1;
      UNALIGN_TRP    : Boolean; -- unaligned word and halfword accesses generate a HardFault exception
      DIV_0_TRP      : Boolean; -- Controls the trap on divide by 0.
      Reserved2      : Bits_3;
      BFHFNMIGN      : Boolean; -- Determines the effect of precise data access faults on handlers ...
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
      Address              => To_Address (SHPR2_ADDRESS),
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

   -- B3.2.15 Configurable Fault Status Register, CFSR

   -- MemManage Status Register, MMFSR
   type MMFSR_Type is
   record
      IACCVIOL  : Boolean;     -- MPU or Execute Never (XN) default memory map access violation on an instruction fetch ...
      DACCVIOL  : Boolean;     -- Data access violation.
      Reserved1 : Bits_1 := 0;
      MUNSTKERR : Boolean;     -- A derived MemManage fault occurred on exception return.
      MSTKERR   : Boolean;     -- A derived MemManage fault occurred on exception entry.
      MLSPERR   : Boolean;     -- A MemManage fault occurred during FP lazy state preservation.
      Reserved2 : Bits_1 := 0;
      MMARVALID : Boolean;     -- MMFAR has valid contents.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MMFSR_Type use
   record
      IACCVIOL  at 0 range 0 .. 0;
      DACCVIOL  at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      MUNSTKERR at 0 range 3 .. 3;
      MSTKERR   at 0 range 4 .. 4;
      MLSPERR   at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      MMARVALID at 0 range 7 .. 7;
   end record;

   -- BusFault Status Register, BFSR
   type BFSR_Type is
   record
      IBUSERR     : Boolean;     -- A bus fault on an instruction prefetch has occurred.
      PRECISERR   : Boolean;     -- A precise data access error has occurred.
      IMPRECISERR : Boolean;     -- A derived MemManage fault occurred on exception return.
      UNSTKERR    : Boolean;     -- A derived bus fault has occurred on exception return.
      STKERR      : Boolean;     -- A derived bus fault has occurred on exception entry.
      LSPERR      : Boolean;     -- A bus fault occurred during FP lazy state preservation.
      Reserved    : Bits_1 := 0;
      BFARVALID   : Boolean;     -- BFAR has valid contents.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for BFSR_Type use
   record
      IBUSERR     at 0 range 0 .. 0;
      PRECISERR   at 0 range 1 .. 1;
      IMPRECISERR at 0 range 2 .. 2;
      UNSTKERR    at 0 range 3 .. 3;
      STKERR      at 0 range 4 .. 4;
      LSPERR      at 0 range 5 .. 5;
      Reserved    at 0 range 6 .. 6;
      BFARVALID   at 0 range 7 .. 7;
   end record;

   -- UsageFault Status Register, UFSR
   type UFSR_Type is
   record
      UNDEFINSTR : Boolean;     -- The processor has attempted to execute an undefined instruction.
      INVSTATE   : Boolean;     -- Instruction executed with invalid EPSR.T or EPSR.IT field.
      INVPC      : Boolean;     -- An integrity check error has occurred on EXC_RETURN.
      NOCP       : Boolean;     -- A coprocessor access error has occurred.
      Reserved1  : Bits_4 := 0;
      UNALIGNED  : Boolean;     -- Unaligned access error has occurred.
      DIVBYZERO  : Boolean;     -- Divide by zero error has occurred.
      Reserved2  : Bits_6 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for UFSR_Type use
   record
      UNDEFINSTR at 0 range 0 .. 0;
      INVSTATE   at 0 range 1 .. 1;
      INVPC      at 0 range 2 .. 2;
      NOCP       at 0 range 3 .. 3;
      Reserved1  at 0 range 4 .. 7;
      UNALIGNED  at 0 range 8 .. 8;
      DIVBYZERO  at 0 range 9 .. 9;
      Reserved2  at 0 range 10 .. 15;
   end record;

   type CFSR_Type is
   record
      MemManage  : MMFSR_Type; -- Provides information on MemManage exceptions.
      BusFault   : BFSR_Type;  -- Provides information on BusFault exceptions.
      UsageFault : UFSR_Type;  -- Provides information on UsageFault exceptions.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CFSR_Type use
   record
      MemManage  at 0 range 0 .. 7;
      BusFault   at 0 range 8 .. 15;
      UsageFault at 0 range 16 .. 31;
   end record;

   CFSR : aliased CFSR_Type with
      Address              => To_Address (CFSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.16 HardFault Status Register, HFSR

   type HFSR_Type is
   record
      Reserved1 : Bits_1 := 0;
      VECTTBL   : Boolean;      -- Vector table read fault has occurred.
      Reserved2 : Bits_28 := 0;
      FORCED    : Boolean;      -- Processor has escalated a configurable-priority exception to HardFault.
      DEBUGEVT  : Boolean;      -- Debug event has occurred.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for HFSR_Type use
   record
      Reserved1 at 0 range 0 .. 0;
      VECTTBL   at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 29;
      FORCED    at 0 range 30 .. 30;
      DEBUGEVT  at 0 range 31 .. 31;
   end record;

   HFSR : aliased HFSR_Type with
      Address              => To_Address (HFSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.17 MemManage Fault Address Register, MMFAR

   MMFAR : aliased Unsigned_32 with
      Address              => To_Address (MMFAR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.18 BusFault Address Register, BFAR

   BFAR : aliased Unsigned_32 with
      Address              => To_Address (BFAR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.19 Auxiliary Fault Status Register, AFSR
   -- IMPLEMENTATION DEFINED

   -- B3.2.20 Coprocessor Access Control Register, CPACR

   CP_ACCESS_DENIED : constant := 2#00#;
   CP_PRIVONLY      : constant := 2#01#;
   CP_FULLACCESS    : constant := 2#11#;

   type CPACR_Type is
   record
      CP0        : Bits_2;      -- access privileges for coprocessor
      CP1        : Bits_2;      -- access privileges for coprocessor
      CP2        : Bits_2;      -- access privileges for coprocessor
      CP3        : Bits_2;      -- access privileges for coprocessor
      CP4        : Bits_2;      -- access privileges for coprocessor
      CP5        : Bits_2;      -- access privileges for coprocessor
      CP6        : Bits_2;      -- access privileges for coprocessor
      CP7        : Bits_2;      -- access privileges for coprocessor
      Reserved8  : Bits_2 := 0;
      Reserved9  : Bits_2 := 0;
      CP10       : Bits_2;      -- access privileges for coprocessor
      CP11       : Bits_2;      -- access privileges for coprocessor
      Reserved12 : Bits_2 := 0;
      Reserved13 : Bits_2 := 0;
      Reserved14 : Bits_2 := 0;
      Reserved15 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CPACR_Type use
   record
      CP0        at 0 range 0 .. 1;
      CP1        at 0 range 2 .. 3;
      CP2        at 0 range 4 .. 5;
      CP3        at 0 range 6 .. 7;
      CP4        at 0 range 8 .. 9;
      CP5        at 0 range 10 .. 11;
      CP6        at 0 range 12 .. 13;
      CP7        at 0 range 14 .. 15;
      Reserved8  at 0 range 16 .. 17;
      Reserved9  at 0 range 18 .. 19;
      CP10       at 0 range 20 .. 21;
      CP11       at 0 range 22 .. 23;
      Reserved12 at 0 range 24 .. 25;
      Reserved13 at 0 range 26 .. 27;
      Reserved14 at 0 range 28 .. 29;
      Reserved15 at 0 range 30 .. 31;
   end record;

   CPACR : aliased CPACR_Type with
      Address              => To_Address (CPACR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.24 Interrupt Controller Type Register, ICTR

   type ICTR_Type is
   record
      INTLINESNUM : Bits_4;  -- The total number of interrupt lines supported by an implementation
      Reserved    : Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICTR_Type use
   record
      INTLINESNUM at 0 range 0 .. 3;
      Reserved    at 0 range 4 .. 31;
   end record;

   ICTR : aliased ICTR_Type with
      Address              => To_Address (ICTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- B3.2.25 Auxiliary Control Register
   -- IMPLEMENTATION DEFINED

   subtype ACTLR_Type is ARMv6M.ACTLR_Type;

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
   procedure Fiq_Enable  renames ARMv6M.Fiq_Enable;
   procedure Fiq_Disable renames ARMv6M.Fiq_Disable;

end ARMv7M;
