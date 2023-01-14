-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malloc.ads                                                                                                --
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
with Interfaces.C;
with Bits;

package Malloc is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   procedure Init (
                   Memory_Address : in System.Address;
                   Size           : in Bits.Bytesize;
                   Debug_Flag     : in Boolean
                  );

   function Malloc (Size : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "__gnat_malloc";

   procedure Free (Memory_Address : in System.Address) with
      Export        => True,
      Convention    => C,
      External_Name => "__gnat_free";

   function Calloc (Nmemb : Interfaces.C.size_t; Size : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => Ada,
      External_Name => "malloc__calloc";

   function Realloc (Memory_Address : System.Address; Size : Interfaces.C.size_t) return System.Address with
      Export        => True,
      Convention    => Ada,
      External_Name => "malloc__realloc";

end Malloc;
