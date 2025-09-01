-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tca9555.ads                                                                                               --
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

with System;
with Interfaces;
with Bits;

package TCA9555
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
   -- TCA9555
   -- SCPS200E –JULY 2009–REVISED APRIL 2019
   ----------------------------------------------------------------------------

   -- 7-bit I2C address
   I2C_BASEADDRESS : constant := 16#20#; -- 0x20 .. 0x27

   -- 9.5.4 Control Register and Command Byte

   INPUTPORT0  : constant Unsigned_8 := 0;
   INPUTPORT1  : constant Unsigned_8 := 1;
   OUTPUTPORT0 : constant Unsigned_8 := 2;
   OUTPUTPORT1 : constant Unsigned_8 := 3;
   POLINVPORT0 : constant Unsigned_8 := 4;
   POLINVPORT1 : constant Unsigned_8 := 5;
   CONFIGPORT0 : constant Unsigned_8 := 6;
   CONFIGPORT1 : constant Unsigned_8 := 7;

   -- 9.6.1 Register Descriptions

   -- Table 4. Registers 0 and 1 (Input Port Registers)

   type INPUTPORT_Type is record
      I0 : Boolean; -- I[0|1].0
      I1 : Boolean; -- I[0|1].1
      I2 : Boolean; -- I[0|1].2
      I3 : Boolean; -- I[0|1].3
      I4 : Boolean; -- I[0|1].4
      I5 : Boolean; -- I[0|1].5
      I6 : Boolean; -- I[0|1].6
      I7 : Boolean; -- I[0|1].7
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

   -- Table 5. Registers 2 and 3 (Output Port Registers)

   type OUTPUTPORT_Type is record
      O0 : Boolean := False; -- O[0|1].0
      O1 : Boolean := False; -- O[0|1].1
      O2 : Boolean := False; -- O[0|1].2
      O3 : Boolean := False; -- O[0|1].3
      O4 : Boolean := False; -- O[0|1].4
      O5 : Boolean := False; -- O[0|1].5
      O6 : Boolean := False; -- O[0|1].6
      O7 : Boolean := False; -- O[0|1].7
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

   -- Table 6. Registers 4 and 5 (Polarity Inversion Registers)

   type POLINVPORT_Type is record
      N0 : Boolean := False; -- N[0|1].0
      N1 : Boolean := False; -- N[0|1].1
      N2 : Boolean := False; -- N[0|1].2
      N3 : Boolean := False; -- N[0|1].3
      N4 : Boolean := False; -- N[0|1].4
      N5 : Boolean := False; -- N[0|1].5
      N6 : Boolean := False; -- N[0|1].6
      N7 : Boolean := False; -- N[0|1].7
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

   -- Table 7. Registers 6 and 7 (Configuration Registers)

   type DIRECTION_Type is new Bits_1;
   DIROUT : constant DIRECTION_Type := 0; -- port pin is enabled as an output
   DIRIN  : constant DIRECTION_Type := 1; -- port pin is enabled as an input with a high-impedance output driver

   type CONFIGPORT_Type is record
      C0 : DIRECTION_Type := DIRIN; -- C[0|1].0
      C1 : DIRECTION_Type := DIRIN; -- C[0|1].1
      C2 : DIRECTION_Type := DIRIN; -- C[0|1].2
      C3 : DIRECTION_Type := DIRIN; -- C[0|1].3
      C4 : DIRECTION_Type := DIRIN; -- C[0|1].4
      C5 : DIRECTION_Type := DIRIN; -- C[0|1].5
      C6 : DIRECTION_Type := DIRIN; -- C[0|1].6
      C7 : DIRECTION_Type := DIRIN; -- C[0|1].7
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

end TCA9555;
