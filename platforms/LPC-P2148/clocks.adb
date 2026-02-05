-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ clocks.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Definitions;
with Bits;
with LPC2148;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Definitions;
   use Bits;
   use LPC2148;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- XTAL input frequency = 12 MHz
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      PLL0CFG := (
         MSEL   => MSEL_M5, -- CCLK = 12 MHz x 5 = 60 MHz
         PSEL   => PSEL_P2, -- FCCO = 60 MHz x 2 x 2 = 240 MHz
         others => <>
         );
      PLL0CON := (
         PLLE   => True,
         PLLC   => False,
         others => <>
         );
      PLL0FEED := PLLxFEED_VALUE1;
      PLL0FEED := PLLxFEED_VALUE2;
      loop exit when PLL0STAT.PLOCK; end loop;
      PLL0CON := (
         PLLE   => True,
         PLLC   => True,
         others => <>
         );
      PLL0FEED := PLLxFEED_VALUE1;
      PLL0FEED := PLLxFEED_VALUE2;
      -- setup values
      CLK_Core := 60 * MHz1;
   end Init;

end Clocks;
