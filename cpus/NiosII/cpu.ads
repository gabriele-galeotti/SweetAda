-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu.ads                                                                                                   --
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
with NiosII;

package CPU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP renames NiosII.NOP;

   procedure Asm_Call (Target_Address : in Address) renames NiosII.Asm_Call;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is NiosII.Irq_State_Type;

   procedure Irq_Enable                                    renames NiosII.Irq_Enable;
   procedure Irq_Disable                                   renames NiosII.Irq_Disable;
   function Irq_State_Get return Irq_State_Type            renames NiosII.Irq_State_Get;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) renames NiosII.Irq_State_Set;

end CPU;
