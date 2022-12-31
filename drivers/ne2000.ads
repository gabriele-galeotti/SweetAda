-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ne2000.ads                                                                                                --
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
with Definitions;
with PCI;
with Ethernet;
with PBUF;

package NE2000 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Ethernet;
   use PBUF;

   type Port_Read_8_Ptr is access function (Port : Unsigned_16) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Unsigned_16; Value : in Unsigned_8);
   type Port_Read_16_Ptr is access function (Port : Unsigned_16) return Unsigned_16;
   type Port_Write_16_Ptr is access procedure (Port : in Unsigned_16; Value : in Unsigned_16);
   type Port_Read_32_Ptr is access function (Port : Unsigned_16) return Unsigned_32;
   type Port_Write_32_Ptr is access procedure (Port : in Unsigned_16; Value : in Unsigned_32);

   type NE2000_Descriptor_Type is
   record
      NE2000PCI     : Boolean;
      Device_Number : PCI.Device_Number_Type;
      Base_Address  : Unsigned_16;
      MAC           : MAC_Address_Type;
      Read_8        : Port_Read_8_Ptr;
      Write_8       : Port_Write_8_Ptr;
      Read_16       : Port_Read_16_Ptr;
      Write_16      : Port_Write_16_Ptr;
      Read_32       : Port_Read_32_Ptr;
      Write_32      : Port_Write_32_Ptr;
      BAR           : Unsigned_16;
      Next_Ptr      : Unsigned_8 with Volatile => True;
   end record;

   NE2000_DESCRIPTOR_INVALID : constant NE2000_Descriptor_Type :=
      (
       NE2000PCI     => False,
       Device_Number => 0,
       Base_Address  => 0,
       MAC           => (0, 0, 0, 0, 0, 0),
       Read_8        => null,
       Write_8       => null,
       Read_16       => null,
       Write_16      => null,
       Read_32       => null,
       Write_32      => null,
       BAR           => 0,
       Next_Ptr      => 0
      );

   RAM_Address : constant := 16#4000#;
   RAM_Size    : constant := Definitions.kB16;

   procedure Probe (Device_Number : out PCI.Device_Number_Type; Success : out Boolean);
   procedure Init (Descriptor : in out NE2000_Descriptor_Type);
   procedure Init_PCI (Descriptor : in out NE2000_Descriptor_Type);
   procedure Interrupt_Handler (Descriptor_Address : in Address);
   -- procedure Receive (Descriptor_Address : in Address);
   procedure Receive (Descriptor : in out NE2000_Descriptor_Type);
   procedure Transmit (Descriptor_Address : in Address; P : in Pbuf_Ptr);

end NE2000;
