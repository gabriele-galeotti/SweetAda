-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-umulsidi3.adb                                                                                      --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;
with Bits;

   separate (LibGCC)
   function UMulSIDI3 (
                       M1 : GCC_Types.USI_Type;
                       M2 : GCC_Types.USI_Type
                      ) return GCC_Types.UDI_Type is
      function To_UDI is new Ada.Unchecked_Conversion (USI_2, GCC_Types.UDI_Type);
      R      : USI_2;
      R_HIGH : GCC_Types.USI_Type renames R (Bits.H64_32_IDX);
      R_LOW  : GCC_Types.USI_Type renames R (Bits.L64_32_IDX);
   begin
      UMul32x32 (M1, M2, R_HIGH, R_LOW);
      return To_UDI (R);
   end UMulSIDI3;
