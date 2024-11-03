
with System;
with System.Storage_Elements;
with Ada.Characters.Latin_1;
with Ada.Unchecked_Conversion;
with Interfaces;
with Configure;
with Bits;
with AVR;
with ATmega328P;

package body Application
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Ada.Characters.Latin_1;
   use ATmega328P;

   procedure Delay_Simple
      (NLoops : in Natural);

   NBlinks : Integer := 6;

   type USART_Buffer is array (Integer range <>) of Character;
   -- type USART_Buffer_Ptr is access USART_Buffer;
   -- function To_USART_Buffer_Ptr is new Ada.Unchecked_Conversion (System.Address, USART_Buffer_Ptr);

   Hello : constant USART_Buffer := [
                                     'H', 'e', 'l', 'l', 'o', ',', ' ',
                                     'S', 'w', 'e', 'e', 't', 'A', 'd', 'a',
                                     CR, LF
                                    ];

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
   procedure Delay_Simple
      (NLoops : in Natural)
      is
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
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      -- GPIO PIN 13 startup blink test, to verify .data relocation -----------
      DDRB (5) := True;
      for N in 1 .. NBlinks loop
         PORTB (5) := True;
         Delay_Simple (4);
         PORTB (5) := False;
         Delay_Simple (8);
      end loop;
      Delay_Simple (32);
      NBlinks := 3;
      -- blink test -----------------------------------------------------------
      if False then
         loop
            for N in 1 .. NBlinks loop
               PORTB (5) := True;
               Delay_Simple (4);
               PORTB (5) := False;
               Delay_Simple (8);
            end loop;
            Delay_Simple (32);
         end loop;
      end if;
      -- SPI test -------------------------------------------------------------
      if False then
         -- configure MISO as output
         PORTB (4) := False;
         DDRB (4) := True;
         -- /SS in slave mode => there is no need to configure I/O pin SCK
         SPCR := (
            SPR  => SPR_DIV4,               -- SPI Clock Rate Select 1 and 0
            CPHA => CPHA_LSample_TSetup,    -- Clock Phase
            CPOL => CPOL_LRaising_TFalling, -- Clock Polarity
            MSTR => MSTR_SLAVE,             -- Master/Slave Select
            DORD => DORD_MSB,               -- Data Order
            SPE  => True,                   -- SPI Enable
            SPIE => False                   -- SPI Interrupt Enable
            );
         SPDR := 16#AA#;
      end if;
      -- USART test -----------------------------------------------------------
      if True then
         -- set baud rate: CLOCK_XTAL / (16 * BAUD_RATE) - 1 = 16E+6 / (16 * 19200) - 1 = 51
         UBRR0L := Interfaces.Unsigned_8 ((Configure.CLOCK_XTAL + (16 * 19_200 / 2)) / (16 * 19_200) - 1);
         UBRR0H := 0;
         -- TX, RX, 8N1
         UCSR0B := (
            UCSZ0_2 => UCSZ_8.UCSZ0_2, -- Character Size bit 2
            TXEN0   => True,           -- Transmitter Enable
            RXEN0   => True,           -- Receiver Enable
            UDRIE0  => False,          -- USART Data register Empty Interrupt Enable
            TXCIE0  => True,           -- TX Complete Interrupt Enable
            RXCIE0  => False,          -- RX Complete Interrupt Enable
            others  => <>
            );
         UCSR0C := (
            UCPOL0   => UCPOL_Rising,      -- Clock Polarity
            UCSZ0_01 => UCSZ_8.UCSZ0_01,   -- Character Size bit 0 .. 1
            USBS0    => USBS_1,            -- Stop Bit Select
            UPM0     => UPM_Disabled,      -- Parity Mode
            UMSEL0   => UMSEL_Asynchronous -- USART Mode Select
            );
         while True loop
            for Idx in Hello'First .. Hello'Last loop
               loop
                  exit when UCSR0A.UDRE0;
               end loop;
               UDR0 := Bits.To_U8 (Hello (Idx));
               if True then
                  -- "confirm" a TX in case a terminal is not open (the MCU is
                  -- sending characters, but the TX LED is stuck on)
                  PORTB (5) := True;
                  Delay_Simple (2);
                  PORTB (5) := False;
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
