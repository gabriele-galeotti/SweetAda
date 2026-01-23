-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-udivmodsi4.adb                                                                                     --
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

separate (LibGCC)
function UDivModSI4
   (N : GCC.Types.USI_Type;
    D : GCC.Types.USI_Type;
    M : Boolean)
   return GCC.Types.USI_Type
   is
   function Is_Negative
      (Value : GCC.Types.USI_Type)
      return Boolean
      is
      ((Value and 16#8000_0000#) /= 0)
      with Inline => True;
   Num    : GCC.Types.USI_Type := N;
   Den    : GCC.Types.USI_Type := D;
   Bit    : GCC.Types.USI_Type;
   Result : GCC.Types.USI_Type;
begin
   Bit := 1;
   Result := 0;
   while Den < Num and then Bit /= 0 and then not Is_Negative (Den) loop
      Den := GCC.Types.Shift_Left (@, 1);
      Bit := GCC.Types.Shift_Left (@, 1);
   end loop;
   while Bit /= 0 loop
      if Num >= Den then
         Num := @ - Den;
         Result := @ or Bit;
      end if;
      Bit := GCC.Types.Shift_Right (@, 1);
      Den := GCC.Types.Shift_Right (@, 1);
   end loop;
   if M then
      Result := Num;
   end if;
   return Result;
end UDivModSI4;
