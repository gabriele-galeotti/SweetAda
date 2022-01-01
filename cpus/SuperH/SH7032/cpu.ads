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

with SH;

package CPU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is SH.Irq_State_Type;

   procedure Irq_Enable                                    renames SH.Irq_Enable;
   procedure Irq_Disable                                   renames SH.Irq_Disable;
   function Irq_State_Get return Irq_State_Type            renames SH.Irq_State_Get;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) renames SH.Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out SH.Lock_Type; Success : out Boolean) renames SH.Lock_Try;
   procedure Lock (Lock_Object : in out SH.Lock_Type)                            renames SH.Lock;
   procedure Unlock (Lock_Object : out SH.Lock_Type)                             renames SH.Unlock;

end CPU;
