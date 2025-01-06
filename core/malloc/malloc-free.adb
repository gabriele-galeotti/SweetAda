-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc-free.adb                                                                                           --
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

separate (Malloc)
procedure Free
   (Memory_Address : in Address)
   is
   P            : aliased Memory_Block_Ptr;
   Q            : aliased Memory_Block_Ptr;
   Memory_Block : aliased Memory_Block_Type
      with Address    => Memory_Address - MEMORYBLOCKTYPE_SIZE, -- uncover the data structure
           Import     => True,
           Convention => Ada;
begin
   if Memory_Address = Null_Address then
      raise Storage_Error;
   end if;
   -- traverse the list of free blocks, sorting by address
   P := Heap_Descriptor'Access;
   Q := Heap_Descriptor.Next_Ptr;
   while Q /= null and then Q.all'Address < Memory_Block'Address loop
      P := Q;
      Q := Q.all.Next_Ptr;
   end loop;
   -- try to merge with the following block
   if Q /= null then
      -- following block (pointed to by Q) with higher address exists
      declare
         Next_Block : aliased Memory_Block_Type
            with Address    => Memory_Block'Address + Storage_Offset (Memory_Block.Size),
                 Import     => True,
                 Convention => Ada;
      begin
         -- check if they are the same (no hole in between)
         if Next_Block'Address = Q.all'Address then
            Memory_Block.Size     := @ + Next_Block.Size;
            Memory_Block.Next_Ptr := Next_Block.Next_Ptr;
         else
            Memory_Block.Next_Ptr := Q;
         end if;
      end;
   else
      -- this is the last block
      Memory_Block.Next_Ptr := null;
   end if;
   -- try to merge with the preceding block
   if P /= Heap_Descriptor'Access then
      declare
         Previous_Block : aliased Memory_Block_Type
            with Address    => P.all'Address + Storage_Offset (P.all.Size),
                 Import     => True,
                 Convention => Ada;
      begin
         if Previous_Block'Address = Memory_Block'Address then
            P.all.Size     := @ + Memory_Block.Size;
            P.all.Next_Ptr := Memory_Block.Next_Ptr;
         else
            P.all.Next_Ptr := Memory_Block'Unchecked_Access;
         end if;
      end;
   else
      Heap_Descriptor.Next_Ptr := Memory_Block'Unchecked_Access;
   end if;
   if Debug then
      Console.Print (Memory_Block'Address, Prefix => "Free block: ", NL => True);
   end if;
end Free;
