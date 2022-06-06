-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-mulsi3.adb                                                                                         --
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

separate (LibGCC)
function MulSI3 (
                 M1 : GCC_Types.USI_Type;
                 M2 : GCC_Types.USI_Type
                ) return GCC_Types.USI_Type is
   T_M1 : GCC_Types.USI_Type := M1;
   T_M2 : GCC_Types.USI_Type := M2;
   R    : GCC_Types.USI_Type := 0;
begin
   while T_M1 /= 0 loop
      if (T_M1 and 1) /= 0 then
         R := @ + T_M2;
      end if;
      T_M1 := GCC_Types.Shift_Right (@, 1);
      T_M2 := GCC_Types.Shift_Left (@, 1);
   end loop;
   return R;
end MulSI3;
