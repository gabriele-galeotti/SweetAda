-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pci-utils.ads                                                                                             --
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

package PCI.Utils
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Cfg_Dump
   ----------------------------------------------------------------------------
   -- Configuration space register dump.
   ----------------------------------------------------------------------------
   procedure Cfg_Dump
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type);

   ----------------------------------------------------------------------------
   -- Cfg_BARs_Dump
   ----------------------------------------------------------------------------
   -- Print out configuration BARs.
   ----------------------------------------------------------------------------
   procedure Cfg_BARs_Dump
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type);

end PCI.Utils;
