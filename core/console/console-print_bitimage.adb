-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_bitimage.adb                                                                                --
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

separate (Console)
procedure Print_BitImage
   (Value  : in Interfaces.Unsigned_8;
    NL     : in Boolean := False;
    Prefix : in String := "";
    Suffix : in String := "")
   is
   use type Interfaces.Unsigned_8;
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   for Index in reverse 0 .. Interfaces.Unsigned_8'Size - 1 loop
      if (Value and Interfaces.Shift_Left (1, Index)) /= 0 then
         Print (Character'('1'));
      else
         Print (Character'('0'));
      end if;
   end loop;
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_BitImage;
