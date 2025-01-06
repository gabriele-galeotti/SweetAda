-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ atmega128a.ads                                                                                            --
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

with System;
with Interfaces;
with Bits;

package ATmega128A
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

   ----------------------------------------------------------------------------
   -- 11. AVR CPU Core
   ----------------------------------------------------------------------------

   -- 11.3.1. SREG – The AVR Status Register

   type SREG_Type is record
      C : Boolean; -- Carry flag
      Z : Boolean; -- Zero flag
      N : Boolean; -- Negative flag
      V : Boolean; -- Two's Complement Overflow flag
      S : Boolean; -- Sign bit
      H : Boolean; -- Half Carry flag
      T : Boolean; -- Bit Copy Storage
      I : Boolean; -- Global Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SREG_Type use record
      C at 0 range 0 .. 0;
      Z at 0 range 1 .. 1;
      N at 0 range 2 .. 2;
      V at 0 range 3 .. 3;
      S at 0 range 4 .. 4;
      H at 0 range 5 .. 5;
      T at 0 range 6 .. 6;
      I at 0 range 7 .. 7;
   end record;

   SREG_ADDRESS : constant := 16#5F#;

   SREG : aliased SREG_Type
      with Address              => System'To_Address (SREG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 13. System Clock and Clock Options
   ----------------------------------------------------------------------------

   -- 13.10.1.XDIV – XTAL Divide Control Register

   type XDIV_Type is record
      XDIV   : Bits_7;  -- XTAL Divide Select Bits [n = 6:0]
      XDIVEN : Boolean; -- XTAL Divide Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for XDIV_Type use record
      XDIV   at 0 range 0 .. 6;
      XDIVEN at 0 range 7 .. 7;
   end record;

   XDIV_ADDRESS : constant := 16#5C#;

   XDIV : aliased XDIV_Type
      with Address              => System'To_Address (XDIV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.10.2. OSCCAL – Oscillator Calibration Register

   OSCCAL_ADDRESS : constant := 16#51#;

   OSCCAL : aliased Unsigned_8
      with Address              => System'To_Address (OSCCAL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 14. Power Management and Sleep Modes
   ----------------------------------------------------------------------------

   -- 14.9.1. MCUCR – MCU Control Register
   -- 16.2.1. MCUCR – MCU Control Register

   type MCUCR_Type is record
      IVCE     : Boolean;      -- Interrupt Vector Change Enable
      IVSEL    : Boolean;      -- Interrupt Vector Select
      Reserved : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUCR_Type use record
      IVCE     at 0 range 0 .. 0;
      IVSEL    at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   MCUCR_ADDRESS : constant := 16#55#;

   MCUCR : aliased MCUCR_Type
      with Address              => System'To_Address (MCUCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 15. System Control and Reset
   ----------------------------------------------------------------------------

   -- 15.6.1. MCUCSR – MCU Control and Status Register

   type MCUCSR_Type is record
      PORF     : Boolean;      -- Power-on Reset Flag
      EXTRF    : Boolean;      -- External Reset Flag
      BORF     : Boolean;      -- Brown-out Reset Flag
      WDRF     : Boolean;      -- Watchdog Reset Flag
      JTRF     : Boolean;      -- JTAG Reset Flag
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUCSR_Type use record
      PORF     at 0 range 0 .. 0;
      EXTRF    at 0 range 1 .. 1;
      BORF     at 0 range 2 .. 2;
      WDRF     at 0 range 3 .. 3;
      JTRF     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   MCUCSR_ADDRESS : constant := 16#54#;

   MCUCSR : aliased MCUCSR_Type
      with Address              => System'To_Address (MCUCSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.6.2. WDTCR – Watchdog Timer Control Register

   type WDT_Prescaler_Type is new Bits_3;

   WDT_16K   : constant WDT_Prescaler_Type := 2#000#;
   WDT_32K   : constant WDT_Prescaler_Type := 2#001#;
   WDT_64K   : constant WDT_Prescaler_Type := 2#010#;
   WDT_128K  : constant WDT_Prescaler_Type := 2#011#;
   WDT_256K  : constant WDT_Prescaler_Type := 2#100#;
   WDT_512K  : constant WDT_Prescaler_Type := 2#101#;
   WDT_1024K : constant WDT_Prescaler_Type := 2#110#;
   WDT_2048K : constant WDT_Prescaler_Type := 2#111#;

   type WDTCR_Type is record
      WDP012   : Bits_3;       -- Watchdog Timer Prescaler bit 0 .. 2
      WDE      : Boolean;      -- Watchdog Enable
      WDCE     : Boolean;      -- Watchdog Change Enable
      Reserved : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WDTCR_Type use record
      WDP012   at 0 range 0 .. 2;
      WDE      at 0 range 3 .. 3;
      WDCE     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   WDTCR_ADDRESS : constant := 16#41#;

   WDTCR : aliased WDTCR_Type
      with Address              => System'To_Address (WDTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 18. I/O Ports
   ----------------------------------------------------------------------------

   -- 18.4.2. PORTA – Port A Data Register

   PORTA_ADDRESS : constant := 16#3B#;

   PORTA : aliased Bitmap_8
      with Address              => System'To_Address (PORTA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.3. DDRA – Port A Data Direction Register

   DDRA_ADDRESS : constant := 16#3A#;

   DDRA : aliased Bitmap_8
      with Address              => System'To_Address (DDRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.4. PINA – Port A Input Pins Address

   PINA_ADDRESS : constant := 16#39#;

   PINA : aliased Bitmap_8
      with Address              => System'To_Address (PINA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.5. PORTB – The Port B Data Register

   PORTB_ADDRESS : constant := 16#38#;

   PORTB : aliased Bitmap_8
      with Address              => System'To_Address (PORTB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.6. DDRB – The Port B Data Direction Register

   DDRB_ADDRESS : constant := 16#37#;

   DDRB : aliased Bitmap_8
      with Address              => System'To_Address (DDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.7. PINB – The Port B Input Pins Address

   PINB_ADDRESS : constant := 16#36#;

   PINB : aliased Bitmap_8
      with Address              => System'To_Address (PINB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.8. PORTC – The Port C Data Register

   PORTC_ADDRESS : constant := 16#35#;

   PORTC : aliased Bitmap_8
      with Address              => System'To_Address (PORTC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.9. DDRC – The Port C Data Direction Register

   DDRC_ADDRESS : constant := 16#34#;

   DDRC : aliased Bitmap_8
      with Address              => System'To_Address (DDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.10. PINC – The Port C Input Pins Address

   PINC_ADDRESS : constant := 16#33#;

   PINC : aliased Bitmap_8
      with Address              => System'To_Address (PINC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.11. PORTD – The Port D Data Register

   PORTD_ADDRESS : constant := 16#32#;

   PORTD : aliased Bitmap_8
      with Address              => System'To_Address (PORTD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.12. DDRD – The Port D Data Direction Register

   DDRD_ADDRESS : constant := 16#31#;

   DDRD : aliased Bitmap_8
      with Address              => System'To_Address (DDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.13. PIND – The Port D Input Pins Address

   PIND_ADDRESS : constant := 16#30#;

   PIND : aliased Bitmap_8
      with Address              => System'To_Address (PIND_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end ATmega128A;
