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

package body Memory_Functions is

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
   -- Memcmp
   ----------------------------------------------------------------------------
   -- Ada implementation of the equivalent C standard library function.
   ----------------------------------------------------------------------------
   function Memcmp (
                    S1 : System.Address;
                    S2 : System.Address;
                    N  : Interfaces.C.size_t
                   ) return Interfaces.C.int is
   separate;

   ----------------------------------------------------------------------------
   -- Memcpy
   ----------------------------------------------------------------------------
   -- Ada implementation of the equivalent C standard library function.
   ----------------------------------------------------------------------------
   function Memcpy (
                    S1 : System.Address;
                    S2 : System.Address;
                    N  : Interfaces.C.size_t
                   ) return System.Address is
   separate;

   ----------------------------------------------------------------------------
   -- Memmove
   ----------------------------------------------------------------------------
   -- Ada implementation of the equivalent C standard library function.
   ----------------------------------------------------------------------------
   function Memmove (
                     S1 : System.Address;
                     S2 : System.Address;
                     N  : Interfaces.C.size_t
                    ) return System.Address is
   separate;

   ----------------------------------------------------------------------------
   -- Memset
   ----------------------------------------------------------------------------
   -- Ada implementation of the equivalent C standard library function.
   ----------------------------------------------------------------------------
   function Memset (
                    S : System.Address;
                    C : Interfaces.C.int;
                    N : Interfaces.C.size_t
                   ) return System.Address is
   separate;

   ----------------------------------------------------------------------------
   -- Cmpmem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memcmp.
   ----------------------------------------------------------------------------
   procedure Cmpmem (
                     S1 : in     System.Address;
                     S2 : in     System.Address;
                     N  : in     Bits.Bytesize;
                     R  : in out Integer
                    ) is
   separate;

   ----------------------------------------------------------------------------
   -- Cpymem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memcpy.
   ----------------------------------------------------------------------------
   procedure Cpymem (
                     S1 : in System.Address;
                     S2 : in System.Address;
                     N  : in Bits.Bytesize
                    ) is
   separate;

   ----------------------------------------------------------------------------
   -- Movemem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memmove.
   ----------------------------------------------------------------------------
   procedure Movemem (
                      S1 : in System.Address;
                      S2 : in System.Address;
                      N  : in Bits.Bytesize
                     ) is
   separate;

   ----------------------------------------------------------------------------
   -- Setmem
   ----------------------------------------------------------------------------
   -- Ada procedure version of Memset.
   ----------------------------------------------------------------------------
   procedure Setmem (
                     S : in System.Address;
                     V : in Interfaces.Unsigned_8;
                     N : in Bits.Bytesize
                    ) is
   separate;

end Memory_Functions;
