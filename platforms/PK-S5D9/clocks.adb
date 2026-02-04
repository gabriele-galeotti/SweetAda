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
with S5D9;

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
   use S5D9;

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
      -- select MOCO
      SCKSCR.CKSEL := CKSEL_MOCO;
      -- stop MOSC clock
      MOSCCR.MOSTP := True;
      -- confirm MOSC clock stopped
      loop exit when not OSCSF.MOSCSF; end loop;
      -- stop PLL
      PLLCR.PLLSTP := True;
      -- confirm PLL stopped
      loop exit when not OSCSF.PLLSF; end loop;
      -- setup MODRV = 24 MHz MOSEL = Resonator AUTODRVEN = Disable
      MOMCR := (
         MODRV     => MODRV_20_24,
         MOSEL     => MOSEL_RES,
         AUTODRVEN => False,
         others    => <>
         );
      -- setup MOSCWTCR, conservative
      MOSCWTCR.MSTS := MSTS_9;
      -- start MOSC clock
      MOSCCR.MOSTP := False;
      -- wait for stabilization
      loop exit when OSCSF.MOSCSF; end loop;
      -- select MOSC clock
      SCKSCR.CKSEL := CKSEL_MOSC;
      -- use MOSC clock
      PLLCCR := (
         PLIDIV   => PLIDIV_DIV2,   -- PLL Input Frequency Division Ratio Select (24 MHz / 2 = 12 MHz)
         PLSRCSEL => PLSRCSEL_MOSC, -- PLL Clock Source Select
         PLLMUL   => PLLMUL_x_10_0, -- PLL Frequency Multiplication Factor Select (12 MHz x 10 = 120 MHz)
         others   => <>
         );
      -- start PLL
      PLLCR.PLLSTP := False;
      -- wait for stabilization
      loop exit when OSCSF.PLLSF; end loop;
      -- select PLL
      SCKSCR.CKSEL := CKSEL_PLL;
      -- select module frequencies
      SCKDIVCR := (
         ICK    => SCKDIVCR_DIV1, -- System Clock              -> 120 MHz - CPU
         BCK    => SCKDIVCR_DIV4, -- External Bus Clock        ->  30 MHz
         FCK    => SCKDIVCR_DIV4, -- Flash Interface Clock     ->  30 MHz
         PCKA   => SCKDIVCR_DIV4, -- Peripheral Module Clock A ->  30 MHz - SCI3 SPI0 ETHERC
         PCKB   => SCKDIVCR_DIV8, -- Peripheral Module Clock B ->  15 MHz - I2C2
         PCKC   => SCKDIVCR_DIV4, -- Peripheral Module Clock C ->  30 MHz
         PCKD   => SCKDIVCR_DIV4, -- Peripheral Module Clock D ->  30 MHz
         others => <>
         );
      -- setup clock values
      CLK_Core := 120 * MHz1;
      CLK_PCKA := 30 * MHz1;
      CLK_PCKB := 15 * MHz1;
      CLK_PCKC := 30 * MHz1;
      CLK_PCKD := 30 * MHz1;
   end Init;

end Clocks;
