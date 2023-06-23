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

with System;
with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Interfaces;
with Configure;
with Definitions;
with Core;
with Bits;
with MMIO;
with Exceptions;
with ARMv4;
with CPU;
with IntegratorCP;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use IntegratorCP;

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
      PL011.TX (PL011_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      PL011.RX (PL011_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- PL011 UART0 ----------------------------------------------------------
      PL011_Descriptor.Base_Address := To_Address (PL011_UART0_BASEADDRESS);
      PL011_Descriptor.Baud_Clock   := CLK_UART14M;
      PL011_Descriptor.Read_8       := MMIO.Read'Access;
      PL011_Descriptor.Write_8      := MMIO.Write'Access;
      PL011_Descriptor.Read_16      := MMIO.Read'Access;
      PL011_Descriptor.Write_16     := MMIO.Write'Access;
      PL011.Init (PL011_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Integrator/CP (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -- PL110 LCD ------------------------------------------------------------
      PL110_Descriptor.Base_Address := To_Address (PL110_BASEADDRESS);
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
      -- PIC_FIQ_ENABLESET.TIMERINT0 := True;
      -- ARMv4.Fiq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
