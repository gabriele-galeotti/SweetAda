-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions.adb                                                                                      --
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

with Ada.Unchecked_Conversion;

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
   use type Interfaces.C.int;
   use type Interfaces.C.size_t;

   -- generic external memory area
   subtype Memory_Area_Type is Interfaces.C.char_array (Interfaces.C.size_t);
   type Memory_Area_Ptr is access all Memory_Area_Type;
   pragma No_Strict_Aliasing (Memory_Area_Ptr);

   function EMemcmp
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "memcmp";

   function EMemcpy
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "memcpy";

   function EMemmove
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "memmove";

   function EMemset
      (S : System.Address;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return System.Address
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

   --
   -- NOTE: memory functions have pragma Suppress (Access_Check) because some
   -- targets (most notably MicroBlaze, during vectors relocation) want to
   -- write at address 0 (which is an invalid access value)
   --

   ----------------------------------------------------------------------------
   -- Overridable library versions
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- EMemcmp
   ----------------------------------------------------------------------------
   function EMemcmp
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return Interfaces.C.int
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemcpy
   ----------------------------------------------------------------------------
   function EMemcpy
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemmove
   ----------------------------------------------------------------------------
   function EMemmove
      (S1 : System.Address;
       S2 : System.Address;
       N  : Interfaces.C.size_t)
      return System.Address
      is
   separate;

   ----------------------------------------------------------------------------
   -- EMemset
   ----------------------------------------------------------------------------
   function EMemset
      (S : System.Address;
       C : Interfaces.C.int;
       N : Interfaces.C.size_t)
      return System.Address
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
         (A1 : System.Address;
          A2 : System.Address;
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
         (A1 : System.Address;
          A2 : System.Address;
          N  : Interfaces.C.size_t)
         return System.Address
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
         (A1 : System.Address;
          A2 : System.Address;
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
      (S : System.Address;
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
      R := Integer (Memcmp (Dest, Src, N));
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
      Unused := Memcpy (Dest, Src, N);
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
      Unused := Memmove (Dest, Src, N);
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
      Unused := Memset (S, Interfaces.C.int (V), N);
   end Setmem;

end Memory_Functions;
