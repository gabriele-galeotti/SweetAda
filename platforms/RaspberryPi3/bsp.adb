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

with Interfaces;
with Definitions;
with Bits;
with AArch64;
with RPI3;
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

   use Interfaces;
   use Definitions;
   use Bits;

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
         exit when RPI3.AUX_MU_LSR_REG.Transmitter_Empty;
      end loop;
      RPI3.AUX_MU_IO_REG.DATA := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      -- wait for receiver available
      loop
         exit when RPI3.AUX_MU_LSR_REG.Data_Ready;
      end loop;
      C := To_Ch (RPI3.AUX_MU_IO_REG.DATA);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      System_Clock : constant := 250 * MHz;
      Baud_Rate    : constant := Baud_Rate_Type'Enum_Rep (BR_115200);
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- GPIO pins 14/15 (8/10) take alternate function 5 ---------------------
      RPI3.GPFSEL1.FSEL14 := RPI3.GPIO_ALT5;
      RPI3.GPFSEL1.FSEL15 := RPI3.GPIO_ALT5;
      -- mini-UART (UART1) ----------------------------------------------------
      RPI3.AUXENB.MiniUART_Enable := True;
      -- baud_rate_reg = SYSTEM_CLK / 8 * baud_rate - 1
      RPI3.AUX_MU_BAUD.Baudrate   := Unsigned_16 ((System_Clock + (Baud_Rate * 8 / 2)) / (Baud_Rate * 8) - 1);
      RPI3.AUX_MU_LCR_REG         := (
                                      Data_Size   => RPI3.UART_8BIT,
                                      Break       => False,
                                      DLAB_Access => False,
                                      others      => <>
                                     );
      RPI3.AUX_MU_CNTL_REG        := (
                                      Receiver_Enable    => True,
                                      Transmitter_Enable => True,
                                      RTS_RX_Autoflow    => False,
                                      CTS_TX_Autoflow    => False,
                                      RTS_Autoflow_Level => RPI3.RTS_Autoflow1,
                                      RTS_Assert_Level   => RPI3.RTS_AutoflowP,
                                      CTS_Assert_Level   => RPI3.CTS_AutoflowP,
                                      others             => <>
                                     );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Raspberry Pi 3", NL => True);
      Console.Print (Natural (AArch64.CurrentEL_Read.EL), Prefix => "Current EL:   ", NL => True);
      Console.Print (RPI3.ARMTIMER_IRQ_ClrAck,            Prefix => "ARM Timer ID: ", NL => True);
      -- GPIOs 5/6 (header pins 29/31) are output -----------------------------
      RPI3.GPFSEL0.FSEL5 := RPI3.GPIO_OUTPUT;
      RPI3.GPFSEL0.FSEL6 := RPI3.GPIO_OUTPUT;
      -- Timer IRQ ------------------------------------------------------------
      RPI3.Timer_Init;
      RPI3.Timer_Reload;
      RPI3.Enable_IRQs_1 (RPI3.system_timer_match_1) := True;
      AArch64.Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
