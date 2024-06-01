-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ml605.adb                                                                                                 --
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

with Definitions;

package body ML605
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Definitions;

   -- Timers run @ 100 MHz
   TIMER_CLK : constant := 100 * MHz1;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init
      is
   begin
      Timer.TLR0 := TIMER_CLK / 1_000;
      Timer.TCSR0 := (
         ENALL  => False,
         PWMA0  => False,
         T0INT  => False,
         ENT0   => False,
         ENIT0  => True,
         LOAD0  => False,
         ARHT0  => True,
         CAPT0  => False,
         GENT0  => False,
         UDT0   => UDT0_DOWN,
         MDT0   => MDT0_GEN,
         others => 0
         );
      -- initial loading
      Timer.TCSR0.LOAD0 := True;
      Timer.TCSR0.LOAD0 := False;
      -- enable
      Timer.TCSR0.ENT0  := True;
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- INTC_Init
   ----------------------------------------------------------------------------
   procedure INTC_Init
      is
   begin
      INTC.ISR := [others => False];
      INTC.IPR := [others => False];
      INTC.IER := [others => False];
      INTC.IAR := [others => False];
      INTC.SIE := [others => False];
      INTC.CIE := [others => False];
      INTC.IVR := 0;
      INTC.MER := (
         HIE    => True,
         ME     => True,
         others => 0
         );
   end INTC_Init;

end ML605;
