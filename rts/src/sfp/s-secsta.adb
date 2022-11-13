------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2022, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------
-- SweetAda SFP cutted-down version                                         --
------------------------------------------------------------------------------

-- with Ada.Unchecked_Conversion;
with Ada.Unchecked_Deallocation;

with System.Parameters;       use System.Parameters;
with System.Storage_Elements; use System.Storage_Elements;

package body System.Secondary_Stack is

   ------------------------------------
   -- Binder Allocated Stack Support --
   ------------------------------------

   --  When at least one of the following restrictions
   --
   --    No_Implicit_Heap_Allocations
   --    No_Implicit_Task_Allocations
   --
   --  is in effect, the binder creates a static secondary stack pool, where
   --  each stack has a default size. Assignment of these stacks to tasks is
   --  performed by SS_Init. The following variables are defined in this unit
   --  in order to avoid depending on the binder. Their values are set by the
   --  binder.

   Binder_SS_Count : Natural;
   pragma Export (Ada, Binder_SS_Count, "__gnat_binder_ss_count");
   --  The number of secondary stacks in the pool created by the binder

   Binder_Default_SS_Size : Size_Type;
   pragma Export (Ada, Binder_Default_SS_Size, "__gnat_default_ss_size");
   --  The default secondary stack size as specified by the binder. The value
   --  is defined here rather than in init.c or System.Init because the ZFP and
   --  Ravenscar-ZFP run-times lack these locations.

   Binder_Default_SS_Pool : Address;
   pragma Export (Ada, Binder_Default_SS_Pool, "__gnat_default_ss_pool");
   --  The address of the secondary stack pool created by the binder

   -- __INF__
   SweetAda_Stack : aliased SS_Stack (256);

   -----------------------
   -- Local subprograms --
   -----------------------

   procedure Allocate_Static
     (Stack    : SS_Stack_Ptr;
      Mem_Size : Memory_Size;
      Addr     : out Address);
   pragma Inline (Allocate_Static);
   --  Allocate enough space on static secondary stack Stack to fit a request
   --  of size Mem_Size. Addr denotes the address of the first byte of the
   --  allocation.

   procedure Free is new Ada.Unchecked_Deallocation (SS_Chunk, SS_Chunk_Ptr);
   --  Free a dynamically allocated chunk

   procedure Free is new Ada.Unchecked_Deallocation (SS_Stack, SS_Stack_Ptr);
   --  Free a dynamically allocated secondary stack

   function Has_Enough_Free_Memory
     (Chunk    : SS_Chunk_Ptr;
      Byte     : Memory_Index;
      Mem_Size : Memory_Size) return Boolean;
   pragma Inline (Has_Enough_Free_Memory);
   --  Determine whether chunk Chunk has enough room to fit a memory request of
   --  size Mem_Size, starting from the first free byte of the chunk denoted by
   --  Byte.

   function Size_Up_To_And_Including (Chunk : SS_Chunk_Ptr) return Memory_Size;
   pragma Inline (Size_Up_To_And_Including);
   --  Calculate the size of secondary stack which houses chunk Chunk, from the
   --  start of the secondary stack up to and including Chunk itself. The size
   --  includes the following kinds of memory:
   --
   --    * Free memory in used chunks due to alignment holes
   --    * Occupied memory by allocations
   --
   --  This is a constant time operation, regardless of the secondary stack's
   --  nature.

   function Used_Memory_Size (Stack : SS_Stack_Ptr) return Memory_Size;
   pragma Inline (Used_Memory_Size);
   --  Calculate the size of stack Stack's occupied memory usage. This includes
   --  the following kinds of memory:
   --
   --    * Free memory in used chunks due to alignment holes
   --    * Occupied memory by allocations
   --
   --  This is a constant time operation, regardless of the secondary stack's
   --  nature.

   -----------------------
   -- Allocate_On_Chunk --
   -----------------------

   procedure Allocate_On_Chunk
     (Stack      : SS_Stack_Ptr;
      Prev_Chunk : SS_Chunk_Ptr;
      Chunk      : SS_Chunk_Ptr;
      Byte       : Memory_Index;
      Mem_Size   : Memory_Size;
      Addr       : out Address)
   is
      New_High_Water_Mark : Memory_Size;

   begin
      --  The allocation occurs on a reused or a brand new chunk. Such a chunk
      --  must always be connected to some previous chunk.

      if Prev_Chunk /= null then
         pragma Assert (Prev_Chunk.Next = Chunk);

         --  Update the Size_Up_To_Chunk because this value is invalidated for
         --  reused and new chunks.
         --
         --                         Prev_Chunk          Chunk
         --                             v                 v
         --    . . . . . . .     +--------------+     +--------
         --                . --> |##############| --> |
         --    . . . . . . .     +--------------+     +--------
         --                       |            |
         --    -------------------+------------+
         --      Size_Up_To_Chunk      Size
         --
         --  The Size_Up_To_Chunk is equal to the size of the whole stack up to
         --  the previous chunk, plus the size of the previous chunk itself.

         Chunk.Size_Up_To_Chunk := Size_Up_To_And_Including (Prev_Chunk);
      end if;

      --  The chunk must have enough room to fit the memory request. If this is
      --  not the case, then a previous step picked the wrong chunk.

      pragma Assert (Has_Enough_Free_Memory (Chunk, Byte, Mem_Size));

      --  The first byte of the allocation is the first free byte within the
      --  chunk.

      Addr := Chunk.Memory (Byte)'Address;

      --  The chunk becomes the chunk indicated by the stack pointer. This is
      --  either the currently indicated chunk, an existing chunk, or a brand
      --  new chunk.

      Stack.Top.Chunk := Chunk;

      --  The next free byte is immediately after the memory request
      --
      --          Addr     Top.Byte
      --          |        |
      --    +-----|--------|----+
      --    |##############|    |
      --    +-------------------+

      --  ??? this calculation may overflow on 32bit targets

      Stack.Top.Byte := Byte + Mem_Size;

      --  At this point the next free byte cannot go beyond the memory capacity
      --  of the chunk indicated by the stack pointer, except when the chunk is
      --  full, in which case it indicates the byte beyond the chunk. Ensure
      --  that the occupied memory is at most as much as the capacity of the
      --  chunk. Top.Byte - 1 denotes the last occupied byte.

      pragma Assert (Stack.Top.Byte - 1 <= Stack.Top.Chunk.Size);

      --  Calculate the new high water mark now that the memory request has
      --  been fulfilled, and update if necessary. The new high water mark is
      --  technically the size of the used memory by the whole stack.

      New_High_Water_Mark := Used_Memory_Size (Stack);

      if New_High_Water_Mark > Stack.High_Water_Mark then
         Stack.High_Water_Mark := New_High_Water_Mark;
      end if;
   end Allocate_On_Chunk;

   ---------------------
   -- Allocate_Static --
   ---------------------

   procedure Allocate_Static
     (Stack    : SS_Stack_Ptr;
      Mem_Size : Memory_Size;
      Addr     : out Address)
   is
   begin
      --  Static secondary stack allocations are performed only on the static
      --  chunk. There should be no dynamic chunks following the static chunk.

      pragma Assert (Stack.Top.Chunk = Stack.Static_Chunk'Access);
      pragma Assert (Stack.Top.Chunk.Next = null);

      --  Raise Storage_Error if the static chunk does not have enough room to
      --  fit the memory request. This indicates that the stack is about to be
      --  depleted.

      if not Has_Enough_Free_Memory
               (Chunk    => Stack.Top.Chunk,
                Byte     => Stack.Top.Byte,
                Mem_Size => Mem_Size)
      then
         raise Storage_Error with "secondary stack exhausted";
      end if;

      Allocate_On_Chunk
        (Stack      => Stack,
         Prev_Chunk => null,
         Chunk      => Stack.Top.Chunk,
         Byte       => Stack.Top.Byte,
         Mem_Size   => Mem_Size,
         Addr       => Addr);
   end Allocate_Static;

   ----------------------------
   -- Has_Enough_Free_Memory --
   ----------------------------

   function Has_Enough_Free_Memory
     (Chunk    : SS_Chunk_Ptr;
      Byte     : Memory_Index;
      Mem_Size : Memory_Size) return Boolean
   is
   begin
      --  Byte - 1 denotes the last occupied byte. Subtracting that byte from
      --  the memory capacity of the chunk yields the size of the free memory
      --  within the chunk. The chunk can fit the request as long as the free
      --  memory is as big as the request.

      return Chunk.Size - (Byte - 1) >= Mem_Size;
   end Has_Enough_Free_Memory;

   ------------------------------
   -- Size_Up_To_And_Including --
   ------------------------------

   function Size_Up_To_And_Including
     (Chunk : SS_Chunk_Ptr) return Memory_Size
   is
   begin
      return Chunk.Size_Up_To_Chunk + Chunk.Size;
   end Size_Up_To_And_Including;

   -----------------
   -- SS_Allocate --
   -----------------

   procedure SS_Allocate
     (Addr         : out Address;
      Storage_Size : Storage_Count)
   is
      function Round_Up (Size : Storage_Count) return Memory_Size;
      pragma Inline (Round_Up);
      --  Round Size up to the nearest multiple of the maximum alignment

      --------------
      -- Round_Up --
      --------------

      function Round_Up (Size : Storage_Count) return Memory_Size is
         Algn_MS : constant Memory_Size := Memory_Alignment;
         Size_MS : constant Memory_Size := Memory_Size (Size);

      begin
         --  Detect a case where the Storage_Size is very large and may yield
         --  a rounded result which is outside the range of Chunk_Memory_Size.
         --  Treat this case as secondary-stack depletion.

         if Memory_Size'Last - Algn_MS < Size_MS then
            raise Storage_Error with "secondary stack exhausted";
         end if;

         return ((Size_MS + Algn_MS - 1) / Algn_MS) * Algn_MS;
      end Round_Up;

      --  Local variables

      -- Stack    : constant SS_Stack_Ptr := Get_Sec_Stack.all;
      Stack    : constant SS_Stack_Ptr := SweetAda_Stack'Access;
      Mem_Size : Memory_Size;

   --  Start of processing for SS_Allocate

   begin
      --  Round the requested size up to the nearest multiple of the maximum
      --  alignment to ensure efficient access.

      if Storage_Size = 0 then
         Mem_Size := Memory_Alignment;
      else
         --  It should not be possible to request an allocation of negative
         --  size.

         pragma Assert (Storage_Size >= 0);
         Mem_Size := Round_Up (Storage_Size);
      end if;

      if Sec_Stack_Dynamic then
         -- __INF__ force static allocation
         --  Allocate_Dynamic (Stack, Mem_Size, Addr);
         raise Storage_Error with "dynamic allocation not implemented";
      else
         Allocate_Static  (Stack, Mem_Size, Addr);
      end if;
   end SS_Allocate;

   -------------
   -- SS_Free --
   -------------

   procedure SS_Free (Stack : in out SS_Stack_Ptr) is
      Static_Chunk : constant SS_Chunk_Ptr := Stack.Static_Chunk'Access;
      Next_Chunk   : SS_Chunk_Ptr;

   begin
      --  Free all dynamically allocated chunks. The first dynamic chunk is
      --  found immediately after the static chunk of the stack.

      while Static_Chunk.Next /= null loop
         Next_Chunk := Static_Chunk.Next.Next;
         Free (Static_Chunk.Next);
         Static_Chunk.Next := Next_Chunk;
      end loop;

      --  At this point one of the following outcomes has taken place:
      --
      --    * The stack lacks any dynamic chunks
      --
      --    * The stack had dynamic chunks which were all freed
      --
      --  Either way, there should be nothing hanging off the static chunk

      pragma Assert (Static_Chunk.Next = null);

      --  Free the stack only when it was dynamically allocated

      if Stack.Freeable then
         Free (Stack);
      end if;
   end SS_Free;

   -------------
   -- SS_Mark --
   -------------

   function SS_Mark return Mark_Id is
      -- Stack : constant SS_Stack_Ptr := Get_Sec_Stack.all;
      Stack : constant SS_Stack_Ptr := SweetAda_Stack'Access;

   begin
      return (Stack => Stack, Top => Stack.Top);
   end SS_Mark;

   ----------------
   -- SS_Release --
   ----------------

   procedure SS_Release (M : Mark_Id) is
   begin
      M.Stack.Top := M.Top;
   end SS_Release;

   ----------------------
   -- Used_Memory_Size --
   ----------------------

   function Used_Memory_Size (Stack : SS_Stack_Ptr) return Memory_Size is
   begin
      --  The size of the occupied memory is equal to the size up to the chunk
      --  indicated by the stack pointer, plus the size in use by the indicated
      --  chunk itself. Top.Byte - 1 is the last occupied byte.
      --
      --                                     Top.Byte
      --                                     |
      --    . . . . . . .     +--------------|----+
      --                . ..> |##############|    |
      --    . . . . . . .     +-------------------+
      --                       |             |
      --    -------------------+-------------+
      --      Size_Up_To_Chunk   size in use

      --  ??? this calculation may overflow on 32bit targets

      return Stack.Top.Chunk.Size_Up_To_Chunk + Stack.Top.Byte - 1;
   end Used_Memory_Size;

end System.Secondary_Stack;
