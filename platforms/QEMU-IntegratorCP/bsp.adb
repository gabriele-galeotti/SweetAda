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
with Core;
with Bits;
with MMIO;
with Secondary_Stack;
with Exceptions;
with CPU;
with IntegratorCP;
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

   use System;
   use Interfaces;
   use Definitions;
   use Bits;
   use IntegratorCP;

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
      PL011.TX (PL011_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      PL011.RX (PL011_Descriptor, Data);
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
      -- PL011 UART0 ----------------------------------------------------------
      PL011_Descriptor := (
         Base_Address => System'To_Address (PL011_UART0_BASEADDRESS),
         Baud_Clock   => CLK_UART14M,
         Read_8       => MMIO.Read'Access,
         Write_8      => MMIO.Write'Access,
         Read_16      => MMIO.Read'Access,
         Write_16     => MMIO.Write'Access
         );
      PL011.Init (PL011_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Integrator/CP (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -- PL031 RTC ------------------------------------------------------------
      PL031_Descriptor := (
         Base_Address => System'To_Address (PL031_RTC_BASEADDRESS)
         );
      PL031.Init (PL031_Descriptor);
      -- PL110 LCD ------------------------------------------------------------
      PL110_Descriptor := (
         Base_Address => System'To_Address (PL110_BASEADDRESS)
         );
      PL110.Init (PL110_Descriptor);
      -- Timer ----------------------------------------------------------------
      -- Timer0 runs @ 40 MHz, prescale 16 = 2.5 MHz
      -- Timer1/2 run @ 1 MHz
      Timer (0).Load    := (Configure.TIMER0_CLK / 16) / Configure.TICK_FREQUENCY;
      Timer (0).Control := (
         ONESHOT    => False,
         TIMER_SIZE => TIMER_SIZE_32,
         PRESCALE   => PRESCALE_16,
         IE         => True,
         MODE       => MODE_PERIODIC,
         ENABLE     => True,
         others     => <>
         );
      PIC_IRQ_ENABLESET.TIMERINT0 := True;
      CPU.Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
