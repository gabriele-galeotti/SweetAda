-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rpi3.ads                                                                                                  --
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
with System.Storage_Elements;
with Interfaces;

package RPI3 is

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

   PERIPHERALS_BASEADDRESS : constant := 16#3F00_0000#;
   GPIO_BASEADDRESS        : constant := PERIPHERALS_BASEADDRESS + 16#0020_0000#;
   AUX_BASEADDRESS         : constant := PERIPHERALS_BASEADDRESS + 16#0021_5000#;

   GPFSEL0 : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#00#),
      Volatile_Full_Access   => True,
      Import     => True,
      Convention => Ada;
   GPFSEL1 : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#04#),
      Volatile_Full_Access   => True,
      Import     => True,
      Convention => Ada;

   LEDON : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#1C#),
      Volatile_Full_Access   => True,
      Import     => True,
      Convention => Ada;

   LEDOFF : Unsigned_32 with
      Address    => To_Address (GPIO_BASEADDRESS + 16#28#),
      Volatile_Full_Access   => True,
      Import     => True,
      Convention => Ada;

   AUXENB : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_IO_REG : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#40#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_LCR_REG : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#4C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_CNTL_REG : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#60#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_BAUD : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#68#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end RPI3;
