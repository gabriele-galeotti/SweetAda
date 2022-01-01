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
                   ) return Interfaces.C.int;
   function Memcpy (
                    S1 : System.Address;
                    S2 : System.Address;
                    N  : Interfaces.C.size_t
                   ) return System.Address;
   function Memmove (
                     S1 : System.Address;
                     S2 : System.Address;
                     N  : Interfaces.C.size_t
                    ) return System.Address;
   function Memset (
                    S : System.Address;
                    C : Interfaces.C.int;
                    N : Interfaces.C.size_t
                   ) return System.Address;
   procedure Bcopy (
                    S1 : in System.Address;
                    S2 : in System.Address;
                    N  : in Interfaces.C.size_t
                   );
   procedure Cpymem (
                     S1 : System.Address; -- source
                     S2 : System.Address; -- destination
                     N  : Bits.Bytesize
                    );

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (C, Memcmp, "memcmp");
   pragma Export (C, Memcpy, "memcpy");
   pragma Export (C, Memmove, "memmove");
   pragma Export (C, Memset, "memset");
   pragma Export (C, Bcopy, "bcopy");
   pragma Export (C, Cpymem, "cpymem");

end Memory_Functions;
