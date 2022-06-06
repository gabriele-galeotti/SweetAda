-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-divsi3.adb                                                                                         --
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

separate (LibGCC)
function DivSI3 (
                 N : GCC_Types.SI_Type;
                 D : GCC_Types.SI_Type
                ) return GCC_Types.SI_Type is
   function To_USI is new Ada.Unchecked_Conversion (GCC_Types.SI_Type, GCC_Types.USI_Type);
   function To_SI is new Ada.Unchecked_Conversion (GCC_Types.USI_Type, GCC_Types.SI_Type);
   Num      : GCC_Types.SI_Type := N;
   Den      : GCC_Types.SI_Type := D;
   Negative : Boolean;
   Result   : GCC_Types.SI_Type;
begin
   Negative := False;
   if N < 0 then
      Negative := not @;
      Num := -@;
   end if;
   if Den < 0 then
      Negative := not @;
      Den := -@;
   end if;
   Result := To_SI (UDivModSI4 (To_USI (Num), To_USI (Den), False));
   if Negative then
      Result := -@;
   end if;
   return Result;
end DivSI3;
