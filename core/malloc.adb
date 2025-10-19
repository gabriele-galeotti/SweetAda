-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc.adb                                                                                                --
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

with System.Storage_Elements;
with Integer_Math;
with Memory_Functions;
with Mutex;
with Console;

package body Malloc
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Bits;
   use Bits.C;
   use Integer_Math;

   DEFAULT_ALIGNMENT    : constant := 16;
   -- Size includes Memory_Block tag
   MEMORYBLOCKTYPE_SIZE : constant := DEFAULT_ALIGNMENT *
      ((((size_t'Size + Standard'Address_Size) / Storage_Unit) + DEFAULT_ALIGNMENT - 1) / DEFAULT_ALIGNMENT);

   type Memory_Block_Type;
   type Memory_Block_Ptr is access all Memory_Block_Type;

   type Memory_Block_Type is record
      Size     : size_t;
      Next_Ptr : Memory_Block_Ptr;
   end record
      with Pack      => True,
           Alignment => DEFAULT_ALIGNMENT,
           Size      => MEMORYBLOCKTYPE_SIZE * Storage_Unit;

   Heap_Descriptor : aliased Memory_Block_Type := (Size => 0, Next_Ptr => null);

   Mtx : Mutex.Semaphore_Binary := Mutex.SEMAPHORE_UNLOCKED;

   Debug : Boolean := False;

   function Round_Size
      (Size      : size_t;
       Alignment : Natural)
      return size_t
      with Inline => True;

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
   function Round_Size
      (Size      : size_t;
       Alignment : Natural)
      return size_t
      is
   begin
      return size_t (Roundup (Natural (Size), Alignment));
   end Round_Size;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (Memory_Address : in Address;
       Size           : in Bytesize;
       Debug_Flag     : in Boolean)
      is
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
            Prefix => "Initializing:         ",
            Value  => Heap_Block.Size,
            NL     => True
            );
         Console.Print (
            Prefix => "MEMORYBLOCKTYPE_SIZE: ",
            Value  => Integer'(MEMORYBLOCKTYPE_SIZE),
            NL     => True
            );
      end if;
      Free (Heap_Block'Address + MEMORYBLOCKTYPE_SIZE);
   end Init;

   ----------------------------------------------------------------------------
   -- Malloc
   ----------------------------------------------------------------------------
   function Malloc
      (Size : size_t)
      return Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- Free
   ----------------------------------------------------------------------------
   procedure Free
      (Memory_Address : in Address)
      is
   separate;

   ----------------------------------------------------------------------------
   -- Calloc
   ----------------------------------------------------------------------------
   function Calloc
      (Nmemb : size_t;
       Size  : size_t)
      return Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- Realloc
   ----------------------------------------------------------------------------
   function Realloc
      (Memory_Address : Address;
       Size           : size_t)
      return Address
      is
   separate;

end Malloc;
