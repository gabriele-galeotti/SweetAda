-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_string.adb                                                                                  --
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
procedure Print_String
   (Value  : in String;
    Limit  : in Natural := Maximum_String_Length;
    NL     : in Boolean := False;
    Prefix : in String := "";
    Suffix : in String := "")
   is
begin
   if Prefix'Length /= 0 then
      Print_StringSimple (Prefix);
   end if;
   Print_StringSimple (Value, Limit, False);
   if Suffix'Length /= 0 then
      Print_StringSimple (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_String;
