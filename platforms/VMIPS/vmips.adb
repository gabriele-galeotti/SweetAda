-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ vmips.adb                                                                                                 --
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

with Ada.Unchecked_Conversion;

package body VMIPS
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   generic function UC renames Ada.Unchecked_Conversion;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- Device_Control/Data register conversion functions

pragma Style_Checks (Off);
   function To_U32 (Value : Device_Control_Type) return Unsigned_32 is function Convert is new UC (Device_Control_Type, Unsigned_32); begin return Convert (Value); end To_U32;
   function To_DCT (Value : Unsigned_32) return Device_Control_Type is function Convert is new UC (Unsigned_32, Device_Control_Type); begin return Convert (Value); end To_DCT;
   function To_U32 (Value : Device_Data_Type) return Unsigned_32 is function Convert is new UC (Device_Data_Type, Unsigned_32); begin return Convert (Value); end To_U32;
   function To_DDT (Value : Unsigned_32) return Device_Data_Type is function Convert is new UC (Unsigned_32, Device_Data_Type); begin return Convert (Value); end To_DDT;
pragma Style_Checks (On);

end VMIPS;
