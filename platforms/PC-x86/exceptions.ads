-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;
with CPU;

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
   use CPU.x86;

   Div_By_0_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Div_By_0_Handler, "div_by_0_handler");
   Debug_Exception_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Debug_Exception_Handler, "debug_exception_handler");
   Nmi_Interrupt_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Nmi_Interrupt_Handler, "nmi_interrupt_handler");
   One_Byte_Int_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, One_Byte_Int_Handler, "one_byte_int_handler");
   Int_On_Overflow_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Int_On_Overflow_Handler, "int_on_overflow_handler");
   Array_Bounds_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Array_Bounds_Handler, "array_bounds_handler");
   Invalid_Opcode_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Invalid_Opcode_Handler, "invalid_opcode_handler");
   Device_Not_Avl_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Device_Not_Avl_Handler, "device_not_avl_handler");
   Double_Fault_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Double_Fault_Handler, "double_fault_handler");
   Cp_Seg_Ovr_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Cp_Seg_Ovr_Handler, "cp_seg_ovr_handler");
   Invalid_Tss_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Invalid_Tss_Handler, "invalid_tss_handler");
   Seg_Not_Prsnt_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Seg_Not_Prsnt_Handler, "seg_not_prsnt_handler");
   Stack_Fault_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Stack_Fault_Handler, "stack_fault_handler");
   Gen_Prot_Fault_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Gen_Prot_Fault_Handler, "gen_prot_fault_handler");
   Page_Fault_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Page_Fault_Handler, "page_fault_handler");
   Coproc_Error_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Coproc_Error_Handler, "coproc_error_handler");
   Irq0_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq0_Handler, "irq0_handler");
   Irq1_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq1_Handler, "irq1_handler");
   Irq2_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq2_Handler, "irq2_handler");
   Irq3_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq3_Handler, "irq3_handler");
   Irq4_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq4_Handler, "irq4_handler");
   Irq5_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq5_Handler, "irq5_handler");
   Irq6_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq6_Handler, "irq6_handler");
   Irq7_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq7_Handler, "irq7_handler");
   Irq8_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq8_Handler, "irq8_handler");
   Irq9_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq9_Handler, "irq9_handler");
   Irq10_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq10_Handler, "irq10_handler");
   Irq11_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq11_Handler, "irq11_handler");
   Irq12_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq12_Handler, "irq12_handler");
   Irq13_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq13_Handler, "irq13_handler");
   Irq14_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq14_Handler, "irq14_handler");
   Irq15_Handler : aliased Asm_Entry_Point;
   pragma Import (Asm, Irq15_Handler, "irq15_handler");

   procedure Process (
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
