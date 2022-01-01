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
with KL46Z;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use KL46Z;

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
   begin
      -- Console --------------------------------------------------------------
      -- Console.Console_Descriptor.Write := Console_Putchar'Access;
      -- Console.Console_Descriptor.Read  := Console_Getchar'Access;
      -- Console.TTY_Setup;
      -------------------------------------------------------------------------
      -- blink on-board LED
      declare
         Delay_Count : constant := 1_000_000;
      begin
         SIM_SCGC5.PORTD := True;
         SIM_SCGC5.PORTE := True;
         -- LED1 (GREEN)
         PORTD_PCR05.MUX := MUX_ALT1_GPIO;
         GPIOD_PDDR.PDD05 := True;
         -- LED2 (RED)
         PORTE_PCR29.MUX := MUX_ALT1_GPIO;
         GPIOE_PDDR.PDD29 := True;
         while True loop
            GPIOD_PTOR.PTTO05 := True;
            GPIOE_PTOR.PTTO29 := True;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
         end loop;
      end;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
