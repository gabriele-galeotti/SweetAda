-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_storage_offset.adb                                                                          --
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

with LLutils;

separate (Console)
procedure Print_Storage_Offset
   (Value  : in SSE.Storage_Offset;
    NL     : in Boolean := False;
    Prefix : in String := "";
    Suffix : in String := "")
   is
   use type SSE.Storage_Offset;
   subtype Negative_SO is SSE.Storage_Offset range SSE.Storage_Offset'First .. -1;
   subtype Positive_SO is SSE.Storage_Offset range 0 .. SSE.Storage_Offset'Last;
   Negative_Sign  : Boolean := False;
   Number         : Positive_SO;
   Number_Literal : String (1 .. 16) := [others => ' '];
   Literal_Index  : Natural;
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   Literal_Index := Number_Literal'Last;
   if Value < 0 then
      Negative_Sign := True;
      declare
         NNumber : Negative_SO := Value;
      begin
         -- handle 2's complement off-range asymmetric negative numbers
         -- by prescaling their values
         while NNumber < -SSE.Storage_Offset'Last loop
            Number_Literal (Literal_Index) := LLutils.To_Ch (Natural (-(NNumber rem 10)));
            Literal_Index := @ - 1;
            NNumber := @ / 10;
         end loop;
         -- now conversion to positive value is safe
         Number := -NNumber;
      end;
   else
      Number := Value;
   end if;
   -- build literal string
   for Index in reverse 2 .. Literal_Index loop
      Number_Literal (Index) := LLutils.To_Ch (Natural (Number rem 10));
      Number := @ / 10;
      if Number = 0 then
         Literal_Index := Index;
         exit;
      end if;
   end loop;
   -- add negative sign
   if Negative_Sign then
      Literal_Index := @ - 1;
      Number_Literal (Literal_Index) := '-';
   end if;
   Print (Number_Literal (Literal_Index .. Number_Literal'Last));
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_Storage_Offset;
