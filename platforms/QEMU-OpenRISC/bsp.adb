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
with Ada.Unchecked_Conversion;
with Configure;
with Definitions;
with Bits;
with MMIO;
with Secondary_Stack;
with OpenRISC;
with Exceptions;
with Virt;
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
   use Virt;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tick_Timer_Init
   ----------------------------------------------------------------------------
   procedure Tick_Timer_Init
      is
   begin
      OpenRISC.TTMR_Write ((
         TP => Configure.CLOCK_FREQUENCY / Configure.TICK_FREQUENCY,
         IP => False,
         IE => True,
         M  => OpenRISC.M_STOP
         ));
      OpenRISC.TTCR_Write (0);
   end Tick_Timer_Init;

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
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- UART -----------------------------------------------------------------
      UART_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (UART_BASEADDRESS),
         Scale_Address => 0,
         Baud_Clock    => CLK_UART1M8,
         Flags         => (PC_UART => False),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (UART_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("OpenRISC " & Configure.CPU_MODEL & " (QEMU emulator)", NL => True);
      declare
         function To_U32 is new Ada.Unchecked_Conversion (OpenRISC.VR_Type, Unsigned_32);
      begin
         Console.Print (Prefix => "VR: ", Value => To_U32 (OpenRISC.VR_Read), NL => True);
      end;
      -------------------------------------------------------------------------
      OpenRISC.TEE_Enable (True);
      Tick_Timer_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
