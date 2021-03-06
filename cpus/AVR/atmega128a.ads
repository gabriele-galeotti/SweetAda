-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ atmega128a.ads                                                                                            --
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

package ATmega128A is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;

   ----------------------------------------------------------------------------
   -- CPU control
   ----------------------------------------------------------------------------

   -- Status Register

   type SREG_Type is
   record
      C : Boolean; -- Carry flag
      Z : Boolean; -- Zero flag
      N : Boolean; -- Negative flag
      V : Boolean; -- Two's Complement Overflow flag
      S : Boolean; -- Sign bit
      H : Boolean; -- Half Carry flag
      T : Boolean; -- Bit Copy Storage
      I : Boolean; -- Global Interrupt Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SREG_Type use
   record
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

   SREG : SREG_Type with
      Address              => To_Address (SREG_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- I/O Ports
   ----------------------------------------------------------------------------

   -- Port A

   type PORTA_Type is
   record
      PORTA0 : Boolean;
      PORTA1 : Boolean;
      PORTA2 : Boolean;
      PORTA3 : Boolean;
      PORTA4 : Boolean;
      PORTA5 : Boolean;
      PORTA6 : Boolean;
      PORTA7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PORTA_Type use
   record
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

   PORTA : PORTA_Type with
      Address              => To_Address (PORTA_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type DDRA_Type is
   record
      DDA0 : Boolean;
      DDA1 : Boolean;
      DDA2 : Boolean;
      DDA3 : Boolean;
      DDA4 : Boolean;
      DDA5 : Boolean;
      DDA6 : Boolean;
      DDA7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DDRA_Type use
   record
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

   DDRA : DDRA_Type with
      Address              => To_Address (DDRA_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type PINA_Type is
   record
      PINA0 : Boolean;
      PINA1 : Boolean;
      PINA2 : Boolean;
      PINA3 : Boolean;
      PINA4 : Boolean;
      PINA5 : Boolean;
      PINA6 : Boolean;
      PINA7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PINA_Type use
   record
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

   PINA : PINA_Type with
      Address              => To_Address (PINA_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Port B

   type PORTB_Type is
   record
      PORTB0 : Boolean;
      PORTB1 : Boolean;
      PORTB2 : Boolean;
      PORTB3 : Boolean;
      PORTB4 : Boolean;
      PORTB5 : Boolean;
      PORTB6 : Boolean;
      PORTB7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PORTB_Type use
   record
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

   PORTB : PORTB_Type with
      Address              => To_Address (PORTB_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type DDRB_Type is
   record
      DDB0 : Boolean;
      DDB1 : Boolean;
      DDB2 : Boolean;
      DDB3 : Boolean;
      DDB4 : Boolean;
      DDB5 : Boolean;
      DDB6 : Boolean;
      DDB7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DDRB_Type use
   record
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

   DDRB : DDRB_Type with
      Address              => To_Address (DDRB_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type PINB_Type is
   record
      PINB0 : Boolean;
      PINB1 : Boolean;
      PINB2 : Boolean;
      PINB3 : Boolean;
      PINB4 : Boolean;
      PINB5 : Boolean;
      PINB6 : Boolean;
      PINB7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PINB_Type use
   record
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

   PINB : PINB_Type with
      Address              => To_Address (PINB_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Port C

   type PORTC_Type is
   record
      PORTC0 : Boolean;
      PORTC1 : Boolean;
      PORTC2 : Boolean;
      PORTC3 : Boolean;
      PORTC4 : Boolean;
      PORTC5 : Boolean;
      PORTC6 : Boolean;
      Unused : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PORTC_Type use
   record
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

   PORTC : PORTC_Type with
      Address              => To_Address (PORTC_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type DDRC_Type is
   record
      DDC0   : Boolean;
      DDC1   : Boolean;
      DDC2   : Boolean;
      DDC3   : Boolean;
      DDC4   : Boolean;
      DDC5   : Boolean;
      DDC6   : Boolean;
      Unused : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DDRC_Type use
   record
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

   DDRC : DDRC_Type with
      Address              => To_Address (DDRC_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type PINC_Type is
   record
      PINC0  : Boolean;
      PINC1  : Boolean;
      PINC2  : Boolean;
      PINC3  : Boolean;
      PINC4  : Boolean;
      PINC5  : Boolean;
      PINC6  : Boolean;
      Unused : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PINC_Type use
   record
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

   PINC : PINC_Type with
      Address              => To_Address (PINC_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Port D

   type PORTD_Type is
   record
      PORTD0 : Boolean;
      PORTD1 : Boolean;
      PORTD2 : Boolean;
      PORTD3 : Boolean;
      PORTD4 : Boolean;
      PORTD5 : Boolean;
      PORTD6 : Boolean;
      PORTD7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PORTD_Type use
   record
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

   PORTD : PORTD_Type with
      Address              => To_Address (PORTD_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type DDRD_Type is
   record
      DDD0 : Boolean;
      DDD1 : Boolean;
      DDD2 : Boolean;
      DDD3 : Boolean;
      DDD4 : Boolean;
      DDD5 : Boolean;
      DDD6 : Boolean;
      DDD7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for DDRD_Type use
   record
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

   DDRD : DDRD_Type with
      Address              => To_Address (DDRD_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type PIND_Type is
   record
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
   for PIND_Type use
   record
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

   PIND : PIND_Type with
      Address              => To_Address (PIND_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end ATmega128A;
