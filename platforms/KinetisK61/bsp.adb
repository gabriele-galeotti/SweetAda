-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with Bits;
with CPU;
with ARMv7M;
with K61;
with Exceptions;
with Console;

package body BSP
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
   use K61;

   procedure SysTick_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      -- The LED is toggled every 1000 ticks, so that in 2000 ticks a complete
      -- 1s-cycle can be observed @ 24 MHz CPU clock (MCLK)
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (24_000_000 / 2_000);
      ARMv7M.SHPR3.PRI_15 := 16#01#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR := (
         ENABLE    => True,
         TICKINT   => True,
         CLKSOURCE => ARMv7M.CLKSOURCE_CPU,
         COUNTFLAG => False,
         others    => <>
         );
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      null;
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      Delay_Count : constant := 500_000;
   begin
      -- WDOG -----------------------------------------------------------------
      WDOG_UNLOCK := 16#C520#;
      WDOG_UNLOCK := 16#D928#;
      WDOG_STCTRLH.WDOGEN := False;
      -------------------------------------------------------------------------
      SIM_SCGC5.PORTF := True; -- PORTF clock gate control
      PORTF_PCR.Pins (12).MUX := 1;
      GPIOF.GPIO_PDDR (12) := True;
      loop
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         GPIOF.GPIO_PSOR (12) := True;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         GPIOF.GPIO_PCOR (12) := True;
      end loop;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
