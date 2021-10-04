
with System;
with System.Storage_Elements;

with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with AVR;
with ATmega328P;
with Configure;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use ATmega328P;

   procedure Delay_Simple (NLoops : in Natural);

   NBlinks : Integer := 6;

   type USART_Buffer is array (Integer range <>) of Character;
   -- type USART_Buffer_Ptr is access USART_Buffer;
   -- function To_USART_Buffer_Ptr is new Ada.Unchecked_Conversion (System.Address, USART_Buffer_Ptr);

   Hello : constant USART_Buffer := ('H', 'E', 'L', 'L', 'O');

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Delay_Simple
   ----------------------------------------------------------------------------
   procedure Delay_Simple (NLoops : in Natural) is
   begin
      for L in 1 .. NLoops loop
         for Delay_Loop_Count in Integer'First .. Integer'Last loop
            AVR.NOP;
         end loop;
      end loop;
   end Delay_Simple;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
   begin
      -------------------------------------------------------------------------
      if False then
         AVR.Asm_Call (System.Storage_Elements.To_Address (16#400#));
      end if;
      -------------------------------------------------------------------------
      -- GPIO PIN 13 blink test -----------------------------------------------
      -- on-board LED is an output
      DDRB := (DDB5 => True, others => False);
      for N in 1 .. NBlinks loop
         PORTB.PORTB5 := True;
         Delay_Simple (4);
         PORTB.PORTB5 := False;
         Delay_Simple (8);
      end loop;
      Delay_Simple (32);
      NBlinks := 3;
      -------------------------------------------------------------------------
      if False then
         loop
            for N in 1 .. NBlinks loop
               PORTB.PORTB5 := True;
               Delay_Simple (4);
               PORTB.PORTB5 := False;
               Delay_Simple (8);
            end loop;
            Delay_Simple (32);
         end loop;
      end if;
      -- SPI test -------------------------------------------------------------
      if False then
         -- configure MISO as output
         PORTB.PORTB4 := False;
         DDRB.DDB4 := True;
         -- /SS in slave mode => there is no need to configure I/O pin SCK
         SPCR := (SPE => True, others => False);
         SPDR := 16#AA#;
      end if;
      -- USART test -----------------------------------------------------------
      if True then
         -- set baud rate: CLOCK_XTAL / (16 * BAUD_RATE) - 1 = 16E+6 / (16 * 19200) - 1 = 51
         UBRR0L := Interfaces.Unsigned_8 ((Configure.CLOCK_XTAL + (16 * 19_200 / 2)) / (16 * 19_200) - 1);
         UBRR0H := 0;
         -- TX, RX, 8N1
         UCSR0C.USBS0    := Stop_Bits_1;
         UCSR0C.UPM0     := Parity_Disabled;
         UCSR0C.UCSZ0_01 := Character_Size_8.UCSZ0_01;
         UCSR0B.UCSZ0_2  := Character_Size_8.UCSZ0_2;
         UCSR0B.TXEN0    := True;
         UCSR0B.RXEN0    := True;
         while True loop
            for Idx in Hello'First .. Hello'Last loop
               loop
                  exit when UCSR0A.UDRE0;
               end loop;
               UDR0 := Bits.To_U8 (Hello (Idx));
               if True then
                  -- "alert" signal in case a terminal is not open (the MCU is
                  -- sending characters, but the TX LED is stuck on)
                  PORTB.PORTB5 := True;
                  Delay_Simple (2);
                  PORTB.PORTB5 := False;
                  Delay_Simple (2);
               end if;
               Delay_Simple (8);
            end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
