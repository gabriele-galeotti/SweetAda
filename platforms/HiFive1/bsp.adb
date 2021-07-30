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
with HiFive1;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

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
      HiFive1.LEDs_IOF  := HiFive1.LEDs_IOF and 16#FF97_FFFF#;
      HiFive1.LEDs_PORT := HiFive1.LEDs_PORT or 16#0068_0000#;
      HiFive1.LEDs_OEN  := HiFive1.LEDs_OEN or 16#0068_0000#;
      declare
         Delay_Count : constant := 5_000_000;
      begin
         while True loop
            -- turn on RED
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT and 16#FFBF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            -- turn on GREEN
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT and 16#FFF7_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            -- turn on BLUE
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT and 16#FFDF_FFFF#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
            HiFive1.LEDs_PORT := HiFive1.LEDs_PORT or 16#0068_0000#;
            for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
         end loop;
      end;
   end BSP_Setup;

end BSP;
