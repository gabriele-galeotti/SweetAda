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

with Definitions;
with Bits;
with Exceptions;
with Secondary_Stack;
with CPU;
with MCF5206;
with SBC5206;
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
      SBC5206.TX (To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      SBC5206.RX (Data);
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
      -------------------------------------------------------------------------
      Exceptions.Init;
      SBC5206.Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Arnewsh SBC5206 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      MCF5206.TIMER1.TRR := 16#1000#;
      MCF5206.TIMER1.TMR := (
         RST => True,
         CLK => MCF5206.CLK_MSTCLK,
         FRR => MCF5206.FRR_RESTART,
         ORI => True,
         OM  => MCF5206.OM_TOGGLE,
         CE  => MCF5206.CE_ANYEDGE,
         PS  => 16
         );
      MCF5206.TIMER1.TER := (
         CAP    => False,
         REF    => True,
         others => <>
         );
      MCF5206.IMR.TIMER1 := False;
      MCF5206.ICR9 := (
         IP     => 2,
         IL     => 2,
         AVEC   => True,
         others => <>
         );
      CPU.Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
