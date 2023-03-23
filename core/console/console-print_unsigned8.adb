-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_unsigned8.adb                                                                               --
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
procedure Print_Unsigned8 (
                           Value  : in Interfaces.Unsigned_8;
                           NL     : in Boolean := False;
                           Prefix : in String := "";
                           Suffix : in String := ""
                          ) is
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   Print_UnsignedHex8 (Value);
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_Unsigned8;