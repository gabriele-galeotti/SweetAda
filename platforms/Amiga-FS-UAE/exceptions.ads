-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
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
with Interfaces;
with Bits;
with M68k;

package Exceptions is

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
   use M68k;

   -- By marking IVT with a Suppress_Initialization aspect, we can avoid
   -- place it in the .data section, which leads to a waste of space due to
   -- alignment.
   IVT : aliased Exception_Vector_Table_Type with
      Suppress_Initialization => True;

   ----------------------------------------------------------------------------
   -- Exception Handlers
   ----------------------------------------------------------------------------

   -- 000 stack pointer
   -- 001 reset vector
   -- 002
   Buserr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "buserr_handler";
   -- 003
   Addrerr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "addrerr_handler";
   -- 004
   Illinstr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "illinstr_handler";
   -- 005
   Div0_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "div0_handler";
   -- 006
   Chkinstr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "chkinstr_handler";
   -- 007
   Trapc_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "trapc_handler";
   -- 008
   PrivilegeV_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "privilegev_handler";
   -- 009
   Trace_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "trace_handler";
   -- 010
   Line1010_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "line1010_handler";
   -- 011
   Line1111_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "line1111_handler";
   -- 012 is reserved
   -- 013
   CProtocolV_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "cprotocolv_handler";
   -- 014
   Formaterr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "formaterr_handler";
   -- 015
   Uninitint_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "uninitint_handler";
   -- 016 is reserved
   -- 017 is reserved
   -- 018 is reserved
   -- 019 is reserved
   -- 020 is reserved
   -- 021 is reserved
   -- 022 is reserved
   -- 023 is reserved
   -- 024
   Spurious_Interrupt_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "spurious_handler";
   -- 025
   Level_1_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l1autovector_handler";
   -- 026
   Level_2_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l2autovector_handler";
   -- 027
   Level_3_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l3autovector_handler";
   -- 028
   Level_4_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l4autovector_handler";
   -- 029
   Level_5_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l5autovector_handler";
   -- 030
   Level_6_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l6autovector_handler";
   -- 031
   Level_7_Interrupt_Autovector_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "l7autovector_handler";
   -- 047
   Trap_15_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "trap15_handler";

   procedure Process (Exception_Number : in Unsigned_32; Frame_Address : in Address) with
      Export        => True,
      Convention    => Asm,
      External_Name => "exception_process";
   procedure Irq_Process (Irq_Identifier : in Exception_Vector_Id_Type) with
      Export        => True,
      Convention    => Asm,
      External_Name => "irq_process";
   procedure Init;

end Exceptions;
