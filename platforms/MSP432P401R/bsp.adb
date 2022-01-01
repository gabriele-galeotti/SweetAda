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
with MSP432P401R;
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
   use MSP432P401R;

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
      Delay_Count : constant := 500_000;
      Dummy       : Unsigned_8;
   begin
      WDTCTL := 16#5A84#; -- stop WDT
      -- Console --------------------------------------------------------------
      -- Console.Console_Descriptor.Write := Console_Putchar'Access;
      -- Console.Console_Descriptor.Read  := Console_Getchar'Access;
      -- Console.TTY_Setup;
      -------------------------------------------------------------------------
      -- blink on-board LED
      PADIR_L := PADIR_L or 16#01#;
      Dummy := PAOUT_L;
      while True loop
         Dummy := Dummy xor 1;
         PAOUT_L := Dummy;
         for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
--          Dummy := Dummy xor 1;
--          PAOUT_L := Dummy;
--          for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
      end loop;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
