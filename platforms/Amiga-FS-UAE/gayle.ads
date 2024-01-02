-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gayle.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Bits;

package Gayle is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Bits;

   GAYLE_IDE_BASEADDRESS : constant := 16#00DD_2020#;

   type IDE_Devcon_Type is
   record
      Unused1    : Bits_1;
      IRQDISABLE : Boolean;
      RESET      : Boolean;
      Unused2    : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for IDE_Devcon_Type use
   record
      Unused1    at 0 range 0 .. 0;
      IRQDISABLE at 0 range 1 .. 1;
      RESET      at 0 range 2 .. 2;
      Unused2    at 0 range 3 .. 7;
   end record;

   -- address shift = 2
   IDE_DEVCON_ADDRESS : constant := GAYLE_IDE_BASEADDRESS + 16#0406# * 2**2;

   IDE_Devcon : aliased IDE_Devcon_Type with
      Address    => To_Address (IDE_DEVCON_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end Gayle;
