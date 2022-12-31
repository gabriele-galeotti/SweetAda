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
with CPU;
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
   use HiFive1;

   procedure CLK_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CLK_Init
   ----------------------------------------------------------------------------
   procedure CLK_Init is
   begin
      -- external clock frequency = 16 MHz, output 128 MHz
      PRCI.plloutdiv := (
                         plloutdivby1 => plloutdivby1_SET, -- PLL Final Divide By 1
                         others       => <>
                        );
      PRCI.pllcfg := (
                      pllr      => pllr_div2,        -- divide by 2, PLL drive = 8 MHz
                      pllf      => pllf_x64,         -- x64 multiply factor = 512 MHz
                      pllq      => pllq_div4,        -- divide by 4 = 128 MHz
                      pllsel    => pllsel_PLL,
                      pllrefsel => pllrefsel_HFXOSC, -- PLL driven by external clock
                      pllbypass => False,            -- enable PLL
                      others    => <>
                     );
      -- wait for PLL to settle down
      loop
         for Delay_Loop_Count in 1 .. 10_000_000 loop CPU.NOP; end loop;
         exit when PRCI.pllcfg.plllock;
      end loop;
   end CLK_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      -- wait for transmitter available
      loop
         exit when not UART0.txdata.full;
      end loop;
      UART0.txdata.txdata := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when not UART0.rxdata.empty;
      end loop;
      Data := UART0.rxdata.rxdata;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- CLK ------------------------------------------------------------------
      CLK_Init;
      -- UARTs ----------------------------------------------------------------
      GPIO_IOFSEL := GPIO_IOFSEL and 16#FF78_FFFF#;
      GPIO_IOFEN  := GPIO_IOFEN or 16#0087_0000#;
      GPIO_OEN    := GPIO_OEN or 16#0087_0000#;
      -- UART0.div.div := 16#008A#; -- 115200 bps @ 16 MHz
      UART0.div.div := 16#0456#; -- 115200 bps @ 128 MHz
      UART0.txctrl  := (txen => True, nstop => 1, txcnt => 1, others => <>);
      UART0.rxctrl  := (rxen => True, rxcnt => 1, others => <>);
      -- UART1.div.div := 16#008A#; -- 115200 bps @ 16 MHz
      UART1.div.div := 16#0456#; -- 115200 bps @ 128 MHz
      UART1.txctrl  := (txen => True, nstop => 1, txcnt => 1, others => <>);
      UART1.rxctrl  := (rxen => True, rxcnt => 1, others => <>);
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
