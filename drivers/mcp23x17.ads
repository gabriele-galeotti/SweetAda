-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcp23x17.ads                                                                                              --
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

with System;
with Interfaces;
with Bits;

package MCP23x17
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MCP23017/MCP23S17 16-Bit I/O Expander with Serial Interface
   -- DS20001952D
   ----------------------------------------------------------------------------

   IOCON_DEFAULT_ADDRESS : constant := 16#0A#;

   INTPOL_HIGH : constant := 1; -- Active-high
   INTPOL_LOW  : constant := 0; -- Active-low

   BANK_SEPARATE : constant := 1; -- The registers associated with each port are separated into different banks.
   BANK_SAME     : constant := 0; -- The registers are in the same bank (addresses are sequential).

   type IOCON_Type is record
      Unimplemented : Bits_1  := 0;
      INTPOL        : Bits_1  := INTPOL_LOW; -- This bit sets the polarity of the INT output pin
      ODR           : Boolean := False;      -- Configures the INT pin as an open-drain output
      HAEN          : Boolean := False;      -- Hardware Address Enable bit
      DISSLW        : Boolean := False;      -- Slew Rate control bit for SDA output
      SEQOP         : Boolean := False;      -- Sequential Operation mode bit
      MIRROR        : Boolean := False;      -- INT Pins Mirror bit
      BANK          : Bits_1  := BANK_SAME;  -- Controls how the registers are addressed
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for IOCON_Type use record
      Unimplemented at 0 range 0 .. 0;
      INTPOL        at 0 range 1 .. 1;
      ODR           at 0 range 2 .. 2;
      HAEN          at 0 range 3 .. 3;
      DISSLW        at 0 range 4 .. 4;
      SEQOP         at 0 range 5 .. 5;
      MIRROR        at 0 range 6 .. 6;
      BANK          at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : IOCON_Type)
      return Unsigned_8
      with Inline => True;

   function To_IOCON
      (Value : Unsigned_8)
      return IOCON_Type
      with Inline => True;

pragma Style_Checks (On);

end MCP23x17;
