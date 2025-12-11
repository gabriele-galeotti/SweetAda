-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcp23x17.adb                                                                                              --
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

with Ada.Unchecked_Conversion;

package body MCP23x17
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function To_U8
      (Value : IOCON_Type)
      return Unsigned_8
      is
      function Convert is new Ada.Unchecked_Conversion (IOCON_Type, Unsigned_8);
   begin
      return Convert (Value);
   end To_U8;

   function To_IOCON
      (Value : Unsigned_8)
      return IOCON_Type
      is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_8, IOCON_Type);
   begin
      return Convert (Value);
   end To_IOCON;

end MCP23x17;
