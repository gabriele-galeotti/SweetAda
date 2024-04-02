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

with Ada.Unchecked_Conversion;
with Definitions;
with Bits;
with RISCV;
with MTIME;
with NEORV32;
with Exceptions;
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
   use RISCV;
   use MTIME;
   use NEORV32;

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

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when not UART0.CTRL.UART_CTRL_TX_FULL;
      end loop;
      UART0.DATA.UART_DATA_RTX := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when UART0.CTRL.UART_CTRL_RX_NEMPTY;
      end loop;
      Data := UART0.DATA.UART_DATA_RTX;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      function To_U32 is new Ada.Unchecked_Conversion (UART_CTRL_Type, Unsigned_32);
   begin
      -- UART0 ----------------------------------------------------------------
      -- serial port wiring:
      -- GND = GPIO-30
      -- RXD = GPIO-33
      -- TXD = GPIO-34
      -- 19200 baud @ clk_i = 90 MHz
      UART0.CTRL := (
         UART_CTRL_EN            => True,
         UART_CTRL_SIM_MODE      => False,
         UART_CTRL_HWFC_EN       => False,
         UART_CTRL_PRSC          => 2#10#,
         UART_CTRL_BAUD          => 584,
         UART_CTRL_RX_NEMPTY     => False,
         UART_CTRL_RX_HALF       => False,
         UART_CTRL_RX_FULL       => False,
         UART_CTRL_TX_EMPTY      => False,
         UART_CTRL_TX_NHALF      => False,
         UART_CTRL_TX_FULL       => False,
         UART_CTRL_IRQ_RX_NEMPTY => False,
         UART_CTRL_IRQ_RX_HALF   => False,
         UART_CTRL_IRQ_RX_FULL   => False,
         UART_CTRL_IRQ_TX_EMPTY  => False,
         UART_CTRL_IRQ_TX_NHALF  => False,
         UART_CTRL_RX_OVER       => False,
         UART_CTRL_TX_BUSY       => False,
         others                  => <>
         );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("NEORV32 (DE10-Lite)", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      Timer_Value := mtime_Read + Timer_Constant;
      mtimecmp_Write (Timer_Value);
      mie_Set_Interrupt ((MTIE => True, others => <>));
      Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
