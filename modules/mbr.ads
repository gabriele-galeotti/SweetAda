-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mbr.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with BlockDevices;

package MBR is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;

   type Partition_Type is new Interfaces.Unsigned_8;

   Partition_NULL      : constant := 16#00#;
   Partition_FAT12     : constant := 16#01#;
   Partition_FAT16     : constant := 16#04#;
   Partition_FAT16B    : constant := 16#06#;
   Partition_FAT32_CHS : constant := 16#0B#;
   Partition_FAT32_LBA : constant := 16#0C#;

   type Partition_Number_Type is (PARTITION1, PARTITION2, PARTITION3, PARTITION4);

   PARTITION_ENTRY_SIZE : constant := 16;

   type Partition_Entry_Type is
   record
      Status           : Interfaces.Unsigned_8;
      CHS_First_Sector : BlockDevices.CHS_Layout_Type;
      Partition        : Partition_Type;
      CHS_Last_Sector  : BlockDevices.CHS_Layout_Type;
      LBA_Start        : Interfaces.Unsigned_32;
      LBA_Size         : Interfaces.Unsigned_32;
   end record with
      Size => PARTITION_ENTRY_SIZE * Storage_Unit;
   for Partition_Entry_Type use record
      Status           at  0 range 0 .. 7;
      CHS_First_Sector at  1 range 0 .. 23;
      Partition        at  4 range 0 .. 7;
      CHS_Last_Sector  at  5 range 0 .. 23;
      LBA_Start        at  8 range 0 .. 31;
      LBA_Size         at 12 range 0 .. 31;
   end record;

   procedure Init (Block_Read : BlockDevices.IO_Read_Ptr);
   procedure Read (
                   Partition_Number : in  Partition_Number_Type;
                   Partition        : out Partition_Entry_Type;
                   Success          : out Boolean
                  );

end MBR;
