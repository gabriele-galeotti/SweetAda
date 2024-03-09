-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.adb                                                                                            --
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

package body C_Wrappers
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Ada_Abort
      is
      procedure System_Abort
         with Import        => True,
              Convention    => Ada,
              External_Name => "abort_library__system_abort_parameterless",
              No_Return     => True;
   begin
      System_Abort;
   end Ada_Abort;

   procedure Ada_Print_Character
      (c : in Bits.C.char)
      is
      procedure Print
         (cc : in Bits.C.char)
         with Import        => True,
              Convention    => Ada,
              External_Name => "console__print__cchar";
   begin
      Print (c);
   end Ada_Print_Character;

   function Ada_Malloc
      (S : Bits.C.size_t)
      return System.Address
      is
      function Malloc
         (SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => C,
              External_Name => "__gnat_malloc";
   begin
      return Malloc (S);
   end Ada_Malloc;

   procedure Ada_Free
      (A : in System.Address)
      is
      procedure Free
         (AA : in System.Address)
         with Import        => True,
              Convention    => C,
              External_Name => "__gnat_free";
   begin
      Free (A);
   end Ada_Free;

   function Ada_Calloc
      (N : Bits.C.size_t;
       S : Bits.C.size_t)
      return System.Address
      is
      function Calloc
         (NN : Bits.C.size_t;
          SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Ada,
              External_Name => "malloc__calloc";
   begin
      return Calloc (N, S);
   end Ada_Calloc;

   function Ada_Realloc
      (A : System.Address;
       S : Bits.C.size_t)
      return System.Address
      is
      function Realloc
         (AA : System.Address;
          SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Ada,
              External_Name => "malloc__realloc";
   begin
      return Realloc (A, S);
   end Ada_Realloc;

end C_Wrappers;
