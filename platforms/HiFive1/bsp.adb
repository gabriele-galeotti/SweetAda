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

with Bits;
with CPU;
with RISCV;
with MTIME;
with HiFive1;
with Exceptions;
with Clocks;
with QSPI;
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
   use Bits;
   use RISCV;
   use MTIME;
   use HiFive1;

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
      use UART;
   begin
      -- wait for transmitter available
      loop exit when not UART0.txdata.full; end loop;
      UART0.txdata.txdata := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      use UART;
      rxdata : rxdata_Type;
   begin
      -- wait for receiver available
      loop
         rxdata := UART0.rxdata;
         exit when not rxdata.empty;
      end loop;
      C := To_Ch (rxdata.rxdata);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      use GPIO;
      use UART;
   begin
      -- Clock setup ----------------------------------------------------------
      Clocks.Init;
      -- Initialize GPIO, enable UARTs ----------------------------------------
      -- 16 -> UART0_RX, 17 -> UART0_TX, 18 -> UART1_TX, 23 -> UART1_RX
      iof_sel   := [16 | 17 | 18 | 23 => False, others => <>];
      iof_en    := [16 | 17 | 18 | 23 => True, others => <>];
      output_en := [16 | 17 | 18 | 23 => True, others => <>];
      -- UART0 ----------------------------------------------------------------
      -- UART0.div.div := 16#008A#; -- 115200 bps @ 16 MHz
      -- UART0.div.div := 16#0115#; -- 115200 bps @ 32 MHz
      UART0.div.div := 16#022B#; -- 115200 bps @ 64 MHz
      UART0.txctrl  := (txen => True, nstop => 1, txcnt => 1, others => <>);
      UART0.rxctrl  := (rxen => True, rxcnt => 0, others => <>);
      -- UART1 ----------------------------------------------------------------
      -- UART1.div.div := 16#008A#; -- 115200 bps @ 16 MHz
      -- UART1.div.div := 16#0115#; -- 115200 bps @ 32 MHz
      UART1.div.div := 16#022B#; -- 115200 bps @ 64 MHz
      UART1.txctrl  := (txen => True, nstop => 1, txcnt => 1, others => <>);
      UART1.rxctrl  := (rxen => True, rxcnt => 0, others => <>);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("SiFive HiFive 1", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      Timer_Value := mtime_Read + Timer_Constant;
      mtimecmp_Write (Timer_Value);
      mie_Set_Interrupt ((MTIE => True, others => <>));
      Irq_Enable;
      -------------------------------------------------------------------------
      QSPI.Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
