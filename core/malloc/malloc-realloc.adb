-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc-realloc.adb                                                                                        --
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

separate (Malloc)
function Realloc (Memory_Address : Address; Size : size_t) return Address is
   Memory_Block         : aliased Memory_Block_Type with
      Address    => Memory_Address - MEMORYBLOCKTYPE_SIZE, -- uncover the data structure
      Import     => True,
      Convention => Ada;
   Memory_Block_Address : Address;
   RSize                : size_t;
   P                    : Memory_Block_Ptr;
   Q                    : Memory_Block_Ptr;
begin
   if Memory_Address = Null_Address then
      return Malloc (Size);
   end if;
   if Size = 0 then
      Free (Memory_Address);
      return Null_Address;
   end if;
   Memory_Block_Address := Memory_Block'Address;
   RSize := Round_Size (MEMORYBLOCKTYPE_SIZE + Size, DEFAULT_ALIGNMENT);
   if Memory_Block.Size > RSize then
      -- block is too big, split it in two parts
      declare
         Half_Block : aliased Memory_Block_Type with
            Address    => Memory_Block_Address + Storage_Offset (RSize),
            Import     => True,
            Convention => Ada;
      begin
         Half_Block.Size := Memory_Block.Size - RSize;
         Memory_Block.Size := RSize;
         -- append the newly created block to free list
         Free (Half_Block'Address + MEMORYBLOCKTYPE_SIZE);
      end;
   else
      if Memory_Block.Size < RSize then
         -- obviously, the allocated block is not in the free list, check
         -- if the immediately following memory area is a free block
         declare
            End_Address : Address;
         begin
            P := Heap_Descriptor'Access;
            Q := Heap_Descriptor.Pointer_Next;
            while Q /= null and then Q.all'Address < Memory_Block_Address loop
               P := Q;
               Q := Q.all.Pointer_Next;
            end loop;
            -- compute memory block end address
            End_Address := Memory_Block_Address + Storage_Offset (Memory_Block.Size);
            if
               Q /= null                               and then
               End_Address = Q.all'Address             and then
               Memory_Block.Size + Q.all.Size >= RSize
            then
               -- expand the block in-place
               Memory_Block.Size := Memory_Block.Size + Q.all.Size;
               P.all.Pointer_Next := Q.all.Pointer_Next;
               Q.all.Size         := 0;
               Q.all.Pointer_Next := null;
            else
               -- failure, move the block
               declare
                  New_Memory_Block_Address : Address;
               begin
                  New_Memory_Block_Address := Malloc (RSize);
                  if New_Memory_Block_Address /= Null_Address then
                     New_Memory_Block_Address :=
                        Memory_Functions.Memcpy (
                                                 New_Memory_Block_Address,
                                                 Memory_Block_Address,
                                                 Memory_Block.Size - MEMORYBLOCKTYPE_SIZE
                                                );
                     Free (Memory_Block_Address);
                     -- update address
                     Memory_Block_Address := New_Memory_Block_Address;
                  else
                     return Null_Address;
                  end if;
               end;
            end if;
         end;
      end if;
   end if;
   return Memory_Block_Address;
end Realloc;
