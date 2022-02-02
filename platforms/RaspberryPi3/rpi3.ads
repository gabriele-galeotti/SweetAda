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
with Bits;

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
   use Bits;

   PERIPHERALS_BASEADDRESS  : constant := 16#3F00_0000#;
   SYSTEM_TIMER_BASEADDRESS : constant := PERIPHERALS_BASEADDRESS + 16#0000_3000#;
   INTERRUPTS_BASEADDRESS   : constant := PERIPHERALS_BASEADDRESS + 16#0000_B000#;
   MAILBOX_BASEADDRESS      : constant := PERIPHERALS_BASEADDRESS + 16#0000_B880#;
   GPIO_BASEADDRESS         : constant := PERIPHERALS_BASEADDRESS + 16#0020_0000#;
   AUX_BASEADDRESS          : constant := PERIPHERALS_BASEADDRESS + 16#0021_5000#;
   EMMC_BASEADDRESS         : constant := PERIPHERALS_BASEADDRESS + 16#0030_0000#;

   GPFSEL0 : Unsigned_32 with
      Address              => To_Address (GPIO_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GPFSEL1 : Unsigned_32 with
      Address              => To_Address (GPIO_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   LEDON : Unsigned_32 with
      Address              => To_Address (GPIO_BASEADDRESS + 16#1C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   LEDOFF : Unsigned_32 with
      Address              => To_Address (GPIO_BASEADDRESS + 16#28#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   AUXENB          : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_IO_REG   : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#40#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_LCR_REG  : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#4C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_CNTL_REG : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#60#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   AUX_MU_BAUD     : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#68#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type Message_Type is
   record
      Channel : Bits.Bits_4;
      Data    : Bits.Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Message_Type use
   record
      Channel at 0 range 0 .. 3;
      Data    at 0 range 4 .. 31;
   end record;

   type Message_Status_Type is
   record
      Reserved : Bits.Bits_30;
      Empty    : Boolean;
      Full     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Message_Status_Type use
   record
      Reserved at 0 range 0 .. 29;
      Empty    at 0 range 30 .. 30;
      Full     at 0 range 31 .. 31;
   end record;

   MAIL0_Read   : Message_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   MAIL0_Status : Message_Status_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#18#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   MAIL0_Write  : Message_Type with
      Address              => To_Address (MAILBOX_BASEADDRESS + 16#20#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end RPI3;
