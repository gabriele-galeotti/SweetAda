-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Storage_Elements;
with Interfaces;
with Bits;
with MicroBlaze;
with ML605;
with MMIO;
with Exceptions;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use MicroBlaze;
   use ML605;

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
      UART16x50.TX (UART_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART16x50.RX (UART_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- UART -----------------------------------------------------------------
      UART_Descriptor.Read_8        := MMIO.Read'Access;
      UART_Descriptor.Write_8       := MMIO.Write'Access;
      UART_Descriptor.Base_Address  := To_Address (UART16550_BASEADDRESS);
      UART_Descriptor.Scale_Address := 2;
      UART_Descriptor.Baud_Clock    := 1_843_200;
      UART16x50.Init (UART_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("MicroBlaze ML605 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      INTC_Init;
      Tclk_Init;
      INTC.IER (TIMER_IRQ) := True;
      Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
