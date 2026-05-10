-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions.adb                                                                                      --
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

pragma Restrictions (No_Elaboration_Code);

with Ada.Unchecked_Conversion;
with System.Address_To_Access_Conversions;
with Interfaces.C.Extensions;

package body Memory_Functions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type System.Address;

   -- generic external memory area
   subtype Memory_Area_Type is Interfaces.C.char_array (Interfaces.C.size_t);
   package MAP is new System.Address_To_Access_Conversions (Memory_Area_Type);

   function EMemcmp
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "memcmp";

   function EMemcpy
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      with Export        => True,
           Convention    => C,
           External_Name => "memcpy";

   function EMemmove
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      with Export        => True,
           Convention    => C,
           External_Name => "memmove";

   function EMemset
      (S : Interfaces.C.Extensions.void_ptr;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      with Export        => True,
           Convention    => C,
           External_Name => "memset";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Overridable library versions
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- EMemcmp
   ----------------------------------------------------------------------------
   function EMemcmp
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemcpy
   ----------------------------------------------------------------------------
   function EMemcpy
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemmove
   ----------------------------------------------------------------------------
   function EMemmove
      (S1 : Interfaces.C.Extensions.void_ptr;
       S2 : Interfaces.C.Extensions.void_ptr;
       N  : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemset
   ----------------------------------------------------------------------------
   function EMemset
      (S : Interfaces.C.Extensions.void_ptr;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return Interfaces.C.Extensions.void_ptr
      is
   separate;

   ----------------------------------------------------------------------------
   -- Legacy visible versions
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Memcmp
   ----------------------------------------------------------------------------
   function Memcmp
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      is
      function MC
         (A1 : Interfaces.C.Extensions.void_ptr;
          A2 : Interfaces.C.Extensions.void_ptr;
          N  : Interfaces.C.size_t)
         return Interfaces.C.int
         with Import        => True,
              Convention    => Intrinsic,
              External_Name => "__builtin_memcmp";
   begin
      return MC (S1, S2, N);
   end Memcmp;

   ----------------------------------------------------------------------------
   -- Memcpy
   ----------------------------------------------------------------------------
   function Memcpy
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      is
      function MC
         (A1 : Interfaces.C.Extensions.void_ptr;
          A2 : Interfaces.C.Extensions.void_ptr;
          N  : Interfaces.C.size_t)
         return Interfaces.C.Extensions.void_ptr
         with Import        => True,
              Convention    => Intrinsic,
              External_Name => "__builtin_memcpy";
   begin
      return MC (S1, S2, N);
   end Memcpy;

   ----------------------------------------------------------------------------
   -- Memmove
   ----------------------------------------------------------------------------
   function Memmove
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      is
      function MM
         (A1 : Interfaces.C.Extensions.void_ptr;
          A2 : Interfaces.C.Extensions.void_ptr;
          N  : Interfaces.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Intrinsic,
              External_Name => "__builtin_memmove";
   begin
      return MM (S1, S2, N);
   end Memmove;

   ----------------------------------------------------------------------------
   -- Memset
   ----------------------------------------------------------------------------
   function Memset
      (S : Interfaces.C.Extensions.void_ptr;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return System.Address
      is
      function MS
         (A : System.Address;
          X : Interfaces.C.int;
          N : Interfaces.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Intrinsic,
              External_Name => "__builtin_memset";
   begin
      return MS (S, C, N);
   end Memset;

   ----------------------------------------------------------------------------
   -- Cmpmem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memcmp.
   ----------------------------------------------------------------------------
   procedure Cmpmem
      (S1 : in     System.Address;
       S2 : in     System.Address;
       N  : in     Bits.Bytesize;
       R  : in out Integer)
      is
      Src  : constant System.Address := S1;
      Dest : constant System.Address := S2;
   begin
      R := Integer (Memcmp (Dest, Src, Interfaces.C.size_t (N)));
   end Cmpmem;

   ----------------------------------------------------------------------------
   -- Cpymem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memcpy.
   ----------------------------------------------------------------------------
   procedure Cpymem
      (S1 : in System.Address;
       S2 : in System.Address;
       N  : in Bits.Bytesize)
      is
      Src    : constant System.Address := S1;
      Dest   : constant System.Address := S2;
      Unused : System.Address with Unreferenced => True;
   begin
      Unused := Memcpy (Dest, Src, Interfaces.C.size_t (N));
   end Cpymem;

   ----------------------------------------------------------------------------
   -- Movemem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memmove.
   ----------------------------------------------------------------------------
   procedure Movemem
      (S1 : in System.Address;
       S2 : in System.Address;
       N  : in Bits.Bytesize)
      is
      Src    : constant System.Address := S1;
      Dest   : constant System.Address := S2;
      Unused : System.Address with Unreferenced => True;
   begin
      Unused := Memmove (Dest, Src, Interfaces.C.size_t (N));
   end Movemem;

   ----------------------------------------------------------------------------
   -- Setmem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memset.
   ----------------------------------------------------------------------------
   procedure Setmem
      (S : in System.Address;
       V : in Interfaces.Unsigned_8;
       N : in Bits.Bytesize)
      is
      Unused : System.Address with Unreferenced => True;
   begin
      Unused := Memset (S, Interfaces.C.int (V), Interfaces.C.size_t (N));
   end Setmem;

end Memory_Functions;
