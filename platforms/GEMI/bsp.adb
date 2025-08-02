-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with Configure;
with Definitions;
with Bits;
with MMIO;
with SH;
with GEMI;
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

   use System;
   use Interfaces;
   use Definitions;
   use Bits;

   procedure GEMI_Last_Chance_Handler
      (Source_Location : in Address;
       Line            : in Integer)
      with Export        => True,
           Convention    => C,
           External_Name => "__gemi_last_chance_handler",
           No_Return     => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- GEMI_Last_Chance_Handler
   ----------------------------------------------------------------------------
   procedure GEMI_Last_Chance_Handler
      (Source_Location : in Address;
       Line            : in Integer)
      is
      pragma Unreferenced (Source_Location);
      pragma Unreferenced (Line);
      Delay_Count : constant := 30_000;
      Value       : Unsigned_8;
   begin
      Value := 16#F0#;
      loop
         GEMI.LEDPORT := Value;
         for Delay_Loop_Count in 1 .. Delay_Count loop SH.NOP; end loop;
         Value := Value xor 16#10#;
      end loop;
   end GEMI_Last_Chance_Handler;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      UART16x50.TX (UART_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      UART16x50.RX (UART_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- UART 16x50 -----------------------------------------------------------
      UART_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (GEMI.UART_BASEADDRESS),
         Scale_Address => 4,
         Baud_Clock    => Configure.CLK_FREQUENCY,
         Flags         => (PC_UART => False),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (UART_Descriptor);
      -- RTC uPD4991A ---------------------------------------------------------
      RTC_Descriptor := (
         Base_Address  => System'To_Address (GEMI.RTC_BASEADDRESS),
         Scale_Address => 0,
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access
         );
      uPD4991A.Init (RTC_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("GEMI SH7032", NL => True);
      -------------------------------------------------------------------------
   end Setup;

end BSP;
