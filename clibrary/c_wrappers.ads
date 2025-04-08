-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.ads                                                                                            --
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

with System;
with Bits.C;

package C_Wrappers
   with Preelaborate => True,
        SPARK_Mode   => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CTYPE
   ----------------------------------------------------------------------------

   function Is_Alnum
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isalnum";

   function Is_Alpha
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isalpha";

   function Is_Cntrl
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "iscntrl";

   function Is_Digit
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isdigit";

   function Is_Graph
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isgraph";

   function Is_Lower
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "islower";

   function Is_Print
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isprint";

   function Is_Punct
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "ispunct";

   function Is_Space
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isspace";

   function Is_Upper
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isupper";

   function Is_XDigit
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isxdigit";

   function Is_ASCII
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "isascii";

   function To_ASCII
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "toascii";

   function To_Lower
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "tolower";

   function To_Upper
      (c : Bits.C.int)
      return Bits.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "toupper";

   ----------------------------------------------------------------------------
   -- ERRNO
   ----------------------------------------------------------------------------

   Errno : Bits.C.int
      with Volatile      => True,
           Export        => True,
           Convention    => C,
           External_Name => "errno";

   ----------------------------------------------------------------------------
   -- STDIO
   ----------------------------------------------------------------------------

   procedure Ada_Print_Character
      (c : in Bits.C.char)
      with Export        => True,
           Convention    => C,
           External_Name => "ada_print_character";

   ----------------------------------------------------------------------------
   -- STDLIB
   ----------------------------------------------------------------------------

   procedure Ada_Abort
      with Export        => True,
           Convention    => C,
           External_Name => "ada_abort",
           No_Return     => True;

   function Ada_Malloc
      (S : Bits.C.size_t)
      return System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "ada_malloc";

   procedure Ada_Free
      (A : in System.Address)
      with Export        => True,
           Convention    => C,
           External_Name => "ada_free";

   function Ada_Calloc
      (N : Bits.C.size_t;
       S : Bits.C.size_t)
      return System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "ada_calloc";

   function Ada_Realloc
      (A : System.Address;
       S : Bits.C.size_t)
      return System.Address
      with Export        => True,
           Convention    => C,
           External_Name => "ada_realloc";

   ----------------------------------------------------------------------------
   -- STRING
   ----------------------------------------------------------------------------

end C_Wrappers;
