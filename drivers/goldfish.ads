-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ goldfish.ads                                                                                              --
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
with Interfaces;
with Bits;
with MMIO;
with Time;

package Goldfish
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

   ----------------------------------------------------------------------------
   -- Android Goldfish RTC
   -- Android Goldfish RTC device used by Android emulator.
   ----------------------------------------------------------------------------

   type Port_Read_32_Ptr is access function (Port : Address) return Unsigned_32;
   type Port_Write_32_Ptr is access procedure (Port : in Address; Value : in Unsigned_32);

   type Descriptor_Type is record
      Base_Address  : Address;
      Scale_Address : Address_Shift;
      Read_32       : not null Port_Read_32_Ptr := MMIO.ReadN_U32'Access;
      Write_32      : not null Port_Write_32_Ptr := MMIO.WriteN_U32'Access;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Read_32       => MMIO.ReadN_U32'Access,
       Write_32      => MMIO.WriteN_U32'Access
      );

   procedure Read_Clock
      (D : in     Descriptor_Type;
       T :    out Time.TM_Time);

end Goldfish;
