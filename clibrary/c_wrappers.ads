-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits.C;

package C_Wrappers
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Ada_Abort
      with Export        => True,
           Convention    => C,
           External_Name => "ada_abort",
           No_Return     => True;

   procedure Ada_Print_Character
      (c : in Bits.C.char)
      with Export        => True,
           Convention    => C,
           External_Name => "ada_print_character";

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

end C_Wrappers;
