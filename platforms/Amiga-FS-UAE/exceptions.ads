-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
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

package Exceptions
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
   use M68k;

   -- By marking IVT with a Suppress_Initialization aspect, we can avoid
   -- place it in the .data section, which leads to a waste of space due to
   -- alignment.
   IVT : aliased Exception_Vector_Table_Type
      with Suppress_Initialization => True;

   ----------------------------------------------------------------------------
   -- Exception Handlers
   ----------------------------------------------------------------------------

   -- 000 stack pointer
   -- 001 reset vector
   Accfault_Handler                     : aliased Asm_Entry_Point -- 002
      with Import => True, External_Name => "accfault_handler";
   Addrerr_Handler                      : aliased Asm_Entry_Point -- 003
      with Import => True, External_Name => "addrerr_handler";
   Illinstr_Handler                     : aliased Asm_Entry_Point -- 004
      with Import => True, External_Name => "illinstr_handler";
   Div0_Handler                         : aliased Asm_Entry_Point -- 005
      with Import => True, External_Name => "div0_handler";
   Chkinstr_Handler                     : aliased Asm_Entry_Point -- 006
      with Import => True, External_Name => "chkinstr_handler";
   FTrapcc_Handler                      : aliased Asm_Entry_Point -- 007
      with Import => True, External_Name => "ftrapcc_handler";
   PrivilegeV_Handler                   : aliased Asm_Entry_Point -- 008
      with Import => True, External_Name => "privilegev_handler";
   Trace_Handler                        : aliased Asm_Entry_Point -- 009
      with Import => True, External_Name => "trace_handler";
   Line1010_Handler                     : aliased Asm_Entry_Point -- 010
      with Import => True, External_Name => "line1010_handler";
   Line1111_Handler                     : aliased Asm_Entry_Point -- 011
      with Import => True, External_Name => "line1111_handler";
   -- 012 is reserved
   CProtocolV_Handler                   : aliased Asm_Entry_Point -- 013
      with Import => True, External_Name => "cprotocolv_handler";
   Formaterr_Handler                    : aliased Asm_Entry_Point -- 014
      with Import => True, External_Name => "formaterr_handler";
   Uninitint_Handler                    : aliased Asm_Entry_Point -- 015
      with Import => True, External_Name => "uninitint_handler";
   -- 016 is reserved
   -- 017 is reserved
   -- 018 is reserved
   -- 019 is reserved
   -- 020 is reserved
   -- 021 is reserved
   -- 022 is reserved
   -- 023 is reserved
   Spurious_Interrupt_Handler           : aliased Asm_Entry_Point -- 024
      with Import => True, External_Name => "spurious_handler";
   Level_1_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 025
      with Import => True, External_Name => "l1autovector_handler";
   Level_2_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 026
      with Import => True, External_Name => "l2autovector_handler";
   Level_3_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 027
      with Import => True, External_Name => "l3autovector_handler";
   Level_4_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 028
      with Import => True, External_Name => "l4autovector_handler";
   Level_5_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 029
      with Import => True, External_Name => "l5autovector_handler";
   Level_6_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 030
      with Import => True, External_Name => "l6autovector_handler";
   Level_7_Interrupt_Autovector_Handler : aliased Asm_Entry_Point -- 031
      with Import => True, External_Name => "l7autovector_handler";
   -- 032 trap0
   -- 033 trap1
   -- 034 trap2
   -- 035 trap3
   -- 036 trap4
   -- 037 trap5
   -- 038 trap6
   -- 039 trap7
   -- 040 trap8
   -- 041 trap9
   -- 042 trap10
   -- 043 trap11
   -- 044 trap12
   -- 045 trap13
   -- 046 trap14
   Trap_15_Handler                      : aliased Asm_Entry_Point -- 047
      with Import => True, External_Name => "trap15_handler";

   procedure Exception_Process
      (Exception_Number : in Unsigned_32;
       Frame_Address    : in Address)
      with Export        => True,
           Convention    => Asm,
           External_Name => "exception_process";

   procedure Irq_Process
      (Irq_Identifier : in Exception_Vector_Id_Type)
      with Export        => True,
           Convention    => Asm,
           External_Name => "irq_process";

   procedure Init;

end Exceptions;
