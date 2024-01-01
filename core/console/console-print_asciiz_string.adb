-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_asciiz_string.adb                                                                           --
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
procedure Print_ASCIIZ_String
   (String_Address : in System.Address;
    NL             : in Boolean := False;
    Prefix         : in String := "";
    Suffix         : in String := "")
   is
   SA : System.Address := String_Address;
begin
   if Prefix'Length /= 0 then
      Print (Prefix);
   end if;
   if SA /= System.Null_Address then
      for Index in Interfaces.C.size_t range 0 .. Maximum_String_Length - 1 loop
         declare
            c : aliased Interfaces.C.char
               with Address    => SA,
                    Import     => True,
                    Convention => Ada;
         begin
            exit when c = Interfaces.C.nul;
            Print (c);
         end;
         SA := @ + 1;
      end loop;
   end if;
   if Suffix'Length /= 0 then
      Print (Suffix);
   end if;
   if NL then
      Print_NewLine;
   end if;
end Print_ASCIIZ_String;
