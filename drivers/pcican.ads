-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pcican.ads                                                                                                --
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

with PCI;

package PCICAN is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use PCI;

   type Descriptor_Type is record
      Bus_Number    : Bus_Number_Type;
      Device_Number : Device_Number_Type;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Bus_Number    => 0,
       Device_Number => 0
      );

   procedure Probe
      (Device_Number : out Device_Number_Type;
       Success       : out Boolean);
   procedure Init;
   procedure TX;

end PCICAN;
