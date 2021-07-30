-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ piix.ads                                                                                                  --
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

with PCI;

package PIIX is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use PCI;

   ----------------------------------------------------------------------------
   -- function 0: PCI-to-ISA Bridge
   ----------------------------------------------------------------------------

   XBCS     : constant := 16#4E#;
   PIRQRCA  : constant := 16#60#;
   PIRQRCB  : constant := 16#61#;
   PIRQRCC  : constant := 16#62#;
   PIRQRCD  : constant := 16#63#;
   TOM      : constant := 16#69#;
   MBIRQ0   : constant := 16#70#; -- Motherboard IRQ Route Control 0 R/W
   MBIRQ1   : constant := 16#71#; -- Motherboard IRQ Route Control 1 (PIIX3) R/W
   APICBASE : constant := 16#80#; -- PIIX3

   ----------------------------------------------------------------------------
   -- function 1: IDE Interface
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- function 2: Universal Serial Bus Interface (PIIX3 only)
   ----------------------------------------------------------------------------

   BASEADD : constant := 16#20#; -- IO Space Base Address R/W

   ----------------------------------------------------------------------------
   -- Subprograms
   ----------------------------------------------------------------------------

   function Probe return Boolean;
   procedure Init;
   procedure Interrupt_Set;

end PIIX;
