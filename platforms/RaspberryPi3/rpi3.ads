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

   ----------------------------------------------------------------------------
   -- GPIO registers
   ----------------------------------------------------------------------------

   GPIO_INPUT  : constant := 2#000#;
   GPIO_OUTPUT : constant := 2#001#;
   GPIO_ALT0   : constant := 2#100#;
   GPIO_ALT1   : constant := 2#101#;
   GPIO_ALT2   : constant := 2#110#;
   GPIO_ALT3   : constant := 2#111#;
   GPIO_ALT4   : constant := 2#011#;
   GPIO_ALT5   : constant := 2#010#;

   type GPFSEL0_Type is
   record
      FSEL0    : Bits_3;
      FSEL1    : Bits_3;
      FSEL2    : Bits_3;
      FSEL3    : Bits_3;
      FSEL4    : Bits_3;
      FSEL5    : Bits_3;
      FSEL6    : Bits_3;
      FSEL7    : Bits_3;
      FSEL8    : Bits_3;
      FSEL9    : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL0_Type use
   record
      FSEL0    at 0 range 0 .. 2;
      FSEL1    at 0 range 3 .. 5;
      FSEL2    at 0 range 6 .. 8;
      FSEL3    at 0 range 9 .. 11;
      FSEL4    at 0 range 12 .. 14;
      FSEL5    at 0 range 15 .. 17;
      FSEL6    at 0 range 18 .. 20;
      FSEL7    at 0 range 21 .. 23;
      FSEL8    at 0 range 24 .. 26;
      FSEL9    at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL0 : GPFSEL0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#00#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL1_Type is
   record
      FSEL10   : Bits_3;
      FSEL11   : Bits_3;
      FSEL12   : Bits_3;
      FSEL13   : Bits_3;
      FSEL14   : Bits_3;
      FSEL15   : Bits_3;
      FSEL16   : Bits_3;
      FSEL17   : Bits_3;
      FSEL18   : Bits_3;
      FSEL19   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL1_Type use
   record
      FSEL10   at 0 range 0 .. 2;
      FSEL11   at 0 range 3 .. 5;
      FSEL12   at 0 range 6 .. 8;
      FSEL13   at 0 range 9 .. 11;
      FSEL14   at 0 range 12 .. 14;
      FSEL15   at 0 range 15 .. 17;
      FSEL16   at 0 range 18 .. 20;
      FSEL17   at 0 range 21 .. 23;
      FSEL18   at 0 range 24 .. 26;
      FSEL19   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL1 : GPFSEL1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#04#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL2_Type is
   record
      FSEL20   : Bits_3;
      FSEL21   : Bits_3;
      FSEL22   : Bits_3;
      FSEL23   : Bits_3;
      FSEL24   : Bits_3;
      FSEL25   : Bits_3;
      FSEL26   : Bits_3;
      FSEL27   : Bits_3;
      FSEL28   : Bits_3;
      FSEL29   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL2_Type use
   record
      FSEL20   at 0 range 0 .. 2;
      FSEL21   at 0 range 3 .. 5;
      FSEL22   at 0 range 6 .. 8;
      FSEL23   at 0 range 9 .. 11;
      FSEL24   at 0 range 12 .. 14;
      FSEL25   at 0 range 15 .. 17;
      FSEL26   at 0 range 18 .. 20;
      FSEL27   at 0 range 21 .. 23;
      FSEL28   at 0 range 24 .. 26;
      FSEL29   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL2 : GPFSEL2_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL3_Type is
   record
      FSEL30   : Bits_3;
      FSEL31   : Bits_3;
      FSEL32   : Bits_3;
      FSEL33   : Bits_3;
      FSEL34   : Bits_3;
      FSEL35   : Bits_3;
      FSEL36   : Bits_3;
      FSEL37   : Bits_3;
      FSEL38   : Bits_3;
      FSEL39   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL3_Type use
   record
      FSEL30   at 0 range 0 .. 2;
      FSEL31   at 0 range 3 .. 5;
      FSEL32   at 0 range 6 .. 8;
      FSEL33   at 0 range 9 .. 11;
      FSEL34   at 0 range 12 .. 14;
      FSEL35   at 0 range 15 .. 17;
      FSEL36   at 0 range 18 .. 20;
      FSEL37   at 0 range 21 .. 23;
      FSEL38   at 0 range 24 .. 26;
      FSEL39   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL3 : GPFSEL3_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#0C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL4_Type is
   record
      FSEL40   : Bits_3;
      FSEL41   : Bits_3;
      FSEL42   : Bits_3;
      FSEL43   : Bits_3;
      FSEL44   : Bits_3;
      FSEL45   : Bits_3;
      FSEL46   : Bits_3;
      FSEL47   : Bits_3;
      FSEL48   : Bits_3;
      FSEL49   : Bits_3;
      Reserved : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL4_Type use
   record
      FSEL40   at 0 range 0 .. 2;
      FSEL41   at 0 range 3 .. 5;
      FSEL42   at 0 range 6 .. 8;
      FSEL43   at 0 range 9 .. 11;
      FSEL44   at 0 range 12 .. 14;
      FSEL45   at 0 range 15 .. 17;
      FSEL46   at 0 range 18 .. 20;
      FSEL47   at 0 range 21 .. 23;
      FSEL48   at 0 range 24 .. 26;
      FSEL49   at 0 range 27 .. 29;
      Reserved at 0 range 30 .. 31;
   end record;

   GPFSEL4 : GPFSEL4_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#10#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPFSEL5_Type is
   record
      FSEL50   : Bits_3;
      FSEL51   : Bits_3;
      FSEL52   : Bits_3;
      FSEL53   : Bits_3;
      Reserved : Bits_20;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPFSEL5_Type use
   record
      FSEL50   at 0 range 0 .. 2;
      FSEL51   at 0 range 3 .. 5;
      FSEL52   at 0 range 6 .. 8;
      FSEL53   at 0 range 9 .. 11;
      Reserved at 0 range 12 .. 31;
   end record;

   GPFSEL5 : GPFSEL5_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#14#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPSET0_Type is
   record
      SET0  : Boolean;
      SET1  : Boolean;
      SET2  : Boolean;
      SET3  : Boolean;
      SET4  : Boolean;
      SET5  : Boolean;
      SET6  : Boolean;
      SET7  : Boolean;
      SET8  : Boolean;
      SET9  : Boolean;
      SET10 : Boolean;
      SET11 : Boolean;
      SET12 : Boolean;
      SET13 : Boolean;
      SET14 : Boolean;
      SET15 : Boolean;
      SET16 : Boolean;
      SET17 : Boolean;
      SET18 : Boolean;
      SET19 : Boolean;
      SET20 : Boolean;
      SET21 : Boolean;
      SET22 : Boolean;
      SET23 : Boolean;
      SET24 : Boolean;
      SET25 : Boolean;
      SET26 : Boolean;
      SET27 : Boolean;
      SET28 : Boolean;
      SET29 : Boolean;
      SET30 : Boolean;
      SET31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPSET0_Type use
   record
      SET0  at 0 range 0 .. 0;
      SET1  at 0 range 1 .. 1;
      SET2  at 0 range 2 .. 2;
      SET3  at 0 range 3 .. 3;
      SET4  at 0 range 4 .. 4;
      SET5  at 0 range 5 .. 5;
      SET6  at 0 range 6 .. 6;
      SET7  at 0 range 7 .. 7;
      SET8  at 0 range 8 .. 8;
      SET9  at 0 range 9 .. 9;
      SET10 at 0 range 10 .. 10;
      SET11 at 0 range 11 .. 11;
      SET12 at 0 range 12 .. 12;
      SET13 at 0 range 13 .. 13;
      SET14 at 0 range 14 .. 14;
      SET15 at 0 range 15 .. 15;
      SET16 at 0 range 16 .. 16;
      SET17 at 0 range 17 .. 17;
      SET18 at 0 range 18 .. 18;
      SET19 at 0 range 19 .. 19;
      SET20 at 0 range 20 .. 20;
      SET21 at 0 range 21 .. 21;
      SET22 at 0 range 22 .. 22;
      SET23 at 0 range 23 .. 23;
      SET24 at 0 range 24 .. 24;
      SET25 at 0 range 25 .. 25;
      SET26 at 0 range 26 .. 26;
      SET27 at 0 range 27 .. 27;
      SET28 at 0 range 28 .. 28;
      SET29 at 0 range 29 .. 29;
      SET30 at 0 range 30 .. 30;
      SET31 at 0 range 31 .. 31;
   end record;

   GPSET0 : GPSET0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#1C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPSET1_Type is
   record
      SET32    : Boolean;
      SET33    : Boolean;
      SET34    : Boolean;
      SET35    : Boolean;
      SET36    : Boolean;
      SET37    : Boolean;
      SET38    : Boolean;
      SET39    : Boolean;
      SET40    : Boolean;
      SET41    : Boolean;
      SET42    : Boolean;
      SET43    : Boolean;
      SET44    : Boolean;
      SET45    : Boolean;
      SET46    : Boolean;
      SET47    : Boolean;
      SET48    : Boolean;
      SET49    : Boolean;
      SET50    : Boolean;
      SET51    : Boolean;
      SET52    : Boolean;
      SET53    : Boolean;
      Reserved : Bits_10;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPSET1_Type use
   record
      SET32    at 0 range 0 .. 0;
      SET33    at 0 range 1 .. 1;
      SET34    at 0 range 2 .. 2;
      SET35    at 0 range 3 .. 3;
      SET36    at 0 range 4 .. 4;
      SET37    at 0 range 5 .. 5;
      SET38    at 0 range 6 .. 6;
      SET39    at 0 range 7 .. 7;
      SET40    at 0 range 8 .. 8;
      SET41    at 0 range 9 .. 9;
      SET42    at 0 range 10 .. 10;
      SET43    at 0 range 11 .. 11;
      SET44    at 0 range 12 .. 12;
      SET45    at 0 range 13 .. 13;
      SET46    at 0 range 14 .. 14;
      SET47    at 0 range 15 .. 15;
      SET48    at 0 range 16 .. 16;
      SET49    at 0 range 17 .. 17;
      SET50    at 0 range 18 .. 18;
      SET51    at 0 range 19 .. 19;
      SET52    at 0 range 20 .. 20;
      SET53    at 0 range 21 .. 21;
      Reserved at 0 range 22 .. 31;
   end record;

   GPSET1 : GPSET1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#20#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPCLR0_Type is
   record
      CLR0  : Boolean;
      CLR1  : Boolean;
      CLR2  : Boolean;
      CLR3  : Boolean;
      CLR4  : Boolean;
      CLR5  : Boolean;
      CLR6  : Boolean;
      CLR7  : Boolean;
      CLR8  : Boolean;
      CLR9  : Boolean;
      CLR10 : Boolean;
      CLR11 : Boolean;
      CLR12 : Boolean;
      CLR13 : Boolean;
      CLR14 : Boolean;
      CLR15 : Boolean;
      CLR16 : Boolean;
      CLR17 : Boolean;
      CLR18 : Boolean;
      CLR19 : Boolean;
      CLR20 : Boolean;
      CLR21 : Boolean;
      CLR22 : Boolean;
      CLR23 : Boolean;
      CLR24 : Boolean;
      CLR25 : Boolean;
      CLR26 : Boolean;
      CLR27 : Boolean;
      CLR28 : Boolean;
      CLR29 : Boolean;
      CLR30 : Boolean;
      CLR31 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPCLR0_Type use
   record
      CLR0  at 0 range 0 .. 0;
      CLR1  at 0 range 1 .. 1;
      CLR2  at 0 range 2 .. 2;
      CLR3  at 0 range 3 .. 3;
      CLR4  at 0 range 4 .. 4;
      CLR5  at 0 range 5 .. 5;
      CLR6  at 0 range 6 .. 6;
      CLR7  at 0 range 7 .. 7;
      CLR8  at 0 range 8 .. 8;
      CLR9  at 0 range 9 .. 9;
      CLR10 at 0 range 10 .. 10;
      CLR11 at 0 range 11 .. 11;
      CLR12 at 0 range 12 .. 12;
      CLR13 at 0 range 13 .. 13;
      CLR14 at 0 range 14 .. 14;
      CLR15 at 0 range 15 .. 15;
      CLR16 at 0 range 16 .. 16;
      CLR17 at 0 range 17 .. 17;
      CLR18 at 0 range 18 .. 18;
      CLR19 at 0 range 19 .. 19;
      CLR20 at 0 range 20 .. 20;
      CLR21 at 0 range 21 .. 21;
      CLR22 at 0 range 22 .. 22;
      CLR23 at 0 range 23 .. 23;
      CLR24 at 0 range 24 .. 24;
      CLR25 at 0 range 25 .. 25;
      CLR26 at 0 range 26 .. 26;
      CLR27 at 0 range 27 .. 27;
      CLR28 at 0 range 28 .. 28;
      CLR29 at 0 range 29 .. 29;
      CLR30 at 0 range 30 .. 30;
      CLR31 at 0 range 31 .. 31;
   end record;

   GPCLR0 : GPCLR0_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#28#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type GPCLR1_Type is
   record
      CLR32    : Boolean;
      CLR33    : Boolean;
      CLR34    : Boolean;
      CLR35    : Boolean;
      CLR36    : Boolean;
      CLR37    : Boolean;
      CLR38    : Boolean;
      CLR39    : Boolean;
      CLR40    : Boolean;
      CLR41    : Boolean;
      CLR42    : Boolean;
      CLR43    : Boolean;
      CLR44    : Boolean;
      CLR45    : Boolean;
      CLR46    : Boolean;
      CLR47    : Boolean;
      CLR48    : Boolean;
      CLR49    : Boolean;
      CLR50    : Boolean;
      CLR51    : Boolean;
      CLR52    : Boolean;
      CLR53    : Boolean;
      Reserved : Bits_10;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPCLR1_Type use
   record
      CLR32    at 0 range 0 .. 0;
      CLR33    at 0 range 1 .. 1;
      CLR34    at 0 range 2 .. 2;
      CLR35    at 0 range 3 .. 3;
      CLR36    at 0 range 4 .. 4;
      CLR37    at 0 range 5 .. 5;
      CLR38    at 0 range 6 .. 6;
      CLR39    at 0 range 7 .. 7;
      CLR40    at 0 range 8 .. 8;
      CLR41    at 0 range 9 .. 9;
      CLR42    at 0 range 10 .. 10;
      CLR43    at 0 range 11 .. 11;
      CLR44    at 0 range 12 .. 12;
      CLR45    at 0 range 13 .. 13;
      CLR46    at 0 range 14 .. 14;
      CLR47    at 0 range 15 .. 15;
      CLR48    at 0 range 16 .. 16;
      CLR49    at 0 range 17 .. 17;
      CLR50    at 0 range 18 .. 18;
      CLR51    at 0 range 19 .. 19;
      CLR52    at 0 range 20 .. 20;
      CLR53    at 0 range 21 .. 21;
      Reserved at 0 range 22 .. 31;
   end record;

   GPCLR1 : GPCLR1_Type with
      Address              => To_Address (GPIO_BASEADDRESS + 16#2C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- AUX registers
   ----------------------------------------------------------------------------

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
   AUX_MU_LSR_REG  : Unsigned_32 with
      Address              => To_Address (AUX_BASEADDRESS + 16#54#),
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

   ----------------------------------------------------------------------------
   -- MAILBOX
   ----------------------------------------------------------------------------

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

   -- POLL   @ 0x10
   -- SENDER @ 0x14
   -- CONFIG @ 0x1C
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
