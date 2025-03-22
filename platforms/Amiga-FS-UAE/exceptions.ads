-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
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
   Accessfault_Handler       : aliased Asm_Entry_Point with Import => True, External_Name => "VH_accessfault";
   Addresserr_Handler        : aliased Asm_Entry_Point with Import => True, External_Name => "VH_addresserr";
   Illinstr_Handler          : aliased Asm_Entry_Point with Import => True, External_Name => "VH_illinstr";
   Div0_Handler              : aliased Asm_Entry_Point with Import => True, External_Name => "VH_div0";
   Chkinstr_Handler          : aliased Asm_Entry_Point with Import => True, External_Name => "VH_chkinstr";
   FTRAPcc_Handler           : aliased Asm_Entry_Point with Import => True, External_Name => "VH_ftrapcc";
   PrivilegeV_Handler        : aliased Asm_Entry_Point with Import => True, External_Name => "VH_privilegev";
   Trace_Handler             : aliased Asm_Entry_Point with Import => True, External_Name => "VH_trace";
   Line1010_Handler          : aliased Asm_Entry_Point with Import => True, External_Name => "VH_line1010";
   Line1111_Handler          : aliased Asm_Entry_Point with Import => True, External_Name => "VH_line1111";
   -- 012 is reserved
   CPProtocolV_Handler       : aliased Asm_Entry_Point with Import => True, External_Name => "VH_cpprotocolv";
   Formaterr_Handler         : aliased Asm_Entry_Point with Import => True, External_Name => "VH_formaterr";
   UninitInt_Handler         : aliased Asm_Entry_Point with Import => True, External_Name => "VH_uninitint";
   -- 016 is reserved
   -- 017 is reserved
   -- 018 is reserved
   -- 019 is reserved
   -- 020 is reserved
   -- 021 is reserved
   -- 022 is reserved
   -- 023 is reserved
   SpuriousInt_Handler       : aliased Asm_Entry_Point with Import => True, External_Name => "VH_spuriousint";
   Level1_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l1autovector";
   Level2_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l2autovector";
   Level3_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l3autovector";
   Level4_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l4autovector";
   Level5_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l5autovector";
   Level6_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l6autovector";
   Level7_Autovector_Handler : aliased Asm_Entry_Point with Import => True, External_Name => "VH_l7autovector";
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
   Trap_15_Handler           : aliased Asm_Entry_Point with Import => True, External_Name => "VH_trap15";

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
