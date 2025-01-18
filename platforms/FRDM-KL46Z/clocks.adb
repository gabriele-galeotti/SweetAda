-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ clocks.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Definitions;
with Bits;
with CPU;
with KL46Z;
with BSP;

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
   -- Starting from 8 MHz crystal, generates 48 MHz core clock and peripherals
   -- at 24 MHz.
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- MCG comes out of reset in FEI mode
      SIM_CLKDIV1 := (
         OUTDIV4 => OUTDIV4_DIV2,
         OUTDIV1 => OUTDIV1_DIV1,
         others  => <>
         );
      OSC0_CR.ERCLKEN := True;
      MCG_C2 := (
         EREFS0  => EREFS0_OSC,
         RANGE0  => RANGE0_VHI1,
         others  => <>
         );
      loop exit when MCG_S.OSCINIT0; end loop;
      MCG_C1 := (
         IREFS   => IREFS_EXT,
         FRDIV   => FRDIV_8_256,   -- 8 MHz / 256 = 31.25 kHz
         -- CLKS    => CLKS_FLLPLLCS, -- go to FEE
         CLKS    => CLKS_EXT,      -- go to FBE
         others  => <>
         );
      loop exit when MCG_S.IREFST = IREFST_EXT; end loop;
      loop exit when MCG_S.CLKST = CLKST_EXT; end loop;
      MCG_C5 := (
         PRDIV0    => PRDIV0_DIV4, -- 8 MHz / 4 = 2 MHz
         PLLCLKEN0 => True,
         others    => <>
         );
      -- FBE mode established
      MCG_C6 := (
         VDIV0  => VDIV0_x24,  -- 2 MHz * 24 = 48 MHz
         PLLS   => PLLS_PLLCS,
         others => <>
         );
      loop exit when MCG_S.PLLST = PLLST_PLLCS; end loop;
      loop exit when MCG_S.LOCK0; end loop;
      MCG_C1.CLKS := CLKS_FLLPLLCS;
      MCG_C6.PLLS := PLLS_PLLCS;
      loop exit when MCG_S.CLKST = CLKST_PLL; end loop;
      SIM_SOPT2 := (
         RTCCLKOUTSEL => RTCCLKOUTSEL_OSCERCLK,
         CLKOUTSEL    => CLKOUTSEL_OSCERCLK,
         PLLFLLSEL    => PLLFLLSEL_MCGFLLCLKDIV2,
         USBSRC       => USBSRC_MCGxLL,
         TPMSRC       => TPMSRC_DISABLED,
         UART0SRC     => UART0SRC_MCGxLLCLK,
         others       => <>
         );
      BSP.CORE_Clock := 48 * MHz1;
      BSP.UART_Clock := 24 * MHz1;
   end Init;

end Clocks;
