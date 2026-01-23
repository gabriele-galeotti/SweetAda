-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-moddi3.adb                                                                                         --
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
function ModDI3
   (N : GCC.Types.DI_Type;
    D : GCC.Types.DI_Type)
   return GCC.Types.DI_Type
   is
   function To_UDI is new Ada.Unchecked_Conversion (GCC.Types.DI_Type, GCC.Types.UDI_Type);
   function To_DI is new Ada.Unchecked_Conversion (GCC.Types.UDI_Type, GCC.Types.DI_Type);
   Num      : GCC.Types.DI_Type := N;
   Den      : GCC.Types.DI_Type := D;
   Negative : Boolean;
   Q        : GCC.Types.DI_Type with Unreferenced => True;
   R        : GCC.Types.UDI_Type;
   Rsigned  : GCC.Types.DI_Type;
begin
   Negative := False;
   if Num < 0 then
      Negative := not @;
      Num := -@;
   end if;
   if Den < 0 then
      Den := -@;
   end if;
   R := 1;
   Q := To_DI (UDivModDI4 (To_UDI (Num), To_UDI (Den), R));
   Rsigned := To_DI (R);
   if Negative then
      Rsigned := -@;
   end if;
   return Rsigned;
end ModDI3;
