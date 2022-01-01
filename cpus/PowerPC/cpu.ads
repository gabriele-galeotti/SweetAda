-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with PowerPC;

package CPU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is PowerPC.Irq_State_Type;

   procedure Irq_Enable                                    renames PowerPC.Irq_Enable;
   procedure Irq_Disable                                   renames PowerPC.Irq_Disable;
   function Irq_State_Get return Irq_State_Type            renames PowerPC.Irq_State_Get;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) renames PowerPC.Irq_State_Set;

end CPU;
