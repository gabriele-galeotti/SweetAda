-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc-init.adb                                                                                           --
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

separate (Malloc)
procedure Init
   (Memory_Address : in System.Address;
    Size           : in Bits.Bytesize;
    Debug_Flag     : in Boolean)
is
   use System;
   use System.Storage_Elements;
   Heap_Block : aliased Memory_Block_Type
      with Address    => Memory_Address,
           Import     => True,
           Convention => Ada;
begin
   Debug := Debug_Flag;
   -- simulate a request to sbrk()
   Heap_Block.Size     := Size;
   Heap_Block.Next_Ptr := null;
   if Debug then
      Console.Print (
         Prefix => "[MALLOC] Size:                 ",
         Value  => Size,
         NL     => True
         );
      Console.Print (
         Prefix => "[MALLOC] MEMORYBLOCKTYPE_SIZE: ",
         Value  => Integer'(MEMORYBLOCKTYPE_SIZE),
         NL     => True
         );
   end if;
   Init_Flag := True;
   Free (Heap_Block'Address + MEMORYBLOCKTYPE_SIZE);
end Init;
