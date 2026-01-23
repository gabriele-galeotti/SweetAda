-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc-malloc.adb                                                                                         --
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
function Malloc
   (Size : size_t)
   return Address
   is
   RSize : size_t;
   P     : Memory_Block_Ptr;
   Q     : Memory_Block_Ptr;
begin
   if Debug then
      Console.Print (Prefix => "Requesting: ", Value => Size, NL => True);
   end if;
   if Size = 0 then
      return Null_Address;
   end if;
   RSize := Round_Size (MEMORYBLOCKTYPE_SIZE + Size, DEFAULT_ALIGNMENT);
   if Debug then
      Console.Print (Prefix => "Rounded size: ", Value => RSize, NL => True);
   end if;
   Mutex.Acquire (Mtx);
   -- traverse the list of free block
   P := Heap_Descriptor'Access;
   Q := Heap_Descriptor.Next_Ptr;
   while Q /= null and then Q.all.Size < RSize loop
      P := Q;
      Q := Q.all.Next_Ptr;
   end loop;
   if Q = null then
      Mutex.Release (Mtx);
      -- no block with sufficient size was found
      raise Storage_Error;
   end if;
   if Debug then
      Console.Print (
         Prefix => "Found block @ ",
         Value  => Q.all'Address,
         NL     => True
         );
   end if;
   -- the memory block could be too big to be provided as a whole; if
   -- possible, split it in two sub-blocks, one for the user and the other
   -- stuck in the pool as available memory space
   if Q.all.Size - RSize >= 2 * MEMORYBLOCKTYPE_SIZE then
      declare
         Half_Block : aliased Memory_Block_Type
            with Address    => Q.all'Address + Storage_Offset (RSize),
                 Import     => True,
                 Convention => Ada;
      begin
         if Debug then
            Console.Print (
               Prefix => "Creating free block @ ",
               Value  => Half_Block'Address,
               NL     => True
               );
         end if;
         P.all.Next_Ptr := Half_Block'Unchecked_Access;
         P.all.Next_Ptr.all.Size := Q.all.Size - RSize;
         P.all.Next_Ptr.all.Next_Ptr := Q.all.Next_Ptr;
         Q.all.Size := RSize;
      end;
   else
      -- use whole block
      P.all.Next_Ptr := Q.all.Next_Ptr;
   end if;
   Q.all.Next_Ptr := null;
   Mutex.Release (Mtx);
   return Q.all'Address + MEMORYBLOCKTYPE_SIZE;
end Malloc;
