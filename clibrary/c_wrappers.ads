-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.ads                                                                                            --
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

with System;
with Interfaces;
with Interfaces.C;

package C_Wrappers is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   procedure Ada_Abort with
      Export        => True,
      Convention    => C,
      External_Name => "abort";

   procedure Ada_Print_Character (c : in Interfaces.C.char) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_character";

   procedure Ada_Print_NewLine with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_newline";

   procedure Ada_Print_UnsignedHex8 (Value : in Interfaces.Unsigned_8) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_hexunsigned8";

   procedure Ada_Print_UnsignedHex16 (Value : in Interfaces.Unsigned_16) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_hexunsigned16";

   procedure Ada_Print_UnsignedHex32 (Value : in Interfaces.Unsigned_32) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_hexunsigned32";

   procedure Ada_Print_UnsignedHex64 (Value : in Interfaces.Unsigned_64) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_hexunsigned64";

   procedure Ada_Print_AddressHex (Value : in System.Address) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_hexaddress";

   procedure Ada_Print_BitImage (Value : in Interfaces.Unsigned_8) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_print_bitimage";

   function Ada_Malloc (S : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "ada_malloc";

   procedure Ada_Free (A : in System.Address) with
      Export        => True,
      Convention    => C,
      External_Name => "ada_free";

   function Ada_Calloc (N : Interfaces.C.size_t; S : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "ada_calloc";

   function Ada_Realloc (A : System.Address; S : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "ada_realloc";

end C_Wrappers;
