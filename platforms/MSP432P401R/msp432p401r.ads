-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ msp432p401r.ads                                                                                           --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;

package MSP432P401R is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;

   WDTCTL : aliased Unsigned_16 with
      Address    => To_Address (16#4000_480C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   PORT_BASE : constant := 16#40004C00#;

   PAOUT_L : aliased Unsigned_8 with
      Address    => To_Address (PORT_BASE + 16#02#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   PADIR_L : aliased Unsigned_8 with
      Address    => To_Address (PORT_BASE + 16#04#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end MSP432P401R;
