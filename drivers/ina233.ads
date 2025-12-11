-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ina233.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package INA233
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- INA233 36V, 16-Bit, Ultra-Precise I2C and PMBus Output Current, Voltage,
   -- Power, and Energy Monitor With Alert
   -- SBOS790A – APRIL 2017 – REVISED MARCH 2025
   ----------------------------------------------------------------------------

   PMBus_CMD_MFR_ID : constant := 16#99#;

pragma Style_Checks (On);

end INA233;
