-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ libgcc-udivmodsi4.adb                                                                                     --
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
function UDivModSI4 (
                     N : GCC_Types.USI_Type;
                     D : GCC_Types.USI_Type;
                     M : Boolean
                    ) return GCC_Types.USI_Type is
   function Is_Negative (Value : GCC_Types.USI_Type) return Boolean with
      Inline => True;
   function Is_Negative (Value : GCC_Types.USI_Type) return Boolean is
   begin
      return (Value and 16#8000_0000#) /= 0;
   end Is_Negative;
   Num    : GCC_Types.USI_Type := N;
   Den    : GCC_Types.USI_Type := D;
   Bit    : GCC_Types.USI_Type;
   Result : GCC_Types.USI_Type;
begin
   Bit := 1;
   Result := 0;
   while Den < Num and then Bit /= 0 and then not Is_Negative (Den) loop
      Den := GCC_Types.Shift_Left (@, 1);
      Bit := GCC_Types.Shift_Left (@, 1);
   end loop;
   while Bit /= 0 loop
      if Num >= Den then
         Num := @ - Den;
         Result := @ or Bit;
      end if;
      Bit := GCC_Types.Shift_Right (@, 1);
      Den := GCC_Types.Shift_Right (@, 1);
   end loop;
   if M then
      return Num;
   else
      return Result;
   end if;
end UDivModSI4;
