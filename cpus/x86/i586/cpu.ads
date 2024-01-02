-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu.ads                                                                                                   --
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
with x86;

package CPU
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP renames x86.NOP;

   procedure Asm_Call (Target_Address : in System.Address) renames x86.Asm_Call;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type    is x86.Irq_State_Type;
   subtype Exception_Id_Type is x86.Exception_Id_Type;
   subtype Irq_Id_Type       is x86.Irq_Id_Type;

   procedure Irq_Enable                                    renames x86.Irq_Enable;
   procedure Irq_Disable                                   renames x86.Irq_Disable;
   function Irq_State_Get return Irq_State_Type            renames x86.Irq_State_Get;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) renames x86.Irq_State_Set;

end CPU;
