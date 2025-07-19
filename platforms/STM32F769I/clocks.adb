-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ clocks.adb                                                                                                --
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
with STM32F769I;
with BSP;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Definitions;
   use Bits;
   use STM32F769I;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- Starting form an unknown status:
   -- 1) activate the default HSI clock
   -- 2) when running in HSI, program either:
   --    a) PLL running out of HSI
   --    b) PLL running out of HSE
   -- 3) switch to PLL
   ----------------------------------------------------------------------------
   procedure Init
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
         SW     => SW_PLL,     -- SYSCLK = PLL
         HPRE   => HPRE_NODIV, -- AHB prescaler
         PPRE1  => PPRE_DIV4,  -- APB Low-speed prescaler (APB1)
         PPRE2  => PPRE_DIV2,  -- APB high-speed prescaler (APB2)
         others => <>
         );
   end Init;

end Clocks;
