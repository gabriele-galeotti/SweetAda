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

   -- HSI, PLL, 192 MHz
   RCCPLL_HSI192 : constant RCC_PLLCFGR_Type := (
      PLLM   => 8,
      PLLN   => 192,
      PLLP   => PLLP_DIV2,
      PLLSRC => PLLSRC_HSI,
      PLLQ   => 4,
      PLLR   => 2,
      others => <>
      );
   -- HSE, PLL, 200 MHz @ 25 MHz external clock
   RCCPLL_HSE200 : constant RCC_PLLCFGR_Type := (
      PLLM   => 16,
      PLLN   => 256,
      PLLP   => PLLP_DIV2,
      PLLSRC => PLLSRC_HSE,
      PLLQ   => 4,
      PLLR   => 2,
      others => <>
      );

   type Clock_Type is (HSI192, HSE200);

   -- Clock : constant Clock_Type := HSI192;
   Clock : constant Clock_Type := HSE200;

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
   begin
      -- activate HSI
      RCC_CR.HSION := True;
      loop exit when RCC_CR.HSIRDY; end loop;
      RCC_CFGR.SW := SW_HSI;
      -- PLL disable
      RCC_CR.PLLON := False;
      -- setup PLL parameters
      case Clock is
         when HSI192 =>
            RCC_PLLCFGR := RCCPLL_HSI192;
         when HSE200 =>
            -- HSE requires setup
            RCC_CR.HSEON := True;
            loop exit when RCC_CR.HSERDY; end loop;
            RCC_PLLCFGR := RCCPLL_HSE200;
      end case;
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
      case Clock is
         when HSI192 => CLK_Core := 192 * MHz1;
         when HSE200 => CLK_Core := 200 * MHz1;
      end case;
      CLK_Peripherals := CLK_Core / 2;
   end Init;

end Clocks;
