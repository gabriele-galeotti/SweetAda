-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ina233.ads                                                                                                --
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
with Bits;

package INA233
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- INA233 36V, 16-Bit, Ultra-Precise I2C and PMBus Output Current, Voltage,
   -- Power, and Energy Monitor With Alert
   -- SBOS790A – APRIL 2017 – REVISED MARCH 2025
   ----------------------------------------------------------------------------

   IOUT_OC_WARN_LIMIT : constant := 16#4A#;
   VIN_OV_WARN_LIMIT  : constant := 16#57#;
   VIN_UV_WARN_LIMIT  : constant := 16#58#;
   PIN_OP_WARN_LIMIT  : constant := 16#6B#;
   STATUS_BYTE        : constant := 16#78#;
   MFR_ID             : constant := 16#99#;
   MFR_CALIBRATION    : constant := 16#D4#;

   -- 6.6.2.4 IOUT_OC_WARN_LIMIT (4Ah)

   type IOUT_OC_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      IO        : Bits_12 := 16#FFF#; -- These bits control the IOUT_OC_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order   => Low_Order_First,
        Object_Size => 16;
   for IOUT_OC_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      IO        at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.5 VIN_OV_WARN_LIMIT (57h)

   type VIN_OV_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      V         : Bits_12 := 16#FFF#; -- These bits control the VIN_OV_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order   => Low_Order_First,
        Object_Size => 16;
   for VIN_OV_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      V         at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.6 VIN_UV_WARN_LIMIT (58h)

   type VIN_UV_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      V         : Bits_12 := 0; -- These bits control the VIN_UV_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order   => Low_Order_First,
        Object_Size => 16;
   for VIN_UV_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      V         at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.7 PIN_OP_WARN_LIMIT (6Bh)

   type PIN_OP_WARN_LIMIT_Type is record
      Reserved : Bits_4  := 0;
      D        : Bits_12 := 16#FFF#; -- These bits control the VIN_UV_WARN_LIMIT.
   end record
   with Bit_Order   => Low_Order_First,
        Object_Size => 16;
   for PIN_OP_WARN_LIMIT_Type use record
      Reserved at 0 range 0 ..  3;
      D        at 0 range 4 .. 15;
   end record;

   -- 6.6.2.8 STATUS_BYTE (78h)

   type STATUS_BYTE_Type is record
      NONE        : Boolean; -- A fault or warning not listed in bits[7:1] has occurred
      CML         : Boolean; -- A communication fault has occurred
      TEMPERATURE : Boolean; -- Not supported
      VIN_UV      : Boolean; -- Not supported
      IOUT_OC     : Boolean; -- Not supported
      VOUT_OV     : Boolean; -- Not supported
      OFF         : Boolean; -- Not supported
      BUSY        : Boolean; -- Not supported
   end record
   with Bit_Order   => Low_Order_First,
        Object_Size => 8;
   for STATUS_BYTE_Type use record
      NONE        at 0 range 0 .. 0;
      CML         at 0 range 1 .. 1;
      TEMPERATURE at 0 range 2 .. 2;
      VIN_UV      at 0 range 3 .. 3;
      IOUT_OC     at 0 range 4 .. 4;
      VOUT_OV     at 0 range 5 .. 5;
      OFF         at 0 range 6 .. 6;
      BUSY        at 0 range 7 .. 7;
   end record;

pragma Style_Checks (On);

end INA233;
