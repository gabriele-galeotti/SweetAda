-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_integer_address.adb                                                                         --
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

separate (Console)
procedure Print_Integer_Address (
                                 Value  : in SSE.Integer_Address;
                                 NL     : in Boolean := False;
                                 Prefix : in String := "";
                                 Suffix : in String := ""
                                ) is
   IAddress        : SSE.Integer_Address := Value;
   MDigits         : constant Natural := (SSE.Integer_Address'Size + 3) / 4;
   Address_Digit   : Interfaces.Unsigned_8;
   Address_Literal : String (1 .. MDigits);
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   for Index in reverse 1 .. MDigits loop
      Address_Digit := Interfaces.Unsigned_8 (IAddress mod 2**4);
      LLutils.U8_To_HexDigit (
         Value => Address_Digit,
         MSD   => False,
         LCase => False,
         C     => Address_Literal (Index)
         );
      IAddress := @ / 2**4;
   end loop;
   Print (Address_Literal);
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_Integer_Address;
