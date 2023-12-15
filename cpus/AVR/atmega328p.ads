-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ atmega328p.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
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

package ATmega328P
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
   -- 6. AVR CPU Core
   ----------------------------------------------------------------------------

   -- 6.3.1 SREG – AVR Status Register

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
   -- 7. AVR Memories
   ----------------------------------------------------------------------------

   -- 7.6.3 EECR - The EEPROM Control Register

   type EECR_Type is record
      EERE     : Boolean;     -- EEPROM Read Enable
      EEPE     : Boolean;     -- EEPROM Write Enable
      EEMPE    : Boolean;     -- EEPROM Master Write Enable
      EERIE    : Boolean;     -- EEPROM Ready Interrupt Enable
      EEPM01   : Boolean;     -- EEPROM Programming Mode Bits
      Reserved : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for EECR_Type use record
      EERE     at 0 range 0 .. 0;
      EEPE     at 0 range 1 .. 1;
      EEMPE    at 0 range 2 .. 2;
      EERIE    at 0 range 3 .. 3;
      EEPM01   at 0 range 4 .. 5;
      Reserved at 0 range 6 .. 7;
   end record;

   EECR_ADDRESS : constant := 16#3F#;

   EECR : aliased EECR_Type
      with Address              => To_Address (EECR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.6.2 EEDR - The EEPROM Data Register

   EEDR_ADDRESS : constant := 16#40#;

   EEDR : aliased Unsigned_8
      with Address              => To_Address (EEDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.6.1 EEARH and EEARL - The EEPROM Address Register

   EEARL_ADDRESS : constant := 16#41#;

   EEARL : aliased Unsigned_8
      with Address              => To_Address (EEARL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   EEARH_ADDRESS : constant := 16#42#;

   EEARH : aliased Unsigned_8
      with Address              => To_Address (EEARH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.6.6 GPIOR0 – General Purpose I/O Register 0

   GPIOR0_ADDRESS : constant := 16#3E#;

   GPIOR0 : aliased Unsigned_8
      with Address              => To_Address (GPIOR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.6.5 GPIOR1 – General Purpose I/O Register 1

   GPIOR1_ADDRESS : constant := 16#4A#;

   GPIOR1 : aliased Unsigned_8
      with Address              => To_Address (GPIOR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 7.6.4 GPIOR2 – General Purpose I/O Register 2

   GPIOR2_ADDRESS : constant := 16#4B#;

   GPIOR2 : aliased Unsigned_8
      with Address              => To_Address (GPIOR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 8. System Clock and Clock Options
   ----------------------------------------------------------------------------

   -- 8.12.1 OSCCAL – Oscillator Calibration Register

   OSCCAL_ADDRESS : constant := 16#66#;

   OSCCAL : Unsigned_8
      with Address              => To_Address (OSCCAL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.12.2 CLKPR – Clock Prescale Register

   Clock_Prescaler_1   : constant := 2#0000#;
   Clock_Prescaler_2   : constant := 2#0001#;
   Clock_Prescaler_4   : constant := 2#0010#;
   Clock_Prescaler_8   : constant := 2#0011#;
   Clock_Prescaler_16  : constant := 2#0100#;
   Clock_Prescaler_32  : constant := 2#0101#;
   Clock_Prescaler_64  : constant := 2#0110#;
   Clock_Prescaler_128 : constant := 2#0111#;
   Clock_Prescaler_256 : constant := 2#1000#;

   type CLKPR_Type is record
      CLKPS    : Bits_4;      -- Clock Prescaler Select bit 0 .. 3
      Reserved : Bits_3 := 0;
      CLKPCE   : Boolean;     -- Clock Prescaler Change Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CLKPR_Type use record
      CLKPS    at 0 range 0 .. 3;
      Reserved at 0 range 4 .. 6;
      CLKPCE   at 0 range 7 .. 7;
   end record;

   CLKPR_ADDRESS : constant := 16#61#;

   CLKPR : aliased CLKPR_Type
      with Address              => To_Address (CLKPR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 9. Power Management and Sleep Modes
   ----------------------------------------------------------------------------

   -- 9.11.1 SMCR – Sleep Mode Control Register

   Idle                : constant := 2#000#;
   ADC_Noise_Reduction : constant := 2#001#;
   Power_Down          : constant := 2#010#;
   Power_Save          : constant := 2#011#;
   Standby             : constant := 2#110#;
   External_Standby    : constant := 2#111#;

   type SMCR_Type is record
      SE       : Boolean;     -- Sleep Enable
      SM       : Bits_3;      -- Sleep Mode Select
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMCR_Type use record
      SE       at 0 range 0 .. 0;
      SM       at 0 range 1 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   SMCR_ADDRESS : constant := 16#53#;

   SMCR : aliased SMCR_Type
      with Address              => To_Address (SMCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.11.2 MCUCR – MCU Control Register
   -- 11.5.2 MCUCR – MCU Control Register

   type MCUCR_Type is record
      IVCE      : Boolean;     -- Interrupt Vector Change Enable
      IVSEL     : Boolean;     -- Interrupt Vector Select
      Reserved1 : Bits_2 := 0;
      PUD       : Boolean;     -- Pull-up Disable
      BODSE     : Boolean;     -- BOD Sleep Enable
      BODS      : Boolean;     -- BOD Sleep
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUCR_Type use record
      IVCE      at 0 range 0 .. 0;
      IVSEL     at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      PUD       at 0 range 4 .. 4;
      BODSE     at 0 range 5 .. 5;
      BODS      at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   MCUCR_ADDRESS : constant := 16#55#;

   MCUCR : aliased MCUCR_Type
      with Address              => To_Address (MCUCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 9.11.3 PRR – Power Reduction Register

   type PRR_Type is record
      PRADC    : Boolean;     -- Power Reduction ADC
      PRUSART0 : Boolean;     -- Power Reduction USART
      PRSPI    : Boolean;     -- Power Reduction Serial Peripheral Interface
      PRTIM1   : Boolean;     -- Power Reduction Timer/Counter1
      Reserved : Bits_1 := 0;
      PRTIM0   : Boolean;     -- Power Reduction Timer/Counter0
      PRTIM2   : Boolean;     -- Power Reduction Timer/Counter2
      PRTWI    : Boolean;     -- Power Reduction TWI
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PRR_Type use record
      PRADC    at 0 range 0 .. 0;
      PRUSART0 at 0 range 1 .. 1;
      PRSPI    at 0 range 2 .. 2;
      PRTIM1   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 4;
      PRTIM0   at 0 range 5 .. 5;
      PRTIM2   at 0 range 6 .. 6;
      PRTWI    at 0 range 7 .. 7;
   end record;

   PRR_ADDRESS : constant := 16#64#;

   PRR : aliased PRR_Type
      with Address              => To_Address (PRR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 10. System Control and Reset
   ----------------------------------------------------------------------------

   -- 10.9.1 MCUSR – MCU Status Register

   type MCUSR_Type is record
      PORF     : Boolean;     -- Power-on reset flag
      EXTRF    : Boolean;     -- External Reset flag
      BORF     : Boolean;     -- Brown-out Reset flag
      WDRF     : Boolean;     -- Watchdog Reset flag
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCUSR_Type use record
      PORF     at 0 range 0 .. 0;
      EXTRF    at 0 range 1 .. 1;
      BORF     at 0 range 2 .. 2;
      WDRF     at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   MCUSR_ADDRESS : constant := 16#54#;

   MCUSR : aliased MCUSR_Type
      with Address              => To_Address (MCUSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.9.2 WDTCSR – Watchdog Timer Control Register

   type WDT_Prescaler_Type is record
      WDP012 : Bits_3; -- Watchdog Timer Prescaler bit 0 .. 2
      WDP3   : Bits_1; -- Watchdog Timer Prescaler bit 3
   end record;

   WDT_2K    : constant WDT_Prescaler_Type := (2#000#, 0);
   WDT_4K    : constant WDT_Prescaler_Type := (2#001#, 0);
   WDT_8K    : constant WDT_Prescaler_Type := (2#010#, 0);
   WDT_16K   : constant WDT_Prescaler_Type := (2#011#, 0);
   WDT_32K   : constant WDT_Prescaler_Type := (2#100#, 0);
   WDT_64K   : constant WDT_Prescaler_Type := (2#101#, 0);
   WDT_128K  : constant WDT_Prescaler_Type := (2#110#, 0);
   WDT_256K  : constant WDT_Prescaler_Type := (2#111#, 0);
   WDT_512K  : constant WDT_Prescaler_Type := (2#000#, 1);
   WDT_1024K : constant WDT_Prescaler_Type := (2#001#, 1);

   type WDTCSR_Type is record
      WDP012 : Bits_3;  -- Watchdog Timer Prescaler bit 0 .. 2
      WDE    : Boolean; -- Watchdog Enable
      WDCE   : Boolean; -- Watchdog Change Enable
      WDP3   : Bits_1;  -- Watchdog Timer Prescaler bit 3
      WDIE   : Boolean; -- Watchdog Timeout Interrupt Enable
      WDIF   : Boolean; -- Watchdog Timeout Interrupt flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WDTCSR_Type use record
      WDP012 at 0 range 0 .. 2;
      WDE    at 0 range 3 .. 3;
      WDCE   at 0 range 4 .. 4;
      WDP3   at 0 range 5 .. 5;
      WDIE   at 0 range 6 .. 6;
      WDIF   at 0 range 7 .. 7;
   end record;

   WDTCSR_ADDRESS : constant := 16#60#;

   WDTCSR : aliased WDTCSR_Type
      with Address              => To_Address (WDTCSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 13. I/O-Ports
   ----------------------------------------------------------------------------

   -- 13.4.2 PORTB – The Port B Data Register

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

   PORTB_ADDRESS : constant := 16#25#;

   PORTB : aliased PORTB_Type
      with Address              => To_Address (PORTB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.3 DDRB – The Port B Data Direction Register

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

   DDRB_ADDRESS : constant := 16#24#;

   DDRB : aliased DDRB_Type
      with Address              => To_Address (DDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.4 PINB – The Port B Input Pins Address

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

   PINB_ADDRESS : constant := 16#23#;

   PINB : aliased PINB_Type
      with Address              => To_Address (PINB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.5 PORTC – The Port C Data Register

   type PORTC_Type is record
      PORTC0 : Boolean;
      PORTC1 : Boolean;
      PORTC2 : Boolean;
      PORTC3 : Boolean;
      PORTC4 : Boolean;
      PORTC5 : Boolean;
      PORTC6 : Boolean;
      Unused : Bits_1 := 0;
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

   PORTC_ADDRESS : constant := 16#28#;

   PORTC : aliased PORTC_Type
      with Address              => To_Address (PORTC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.6 DDRC – The Port C Data Direction Register

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

   DDRC_ADDRESS : constant := 16#27#;

   DDRC : aliased DDRC_Type
      with Address              => To_Address (DDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.7 PINC – The Port C Input Pins Address

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

   PINC_ADDRESS : constant := 16#26#;

   PINC : aliased PINC_Type
      with Address              => To_Address (PINC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.8 PORTD – The Port D Data Register

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

   PORTD_ADDRESS : constant := 16#2B#;

   PORTD : aliased PORTB_Type
      with Address              => To_Address (PORTD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.9 DDRD – The Port D Data Direction Register

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

   DDRD_ADDRESS : constant := 16#2A#;

   DDRD : aliased DDRD_Type
      with Address              => To_Address (DDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.4.10 PIND – The Port D Input Pins Address

   type PIND_Type is record
      PIND0 : Boolean;
      PIND1 : Boolean;
      PIND2 : Boolean;
      PIND3 : Boolean;
      PIND4 : Boolean;
      PIND5 : Boolean;
      PIND6 : Boolean;
      PIND7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
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

   PIND_ADDRESS : constant := 16#29#;

   PIND : aliased PIND_Type
      with Address              => To_Address (PIND_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 14. 8-bit Timer/Counter0 with PWM
   ----------------------------------------------------------------------------

   -- 14.9.1 TCCR0A – Timer/Counter Control Register A

   type TC0_WGM_Type is record
      WGM01 : Bits_2; -- Waveform Generation Mode bit 0 .. 1
      WGM2  : Bits_1; -- Waveform Generation Mode bit 2
   end record;

   TC0_WGM_Normal       : constant TC0_WGM_Type := (2#00#, 0);
   TC0_WGM_PWM_Correct1 : constant TC0_WGM_Type := (2#01#, 0);
   TC0_WGM_CTC          : constant TC0_WGM_Type := (2#10#, 0);
   TC0_WGM_PWM_Fast1    : constant TC0_WGM_Type := (2#11#, 0);
   TC0_WGM_PWM_Correct2 : constant TC0_WGM_Type := (2#01#, 1);
   TC0_WGM_PWM_Fast2    : constant TC0_WGM_Type := (2#11#, 1);

   type TCCR0A_Type is record
      WGM01    : Bits_2;      -- Waveform Generation Mode bit 0 .. 1
      Reserved : Bits_2 := 0;
      COM0B0   : Boolean;     -- Compare Match Output B Mode bit 0
      COM0B1   : Boolean;     -- Compare Match Output B Mode bit 1
      COM0A0   : Boolean;     -- Compare Match Output A Mode bit 0
      COM0A1   : Boolean;     -- Compare Match Output A Mode bit 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR0A_Type use record
      WGM01    at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 3;
      COM0B0   at 0 range 4 .. 4;
      COM0B1   at 0 range 5 .. 5;
      COM0A0   at 0 range 6 .. 6;
      COM0A1   at 0 range 7 .. 7;
   end record;

   TCCR0A_ADDRESS : constant := 16#44#;

   TCCR0A : aliased TCCR0A_Type
      with Address              => To_Address (TCCR0A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.2 TCCR0B – Timer/Counter Control Register B

   TC0_Clock_Select_NOCLK   : constant := 2#000#;
   TC0_Clock_Select_CLK     : constant := 2#001#;
   TC0_Clock_Select_CLK8    : constant := 2#010#;
   TC0_Clock_Select_CLK32   : constant := 2#011#;
   TC0_Clock_Select_CLK64   : constant := 2#100#;
   TC0_Clock_Select_CLK128  : constant := 2#101#;
   TC0_Clock_Select_CLK256  : constant := 2#110#;
   TC0_Clock_Select_CLK1024 : constant := 2#111#;

   type TCCR0B_Type is record
      CS0      : Bits_3;      -- Clock Select
      WGM2     : Bits_1;      -- Waveform Generation Mode bit 2
      Reserved : Bits_2 := 0;
      FOC0B    : Boolean;     -- Force Output Compare B
      FOC0A    : Boolean;     -- Force Output Compare A
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR0B_Type use record
      CS0      at 0 range 0 .. 2;
      WGM2     at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 5;
      FOC0B    at 0 range 6 .. 6;
      FOC0A    at 0 range 7 .. 7;
   end record;

   TCCR0B_ADDRESS : constant := 16#45#;

   TCCR0B : aliased TCCR0B_Type
      with Address              => To_Address (TCCR0B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.3 TCNT0 – Timer/Counter Register

   TCNT0_ADDRESS : constant := 16#46#;

   TCNT0 : aliased Unsigned_8
      with Address              => To_Address (TCNT0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.4 OCR0A – Output Compare Register A

   OCR0A_ADDRESS : constant := 16#47#;

   OCR0A : aliased Unsigned_8
      with Address              => To_Address (OCR0A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.5 OCR0B – Output Compare Register B

   OCR0B_ADDRESS : constant := 16#48#;

   OCR0B : aliased Unsigned_8
      with Address              => To_Address (OCR0B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.6 TIMSK0 – Timer/Counter Interrupt Mask Register

   type TIMSK0_Type is record
      TOIE0    : Boolean;     -- Timer/Counter0 Overflow Interrupt Enable
      OCIE0A   : Boolean;     -- Timer/Counter0 Output Compare Match A Interrupt Enable
      OCIE0B   : Boolean;     -- Timer/Counter0 Output Compare Match B Interrupt Enable
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIMSK0_Type use record
      TOIE0    at 0 range 0 .. 0;
      OCIE0A   at 0 range 1 .. 1;
      OCIE0B   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   TIMSK0_ADDRESS : constant := 16#6E#;

   TIMSK0 : aliased TIMSK0_Type
      with Address              => To_Address (TIMSK0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.9.7 TIFR0 - Timer/Counter0 Interrupt Flag Register

   type TIFR0_Type is record
      TOV0     : Boolean;     -- Timer/Counter0 Overflow Flag
      OCF0A    : Boolean;     -- Timer/Counter0 Output Compare A Match Flag
      OCF0B    : Boolean;     -- Timer/Counter0 Output Compare B Match Flag
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIFR0_Type use record
      TOV0     at 0 range 0 .. 0;
      OCF0A    at 0 range 1 .. 1;
      OCF0B    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   TIFR0_ADDRESS : constant := 16#35#;

   TIFR0 : aliased TIFR0_Type
      with Address              => To_Address (TIFR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 15. 16-bit Timer/Counter1 with PWM
   ----------------------------------------------------------------------------

   -- 15.11.1 TCCR1A – Timer/Counter1 Control Register A

   type TC1_WGM_Type is record
      WGM01 : Bits_2; -- Waveform Generation Mode bit 0 .. 1
      WGM23 : Bits_2; -- Waveform Generation Mode bit 2
   end record;

   TC1_WGM_Normal            : constant TC1_WGM_Type := (2#00#, 2#00#);
   TC1_WGM_PWM_PCorrect8bit  : constant TC1_WGM_Type := (2#01#, 2#00#);
   TC1_WGM_PWM_PCorrect9bit  : constant TC1_WGM_Type := (2#10#, 2#00#);
   TC1_WGM_PWM_PCorrect10bit : constant TC1_WGM_Type := (2#11#, 2#00#);
   TC1_WGM_CTC1              : constant TC1_WGM_Type := (2#00#, 2#01#);
   TC1_WGM_PWM_Fast8bit      : constant TC1_WGM_Type := (2#01#, 2#01#);
   TC1_WGM_PWM_Fast9bit      : constant TC1_WGM_Type := (2#10#, 2#01#);
   TC1_WGM_PWM_Fast10bit     : constant TC1_WGM_Type := (2#11#, 2#01#);
   TC1_WGM_PWM_PFCorrect1    : constant TC1_WGM_Type := (2#00#, 2#10#);
   TC1_WGM_PWM_PFCorrect2    : constant TC1_WGM_Type := (2#01#, 2#10#);
   TC1_WGM_PWM_PCorrect1     : constant TC1_WGM_Type := (2#10#, 2#10#);
   TC1_WGM_PWM_PCorrect2     : constant TC1_WGM_Type := (2#11#, 2#10#);
   TC1_WGM_CTC2              : constant TC1_WGM_Type := (2#00#, 2#11#);
   TC1_WGM_PWM_Fast1         : constant TC1_WGM_Type := (2#10#, 2#11#);
   TC1_WGM_PWM_Fast2         : constant TC1_WGM_Type := (2#11#, 2#11#);

   type TCCR1A_Type is record
      WGM01    : Bits_2;      -- Waveform Generation Mode bit 0 .. 1
      Reserved : Bits_2 := 0;
      COM1B0   : Boolean;     -- Compare Match Output B Mode bit 0
      COM1B1   : Boolean;     -- Compare Match Output B Mode bit 1
      COM1A0   : Boolean;     -- Compare Match Output A Mode bit 0
      COM1A1   : Boolean;     -- Compare Match Output A Mode bit 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR1A_Type use record
      WGM01    at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 3;
      COM1B0   at 0 range 4 .. 4;
      COM1B1   at 0 range 5 .. 5;
      COM1A0   at 0 range 6 .. 6;
      COM1A1   at 0 range 7 .. 7;
   end record;

   TCCR1A_ADDRESS : constant := 16#80#;

   TCCR1A : aliased TCCR1A_Type
      with Address              => To_Address (TCCR1A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.2 TCCR1B – Timer/Counter1 Control Register B

   TC1_Clock_Select_NOCLK   : constant := 2#000#;
   TC1_Clock_Select_CLK     : constant := 2#001#;
   TC1_Clock_Select_CLK8    : constant := 2#010#;
   TC1_Clock_Select_CLK64   : constant := 2#011#;
   TC1_Clock_Select_CLK256  : constant := 2#100#;
   TC1_Clock_Select_CLK1024 : constant := 2#101#;
   TC1_Clock_Select_EXT_T1F : constant := 2#110#;
   TC1_Clock_Select_EXT_T1R : constant := 2#111#;

   type TCCR1B_Type is record
      CS1      : Bits_3;      -- Clock Select
      WGM23    : Bits_2;      -- Waveform Generation Mode bit 2 .. 3
      Reserved : Bits_1 := 0;
      ICES1    : Boolean;     -- Force Output Compare B
      ICNC1    : Boolean;     -- Force Output Compare A
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR1B_Type use record
      CS1      at 0 range 0 .. 2;
      WGM23    at 0 range 3 .. 4;
      Reserved at 0 range 5 .. 5;
      ICES1    at 0 range 6 .. 6;
      ICNC1    at 0 range 7 .. 7;
   end record;

   TCCR1B_ADDRESS : constant := 16#81#;

   TCCR1B : aliased TCCR1B_Type
      with Address              => To_Address (TCCR1B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.3 TCCR1C - Timer/Counter1 Control Register C

   type TCCR1C_Type is record
      Reserved : Bits_6 := 0;
      FOC1B    : Boolean;     -- Force Output Compare B
      FOC1A    : Boolean;     -- Force Output Compare A
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR1C_Type use record
      Reserved at 0 range 0 .. 5;
      FOC1B    at 0 range 6 .. 6;
      FOC1A    at 0 range 7 .. 7;
   end record;

   TCCR1C_ADDRESS : constant := 16#82#;

   TCCR1C : aliased TCCR1C_Type
      with Address              => To_Address (TCCR1C_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.4 TCNT1H and TCNT1L – Timer/Counter1

   TCNT1L_ADDRESS : constant := 16#84#;

   TCNT1L : aliased Unsigned_8
      with Address              => To_Address (TCNT1L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCNT1H_ADDRESS : constant := 16#85#;

   TCNT1H : aliased Unsigned_8
      with Address              => To_Address (TCNT1H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.5 OCR1AH and OCR1AL – Output Compare Register 1 A

   OCR1AL_ADDRESS : constant := 16#88#;

   OCR1AL : aliased Unsigned_8
      with Address              => To_Address (OCR1AL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   OCR1AH_ADDRESS : constant := 16#89#;

   OCR1AH : aliased Unsigned_8
      with Address              => To_Address (OCR1AH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.6 OCR1BH and OCR1BL – Output Compare Register 1 B

   OCR1BL_ADDRESS : constant := 16#8A#;

   OCR1BL : aliased Unsigned_8
      with Address              => To_Address (OCR1BL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   OCR1BH_ADDRESS : constant := 16#8B#;

   OCR1BH : aliased Unsigned_8
      with Address              => To_Address (OCR1BH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.7 ICR1H and ICR1L – Input Capture Register 1

   ICR1L_ADDRESS : constant := 16#86#;

   ICR1L : aliased Unsigned_8
      with Address              => To_Address (ICR1L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ICR1H_ADDRESS : constant := 16#87#;

   ICR1H : aliased Unsigned_8
      with Address              => To_Address (ICR1H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.8 TIMSK1 - Timer/Counter1 Interrupt Mask Register

   type TIMSK1_Type is record
      TOIE1     : Boolean;     -- Timer/Counter1 Overflow Interrupt Enable
      OCIE1A    : Boolean;     -- Timer/Counter1 Output Compare Match A Interrupt Enable
      OCIE1B    : Boolean;     -- Timer/Counter1 Output Compare Match B Interrupt Enable
      Reserved1 : Bits_2 := 0;
      ICIE1     : Boolean;     -- Timer/Counter1 Input Capture Interrupt Enable
      Reserved2 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIMSK1_Type use record
      TOIE1     at 0 range 0 .. 0;
      OCIE1A    at 0 range 1 .. 1;
      OCIE1B    at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 4;
      ICIE1     at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   TIMSK1_ADDRESS : constant := 16#6F#;

   TIMSK1 : aliased TIMSK1_Type
      with Address              => To_Address (TIMSK1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.11.9 TIFR1 – Timer/Counter1 Interrupt Flag Register

   type TIFR1_Type is record
      TOV1      : Boolean;     -- Timer/Counter1 Overflow Flag
      OCF1A     : Boolean;     -- Timer/Counter1 Output Compare A Match Flag
      OCF1B     : Boolean;     -- Timer/Counter1 Output Compare B Match Flag
      Reserved1 : Bits_2 := 0;
      ICF1      : Boolean;     -- Timer/Counter1 Input Capture Flag
      Reserved2 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIFR1_Type use record
      TOV1      at 0 range 0 .. 0;
      OCF1A     at 0 range 1 .. 1;
      OCF1B     at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 4;
      ICF1      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   TIFR1_ADDRESS : constant := 16#36#;

   TIFR1 : aliased TIFR1_Type
      with Address              => To_Address (TIFR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 17. 8-bit Timer/Counter2 with PWM and Asynchronous Operation
   ----------------------------------------------------------------------------

   -- 17.11.1 TCCR2A – Timer/Counter Control Register A

   type TC2_WGM_Type is record
      WGM01 : Bits_2; -- Waveform Generation Mode bit 0 .. 1
      WGM2  : Bits_1; -- Waveform Generation Mode bit 2
   end record;

   TC2_WGM2_Normal       : constant TC2_WGM_Type := (2#00#, 0);
   TC2_WGM2_PWM_Correct1 : constant TC2_WGM_Type := (2#01#, 0);
   TC2_WGM2_CTC          : constant TC2_WGM_Type := (2#10#, 0);
   TC2_WGM2_PWM_Fast1    : constant TC2_WGM_Type := (2#11#, 0);
   TC2_WGM2_PWM_Correct2 : constant TC2_WGM_Type := (2#01#, 1);
   TC2_WGM2_PWM_Fast2    : constant TC2_WGM_Type := (2#11#, 1);

   type TCCR2A_Type is record
      WGM01    : Bits_2;      -- Waveform Generation Mode bit 0 .. 1
      Reserved : Bits_2 := 0;
      COM2B0   : Boolean;     -- Compare Match Output B Mode bit 0
      COM2B1   : Boolean;     -- Compare Match Output B Mode bit 1
      COM2A0   : Boolean;     -- Compare Match Output A Mode bit 0
      COM2A1   : Boolean;     -- Compare Match Output A Mode bit 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR2A_Type use record
      WGM01    at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 3;
      COM2B0   at 0 range 4 .. 4;
      COM2B1   at 0 range 5 .. 5;
      COM2A0   at 0 range 6 .. 6;
      COM2A1   at 0 range 7 .. 7;
   end record;

   TCCR2A_ADDRESS : constant := 16#B0#;

   TCCR2A : aliased TCCR2A_Type
      with Address              => To_Address (TCCR2A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.2 TCCR2B – Timer/Counter Control Register B

   TC2_Clock_Select_NOCLK   : constant := 2#000#;
   TC2_Clock_Select_CLK     : constant := 2#001#;
   TC2_Clock_Select_CLK8    : constant := 2#010#;
   TC2_Clock_Select_CLK32   : constant := 2#011#;
   TC2_Clock_Select_CLK64   : constant := 2#100#;
   TC2_Clock_Select_CLK128  : constant := 2#101#;
   TC2_Clock_Select_CLK256  : constant := 2#110#;
   TC2_Clock_Select_CLK1024 : constant := 2#111#;

   type TCCR2B_Type is record
      CS2      : Bits_3;      -- Clock Select
      WGM2     : Bits_1;      -- Waveform Generation Mode bit 2
      Reserved : Bits_2 := 0;
      FOC2B    : Boolean;     -- Force Output Compare B
      FOC2A    : Boolean;     -- Force Output Compare A
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TCCR2B_Type use record
      CS2      at 0 range 0 .. 2;
      WGM2     at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 5;
      FOC2B    at 0 range 6 .. 6;
      FOC2A    at 0 range 7 .. 7;
   end record;

   TCCR2B_ADDRESS : constant := 16#B1#;

   TCCR2B : aliased TCCR2B_Type
      with Address              => To_Address (TCCR2B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.3 TCNT2 – Timer/Counter Register

   TCNT2_ADDRESS : constant := 16#B2#;

   TCNT2 : aliased Unsigned_8
      with Address              => To_Address (TCNT2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.4 OCR2A – Output Compare Register A

   OCR2A_ADDRESS : constant := 16#B3#;

   OCR2A : aliased Unsigned_8
      with Address              => To_Address (OCR2A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.5 OCR2B – Output Compare Register B

   OCR2B_ADDRESS : constant := 16#B4#;

   OCR2B : aliased Unsigned_8
      with Address              => To_Address (OCR2B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.6 TIMSK2 – Timer/Counter2 Interrupt Mask Register

   type TIMSK2_Type is record
      TOIE2    : Boolean;     -- Timer/Counter2 Overflow Interrupt Enable
      OCIE2A   : Boolean;     -- Timer/Counter2 Output Compare Match A Interrupt Enable
      OCIE2B   : Boolean;     -- Timer/Counter2 Output Compare Match B Interrupt Enable
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIMSK2_Type use record
      TOIE2    at 0 range 0 .. 0;
      OCIE2A   at 0 range 1 .. 1;
      OCIE2B   at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   TIMSK2_ADDRESS : constant := 16#70#;

   TIMSK2 : aliased TIMSK2_Type
      with Address              => To_Address (TIMSK2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.7 TIFR2 – Timer/Counter2 Interrupt Flag Register

   type TIFR2_Type is record
      TOV2     : Boolean;     -- Timer/Counter2 Overflow Flag
      OCF2A    : Boolean;     -- Timer/Counter2 Output Compare A Match Flag
      OCF2B    : Boolean;     -- Timer/Counter2 Output Compare B Match Flag
      Reserved : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TIFR2_Type use record
      TOV2     at 0 range 0 .. 0;
      OCF2A    at 0 range 1 .. 1;
      OCF2B    at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   TIFR2_ADDRESS : constant := 16#37#;

   TIFR2 : aliased TIFR2_Type
      with Address              => To_Address (TIFR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.8 ASSR – Asynchronous Status Register

   type ASSR_Type is record
      TCR2BUB  : Boolean;     -- Timer/Counter Control Register2 Update Busy
      TCR2AUB  : Boolean;     -- Timer/Counter Control Register2 Update Busy
      OCR2BUB  : Boolean;     -- Output Compare Register2 Update Busy
      OCR2AUB  : Boolean;     -- Output Compare Register2 Update Busy
      TCN2UB   : Boolean;     -- Timer/Counter2 Update Busy
      AS2      : Boolean;     -- Asynchronous Timer/Counter2
      EXCLK    : Boolean;     -- Enable External Clock Input
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ASSR_Type use record
      TCR2BUB  at 0 range 0 .. 0;
      TCR2AUB  at 0 range 1 .. 1;
      OCR2BUB  at 0 range 2 .. 2;
      OCR2AUB  at 0 range 3 .. 3;
      TCN2UB   at 0 range 4 .. 4;
      AS2      at 0 range 5 .. 5;
      EXCLK    at 0 range 6 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   ASSR_ADDRESS : constant := 16#B6#;

   ASSR : aliased ASSR_Type
      with Address              => To_Address (ASSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.11.9 GTCCR – General Timer/Counter Control Register

   type GTCCR_Type is record
      PSRSYNC  : Boolean;     -- Prescaler Reset Timer/Counter1 and Timer/Counter0
      PSRASY   : Boolean;     -- Prescaler Reset Timer/Counter2
      Reserved : Bits_5 := 0;
      TSM      : Boolean;     -- Timer/Counter Synchronization Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for GTCCR_Type use record
      PSRSYNC  at 0 range 0 .. 0;
      PSRASY   at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 6;
      TSM      at 0 range 7 .. 7;
   end record;

   GTCCR_ADDRESS : constant := 16#43#;

   GTCCR : aliased GTCCR_Type
      with Address              => To_Address (GTCCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 18. SPI – Serial Peripheral Interface
   ----------------------------------------------------------------------------

   -- 18.5.1 SPCR – SPI Control Register

   SPR_DIV4   : constant := 2#00#; -- fOSC/4
   SPR_DIV16  : constant := 2#01#; -- fOSC/16
   SPR_DIV64  : constant := 2#10#; -- fOSC/64
   SPR_DIV128 : constant := 2#11#; -- fOSC/128

   CPHA_LSample_TSetup : constant := 0; -- Leading Edge = Sample, Trailing Edge = Setup
   CPHA_LSetup_TSample : constant := 1; -- Leading Edge = Setup, Trailing Edge = Sample

   CPOL_LRaising_TFalling : constant := 0; -- Leading Edge = Raising, Trailing Edge = Falling
   CPOL_LFalling_TRaising : constant := 1; -- Leading Edge = Falling, Trailing Edge = Raising

   MSTR_SLAVE  : constant := 0; -- SPI Slave
   MSTR_MASTER : constant := 1; -- SPI Master

   DORD_MSB : constant := 0; -- MSB first
   DORD_LSB : constant := 1; -- LSB first

   type SPCR_Type is record
      SPR  : Bits_2;  -- SPI Clock Rate Select 1 and 0
      CPHA : Bits_1;  -- Clock Phase
      CPOL : Bits_1;  -- Clock Polarity
      MSTR : Bits_1;  -- Master/Slave Select
      DORD : Bits_1;  -- Data Order
      SPE  : Boolean; -- SPI Enable
      SPIE : Boolean; -- SPI Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPCR_Type use record
      SPR  at 0 range 0 .. 1;
      CPHA at 0 range 2 .. 2;
      CPOL at 0 range 3 .. 3;
      MSTR at 0 range 4 .. 4;
      DORD at 0 range 5 .. 5;
      SPE  at 0 range 6 .. 6;
      SPIE at 0 range 7 .. 7;
   end record;

   SPCR_ADDRESS : constant := 16#4C#;

   SPCR : aliased SPCR_Type
      with Address              => To_Address (SPCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.5.2 SPSR – SPI Status Register

   type SPSR_Type is record
      SPI2X    : Boolean;     -- Double SPI Speed Bit
      Reserved : Bits_5 := 0;
      WCOL     : Boolean;     -- Write COLlision Flag
      SPIF     : Boolean;     -- SPI Interrupt Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPSR_Type use record
      SPI2X    at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 5;
      WCOL     at 0 range 6 .. 6;
      SPIF     at 0 range 7 .. 7;
   end record;

   SPSR_ADDRESS : constant := 16#4D#;

   SPSR : aliased SPSR_Type
      with Address              => To_Address (SPSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.5.3 SPDR – SPI Data Register

   SPDR_ADDRESS : constant := 16#4E#;

   SPDR : aliased Unsigned_8
      with Address              => To_Address (SPDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 19. USART0
   ----------------------------------------------------------------------------

   type USART_Character_Size_Type is record
      UCSZ0_01 : Bits_2; -- Character Size bit 0 .. 1
      UCSZ0_2  : Bits_1; -- Character Size bit 2
   end record;

   UCSZ_5 : constant USART_Character_Size_Type := (2#00#, 0);
   UCSZ_6 : constant USART_Character_Size_Type := (2#01#, 0);
   UCSZ_7 : constant USART_Character_Size_Type := (2#10#, 0);
   UCSZ_8 : constant USART_Character_Size_Type := (2#11#, 0);
   UCSZ_9 : constant USART_Character_Size_Type := (2#11#, 1);

   UCPOL_Rising  : constant := 0;
   UCPOL_Falling : constant := 1;

   USBS_1 : constant := 2#0#;
   USBS_2 : constant := 2#1#;

   UPM_Disabled : constant := 2#00#;
   UPM_Reserved : constant := 2#01#;
   UPM_Even     : constant := 2#10#;
   UPM_Odd      : constant := 2#11#;

   UMSEL_Asynchronous : constant := 2#00#;
   UMSEL_Synchronous  : constant := 2#01#;
   UMSEL_Reserved     : constant := 2#10#;
   UMSEL_Master_SPI   : constant := 2#11#;

   -- 19.10.2 UCSRnA – USART Control and Status Register n A

   type UCSR0A_Type is record
      MPCM0 : Boolean := False; -- Multi-Processor Communication Mode
      U2X0  : Boolean := False; -- Double the USART transmission speed
      UPE0  : Boolean := False; -- Parity Error
      DOR0  : Boolean := False; -- Data Overrun
      FE0   : Boolean := False; -- Framing Error
      UDRE0 : Boolean := True;  -- USART Data Register Empty
      TXC0  : Boolean := False; -- USART Transmit Complete
      RXC0  : Boolean := False; -- USART Receive Complete
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCSR0A_Type use record
      MPCM0 at 0 range 0 .. 0;
      U2X0  at 0 range 1 .. 1;
      UPE0  at 0 range 2 .. 2;
      DOR0  at 0 range 3 .. 3;
      FE0   at 0 range 4 .. 4;
      UDRE0 at 0 range 5 .. 5;
      TXC0  at 0 range 6 .. 6;
      RXC0  at 0 range 7 .. 7;
   end record;

   UCSR0A_ADDRESS : constant := 16#C0#;

   UCSR0A : aliased UCSR0A_Type
      with Address              => To_Address (UCSR0A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 19.10.3 UCSRnB – USART Control and Status Register n B

   type UCSR0B_Type is record
      TXB80   : Bits_1 := 0;              -- Transmit Data bit 8
      RXB80   : Bits_1 := 0;              -- Receive Data bit 8
      UCSZ0_2 : Bits_1 := UCSZ_8.UCSZ0_2; -- Character Size bit 2
      TXEN0   : Boolean := False;         -- Transmitter Enable
      RXEN0   : Boolean := False;         -- Receiver Enable
      UDRIE0  : Boolean := False;         -- USART Data register Empty Interrupt Enable
      TXCIE0  : Boolean := False;         -- TX Complete Interrupt Enable
      RXCIE0  : Boolean := False;         -- RX Complete Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCSR0B_Type use record
      TXB80   at 0 range 0 .. 0;
      RXB80   at 0 range 1 .. 1;
      UCSZ0_2 at 0 range 2 .. 2;
      TXEN0   at 0 range 3 .. 3;
      RXEN0   at 0 range 4 .. 4;
      UDRIE0  at 0 range 5 .. 5;
      TXCIE0  at 0 range 6 .. 6;
      RXCIE0  at 0 range 7 .. 7;
   end record;

   UCSR0B_ADDRESS : constant := 16#C1#;

   UCSR0B : aliased UCSR0B_Type
      with Address              => To_Address (UCSR0B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 19.10.4 UCSRnC - USART Control and Status Register n C

   type UCSR0C_Type is record
      UCPOL0   : Bits_1 := UCPOL_Rising;       -- Clock Polarity
      UCSZ0_01 : Bits_2 := UCSZ_8.UCSZ0_01;    -- Character Size bit 0 .. 1
      USBS0    : Bits_1 := USBS_1;             -- Stop Bit Select
      UPM0     : Bits_2 := UPM_Even;           -- Parity Mode
      UMSEL0   : Bits_2 := UMSEL_Asynchronous; -- USART Mode Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCSR0C_Type use record
      UCPOL0   at 0 range 0 .. 0;
      UCSZ0_01 at 0 range 1 .. 2;
      USBS0    at 0 range 3 .. 3;
      UPM0     at 0 range 4 .. 5;
      UMSEL0   at 0 range 6 .. 7;
   end record;

   UCSR0C_ADDRESS : constant := 16#C2#;

   UCSR0C : aliased UCSR0C_Type
      with Address              => To_Address (UCSR0C_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 19.10.5 UBRRnL and UBRRnH – USART Baud Rate Registers

   UBRR0L_ADDRESS : constant := 16#C4#;

   UBRR0L : aliased Unsigned_8
      with Address              => To_Address (UBRR0L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   UBRR0H_ADDRESS : constant := 16#C5#;

   UBRR0H : aliased Unsigned_8
      with Address              => To_Address (UBRR0H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 19.10.1 UDRn – USART I/O Data Register n

   UDR0_ADDRESS : constant := 16#C6#;

   UDR0 : aliased Unsigned_8
      with Address              => To_Address (UDR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end ATmega328P;
