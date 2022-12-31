-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-adddi3.adb                                                                                         --
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

with Ada.Unchecked_Conversion;
with Bits;

separate (LibGCC)
function AddDI3 (
                 A1 : GCC_Types.UDI_Type;
                 A2 : GCC_Types.UDI_Type
                ) return GCC_Types.UDI_Type is
   function To_USI_2 is new Ada.Unchecked_Conversion (GCC_Types.UDI_Type, USI_2);
   function To_UDI is new Ada.Unchecked_Conversion (USI_2, GCC_Types.UDI_Type);
   T_A1    : constant USI_2 := To_USI_2 (A1);
   T_A2    : constant USI_2 := To_USI_2 (A2);
   A1_HIGH : GCC_Types.USI_Type renames T_A1 (Bits.H64_32_IDX);
   A1_LOW  : GCC_Types.USI_Type renames T_A1 (Bits.L64_32_IDX);
   A2_HIGH : GCC_Types.USI_Type renames T_A2 (Bits.H64_32_IDX);
   A2_LOW  : GCC_Types.USI_Type renames T_A2 (Bits.L64_32_IDX);
   R       : USI_2;
   R_HIGH  : GCC_Types.USI_Type renames R (Bits.H64_32_IDX);
   R_LOW   : GCC_Types.USI_Type renames R (Bits.L64_32_IDX);
begin
   R_LOW  := A1_LOW  + A2_LOW;
   R_HIGH := A1_HIGH + A2_HIGH;
   -- if the intermediate result is less than any one of the addends, this
   -- is an indication of overflow, so a carry bit must be propagated
   if R_LOW < A1_LOW then
      R_HIGH := R_HIGH + 1;
   end if;
   return To_UDI (R);
end AddDI3;
