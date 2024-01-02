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
with Bits;
with x86;

package Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;
   use x86;

   Div_By_0_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "div_by_0_handler";
   Debug_Exception_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "debug_exception_handler";
   Nmi_Interrupt_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "nmi_interrupt_handler";
   One_Byte_Int_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "one_byte_int_handler";
   Int_On_Overflow_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "int_on_overflow_handler";
   Array_Bounds_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "array_bounds_handler";
   Invalid_Opcode_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "invalid_opcode_handler";
   Device_Not_Avl_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "device_not_avl_handler";
   Double_Fault_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "double_fault_handler";
   Cp_Seg_Ovr_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "cp_seg_ovr_handler";
   Invalid_Tss_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "invalid_tss_handler";
   Seg_Not_Prsnt_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "seg_not_prsnt_handler";
   Stack_Fault_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "stack_fault_handler";
   Gen_Prot_Fault_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "gen_prot_fault_handler";
   Page_Fault_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "page_fault_handler";
   Coproc_Error_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "coproc_error_handler";
   Irq0_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq0_handler";
   Irq1_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq1_handler";
   Irq2_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq2_handler";
   Irq3_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq3_handler";
   Irq4_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq4_handler";
   Irq5_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq5_handler";
   Irq6_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq6_handler";
   Irq7_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq7_handler";
   Irq8_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq8_handler";
   Irq9_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq9_handler";
   Irq10_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq10_handler";
   Irq11_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq11_handler";
   Irq12_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq12_handler";
   Irq13_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq13_handler";
   Irq14_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq14_handler";
   Irq15_Handler : aliased Asm_Entry_Point with
      Import        => True,
      Convention    => Asm,
      External_Name => "irq15_handler";

   procedure Exception_Process (
                                Exception_Identifier          : in Exception_Id_Type;
                                Exception_Stack_Frame_Address : in Address
                               ) with
      Export        => True,
      Convention    => Asm,
      External_Name => "exception_process";

   procedure Irq_Process (Irq_Identifier : in Irq_Id_Type) with
      Export        => True,
      Convention    => Asm,
      External_Name => "irq_process";

   procedure Init;

end Exceptions;
