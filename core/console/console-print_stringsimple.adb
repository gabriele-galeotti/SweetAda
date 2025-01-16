-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_stringsimple.adb                                                                            --
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

separate (Console)
procedure Print_StringSimple
   (S      : in String;
    Limit  : in Natural := Maximum_String_Length;
    NL     : in Boolean := False)
   is
   String_Index_Limit : Integer;
begin
   if S'Length > Limit then
      String_Index_Limit := S'First + Limit;
   else
      String_Index_Limit := S'Last;
   end if;
   for Index in S'First .. String_Index_Limit loop
      Print (S (Index));
   end loop;
   if NL then
      Print_NewLine;
   end if;
end Print_StringSimple;
