-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Parameters;
with System.Secondary_Stack;
with Definitions;
with Bits;
with Core;
with Exceptions;
with CPU;
with ZynqA9;
with Console;

package body BSP is

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

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr with
      Export        => True,
      Convention    => C,
      External_Name => "__gnat_get_secondary_stack";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      UART_TX (To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART_RX (Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -- basic hardware initialization ----------------------------------------
      ZynqA9.SLCR.SLCR_UNLOCK.UNLOCK_KEY := UNLOCK_KEY_VALUE;
      ZynqA9.SLCR.SCL.LOCK := False;
      Exceptions.Init;
      UART_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Zynq7000 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -- GIC ------------------------------------------------------------------
      ZynqA9.APU.ICCICR :=
         (EnableS  => False,
          EnableNS => False,
          AckCtl   => False,
          FIQEn    => False,
          SBPR     => False,
          others   => <>);
      ZynqA9.APU.ICDISR0 := [others => True];
      ZynqA9.APU.ICDISR1 := [others => True];
      ZynqA9.APU.ICDISR2 := [others => True];
      ZynqA9.APU.ICDISER0 := [others => True];
      ZynqA9.APU.ICDISER1 := [others => True];
      ZynqA9.APU.ICDISER2 := [others => True];
      ZynqA9.APU.ICDIPTR (8)  := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (9)  := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (10) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (11) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (12) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (13) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (14) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (15) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (16) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (17) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (18) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (19) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (20) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (21) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (22) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICDIPTR (23) := [others => ICDIPTR_CPU0];
      ZynqA9.APU.ICCPMR.Priority := 16#FF#;
      ZynqA9.APU.ICCICR :=
         (EnableS  => True,
          EnableNS => True,
          AckCtl   => True,
          FIQEn    => False,
          SBPR     => False,
          others   => <>);
      ZynqA9.APU.ICDDCR :=
         (Enable_secure     => True,
          Enable_Non_secure => True,
          others            => <>);
      -- ttc timer ------------------------------------------------------------
      TTC0.CNT_CNTRL (0) :=
         (DIS      => False,
          INT      => INT_OVERFLOW,
          DECR     => True,
          MATCH    => False,
          RST      => False,
          EN_WAVE  => False,
          POL_WAVE => POL_WAVE_L2H,
          others   => <>);
      TTC0.INTERVAL_VAL (0).COUNT_VALUE := 16#8000#;
      TTC0.CLK_CNTRL (0) :=
         (PS_EN    => True,
          PS_VAL   => 8,
          SRC      => SRC_PCLK,
          EXT_EDGE => False,
          others   => <>);
      -------------------------------------------------------------------------
   end Setup;

end BSP;
