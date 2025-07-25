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
with Configure;
with Bits;
with ARMv7M;
with STM32F769I;
with Clocks;
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

   procedure SysTick_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (Clocks.CLK_Core / Configure.TICK_FREQUENCY);
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
      loop exit when USART1.USART_ISR.TXE; end loop;
      USART1.USART_TDR.DR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop exit when USART1.USART_ISR.RXNE; end loop;
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
      -- clock initialization -------------------------------------------------
      Clocks.Init;
      -- PWR ------------------------------------------------------------------
      RCC_APB1ENR.PWREN := True;
      RCC_APB1RSTR.PWRRST := True;
      RCC_APB1RSTR.PWRRST := False;
      -- GPIOA (USART1)
      RCC_AHB1ENR.GPIOAEN := True;
      RCC_AHB1RSTR.GPIOARST := True;
      RCC_AHB1RSTR.GPIOARST := False;
      -- USART1
      RCC_APB2ENR.USART1EN := True;
      RCC_APB2RSTR.USART1RST := True;
      RCC_APB2RSTR.USART1RST := False;
      -- USART1 ---------------------------------------------------------------
      -- USART1_TX PA9 (E15) Virtual COM port
      -- USART1_RX PA10 (D15) Virtual COM port
      RCC_DCKCFGR2.USART1SEL := USART1SEL_APB2;
      GPIOA.AFRH (9) := AF7;
      GPIOA.AFRH (10) := AF7;
      GPIOA.MODER (9) := GPIO_ALT;
      GPIOA.MODER (10) := GPIO_ALT;
      USART1.USART_CR1.UE := False;
      USART1.USART_BRR.BRR := Unsigned_16 (Clocks.CLK_Peripherals / 115_200);
      USART1.USART_CR1 := (
         RE     => True,
         TE     => True,
         PCE    => False,
         M0     => M_8N1.M0,
         M1     => M_8N1.M1,
         OVER8  => OVER8_16,
         others => <>
         );
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
      ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;
