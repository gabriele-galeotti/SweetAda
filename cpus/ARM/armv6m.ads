-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv6m.ads                                                                                                --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package ARMv6M
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
   -- ARMv6-M Architecture Reference Manual
   -- ARM DDI 0419C (ID092410)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- B1.4 Registers
   ----------------------------------------------------------------------------

   -- B1.4.1 The ARM core registers

   function MSP_Read
      return Unsigned_32
      with Inline => True;
   procedure MSP_Write
      (Value : in Unsigned_32)
      with Inline => True;

   function PSP_Read
      return Unsigned_32
      with Inline => True;
   procedure PSP_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- B1.4.2 The special-purpose Program Status Registers, xPSR

   type APSR_Type is record
      Reserved : Bits_28;
      V        : Boolean; -- Overflow condition flag.
      C        : Boolean; -- Carry condition flag.
      Z        : Boolean; -- Zero condition flag.
      N        : Boolean; -- Negative condition flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for APSR_Type use record
      Reserved at 0 range  0 .. 27;
      V        at 0 range 28 .. 28;
      C        at 0 range 29 .. 29;
      Z        at 0 range 30 .. 30;
      N        at 0 range 31 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (APSR_Type, Unsigned_32);
   function To_APSR is new Ada.Unchecked_Conversion (Unsigned_32, APSR_Type);

   function APSR_Read
      return APSR_Type
      with Inline => True;
   procedure APSR_Write
      (Value : in APSR_Type)
      with Inline => True;

   type IPSR_Type is record
      Exception_Number : Bits_6;  -- in Handler mode, holds the exception number of the currently-executing exception
      Reserved         : Bits_26;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for IPSR_Type use record
      Exception_Number at 0 range 0 ..  5;
      Reserved         at 0 range 6 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (IPSR_Type, Unsigned_32);
   function To_IPSR is new Ada.Unchecked_Conversion (Unsigned_32, IPSR_Type);

   function IPSR_Read
      return IPSR_Type
      with Inline => True;
   procedure IPSR_Write
      (Value : in IPSR_Type)
      with Inline => True;

   type EPSR_Type is record
      Reserved1 : Bits_9;
      A         : Boolean; -- reserved, but when the processor stacks the PSR, it uses this bit to indicate the stack alignment
      Reserved2 : Bits_14;
      T         : Boolean; -- Thumb state
      Reserved3 : Bits_7;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EPSR_Type use record
      Reserved1 at 0 range  0 ..  8;
      A         at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 23;
      T         at 0 range 24 .. 24;
      Reserved3 at 0 range 25 .. 31;
   end record;

   function To_U32 is new Ada.Unchecked_Conversion (EPSR_Type, Unsigned_32);
   function To_EPSR is new Ada.Unchecked_Conversion (Unsigned_32, EPSR_Type);

   function EPSR_Read
      return EPSR_Type
      with Inline => True;
   procedure EPSR_Write
      (Value : in EPSR_Type)
      with Inline => True;

   -- B1.4.3 The special-purpose mask register, PRIMASK

   type PRIMASK_Type is record
      PM       : Boolean;      -- priority boosting
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PRIMASK_Type use record
      PM       at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   function PRIMASK_Read
      return PRIMASK_Type
      with Inline => True;
   procedure PRIMASK_Write
      (Value : in PRIMASK_Type)
      with Inline => True;

   -- B1.4.4 The special-purpose CONTROL register

   SPSEL_SP_main    : constant := 0; -- Use SP_main as the current stack
   SPSEL_SP_process : constant := 1; -- In Thread mode, use SP_process as the current stack.

   type CONTROL_Type is record
      nPRIV    : Boolean; -- defines the execution privilege in Thread mode
      SPSEL    : Bits_1;  -- Defines the stack to be used
      Reserved : Bits_30;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CONTROL_Type use record
      nPRIV    at 0 range 0 ..  0;
      SPSEL    at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   function CONTROL_Read
      return CONTROL_Type
      with Inline => True;
   procedure CONTROL_Write
      (Value : in CONTROL_Type)
      with Inline => True;

   -- B1.5.2 Exception number definition

   Reset         : constant := 1;
   NMI           : constant := 2;
   HardFault     : constant := 3;
   ReservedExc4  : constant := 4;
   ReservedExc5  : constant := 5;
   ReservedExc6  : constant := 6;
   ReservedExc7  : constant := 7;
   ReservedExc8  : constant := 8;
   ReservedExc9  : constant := 9;
   ReservedExc10 : constant := 10;
   SVCall        : constant := 11;
   ReservedExc12 : constant := 12;
   ReservedExc13 : constant := 13;
   PendSV        : constant := 14;
   SysTick       : constant := 15;

   ----------------------------------------------------------------------------
   -- B3.2 System Control Space (SCS)
   ----------------------------------------------------------------------------

   -- B3.2.2 System control and ID registers

   ACTLR_ADDRESS : constant := 16#E000_E008#;
   CPUID_ADDRESS : constant := 16#E000_ED00#;
   ICSR_ADDRESS  : constant := 16#E000_ED04#;
   VTOR_ADDRESS  : constant := 16#E000_ED08#;
   AIRCR_ADDRESS : constant := 16#E000_ED0C#;
   SCR_ADDRESS   : constant := 16#E000_ED10#;
   CCR_ADDRESS   : constant := 16#E000_ED14#;
   SHPR2_ADDRESS : constant := 16#E000_ED1C#;
   SHPR3_ADDRESS : constant := 16#E000_ED20#;
   SHCSR_ADDRESS : constant := 16#E000_ED24#;
   DFSR_ADDRESS  : constant := 16#E000_ED30#;

   -- B3.2.3 CPUID Base Register

   type CPUID_Type is record
      Revision    : Bits_4;
      PartNo      : Bits_12;
      Constant0F  : Bits_4;  -- 0x0F
      Variant     : Bits_4;
      Implementer : Bits_8;  -- 0x41 = ARM
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CPUID_Type use record
      Revision    at 0 range  0 ..  3;
      PartNo      at 0 range  4 .. 15;
      Constant0F  at 0 range 16 .. 19;
      Variant     at 0 range 20 .. 23;
      Implementer at 0 range 24 .. 31;
   end record;

   CPUID : aliased CPUID_Type
      with Address              => System'To_Address (CPUID_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   function To_U32 is new Ada.Unchecked_Conversion (CPUID_Type, Unsigned_32);

   -- B3.2.4 Interrupt Control and State Register, ICSR

   type ICSR_Type is record
      VECTACTIVE  : Bits_9;  -- The exception number of the current executing exception.
      Reserved1   : Bits_2;
      RETTOBASE   : Boolean; -- Whether there is an active exception other than the exception shown by IPSR.
      VECTPENDING : Bits_9;  -- The exception number of the highest priority pending and enabled interrupt.
      Reserved2   : Bits_1;
      ISRPENDING  : Boolean; -- Indicates whether an external interrupt, generated by the NVIC, is pending.
      ISRPREEMPT  : Boolean; -- Indicates whether a pending exception will be serviced on exit from debug halt state.
      Reserved3   : Bits_1;
      PENDSTCLR   : Boolean; -- Removes the pending status of the SysTick exception.
      PENDSTSET   : Boolean; -- W: sets the SysTick exception as pending R: indicates the current state of the exception.
      PENDSVCLR   : Boolean; -- Removes the pending status of the PendSV exception.
      PENDSVSET   : Boolean; -- W: sets the PendSV exception as pending. R: indicates the current state of the exception.
      Reserved4   : Bits_2;
      NMIPENDSET  : Boolean; -- W: makes the NMI exception active R: indicates the state of the exception.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICSR_Type use record
      VECTACTIVE  at 0 range  0 ..  8;
      Reserved1   at 0 range  9 .. 10;
      RETTOBASE   at 0 range 11 .. 11;
      VECTPENDING at 0 range 12 .. 20;
      Reserved2   at 0 range 21 .. 21;
      ISRPENDING  at 0 range 22 .. 22;
      ISRPREEMPT  at 0 range 23 .. 23;
      Reserved3   at 0 range 24 .. 24;
      PENDSTCLR   at 0 range 25 .. 25;
      PENDSTSET   at 0 range 26 .. 26;
      PENDSVCLR   at 0 range 27 .. 27;
      PENDSVSET   at 0 range 28 .. 28;
      Reserved4   at 0 range 29 .. 30;
      NMIPENDSET  at 0 range 31 .. 31;
   end record;

   ICSR : aliased ICSR_Type
      with Address              => System'To_Address (ICSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.5 Vector Table Offset Register, VTOR

   VTOR_ADDRESS_LSB : constant := 7;
   VTOR_ADDRESS_MSB : constant := 31;

   type VTOR_Type is record
      Reserved : Bits_7  := 0;
      TBLOFF   : Bits_25;      -- Bits[31:7] of the vector table address.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for VTOR_Type use record
      Reserved at 0 range 0 ..  6;
      TBLOFF   at 0 range 7 .. 31;
   end record;

   VTOR : aliased VTOR_Type
      with Address              => System'To_Address (VTOR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.6 Application Interrupt and Reset Control Register, AIRCR

   ENDIANNESS_LITTLE : constant := 0; -- memory system data endianness = LITTLE
   ENDIANNESS_BIG    : constant := 1; -- memory system data endianness = BIG

   VECTKEY_KEY : constant := 16#05FA#; -- Vector Key

   type AIRCR_Type is record
      Reserved1     : Bits_1;
      VECTCLRACTIVE : Boolean; -- Clears all active state information for fixed and configurable exceptions.
      SYSRESETREQ   : Boolean; -- System Reset Request.
      Reserved2     : Bits_12;
      ENDIANNESS    : Bits_1;  -- Indicates the memory system data endianness.
      VECTKEY_STAT  : Bits_16; -- Vector Key.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for AIRCR_Type use record
      Reserved1     at 0 range  0 ..  0;
      VECTCLRACTIVE at 0 range  1 ..  1;
      SYSRESETREQ   at 0 range  2 ..  2;
      Reserved2     at 0 range  3 .. 14;
      ENDIANNESS    at 0 range 15 .. 15;
      VECTKEY_STAT  at 0 range 16 .. 31;
   end record;

   AIRCR : aliased AIRCR_Type
      with Address              => System'To_Address (AIRCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.7 System Control Register, SCR

   type SCR_Type is record
      Reserved1   : Bits_1;
      SLEEPONEXIT : Boolean; -- Whether, on an exit from an ISR ..., the processor enters a sleep state.
      SLEEPDEEP   : Boolean; -- Provides a qualifying hint indicating that waking from sleep might take longer.
      Reserved2   : Bits_1;
      SEVONPEND   : Boolean; -- Whether an interrupt transition from inactive state to pending state is a wakeup event.
      Reserved3   : Bits_27;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCR_Type use record
      Reserved1   at 0 range 0 ..  0;
      SLEEPONEXIT at 0 range 1 ..  1;
      SLEEPDEEP   at 0 range 2 ..  2;
      Reserved2   at 0 range 3 ..  3;
      SEVONPEND   at 0 range 4 ..  4;
      Reserved3   at 0 range 5 .. 31;
   end record;

   SCR : aliased SCR_Type
      with Address              => System'To_Address (SCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.8 Configuration and Control Register, CCR

   type CCR_Type is record
      Reserved1   : Bits_3;
      UNALIGN_TRP : Boolean; -- unaligned word and halfword accesses generate a HardFault exception
      Reserved2   : Bits_5;
      STKALIGN    : Boolean; -- On exception entry, the SP ... is adjusted to be 8-byte aligned.
      Reserved3   : Bits_22;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CCR_Type use record
      Reserved1   at 0 range  0 ..  2;
      UNALIGN_TRP at 0 range  3 ..  3;
      Reserved2   at 0 range  4 ..  8;
      STKALIGN    at 0 range  9 ..  9;
      Reserved3   at 0 range 10 .. 31;
   end record;

   CCR : aliased CCR_Type
      with Address              => System'To_Address (CCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.9 System Handler Priority Register 2, SHPR2

   type SHPR2_Type is record
      Reserved : Bits_30;
      PRI_11   : Bits_2;  -- Priority of system handler 11, SVCall
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SHPR2_Type use record
      Reserved at 0 range  0 .. 29;
      PRI_11   at 0 range 30 .. 31;
   end record;

   SHPR2 : aliased SHPR2_Type
      with Address              => System'To_Address (SHPR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.10 System Handler Priority Register 3, SHPR3

   type SHPR3_Type is record
      Reserved1 : Bits_22;
      PRI_14    : Bits_2;  -- Priority of system handler 14, PendSV
      Reserved2 : Bits_6;
      PRI_15    : Bits_2;  -- Priority of system handler 15, SysTick
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SHPR3_Type use record
      Reserved1 at 0 range  0 .. 21;
      PRI_14    at 0 range 22 .. 23;
      Reserved2 at 0 range 24 .. 29;
      PRI_15    at 0 range 30 .. 31;
   end record;

   SHPR3 : aliased SHPR3_Type
      with Address              => System'To_Address (SHPR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.2.12 The Auxiliary Control Register, ACTLR
   -- IMPLEMENTATION DEFINED

   type ACTLR_Type is record
      Reserved : Bits_32;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ACTLR_Type use record
      Reserved at 0 range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- B3.3 The system timer, SysTick
   ----------------------------------------------------------------------------

   -- B3.3.2 System timer register support in the SCS

   SYST_CSR_ADDRESS   : constant := 16#E000_E010#;
   SYST_RVR_ADDRESS   : constant := 16#E000_E014#;
   SYST_CVR_ADDRESS   : constant := 16#E000_E018#;
   SYST_CALIB_ADDRESS : constant := 16#E000_E01C#;

   -- B3.3.3 SysTick Control and Status Register, SYST_CSR

   CLKSOURCE_EXT : constant := 0; -- SysTick uses the optional external reference clock.
   CLKSOURCE_CPU : constant := 1; -- SysTick uses the processor clock.

   type SYST_CSR_Type is record
      ENABLE    : Boolean;      -- Indicates the enabled status of the SysTick counter.
      TICKINT   : Boolean;      -- Indicates whether counting to 0 causes the status of the SysTick exception to change to pending.
      CLKSOURCE : Bits_1;       -- Indicates the SysTick clock source.
      Reserved1 : Bits_13 := 0;
      COUNTFLAG : Boolean;      -- Indicates whether the counter has counted to 0 since the last read of this register.
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYST_CSR_Type use record
      ENABLE    at 0 range  0 ..  0;
      TICKINT   at 0 range  1 ..  1;
      CLKSOURCE at 0 range  2 ..  2;
      Reserved1 at 0 range  3 .. 15;
      COUNTFLAG at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   SYST_CSR : aliased SYST_CSR_Type
      with Address              => System'To_Address (SYST_CSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.3.4 SysTick Reload Value Register, SYST_RVR

   type SYST_RVR_Type is record
      RELOAD   : Bits_24;      -- The value to load into the SYST_CVR register when the counter reaches 0.
      Reserved : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYST_RVR_Type use record
      RELOAD   at 0 range  0 .. 23;
      Reserved at 0 range 24 .. 31;
   end record;

   SYST_RVR : aliased SYST_RVR_Type
      with Address              => System'To_Address (SYST_RVR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.3.5 SysTick Current Value Register, SYST_CVR

   type SYST_CVR_Type is record
      CURRENT  : Bits_24;      -- Current counter value.
      Reserved : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYST_CVR_Type use record
      CURRENT  at 0 range  0 .. 23;
      Reserved at 0 range 24 .. 31;
   end record;

   SYST_CVR : aliased SYST_CVR_Type
      with Address              => System'To_Address (SYST_CVR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- B3.3.6 SysTick Calibration Value Register

   type SYST_CALIB_Type is record
      TENMS    : Bits_24; -- Optionally, holds a reload value to be used for 10ms (100Hz) timing.
      Reserved : Bits_6;
      SKEW     : Boolean; -- Indicates whether the 10ms calibration value is exact.
      NOREF    : Boolean; -- Indicates whether the IMPLEMENTATION DEFINED reference clock is provided.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYST_CALIB_Type use record
      TENMS    at 0 range  0 .. 23;
      Reserved at 0 range 24 .. 29;
      SKEW     at 0 range 30 .. 30;
      NOREF    at 0 range 31 .. 31;
   end record;

   SYST_CALIB : aliased SYST_CALIB_Type
      with Address              => System'To_Address (SYST_CALIB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- B3.4 Nested Vectored Interrupt Controller, NVIC
   ----------------------------------------------------------------------------

   -- B3.4.3 Interrupt Set-Enable Registers, NVIC_ISER
   -- B3.4.4 Interrupt Clear-Enable Registers, NVIC_ICER
   -- B3.4.5 Interrupt Set-Pending Registers, NVIC_ISPR
   -- B3.4.6 Interrupt Clear-Pending Registers, NVIC_ICPR

   type NVIC_Bitmap_Type is new Bitmap_32
      with Volatile_Full_Access => True;

   -- B3.4.7 Interrupt Priority Registers, NVIC_IPR0 - NVIC_IPR7

   type NVIC_IPR_Type is array (0 .. 3) of Unsigned_8
      with Volatile_Full_Access => True;

   type NVIC_IPR_Array_Type is array (Natural range <>) of NVIC_IPR_Type;

   NVIC_ISER_ADDRESS : constant := 16#E000_E100#;
   NVIC_ICER_ADDRESS : constant := 16#E000_E180#;
   NVIC_ISPR_ADDRESS : constant := 16#E000_E200#;
   NVIC_ICPR_ADDRESS : constant := 16#E000_E280#;
   NVIC_IABR_ADDRESS : constant := 16#E000_E300#;
   NVIC_IPR_ADDRESS  : constant := 16#E000_E400#;

   NVIC_ISER : aliased NVIC_Bitmap_Type
      with Address    => System'To_Address (NVIC_ISER_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   NVIC_ICER : aliased NVIC_Bitmap_Type
      with Address    => System'To_Address (NVIC_ICER_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   NVIC_ISPR : aliased NVIC_Bitmap_Type
      with Address    => System'To_Address (NVIC_ISPR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   NVIC_ICPR : aliased NVIC_Bitmap_Type
      with Address    => System'To_Address (NVIC_ICPR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   NVIC_IPR  : aliased NVIC_IPR_Array_Type (0 .. 7)
      with Address    => System'To_Address (NVIC_IPR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- C1.6 Debug system registers
   ----------------------------------------------------------------------------

   -- C1.6.1 System Handler Control and State Register, SHCSR

   type SHCSR_Type is record
      Reserved1    : Bits_15 := 0;
      SVCALLPENDED : Boolean;      -- ... reflects the pending state (R), and updates the pending state, to the value written (W).
      Reserved2    : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SHCSR_Type use record
      Reserved1    at 0 range  0 .. 14;
      SVCALLPENDED at 0 range 15 .. 15;
      Reserved2    at 0 range 16 .. 31;
   end record;

   SHCSR : aliased SHCSR_Type
      with Address              => System'To_Address (SHCSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- C1.6.2 Debug Fault Status Register, DFSR

   type DFSR_Type is record
      HALTED   : Boolean; -- Indicates a debug event generated by a C_HALT or C_STEP request.
      BKPT     : Boolean; -- Indicates a debug event generated by BKPT instruction execution or a bkpt match in the BPU.
      DWTTRAP  : Boolean; -- Indicates a debug event generated by the DWT.
      VCATCH   : Boolean; -- Indicates whether a vector catch debug event was generated.
      EXTERNAL : Boolean; -- Indicates an asynchronous debug event generated because of EDBGRQ being asserted.
      Reserved : Bits_27;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DFSR_Type use record
      HALTED   at 0 range 0 ..  0;
      BKPT     at 0 range 1 ..  1;
      DWTTRAP  at 0 range 2 ..  2;
      VCATCH   at 0 range 3 ..  3;
      EXTERNAL at 0 range 4 ..  4;
      Reserved at 0 range 5 .. 31;
   end record;

   DFSR : aliased DFSR_Type
      with Address              => System'To_Address (DFSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Specific definitions
   ----------------------------------------------------------------------------

   procedure WFE
      with Inline => True;
   procedure WFI
      with Inline => True;
   procedure DMB
      with Inline => True;
   procedure DSB
      with Inline => True;
   procedure ISB
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   String_Reset     : aliased constant String := "Reset";
   String_NMI       : aliased constant String := "NMI";
   String_HardFault : aliased constant String := "HardFault";
   String_Reserved  : aliased constant String := "Reserved";
   -- Reserved
   -- Reserved
   -- Reserved
   -- Reserved
   -- Reserved
   -- Reserved
   String_SVCall    : aliased constant String := "SVCall";
   -- Reserved
   -- Reserved
   String_PendSV    : aliased constant String := "PendSV";
   String_SysTick   : aliased constant String := "SysTick";
   String_UNKNOWN   : aliased constant String := "UNKNOWN";

   MsgPtr_Reset     : constant access constant String := String_Reset'Access;     -- 1
   MsgPtr_NMI       : constant access constant String := String_NMI'Access;       -- 2
   MsgPtr_HardFault : constant access constant String := String_HardFault'Access; -- 3
   MsgPtr_Reserved  : constant access constant String := String_Reserved'Access;  -- 4
   -- Reserved                                                                       5
   -- Reserved                                                                       6
   -- Reserved                                                                       7
   -- Reserved                                                                       8
   -- Reserved                                                                       9
   -- Reserved                                                                       10
   MsgPtr_SVCall    : constant access constant String := String_SVCall'Access;    -- 11
   -- Reserved                                                                    -- 12
   -- Reserved                                                                    -- 13
   MsgPtr_PendSV    : constant access constant String := String_PendSV'Access;    -- 14
   MsgPtr_SysTick   : constant access constant String := String_SysTick'Access;   -- 15
   MsgPtr_UNKNOWN   : constant access constant String := String_UNKNOWN'Access;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;
   procedure Fault_Irq_Enable
      with Inline => True;
   procedure Fault_Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end ARMv6M;
