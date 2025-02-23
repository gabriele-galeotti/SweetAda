-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv5te.ads                                                                                               --
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

with ARMv4;

package ARMv5TE
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ARM Architecture Reference Manual
   -- ARM DDI 0100I
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      renames ARMv4.NOP;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is ARMv4.Intcontext_Type;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      renames ARMv4.Intcontext_Get;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      renames ARMv4.Intcontext_Set;

   procedure Irq_Enable
      renames ARMv4.Irq_Enable;
   procedure Irq_Disable
      renames ARMv4.Irq_Disable;

pragma Style_Checks (On);

end ARMv5TE;
