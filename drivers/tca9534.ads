-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tca9534.ads                                                                                               --
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

package TCA9534
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
   -- TCA9534
   -- SCPS197D –SEPTEMBER 2014–REVISED OCTOBER 2017
   ----------------------------------------------------------------------------

   -- 7-bit I2C address
   I2C_BASEADDRESS : constant := 16#20#; -- 0x20 .. 0x27

   -- 8.6.2 Control Register and Command Byte

   INPUTPORT  : constant Unsigned_8 := 0;
   OUTPUTPORT : constant Unsigned_8 := 1;
   POLINVPORT : constant Unsigned_8 := 2;
   CONFIGPORT : constant Unsigned_8 := 3;

   -- 8.6.3 Register Descriptions

   -- Table 4. Register 0 (Input Port Register) Table

   type INPUTPORT_Type is record
      I0 : Boolean; -- I0
      I1 : Boolean; -- I1
      I2 : Boolean; -- I2
      I3 : Boolean; -- I3
      I4 : Boolean; -- I4
      I5 : Boolean; -- I5
      I6 : Boolean; -- I6
      I7 : Boolean; -- I7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for INPUTPORT_Type use record
      I0 at 0 range 0 .. 0;
      I1 at 0 range 1 .. 1;
      I2 at 0 range 2 .. 2;
      I3 at 0 range 3 .. 3;
      I4 at 0 range 4 .. 4;
      I5 at 0 range 5 .. 5;
      I6 at 0 range 6 .. 6;
      I7 at 0 range 7 .. 7;
   end record;

   function To_INPUTPORT
      (Value : Unsigned_8)
      return INPUTPORT_Type
      with Inline => True;

   -- Table 5. Register 1 (Output Port Register) Table

   type OUTPUTPORT_Type is record
      O0 : Boolean := False; -- O0
      O1 : Boolean := False; -- O1
      O2 : Boolean := False; -- O2
      O3 : Boolean := False; -- O3
      O4 : Boolean := False; -- O4
      O5 : Boolean := False; -- O5
      O6 : Boolean := False; -- O6
      O7 : Boolean := False; -- O7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUTPUTPORT_Type use record
      O0 at 0 range 0 .. 0;
      O1 at 0 range 1 .. 1;
      O2 at 0 range 2 .. 2;
      O3 at 0 range 3 .. 3;
      O4 at 0 range 4 .. 4;
      O5 at 0 range 5 .. 5;
      O6 at 0 range 6 .. 6;
      O7 at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : OUTPUTPORT_Type)
      return Unsigned_8
      with Inline => True;

   function To_OUTPUTPORT
      (Value : Unsigned_8)
      return OUTPUTPORT_Type
      with Inline => True;

   -- Table 6. Register 2 (Polarity Inversion Register) Table

   type POLINVPORT_Type is record
      N0 : Boolean := False; -- N0
      N1 : Boolean := False; -- N1
      N2 : Boolean := False; -- N2
      N3 : Boolean := False; -- N3
      N4 : Boolean := False; -- N4
      N5 : Boolean := False; -- N5
      N6 : Boolean := False; -- N6
      N7 : Boolean := False; -- N7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for POLINVPORT_Type use record
      N0 at 0 range 0 .. 0;
      N1 at 0 range 1 .. 1;
      N2 at 0 range 2 .. 2;
      N3 at 0 range 3 .. 3;
      N4 at 0 range 4 .. 4;
      N5 at 0 range 5 .. 5;
      N6 at 0 range 6 .. 6;
      N7 at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : POLINVPORT_Type)
      return Unsigned_8
      with Inline => True;

   function To_POLINVPORT
      (Value : Unsigned_8)
      return POLINVPORT_Type
      with Inline => True;

   -- Table 7. Register 3 (Configuration Register) Table

   type DIRECTION_Type is new Bits_1;
   DIROUT : constant DIRECTION_Type := 0; -- port pin is enabled as an output
   DIRIN  : constant DIRECTION_Type := 1; -- port pin is enabled as an input with a high-impedance output driver

   type CONFIGPORT_Type is record
      C0 : DIRECTION_Type := DIRIN; -- C0
      C1 : DIRECTION_Type := DIRIN; -- C1
      C2 : DIRECTION_Type := DIRIN; -- C2
      C3 : DIRECTION_Type := DIRIN; -- C3
      C4 : DIRECTION_Type := DIRIN; -- C4
      C5 : DIRECTION_Type := DIRIN; -- C5
      C6 : DIRECTION_Type := DIRIN; -- C6
      C7 : DIRECTION_Type := DIRIN; -- C7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CONFIGPORT_Type use record
      C0 at 0 range 0 .. 0;
      C1 at 0 range 1 .. 1;
      C2 at 0 range 2 .. 2;
      C3 at 0 range 3 .. 3;
      C4 at 0 range 4 .. 4;
      C5 at 0 range 5 .. 5;
      C6 at 0 range 6 .. 6;
      C7 at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : CONFIGPORT_Type)
      return Unsigned_8
      with Inline => True;

   function To_CONFIGPORT
      (Value : Unsigned_8)
      return CONFIGPORT_Type
      with Inline => True;

pragma Style_Checks (On);

end TCA9534;
