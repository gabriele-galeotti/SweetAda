-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory.ads                                                                                                --
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

with System;
with System.Storage_Elements;

package Memory
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;

   type ID_Type is (NULLID, RESERVED, SYSTEM, USED, FREE)
      with Size => Standard'Address_Size;
   for ID_Type use (0,      1,        2,      3,    4);

   type Area_Type is record
      Start : Address       := Null_Address;
      Size  : Storage_Count := 0;
      Id    : ID_Type       := NULLID;
   end record
      with Alignment => Standard'Address_Size / Storage_Unit,
           Size      => Standard'Address_Size +
                        Storage_Offset'Size   +
                        ID_Type'Size;
   for Area_Type use record
      Start at    0
            range 0 .. Standard'Address_Size - 1;
      Size  at    Standard'Address_Size / Storage_Unit
            range 0 .. Storage_Offset'Size - 1;
      Id    at    (Standard'Address_Size + Storage_Offset'Size) / Storage_Unit
            range 0 .. ID_Type'Size - 1;
   end record;

   type Areas_Type is array (Natural range <>) of Area_Type
      with Pack => True;

   NMEMORYAREAS_MAX : constant := 8;

   MemoryMap : Areas_Type (0 .. NMEMORYAREAS_MAX - 1)
      with Import        => True,
           Convention    => Asm,
           External_Name => "_memorymap";

   NAreas : Natural range 0 .. NMEMORYAREAS_MAX
      with Size          => Storage_Unit,
           Import        => True,
           Convention    => Asm,
           External_Name => "_nareas";

end Memory;
