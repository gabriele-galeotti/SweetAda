-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-muldi3.adb                                                                                         --
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

with Ada.Unchecked_Conversion;

separate (LibGCC)
function MulDI3
   (M1 : GCC.Types.UDI_Type;
    M2 : GCC.Types.UDI_Type)
   return GCC.Types.UDI_Type
   is
   function To_USI_2 is new Ada.Unchecked_Conversion (GCC.Types.UDI_Type, USI_2);
   function To_UDI is new Ada.Unchecked_Conversion (USI_2, GCC.Types.UDI_Type);
   T_M1    : constant USI_2 := To_USI_2 (M1);
   T_M2    : constant USI_2 := To_USI_2 (M2);
   M1_HIGH : GCC.Types.USI_Type renames T_M1 (HI64);
   M1_LOW  : GCC.Types.USI_Type renames T_M1 (LO64);
   M2_HIGH : GCC.Types.USI_Type renames T_M2 (HI64);
   M2_LOW  : GCC.Types.USI_Type renames T_M2 (LO64);
   R       : USI_2;
   R_HIGH  : GCC.Types.USI_Type renames R (HI64);
   R_LOW   : GCC.Types.USI_Type renames R (LO64);
begin
   R := To_USI_2 (UMulSIDI3 (M1_LOW, M2_LOW));
   R_HIGH := @ + M1_LOW * M2_HIGH + M1_HIGH * M2_LOW;
   return To_UDI (R);
end MulDI3;
