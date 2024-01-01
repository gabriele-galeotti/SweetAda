-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_boolean.adb                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

separate (Console)
procedure Print_Boolean
   (Value  : in Boolean;
    NL     : in Boolean := False;
    Prefix : in String := "";
    Suffix : in String := "")
   is
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   Print (Character'(if Value then 'T' else 'F'));
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_Boolean;
