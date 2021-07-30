-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Configure;
with Bits;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
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
      UART1.Data_Register := Unsigned_32 (To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      -- CR : aliased GPTimer_Control_Register_Type with Volatile => True;
   begin
      -------------------------------------------------------------------------
      -- timer tick = 40 MHz / 40 = 1 MHz
      GPTIMER.Scaler_Reload_Value := (Configure.TIMER_SYSCLK / 1000) - 1;
      -- CR.RS := True;
      -- CR.CH := False;
      -- GPTIMER.Control_Register_1 := CR;
      -- GPTIMER.Control_Register_2 := CR;
      -- GPTIMER.Control_Register_3 := CR;
      -- GPTIMER.Control_Register_4 := CR;
      -- GPTIMER.Reload_1           := 16#0000_0800#;
      -- CR := GPTIMER.Control_Register_1;
      -- CR.LD := True;
      -- CR.IE := True;
      -- CR.EN := True;
      -- GPTIMER.Control_Register_1 := CR;
      GPTIMER.Control_Register_1.RS := True;
      GPTIMER.Control_Register_1.CH := False;
      GPTIMER.Reload_1              := 1000;
      GPTIMER.Control_Register_1.LD := True;
      GPTIMER.Control_Register_1.IE := True;
      GPTIMER.Control_Register_1.EN := True;
      UART1.Control_Register.TE := True;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("LEON3 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
