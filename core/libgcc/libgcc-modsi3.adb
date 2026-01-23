-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-modsi3.adb                                                                                         --
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
function ModSI3
   (N : GCC.Types.SI_Type;
    D : GCC.Types.SI_Type)
   return GCC.Types.SI_Type
   is
   function To_USI is new Ada.Unchecked_Conversion (GCC.Types.SI_Type, GCC.Types.USI_Type);
   function To_SI is new Ada.Unchecked_Conversion (GCC.Types.USI_Type, GCC.Types.SI_Type);
   Num      : GCC.Types.SI_Type := N;
   Den      : GCC.Types.SI_Type := D;
   Negative : Boolean;
   Result   : GCC.Types.SI_Type;
begin
   Negative := False;
   if Num < 0 then
      Negative := True;
      Num := -@;
   end if;
   if Den < 0 then
      Den := -@;
   end if;
   Result := To_SI (UDivModSI4 (To_USI (Num), To_USI (Den), True));
   if Negative then
      Result := -@;
   end if;
   return Result;
end ModSI3;
