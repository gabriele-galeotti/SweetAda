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

   MXLEN renames RISCV_Definitions.XLEN;

   subtype MXLEN_Type is RISCV_Definitions.MXLEN_Type;

   ----------------------------------------------------------------------------
   -- 3.1.6 Machine Status Registers (mstatus and mstatush)
   ----------------------------------------------------------------------------

   subtype mstatus_Type is RISCV_Definitions.mstatus_Type;
   subtype mstatush_Type is RISCV_Definitions.mstatush_Type;

   ----------------------------------------------------------------------------
   -- 3.1.7 Machine Trap-Vector Base-Address Register (mtvec)
   ----------------------------------------------------------------------------

   MODE_Direct   : constant := 2#00#;
   MODE_Vectored : constant := 2#01#;

   mtvec_BASE_ADDRESS_LSB renames RISCV_Definitions.mtvec_BASE_ADDRESS_LSB;
   mtvec_BASE_ADDRESS_MSB renames RISCV_Definitions.mtvec_BASE_ADDRESS_MSB;

   subtype mtvec_Type      is RISCV_Definitions.mtvec_Type;
   subtype mtvec_BASE_Type is RISCV_Definitions.mtvec_BASE_Type;

   procedure mtvec_Write
      (mtvec : in mtvec_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 3.1.9 Machine Interrupt Registers (mip and mie)
   ----------------------------------------------------------------------------

   subtype mip_Type is RISCV_Definitions.mip_Type;
   subtype mie_Type is RISCV_Definitions.mie_Type;

   procedure mie_Set_Interrupt
      (mie : in mie_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 3.1.14 Machine Exception Program Counter (mepc)
   ----------------------------------------------------------------------------

   function mepc_Read
      return MXLEN_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 3.1.15 Machine Cause Register (mcause)
   ----------------------------------------------------------------------------

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

   subtype mcause_Type                is RISCV_Definitions.mcause_Type;
   subtype mcause_Exception_Code_Type is RISCV_Definitions.mcause_Exception_Code_Type;

   function mcause_Read
      return mcause_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 3.2.1 Machine Timer Registers (mtime and mtimecmp)
   ----------------------------------------------------------------------------

   subtype mtime_Type is RISCV_Definitions.mtime_Type;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;
   function Irq_State_Get
      return Irq_State_Type
      with Inline => True;
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      with Inline => True;

end RISCV;
