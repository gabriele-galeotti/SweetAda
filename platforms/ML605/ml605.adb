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
   -- Timers run @ 100 MHz.
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
   begin
      Timer.TLR0 := 16#05F5_E100#;
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
