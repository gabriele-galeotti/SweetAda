-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ blockdevices.ads                                                                                          --
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

package BlockDevices
   with  Pure => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;

   type Sector_Type is new Interfaces.Unsigned_32;

   BLOCK_ALIGNMENT : constant := 8;

   type Block_Type is new Bits.Byte_Array
      with Alignment => BLOCK_ALIGNMENT;

   ----------------------------------------------------------------------------
   -- CHS addressing
   --
   -- CHS physical layout:
   -- 1st byte: H
   -- 2nd byte: bit0..5 = S, bit6..7 = CH
   -- 3rd byte: CL
   ----------------------------------------------------------------------------

   type CHS_Type is record
      C : Natural range 0 .. 1023;
      H : Natural range 0 ..  254;
      S : Natural range 1 ..   63;
   end record;

   type CHS_Layout_Type is record
      H  : Natural range 0 .. 254;
      S  : Natural range 1 ..  63;
      CH : Natural range 0 ..   3;
      CL : Natural range 0 .. 255;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 3 * 8;
   for CHS_Layout_Type use record
      H  at 0 range 0 .. 7;
      S  at 1 range 0 .. 5;
      CH at 1 range 6 .. 7;
      CL at 2 range 0 .. 7;
   end record;

   function To_CHS
      (CHS : in CHS_Type)
      return CHS_Layout_Type;

   function To_CHS
      (CHS : in CHS_Layout_Type)
      return CHS_Type;

   ----------------------------------------------------------------------------
   -- LBA addressing
   ----------------------------------------------------------------------------

   type LBA_Type is mod 2**28;

   function To_LBA
      (CHS          : in CHS_Type;
       CHS_Geometry : in CHS_Type)
      return LBA_Type;

   function To_CHS
      (Sector_Number : in LBA_Type;
       CHS_Geometry  : in CHS_Type)
      return CHS_Type;

end BlockDevices;
