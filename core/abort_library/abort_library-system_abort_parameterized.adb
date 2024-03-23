-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library-system_abort_parameterized.adb                                                              --
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

with System;
with Console;

separate (Abort_Library)
procedure System_Abort_Parameterized
   (File    : in System.Address;
    Line    : in Integer;
    Column  : in Integer;
    Message : in System.Address)
   is
   use type System.Address;
begin
   Console.Print_NewLine;
   Console.Print ("*** SYSTEM ABORT", NL => True);
   if File /= System.Null_Address then
      Console.Print ("File:    ", NL => False);
      Console.Print_ASCIIZ_String (String_Address => File, NL => True);
   end if;
   if Line /= 0 then
      Console.Print (Prefix => "Line:    ", Value => Line, NL => True);
      Console.Print (Prefix => "Column:  ", Value => Column, NL => True);
   end if;
   Console.Print ("Message: ", NL => False);
   Console.Print_ASCIIZ_String (String_Address => Message, NL => True);
   System_Abort; -- default abort procedure
end System_Abort_Parameterized;
