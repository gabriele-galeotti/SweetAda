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
with ARMv6M;
with KL46Z;
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

   use Interfaces;
   use Definitions;
   use Bits;
   use KL46Z;

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
      ARMv6M.SYST_RVR.RELOAD := Bits_24 (16#FFF#);
      ARMv6M.SHPR3.PRI_15 := 16#1#;
      ARMv6M.SYST_CVR.CURRENT := 0;
      ARMv6M.SYST_CSR := (
         ENABLE    => True,
         TICKINT   => True,
         CLKSOURCE => ARMv6M.CLKSOURCE_CPU,
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
      loop
         exit when UART0.S1.TDRE;
      end loop;
      UART0.D := To_U8 (C);
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
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      -- clock gating
      SIM_SCGC5 := (
         LPTMR  => False,
         TSI    => True,
         PORTA  => True,
         PORTB  => True,
         PORTC  => False,
         PORTD  => True,
         PORTE  => True,
         SLCD   => False,
         others => <>
         );
      -- clock selection
      SIM_SOPT2 := (
         RTCCLKOUTSEL => RTCCLKOUTSEL_OSCERCLK,
         CLKOUTSEL    => CLKOUTSEL_OSCERCLK,
         PLLFLLSEL    => PLLFLLSEL_MCGFLLCLKDIV2,
         USBSRC       => USBSRC_MCGxLL,
         TPMSRC       => TPMSRC_DISABLED,
         UART0SRC     => UART0SRC_OSCERCLK,
         others       => <>
         );
      -- UART0 ----------------------------------------------------------------
      SIM_SCGC4.UART0 := True;
      PORTA_PCR (1).MUX := MUX_ALT2;
      PORTA_PCR (2).MUX := MUX_ALT2;
      UART0.C4 := (
         OSR    => OSR_16x,
         M10    => False,
         MAEN2  => False,
         MAEN1  => False
         );
      UART0.BDL     := Unsigned_8 ((8 * MHz1 / 16) / 9_600);
      UART0.BDH.SBR := 0;
      UART0.C2.TE := True;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("FRDM-KL46Z", NL => True);
      -------------------------------------------------------------------------
      ARMv6M.Irq_Enable;
      -- ARMv6M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
