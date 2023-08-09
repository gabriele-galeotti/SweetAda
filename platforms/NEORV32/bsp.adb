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

with Bits;
with CPU;
with RISCV;
with MTIME;
with NEORV32;
with Exceptions;
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
   use Bits;
   use RISCV;
   use MTIME;
   use NEORV32;

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
      -- wait for transmitter available
      loop
         exit when not UART0.CTRL.TX_FULL;
      end loop;
      UART0.DATA.RTX := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := To_Ch (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -- UART0 ----------------------------------------------------------------
      UART0.CTRL := (
         EN            => True,
         SIM_MODE      => True,
         HWFC_EN       => True,
         PRSC          => 2#1#,
         BAUD          => 1,
         RX_NEMPTY     => False,
         RX_HALF       => False,
         RX_FULL       => False,
         TX_EMPTY      => False,
         TX_NHALF      => False,
         TX_FULL       => False,
         IRQ_RX_NEMPTY => False,
         IRQ_RX_HALF   => False,
         IRQ_RX_FULL   => False,
         IRQ_TX_EMPTY  => False,
         IRQ_TX_NHALF  => False,
         RX_OVER       => False,
         TX_BUSY       => False,
         others        => <>
         );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      -- Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("*** Hello SweetAda on NEORV32!", NL => True);
      -------------------------------------------------------------------------
   end Setup;

end BSP;
