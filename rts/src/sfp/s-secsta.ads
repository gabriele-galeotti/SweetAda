------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--               S Y S T E M . S E C O N D A R Y _ S T A C K                --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2019, Free Software Foundation, Inc.         --
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

pragma Compiler_Unit_Warning;

with System.Parameters;
with System.Storage_Elements;

package System.Secondary_Stack is
   pragma Preelaborate;

   package SP  renames System.Parameters;
   package SSE renames System.Storage_Elements;

   use type SP.Size_Type;

   type SS_Stack (Default_Chunk_Size : SP.Size_Type) is private;
   --  An abstraction for a heap structure maintained in a stack-like fashion.
   --  The structure is comprised of chunks which accommodate allocations of
   --  varying sizes. See the private part of the package for further details.
   --  Default_Chunk_Size indicates the size of the static chunk, and provides
   --  a minimum size for all dynamic chunks.

   type SS_Stack_Ptr is access all SS_Stack;
   --  A reference to a secondary stack

   type Mark_Id is private;
   --  An abstraction for tracking the state of the secondary stack

   procedure SS_Allocate
     (Addr         : out Address;
      Storage_Size : SSE.Storage_Count);
   --  Allocate enough space on the secondary stack of the invoking task to
   --  accommodate an alloction of size Storage_Size. Return the address of the
   --  first byte of the allocation in Addr. The routine may carry out one or
   --  more of the following actions:
   --
   --    * Reuse an existing chunk that is big enough to accommodate the
   --      requested Storage_Size.
   --
   --    * Free an existing chunk that is too small to accommodate the
   --      requested Storage_Size.
   --
   --    * Create a new chunk that fits the requested Storage_Size.

   procedure SS_Free (Stack : in out SS_Stack_Ptr);
   --  Free all dynamic chunks of secondary stack Stack. If possible, free the
   --  stack itself.

   function SS_Mark return Mark_Id;
   --  Capture and return the state of the invoking task's secondary stack

   procedure SS_Release (M : Mark_Id);
   --  Restore the state of the invoking task's secondary stack to mark M

private
   SS_Pool : Integer;
   --  Unused entity that is just present to ease the sharing of the pool
   --  mechanism for specific allocation/deallocation in the compiler.

   --------------------------
   -- Memory-related types --
   --------------------------

   subtype Memory_Size_With_Invalid is SP.Size_Type;
   --  Memory storage size which also includes an invalid negative range

   Invalid_Memory_Size : constant Memory_Size_With_Invalid := -1;

   subtype Memory_Size is
     Memory_Size_With_Invalid range 0 .. SP.Size_Type'Last;
   --  The memory storage size of a single chunk or the whole secondary stack.
   --  A non-negative size is considered a "valid" size.

   subtype Memory_Index is Memory_Size;
   --  Index into the memory storage of a single chunk

   type Chunk_Memory is array (Memory_Size range <>) of SSE.Storage_Element;
   for Chunk_Memory'Alignment use Standard'Maximum_Alignment;
   --  The memory storage of a single chunk. It utilizes maximum alignment in
   --  order to guarantee efficient operations.

   --------------
   -- SS_Chunk --
   --------------

   type SS_Chunk (Size : Memory_Size);
   --  Abstraction for a chunk. Size indicates the memory capacity of the
   --  chunk.

   type SS_Chunk_Ptr is access all SS_Chunk;
   --  Reference to the static or any dynamic chunk

   type SS_Chunk (Size : Memory_Size) is record
      Next : SS_Chunk_Ptr;
      --  Pointer to the next chunk. The direction of the pointer is from the
      --  static chunk to the first dynamic chunk, and so on.

      Size_Up_To_Chunk : Memory_Size;
      --  The size of the secondary stack up to, but excluding the current
      --  chunk. This value aids in calculating the total amount of memory
      --  the stack is consuming, for high-water-mark update purposes.

      Memory : Chunk_Memory (1 .. Size);
      --  The memory storage of the chunk. The 1-indexing facilitates various
      --  size and indexing calculations.
   end record;

   -------------------
   -- Stack_Pointer --
   -------------------

   --  Abstraction for a secondary stack pointer

   type Stack_Pointer is record
      Byte : Memory_Index;
      --  The position of the first free byte within the memory storage of
      --  Chunk.all. Byte - 1 denotes the last occupied byte within Chunk.all.

      Chunk : SS_Chunk_Ptr;
      --  Reference to the chunk that accommodated the most recent allocation.
      --  This could be the static or any dynamic chunk.
   end record;

   --------------
   -- SS_Stack --
   --------------

   type SS_Stack (Default_Chunk_Size : SP.Size_Type) is record
      Freeable : Boolean;
      --  Indicates whether the secondary stack can be freed

      High_Water_Mark : Memory_Size;
      --  The maximum amount of memory in use throughout the lifetime of the
      --  secondary stack.

      Top : Stack_Pointer;
      --  The stack pointer

      Static_Chunk : aliased SS_Chunk (Default_Chunk_Size);
      --  A special chunk with a default size. On targets that do not support
      --  dynamic allocations, this chunk represents the capacity of the whole
      --  secondary stack.
   end record;

   -------------
   -- Mark_Id --
   -------------

   type Mark_Id is record
      Stack : SS_Stack_Ptr;
      --  The secondary stack whose mark was taken

      Top : Stack_Pointer;
      --  The value of Stack.Top at the point in time when the mark was taken
   end record;

end System.Secondary_Stack;
