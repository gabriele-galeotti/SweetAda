-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_sizet.adb                                                                                   --
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
procedure Print_sizet (
                       s      : in Interfaces.C.size_t;
                       NL     : in Boolean := False;
                       Prefix : in String := "";
                       Suffix : in String := ""
                      ) is
   Number         : Interfaces.C.size_t := s;
   Number_Literal : String (1 .. 16);
   Literal_Index  : Natural := 0;
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   for Index in reverse Number_Literal'Range loop
      Number_Literal (Index) := To_Ch (Decimal_Digit_Type (Number mod 10));
      Number := @ / 10;
      if Number = 0 then
         Literal_Index := Index;
         exit;
      end if;
   end loop;
   Print (Number_Literal (Literal_Index .. Number_Literal'Last));
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_sizet;
