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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with CPU;
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

   use System.Storage_Elements;
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
      while (RPI3.AUX_MU_LSR_REG and 16#0000_0020#) = 0 loop null; end loop;
      RPI3.AUX_MU_IO_REG := Unsigned_32 (Bits.To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      while (RPI3.AUX_MU_LSR_REG and 16#0000_0001#) = 0 loop null; end loop;
      C := Character'Val (Unsigned_8 (RPI3.AUX_MU_IO_REG));
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- mini-UART (UART1) ----------------------------------------------------
      -- GPIO pins 14/15 (8/10) take alternate function 5
      RPI3.GPFSEL1.FSEL14  := RPI3.GPIO_ALT5;
      RPI3.GPFSEL1.FSEL15  := RPI3.GPIO_ALT5;
      RPI3.AUXENB          := 16#0000_0001#;
      RPI3.AUX_MU_BAUD     := 16#0000_0CB6#; -- 9600 bps @ 250 MHz
      RPI3.AUX_MU_LCR_REG  := 16#0000_0003#;
      RPI3.AUX_MU_CNTL_REG := 16#0000_0003#;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Raspberry Pi 3", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
