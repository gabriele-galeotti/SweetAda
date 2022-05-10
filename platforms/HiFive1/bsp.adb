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

with Interfaces;
with Bits;
with RISCV;
with HiFive1;
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
         exit when not HiFive1.UART0.txdata.full;
      end loop;
      HiFive1.UART0.txdata.txdata := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when not HiFive1.UART0.rxdata.empty;
      end loop;
      Data := HiFive1.UART0.rxdata.rxdata;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- Clock ----------------------------------------------------------------
      HiFive1.PRCI.pllcfg    := (
                                 pllr      => 0,
                                 pllf      => 0,
                                 pllq      => 0,
                                 pllsel    => True,
                                 pllrefsel => True,
                                 pllbypass => True,
                                 others    => <>
                                );
      HiFive1.PRCI.hfrosccfg := (
                                 hfroscdiv  => 4,
                                 hfrosctrim => 16#10#,
                                 hfroscen   => False,
                                 others     => <>
                                );
      -- UARTs ----------------------------------------------------------------
      HiFive1.GPIO_IOFSEL := @ and 16#FF78_FFFF#;
      HiFive1.GPIO_IOFEN  := @ or 16#0087_0000#;
      HiFive1.GPIO_OEN    := @ or 16#0087_0000#;
      HiFive1.UART0.div          := 16#89#; -- 115200 bps @ 16 MHz
      HiFive1.UART0.txctrl.txen  := True;
      -- HiFive1.UART0.txctrl.nstop := 0;
      -- HiFive1.UART0.txctrl.txcnt := 0;
      HiFive1.UART0.rxctrl.rxen  := True;
      -- HiFive1.UART0.rxctrl.rxcnt := 0;
      HiFive1.UART1.div          := 16#89#; -- 115200 bps @ 16 MHz
      HiFive1.UART1.txctrl.txen  := True;
      -- HiFive1.UART1.txctrl.nstop := 0;
      -- HiFive1.UART1.txctrl.txcnt := 0;
      HiFive1.UART1.rxctrl.rxen  := True;
      -- HiFive1.UART1.rxctrl.rxcnt := 0;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("SiFive HiFive 1", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      RISCV.Irq_Enable;
      RISCV.MTimeCmp := RISCV.MTime + 16#3200#;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
