-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with Configure;
with Bits;
with CPU;
with ARMv7M;
with K61;
with Clocks;
with DDR;
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
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (Clocks.CLK_Core / Configure.TICK_FREQUENCY);
      ARMv7M.SHPR3.PRI_15 := 16#FF#;
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
      loop exit when UART5.S1.TDRE; end loop;
      UART5.D.RT := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      -- wait for receiver available
      loop exit when UART5.S1.RDRF; end loop;
      C := To_Ch (UART5.D.RT);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Clocks.Init;
      -- PORTx clock gate control ---------------------------------------------
      SIM_SCGC5.PORTE := True;
      SIM_SCGC5.PORTF := True;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- UART5 ----------------------------------------------------------------
      SIM_SCGC1.UART5 := True;
      PORTE_MUXCTRL.PCR (8).MUX := MUX_ALT3;
      PORTE_MUXCTRL.PCR (9).MUX := MUX_ALT3;
      UART5.C4 := (BRFA => 0, M10 => False, MAEN2 => False, MAEN1 => False);
      UART5.BDL.SBR := Bits_8 ((Clocks.CLK_Peripherals / 16) / 115_200);
      UART5.BDH.SBR := 0;
      UART5.C2.TE := True;
      UART5.C2.RE := True;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Kinetis K61", NL => True);
      -------------------------------------------------------------------------
      DDR.Init;
      -------------------------------------------------------------------------
      ARMv7M.Irq_Enable;
      ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
