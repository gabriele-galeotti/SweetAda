-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ switch.ads                                                                                                --
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

package Switch
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   SYSTEM_CLOCK : constant := 133_332_000; -- CFG_RESET_SOURCE[0:3] = 1001
   -- SYSTEM_CLOCK : constant := 166_650_000; -- CFG_RESET_SOURCE[0:3] = 1000

   PCA9534DW_I2C_ADDRESS : constant := 16#42#;
   ADS1110_I2C_ADDRESS   : constant := 16#90#;
   LM75AIM_I2C_ADDRESS   : constant := 16#98#;
   M24LC256_I2C_ADDRESS  : constant := 16#AE#;

end Switch;
