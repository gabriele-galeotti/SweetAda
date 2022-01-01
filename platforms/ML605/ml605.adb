-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ml605.adb                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package body ML605 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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
   procedure Tclk_Init is
   begin
      Timer.TLR0        := 16#FC00_0000#;
      Timer.TCSR0.PWMA0 := 0;
      Timer.TCSR0.ENIT0 := 1;
      Timer.TCSR0.ARHT0 := 1;
      Timer.TCSR0.CAPT0 := 0;
      Timer.TCSR0.GENT0 := 0;
      Timer.TCSR0.UDT0  := 0;
      Timer.TCSR0.MDT0  := 0;
      -- initial loading
      Timer.TCSR0.LOAD0 := 1;
      Timer.TCSR0.LOAD0 := 0;
      -- enable
      Timer.TCSR0.ENT0  := 1;
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- INTC_Init
   ----------------------------------------------------------------------------
   procedure INTC_Init is
   begin
      INTC.ISR     := 0;
      INTC.IPR     := 0;
      INTC.IER     := TIMER_IRQ;
      INTC.IAR     := 0;
      INTC.SIE     := 0;
      INTC.CIE     := 0;
      INTC.IVR     := 0;
      INTC.MER.HIE := 1;
      INTC.MER.ME  := 1;
   end INTC_Init;

end ML605;
