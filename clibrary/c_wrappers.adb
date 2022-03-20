-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.adb                                                                                            --
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

with Abort_Library;
with Malloc;
with Console;

package body C_Wrappers is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Ada_Abort is
   begin
      Abort_Library.System_Abort;
   end Ada_Abort;

   procedure Ada_Print_Character (c : in Interfaces.C.char) is
   begin
      Console.Print (c);
   end Ada_Print_Character;

   procedure Ada_Print_NewLine is
   begin
      Console.Print_NewLine;
   end Ada_Print_NewLine;

   procedure Ada_Print_UnsignedHex8 (Value : in Interfaces.Unsigned_8) is
   begin
      Console.Print (Value);
   end Ada_Print_UnsignedHex8;

   procedure Ada_Print_UnsignedHex16 (Value : in Interfaces.Unsigned_16) is
   begin
      Console.Print (Value);
   end Ada_Print_UnsignedHex16;

   procedure Ada_Print_UnsignedHex32 (Value : in Interfaces.Unsigned_32) is
   begin
      Console.Print (Value);
   end Ada_Print_UnsignedHex32;

   procedure Ada_Print_UnsignedHex64 (Value : in Interfaces.Unsigned_64) is
   begin
      Console.Print (Value);
   end Ada_Print_UnsignedHex64;

   procedure Ada_Print_AddressHex (Value : in System.Address) is
   begin
      Console.Print (Value);
   end Ada_Print_AddressHex;

   procedure Ada_Print_BitImage (Value : in Interfaces.Unsigned_8) is
   begin
      Console.Print_BitImage (Value);
   end Ada_Print_BitImage;

   function Ada_Malloc (S : Interfaces.C.size_t) return System.Address is
   begin
      return Malloc.Malloc (S);
   end Ada_Malloc;

   procedure Ada_Free (A : in System.Address) is
   begin
      Malloc.Free (A);
   end Ada_Free;

   function Ada_Calloc (N : Interfaces.C.size_t; S : Interfaces.C.size_t) return System.Address is
   begin
      return Malloc.Calloc (N, S);
   end Ada_Calloc;

   function Ada_Realloc (A : System.Address; S : Interfaces.C.size_t) return System.Address is
   begin
      return Malloc.Realloc (A, S);
   end Ada_Realloc;

end C_Wrappers;
