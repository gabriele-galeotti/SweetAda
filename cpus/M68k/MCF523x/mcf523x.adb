-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf523x.adb                                                                                               --
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

package body MCF523x
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function IRQ_Index
      (IRQ       : INTC0_Source_Type;
       VTHandler : Boolean)
      return Natural
      is
      Index : Natural;
   begin
      Index := 63 - IRQ'Enum_Rep;
      if VTHandler then
         Index := @ + 64;
      end if;
      return Index;
   end IRQ_Index;

   function IRQ_Index
      (IRQ       : INTC1_Source_Type;
       VTHandler : Boolean)
      return Natural
      is
      Index : Natural;
   begin
      Index := 63 - IRQ'Enum_Rep;
      if VTHandler then
         Index := @ + 128;
      end if;
      return Index;
   end IRQ_Index;

end MCF523x;
