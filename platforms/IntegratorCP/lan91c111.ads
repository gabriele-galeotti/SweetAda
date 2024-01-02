-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lan91c111.ads                                                                                             --
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

package LAN91C111
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

   type Port_Read_8_Ptr is access function (Port : Address) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);
   type Port_Read_16_Ptr is access function (Port : Address) return Unsigned_16;
   type Port_Write_16_Ptr is access procedure (Port : in Address; Value : in Unsigned_16);

   type LAN91C111_Descriptor_Type is record
      Read_8   : Port_Read_8_Ptr;
      Write_8  : Port_Write_8_Ptr;
      Read_16  : Port_Read_16_Ptr;
      Write_16 : Port_Write_16_Ptr;
   end record;

end LAN91C111;
