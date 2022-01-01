-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdt_simple.ads                                                                                            --
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

with CPU;

package GDT_Simple is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use CPU.x86;

   SELECTOR_KCODE : constant Selector_Type := (RPL => PL0, TI => TI_GDT, Index => 1);
   SELECTOR_KDATA : constant Selector_Type := (RPL => PL0, TI => TI_GDT, Index => 2);
   -- SELECTOR_UCODE : constant Selector_Type := (RPL => PL3, TI => TI_GDT, Index => 3);
   -- SELECTOR_UDATA : constant Selector_Type := (RPL => PL3, TI => TI_GDT, Index => 4);

   procedure Setup;

end GDT_Simple;
