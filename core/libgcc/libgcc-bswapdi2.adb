-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-bswapdi2.adb                                                                                       --
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

separate (LibGCC)
function BswapDI2
   (V : GCC_Types.UDI_Type)
   return GCC_Types.UDI_Type
   is
begin
   return GCC_Types.Shift_Right (V and 16#FF00_0000_0000_0000#, 56) or
          GCC_Types.Shift_Right (V and 16#00FF_0000_0000_0000#, 40) or
          GCC_Types.Shift_Right (V and 16#0000_FF00_0000_0000#, 24) or
          GCC_Types.Shift_Right (V and 16#0000_00FF_0000_0000#, 8) or
          GCC_Types.Shift_Left (V and 16#0000_0000_FF00_0000#, 8) or
          GCC_Types.Shift_Left (V and 16#0000_0000_00FF_0000#, 24) or
          GCC_Types.Shift_Left (V and 16#0000_0000_0000_FF00#, 40) or
          GCC_Types.Shift_Left (V and 16#0000_0000_0000_00FF#, 56);
end BswapDI2;
