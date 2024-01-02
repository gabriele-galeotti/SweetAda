-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mc146818a.ads                                                                                             --
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
with Interfaces;
with Bits;
with MMIO;
with Time;

package MC146818A
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

   type Flags_Type is record
      PC_RTC : Boolean;
   end record;

   type Port_Read_8_Ptr is access function (Port : Address) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);

   type Descriptor_Type is record
      Base_Address  : Address;
      Scale_Address : Address_Shift;
      Flags         : Flags_Type;
      Read_8        : not null Port_Read_8_Ptr := MMIO.ReadN_U8'Access;
      Write_8       : not null Port_Write_8_Ptr := MMIO.WriteN_U8'Access;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      [
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Flags         => (PC_RTC => False),
       Read_8        => MMIO.ReadN_U8'Access,
       Write_8       => MMIO.WriteN_U8'Access
      ];

   procedure Handle
      (Data_Address : in System.Address);

   procedure Read_Clock
      (D : in     Descriptor_Type;
       T : in out Time.TM_Time);

   procedure Init
      (D : in Descriptor_Type);

end MC146818A;
