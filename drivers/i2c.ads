-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ i2c.ads                                                                                                   --
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

package I2C
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

   -- I2C addressing ----------------------------------------------------------

   type RW_Mode_Type is new Bits_8 range 0 .. 1
      with Size => 8;
   WRITE : constant RW_Mode_Type := 0;
   READ  : constant RW_Mode_Type := 1;

   ----------------------------------------------------------------------------
   -- BusAddress
   ----------------------------------------------------------------------------
   -- Build the [I2C address + R/W] 8-bit pattern to be placed on the bus.
   ----------------------------------------------------------------------------
   function BusAddress
      (Device_Address : Unsigned_8;
       RW             : RW_Mode_Type)
      return Unsigned_8
      with Inline => True;

end I2C;
