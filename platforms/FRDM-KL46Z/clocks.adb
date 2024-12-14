-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ clocks.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with KL46Z;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use KL46Z;

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
   procedure Init
      is
   begin
      -- MCG comes out of reset in FEI mode
      OSC0_CR.ERCLKEN := True;
      MCG_C1 := (
         IRCLKEN => True,
         IREFS   => IREFS_EXT,
         FRDIV   => FRDIV_8_256,
         CLKS    => CLKS_FLLPLL,
         others  => <>
         );
      MCG_C2 := (
         EREFS0  => EREFS0_OSC,
         RANGE0  => RANGE0_VHI1,
         LOCRE0  => LOCRE0_IRQ,
         others  => <>
         );
      MCG_C5.PRDIV0 := PRDIV0_DIV2;
      MCG_C6.PLLS := PLLS_PLL;
      MCG_C7.OSCSEL := OSCSEL_OSC;
      SIM_SOPT2 := (
         RTCCLKOUTSEL => RTCCLKOUTSEL_OSCERCLK,
         CLKOUTSEL    => CLKOUTSEL_OSCERCLK,
         PLLFLLSEL    => PLLFLLSEL_MCGFLLCLKDIV2,
         USBSRC       => USBSRC_MCGxLL,
         TPMSRC       => TPMSRC_DISABLED,
         UART0SRC     => UART0SRC_OSCERCLK,
         others       => <>
         );
   end Init;

end Clocks;
