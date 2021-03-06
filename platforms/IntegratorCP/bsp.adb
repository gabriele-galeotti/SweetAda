-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with Exceptions;
with ARM;
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
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- PL011 UART0 ----------------------------------------------------------
      PL011_Descriptor.Base_Address := To_Address (PL011_UART0_BASEADDRESS);
      PL011_Descriptor.Baud_Clock   := 14_745_600;
      PL011_Descriptor.Read_8       := MMIO.Read'Access;
      PL011_Descriptor.Write_8      := MMIO.Write'Access;
      PL011_Descriptor.Read_16      := MMIO.Read'Access;
      PL011_Descriptor.Write_16     := MMIO.Write'Access;
      PL011.Init (PL011_Descriptor);
      -- PL110 LCD ------------------------------------------------------------
      PL110_Descriptor.Base_Address := To_Address (PL110_BASEADDRESS);
      PL110.Init (PL110_Descriptor);
      PL110.Print (0, 0, "hello SweetAda ...");
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Integrator/CP (QEMU emulator)", NL => True);
      -- Timer ----------------------------------------------------------------
      -- Timer0 runs @ 40 MHz
      -- Timer1/2 run @ 1 MHz
      Timer (0).Load    := 16#0020_0000#; -- Timer1/2: 16#0001_0000#;
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
      ARM.Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
