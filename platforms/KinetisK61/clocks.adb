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

with Bits;
with K61;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Bits;
   use K61;

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
      SIM_CLKDIV1 := (
         OUTDIV4 => OUTDIVx_DIV4,
         OUTDIV3 => OUTDIVx_DIV4,
         OUTDIV2 => OUTDIVx_DIV2,
         OUTDIV1 => OUTDIVx_DIV1,
         others  => <>
         );
      MCG_C2 := (
         EREFS0 => EREFS0_EXT,
         RANGE0 => RANGE0_VHI1,
         others => <>
         );
      MCG_C1 := (
         -- IRCLKEN => True,
         IREFS   => IREFS_EXT,
         FRDIV   => FRDIV_64_1280, -- 50 / 1280 = 39.0625 kHz
         -- CLKS    => CLKS_FLLPLLCS, -- go to FEE
         CLKS    => CLKS_EXT,      -- go to FBE
         others  => <>
         );
      loop exit when MCG_S.IREFST = IREFST_EXT; end loop;
      loop exit when MCG_S.CLKST = CLKST_EXT; end loop;
      MCG_C5 := (
         PRDIV0     => PRDIV0_DIV4,     -- 50 / 4 = 12.5 MHz
         PLLCLKEN0  => True,
         PLLREFSEL0 => PLLREFSEL0_OSC0,
         others     => <>
         );
      -- FBE mode established
      MCG_C6 := (
         VDIV0  => VDIV0_x24,  -- 12.5 * 24 = 300 MHz (VCO)
         PLLS   => PLLS_PLLCS,
         others => <>
         );
      loop exit when MCG_S.PLLST = PLLST_PLLCS; end loop;
      loop exit when MCG_S.LOCK0; end loop;
      MCG_C1.CLKS := CLKS_FLLPLLCS;
      MCG_C6.PLLS := PLLS_PLLCS;
      loop exit when MCG_S.CLKST = CLKST_PLL; end loop;
      if False then
         -- 5.7.3 Debug trace clock
         -- 12.2.3 System Options Register 2 (SIM_SOPT2)
         -- 12.2.24 System Clock Divider Register 4 (SIM_CLKDIV4)
         -- SIM_SOPT2.TRACECLKSEL := TRACECLKSEL_MCGCLKOUT;
         SIM_SOPT2.TRACECLKSEL := TRACECLKSEL_CORE;
         SIM_CLKDIV4.TRACEFRAC := 1;
         SIM_CLKDIV4.TRACEDIV  := 1;
         SIM_SCGC5.PORTA := True;               -- PORTA clock gate control
         PORTA_MUXCTRL.PCR (6).MUX := MUX_ALT7; -- PTA6 = ALT7 = TRACE_CLKOUT
      end if;
   end Init;

end Clocks;
