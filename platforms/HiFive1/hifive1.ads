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
   use Bits;

   ----------------------------------------------------------------------------
   -- __REF__ SiFive FE310-G002 Manual v1p0
   ----------------------------------------------------------------------------

   AON_BASEADDRESS : constant := 16#1000_0000#;

   ----------------------------------------------------------------------------
   -- 6 Clock Generation (PRCI)
   ----------------------------------------------------------------------------

   -- 6.3 Internal Trimmable Programmable 72 MHz Oscillator (HFROSC)

   type hfrosccfg_Type is
   record
      hfroscdiv  : Bits_6;           -- Ring Oscillator Divider Register
      Reserved1  : Bits_10 := 0;
      hfrosctrim : Bits_5;           -- Ring Oscillator Trim Register
      Reserved2  : Bits_9 := 0;
      hfroscen   : Boolean;          -- Ring Oscillator Enable
      hfroscrdy  : Boolean := False; -- Ring Oscillator Ready
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for hfrosccfg_Type use
   record
      hfroscdiv  at 0 range 0 .. 5;
      Reserved1  at 0 range 6 .. 15;
      hfrosctrim at 0 range 16 .. 20;
      Reserved2  at 0 range 21 .. 29;
      hfroscen   at 0 range 30 .. 30;
      hfroscrdy  at 0 range 31 .. 31;
   end record;

   -- 6.4 External 16 MHz Crystal Oscillator (HFXOSC)

   type hfxosccfg_Type is
   record
      Reserved  : Bits_30 := 0;
      hfxoscen  : Boolean;          -- Crystal Oscillator Enable
      hfxoscrdy : Boolean := False; -- Crystal Oscillator Ready
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for hfxosccfg_Type use
   record
      Reserved  at 0 range 0 .. 29;
      hfxoscen  at 0 range 30 .. 30;
      hfxoscrdy at 0 range 31 .. 31;
   end record;

   -- 6.5 Internal High-Frequency PLL (HFPLL)

   type pllcfg_Type is
   record
      pllr      : Bits_3;           -- PLL R Value
      Reserved1 : Bits_1 := 0;
      pllf      : Bits_6;           -- PLL F Value
      pllq      : Bits_2;           -- PLL Q Value
      Reserved2 : Bits_4 := 0;
      pllsel    : Boolean;          -- PLL Select
      pllrefsel : Boolean;          -- PLL Reference Select
      pllbypass : Boolean;          -- PLL Bypass
      Reserved3 : Bits_12 := 0;
      plllock   : Boolean := False; -- PLL Lock
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for pllcfg_Type use
   record
      pllr      at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      pllf      at 0 range 4 .. 9;
      pllq      at 0 range 10 .. 11;
      Reserved2 at 0 range 12 .. 15;
      pllsel    at 0 range 16 .. 16;
      pllrefsel at 0 range 17 .. 17;
      pllbypass at 0 range 18 .. 18;
      Reserved3 at 0 range 19 .. 30;
      plllock   at 0 range 31 .. 31;
   end record;

   -- 6.6 PLL Output Divider

   type plloutdiv_Type is
   record
      plloutdiv    : Bits_6;       -- PLL Final Divider Value
      Reserved1    : Bits_2 := 0;
      plloutdivby1 : Bits_6;       -- PLL Final Divide By 1
      Reserved2    : Bits_18 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for plloutdiv_Type use
   record
      plloutdiv    at 0 range 0 .. 5;
      Reserved1    at 0 range 6 .. 7;
      plloutdivby1 at 0 range 8 .. 13;
      Reserved2    at 0 range 14 .. 31;
   end record;

   -- 6.2 PRCI Address Space Usage

   type PRCI_Type is
   record
      hfrosccfg  : hfrosccfg_Type with Volatile_Full_Access => True;
      hfxosccfg  : hfxosccfg_Type with Volatile_Full_Access => True;
      pllcfg     : pllcfg_Type    with Volatile_Full_Access => True;
      plloutdiv  : plloutdiv_Type with Volatile_Full_Access => True;
   end record with
      Size => 4 * 32;
   for PRCI_Type use
   record
      hfrosccfg  at 16#00# range 0 .. 31;
      hfxosccfg  at 16#04# range 0 .. 31;
      pllcfg     at 16#08# range 0 .. 31;
      plloutdiv  at 16#0C# range 0 .. 31;
   end record;

   PRCI_BASEADDRESS : constant := 16#1000_8000#;

   PRCI : aliased PRCI_Type with
      Address    => To_Address (PRCI_BASEADDRESS),
      -- Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 9 Core-Local Interruptor (CLINT)
   ----------------------------------------------------------------------------

   -- msip for hart 0 MSIP Registers (1 bit wide)

   MSIP_ADDRESS : constant := 16#0200_0000#;

   MSIP : aliased Unsigned_32 with
      Address    => To_Address (MSIP_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- mtimecmp for hart 0 MTIMECMP Registers

   MTIMECMP_ADDRESS : constant := 16#0200_4000#;

   MTIMECMP : aliased Unsigned_64 with
      Address    => To_Address (MTIMECMP_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- mtime Timer Register

   Timer_ADDRESS : constant := 16#0200_BFF8#;

   Timer : aliased Unsigned_64 with
      Address    => To_Address (Timer_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 14 Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

   wdogkey_Value  : constant := 16#0051_F15E#;
   wdogfeed_Value : constant := 16#0D09_F00D#;

   -- 14.3 Watchdog Configuration Register (wdogcfg)

   type wdogcfg_Type is
   record
      wdogscale     : Bits_4;       -- Counter scale value.
      Reserved1     : Bits_4 := 0;
      wdogrsten     : Boolean;      -- Controls whether the comp output can set the wdogrst bit and hence cause a full reset.
      wdogzerocmp   : Boolean;
      Reserved2     : Bits_2 := 0;
      wdogenalways  : Boolean;      -- Enable Always - run continuously
      wdogcoreawake : Boolean;      -- Increment the watchdog counter if the processor is not asleep
      Reserved3     : Bits_14 := 0;
      wdogip0       : Boolean;      -- Interrupt 0 Pending
      Reserved4     : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for wdogcfg_Type use
   record
      wdogscale     at 0 range 0 .. 3;
      Reserved1     at 0 range 4 .. 7;
      wdogrsten     at 0 range 8 .. 8;
      wdogzerocmp   at 0 range 9 .. 9;
      Reserved2     at 0 range 10 .. 11;
      wdogenalways  at 0 range 12 .. 12;
      wdogcoreawake at 0 range 13 .. 13;
      Reserved3     at 0 range 14 .. 27;
      wdogip0       at 0 range 28 .. 28;
      Reserved4     at 0 range 29 .. 31;
   end record;

   -- 14.4 Watchdog Compare Register (wdogcmp)

   type wdogcmp_Type is
   record
      wdogcmp0 : Unsigned_16;      -- Comparator 0
      Reserved : Unsigned_16 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for wdogcmp_Type use
   record
      wdogcmp0 at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   type WDT_Type is
   record
      wdogcfg   : wdogcfg_Type with Volatile_Full_Access => True;
      wdogcount : Unsigned_32  with Volatile_Full_Access => True;
      wdogs     : Unsigned_16  with Volatile_Full_Access => True;
      wdogfeed  : Unsigned_32  with Volatile_Full_Access => True;
      wdogkey   : Unsigned_32  with Volatile_Full_Access => True;
      wdogcmp0  : wdogcmp_Type with Volatile_Full_Access => True;
   end record with
      Size => 16#24# * 8;
   for WDT_Type use
   record
      wdogcfg   at 16#00# range 0 .. 31;
      wdogcount at 16#08# range 0 .. 31;
      wdogs     at 16#10# range 0 .. 15;
      wdogfeed  at 16#18# range 0 .. 31;
      wdogkey   at 16#1C# range 0 .. 31;
      wdogcmp0  at 16#20# range 0 .. 31;
   end record;

   WDT_BASEADDRESS : constant := AON_BASEADDRESS;

   WDT : aliased WDT_Type with
      Address    => To_Address (WDT_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 17 General Purpose Input/Output Controller (GPIO)
   ----------------------------------------------------------------------------

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

   ----------------------------------------------------------------------------
   -- 18 Universal Asynchronous Receiver/Transmitter (UART)
   ----------------------------------------------------------------------------

   -- 18.4 Transmit Data Register (txdata)

   type txdata_Type is
   record
      txdata   : Unsigned_8;   -- Transmit data
      Reserved : Bits_23 := 0;
      full     : Boolean;      -- Transmit FIFO full
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for txdata_Type use
   record
      txdata   at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 30;
      full     at 0 range 31 .. 31;
   end record;

   -- 18.5 Receive Data Register (rxdata)

   type rxdata_Type is
   record
      rxdata   : Unsigned_8;   -- Received data
      Reserved : Bits_23 := 0;
      empty    : Boolean;      -- Receive FIFO empty
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for rxdata_Type use
   record
      rxdata   at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 30;
      empty    at 0 range 31 .. 31;
   end record;

   -- 18.6 Transmit Control Register (txctrl)

   nstop_1 : constant := 0; -- one stop bit
   nstop_2 : constant := 1; -- two stop bits

   type txctrl_Type is
   record
      txen      : Boolean;      -- Transmit enable
      nstop     : Bits_1;       -- Number of stop bits
      Reserved1 : Bits_14 := 0;
      txcnt     : Bits_3;       -- Transmit watermark level
      Reserved2 : Bits_13 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for txctrl_Type use
   record
      txen      at 0 range 0 .. 0;
      nstop     at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 15;
      txcnt     at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   -- 18.7 Receive Control Register (rxctrl)

   type rxctrl_Type is
   record
      rxen      : Boolean;      -- Receive enable
      Reserved1 : Bits_15 := 0;
      rxcnt     : Bits_3;       -- Receive watermark level
      Reserved2 : Bits_13 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for rxctrl_Type use
   record
      rxen      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 15;
      rxcnt     at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 31;
   end record;

   -- 18.8 Interrupt Registers (ip and ie)

   type ie_Type is
   record
      txwm     : Boolean;      -- Transmit watermark interrupt enable
      rxwm     : Boolean;      -- Receive watermark interrupt enable
      Reserved : Bits_30 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ie_Type use
   record
      txwm     at 0 range 0 .. 0;
      rxwm     at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 31;
   end record;

   type ip_Type is
   record
      txwm     : Boolean;      -- Transmit watermark interrupt pending
      rxwm     : Boolean;      -- Receive watermark interrupt pending
      Reserved : Bits_30 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ip_Type use
   record
      txwm     at 0 range 0 .. 0;
      rxwm     at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 31;
   end record;

   -- 18.9 Baud Rate Divisor Register (div)

   type div_Type is
   record
      div      : Unsigned_16;  -- Baud rate divisor.
      Reserved : Bits_16 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for div_Type use
   record
      div      at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 18.3 Memory Map

   type UART_Type is
   record
      txdata : txdata_Type with Volatile_Full_Access => True;
      rxdata : rxdata_Type with Volatile_Full_Access => True;
      txctrl : txctrl_Type with Volatile_Full_Access => True;
      rxctrl : rxctrl_Type with Volatile_Full_Access => True;
      ie     : ie_Type     with Volatile_Full_Access => True;
      ip     : ip_Type     with Volatile_Full_Access => True;
      div    : div_Type    with Volatile_Full_Access => True;
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
