-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ core.adb                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Bits;
with Console;

package body Core is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Parameters_Dump
   ----------------------------------------------------------------------------
   procedure Parameters_Dump is
   begin
      -------------------------------------------------------------------------
      if True then
         Console.Print ("CPU byte order:        ");
         if Bits.BigEndian then
            Console.Print ("BE");
         else
            Console.Print ("LE");
         end if;
         Console.Print_NewLine;
         Console.Print (
                        Integer'(Standard'Word_Size),
                        Prefix => "Standard'Word_Size:    ",
                        NL     => True
                       );
         Console.Print (
                        Integer'(Standard'Address_Size),
                        Prefix => "Standard'Address_Size: ",
                        NL     => True
                       );
      end if;
      -------------------------------------------------------------------------
   end Parameters_Dump;

   ----------------------------------------------------------------------------
   -- Stack_Check
   ----------------------------------------------------------------------------
   -- __TBD__
   ----------------------------------------------------------------------------
   function Stack_Check (Stack_Address : System.Address) return Stack_Access is
      pragma Unreferenced (Stack_Address);
   begin
      return null;
   end Stack_Check;

end Core;
