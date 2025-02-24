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

with CPU;
with MSP432P401R;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use MSP432P401R;

   function Status_Ready
      return Boolean
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Status_Ready
   ----------------------------------------------------------------------------
   function Status_Ready
      return Boolean
      is
      Status : CSSTAT_Type;
   begin
      Status := CSSTAT;
      return Status.ACLK_READY   and then
             Status.BCLK_READY   and then
             Status.MCLK_READY   and then
             Status.SMCLK_READY  and then
             Status.HSMCLK_READY;
   end Status_Ready;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- Initialize clocks, HFXT = 48 MHz
   -- MCLK CPU:     24 MHz
   -- HSMCLK/SMCLK: 12 MHz
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      CSKEY.CSKEY := CSKEY_CSKEY;
      loop exit when CSSTAT.REFO_ON; end loop;
      -- set primary module for HFXT
      PJ.PxSELC (2) := False;
      PJ.PxSEL0 (2) := True;
      PJ.PxSEL1 (2) := False;
      PJ.PxSELC (3) := False;
      PJ.PxSEL0 (3) := True;
      PJ.PxSEL1 (3) := False;
      -- HFX, 48 MHz external source
      CSCTL2 := (
         LFXTDRIVE  => LFXTDRIVE_0,
         LFXT_EN    => False,
         LFXTBYPASS => LFXTBYPASS_EXTAL,
         HFXTDRIVE  => HFXTDRIVE_5_48,
         HFXTFREQ   => HFXTFREQ_41_48,
         HFXT_EN    => True,
         HFXTBYPASS => HFXTBYPASS_EXTAL,
         others     => <>
         );
      -- wait until HFXT oscillator does not fail
      loop
         CSCLRIFG.CLR_HFXTIFG := True;
         for Delay_Loop_Count in 1 .. 1024 loop CPU.NOP; end loop;
         exit when CSSTAT.HFXT_ON and then not CSIFG.HFXTIFG;
      end loop;
      -- clock enables
      CSCLKEN := (
         ACLK_EN   => True,
         MCLK_EN   => True,
         HSMCLK_EN => True,
         SMCLK_EN  => True,
         VLO_EN    => False,
         REFO_EN   => True,
         MODOSC_EN => False,
         REFOFSEL  => REFOFSEL_32k,
         others => <>
         );
      -- check for readiness
      loop exit when Status_Ready; end loop;
      -- MCLK = 24 MHz (core clock), SMCLK = 12 MHz (peripherals)
      CSCTL1 := (
         SELM   => SELM_HFXTCLK,
         SELS   => SELS_HFXTCLK,
         SELA   => SELA_REFOCLK,
         SELB   => SELB_REFOCLK,
         DIVM   => DIVM_DIV2,
         DIVHS  => DIVHS_DIV4,
         DIVA   => DIVA_DIV4,
         DIVS   => DIVS_DIV4,
         others => <>
         );
      -- check for readiness
      loop exit when Status_Ready; end loop;
      -- disable DCO
      CSCTL0 := (
         DCOTUNE => 0,
         DCORSEL => DCORSEL_48M,
         DCORES  => False,
         DCOEN   => False,
         others  => <>
         );
   end Init;

end Clocks;
