-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Interfaces;
with Bits;
with ATmega328P;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use ATmega328P;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      -- wait for transmitter available
      loop
         exit when UCSR0A.UDRE0;
      end loop;
      UDR0 := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      Data := 0;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- USART0 ---------------------------------------------------------------
      UBRR0L := 16#67#;
      UBRR0H := 0;
      UCSR0B := (
                 UCSZ0_2 => UCSZ_8.UCSZ0_2, -- Character Size bit 2
                 TXEN0   => True,           -- Transmitter Enable
                 RXEN0   => True,           -- Receiver Enable
                 UDRIE0  => False,          -- USART Data register Empty Interrupt Enable
                 TXCIE0  => False,          -- TX Complete Interrupt Enable
                 RXCIE0  => False,          -- RX Complete Interrupt Enable
                 others  => <>
                );
      UCSR0C := (
                 UCPOL0   => UCPOL_Rising,      -- Clock Polarity
                 UCSZ0_01 => UCSZ_8.UCSZ0_01,   -- Character Size bit 0 .. 1
                 USBS0    => USBS_1,            -- Stop Bit Select
                 UPM0     => UPM_Even,          -- Parity Mode
                 UMSEL0   => UMSEL_Asynchronous -- USART Mode Select
                );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("AVR ATmega328P (QEMU emulator)", NL => True);
      -- setup GPIO PIN 13 ----------------------------------------------------
      DDRB := (DDB5 => True, others => False);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
