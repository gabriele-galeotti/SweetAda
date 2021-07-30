-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Interfaces;
with Integer_Math;
with Memory_Functions;
with Console;

package body Malloc is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Interfaces.C;
   use Bits;
   use Integer_Math;

   type Memory_Block_Type;
   type Memory_Block_Ptr is access all Memory_Block_Type;

   DEFAULT_ALIGNMENT    : constant := 16;
   -- Size includes Memory_Block tag
   MEMORYBLOCKTYPE_SIZE : constant := DEFAULT_ALIGNMENT *
      ((((size_t'Size + Standard'Address_Size) / Storage_Unit) + DEFAULT_ALIGNMENT - 1) / DEFAULT_ALIGNMENT);

   type Memory_Block_Type is
   record
      Size         : size_t;
      Pointer_Next : Memory_Block_Ptr;
   end record with
      Pack      => True,
      Alignment => DEFAULT_ALIGNMENT,
      Size      => MEMORYBLOCKTYPE_SIZE * Storage_Unit;

   Heap_Descriptor : aliased Memory_Block_Type := (Size => 0, Pointer_Next => null);

   Debug : Boolean := False;

   function Round_Size (Size : size_t; Alignment : Natural) return size_t with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Round_Size
   ----------------------------------------------------------------------------
   function Round_Size (Size : size_t; Alignment : Natural) return size_t is
   begin
      return size_t (Roundup (Natural (Size), Alignment));
   end Round_Size;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (
                   Memory_Address : in Address;
                   Size           : in Bytesize;
                   Debug_Flag     : in Boolean
                  ) is
      Heap_Block : aliased Memory_Block_Type with
         Address    => Memory_Address,
         Import     => True,
         Convention => Ada;
   begin
      Debug := Debug_Flag;
      -- simulate a request to sbrk()
      Heap_Block.Size         := Size;
      Heap_Block.Pointer_Next := null;
      if Debug then
         Console.Print (Heap_Block.Size, Prefix => "Initializing: ", NL => True);
         Console.Print (Integer'(MEMORYBLOCKTYPE_SIZE), Prefix => "MEMORYBLOCKTYPE_SIZE:  ", NL => True);
      end if;
      Free (Heap_Block'Address + MEMORYBLOCKTYPE_SIZE);
   end Init;

   ----------------------------------------------------------------------------
   -- Malloc
   ----------------------------------------------------------------------------
   function Malloc (Size : size_t) return Address is
      RSize : size_t;
      P     : Memory_Block_Ptr;
      Q     : Memory_Block_Ptr;
   begin
      if Debug then
         Console.Print (Size, Prefix => "Requesting: ", NL => True);
      end if;
      if Size = 0 then
         return Null_Address;
      end if;
      RSize := Round_Size (MEMORYBLOCKTYPE_SIZE + Size, DEFAULT_ALIGNMENT);
      if Debug then
         Console.Print (RSize, Prefix => "Rounded size: ", NL => True);
      end if;
      -- traverse the list of free block
      P := Heap_Descriptor'Access;
      Q := Heap_Descriptor.Pointer_Next;
      while Q /= null and then Q.all.Size < RSize loop
         P := Q;
         Q := Q.all.Pointer_Next;
      end loop;
      if Q = null then
         -- no block with sufficient size was found
         return Null_Address;
      end if;
      if Debug then
         Console.Print (Q.all'Address, Prefix => "Found block @ ", NL => True);
      end if;
      -- the memory block could be too big to be provided as a whole; if
      -- possible, split it in two sub-blocks, one for the user and the other
      -- stuck in the pool as available memory space
      if Q.all.Size - RSize >= 2 * MEMORYBLOCKTYPE_SIZE then
         declare
            Half_Block : aliased Memory_Block_Type with
               Address    => Q.all'Address + Storage_Offset (RSize),
               Import     => True,
               Convention => Ada;
         begin
            if Debug then
               Console.Print (Half_Block'Address, Prefix => "Creating free block @ ", NL => True);
            end if;
            P.all.Pointer_Next := Half_Block'Unchecked_Access;
            P.all.Pointer_Next.all.Size := Q.all.Size - RSize;
            P.all.Pointer_Next.all.Pointer_Next := Q.all.Pointer_Next;
            Q.all.Size := RSize;
         end;
      else
         -- use whole block
         P.all.Pointer_Next := Q.all.Pointer_Next;
      end if;
      Q.all.Pointer_Next := null;
      return Q.all'Address + MEMORYBLOCKTYPE_SIZE;
   end Malloc;

   ----------------------------------------------------------------------------
   -- Free
   ----------------------------------------------------------------------------
   procedure Free (Memory_Address : in Address) is
      P            : aliased Memory_Block_Ptr;
      Q            : aliased Memory_Block_Ptr;
      Memory_Block : aliased Memory_Block_Type with
         Address    => Memory_Address - MEMORYBLOCKTYPE_SIZE, -- uncover the data structure
         Import     => True,
         Convention => Ada;
   begin
      if Memory_Address = Null_Address then
         return;
      end if;
      -- traverse the list of free blocks, sorting by address
      P := Heap_Descriptor'Access;
      Q := Heap_Descriptor.Pointer_Next;
      while Q /= null and then Q.all'Address < Memory_Block'Address loop
         P := Q;
         Q := Q.all.Pointer_Next;
      end loop;
      -- try to merge with the following block
      if Q /= null then
         -- following block (pointed to by Q) with higher address exists
         declare
            Next_Block : aliased Memory_Block_Type with
               Address    => Memory_Block'Address + Storage_Offset (Memory_Block.Size),
               Import     => True,
               Convention => Ada;
         begin
            -- check if they are the same (no hole in between)
            if Next_Block'Address = Q.all'Address then
               Memory_Block.Size         := Memory_Block.Size + Next_Block.Size;
               Memory_Block.Pointer_Next := Next_Block.Pointer_Next;
            else
               Memory_Block.Pointer_Next := Q;
            end if;
         end;
      else
         -- this is the last block
         Memory_Block.Pointer_Next := null;
      end if;
      -- try to merge with the preceding block
      if P /= Heap_Descriptor'Access then
         declare
            Previous_Block : aliased Memory_Block_Type with
               Address    => P.all'Address + Storage_Offset (P.all.Size),
               Import     => True,
               Convention => Ada;
         begin
            if Previous_Block'Address = Memory_Block'Address then
               P.all.Size         := P.all.Size + Memory_Block.Size;
               P.all.Pointer_Next := Memory_Block.Pointer_Next;
            else
               P.all.Pointer_Next := Memory_Block'Unchecked_Access;
            end if;
         end;
      else
         Heap_Descriptor.Pointer_Next := Memory_Block'Unchecked_Access;
      end if;
      if Debug then
         Console.Print (Memory_Block'Address, Prefix => "Free block: ", NL => True);
      end if;
   end Free;

   ----------------------------------------------------------------------------
   -- Calloc
   ----------------------------------------------------------------------------
   function Calloc (Nmemb : size_t; Size : size_t) return Address is
      Nbytes         : size_t;
      Memory_Address : Address;
   begin
      Nbytes := Nmemb * Size;
      Memory_Address := Malloc (Nbytes);
      if Memory_Address /= Null_Address then
         Memory_Address := Memory_Functions.Memset (Memory_Address, 0, Nbytes);
      end if;
      return Memory_Address;
   end Calloc;

   ----------------------------------------------------------------------------
   -- Realloc
   ----------------------------------------------------------------------------
   -- Realloc (Null_Address, Size) is the same as Malloc (Size)
   -- Realloc (Memory_Address, 0) is the same as Free (Memory_Address)
   ----------------------------------------------------------------------------
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

end Malloc;
