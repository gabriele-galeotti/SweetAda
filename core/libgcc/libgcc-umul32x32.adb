-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-umul32x32.adb                                                                                      --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

separate (LibGCC)
procedure UMul32x32 (
                     M1 : in  GCC_Types.USI_Type;
                     M2 : in  GCC_Types.USI_Type;
                     RH : out GCC_Types.USI_Type;
                     RL : out GCC_Types.USI_Type
                    ) is
   M1_LOW  : constant GCC_Types.USI_Type := M1 mod 2**16;
   M1_HIGH : constant GCC_Types.USI_Type := M1 / 2**16;
   M2_LOW  : constant GCC_Types.USI_Type := M2 mod 2**16;
   M2_HIGH : constant GCC_Types.USI_Type := M2 / 2**16;
   I0      : GCC_Types.USI_Type;
   I1      : GCC_Types.USI_Type;
   I2      : GCC_Types.USI_Type;
   I3      : GCC_Types.USI_Type;
begin
   I0 := M2_LOW * M1_LOW;
   I1 := M2_LOW * M1_HIGH;
   I2 := M2_HIGH * M1_LOW;
   I3 := M2_HIGH * M1_HIGH;
   I1 := @ + (I0 / 2**16);
   I1 := @ + I2;
   if I1 < I2 then
      I3 := @ + 2**16;
   end if;
   RH := I3 + (I1 / 2**16);
   RL := ((I1 mod 2**16) * 2**16) + (I0 mod 2**16);
end UMul32x32;
