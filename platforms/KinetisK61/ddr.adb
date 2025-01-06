-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ddr.adb                                                                                                   --
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

with Bits;
with K61;

package body DDR
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
      -- parameters for MT47H64M16NF-25E:M
      DDR_CR00 := (DDRCLS => DDRCLS_DDR2, others => <>);
      -- DDR_CR01 = default
      DDR_CR02 := (TINIT => 49, INITAREF => 2, others => <>);
      DDR_CR03 := (LATLIN  => 6, LATGATE => 5, WRLAT => 2, TCCD => 15, others => <>);
      DDR_CR04 := (TBINT => 2, TRRD => 2, TRC => 9, TRASMIN => 6, others => <>);
      DDR_CR05 := (TWTR => 2, TRP => 3, TRTP => 2, TMRD => 2, others => <>);
      DDR_CR06 := (TMOD => 2, TRASMAX => 36928, others => <>);
      DDR_CR07 := (CLKPW => 3, TCKESR => 3, CCAPEN => True, others => <>);
      DDR_CR08 := (TRAS => True, TRASDI => 2, TWR => 3, TDAL => 5, others => <>);
      DDR_CR09 := (TDLL => 200, BSTLEN => 2, others => <>);
      DDR_CR10 := (TFAW => 7, TCPD => 50, TRPAB => 3, others => <>);
      DDR_CR11 := (TREFEN => True, others => <>);
      DDR_CR12 := (TRFC => 49, TREF => 1170, others => <>);
      -- DDR_CR13 = default
      DDR_CR14 := (TPDEX => 2, TXSR => 200);
      DDR_CR15 := (TXSNR => 50, others => <>);
      DDR_CR16 := (QKREF => True, others => <>);
      -- DDR_CR17 = default
      -- DDR_CR18 = default
      -- DDR_CR19 = default
      DDR_CR20 := (CKSRE => 3, CKSRX => 3, others => <>);
      DDR_CR21 := (MR0DAT0 => 16#0232#, MR1DAT0 => 16#0004#);
      DDR_CR22 := (MR2DAT0 => 16#0000#, MR3DAT0 => 16#0000#);
      -- DDR_CR23 = default
      -- DDR_CR24 = default
      DDR_CR25 := (BNK8 => BNK8_8, ADDPINS => 2, COLSIZ => 1, APREBIT => 10, others => <>);
      DDR_CR26 := (AGECNT => 255, CMDAGE => 255, ADDCOL => True, BNKSPT => True, others => <>);
      DDR_CR27 := (PLEN => True, PRIEN => True, RWEN => True, SWPEN => True, others => <>);
      DDR_CR28 := (CSMAP => True, others => <>);
      -- DDR_CR29 = default
      DDR_CR30 := (RSYNCRF => True, others => <>);
      -- DDR_CR31 = default
      -- DDR_CR32 = default
      -- DDR_CR33 = default
      DDR_CR34 := (ODTRDC => ODTRDC_ACT, ODTWRCS => ODTWRCS_ACT, others => <>);
      -- DDR_CR35 = default
      -- DDR_CR36 = default
      DDR_CR37 := (R2WSAME => 2, others => <>);
      DDR_CR38 := (P0WRCNT => 32, others => <>);
      DDR_CR39 := (P0RDCNT => 32, RP0 => 1, WP0 => 1, others => <>);
      DDR_CR40 := (P0TYP => P0TYP_ASYNC, P1WRCNT => 32, others => <>);
      DDR_CR41 := (P1RDCNT => 32, RP1 => 1, WP1 => 1, others => <>);
      DDR_CR42 := (P1TYP => P1TYP_ASYNC, P2WRCNT => 32, others => <>);
      DDR_CR43 := (P2RDCNT => 32, RP2 => 1, WP2 => 1, others => <>);
      -- DDR_CR44 = default
      DDR_CR45 := (P0PRI0 => 3, P0PRI1 => 3, P0PRI2 => 3, P0PRI3 => 3, others => <>);
      DDR_CR46 := (P0ORD => 1, P0PRIRLX => 100, P1PRI0 => 2, others => <>);
      DDR_CR47 := (P1PRI1 => 2, P1PRI2 => 2, P1PRI3 => 2, P1ORD => 1, others => <>);
      DDR_CR48 := (P1PRIRLX => 100, P2PRI0 => 1, P2PRI1 => 1, others => <>);
      DDR_CR49 := (P2PRI2 => 1, P2PRI3 => 1, P2ORD => 2, others => <>);
      DDR_CR50 := (P2PRIRLX => 100, others => <>);
      -- DDR_CR51 = default
      DDR_CR52 := (PYWRLTBS => 2, PHYRDLAT => 6, RDDTENBAS => 2, others => <>);
      -- DDR_CR53 = default
      -- DDR_CR54 = default
      -- DDR_CR55 = default
      DDR_CR56 := (RDLATADJ => 3, WRLATADJ => 2, others => <>);
      DDR_CR57 := (ODTALTEN => True, others => <>);
      -- DDR_CR58 = default
      -- DDR_CR59 = default
      -- DDR_CR60 = default
      -- DDR_CR61 = default
      -- DDR_CR62 = default
      -- DDR_CR63 = default
   end Init;

end DDR;
