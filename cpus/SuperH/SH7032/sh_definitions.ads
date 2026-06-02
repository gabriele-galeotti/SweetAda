-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh_definitions.ads                                                                                        --
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

package SH_Definitions
   with Pure => True
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

   ----------------------------------------------------------------------------
   -- SH7032, SH7034 Hardware Manual
   -- Rev.7.00 2006.01
   ----------------------------------------------------------------------------

   -- 2.1.2 Control Registers

   type SR_Type is record
      T         : Boolean;      -- T bit
      S         : Boolean;      -- S bit
      Reserved1 : Bits_2  := 0;
      IMASK     : Bits_4;       -- Interrupt mask bits.
      Q         : Boolean;      -- Q bit
      M         : Boolean;      -- M bit
      Reserved2 : Bits_22 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SR_Type use record
      T         at 0 range  0 ..  0;
      S         at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      IMASK     at 0 range  4 ..  7;
      Q         at 0 range  8 ..  8;
      M         at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 31;
   end record;

end SH_Definitions;
