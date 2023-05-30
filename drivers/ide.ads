-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ide.ads                                                                                                   --
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
with BlockDevices;

package IDE is

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
   use BlockDevices;

   type Drive_Type is (MASTER, SLAVE) with
      Size => 1;
   for Drive_Type use (0, 1);

   -- I/O subprograms access
   type Port_Read_8_Ptr is access function (Port : in Address) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);
   type Port_Read_16_Ptr is access function (Port : in Address) return Unsigned_16;
   type Port_Write_16_Ptr is access procedure (Port : in Address; Value : in Unsigned_16);

   type Descriptor_Type is
   record
      Base_Address  : Address;
      Scale_Address : Address_Shift;
      Read_8        : Port_Read_8_Ptr;
      Write_8       : Port_Write_8_Ptr;
      Read_16       : Port_Read_16_Ptr;
      Write_16      : Port_Write_16_Ptr;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Read_8        => null,
       Write_8       => null,
       Read_16       => null,
       Write_16      => null
      );

   procedure Read
      (D       : in     Descriptor_Type;
       S       : in     Sector_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   procedure Write
      (D       : in     Descriptor_Type;
       S       : in     Sector_Type;
       B       : in     Block_Type;
       Success :    out Boolean);

   procedure Init
      (D : in Descriptor_Type);

end IDE;
