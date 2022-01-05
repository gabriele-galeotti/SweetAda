-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ hifive1.ads                                                                                               --
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

package HiFive1 is

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

   -- PRCI

   PRCI_BASEADDRESS : constant := 16#1000_8000#;

   -- 17 General Purpose Input/Output Controller (GPIO)

   GPIO_ADDRESS : constant := 16#1001_2000#;

   GPIO_OEN : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#08#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   GPIO_PORT : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#0C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   GPIO_IOFEN : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#38#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   GPIO_IOFSEL : aliased Unsigned_32 with
      Address              => To_Address (GPIO_ADDRESS + 16#3C#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 18 Universal Asynchronous Receiver/Transmitter (UART)

   type TXDATA_Type is
   record
      txdata   : Unsigned_8;
      Reserved : Bits.Bits_23;
      full     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32,
      Volatile_Full_Access => True;
   for TXDATA_Type use
   record
      txdata   at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 30;
      full     at 0 range 31 .. 31;
   end record;

   type RXDATA_Type is
   record
      rxdata   : Unsigned_8;
      Reserved : Bits.Bits_23;
      full     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RXDATA_Type use
   record
      rxdata   at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 30;
      full     at 0 range 31 .. 31;
   end record;

   type TXCTRL_Type is
   record
      txen      : Boolean;
      nstop     : Bits.Bits_1;
      Reserved1 : Bits.Bits_14;
      txcnt     : Bits.Bits_3;
      Reserved2 : Bits.Bits_13;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TXCTRL_Type use
   record
      txen      at 0 range 0 .. 0;
      nstop     at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 15;
      txcnt     at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   type RXCTRL_Type is
   record
      rxen      : Boolean;
      Reserved1 : Bits.Bits_15;
      rxcnt     : Bits.Bits_3;
      Reserved2 : Bits.Bits_13;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RXCTRL_Type use
   record
      rxen      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 15;
      rxcnt     at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   type UART_Type is
   record
      txdata : TXDATA_Type;
      rxdata : RXDATA_Type;
      txctrl : TXCTRL_Type;
      rxctrl : RXCTRL_Type;
      ie     : Unsigned_32;
      ip     : Unsigned_32;
      div    : Unsigned_32;
   end record with
      Size => 7 * 32;
   for UART_Type use
   record
      txdata at 16#00# range 0 .. 31;
      rxdata at 16#04# range 0 .. 31;
      txctrl at 16#08# range 0 .. 31;
      rxctrl at 16#0C# range 0 .. 31;
      ie     at 16#10# range 0 .. 31;
      ip     at 16#14# range 0 .. 31;
      div    at 16#18# range 0 .. 31;
   end record;

   UART0_BASEADDRESS : constant := 16#1001_3000#;

   UART0 : aliased UART_Type with
      Address    => To_Address (UART0_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART1_BASEADDRESS : constant := 16#1002_3000#;

   UART1 : aliased UART_Type with
      Address    => To_Address (UART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end HiFive1;
