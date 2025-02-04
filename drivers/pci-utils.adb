-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pci-utils.adb                                                                                             --
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

with Console;

package body PCI.Utils
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Cfg_Dump
   ----------------------------------------------------------------------------
   procedure Cfg_Dump
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type)
      is
      Cfg_Space : Byte_Array (0 .. 255);
   begin
      for Index in Cfg_Space'Range loop
         Cfg_Space (Index) := Cfg_Read (
            Descriptor,
            Bus_Number,
            Device_Number,
            Function_Number,
            Register_Number_Type (Index)
            );
      end loop;
      Console.Print_Memory (Cfg_Space'Address, Cfg_Space'Length);
   end Cfg_Dump;

   ----------------------------------------------------------------------------
   -- Cfg_BARs_Dump
   ----------------------------------------------------------------------------
   procedure Cfg_BARs_Dump
      (Descriptor      : in Descriptor_Type;
       Bus_Number      : in Bus_Number_Type;
       Device_Number   : in Device_Number_Type;
       Function_Number : in Function_Number_Type)
      is
      Data : Unsigned_32;
   begin
      Data := Cfg_Read (Descriptor, Bus_Number, Device_Number, Function_Number, BAR0_Register_Offset);
      Console.Print (Prefix => "BAR0: ", Value => Data, NL => True);
      Data := Cfg_Read (Descriptor, Bus_Number, Device_Number, Function_Number, BAR1_Register_Offset);
      Console.Print (Prefix => "BAR1: ", Value => Data, NL => True);
      Data := Cfg_Read (Descriptor, Bus_Number, Device_Number, Function_Number, BAR2_Register_Offset);
      Console.Print (Prefix => "BAR2: ", Value => Data, NL => True);
      Data := Cfg_Read (Descriptor, Bus_Number, Device_Number, Function_Number, BAR3_Register_Offset);
      Console.Print (Prefix => "BAR3: ", Value => Data, NL => True);
      Data := Cfg_Read (Descriptor, Bus_Number, Device_Number, Function_Number, BAR4_Register_Offset);
      Console.Print (Prefix => "BAR4: ", Value => Data, NL => True);
   end Cfg_BARs_Dump;

end PCI.Utils;
