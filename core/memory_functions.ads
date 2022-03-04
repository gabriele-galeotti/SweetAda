-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ memory_functions.ads                                                                                      --
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
with Interfaces.C;
with Bits;

package Memory_Functions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   function Memcmp (
                    S1 : System.Address;
                    S2 : System.Address;
                    N  : Interfaces.C.size_t
                   ) return Interfaces.C.int with
      Export        => True,
      Convention    => C,
      External_Name => "memcmp";

   function Memcpy (
                    S1 : System.Address;
                    S2 : System.Address;
                    N  : Interfaces.C.size_t
                   ) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "memcpy";

   function Memmove (
                     S1 : System.Address;
                     S2 : System.Address;
                     N  : Interfaces.C.size_t
                    ) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "memmove";

   function Memset (
                    S : System.Address;
                    C : Interfaces.C.int;
                    N : Interfaces.C.size_t
                   ) return System.Address with
      Export        => True,
      Convention    => C,
      External_Name => "memset";

   procedure Bcopy (
                    S1 : in System.Address;
                    S2 : in System.Address;
                    N  : in Interfaces.C.size_t
                   ) with
      Export        => True,
      Convention    => C,
      External_Name => "bcopy";

   procedure Cpymem (
                     S1 : System.Address; -- source
                     S2 : System.Address; -- destination
                     N  : Bits.Bytesize
                    ) with
      Export        => True,
      Convention    => C,
      External_Name => "cpymem";

end Memory_Functions;
