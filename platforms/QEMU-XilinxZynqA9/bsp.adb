-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with Configure;
with Definitions;
with Bits;
with Core;
with Secondary_Stack;
with Exceptions;
with CPU;
with ZynqA9;
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
   use ZynqA9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      UART_TX (To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      UART_RX (Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -- basic hardware initialization ----------------------------------------
      slcr.SLCR_UNLOCK.UNLOCK_KEY := UNLOCK_KEY_VALUE;
      slcr.SCL.LOCK := False;
      Exceptions.Init;
      UART_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Zynq7000 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -- GIC ------------------------------------------------------------------
      mpcore.ICCICR := (
         EnableS  => False,
         EnableNS => False,
         AckCtl   => False,
         FIQEn    => False,
         SBPR     => False,
         others   => <>
         );
      mpcore.ICDISR0 := [others => True];
      mpcore.ICDISR1 := [others => True];
      mpcore.ICDISR2 := [others => True];
      mpcore.ICDISER0 := [others => True];
      mpcore.ICDISER1 := [others => True];
      mpcore.ICDISER2 := [others => True];
      for Idx in 8 .. 23 loop
         mpcore.ICDIPTR (Idx) := [others => ICDIPTR_CPU0];
      end loop;
      mpcore.ICCPMR.Priority := 16#FF#;
      mpcore.ICCICR := (
         EnableS  => True,
         EnableNS => True,
         AckCtl   => True,
         FIQEn    => False,
         SBPR     => False,
         others   => <>
         );
      mpcore.ICDDCR := (
         Enable_secure     => True,
         Enable_Non_secure => True,
         others            => <>
         );
      -------------------------------------------------------------------------
      CPU.Irq_Enable;
      -- ttc timer ------------------------------------------------------------
      ttc0.CNT_CNTRL (0) := (
         DIS      => False,
         INT      => INT_OVERFLOW,
         DECR     => True,
         MATCH    => False,
         RST      => False,
         EN_WAVE  => False,
         POL_WAVE => POL_WAVE_L2H,
         others   => <>
         );
      ttc0.INTERVAL_VAL (0).COUNT_VALUE :=
         Unsigned_16 (Configure.CLK_FREQUENCY / Configure.TICK_FREQUENCY);
      ttc0.CLK_CNTRL (0) := (
         PS_EN    => True,
         PS_VAL   => 1,
         SRC      => SRC_PCLK,
         EXT_EDGE => False,
         others   => <>
         );
      ttc0.IER (0).IXR_CNT_OVR_IEN := True;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
