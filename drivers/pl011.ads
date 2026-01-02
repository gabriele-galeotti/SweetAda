-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl011.ads                                                                                                 --
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

package PL011
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- PrimeCell® UART (PL011)
   -- Revision: r1p4
   -- Technical Reference Manual
   -- ARM DDI 0183F
   ----------------------------------------------------------------------------

   type Port_Read_8_Ptr is access function (Port : Address) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);
   type Port_Read_16_Ptr is access function (Port : Address) return Unsigned_16;
   type Port_Write_16_Ptr is access procedure (Port : in Address; Value : in Unsigned_16);

   type Descriptor_Type is record
      Base_Address : Address;
      Baud_Clock   : Positive;
      Read_8       : Port_Read_8_Ptr;
      Write_8      : Port_Write_8_Ptr;
      Read_16      : Port_Read_16_Ptr;
      Write_16     : Port_Write_16_Ptr;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Base_Address => Null_Address,
       Baud_Clock   => 1,
       Read_8       => null,
       Write_8      => null,
       Read_16      => null,
       Write_16     => null
      );

   procedure Init
      (Descriptor : in Descriptor_Type);
   procedure TX
      (Descriptor : in Descriptor_Type;
       Data       : in Unsigned_8);
   procedure RX
      (Descriptor : in     Descriptor_Type;
       Data       :    out Unsigned_8);

pragma Style_Checks (On);

end PL011;
