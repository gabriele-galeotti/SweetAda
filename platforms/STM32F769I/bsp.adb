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

with Interfaces;
with STM32F769I;
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
   use STM32F769I;

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
      null;
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      Delay_Count : constant := 50000000;
      dummy       : Unsigned_32;
   begin
      --                           15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
      PORT_GPIOJ.MODER.Value  := 2#00_00_01_00_00_00_00_00_00_00_01_00_00_00_00_00#;
      --                           10 98 76 54 32 10 98 76 54 32 10 98 76 54 32 10
      PORT_GPIOJ.OTYPER.Value := 2#00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00#;
      -- PORT_GPIOJ.OTYPER.Value := 2#00_00_00_00_00_00_00_00_00_10_00_00_00_10_00_00#;
      PORT_GPIOJ.PUPDR := 0;
      while True loop
         dummy := PORT_GPIOJ.ODR.Value;
         PORT_GPIOJ.ODR.Value := dummy or 16#0000_2020#;
         for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
         PORT_GPIOJ.ODR.Value := dummy and 16#0000_DFDF#;
         for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
      end loop;
   end BSP_Setup;

end BSP;
