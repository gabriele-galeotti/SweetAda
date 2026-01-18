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
with RISCV;
with MTIME;
with NEORV32;
with ULX3S;
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

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop exit when not ULX3S.UART.TXFULL.txfull; end loop;
      ULX3S.UART.RXTX.rxtx := To_U8 (C);
      ULX3S.UART.EV_PENDING.rx := True;
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop exit when not ULX3S.UART.RXEMPTY.rxempty; end loop;
      Data := ULX3S.UART.RXTX.rxtx;
      C := To_Ch (Data);
      ULX3S.UART.EV_PENDING.tx := True;
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- UART -----------------------------------------------------------------
      pragma Warnings (Off);
      ULX3S.UART.EV_PENDING := ULX3S.UART.EV_PENDING;
      pragma Warnings (On);
      ULX3S.UART.EV_ENABLE := (
         tx     => True,
         rx     => True,
         others => <>
         );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("NEORV32 (Radiona ULX3S/LiteX)", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      Timer_Value := mtime_Read + Timer_Constant;
      mtimecmp_Write (Timer_Value);
      mie_Set_Interrupt ((MTIE => True, others => <>));
      Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
