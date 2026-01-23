-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
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

package RISCV
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   MXLEN renames RISCV_Definitions.XLEN;

   subtype MXLEN_Type is RISCV_Definitions.MXLEN_Type;

   ----------------------------------------------------------------------------
   -- 3.1.5 Hart ID Register mhartid
   ----------------------------------------------------------------------------

   function mhartid_Read
      return MXLEN_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 3.1.6 Machine Status Registers (mstatus and mstatush)
   ----------------------------------------------------------------------------

   subtype mstatus_Type is RISCV_Definitions.mstatus_Type;
   subtype mstatush_Type is RISCV_Definitions.mstatush_Type;

   function mstatus_Read
      return mstatus_Type
      with Inline => True;
   procedure mstatus_Write
      (mstatus : in mstatus_Type)
      with Inline => True;
   procedure mstatus_Set
      (mstatus : in mstatus_Type)
      with Inline => True;

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

   String_EXC_INSTRADDRMIS  : aliased constant String := "Instruction address misaligned";
   String_EXC_INSTRACCFAULT : aliased constant String := "Instruction access fault";
   String_EXC_INSTRILL      : aliased constant String := "Illegal instruction";
   String_EXC_BREAKPT       : aliased constant String := "Breakpoint";
   String_EXC_LOADADDRMIS   : aliased constant String := "Load address misaligned";
   String_EXC_LOADACCFAULT  : aliased constant String := "Load access fault";
   String_EXC_STAMOADDRMIS  : aliased constant String := "Store/AMO address misaligned";
   String_EXC_STAMOACCFAULT : aliased constant String := "Store/AMO access fault";
   String_EXC_ENVCALLUMODE  : aliased constant String := "Environment call from U-mode";
   String_EXC_ENVCALLMMODE  : aliased constant String := "Environment call from M-mode";
   String_EXC_UNKNOWN       : aliased constant String := "UNKNOWN";

   MsgPtr_EXC_INSTRADDRMIS  : constant access constant String := String_EXC_INSTRADDRMIS'Access;
   MsgPtr_EXC_INSTRACCFAULT : constant access constant String := String_EXC_INSTRACCFAULT'Access;
   MsgPtr_EXC_INSTRILL      : constant access constant String := String_EXC_INSTRILL'Access;
   MsgPtr_EXC_BREAKPT       : constant access constant String := String_EXC_BREAKPT'Access;
   MsgPtr_EXC_LOADADDRMIS   : constant access constant String := String_EXC_LOADADDRMIS'Access;
   MsgPtr_EXC_LOADACCFAULT  : constant access constant String := String_EXC_LOADACCFAULT'Access;
   MsgPtr_EXC_STAMOADDRMIS  : constant access constant String := String_EXC_STAMOADDRMIS'Access;
   MsgPtr_EXC_STAMOACCFAULT : constant access constant String := String_EXC_STAMOACCFAULT'Access;
   MsgPtr_EXC_ENVCALLUMODE  : constant access constant String := String_EXC_ENVCALLUMODE'Access;
   MsgPtr_EXC_ENVCALLMMODE  : constant access constant String := String_EXC_ENVCALLMMODE'Access;
   MsgPtr_EXC_UNKNOWN       : constant access constant String := String_EXC_UNKNOWN'Access;

   subtype mcause_Type                is RISCV_Definitions.mcause_Type;
   subtype mcause_Exception_Code_Type is RISCV_Definitions.mcause_Exception_Code_Type;

   function mcause_Read
      return mcause_Type
      with Inline => True;

   function To_MXLEN
      (Value : mcause_Type)
      return MXLEN_Type
      with Inline => True;
   function To_mcause
      (Value : MXLEN_Type)
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
   procedure FENCE
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Boolean;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

end RISCV;
