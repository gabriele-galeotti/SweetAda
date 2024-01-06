-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with System.Parameters;
with System.Secondary_Stack;
with Configure;
with Definitions;
with Bits;
with ATmega328P;
with Console;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Definitions;
   use Bits;
   use ATmega328P;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_get_secondary_stack";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when UCSR0A.UDRE0;
      end loop;
      UDR0 := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      -- wait for receiver available
      loop
         exit when UCSR0A.RXC0;
      end loop;
      C := To_Ch (UDR0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
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
         UPM0     => UPM_Disabled,      -- Parity Mode
         UMSEL0   => UMSEL_Asynchronous -- USART Mode Select
         );
      -- without this, seemingly QEMU is not able to correctly setup RX poll
      declare
         Unused : Unsigned_8 with Unreferenced => True;
      begin
         Unused := UDR0;
      end;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("AVR " & Configure.CPU_MODEL & " (QEMU emulator)", NL => True);
      -- setup GPIO PIN 13 ----------------------------------------------------
      DDRB := (DDB5 => True, others => False);
      -------------------------------------------------------------------------
   end Setup;

end BSP;
