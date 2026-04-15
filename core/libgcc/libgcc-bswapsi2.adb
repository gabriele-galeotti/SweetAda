-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-bswapsi2.adb                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;

separate (LibGCC)
function BswapSI2
   (V : GCC.Types.SI_Type)
   return GCC.Types.SI_Type
   is
   function To_USI is new Ada.Unchecked_Conversion (GCC.Types.SI_Type, GCC.Types.USI_Type);
   function To_SI is new Ada.Unchecked_Conversion (GCC.Types.USI_Type, GCC.Types.SI_Type);
   UV : constant GCC.Types.USI_Type := To_USI (V);
begin
   return To_SI (
             GCC.Types.Shift_Right (UV and 16#FF00_0000#, 24) or
             GCC.Types.Shift_Right (UV and 16#00FF_0000#, 8) or
             GCC.Types.Shift_Left (UV and 16#0000_FF00#, 8) or
             GCC.Types.Shift_Left (UV and 16#0000_00FF#, 24)
             );
end BswapSI2;
