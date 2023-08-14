-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32f769i.ads                                                                                            --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package STM32F769I is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Warnings (Off);

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- 4 Power controller (PWR)
   ----------------------------------------------------------------------------

   -- 4.4.1 PWR power control register (PWR_CR1)

   PLS_2V0 : constant := 2#000#; -- 2.0 V
   PLS_2V1 : constant := 2#001#; -- 2.1 V
   PLS_2V3 : constant := 2#010#; -- 2.3 V
   PLS_2V5 : constant := 2#011#; -- 2.5 V
   PLS_2V6 : constant := 2#100#; -- 2.6 V
   PLS_2V7 : constant := 2#101#; -- 2.7 V
   PLS_2V8 : constant := 2#110#; -- 2.8 V
   PLS_2V9 : constant := 2#111#; -- 2.9 V

   VOS_RESERVED : constant := 2#00#; -- Reserved (Scale 3 mode selected)
   VOS_SCALE3   : constant := 2#01#; -- Scale 3 mode
   VOS_SCALE2   : constant := 2#10#; -- Scale 2 mode
   VOS_SCALE1   : constant := 2#11#; -- Scale 1 mode (reset value)

   UDEN_DISABLE   : constant := 2#00#; -- Under-drive disable
   UDEN_RESERVED1 : constant := 2#01#; -- Reserved
   UDEN_RESERVED2 : constant := 2#10#; -- Reserved
   UDEN_ENABLE    : constant := 2#11#; -- Under-drive enable

   type PWR_CR1_Type is
   record
      LPDS      : Boolean; -- Low-power deepsleep
      PDDS      : Boolean; -- Power-down deepsleep
      Reserved1 : Bits_1;
      CSBF      : Boolean; -- Clear standby flag
      PVDE      : Boolean; -- Power voltage detector enable
      PLS       : Bits_3;  -- PVD level selection
      DBP       : Boolean; -- Disable backup domain write protection
      FPDS      : Boolean; -- Flash power-down in Stop mode
      LPUDS     : Boolean; -- Low-power regulator in deepsleep under-drive mode
      MRUDS     : Boolean; -- Main regulator in deepsleep under-drive mode
      Reserved2 : Bits_1;
      ADCDC1    : Bits_1;  -- Refer to AN4073 for details on how to use this bit.
      VOS       : Bits_2;  -- Regulator voltage scaling output selection
      ODEN      : Boolean; -- Over-drive enable
      ODSWEN    : Boolean; -- Over-drive switching enabled.
      UDEN      : Bits_2;  -- Under-drive enable in stop mode
      Reserved3 : Bits_12;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PWR_CR1_Type use
   record
      LPDS      at 0 range  0 ..  0;
      PDDS      at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  2;
      CSBF      at 0 range  3 ..  3;
      PVDE      at 0 range  4 ..  4;
      PLS       at 0 range  5 ..  7;
      DBP       at 0 range  8 ..  8;
      FPDS      at 0 range  9 ..  9;
      LPUDS     at 0 range 10 .. 10;
      MRUDS     at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 12;
      ADCDC1    at 0 range 13 .. 13;
      VOS       at 0 range 14 .. 15;
      ODEN      at 0 range 16 .. 16;
      ODSWEN    at 0 range 17 .. 17;
      UDEN      at 0 range 18 .. 19;
      Reserved3 at 0 range 20 .. 31;
   end record;

   PWR_CR1_ADDRESS : constant := 16#4000_7000#;

   PWR_CR1 : aliased PWR_CR1_Type with
      Address              => To_Address (PWR_CR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 4.4.2 PWR power control/status register (PWR_CSR1)

   PVDO_HIGHER : constant := 0; -- VDD is higher than the PVD threshold selected with the PLS[2:0] bits.
   PVDO_LOWER  : constant := 1; -- VDD is lower than the PVD threshold selected with the PLS[2:0] bits.

   UDRDY_DISABLED  : constant := 2#00#; -- Under-drive is disabled
   UDRDY_RESERVED1 : constant := 2#01#; -- Reserved
   UDRDY_RESERVED2 : constant := 2#10#; -- Reserved
   UDRDY_STOP      : constant := 2#11#; -- Under-drive mode is activated in Stop mode.

   type PWR_CSR1_Type is
   record
      WUIF      : Boolean; -- Wakeup internal flag
      SBF       : Boolean; -- Standby flag
      PVDO      : Bits_1;  -- This bit is set and cleared by hardware. It is valid only if PVD is enabled by the PVDE bit.
      BRR       : Boolean; -- Backup regulator ready
      Reserved1 : Bits_5;
      BRE       : Boolean; -- Backup regulator enable
      Reserved2 : Bits_4;
      VOSRDY    : Boolean; -- Regulator voltage scaling output selection ready bit
      Reserved3 : Bits_1;
      ODRDY     : Boolean; -- Over-drive mode ready
      ODSWRDY   : Boolean; -- Over-drive mode switching ready
      UDRDY     : Bits_2;  -- Under-drive ready flag
      Reserved4 : Bits_12;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PWR_CSR1_Type use
   record
      WUIF      at 0 range  0 ..  0;
      SBF       at 0 range  1 ..  1;
      PVDO      at 0 range  2 ..  2;
      BRR       at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  8;
      BRE       at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 13;
      VOSRDY    at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 15;
      ODRDY     at 0 range 16 .. 16;
      ODSWRDY   at 0 range 17 .. 17;
      UDRDY     at 0 range 18 .. 19;
      Reserved4 at 0 range 20 .. 31;
   end record;

   PWR_CSR1_ADDRESS : constant := 16#4000_7004#;

   PWR_CSR1 : aliased PWR_CSR1_Type with
      Address              => To_Address (PWR_CSR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 4.4.3 PWR power control/status register 2 (PWR_CR2)

   WUPP_RISING  : constant := 0; -- Detection on rising edge
   WUPP_FALLING : constant := 1; -- Detection on falling edge

   type PWR_CR2_Type is
   record
      CWUPF1    : Boolean;      -- Clear Wakeup Pin flag for PA0
      CWUPF2    : Boolean;      -- Clear Wakeup Pin flag for PA2
      CWUPF3    : Boolean;      -- Clear Wakeup Pin flag for PC1
      CWUPF4    : Boolean;      -- Clear Wakeup Pin flag for PC13
      CWUPF5    : Boolean;      -- Clear Wakeup Pin flag for PI8
      CWUPF6    : Boolean;      -- Clear Wakeup Pin flag for PI11
      Reserved1 : Bits_2 := 0;
      WUPP1     : Bits_1;       -- Wakeup pin polarity bit for PA0
      WUPP2     : Bits_1;       -- Wakeup pin polarity bit for PA2
      WUPP3     : Bits_1;       -- Wakeup pin polarity bit for PC1
      WUPP4     : Bits_1;       -- Wakeup pin polarity bit for PC13
      WUPP5     : Bits_1;       -- Wakeup pin polarity bit for PI8
      WUPP6     : Bits_1;       -- Wakeup pin polarity bit for PI11
      Reserved2 : Bits_18 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PWR_CR2_Type use
   record
      CWUPF1    at 0 range  0 ..  0;
      CWUPF2    at 0 range  1 ..  1;
      CWUPF3    at 0 range  2 ..  2;
      CWUPF4    at 0 range  3 ..  3;
      CWUPF5    at 0 range  4 ..  4;
      CWUPF6    at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      WUPP1     at 0 range  8 ..  8;
      WUPP2     at 0 range  9 ..  9;
      WUPP3     at 0 range 10 .. 10;
      WUPP4     at 0 range 11 .. 11;
      WUPP5     at 0 range 12 .. 12;
      WUPP6     at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   PWR_CR2_ADDRESS : constant := 16#4000_7008#;

   PWR_CR2 : aliased PWR_CR2_Type with
      Address              => To_Address (PWR_CR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 4.4.4 PWR power control register 2 (PWR_CSR2)

   type PWR_CSR2_Type is
   record
      WUPF1     : Boolean;      -- Wakeup Pin flag for PA0
      WUPF2     : Boolean;      -- Wakeup Pin flag for PA2
      WUPF3     : Boolean;      -- Wakeup Pin flag for PC1
      WUPF4     : Boolean;      -- Wakeup Pin flag for PC13
      WUPF5     : Boolean;      -- Wakeup Pin flag for PI8
      WUPF6     : Boolean;      -- Wakeup Pin flag for PI11
      Reserved1 : Bits_2 := 0;
      EWUP1     : Boolean;      -- Enable Wakeup pin for PA0
      EWUP2     : Boolean;      -- Enable Wakeup pin for PA2
      EWUP3     : Boolean;      -- Enable Wakeup pin for PC1
      EWUP4     : Boolean;      -- Enable Wakeup pin for PC13
      EWUP5     : Boolean;      -- Enable Wakeup pin for PI8
      EWUP6     : Boolean;      -- Enable Wakeup pin for PI11
      Reserved2 : Bits_18 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PWR_CSR2_Type use
   record
      WUPF1     at 0 range  0 ..  0;
      WUPF2     at 0 range  1 ..  1;
      WUPF3     at 0 range  2 ..  2;
      WUPF4     at 0 range  3 ..  3;
      WUPF5     at 0 range  4 ..  4;
      WUPF6     at 0 range  5 ..  5;
      Reserved1 at 0 range  6 ..  7;
      EWUP1     at 0 range  8 ..  8;
      EWUP2     at 0 range  9 ..  9;
      EWUP3     at 0 range 10 .. 10;
      EWUP4     at 0 range 11 .. 11;
      EWUP5     at 0 range 12 .. 12;
      EWUP6     at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 31;
   end record;

   PWR_CSR2_ADDRESS : constant := 16#4000_700C#;

   PWR_CSR2 : aliased PWR_CSR2_Type with
      Address              => To_Address (PWR_CSR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 5 Reset and clock control (RCC)
   ----------------------------------------------------------------------------

   -- 5.3.1 RCC clock control register (RCC_CR)

   type RCC_CR_Type is
   record
      HSION     : Boolean := False; -- Internal high-speed clock enable
      HSIRDY    : Boolean := False; -- Internal high-speed clock ready flag
      Reserved1 : Bits_1 := 0;
      HSITRIM   : Bits_5;           -- Internal high-speed clock trimming
      HSICAL    : Bits_8;           -- Internal high-speed clock calibration
      HSEON     : Boolean := False; -- HSE clock enable
      HSERDY    : Boolean := False; -- HSE clock ready flag
      HSEBYP    : Boolean := False; -- HSE clock bypass
      CSSON     : Boolean := False; -- Clock security system enable
      Reserved2 : Bits_4 := 0;
      PLLON     : Boolean := False; -- Main PLL (PLL) enable
      PLLRDY    : Boolean := False; -- Main PLL (PLL) clock ready flag
      PLLI2SON  : Boolean := False; -- PLLI2S enable
      PLLI2SRDY : Boolean := False; -- PLLI2S clock ready flag
      PLLSAION  : Boolean := False; -- PLLSAI enable
      PLLSAIRDY : Boolean := False; -- PLLSAI clock ready flag
      Reserved3 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_CR_Type use
   record
      HSION     at 0 range  0 ..  0;
      HSIRDY    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  2;
      HSITRIM   at 0 range  3 ..  7;
      HSICAL    at 0 range  8 .. 15;
      HSEON     at 0 range 16 .. 16;
      HSERDY    at 0 range 17 .. 17;
      HSEBYP    at 0 range 18 .. 18;
      CSSON     at 0 range 19 .. 19;
      Reserved2 at 0 range 20 .. 23;
      PLLON     at 0 range 24 .. 24;
      PLLRDY    at 0 range 25 .. 25;
      PLLI2SON  at 0 range 26 .. 26;
      PLLI2SRDY at 0 range 27 .. 27;
      PLLSAION  at 0 range 28 .. 28;
      PLLSAIRDY at 0 range 29 .. 29;
      Reserved3 at 0 range 30 .. 31;
   end record;

   -- 5.3.2 RCC PLL configuration register (RCC_PLLCFGR)

   PLLP_DIV2 : constant := 2#00#; -- PLLP = 2
   PLLP_DIV4 : constant := 2#01#; -- PLLP = 4
   PLLP_DIV6 : constant := 2#10#; -- PLLP = 6
   PLLP_DIV8 : constant := 2#11#; -- PLLP = 8

   PLLSRC_HSI : constant := 0; -- HSI clock selected as PLL and PLLI2S clock entry
   PLLSRC_HSE : constant := 1; -- HSE oscillator clock selected as PLL and PLLI2S clock entry

   type RCC_PLLCFGR_Type is
   record
      PLLM      : Bits_6;      -- Division factor for the main PLLs (PLL, PLLI2S and PLLSAI) input clock
      PLLN      : Bits_9;      -- Main PLL (PLL) multiplication factor for VCO
      Reserved1 : Bits_1 := 0;
      PLLP      : Bits_2;      -- Main PLL (PLL) division factor for main system clock
      Reserved2 : Bits_4 := 0;
      PLLSRC    : Bits_1;      -- Main PLL(PLL) and audio PLL (PLLI2S) entry clock source
      Reserved3 : Bits_1 := 0;
      PLLQ      : Bits_4;      -- Main PLL (PLL) division factor for USB OTG FS, SDMMC1/2 and random number generator clocks
      PLLR      : Bits_3;      -- PLL division factor for DSI clock
      Reserved4 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_PLLCFGR_Type use
   record
      PLLM      at 0 range  0 ..  5;
      PLLN      at 0 range  6 .. 14;
      Reserved1 at 0 range 15 .. 15;
      PLLP      at 0 range 16 .. 17;
      Reserved2 at 0 range 18 .. 21;
      PLLSRC    at 0 range 22 .. 22;
      Reserved3 at 0 range 23 .. 23;
      PLLQ      at 0 range 24 .. 27;
      PLLR      at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   -- 5.3.3 RCC clock configuration register (RCC_CFGR)

   SW_HSI : constant := 2#00#; -- HSI oscillator selected as system clock
   SW_HSE : constant := 2#01#; -- HSE oscillator selected as system clock
   SW_PLL : constant := 2#10#; -- PLL selected as system clock

   HPRE_DIV2   : constant := 2#1000#; -- system clock divided by 2
   HPRE_DIV4   : constant := 2#1001#; -- system clock divided by 4
   HPRE_DIV8   : constant := 2#1010#; -- system clock divided by 8
   HPRE_DIV16  : constant := 2#1011#; -- system clock divided by 16
   HPRE_DIV64  : constant := 2#1100#; -- system clock divided by 64
   HPRE_DIV128 : constant := 2#1101#; -- system clock divided by 128
   HPRE_DIV256 : constant := 2#1110#; -- system clock divided by 256
   HPRE_DIV512 : constant := 2#1111#; -- system clock divided by 512

   PPRE_DIV2  : constant := 2#100#; -- AHB clock divided by 2
   PPRE_DIV4  : constant := 2#101#; -- AHB clock divided by 4
   PPRE_DIV8  : constant := 2#110#; -- AHB clock divided by 8
   PPRE_DIV16 : constant := 2#111#; -- AHB clock divided by 16

   MCO1_HSI : constant := 2#00#; -- HSI clock selected
   MCO1_LSE : constant := 2#01#; -- LSE oscillator selected
   MCO1_HSE : constant := 2#10#; -- HSE oscillator clock selected
   MCO1_PLL : constant := 2#11#; -- PLL clock selected

   I2SSCR_PLLI2S : constant := 2#0#; -- PLLI2S clock used as I2S clock source
   I2SSCR_EXT    : constant := 2#1#; -- External clock mapped on the I2S_CKIN pin used as I2S clock source

   MCOPRE_DIV2 : constant := 2#100#; -- division by 2
   MCOPRE_DIV3 : constant := 2#101#; -- division by 3
   MCOPRE_DIV4 : constant := 2#110#; -- division by 4
   MCOPRE_DIV5 : constant := 2#111#; -- division by 5

   MCO2_SYSCLK : constant := 2#00#; -- System clock (SYSCLK) selected
   MCO2_PLLI2S : constant := 2#01#; -- PLLI2S clock selected
   MCO2_HSE    : constant := 2#10#; -- HSE oscillator clock selected
   MCO2_PLL    : constant := 2#11#; -- PLL clock selected

   type RCC_CFGR_Type is
   record
      SW        : Bits_2;      -- System clock switch
      SWS       : Bits_2;      -- System clock switch status
      HPRE      : Bits_4;      -- AHB prescaler
      Reserved1 : Bits_2 := 0;
      PPRE1     : Bits_3;      -- APB Low-speed prescaler (APB1)
      PPRE2     : Bits_3;      -- APB high-speed prescaler (APB2)
      RTCPRE    : Bits_5;      -- HSE division factor for RTC clock
      MCO1      : Bits_2;      -- Microcontroller clock output 1
      I2SSCR    : Bits_1;      -- I2S clock selection
      MCO1PRE   : Bits_3;      -- MCO1 prescaler
      MCO2PRE   : Bits_3;      -- MCO2 prescaler
      MCO2      : Bits_2;      -- Microcontroller clock output 2
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_CFGR_Type use
   record
      SW        at 0 range  0 ..  1;
      SWS       at 0 range  2 ..  3;
      HPRE      at 0 range  4 ..  7;
      Reserved1 at 0 range  8 ..  9;
      PPRE1     at 0 range 10 .. 12;
      PPRE2     at 0 range 13 .. 15;
      RTCPRE    at 0 range 16 .. 20;
      MCO1      at 0 range 21 .. 22;
      I2SSCR    at 0 range 23 .. 23;
      MCO1PRE   at 0 range 24 .. 26;
      MCO2PRE   at 0 range 27 .. 29;
      MCO2      at 0 range 30 .. 31;
   end record;

   -- 5.3.13 RCC APB1 peripheral clock enable register (RCC_APB1ENR)

   type RCC_APB1ENR_Type is
   record
      TIM2EN    : Boolean; -- TIM2 clock enable
      TIM3EN    : Boolean; -- TIM3 clock enable
      TIM4EN    : Boolean; -- TIM4 clock enable
      TIM5EN    : Boolean; -- TIM5 clock enable
      TIM6EN    : Boolean; -- TIM6 clock enable
      TIM7EN    : Boolean; -- TIM7 clock enable
      TIM12EN   : Boolean; -- TIM12 clock enable
      TIM13EN   : Boolean; -- TIM13 clock enable
      TIM14EN   : Boolean; -- TIM14 clock enable
      LPTMI1EN  : Boolean; -- Low-power timer 1 clock enable
      RTCAPBEN  : Boolean; -- RTC register interface clock enable
      WWDGEN    : Boolean; -- Window watchdog clock enable
      Reserved  : Bits_1;
      CAN3EN    : Boolean; -- CAN 3 clock enable
      SPI2EN    : Boolean; -- SPI2 clock enable
      SPI3EN    : Boolean; -- SPI3 clock enable
      SPDIFRXEN : Boolean; -- SPDIFRX clock enable
      USART2EN  : Boolean; -- USART2 clock enable
      USART3EN  : Boolean; -- USART3 clock enable
      UART4EN   : Boolean; -- UART4 clock enable
      UART5EN   : Boolean; -- UART5 clock enable
      I2C1EN    : Boolean; -- I2C1 clock enable
      I2C2EN    : Boolean; -- I2C2 clock enable
      I2C3EN    : Boolean; -- I2C3 clock enable
      I2C4      : Boolean; -- Boolean; -- I2C4 clock enable
      CAN1EN    : Boolean; -- CAN 1 clock enable
      CAN2EN    : Boolean; -- CAN 2 clock enable
      CECEN     : Boolean; -- HDMI-CEC clock enable
      PWREN     : Boolean; -- Power interface clock enable
      DACEN     : Boolean; -- DAC interface clock enable
      UART7EN   : Boolean; -- UART7 clock enable
      UART8EN   : Boolean; -- UART8 clock enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB1ENR_Type use
   record
      TIM2EN    at 0 range  0  .. 0;
      TIM3EN    at 0 range  1  .. 1;
      TIM4EN    at 0 range  2  .. 2;
      TIM5EN    at 0 range  3  .. 3;
      TIM6EN    at 0 range  4  .. 4;
      TIM7EN    at 0 range  5  .. 5;
      TIM12EN   at 0 range  6  .. 6;
      TIM13EN   at 0 range  7  .. 7;
      TIM14EN   at 0 range  8  .. 8;
      LPTMI1EN  at 0 range  9  .. 9;
      RTCAPBEN  at 0 range 10 .. 10;
      WWDGEN    at 0 range 11 .. 11;
      Reserved  at 0 range 12 .. 12;
      CAN3EN    at 0 range 13 .. 13;
      SPI2EN    at 0 range 14 .. 14;
      SPI3EN    at 0 range 15 .. 15;
      SPDIFRXEN at 0 range 16 .. 16;
      USART2EN  at 0 range 17 .. 17;
      USART3EN  at 0 range 18 .. 18;
      UART4EN   at 0 range 19 .. 19;
      UART5EN   at 0 range 20 .. 20;
      I2C1EN    at 0 range 21 .. 21;
      I2C2EN    at 0 range 22 .. 22;
      I2C3EN    at 0 range 23 .. 23;
      I2C4      at 0 range 24 .. 24;
      CAN1EN    at 0 range 25 .. 25;
      CAN2EN    at 0 range 26 .. 26;
      CECEN     at 0 range 27 .. 27;
      PWREN     at 0 range 28 .. 28;
      DACEN     at 0 range 29 .. 29;
      UART7EN   at 0 range 30 .. 30;
      UART8EN   at 0 range 31 .. 31;
   end record;

   -- 5.3.14 RCC APB2 peripheral clock enable register (RCC_APB2ENR)

   type RCC_APB2ENR_Type is
   record
      TIM1EN    : Boolean; -- TIM1 clock enable
      TIM8EN    : Boolean; -- TIM8 clock enable
      Reserved1 : Bits_2;
      USART1EN  : Boolean; -- USART1 clock enable
      USART6EN  : Boolean; -- USART6 clock enable
      Reserved2 : Bits_1;
      SDMMC2EN  : Boolean; -- SDMMC2 clock enable
      ADC1EN    : Boolean; -- ADC1 clock enable
      ADC2EN    : Boolean; -- ADC2 clock enable
      ADC3EN    : Boolean; -- ADC3 clock enable
      SDMMC1EN  : Boolean; -- SDMMC1 clock enable
      SPI1EN    : Boolean; -- SPI1 clock enable
      SPI4EN    : Boolean; -- SPI4 clock enable
      SYSCFGEN  : Boolean; -- System configuration controller clock enable
      Reserved3 : Bits_1;
      TIM9EN    : Boolean; -- TIM9 clock enable
      TIM10EN   : Boolean; -- TIM10 clock enable
      TIM11EN   : Boolean; -- TIM11 clock enable
      Reserved4 : Bits_1;
      SPI5EN    : Boolean; -- SPI5 clock enable
      SPI6EN    : Boolean; -- SPI6 clock enable
      SAI1EN    : Boolean; -- SAI1 clock enable
      SAI2EN    : Boolean; -- SAI2 clock enable
      Reserved5 : Bits_2;
      LTDCEN    : Boolean; -- LTDC clock enable
      DSIEN     : Boolean; -- DSIHOST clock enable
      Reserved6 : Bits_1;
      DFSDM1EN  : Boolean; -- DFSDM1 module reset
      MDIOEN    : Boolean; -- MDIO clock enable
      Reserved7 : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB2ENR_Type use
   record
      TIM1EN    at 0 range  0 ..  0;
      TIM8EN    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      USART1EN  at 0 range  4 ..  4;
      USART6EN  at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      SDMMC2EN  at 0 range  7 ..  7;
      ADC1EN    at 0 range  8 ..  8;
      ADC2EN    at 0 range  9 ..  9;
      ADC3EN    at 0 range 10 .. 10;
      SDMMC1EN  at 0 range 11 .. 11;
      SPI1EN    at 0 range 12 .. 12;
      SPI4EN    at 0 range 13 .. 13;
      SYSCFGEN  at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 15;
      TIM9EN    at 0 range 16 .. 16;
      TIM10EN   at 0 range 17 .. 17;
      TIM11EN   at 0 range 18 .. 18;
      Reserved4 at 0 range 19 .. 19;
      SPI5EN    at 0 range 20 .. 20;
      SPI6EN    at 0 range 21 .. 21;
      SAI1EN    at 0 range 22 .. 22;
      SAI2EN    at 0 range 23 .. 23;
      Reserved5 at 0 range 24 .. 25;
      LTDCEN    at 0 range 26 .. 26;
      DSIEN     at 0 range 27 .. 27;
      Reserved6 at 0 range 28 .. 28;
      DFSDM1EN  at 0 range 29 .. 29;
      MDIOEN    at 0 range 30 .. 30;
      Reserved7 at 0 range 31 .. 31;
   end record;

   -- 5.3 RCC registers

   type RCC_Type is
   record
      RCC_CR      : RCC_CR_Type      with Volatile_Full_Access => True;
      RCC_PLLCFGR : RCC_PLLCFGR_Type with Volatile_Full_Access => True;
      RCC_CFGR    : RCC_CFGR_Type    with Volatile_Full_Access => True;
      RCC_APB1ENR : RCC_APB1ENR_Type with Volatile_Full_Access => True;
      RCC_APB2ENR : RCC_APB2ENR_Type with Volatile_Full_Access => True;
   end record with
      Size                    => 16#48# * 8,
      Suppress_Initialization => True;
   for RCC_Type use
   record
      RCC_CR      at 16#00# range 0 .. 31;
      RCC_PLLCFGR at 16#04# range 0 .. 31;
      RCC_CFGR    at 16#08# range 0 .. 31;
      RCC_APB1ENR at 16#40# range 0 .. 31;
      RCC_APB2ENR at 16#44# range 0 .. 31;
   end record;

   RCC_BASEADDRESS : constant := 16#4002_3800#;

   RCC : aliased RCC_Type with
      Address    => To_Address (RCC_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 6 General-purpose I/Os (GPIO)
   ----------------------------------------------------------------------------

   -- 6.4.1 GPIO port mode register (GPIOx_MODER) (x =A..K)

   GPIO_IN  : constant := 2#00#; -- Input mode (reset state)
   GPIO_OUT : constant := 2#01#; -- General purpose output mode
   GPIO_ALT : constant := 2#10#; -- Alternate function mode
   GPIO_ANL : constant := 2#11#; -- Analog mode

   type GPIOx_MODER_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

   -- 6.4.2 GPIO port output type register (GPIOx_OTYPER) (x = A..K)

   GPIO_PP : constant := 0; -- Output push-pull (reset state)
   GPIO_OD : constant := 1; -- Output open-drain

   type GPIOx_OTYPER_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;

   -- 6.4.3 GPIO port output speed register (GPIOx_OSPEEDR) (x = A..K)

   GPIO_LO : constant := 2#00#; -- Low speed
   GPIO_MS : constant := 2#01#; -- Medium speed
   GPIO_HI : constant := 2#10#; -- High speed
   GPIO_VH : constant := 2#11#; -- Very high speed

   type GPIOx_OSPEEDR_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

   -- 6.4.4 GPIO port pull-up/pull-down register (GPIOx_PUPDR)(x = A..K)

   GPIO_NOPUPD : constant := 2#00#; -- No pull-up, pull-down
   GPIO_PU     : constant := 2#01#; -- Pull-up
   GPIO_PD     : constant := 2#10#; -- Pull-down

   type GPIOx_PUPDR_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

   -- 6.4.5 GPIO port input data register (GPIOx_IDR) (x = A..K)

   type GPIOx_IDR_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;

   -- 6.4.6 GPIO port output data register (GPIOx_ODR) (x = A..K)

   type GPIOx_ODR_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;

   -- 6.4.7 GPIO port bit set/reset register (GPIOx_BSRR) (x = A..K)

   type BSRR_SET_Type is array (0 .. 15) of Boolean with
      Size => 16,
      Pack => True;
   type BSRR_RST_Type is array (0 .. 15) of Boolean with
      Size => 16,
      Pack => True;

   type GPIOx_BSRR_Type is
   record
      SET : BSRR_SET_Type;
      RST : BSRR_RST_Type;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_BSRR_Type use
   record
      SET at 0 range  0 .. 15;
      RST at 0 range 16 .. 31;
   end record;

   -- 6.4.8 GPIO port configuration lock register (GPIOx_LCKR) (x = A..K)

   type LCKy_Type is array (0 .. 15) of Boolean with
      Size => 16,
      Pack => True;

   type GPIOx_LCKR_Type is
   record
      LCK      : LCKy_Type;    -- Port x lock bit y (y= 0..15)
      LCKK     : Boolean;      -- Lock key
      Reserved : Bits_15 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPIOx_LCKR_Type use
   record
      LCK      at 0 range  0 .. 15;
      LCKK     at 0 range 16 .. 16;
      Reserved at 0 range 17 .. 31;
   end record;

   -- 6.4.9 GPIO alternate function low register (GPIOx_AFRL) (x = A..K)
   -- 6.4.10 GPIO alternate function high register (GPIOx_AFRH) (x = A..J)

   AF0  : constant := 2#0000#;
   AF1  : constant := 2#0001#;
   AF2  : constant := 2#0010#;
   AF3  : constant := 2#0011#;
   AF4  : constant := 2#0100#;
   AF5  : constant := 2#0101#;
   AF6  : constant := 2#0110#;
   AF7  : constant := 2#0111#;
   AF8  : constant := 2#1000#;
   AF9  : constant := 2#1001#;
   AF10 : constant := 2#1010#;
   AF11 : constant := 2#1011#;
   AF12 : constant := 2#1100#;
   AF13 : constant := 2#1101#;
   AF14 : constant := 2#1110#;
   AF15 : constant := 2#1111#;

   type AFRL_Type is array (0 .. 7) of Bits_4 with
      Size => 32,
      Pack => True;

   type AFRH_Type is array (8 .. 15) of Bits_4 with
      Size => 32,
      Pack => True;

   -- 6.4. GPIO registers

   type GPIO_PORT_Type is
   record
      MODER   : GPIOx_MODER_Type := [others => GPIO_IN] with
         Volatile_Full_Access => True; -- mode register
      OTYPER  : GPIOx_OTYPER_Type := [others => GPIO_PP] with
         Volatile_Full_Access => True; -- output type register
      OSPEEDR : GPIOx_OSPEEDR_Type := [others => GPIO_LO] with
         Volatile_Full_Access => True; -- output speed register
      PUPDR   : GPIOx_PUPDR_Type := [others => GPIO_NOPUPD] with
         Volatile_Full_Access => True; -- pull-up/pull-down register
      IDR     : GPIOx_IDR_Type with
         Volatile_Full_Access => True; -- input data register
      ODR     : GPIOx_ODR_Type with
         Volatile_Full_Access => True; -- output data register
      BSRR    : GPIOx_BSRR_Type := [[others => False], [others => False]] with
         Volatile_Full_Access => True; -- bit set/reset register
      LCKR    : GPIOx_LCKR_Type := (LCK => [others => False], LCKK => False, others => <>) with
         Volatile_Full_Access => True; -- configuration lock register
      AFRL    : AFRL_Type := [others => AF0] with
         Volatile_Full_Access => True; -- alternate function low register
      AFRH    : AFRH_Type := [others => AF0] with
         Volatile_Full_Access => True; -- alternate function high register
   end record with
      Size                    => 16#28# * 8,
      Suppress_Initialization => True;
   for GPIO_PORT_Type use
   record
      MODER   at 16#00# range 0 .. 31;
      OTYPER  at 16#04# range 0 .. 31;
      OSPEEDR at 16#08# range 0 .. 31;
      PUPDR   at 16#0C# range 0 .. 31;
      IDR     at 16#10# range 0 .. 31;
      ODR     at 16#14# range 0 .. 31;
      BSRR    at 16#18# range 0 .. 31;
      LCKR    at 16#1C# range 0 .. 31;
      AFRL    at 16#20# range 0 .. 31;
      AFRH    at 16#24# range 0 .. 31;
   end record;

   GPIOA_BASEADDRESS : constant := 16#4002_0000#;

   GPIOA : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOA_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOB_BASEADDRESS : constant := 16#4002_0400#;

   GPIOB : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOB_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOC_BASEADDRESS : constant := 16#4002_0800#;

   GPIOC : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOC_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOD_BASEADDRESS : constant := 16#4002_0C00#;

   GPIOD : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOD_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOE_BASEADDRESS : constant := 16#4002_1000#;

   GPIOE : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOE_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOF_BASEADDRESS : constant := 16#4002_1400#;

   GPIOF : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOF_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOG_BASEADDRESS : constant := 16#4002_1800#;

   GPIOG : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOG_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOH_BASEADDRESS : constant := 16#4002_1C00#;

   GPIOH : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOH_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOI_BASEADDRESS : constant := 16#4002_2000#;

   GPIOI : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOI_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOJ_BASEADDRESS : constant := 16#4002_2400#;

   GPIOJ : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOJ_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   GPIOK_BASEADDRESS : constant := 16#4002_2800#;

   GPIOK : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOK_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 7 System configuration controller (SYSCFG)
   ----------------------------------------------------------------------------

   -- 7.2.1 SYSCFG memory remap register (SYSCFG_MEMRMP)

   MEM_BOOT_ADD0 : constant := 0; -- Boot memory base address is defined by BOOT_ADD0 option byte
   MEM_BOOT_ADD1 : constant := 1; -- Boot memory base address is defined by BOOT_ADD1 option byte

   SWP_FMC_NONE  : constant := 2#00#; -- No FMC memory mapping swapping
   SWP_FMC_SDRAM : constant := 2#01#; -- NOR/RAM and SDRAM memory mapping swapped

   type SYSCFG_MEMRMP_Type is
   record
      MEM_BOOT  : Bits_1;  -- Memory boot mapping
      Reserved1 : Bits_7;
      SWP_FB    : Boolean; -- Flash Bank swap
      Reserved2 : Bits_1;
      SWP_FMC   : Bits_2;  -- FMC memory mapping swap
      Reserved3 : Bits_20;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_MEMRMP_Type use
   record
      MEM_BOOT  at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      SWP_FB    at 0 range  8 ..  8;
      Reserved2 at 0 range  9 ..  9;
      SWP_FMC   at 0 range 10 .. 11;
      Reserved3 at 0 range 12 .. 31;
   end record;

   SYSCFG_MEMRMP_ADDRESS : constant := 16#4001_3800#;

   SYSCFG_MEMRMP : aliased SYSCFG_MEMRMP_Type with
      Address              => To_Address (SYSCFG_MEMRMP_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 10 Nested vectored interrupt controller (NVIC)
   ----------------------------------------------------------------------------

   -- 10.1.2 Interrupt and exception vectors

   IRQ_WWDG               : constant :=   0; -- Window Watchdog interrupt
   IRQ_PVD                : constant :=   1; -- PVD through EXTI line detection interrupt
   IRQ_TAMP_STAMP         : constant :=   2; -- Tamper and TimeStamp interrupts through the EXTI line
   IRQ_RTC_WKUP           : constant :=   3; -- RTC Wakeup interrupt through the EXTI line
   IRQ_FLASH              : constant :=   4; -- Flash global interrupt
   IRQ_RCC                : constant :=   5; -- RCC global interrupt
   IRQ_EXTI0              : constant :=   6; -- EXTI Line0 interrupt
   IRQ_EXTI1              : constant :=   7; -- EXTI Line1 interrupt
   IRQ_EXTI2              : constant :=   8; -- EXTI Line2 interrupt
   IRQ_EXTI3              : constant :=   9; -- EXTI Line3 interrupt
   IRQ_EXTI4              : constant :=  10; -- EXTI Line4 interrupt
   IRQ_DMA1_Stream0       : constant :=  11; -- DMA1 Stream0 global interrupt
   IRQ_DMA1_Stream1       : constant :=  12; -- DMA1 Stream1 global interrupt
   IRQ_DMA1_Stream2       : constant :=  13; -- DMA1 Stream2 global interrupt
   IRQ_DMA1_Stream3       : constant :=  14; -- DMA1 Stream3 global interrupt
   IRQ_DMA1_Stream4       : constant :=  15; -- DMA1 Stream4 global interrupt
   IRQ_DMA1_Stream5       : constant :=  16; -- DMA1 Stream5 global interrupt
   IRQ_DMA1_Stream6       : constant :=  17; -- DMA1 Stream6 global interrupt
   IRQ_ADC                : constant :=  18; -- ADC1, ADC2 and ADC3 global interrupts
   IRQ_CAN1_TX            : constant :=  19; -- CAN1 TX interrupts
   IRQ_CAN1_RX0           : constant :=  20; -- CAN1 RX0 interrupts
   IRQ_CAN1_RX1           : constant :=  21; -- CAN1 RX1 interrupt
   IRQ_CAN1_SCE           : constant :=  22; -- CAN1 SCE interrupt
   IRQ_EXTI9_5            : constant :=  23; -- EXTI Line[9:5] interrupts
   IRQ_TIM1_BRK_TIM9      : constant :=  24; -- TIM1 Break interrupt and TIM9 global interrupt
   IRQ_TIM1_UP_TIM10      : constant :=  25; -- TIM1 Update interrupt and TIM10 global interrupt
   IRQ_TIM1_TRG_COM_TIM11 : constant :=  26; -- TIM1 Trigger and Commutation interrupts and TIM11 global interrupt
   IRQ_TIM1_CC            : constant :=  27; -- TIM1 Capture Compare interrupt
   IRQ_TIM2               : constant :=  28; -- TIM2 global interrupt
   IRQ_TIM3               : constant :=  29; -- TIM3 global interrupt
   IRQ_TIM4               : constant :=  30; -- TIM4 global interrupt
   IRQ_I2C1_EV            : constant :=  31; -- I2C1 event interrupt
   IRQ_I2C1_ER            : constant :=  32; -- I2C1 error interrupt
   IRQ_I2C2_EV            : constant :=  33; -- I2C2 event interrupt
   IRQ_I2C2_ER            : constant :=  34; -- I2C2 error interrupt
   IRQ_SPI1               : constant :=  35; -- SPI1 global interrupt
   IRQ_SPI2               : constant :=  36; -- SPI2 global interrupt
   IRQ_USART1             : constant :=  37; -- USART1 global interrupt
   IRQ_USART2             : constant :=  38; -- USART2 global interrupt
   IRQ_USART3             : constant :=  39; -- USART3 global interrupt
   IRQ_EXTI15_10          : constant :=  40; -- EXTI Line[15:10] interrupts
   IRQ_RTC_Alarm          : constant :=  41; -- RTC Alarms (A and B) through EXTI line interrupt
   IRQ_OTG_FS_WKUP        : constant :=  42; -- USB On-The-Go FS Wakeup through EXTI line interrupt
   IRQ_TIM8_BRK_TIM12     : constant :=  43; -- TIM8 Break interrupt and TIM12 global interrupt
   IRQ_TIM8_UP_TIM13      : constant :=  44; -- TIM8 Update interrupt and TIM13 global interrupt
   IRQ_TIM8_TRG_COM_TIM14 : constant :=  45; -- TIM8 Trigger and Commutation interrupts and TIM14 global interrupt
   IRQ_TIM8_CC            : constant :=  46; -- TIM8 Capture Compare interrupt
   IRQ_DMA1_Stream7       : constant :=  47; -- DMA1 Stream7 global interrupt
   IRQ_FMC                : constant :=  48; -- FMC global interrupt
   IRQ_SDMMC1             : constant :=  49; -- SDMMC1 global interrupt
   IRQ_TIM5               : constant :=  50; -- TIM5 global interrupt
   IRQ_SPI3               : constant :=  51; -- SPI3 global interrupt
   IRQ_UART4              : constant :=  52; -- UART4 global interrupt
   IRQ_UART5              : constant :=  53; -- UART5 global interrupt
   IRQ_TIM6_DAC           : constant :=  54; -- TIM6 global interrupt, DAC1 and DAC2 underrun error interrupts
   IRQ_TIM7               : constant :=  55; -- TIM7 global interrupt
   IRQ_DMA2_Stream0       : constant :=  56; -- DMA2 Stream0 global interrupt
   IRQ_DMA2_Stream1       : constant :=  57; -- DMA2 Stream1 global interrupt
   IRQ_DMA2_Stream2       : constant :=  58; -- DMA2 Stream2 global interrupt
   IRQ_DMA2_Stream3       : constant :=  59; -- DMA2 Stream3 global interrupt
   IRQ_DMA2_Stream4       : constant :=  60; -- DMA2 Stream4 global interrupt
   IRQ_ETH                : constant :=  61; -- Ethernet global interrupt
   IRQ_ETH_WKUP           : constant :=  62; -- Ethernet Wakeup through EXTI line interrupt
   IRQ_CAN2_TX            : constant :=  63; -- CAN2 TX interrupts
   IRQ_CAN2_RX0           : constant :=  64; -- CAN2 RX0 interrupts
   IRQ_CAN2_RX1           : constant :=  65; -- CAN2 RX1 interrupt
   IRQ_CAN2_SCE           : constant :=  66; -- CAN2 SCE interrupt
   IRQ_OTG_FS             : constant :=  67; -- USB On The Go FS global interrupt
   IRQ_DMA2_Stream5       : constant :=  68; -- DMA2 Stream5 global interrupt
   IRQ_DMA2_Stream6       : constant :=  69; -- DMA2 Stream6 global interrupt
   IRQ_DMA2_Stream7       : constant :=  70; -- DMA2 Stream7 global interrupt
   IRQ_USART6             : constant :=  71; -- USART6 global interrupt
   IRQ_I2C3_EV            : constant :=  72; -- I2C3 event interrupt
   IRQ_I2C3_ER            : constant :=  73; -- I2C3 error interrupt
   IRQ_OTG_HS_EP1_OUT     : constant :=  74; -- USB On The Go HS End Point 1 Out global interrupt
   IRQ_OTG_HS_EP1_IN      : constant :=  75; -- USB On The Go HS End Point 1 In global interrupt
   IRQ_OTG_HS_WKUP        : constant :=  76; -- USB On The Go HS Wakeup through EXTI interrupt
   IRQ_OTG_HS             : constant :=  77; -- USB On The Go HS global interrupt
   IRQ_DCMI               : constant :=  78; -- DCMI global interrupt
   IRQ_CRYP               : constant :=  79; -- CRYP crypto global interrupt
   IRQ_HASH_RNG           : constant :=  80; -- Hash and Rng global interrupt
   IRQ_FPU                : constant :=  81; -- FPU global interrupt
   IRQ_UART7              : constant :=  82; -- UART7 global interrupt
   IRQ_UART8              : constant :=  83; -- UART8 global interrupt
   IRQ_SPI4               : constant :=  84; -- SPI4 global interrupt
   IRQ_SPI5               : constant :=  85; -- SPI5 global interrupt
   IRQ_SPI6               : constant :=  86; -- SPI6 global interrupt
   IRQ_SAI7               : constant :=  87; -- SAI1 global interrupt
   IRQ_LCD_TFT            : constant :=  88; -- LCD-TFT global interrupt
   IRQ_LCD_TFT_E          : constant :=  89; -- LCD-TFT global Error interrupt
   IRQ_DMA2D              : constant :=  90; -- DMA2D global interrupt
   IRQ_SAI2               : constant :=  91; -- SAI2 global interrupt
   IRQ_QuadSPI            : constant :=  92; -- QuadSPI global interrupt
   IRQ_LP_Timer1          : constant :=  93; -- LP Timer1 global interrupt
   IRQ_HDMI_CEC           : constant :=  94; -- HDMI-CEC global interrupt
   IRQ_I2C4_EV            : constant :=  95; -- I2C4 event interrupt
   IRQ_I2C4_ER            : constant :=  96; -- I2C4 Error interrupt
   IRQ_SPDIFRX            : constant :=  97; -- SPDIFRX global interrupt
   IRQ_DSIHOST            : constant :=  98; -- DSI host global interrupt
   IRQ_DFSDM1_FLT0        : constant :=  99; -- DFSDM1 Filter 0 global interrupt
   IRQ_DFSDM1_FLT1        : constant := 100; -- DFSDM1 Filter 1 global interrupt
   IRQ_DFSDM1_FLT2        : constant := 101; -- DFSDM1 Filter 2 global interrupt
   IRQ_DFSDM1_FLT3        : constant := 102; -- DFSDM1 Filter 3 global interrupt
   IRQ_SDMMC2             : constant := 103; -- SDMMC2 global interrupt
   IRQ_CAN3_TX            : constant := 104; -- CAN3 TX interrupt
   IRQ_CAN3_RX0           : constant := 105; -- CAN3 RX0 interrupt
   IRQ_CAN3_RX1           : constant := 106; -- CAN3 RX1 interrupt
   IRQ_CAN3_SCE           : constant := 107; -- CAN3 SCE interrupt
   IRQ_JPEG               : constant := 108; -- JPEG global interrupt
   IRQ_MDIOS              : constant := 109; -- MDIO slave global interrupt

   ----------------------------------------------------------------------------
   -- 34 Universal synchronous asynchronous receiver transmitter (USART)
   ----------------------------------------------------------------------------

   -- 34.8.1 Control register 1 (USART_CR1)

   PS_EVEN : constant := 0; -- Even parity
   PS_ODD  : constant := 1; -- Odd parity

   WAKE_IDLE : constant := 0; -- Idle line
   WAKE_ADDR : constant := 1; -- Address mark

   type M_WORD_LENGTH_Type is
   record
      M0 : Bits_1;
      M1 : Bits_1;
   end record;

   M_8N1 : constant M_WORD_LENGTH_Type := (0, 0); -- 1 Start bit, 8 data bits, n stop bits
   M_9N1 : constant M_WORD_LENGTH_Type := (1, 0); -- 1 Start bit, 9 data bits, n stop bits
   M_7N1 : constant M_WORD_LENGTH_Type := (0, 1); -- 1 Start bit, 7 data bits, n stop bits

   OVER8_16 : constant := 0; -- Oversampling by 16
   OVER8_8  : constant := 1; -- Oversampling by 8

   type USART_CR1_Type is
   record
      UE       : Boolean;     -- USART enable
      UESM     : Boolean;     -- USART enable in Stop mode
      RE       : Boolean;     -- Receiver enable
      TE       : Boolean;     -- Transmitter enable
      IDLEIE   : Boolean;     -- IDLE interrupt enable
      RXNEIE   : Boolean;     -- RXNE interrupt enable
      TCIE     : Boolean;     -- Transmission complete interrupt enable
      TXEIE    : Boolean;     -- interrupt enable
      PEIE     : Boolean;     -- PE interrupt enable
      PS       : Bits_1;      -- Parity selection
      PCE      : Boolean;     -- Parity control enable
      WAKE     : Bits_1;      -- Receiver wakeup method
      M0       : Bits_1;      -- Word length
      MME      : Boolean;     -- Mute mode enable
      CMIE     : Boolean;     -- Character match interrupt enable
      OVER8    : Bits_1;      -- Oversampling mode
      DEDT     : Bits_5;      -- Driver Enable de-assertion time
      DEAT     : Bits_5;      -- Driver Enable assertion time
      RTOIE    : Boolean;     -- Receiver timeout interrupt enable
      EOBIE    : Boolean;     -- End of Block interrupt enable
      M1       : Bits_1;      -- Word length
      Reserved : Bits_3 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_CR1_Type use
   record
      UE       at 0 range  0 ..  0;
      UESM     at 0 range  1 ..  1;
      RE       at 0 range  2 ..  2;
      TE       at 0 range  3 ..  3;
      IDLEIE   at 0 range  4 ..  4;
      RXNEIE   at 0 range  5 ..  5;
      TCIE     at 0 range  6 ..  6;
      TXEIE    at 0 range  7 ..  7;
      PEIE     at 0 range  8 ..  8;
      PS       at 0 range  9 ..  9;
      PCE      at 0 range 10 .. 10;
      WAKE     at 0 range 11 .. 11;
      M0       at 0 range 12 .. 12;
      MME      at 0 range 13 .. 13;
      CMIE     at 0 range 14 .. 14;
      OVER8    at 0 range 15 .. 15;
      DEDT     at 0 range 16 .. 20;
      DEAT     at 0 range 21 .. 25;
      RTOIE    at 0 range 26 .. 26;
      EOBIE    at 0 range 27 .. 27;
      M1       at 0 range 28 .. 28;
      Reserved at 0 range 29 .. 31;
   end record;

   -- 34.8.2 Control register 2 (USART_CR2)

   ADDM7_4 : constant := 0; -- 4-bit address detection
   ADDM7_7 : constant := 1; -- 7-bit address detection (in 8-bit data mode)

   LBDL_10 : constant := 0; -- 10-bit break detection
   LBDL_11 : constant := 1; -- 11-bit break detection

   CPHA_1ST : constant := 0; -- The first clock transition is the first data capture edge
   CPHA_2ND : constant := 1; -- The second clock transition is the first data capture edge

   CPOL_LOW  : constant := 0; -- Steady low value on CK pin outside transmission window
   CPOL_HIGH : constant := 1; -- Steady high value on CK pin outside transmission window

   STOP_1  : constant := 2#00#; -- 1 stop bit
   STOP_05 : constant := 2#01#; -- 0.5 stop bit
   STOP_2  : constant := 2#10#; -- 2 stop bits
   STOP_15 : constant := 2#11#; -- 1.5 stop bits

   ABRMOD_START   : constant := 2#00#; --  Measurement of the start bit is used to detect the baud rate.
   ABRMOD_FALLING : constant := 2#01#; --  Falling edge to falling edge measurement.
   ABRMOD_7F      : constant := 2#10#; --  0x7F frame detection.
   ABRMOD_55      : constant := 2#11#; --  0x55 frame detection

   type USART_CR2_Type is
   record
      Reserved1 : Bits_4;
      ADDM7     : Bits_1;  -- 7-bit Address Detection/4-bit Address Detection
      LBDL      : Bits_1;  -- LIN break detection length
      LBDIE     : Boolean; -- LIN break detection interrupt enable
      Reserved2 : Bits_1;
      LBCL      : Boolean; -- Last bit clock pulse
      CPHA      : Bits_1;  -- Clock phase
      CPOL      : Bits_1;  -- Clock polarity
      CLKEN     : Boolean; -- Clock enable
      STOP      : Bits_2;  -- STOP bits
      LINEN     : Boolean; -- LIN mode enable
      SWAP      : Boolean; -- Swap TX/RX pins
      RXINV     : Boolean; -- RX pin active level inversion
      TXINV     : Boolean; -- TX pin active level inversion
      DATAINV   : Boolean; -- Binary data inversion
      MSBFIRST  : Boolean; -- Most significant bit first
      ABREN     : Boolean; -- Auto baud rate enable
      ABRMOD    : Bits_2;  -- Auto baud rate mode
      RTOEN     : Boolean; -- Receiver timeout enable
      ADD30     : Bits_4;  -- Address of the USART node
      ADD74     : Bits_4;  -- Address of the USART node
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_CR2_Type use
   record
      Reserved1 at 0 range  0 ..  3;
      ADDM7     at 0 range  4 ..  4;
      LBDL      at 0 range  5 ..  5;
      LBDIE     at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  7;
      LBCL      at 0 range  8 ..  8;
      CPHA      at 0 range  9 ..  9;
      CPOL      at 0 range 10 .. 10;
      CLKEN     at 0 range 11 .. 11;
      STOP      at 0 range 12 .. 13;
      LINEN     at 0 range 14 .. 14;
      SWAP      at 0 range 15 .. 15;
      RXINV     at 0 range 16 .. 16;
      TXINV     at 0 range 17 .. 17;
      DATAINV   at 0 range 18 .. 18;
      MSBFIRST  at 0 range 19 .. 19;
      ABREN     at 0 range 20 .. 20;
      ABRMOD    at 0 range 21 .. 22;
      RTOEN     at 0 range 23 .. 23;
      ADD30     at 0 range 24 .. 27;
      ADD74     at 0 range 28 .. 31;
   end record;

   -- 34.8.3 Control register 3 (USART_CR3)

   DEP_HIGH : constant := 0; -- DE signal is active high.
   DEP_LOW  : constant := 1; -- DE signal is active low.

   SCARCNT_RETXDIS : constant := 0; -- No automatic retransmission in transmit mode.

   WUS_ADDRMATCH : constant := 2#00#; -- WUF active on address match
   WUS_STARTBIT  : constant := 2#10#; -- WuF active on Start bit detection
   WUS_RXNE      : constant := 2#11#; -- WUF active on RXNE.

   type USART_CR3_Type is
   record
      EIE       : Boolean; -- Error interrupt enable
      IREN      : Boolean; -- IrDA mode enable
      IRLP      : Boolean; -- IrDA low-power
      HDSEL     : Boolean; -- Half-duplex selection
      NACK      : Boolean; -- Smartcard NACK enable
      SCEN      : Boolean; -- Smartcard mode enable
      DMAR      : Boolean; -- DMA enable receiver
      DMAT      : Boolean; -- DMA enable transmitter
      RTSE      : Boolean; -- RTS enable
      CTSE      : Boolean; -- CTS enable
      CTSIE     : Boolean; -- CTS interrupt enable
      ONEBIT    : Boolean; -- One sample bit method enable
      OVRDIS    : Boolean; -- Overrun Disable
      DDRE      : Boolean; -- DMA Disable on Reception Error
      DEM       : Boolean; -- Driver enable mode
      DEP       : Bits_1;  -- Driver enable polarity selection
      Reserved1 : Bits_1;
      SCARCNT   : Bits_3;  -- Smartcard auto-retry count
      WUS       : Bits_2;  -- Wakeup from Stop mode interrupt flag selection
      WUFIE     : Boolean; -- Wakeup from Stop mode interrupt enable
      UCESM     : Boolean; -- USART Clock Enable in Stop mode.
      TCBGTIE   : Boolean; -- Transmission complete before guard time interrupt enable
      Reserved2 : Bits_7;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_CR3_Type use
   record
      EIE       at 0 range  0 ..  0;
      IREN      at 0 range  1 ..  1;
      IRLP      at 0 range  2 ..  2;
      HDSEL     at 0 range  3 ..  3;
      NACK      at 0 range  4 ..  4;
      SCEN      at 0 range  5 ..  5;
      DMAR      at 0 range  6 ..  6;
      DMAT      at 0 range  7 ..  7;
      RTSE      at 0 range  8 ..  8;
      CTSE      at 0 range  9 ..  9;
      CTSIE     at 0 range 10 .. 10;
      ONEBIT    at 0 range 11 .. 11;
      OVRDIS    at 0 range 12 .. 12;
      DDRE      at 0 range 13 .. 13;
      DEM       at 0 range 14 .. 14;
      DEP       at 0 range 15 .. 15;
      Reserved1 at 0 range 16 .. 16;
      SCARCNT   at 0 range 17 .. 19;
      WUS       at 0 range 20 .. 21;
      WUFIE     at 0 range 22 .. 22;
      UCESM     at 0 range 23 .. 23;
      TCBGTIE   at 0 range 24 .. 24;
      Reserved2 at 0 range 25 .. 31;
   end record;

   -- 34.8.4 Baud rate register (USART_BRR)

   type USART_BRR_Type is
   record
      BRR      : Bits_16; -- BRR value
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_BRR_Type use
   record
      BRR      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 34.8.5 Guard time and prescaler register (USART_GTPR)

   type USART_GTPR_Type is
   record
      PSC      : Unsigned_8; -- Prescaler value
      GT       : Unsigned_8; -- Guard time value
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_GTPR_Type use
   record
      PSC      at 0 range  0 ..  7;
      GT       at 0 range  8 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 34.8.6 Receiver timeout register (USART_RTOR)

   type USART_RTOR_Type is
   record
      RTO  : Bits_24; -- Receiver timeout value
      BLEN : Bits_8;  -- Block Length
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_RTOR_Type use
   record
      RTO  at 0 range  0 .. 23;
      BLEN at 0 range 24 .. 31;
   end record;

   -- 34.8.7 Request register (USART_RQR)

   type USART_RQR_Type is
   record
      ABRRQ    : Boolean; -- Auto baud rate request
      SBKRQ    : Boolean; -- Send break request
      MMRQ     : Boolean; -- Mute mode request
      RXFRQ    : Boolean; -- Receive data flush request
      TXFRQ    : Boolean; -- Transmit data flush request
      Reserved : Bits_27;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_RQR_Type use
   record
      ABRRQ    at 0 range 0 ..  0;
      SBKRQ    at 0 range 1 ..  1;
      MMRQ     at 0 range 2 ..  2;
      RXFRQ    at 0 range 3 ..  3;
      TXFRQ    at 0 range 4 ..  4;
      Reserved at 0 range 5 .. 31;
   end record;

   -- 34.8.8 Interrupt and status register (USART_ISR)

   type USART_ISR_Type is
   record
      PE        : Boolean;     -- Parity Error
      FE        : Boolean;     -- Framing Error
      NF        : Boolean;     -- START bit Noise detection flag
      ORE       : Boolean;     -- Overrun error
      IDLE      : Boolean;     -- Idle line detected
      RXNE      : Boolean;     -- Read data register not empty
      TC        : Boolean;     -- Transmission complete
      TXE       : Boolean;     -- Transmit data register empty
      LBDF      : Boolean;     -- LIN break detection flag
      CTSIF     : Boolean;     -- CTS interrupt flag
      CTS       : Boolean;     -- CTS flag
      RTOF      : Boolean;     -- Receiver timeout
      EOBF      : Boolean;     -- End of block flag
      Reserved1 : Bits_1 := 0;
      ABRE      : Boolean;     -- Auto baud rate error
      ABRF      : Boolean;     -- Auto baud rate flag
      BUSY      : Boolean;     -- Busy flag
      CMF       : Boolean;     -- Character match flag
      SBKF      : Boolean;     -- Send break flag
      RWU       : Boolean;     -- Receiver wakeup from Mute mode
      WUF       : Boolean;     -- Wakeup from Stop mode flag
      TEACK     : Boolean;     -- Transmit enable acknowledge flag
      REACK     : Boolean;     -- Receive enable acknowledge flag
      Reserved2 : Bits_2 := 0;
      TCBGT     : Boolean;     -- Transmission complete before guard time completion.
      Reserved3 : Bits_6 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_ISR_Type use
   record
      PE        at 0 range  0 ..  0;
      FE        at 0 range  1 ..  1;
      NF        at 0 range  2 ..  2;
      ORE       at 0 range  3 ..  3;
      IDLE      at 0 range  4 ..  4;
      RXNE      at 0 range  5 ..  5;
      TC        at 0 range  6 ..  6;
      TXE       at 0 range  7 ..  7;
      LBDF      at 0 range  8 ..  8;
      CTSIF     at 0 range  9 ..  9;
      CTS       at 0 range 10 .. 10;
      RTOF      at 0 range 11 .. 11;
      EOBF      at 0 range 12 .. 12;
      Reserved1 at 0 range 13 .. 13;
      ABRE      at 0 range 14 .. 14;
      ABRF      at 0 range 15 .. 15;
      BUSY      at 0 range 16 .. 16;
      CMF       at 0 range 17 .. 17;
      SBKF      at 0 range 18 .. 18;
      RWU       at 0 range 19 .. 19;
      WUF       at 0 range 20 .. 20;
      TEACK     at 0 range 21 .. 21;
      REACK     at 0 range 22 .. 22;
      Reserved2 at 0 range 23 .. 24;
      TCBGT     at 0 range 25 .. 25;
      Reserved3 at 0 range 26 .. 31;
   end record;

   -- 34.8.9 Interrupt flag clear register (USART_ICR)

   type USART_ICR_Type is
   record
      PECF      : Boolean; -- Parity error clear flag
      FECF      : Boolean; -- Framing error clear flag
      NCF       : Boolean; -- Noise detected clear flag
      ORECF     : Boolean; -- Overrun error clear flag
      IDLECF    : Boolean; -- Idle line detected clear flag
      Reserved1 : Bits_1;
      TCCF      : Boolean; -- Transmission complete clear flag
      TCBGTCF   : Boolean; -- Transmission completed before guard time clear flag
      LBDCF     : Boolean; -- LIN break detection clear flag
      CTSCF     : Boolean; -- CTS clear flag
      Reserved2 : Bits_1;
      RTOCF     : Boolean; -- Receiver timeout clear flag
      EOBCF     : Boolean; -- End of block clear flag
      Reserved3 : Bits_4;
      CMCF      : Boolean; -- Character match clear flag
      Reserved4 : Bits_2;
      WUCF      : Boolean; -- Wakeup from Stop mode clear flag
      Reserved5 : Bits_11;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_ICR_Type use
   record
      PECF      at 0 range  0 ..  0;
      FECF      at 0 range  1 ..  1;
      NCF       at 0 range  2 ..  2;
      ORECF     at 0 range  3 ..  3;
      IDLECF    at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  5;
      TCCF      at 0 range  6 ..  6;
      TCBGTCF   at 0 range  7 ..  7;
      LBDCF     at 0 range  8 ..  8;
      CTSCF     at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 10;
      RTOCF     at 0 range 11 .. 11;
      EOBCF     at 0 range 12 .. 12;
      Reserved3 at 0 range 13 .. 16;
      CMCF      at 0 range 17 .. 17;
      Reserved4 at 0 range 18 .. 19;
      WUCF      at 0 range 20 .. 20;
      Reserved5 at 0 range 21 .. 31;
   end record;

   -- 34.8.10 Receive data register (USART_RDR)
   -- 34.8.11 Transmit data register (USART_TDR)

   type USART_DR_Type is
   record
      DR       : Unsigned_8;
      DR8      : Bits_1;
      Reserved : Bits_23 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for USART_DR_Type use
   record
      DR       at 0 range 0 ..  7;
      DR8      at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 34.8 USART registers

   type USART_Type is
   record
      USART_CR1  : USART_CR1_Type  with Volatile_Full_Access => True;
      USART_CR2  : USART_CR2_Type  with Volatile_Full_Access => True;
      USART_CR3  : USART_CR3_Type  with Volatile_Full_Access => True;
      USART_BRR  : USART_BRR_Type  with Volatile_Full_Access => True;
      USART_GTPR : USART_GTPR_Type with Volatile_Full_Access => True;
      USART_RTOR : USART_RTOR_Type with Volatile_Full_Access => True;
      USART_RQR  : USART_RQR_Type  with Volatile_Full_Access => True;
      USART_ISR  : USART_ISR_Type  with Volatile_Full_Access => True;
      USART_ICR  : USART_ICR_Type  with Volatile_Full_Access => True;
      USART_RDR  : USART_DR_Type;
      USART_TDR  : USART_DR_Type;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16#2C# * 8;
   for USART_Type use
   record
      USART_CR1  at 16#00# range 0 .. 31;
      USART_CR2  at 16#04# range 0 .. 31;
      USART_CR3  at 16#08# range 0 .. 31;
      USART_BRR  at 16#0C# range 0 .. 31;
      USART_GTPR at 16#10# range 0 .. 31;
      USART_RTOR at 16#14# range 0 .. 31;
      USART_RQR  at 16#18# range 0 .. 31;
      USART_ISR  at 16#1C# range 0 .. 31;
      USART_ICR  at 16#20# range 0 .. 31;
      USART_RDR  at 16#24# range 0 .. 31;
      USART_TDR  at 16#28# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_1000#;

   USART1 : aliased USART_Type with
      Address    => To_Address (USART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   USART6_BASEADDRESS : constant := 16#4001_1400#;

   USART6 : aliased USART_Type with
      Address    => To_Address (USART6_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32F769I;
