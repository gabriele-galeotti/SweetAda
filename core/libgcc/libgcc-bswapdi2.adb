-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-bswapdi2.adb                                                                                       --
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
function BswapDI2
   (V : GCC.Types.DI_Type)
   return GCC.Types.DI_Type
   is
   function To_UDI is new Ada.Unchecked_Conversion (GCC.Types.DI_Type, GCC.Types.UDI_Type);
   function To_DI is new Ada.Unchecked_Conversion (GCC.Types.UDI_Type, GCC.Types.DI_Type);
   UV : constant GCC.Types.UDI_Type := To_UDI (V);
begin

   return To_DI (
             GCC.Types.Shift_Right (UV and 16#FF00_0000_0000_0000#, 56) or
             GCC.Types.Shift_Right (UV and 16#00FF_0000_0000_0000#, 40) or
             GCC.Types.Shift_Right (UV and 16#0000_FF00_0000_0000#, 24) or
             GCC.Types.Shift_Right (UV and 16#0000_00FF_0000_0000#, 8) or
             GCC.Types.Shift_Left (UV and 16#0000_0000_FF00_0000#, 8) or
             GCC.Types.Shift_Left (UV and 16#0000_0000_00FF_0000#, 24) or
             GCC.Types.Shift_Left (UV and 16#0000_0000_0000_FF00#, 40) or
             GCC.Types.Shift_Left (UV and 16#0000_0000_0000_00FF#, 56)
             );
end BswapDI2;
