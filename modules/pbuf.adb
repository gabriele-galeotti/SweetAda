-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pbuf.adb                                                                                                  --
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

with CPU;

package body PBUF
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Pool_Memory : array (0 .. PBUF_NUMS - 1) of aliased Pbuf_Type;

   Pool_Pointer : Pbuf_Ptr
      with Volatile => True;

   procedure Reset
      (Item : in out Pbuf_Type)
      with Inline => True;

   function Allocate_Simple
      return Pbuf_Ptr;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Reset
   ----------------------------------------------------------------------------
   procedure Reset
      (Item : in out Pbuf_Type)
      is
   begin
      Item.Size            := PBUF_PAYLOAD_SIZE; -- available space
      Item.Total_Size      := 0;                 -- unnecessary, only for clarity
      Item.Offset          := 0;                 -- current payload starting offset
      Item.Offset_Previous := 0;                 -- saved payload starting offset
   end Reset;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      for Index in Pool_Memory'Range loop
         declare
            P : Pbuf_Ptr;
         begin
            P := Pool_Memory (Index)'Access;
            P.all.Index := Index;
            Reset (P.all);
            P.all.Nref := 0;
            if Index /= Pool_Memory'Last then
               P.all.Next := Pool_Memory (Index + 1)'Access;
            else
               -- the Next pointer of last pbuf is null to indicate that there
               -- are no more pbufs in the pool
               -- required because Pbuf_Type is pragma Suppress_Initialization
               P.all.Next := null;
            end if;
         end;
      end loop;
      Pool_Pointer := Pool_Memory (Pool_Memory'First)'Access;
   end Init;

   ----------------------------------------------------------------------------
   -- Allocate_Simple
   ----------------------------------------------------------------------------
   function Allocate_Simple
      return Pbuf_Ptr
      is
      Intcontext : CPU.Intcontext_Type;
      Result     : Pbuf_Ptr;
   begin
      CPU.Intcontext_Get (Intcontext);
      CPU.Irq_Disable;
      if Pool_Pointer /= null then
         declare
            T_Result : constant not null Pbuf_Ptr := Pool_Pointer;
         begin
            Result := T_Result;
            Pool_Pointer := T_Result.all.Next;          -- update the global pointer
            T_Result.all.Next := null;                  -- invalidate Next pointer
            T_Result.all.Nref := T_Result.all.Nref + 1; -- increment reference count
         end;
      end if;
      CPU.Intcontext_Set (Intcontext);
      return Result;
   end Allocate_Simple;

   ----------------------------------------------------------------------------
   -- Allocate
   ----------------------------------------------------------------------------
   -- Allocate a pbuf chain.
   -- __REF__ src/core/pbuf.c:pbuf_alloc()
   ----------------------------------------------------------------------------
   function Allocate
      (Size : Natural)
      return Pbuf_Ptr
      is
      Result         : Pbuf_Ptr; -- first pbuf (head)
      C              : Pbuf_Ptr; -- current (last) allocated pbuf
      N              : Pbuf_Ptr; -- freshly allocated pbuf
      Remaining_Size : Natural;
   begin
      Result := Allocate_Simple;
      if Result /= null then
         -- set total length of the packet stored in this and following pbufs
         Result.all.Total_Size := Size;
         -- if the frame is so small that can be stored in this pbuf, then set
         -- the exact length; else the frame is bigger and the pbuf size is fully
         -- utilized, so no change this field (which is by default set at
         -- the maximum value)
         if Result.all.Total_Size < Result.all.Size then
            Result.all.Size := Size;
         end if;
         -- compute the remaining size of the packet, which will be splitted in
         -- newly allocated elements
         Remaining_Size := Result.all.Total_Size - Result.all.Size;
         C := Result;
         while Remaining_Size > 0 loop
            N := Allocate_Simple;
            if N = null then
               Free (Result);
               Result := null;
               exit;
            end if;
            -- link new pbuf at the tail of chain
            C.all.Next := N;
            -- make it the current item
            C := N;
            -- re-compute remaining size
            C.all.Total_Size := Remaining_Size;
            if C.all.Total_Size <= C.all.Size then
               C.all.Size := Remaining_Size;
            end if;
            Remaining_Size := C.all.Total_Size - C.all.Size;
         end loop;
      end if;
      return Result;
   end Allocate;

   ----------------------------------------------------------------------------
   -- Free
   ----------------------------------------------------------------------------
   procedure Free
      (Item : in Pbuf_Ptr)
      is
      Intcontext : CPU.Intcontext_Type;
      P          : Pbuf_Ptr;
      Q          : Pbuf_Ptr;
   begin
      CPU.Intcontext_Get (Intcontext);
      CPU.Irq_Disable;
      P := Item;
      while P /= null loop
         P.all.Nref := P.all.Nref - 1;
         if P.all.Nref = 0 then
            if P.all.Size = P.all.Total_Size then
               Q := null;               -- end of pbuf chain
            else
               Q := P.all.Next;         -- remember next pbuf in chain
            end if;
            Reset (P.all);
            P.all.Next := Pool_Pointer; -- head-insert
            Pool_Pointer := P;          -- update global pointer
            P := Q;                     -- examine next pbuf
         else
            -- this pbuf (and so every remaining pbuf in chain) is still
            -- referenced, stop walking
            P := null;
         end if;
      end loop;
      CPU.Intcontext_Set (Intcontext);
   end Free;

   ----------------------------------------------------------------------------
   -- Payload_Adjust
   ----------------------------------------------------------------------------
   procedure Payload_Adjust
      (P      : in Pbuf_Ptr;
       Adjust : in Integer)
      is
   begin
      P.all.Offset_Previous := P.all.Offset;
      P.all.Offset          := P.all.Offset - Adjust;
      P.all.Size            := P.all.Size + Adjust;
      P.all.Total_Size      := P.all.Total_Size + Adjust;
   end Payload_Adjust;

   ----------------------------------------------------------------------------
   -- Payload_Rewind
   ----------------------------------------------------------------------------
   procedure Payload_Rewind
      (P : in Pbuf_Ptr)
      is
      Offset_Previous : constant Natural := P.all.Offset;
      Skew            : constant Integer := P.all.Offset - P.all.Offset_Previous;
   begin
      P.all.Size            := P.all.Size + Skew;
      P.all.Total_Size      := P.all.Total_Size + Skew;
      P.all.Offset          := P.all.Offset_Previous;
      P.all.Offset_Previous := Offset_Previous;
   end Payload_Rewind;

   ----------------------------------------------------------------------------
   -- Payload_Address
   ----------------------------------------------------------------------------
   function Payload_Address
      (P      : Pbuf_Ptr;
       Offset : Natural := 0)
      return System.Address
      is
   begin
      return P.all.Payload (Offset)'Address;
   end Payload_Address;

   ----------------------------------------------------------------------------
   -- Payload_CurrentAddress
   ----------------------------------------------------------------------------
   function Payload_CurrentAddress
      (P : Pbuf_Ptr)
      return System.Address
      is
   begin
      return Payload_Address (P, P.all.Offset);
   end Payload_CurrentAddress;

end PBUF;
