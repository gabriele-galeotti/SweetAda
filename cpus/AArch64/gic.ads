-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gic.ads                                                                                                   --
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

with System;
with Interfaces;
with Bits;

package GIC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- GIC
   ----------------------------------------------------------------------------

   type GICD_CTLR_Type is
   record
      EnableGrp1  : Boolean;
      EnableGrp1A : Boolean;
      Reserved1   : Bits_2 := 0;
      ARE_NS      : Boolean;
      Reserved2   : Bits_26 := 0;
      RWP         : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GICD_CTLR_Type use record
      EnableGrp1  at 0 range  0 ..  0;
      EnableGrp1A at 0 range  1 ..  1;
      Reserved1   at 0 range  2 ..  3;
      ARE_NS      at 0 range  4 ..  4;
      Reserved2   at 0 range  5 .. 30;
      RWP         at 0 range 31 .. 31;
   end record;

   EOImodeNS_ALL      : constant := 0;
   EOImodeNS_PRIORITY : constant := 1;

   type GICC_CTLR_Type is
   record
      EnableGrp1    : Boolean;
      Reserved1     : Bits_4 := 0;
      FIQBypDisGrp1 : Boolean;
      IRQBypDisGrp1 : Boolean;
      Reserved2     : Bits_2 := 0;
      EOImodeNS     : Bits_1;
      Reserved3     : Bits_13 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GICC_CTLR_Type use record
      EnableGrp1    at 0 range  0 ..  0;
      Reserved1     at 0 range  1 ..  4;
      FIQBypDisGrp1 at 0 range  5 ..  5;
      IRQBypDisGrp1 at 0 range  6 ..  6;
      Reserved2     at 0 range  7 ..  8;
      EOImodeNS     at 0 range  9 ..  9;
      Reserved3     at 0 range 19 .. 31;
   end record;

   type GICC_PMR_Type is
   record
      Priority : Unsigned_8;
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GICC_PMR_Type use record
      Priority at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

end GIC;
