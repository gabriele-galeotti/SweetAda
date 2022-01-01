-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
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

   procedure Ada_Print_Character (c : in Interfaces.C.char);
   procedure Ada_Print_NewLine;
   procedure Ada_Print_UnsignedHex8 (Value : in Interfaces.Unsigned_8);
   procedure Ada_Print_UnsignedHex16 (Value : in Interfaces.Unsigned_16);
   procedure Ada_Print_UnsignedHex32 (Value : in Interfaces.Unsigned_32);
   procedure Ada_Print_UnsignedHex64 (Value : in Interfaces.Unsigned_64);
   procedure Ada_Print_AddressHex (Value : in System.Address);
   procedure Ada_Print_BitImage (Value : in Interfaces.Unsigned_8);
   function Ada_Malloc (S : Interfaces.C.size_t) return System.Address;
   procedure Ada_Free (A : in System.Address);
   function Ada_Calloc (N : Interfaces.C.size_t; S : Interfaces.C.size_t) return System.Address;
   function Ada_Realloc (A : System.Address; S : Interfaces.C.size_t) return System.Address;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (C, Ada_Print_Character, "ada_print_character");
   pragma Export (C, Ada_Print_NewLine, "ada_print_newline");
   pragma Export (C, Ada_Print_UnsignedHex8, "ada_print_hexunsigned8");
   pragma Export (C, Ada_Print_UnsignedHex16, "ada_print_hexunsigned16");
   pragma Export (C, Ada_Print_UnsignedHex32, "ada_print_hexunsigned32");
   pragma Export (C, Ada_Print_UnsignedHex64, "ada_print_hexunsigned64");
   pragma Export (C, Ada_Print_AddressHex, "ada_print_hexaddress");
   pragma Export (C, Ada_Print_BitImage, "ada_print_bitimage");
   pragma Export (C, Ada_Malloc, "ada_malloc");
   pragma Export (C, Ada_Free, "ada_free");
   pragma Export (C, Ada_Calloc, "ada_calloc");
   pragma Export (C, Ada_Realloc, "ada_realloc");

end C_Wrappers;
