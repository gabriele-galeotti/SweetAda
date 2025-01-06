-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-udivmoddi4.adb                                                                                     --
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

separate (LibGCC)
function UDivModDI4
   (N : in     GCC_Types.UDI_Type;
    D : in     GCC_Types.UDI_Type;
    R : in out GCC_Types.UDI_Type)
   return GCC_Types.UDI_Type
   is
   function Is_Negative
      (Value : GCC_Types.UDI_Type)
      return Boolean
      is
      ((Value and 16#8000_0000_0000_0000#) /= 0)
      with Inline => True;
   Num   : GCC_Types.UDI_Type := N;
   Den   : GCC_Types.UDI_Type := D;
   Q     : GCC_Types.UDI_Type;
   Qaddp : GCC_Types.UDI_Type;
begin
   Q := 0;
   Qaddp := 1;
   while not Is_Negative (Den) loop
      Den := GCC_Types.Shift_Left (@, 1);
      Qaddp := GCC_Types.Shift_Left (@, 1);
   end loop;
   while Qaddp /= 0 loop
      if Den <= Num then
         Num := @ - Den;
         Q := @ + Qaddp;
      end if;
      Den := GCC_Types.Shift_Right (@, 1);
      Qaddp := GCC_Types.Shift_Right (@, 1);
   end loop;
   -- return R if flagged
   if R /= 0 then
      R := Num;
   end if;
   return Q;
end UDivModDI4;
