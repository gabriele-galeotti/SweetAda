-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ atmega128a.ads                                                                                            --
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
with System.Storage_Elements;
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
   use System.Storage_Elements;
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
      with Address              => To_Address (SREG_ADDRESS),
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
      with Address              => To_Address (XDIV_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.10.2. OSCCAL – Oscillator Calibration Register

   OSCCAL_ADDRESS : constant := 16#51#;

   OSCCAL : aliased Unsigned_8
      with Address              => To_Address (OSCCAL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 14. Power Management and Sleep Modes
   ----------------------------------------------------------------------------

   -- 14.9.1. MCUCR – MCU Control Register
   -- 16.2.1. MCUCR – MCU Control Register

   type MCUCR_Type is record
      IVCE     : Boolean;     -- Interrupt Vector Change Enable
      IVSEL    : Boolean;     -- Interrupt Vector Select
      Reserved : Bits_6 := 0;
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
      with Address              => To_Address (MCUCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 15. System Control and Reset
   ----------------------------------------------------------------------------

   -- 15.6.1. MCUCSR – MCU Control and Status Register

   type MCUCSR_Type is record
      PORF     : Boolean;     -- Power-on Reset Flag
      EXTRF    : Boolean;     -- External Reset Flag
      BORF     : Boolean;     -- Brown-out Reset Flag
      WDRF     : Boolean;     -- Watchdog Reset Flag
      JTRF     : Boolean;     -- JTAG Reset Flag
      Reserved : Bits_3 := 0;
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
      with Address              => To_Address (MCUCSR_ADDRESS),
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
      WDP012   : Bits_3;      -- Watchdog Timer Prescaler bit 0 .. 2
      WDE      : Boolean;     -- Watchdog Enable
      WDCE     : Boolean;     -- Watchdog Change Enable
      Reserved : Bits_3 := 0;
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
      with Address              => To_Address (WDTCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 18. I/O Ports
   ----------------------------------------------------------------------------

   -- 18.4.2. PORTA – Port A Data Register

   type PORTA_Type is record
      PORTA0 : Boolean;
      PORTA1 : Boolean;
      PORTA2 : Boolean;
      PORTA3 : Boolean;
      PORTA4 : Boolean;
      PORTA5 : Boolean;
      PORTA6 : Boolean;
      PORTA7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PORTA_Type use record
      PORTA0 at 0 range 0 .. 0;
      PORTA1 at 0 range 1 .. 1;
      PORTA2 at 0 range 2 .. 2;
      PORTA3 at 0 range 3 .. 3;
      PORTA4 at 0 range 4 .. 4;
      PORTA5 at 0 range 5 .. 5;
      PORTA6 at 0 range 6 .. 6;
      PORTA7 at 0 range 7 .. 7;
   end record;

   PORTA_ADDRESS : constant := 16#3B#;

   PORTA : aliased PORTA_Type
      with Address              => To_Address (PORTA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.3. DDRA – Port A Data Direction Register

   type DDRA_Type is record
      DDA0 : Boolean;
      DDA1 : Boolean;
      DDA2 : Boolean;
      DDA3 : Boolean;
      DDA4 : Boolean;
      DDA5 : Boolean;
      DDA6 : Boolean;
      DDA7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DDRA_Type use record
      DDA0 at 0 range 0 .. 0;
      DDA1 at 0 range 1 .. 1;
      DDA2 at 0 range 2 .. 2;
      DDA3 at 0 range 3 .. 3;
      DDA4 at 0 range 4 .. 4;
      DDA5 at 0 range 5 .. 5;
      DDA6 at 0 range 6 .. 6;
      DDA7 at 0 range 7 .. 7;
   end record;

   DDRA_ADDRESS : constant := 16#3A#;

   DDRA : aliased DDRA_Type
      with Address              => To_Address (DDRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.4. PINA – Port A Input Pins Address

   type PINA_Type is record
      PINA0 : Boolean;
      PINA1 : Boolean;
      PINA2 : Boolean;
      PINA3 : Boolean;
      PINA4 : Boolean;
      PINA5 : Boolean;
      PINA6 : Boolean;
      PINA7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PINA_Type use record
      PINA0 at 0 range 0 .. 0;
      PINA1 at 0 range 1 .. 1;
      PINA2 at 0 range 2 .. 2;
      PINA3 at 0 range 3 .. 3;
      PINA4 at 0 range 4 .. 4;
      PINA5 at 0 range 5 .. 5;
      PINA6 at 0 range 6 .. 6;
      PINA7 at 0 range 7 .. 7;
   end record;

   PINA_ADDRESS : constant := 16#39#;

   PINA : aliased PINA_Type
      with Address              => To_Address (PINA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.5. PORTB – The Port B Data Register

   type PORTB_Type is record
      PORTB0 : Boolean;
      PORTB1 : Boolean;
      PORTB2 : Boolean;
      PORTB3 : Boolean;
      PORTB4 : Boolean;
      PORTB5 : Boolean;
      PORTB6 : Boolean;
      PORTB7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PORTB_Type use record
      PORTB0 at 0 range 0 .. 0;
      PORTB1 at 0 range 1 .. 1;
      PORTB2 at 0 range 2 .. 2;
      PORTB3 at 0 range 3 .. 3;
      PORTB4 at 0 range 4 .. 4;
      PORTB5 at 0 range 5 .. 5;
      PORTB6 at 0 range 6 .. 6;
      PORTB7 at 0 range 7 .. 7;
   end record;

   PORTB_ADDRESS : constant := 16#38#;

   PORTB : aliased PORTB_Type
      with Address              => To_Address (PORTB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.6. DDRB – The Port B Data Direction Register

   type DDRB_Type is record
      DDB0 : Boolean;
      DDB1 : Boolean;
      DDB2 : Boolean;
      DDB3 : Boolean;
      DDB4 : Boolean;
      DDB5 : Boolean;
      DDB6 : Boolean;
      DDB7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DDRB_Type use record
      DDB0 at 0 range 0 .. 0;
      DDB1 at 0 range 1 .. 1;
      DDB2 at 0 range 2 .. 2;
      DDB3 at 0 range 3 .. 3;
      DDB4 at 0 range 4 .. 4;
      DDB5 at 0 range 5 .. 5;
      DDB6 at 0 range 6 .. 6;
      DDB7 at 0 range 7 .. 7;
   end record;

   DDRB_ADDRESS : constant := 16#37#;

   DDRB : aliased DDRB_Type
      with Address              => To_Address (DDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.7. PINB – The Port B Input Pins Address

   type PINB_Type is record
      PINB0 : Boolean;
      PINB1 : Boolean;
      PINB2 : Boolean;
      PINB3 : Boolean;
      PINB4 : Boolean;
      PINB5 : Boolean;
      PINB6 : Boolean;
      PINB7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PINB_Type use record
      PINB0 at 0 range 0 .. 0;
      PINB1 at 0 range 1 .. 1;
      PINB2 at 0 range 2 .. 2;
      PINB3 at 0 range 3 .. 3;
      PINB4 at 0 range 4 .. 4;
      PINB5 at 0 range 5 .. 5;
      PINB6 at 0 range 6 .. 6;
      PINB7 at 0 range 7 .. 7;
   end record;

   PINB_ADDRESS : constant := 16#36#;

   PINB : aliased PINB_Type
      with Address              => To_Address (PINB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.8. PORTC – The Port C Data Register

   type PORTC_Type is record
      PORTC0 : Boolean;
      PORTC1 : Boolean;
      PORTC2 : Boolean;
      PORTC3 : Boolean;
      PORTC4 : Boolean;
      PORTC5 : Boolean;
      PORTC6 : Boolean;
      Unused : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PORTC_Type use record
      PORTC0 at 0 range 0 .. 0;
      PORTC1 at 0 range 1 .. 1;
      PORTC2 at 0 range 2 .. 2;
      PORTC3 at 0 range 3 .. 3;
      PORTC4 at 0 range 4 .. 4;
      PORTC5 at 0 range 5 .. 5;
      PORTC6 at 0 range 6 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   PORTC_ADDRESS : constant := 16#35#;

   PORTC : aliased PORTC_Type
      with Address              => To_Address (PORTC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.9. DDRC – The Port C Data Direction Register

   type DDRC_Type is record
      DDC0   : Boolean;
      DDC1   : Boolean;
      DDC2   : Boolean;
      DDC3   : Boolean;
      DDC4   : Boolean;
      DDC5   : Boolean;
      DDC6   : Boolean;
      Unused : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DDRC_Type use record
      DDC0   at 0 range 0 .. 0;
      DDC1   at 0 range 1 .. 1;
      DDC2   at 0 range 2 .. 2;
      DDC3   at 0 range 3 .. 3;
      DDC4   at 0 range 4 .. 4;
      DDC5   at 0 range 5 .. 5;
      DDC6   at 0 range 6 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   DDRC_ADDRESS : constant := 16#34#;

   DDRC : aliased DDRC_Type
      with Address              => To_Address (DDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.10. PINC – The Port C Input Pins Address

   type PINC_Type is record
      PINC0  : Boolean;
      PINC1  : Boolean;
      PINC2  : Boolean;
      PINC3  : Boolean;
      PINC4  : Boolean;
      PINC5  : Boolean;
      PINC6  : Boolean;
      Unused : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PINC_Type use record
      PINC0  at 0 range 0 .. 0;
      PINC1  at 0 range 1 .. 1;
      PINC2  at 0 range 2 .. 2;
      PINC3  at 0 range 3 .. 3;
      PINC4  at 0 range 4 .. 4;
      PINC5  at 0 range 5 .. 5;
      PINC6  at 0 range 6 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   PINC_ADDRESS : constant := 16#33#;

   PINC : aliased PINC_Type
      with Address              => To_Address (PINC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.11. PORTD – The Port D Data Register

   type PORTD_Type is record
      PORTD0 : Boolean;
      PORTD1 : Boolean;
      PORTD2 : Boolean;
      PORTD3 : Boolean;
      PORTD4 : Boolean;
      PORTD5 : Boolean;
      PORTD6 : Boolean;
      PORTD7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PORTD_Type use record
      PORTD0 at 0 range 0 .. 0;
      PORTD1 at 0 range 1 .. 1;
      PORTD2 at 0 range 2 .. 2;
      PORTD3 at 0 range 3 .. 3;
      PORTD4 at 0 range 4 .. 4;
      PORTD5 at 0 range 5 .. 5;
      PORTD6 at 0 range 6 .. 6;
      PORTD7 at 0 range 7 .. 7;
   end record;

   PORTD_ADDRESS : constant := 16#32#;

   PORTD : aliased PORTD_Type
      with Address              => To_Address (PORTD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.12. DDRD – The Port D Data Direction Register

   type DDRD_Type is record
      DDD0 : Boolean;
      DDD1 : Boolean;
      DDD2 : Boolean;
      DDD3 : Boolean;
      DDD4 : Boolean;
      DDD5 : Boolean;
      DDD6 : Boolean;
      DDD7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DDRD_Type use record
      DDD0 at 0 range 0 .. 0;
      DDD1 at 0 range 1 .. 1;
      DDD2 at 0 range 2 .. 2;
      DDD3 at 0 range 3 .. 3;
      DDD4 at 0 range 4 .. 4;
      DDD5 at 0 range 5 .. 5;
      DDD6 at 0 range 6 .. 6;
      DDD7 at 0 range 7 .. 7;
   end record;

   DDRD_ADDRESS : constant := 16#31#;

   DDRD : aliased DDRD_Type
      with Address              => To_Address (DDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.4.13. PIND – The Port D Input Pins Address

   type PIND_Type is record
      PIND0 : Boolean;
      PIND1 : Boolean;
      PIND2 : Boolean;
      PIND3 : Boolean;
      PIND4 : Boolean;
      PIND5 : Boolean;
      PIND6 : Boolean;
      PIND7 : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIND_Type use record
      PIND0 at 0 range 0 .. 0;
      PIND1 at 0 range 1 .. 1;
      PIND2 at 0 range 2 .. 2;
      PIND3 at 0 range 3 .. 3;
      PIND4 at 0 range 4 .. 4;
      PIND5 at 0 range 5 .. 5;
      PIND6 at 0 range 6 .. 6;
      PIND7 at 0 range 7 .. 7;
   end record;

   PIND_ADDRESS : constant := 16#30#;

   PIND : aliased PIND_Type
      with Address              => To_Address (PIND_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end ATmega128A;
