-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pcican.ads                                                                                                --
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

with PCI;

package PCICAN
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Descriptor_Type is record
      Bus_Number    : PCI.Bus_Number_Type;
      Device_Number : PCI.Device_Number_Type;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Bus_Number    => 0,
       Device_Number => 0
      );

   procedure Probe
      (Descriptor    : in     PCI.Descriptor_Type;
       Device_Number :    out PCI.Device_Number_Type;
       Success       :    out Boolean);
   procedure Init
      (Descriptor    : in PCI.Descriptor_Type;
       Device_Number : in PCI.Device_Number_Type);

   procedure TX;

end PCICAN;
