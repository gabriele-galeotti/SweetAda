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
      -- external clock frequency = 16 MHz
      PRCI.plloutdiv := (
                         plloutdivby1 => plloutdivby1_SET, -- PLL Final Divide By 1
                         others       => <>
                        );
      PRCI.pllcfg := (
                      pllr      => pllr_div2,        -- divide by 2, PLL drive = 8 MHz
                      -- pllf      => pllf_x8,          -- x8 multiply factor = 64 MHz --> 16 MHz
                      -- pllf      => pllf_x16,         -- x16 multiply factor = 128 MHz --> 32 MHz
                      pllf      => pllf_x32,         -- x32 multiply factor = 256 MHz --> 64 MHz
                      pllq      => pllq_div4,        -- divide by 4
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
         exit when UART0.ip.txwm;
      end loop;
      UART0.txdata.txdata := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when UART0.ip.rxwm;
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
      -- Initialize GPIO, enable UARTs ----------------------------------------
      -- 16 -> UART0_RX, 17 -> UART0_TX, 18 -> UART1_TX, 23 -> UART1_RX
      GPIO_IOFSEL := [16 | 17 | 18 | 23 => False, others => <>];
      GPIO_IOFEN  := [16 | 17 | 18 | 23 => True, others => <>];
      GPIO_OEN    := [16 | 17 | 18 | 23 => True, others => <>];
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
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("SiFive HiFive 1", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      RISCV.MTIMECMP_Write (RISCV.MTIME_Read + MTIME_Offset);
      RISCV.Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
