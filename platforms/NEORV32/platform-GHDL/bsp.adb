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
      loop exit when UART0.CTRL.UART_CTRL_TX_EMPTY; end loop;
      UART0.DATA.UART_DATA_RTX := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop exit when UART0.CTRL.UART_CTRL_RX_NEMPTY; end loop;
      Data := UART0.DATA.UART_DATA_RTX;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- UART0 ----------------------------------------------------------------
      UART0.CTRL := (
         UART_CTRL_EN            => True,
         UART_CTRL_SIM_MODE      => True,
         UART_CTRL_HWFC_EN       => True,
         UART_CTRL_PRSC          => 2#1#,
         UART_CTRL_BAUD          => 1,
         UART_CTRL_RX_NEMPTY     => False,
         UART_CTRL_RX_HALF       => False,
         UART_CTRL_RX_FULL       => False,
         UART_CTRL_TX_EMPTY      => False,
         UART_CTRL_TX_NHALF      => False,
         UART_CTRL_TX_NFULL      => False,
         UART_CTRL_IRQ_RX_NEMPTY => False,
         UART_CTRL_IRQ_RX_HALF   => False,
         UART_CTRL_IRQ_RX_FULL   => False,
         UART_CTRL_IRQ_TX_EMPTY  => False,
         UART_CTRL_IRQ_TX_NHALF  => False,
         UART_CTRL_RX_OVER       => False,
         UART_CTRL_TX_BUSY       => False,
         others                  => <>
         );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("NEORV32 1.11.8", NL => True);
      Console.Print (
         Prefix => "number of harts:                 ",
         Value  => Natural (SYSINFO.MEM.SYSINFO_MISC_HART),
         NL     => True
         );
      Console.Print (
         Prefix => "i-cache block size in bytes:     ",
         Value  => Integer (2**Natural (SYSINFO.CACHE.SYSINFO_CACHE_INST_BLOCK_SIZE)),
         NL     => True
         );
      Console.Print (
         Prefix => "i-cache number of cache blocks:  ",
         Value  => Integer (2**Natural (SYSINFO.CACHE.SYSINFO_CACHE_INST_NUM_BLOCKS)),
         NL     => True
         );
      Console.Print (
         Prefix => "i-cache burst transfers enabled: ",
         Value  => SYSINFO.CACHE.SYSINFO_CACHE_INST_BURSTS_EN,
         NL     => True
         );
      Console.Print (
         Prefix => "d-cache block size in bytes:     ",
         Value  => Integer (2**Natural (SYSINFO.CACHE.SYSINFO_CACHE_DATA_BLOCK_SIZE)),
         NL     => True
         );
      Console.Print (
         Prefix => "d-cache number of cache blocks:  ",
         Value  => Integer (2**Natural (SYSINFO.CACHE.SYSINFO_CACHE_DATA_NUM_BLOCKS)),
         NL     => True
         );
      Console.Print (
         Prefix => "d-cache burst transfers enabled: ",
         Value  => SYSINFO.CACHE.SYSINFO_CACHE_DATA_BURSTS_EN,
         NL     => True
         );
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
