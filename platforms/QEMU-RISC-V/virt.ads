-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ virt.ads                                                                                                  --
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

with System.Storage_Elements;
with Interfaces;
with Definitions;
with Goldfish;

package Virt is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   -- Timer

   Timer_Frequency : constant := 10 * Definitions.MHz;
   Timer_Constant  : constant := Timer_Frequency / 1_000;

   -- UART 16x50-style

   UART0_BASEADDRESS : constant := 16#1000_0000#;

   -- Goldfish RTC

   Goldfish_RTC_BASEADDRESS : constant := 16#0010_1000#;

   Goldfish_RTC : aliased Goldfish.RTC_Type with
      Address    => To_Address (Goldfish_RTC_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end Virt;
