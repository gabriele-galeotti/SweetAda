-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ switches.adb                                                                                              --
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
with KL46Z;

package body Switches
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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
   -- SW1_Read
   ----------------------------------------------------------------------------
   function SW1_Read
      return Boolean
      is
   begin
      return GPIOC.PDIR (3);
   end SW1_Read;

   ----------------------------------------------------------------------------
   -- SW3_Read
   ----------------------------------------------------------------------------
   function SW3_Read
      return Boolean
      is
   begin
      return GPIOC.PDIR (12);
   end SW3_Read;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- port multiplexing control
      -- PTC3  = SW1
      -- PTC12 = SW3
      PORTC_MUXCTRL.PCR (3) := (
         PS     => PS_PULLUP,
         PE     => True,
         MUX    => MUX_GPIO,
         others => <>
         );
      PORTC_MUXCTRL.PCR (12) := (
         PS     => PS_PULLUP,
         PE     => True,
         MUX    => MUX_GPIO,
         others => <>
         );
      -- set switches as GPIO inputs
      GPIOC.PDDR (3)  := False;
      GPIOC.PDDR (12) := False;
   end Init;

end Switches;
