-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ k61.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package K61
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- Chapter 11 Port Control and Interrupts (PORT)
   ----------------------------------------------------------------------------

   PORT_PCR_BASEADDRESS : constant := 16#4004_9000#;

   -- 11.5.1 Pin Control Register n (PORTx_PCRn)

   PS_PULLDOWN : constant := 0; -- Internal pulldown resistor is enabled on the corresponding pin, if the corresponding PE field is set.
   PS_PULLUP   : constant := 1; -- Internal pullup resistor is enabled on the corresponding pin, if the corresponding PE field is set.

   type PORT_PCR_Pin_Type is record
      PS        : Bits_1;       -- Pull Select
      PE        : Boolean;      -- Pull Enable
      SRE       : Boolean;      -- Slew Rate Enable
      Reserved1 : Bits_1  := 0;
      PFE       : Boolean;      -- Passive Filter Enable
      ODE       : Boolean;      -- Open Drain Enable
      DSE       : Boolean;      -- Drive Strength Enable
      Reserved2 : Bits_1  := 0;
      MUX       : Bits_3;       -- Pin Mux Control
      Reserved3 : Bits_4  := 0;
      LK        : Boolean;      -- Lock Register
      IRQC      : Bits_4;       -- Interrupt Configuration
      Reserved4 : Bits_4  := 0;
      ISF       : Boolean;      -- Interrupt Status Flag
      Reserved5 : Bits_7  := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORT_PCR_Pin_Type use record
      PS        at 0 range  0 ..  0;
      PE        at 0 range  1 ..  1;
      SRE       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PFE       at 0 range  4 ..  4;
      ODE       at 0 range  5 ..  5;
      DSE       at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      MUX       at 0 range  8 .. 10;
      Reserved3 at 0 range 11 .. 14;
      LK        at 0 range 15 .. 15;
      IRQC      at 0 range 16 .. 19;
      Reserved4 at 0 range 20 .. 23;
      ISF       at 0 range 24 .. 24;
      Reserved5 at 0 range 25 .. 31;
   end record;

   type PORT_PCR_Pins_Type is array (0 .. 31) of PORT_PCR_Pin_Type
      with Pack => True;

   type PORT_PCR_Type is record
      Pins  : PORT_PCR_Pins_Type;
      GPCLR : Unsigned_32        with Volatile_Full_Access => True;
      GPCHR : Unsigned_32        with Volatile_Full_Access => True;
      ISFR  : Unsigned_32        with Volatile_Full_Access => True;
   end record
      with Size => 16#A4# * 8;
   for PORT_PCR_Type use record
      Pins  at 16#00# range 0 .. 32 * 32 - 1;
      GPCLR at 16#80# range 0 .. 31;
      GPCHR at 16#84# range 0 .. 31;
      ISFR  at 16#A0# range 0 .. 31;
   end record;

   PORTA_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#0000#),
           Import     => True,
           Convention => Ada;
   PORTB_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#1000#),
           Import     => True,
           Convention => Ada;
   PORTC_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#2000#),
           Import     => True,
           Convention => Ada;
   PORTD_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#3000#),
           Import     => True,
           Convention => Ada;
   PORTE_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#4000#),
           Import     => True,
           Convention => Ada;
   PORTF_PCR : aliased PORT_PCR_Type
      with Address    => System'To_Address (PORT_PCR_BASEADDRESS + 16#5000#),
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 12 System integration module (SIM)
   ----------------------------------------------------------------------------

   SIM_BASEADDRESS : constant := 16#4004_7000#;

   -- 12.2.13 System Clock Gating Control Register 5 (SIM_SCGC5)

   type SIM_SCGC5_Type is record
      LPTIMER      : Boolean;      -- LPTMR clock gate control
      Reserved1    : Bits_1  := 1;
      DRYICE       : Boolean;      -- Dryice clock gate control
      DRYICESECREG : Boolean;      -- Dryice secure storage clock gate control
      Reserved2    : Bits_1  := 0;
      TSI          : Boolean;      -- TSI clock gate control
      Reserved3    : Bits_1  := 0;
      Reserved4    : Bits_1  := 1;
      Reserved5    : Bits_1  := 1;
      PORTA        : Boolean;      -- PORTA clock gate control
      PORTB        : Boolean;      -- PORTB clock gate control
      PORTC        : Boolean;      -- PORTC clock gate control
      PORTD        : Boolean;      -- PORTD clock gate control
      PORTE        : Boolean;      -- PORTE clock gate control
      PORTF        : Boolean;      -- PORTF clock gate control
      Reserved6    : Bits_3  := 0;
      Reserved7    : Bits_1  := 1;
      Reserved8    : Bits_13 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC5_Type use record
      LPTIMER      at 0 range  0 ..  0;
      Reserved1    at 0 range  1 ..  1;
      DRYICE       at 0 range  2 ..  2;
      DRYICESECREG at 0 range  3 ..  3;
      Reserved2    at 0 range  4 ..  4;
      TSI          at 0 range  5 ..  5;
      Reserved3    at 0 range  6 ..  6;
      Reserved4    at 0 range  7 ..  7;
      Reserved5    at 0 range  8 ..  8;
      PORTA        at 0 range  9 ..  9;
      PORTB        at 0 range 10 .. 10;
      PORTC        at 0 range 11 .. 11;
      PORTD        at 0 range 12 .. 12;
      PORTE        at 0 range 13 .. 13;
      PORTF        at 0 range 14 .. 14;
      Reserved6    at 0 range 15 .. 17;
      Reserved7    at 0 range 18 .. 18;
      Reserved8    at 0 range 19 .. 31;
   end record;

   SIM_SCGC5 : aliased SIM_SCGC5_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 24 Watchdog Timer (WDOG)
   ----------------------------------------------------------------------------

   WDOG_BASEADDRESS : constant := 16#4005_2000#;

   -- 24.7.1 Watchdog Status and Control Register High (WDOG_STCTRLH)

   type WDOG_STCTRLH_Type is record
      WDOGEN   : Boolean;      -- Enables or disables the WDOG’s operation.
      Reserved : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for WDOG_STCTRLH_Type use record
      WDOGEN   at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   WDOG_STCTRLH : aliased WDOG_STCTRLH_Type
      with Address              => System'To_Address (WDOG_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.7.8 Watchdog Unlock register (WDOG_UNLOCK)

   WDOG_UNLOCK : aliased Unsigned_16
      with Address              => System'To_Address (WDOG_BASEADDRESS + 16#0E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 59 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   GPIO_BASEADDRESS : constant := 16#400F_F000#;

   type GPIO_PORT is record
      GPIO_PDOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PSOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PCOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PTOR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDIR : Bitmap_32 with Volatile_Full_Access => True;
      GPIO_PDDR : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 16#18# * 8;
   for GPIO_PORT use record
      GPIO_PDOR at 16#00# range 0 .. 31;
      GPIO_PSOR at 16#04# range 0 .. 31;
      GPIO_PCOR at 16#08# range 0 .. 31;
      GPIO_PTOR at 16#0C# range 0 .. 31;
      GPIO_PDIR at 16#10# range 0 .. 31;
      GPIO_PDDR at 16#14# range 0 .. 31;
   end record;

   GPIOA : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#000#),
           Import     => True,
           Convention => Ada;
   GPIOB : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#040#),
           Import     => True,
           Convention => Ada;
   GPIOC : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#080#),
           Import     => True,
           Convention => Ada;
   GPIOD : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#0C0#),
           Import     => True,
           Convention => Ada;
   GPIOE : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#100#),
           Import     => True,
           Convention => Ada;
   GPIOF : aliased GPIO_PORT
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#140#),
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end K61;
