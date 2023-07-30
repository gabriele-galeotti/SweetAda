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

   -- Machine Status (mstatus)

   subtype mstatus_Type is RISCV_Definitions.mstatus_Type;

   -- Machine Trap Vector CSR (mtvec)

   MODE_Direct   : constant := 2#00#;
   MODE_Vectored : constant := 2#01#;

   type mtvec_Type is
   record
      MODE : Bits_2;  -- MODE Sets the interrupt processing mode.
      BASE : Bits_30; -- Interrupt Vector Base Address.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for mtvec_Type use
   record
      MODE at 0 range 0 .. 1;
      BASE at 0 range 2 .. 31;
   end record;

   procedure mtvec_Write (mtvec : in mtvec_Type) with
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

   type mcause_Type is
   record
      Exception_Code : Bits_10; -- A code identifying the last exception.
      Reserved       : Bits_21;
      Interrupt      : Boolean; -- 1, if the trap was caused by an interrupt; 0 otherwise.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for mcause_Type use
   record
      Exception_Code at 0 range 0 .. 9;
      Reserved       at 0 range 10 .. 30;
      Interrupt      at 0 range 31 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- CLIC/CLINT
   ----------------------------------------------------------------------------

   msip_ADDRESS : constant := 16#0200_0000#;

   msip : aliased Unsigned_32 with
      Address              => To_Address (msip_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- threshold

   type threshold_Type is
   record
      Threshold : Bits_3;  -- Sets the priority threshold
      Reserved  : Bits_29;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for threshold_Type use
   record
      Threshold at 0 range 0 .. 2;
      Reserved  at 0 range 3 .. 31;
   end record;

   threshold_ADDRESS_OFFSET : constant := 16#0020_0000#;

   ----------------------------------------------------------------------------
   -- mtime/mtimecmp
   ----------------------------------------------------------------------------

   mtime_ADDRESS : constant := 16#0200_BFF8#;

   mtime : RISCV_Definitions.mtime_Type with
      Address    => To_Address (mtime_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   mtimecmp_ADDRESS : constant := 16#0200_4000#;

   mtimecmp : RISCV_Definitions.mtime_Type with
      Address    => To_Address (mtimecmp_ADDRESS),
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
   function mcause_Read return Unsigned_32 with
      Inline => True;
   function mepc_Read return Unsigned_32 with
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
