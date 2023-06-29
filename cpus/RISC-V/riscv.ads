-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.ads                                                                                                 --
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
with RISCV_Definitions;

package RISCV is

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
   use RISCV_Definitions;

   -- Machine Status (mstatus)

   type mstatus_Type is
   record
      UIE       : Boolean;     -- User Interrupt Enable
      SIE       : Boolean;     -- Supervisor Interrupt Enable
      Reserved1 : Bits_1 := 0;
      MIE       : Boolean;     -- Machine Interrupt Enable
      UPIE      : Boolean;     -- User Previous Interrupt Enable
      SPIE      : Boolean;     -- Supervisor Previous Interrupt Enable
      Reserved2 : Bits_1 := 0;
      MPIE      : Boolean;     -- Machine Previous Interrupt Enabler
      SPP       : Boolean;     -- Supervisor Previous Privilege
      Reserved3 : Bits_2 := 0;
      MPP       : Bits_2;      -- Machine Previous Privilege
      FS        : Bits_2;      -- Floating Point State
      XS        : Bits_2;      -- User Mode Extension State
      MPRIV     : Boolean;     -- Modify Privilege (access memory as MPP)
      SUM       : Boolean;     -- Permit Supervisor User Memory Access
      MXR       : Boolean;     -- Make Executable Readable
      TVM       : Boolean;     -- Trap Virtual memory
      TW        : Boolean;     -- Timeout Wait (traps S-Mode wfi)
      TSR       : Boolean;     -- Trap SRET
      Reserved4 : Bits_8 := 0;
      SD        : Boolean;     -- State Dirty (FS and XS summary bit)
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for mstatus_Type use
   record
      UIE       at 0 range 0 .. 0;
      SIE       at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      MIE       at 0 range 3 .. 3;
      UPIE      at 0 range 4 .. 4;
      SPIE      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      MPIE      at 0 range 7 .. 7;
      SPP       at 0 range 8 .. 8;
      Reserved3 at 0 range 9 .. 10;
      MPP       at 0 range 11 .. 12;
      FS        at 0 range 13 .. 14;
      XS        at 0 range 15 .. 16;
      MPRIV     at 0 range 17 .. 17;
      SUM       at 0 range 18 .. 18;
      MXR       at 0 range 19 .. 19;
      TVM       at 0 range 20 .. 20;
      TW        at 0 range 21 .. 21;
      TSR       at 0 range 22 .. 22;
      Reserved4 at 0 range 23 .. 30;
      SD        at 0 range 31 .. 31;
   end record;

   -- Machine Trap Vector CSR (mtvec)

   MODE_Direct   : constant := 2#00#;
   MODE_Vectored : constant := 2#01#;

   type MTVEC_Type is
   record
      MODE : Bits_2;  -- MODE Sets the interrupt processing mode.
      BASE : Bits_30; -- Interrupt Vector Base Address.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MTVEC_Type use
   record
      MODE at 0 range 0 .. 1;
      BASE at 0 range 2 .. 31;
   end record;

   procedure MTVEC_Write (Mtvec : in MTVEC_Type) with
      Inline => True;

   -- Machine Cause (mcause)

   -- Interrupt = 1
   EXC_SWINT         : constant := 3;  -- Machine software interrupt
   EXC_TIMERINT      : constant := 7;  -- Machine timer interrupt
   EXC_EXTINT        : constant := 11; -- Machine external interrupt
   -- Interrupt = 0
   EXC_INSTRADDRMIS  : constant := 0;  -- Instruction address misaligned
   EXC_INSTRACCFAULT : constant := 1;  -- Instruction access fault
   EXC_INSTRILL      : constant := 2;  -- Illegal instruction
   EXC_BREAKPT       : constant := 3;  -- Breakpoint
   EXC_LOADADDRMIS   : constant := 4;  -- Load address misaligned
   EXC_LOADACCFAULT  : constant := 5;  -- Load access fault
   EXC_STAMOADDRMIS  : constant := 6;  -- Store/AMO address misaligned
   EXC_STAMOACCFAULT : constant := 7;  -- Store/AMO access fault
   EXC_ENVCALLUMODE  : constant := 8;  -- Environment call from U-mode
   EXC_ENVCALLMMODE  : constant := 11; -- Environment call from M-mode

   type MCAUSE_Type is
   record
      Exception_Code : Bits_10; -- A code identifying the last exception.
      Reserved       : Bits_21;
      Interrupt      : Boolean; -- 1, if the trap was caused by an interrupt; 0 otherwise.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MCAUSE_Type use
   record
      Exception_Code at 0 range 0 .. 9;
      Reserved       at 0 range 10 .. 30;
      Interrupt      at 0 range 31 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- CLIC/CLINT
   ----------------------------------------------------------------------------

   MSIP_ADDRESS : constant := 16#0200_0000#;

   MSIP : aliased Unsigned_32 with
      Address              => To_Address (MSIP_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- mtime/mtimecmp
   ----------------------------------------------------------------------------

   MTIME_ADDRESS : constant := 16#0200_BFF8#;

   mtime : mtime_Type with
      Address    => To_Address (MTIME_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   MTIMECMP_ADDRESS : constant := 16#0200_4000#;

   mtimecmp : mtime_Type with
      Address    => To_Address (MTIMECMP_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   function mtime_Read return Unsigned_64 with
      Inline => True;
   procedure mtimecmp_Write (Value : in Unsigned_64) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   function MCAUSE_Read return Unsigned_32 with
      Inline => True;
   function MEPC_Read return Unsigned_32 with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end RISCV;
