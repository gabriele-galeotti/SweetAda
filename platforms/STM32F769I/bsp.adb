-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Definitions;
with Configure;
with Bits;
with ARMv7M;
with STM32F769I;
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
   use STM32F769I;

   procedure CLK_Init;
   procedure SysTick_Init;

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
   -- Starting form an unknown status:
   -- 1) activate the default HSI clock
   -- 2) when running in HSI, program either:
   --    a) PLL running out of HSI
   --    b) PLL running out of HSE
   -- 3) switch to PLL
   ----------------------------------------------------------------------------
   procedure CLK_Init
      is
      -- HSI, PLL, 192 MHz
      HSI192 : constant RCC_PLLCFGR_Type :=
         (PLLM => 8, PLLN => 192, PLLP => PLLP_DIV2, PLLSRC => PLLSRC_HSI, PLLQ => 4, PLLR => 2, others => <>);
      -- HSE, PLL, 200 MHz @ 25 MHz external clock
      HSE200 : constant RCC_PLLCFGR_Type :=
         (PLLM => 16, PLLN => 256, PLLP => PLLP_DIV2, PLLSRC => PLLSRC_HSE, PLLQ => 4, PLLR => 2, others => <>);
      -- use HSI192 or HSE200
      -- Clk    : constant RCC_PLLCFGR_Type := HSI192;
      Clk    : constant RCC_PLLCFGR_Type := HSE200;
   begin
      -- activate HSI
      RCC_CR.HSION := True;
      loop exit when RCC_CR.HSIRDY; end loop;
      RCC_CFGR.SW := SW_HSI;
      -- PLL disable
      RCC_CR.PLLON := False;
      -- HSE requires setup
      if Clk.PLLSRC = PLLSRC_HSE then
         RCC_CR.HSEON := True;
         loop exit when RCC_CR.HSERDY; end loop;
      end if;
      -- setup PLL parameters
      RCC_PLLCFGR := Clk;
      -- PLL enable
      RCC_CR.PLLON := True;
      loop exit when RCC_CR.PLLRDY; end loop;
      -- configure main clocks
      RCC_CFGR := (
         SW     => SW_PLL,    -- SYSCLK = PLL
         HPRE   => HPRE_NONE, -- AHB prescaler
         PPRE1  => PPRE_DIV4, -- APB Low-speed prescaler (APB1)
         PPRE2  => PPRE_DIV2, -- APB high-speed prescaler (APB2)
         others => <>
         );
   end CLK_Init;

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (Configure.SYSCLK_FREQUENCY / Configure.TICK_FREQUENCY);
      ARMv7M.SHPR3.PRI_15 := 16#FF#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR := (
         ENABLE    => True,
         TICKINT   => True,
         CLKSOURCE => ARMv7M.CLKSOURCE_CPU,
         COUNTFLAG => False,
         others    => <>
         );
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when USART1.USART_ISR.TXE;
      end loop;
      USART1.USART_TDR.DR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when USART1.USART_ISR.RXNE;
      end loop;
      Data := USART1.USART_TDR.DR;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- PWR ------------------------------------------------------------------
      RCC_APB1ENR.PWREN := True;
      RCC_APB1RSTR.PWRRST := True;
      RCC_APB1RSTR.PWRRST := False;
      -- CLK ------------------------------------------------------------------
      CLK_Init;
      -- USART1 ---------------------------------------------------------------
      -- USART1_TX PA9 (E15) Virtual COM port
      -- USART1_RX PA10 (D15) Virtual COM port
      RCC_DCKCFGR2.USART1SEL := USART1SEL_APB2;
      RCC_APB2ENR.USART1EN := True;
      GPIOA.AFRH (9) := AF7;
      GPIOA.AFRH (10) := AF7;
      GPIOA.MODER (9) := GPIO_ALT;
      GPIOA.MODER (10) := GPIO_ALT;
      USART1.USART_CR1.UE := False;
      -- USART1.USART_BRR.BRR := Unsigned_16 (96 * MHz1 / 115_200); -- assume HSI192, fck = 96 MHz, 115200 baud
      USART1.USART_BRR.BRR := Unsigned_16 (100 * MHz1 / 115_200); -- assume HSE200, fck = 100 MHz, 115200 baud
      USART1.USART_CR1.TE := True;
      USART1.USART_CR1.UE := True;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("STM32F769I", NL => True);
      -------------------------------------------------------------------------
      ARMv7M.Irq_Enable;
      -- ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
