-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library.adb                                                                                         --
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

with Console;

package body Abort_Library is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type System.Address;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- System_Abort (parameterless)
   ----------------------------------------------------------------------------
   procedure System_Abort is
   begin
      loop null; end loop;
   end System_Abort;

   ----------------------------------------------------------------------------
   -- System_Abort (parameterized)
   ----------------------------------------------------------------------------
   procedure System_Abort (
                           File    : in System.Address;
                           Line    : in Integer;
                           Column  : in Integer;
                           Message : in System.Address
                          ) is
   begin
      Console.Print_NewLine;
      Console.Print ("*** SYSTEM ABORT", NL => True);
      if File /= System.Null_Address then
         Console.Print ("File:    ", NL => False);
         Console.Print_ASCIIZ_String (String_Ptr => File, NL => True);
      end if;
      if Line /= 0 then
         Console.Print (Prefix => "Line:    ", Value => Line, NL => True);
         Console.Print (Prefix => "Column:  ", Value => Column, NL => True);
      end if;
      Console.Print ("Message: ", NL => False);
      Console.Print_ASCIIZ_String (String_Ptr => Message, NL => True);
      System_Abort; -- default abort procedure
   end System_Abort;

end Abort_Library;
