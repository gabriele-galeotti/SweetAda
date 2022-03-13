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
with Bits;
with MPC8306;
with Switch;
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
      loop
         exit when (MPC8306.UART1_ULSR and 16#20#) /= 0;
      end loop;
      MPC8306.UART1_UTHR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      Data := 0;
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      BAUDRATE : constant := 9600;
      BAUDRATE_DIVISOR : constant := Switch.SYSTEM_CLOCK / (BAUDRATE * 16);
   begin
      -- 6.3.2.6 System I/O Configuration Register 2 (SICR_2) -----------------
      MPC8306.SICR_1 := 16#0001_165F#; -- UART1A mapped on I/O pads
      MPC8306.SICR_2 := 16#A005_0475#; -- GPIO22 function
      MPC8306.GP1DIR := 16#0000_0200#; -- GPIO22 = output
      MPC8306.GP1ODR := 16#FFFF_FDFF#; -- GPIO22 = actively driven
      -- UART1 ----------------------------------------------------------------
      MPC8306.UART1_ULCR := 16#83#;                                 -- access UDLB, UDMB
      MPC8306.UART1_UDLB := Unsigned_8 (BAUDRATE_DIVISOR mod 2**8); -- 0x64
      MPC8306.UART1_UDMB := Unsigned_8 (BAUDRATE_DIVISOR / 2**8);   -- 0x03
      MPC8306.UART1_ULCR := 16#03#;                                 -- 8-bit
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("MPC8306 Switch", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
