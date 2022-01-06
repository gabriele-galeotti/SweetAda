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

   -- CORE0_MBOX3_SET_BASEADDRESS : constant := 16#4000_008C#;
   -- procedure Core_Enable (CoreN : Integer; Start_Address : Integer_Address);
   -- procedure Core_Enable (CoreN : Integer; Start_Address : Integer_Address) is
   --    C : constant Integer_Address := 16#10# * Integer_Address (CoreN);
   -- begin
   --    MMIO.Write (To_Address (RPI3.CORE0_MBOX3_SET_BASEADDRESS + C), Unsigned_32 (Start_Address));
   -- end Core_Enable;

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
      RPI3.AUX_MU_IO_REG := Unsigned_32 (Bits.To_U8 (C));
      for Delay_Loop_Count in 1 .. 10_000 loop CPU.NOP; end loop;
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- mini-UART ------------------------------------------------------------
      -- GPIO Pin 14 takes alternate function 5
      RPI3.GPFSEL1         := (@ and 16#FFFF_8FFF#) or 16#0000_2000#;
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
