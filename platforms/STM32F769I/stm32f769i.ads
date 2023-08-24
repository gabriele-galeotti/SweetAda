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

   RCC_CR_ADDRESS : constant := 16#4002_3800#;

   RCC_CR : aliased RCC_CR_Type with
      Address              => To_Address (RCC_CR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.2 RCC PLL configuration register (RCC_PLLCFGR)

   PLLP_DIV2 : constant := 2#00#; -- PLLP = 2
   PLLP_DIV4 : constant := 2#01#; -- PLLP = 4
   PLLP_DIV6 : constant := 2#10#; -- PLLP = 6
   PLLP_DIV8 : constant := 2#11#; -- PLLP = 8

   PLLSRC_HSI : constant := 0; -- HSI clock selected as PLL and PLLI2S clock entry
   PLLSRC_HSE : constant := 1; -- HSE oscillator clock selected as PLL and PLLI2S clock entry

   type RCC_PLLCFGR_Type is
   record
      PLLM      : Bits_6 range 2 .. 63;   -- Division factor for the main PLLs (PLL, PLLI2S and PLLSAI) input clock
      PLLN      : Bits_9 range 50 .. 432; -- Main PLL (PLL) multiplication factor for VCO
      Reserved1 : Bits_1 := 0;
      PLLP      : Bits_2;                 -- Main PLL (PLL) division factor for main system clock
      Reserved2 : Bits_4 := 0;
      PLLSRC    : Bits_1;                 -- Main PLL(PLL) and audio PLL (PLLI2S) entry clock source
      Reserved3 : Bits_1 := 0;
      PLLQ      : Bits_4 range 2 .. 15;   -- Main PLL (PLL) division factor for USB OTG FS, SDMMC1/2 and [RNG] clocks
      PLLR      : Bits_3 range 2 ..7;     -- PLL division factor for DSI clock
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

   RCC_PLLCFGR_ADDRESS : constant := 16#4002_3804#;

   RCC_PLLCFGR : aliased RCC_PLLCFGR_Type with
      Address              => To_Address (RCC_PLLCFGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

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

   RCC_CFGR_ADDRESS : constant := 16#4002_3808#;

   RCC_CFGR : aliased RCC_CFGR_Type with
      Address              => To_Address (RCC_CFGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.4 RCC clock interrupt register (RCC_CIR)

   type RCC_CIR_Type is
   record
      LSIRDYF     : Boolean; -- LSI ready interrupt flag
      LSERDYF     : Boolean; -- LSE ready interrupt flag
      HSIRDYF     : Boolean; -- HSI ready interrupt flag
      HSERDYF     : Boolean; -- HSE ready interrupt flag
      PLLRDYF     : Boolean; -- Main PLL (PLL) ready interrupt flag
      PLLI2SRDYF  : Boolean; -- PLLI2S ready interrupt flag
      PLLSAIRDYF  : Boolean; -- PLLSAI Ready Interrupt flag
      CSSF        : Boolean; -- Clock security system interrupt flag
      LSIRDYIE    : Boolean; -- LSI ready interrupt enable
      LSERDYIE    : Boolean; -- LSE ready interrupt enable
      HSIRDYIE    : Boolean; -- HSI ready interrupt enable
      HSERDYIE    : Boolean; -- HSE ready interrupt enable
      PLLRDYIE    : Boolean; -- Main PLL (PLL) ready interrupt enable
      PLLI2SRDYIE : Boolean; -- PLLI2S ready interrupt enable
      PLLSAIRDYIE : Boolean; -- PLLSAI Ready Interrupt Enable
      Reserved1   : Bits_1;
      LSIRDYC     : Boolean; -- LSI ready interrupt clear
      LSERDYC     : Boolean; -- LSE ready interrupt clear
      HSIRDYC     : Boolean; -- HSI ready interrupt clear
      HSERDYC     : Boolean; -- HSE ready interrupt clear
      PLLRDYC     : Boolean; -- Main PLL(PLL) ready interrupt clear
      PLLI2SRDYC  : Boolean; -- PLLI2S ready interrupt clear
      PLLSAIRDYC  : Boolean; -- PLLSAI Ready Interrupt Clear
      CSSC        : Boolean; -- Clock security system interrupt clear
      Reserved2   : Bits_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_CIR_Type use
   record
      LSIRDYF     at 0 range  0 ..  0;
      LSERDYF     at 0 range  1 ..  1;
      HSIRDYF     at 0 range  2 ..  2;
      HSERDYF     at 0 range  3 ..  3;
      PLLRDYF     at 0 range  4 ..  4;
      PLLI2SRDYF  at 0 range  5 ..  5;
      PLLSAIRDYF  at 0 range  6 ..  6;
      CSSF        at 0 range  7 ..  7;
      LSIRDYIE    at 0 range  8 ..  8;
      LSERDYIE    at 0 range  9 ..  9;
      HSIRDYIE    at 0 range 10 .. 10;
      HSERDYIE    at 0 range 11 .. 11;
      PLLRDYIE    at 0 range 12 .. 12;
      PLLI2SRDYIE at 0 range 13 .. 13;
      PLLSAIRDYIE at 0 range 14 .. 14;
      Reserved1   at 0 range 15 .. 15;
      LSIRDYC     at 0 range 16 .. 16;
      LSERDYC     at 0 range 17 .. 17;
      HSIRDYC     at 0 range 18 .. 18;
      HSERDYC     at 0 range 19 .. 19;
      PLLRDYC     at 0 range 20 .. 20;
      PLLI2SRDYC  at 0 range 21 .. 21;
      PLLSAIRDYC  at 0 range 22 .. 22;
      CSSC        at 0 range 23 .. 23;
      Reserved2   at 0 range 24 .. 31;
   end record;

   RCC_CIR_ADDRESS : constant := 16#4002_380C#;

   RCC_CIR : aliased RCC_CIR_Type with
      Address              => To_Address (RCC_CIR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.5 RCC AHB1 peripheral reset register (RCC_AHB1RSTR)

   type RCC_AHB1RSTR_Type is
   record
      GPIOARST  : Boolean; -- IO port A reset
      GPIOBRST  : Boolean; -- IO port B reset
      GPIOCRST  : Boolean; -- IO port C reset
      GPIODRST  : Boolean; -- IO port D reset
      GPIOERST  : Boolean; -- IO port E reset
      GPIOFRST  : Boolean; -- IO port F reset
      GPIOGRST  : Boolean; -- IO port G reset
      GPIOHRST  : Boolean; -- IO port H reset
      GPIOIRST  : Boolean; -- IO port I reset
      GPIOJRST  : Boolean; -- IO port J reset
      GPIOKRST  : Boolean; -- IO port K reset
      Reserved1 : Bits_1;
      CRCRST    : Boolean; -- CRC reset
      Reserved2 : Bits_8;
      DMA1RST   : Boolean; -- DMA2 reset
      DMA2RST   : Boolean; -- DMA2 reset
      DMA2DRST  : Boolean; -- DMA2D reset
      Reserved3 : Bits_1;
      ETHMACRST : Boolean; -- Ethernet MAC reset
      Reserved4 : Bits_3;
      OTGHSRST  : Boolean; -- USB OTG HS module reset
      Reserved5 : Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB1RSTR_Type use
   record
      GPIOARST  at 0 range  0 ..  0;
      GPIOBRST  at 0 range  1 ..  1;
      GPIOCRST  at 0 range  2 ..  2;
      GPIODRST  at 0 range  3 ..  3;
      GPIOERST  at 0 range  4 ..  4;
      GPIOFRST  at 0 range  5 ..  5;
      GPIOGRST  at 0 range  6 ..  6;
      GPIOHRST  at 0 range  7 ..  7;
      GPIOIRST  at 0 range  8 ..  8;
      GPIOJRST  at 0 range  9 ..  9;
      GPIOKRST  at 0 range 10 .. 10;
      Reserved1 at 0 range 11 .. 11;
      CRCRST    at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 20;
      DMA1RST   at 0 range 21 .. 21;
      DMA2RST   at 0 range 22 .. 22;
      DMA2DRST  at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 24;
      ETHMACRST at 0 range 25 .. 25;
      Reserved4 at 0 range 26 .. 28;
      OTGHSRST  at 0 range 29 .. 29;
      Reserved5 at 0 range 30 .. 31;
   end record;

   RCC_AHB1RSTR_ADDRESS : constant := 16#4002_3810#;

   RCC_AHB1RSTR : aliased RCC_AHB1RSTR_Type with
      Address              => To_Address (RCC_AHB1RSTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.6 RCC AHB2 peripheral reset register (RCC_AHB2RSTR)

   type RCC_AHB2RSTR_Type is
   record
      DCMIRST   : Boolean; -- Camera interface reset
      JPEGRST   : Boolean; -- JPEG module reset
      Reserved1 : Bits_2;
      CRYPRST   : Boolean; -- Cryptographic module reset
      HASHRST   : Boolean; -- Hash module reset
      RNGRST    : Boolean; -- Random number generator module reset
      OTGFSRST  : Boolean; -- USB OTG FS module reset
      Reserved2 : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB2RSTR_Type use
   record
      DCMIRST   at 0 range 0 ..  0;
      JPEGRST   at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPRST   at 0 range 4 ..  4;
      HASHRST   at 0 range 5 ..  5;
      RNGRST    at 0 range 6 ..  6;
      OTGFSRST  at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2RSTR_ADDRESS : constant := 16#4002_3814#;

   RCC_AHB2RSTR : aliased RCC_AHB2RSTR_Type with
      Address              => To_Address (RCC_AHB2RSTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.7 RCC AHB3 peripheral reset register (RCC_AHB3RSTR)

   type RCC_AHB3RSTR_Type is
   record
      FMCRST   : Boolean; -- Flexible memory controller module reset
      QSPIRST  : Boolean; -- Quad SPI memory controller reset
      Reserved : Bits_30;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB3RSTR_Type use
   record
      FMCRST   at 0 range 0 ..  0;
      QSPIRST  at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3RSTR_ADDRESS : constant := 16#4002_3818#;

   RCC_AHB3RSTR : aliased RCC_AHB3RSTR_Type with
      Address              => To_Address (RCC_AHB3RSTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.8 RCC APB1 peripheral reset register (RCC_APB1RSTR)

   type RCC_APB1RSTR_Type is
   record
      TIM2RST    : Boolean; -- TIM2 reset
      TIM3RST    : Boolean; -- TIM3 reset
      TIM4RST    : Boolean; -- TIM4 reset
      TIM5RST    : Boolean; -- TIM5 reset
      TIM6RST    : Boolean; -- TIM6 reset
      TIM7RST    : Boolean; -- TIM7 reset
      TIM12RST   : Boolean; -- TIM12 reset
      TIM13RST   : Boolean; -- TIM13 reset
      TIM14RST   : Boolean; -- TIM14 reset
      LPTMI1RST  : Boolean; -- Low-power timer 1 reset
      Reserved1  : Bits_1;
      WWDGRST    : Boolean; -- Window watchdog reset
      Reserved2  : Bits_1;
      CAN3RST    : Boolean; -- CAN 3 reset
      SPI2RST    : Boolean; -- SPI2 reset
      SPI3RST    : Boolean; -- SPI3 reset
      SPDIFRXRST : Boolean; -- SPDIFRX reset
      USART2RST  : Boolean; -- USART2 reset
      USART3RST  : Boolean; -- USART3 reset
      UART4RST   : Boolean; -- UART4 reset
      UART5RST   : Boolean; -- UART5 reset
      I2C1RST    : Boolean; -- I2C1 reset
      I2C2RST    : Boolean; -- I2C2 reset
      I2C3RST    : Boolean; -- I2C3 reset
      I2C4RST    : Boolean; -- I2C4 reset
      CAN1RST    : Boolean; -- CAN 1 reset
      CAN2RST    : Boolean; -- CAN 2 reset
      CECRST     : Boolean; -- HDMI-CEC reset
      PWRRST     : Boolean; -- Power interface reset
      DACRST     : Boolean; -- DAC interface reset
      UART7RST   : Boolean; -- UART7 reset
      UART8RST   : Boolean; -- UART8 reset
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB1RSTR_Type use
   record
      TIM2RST    at 0 range  0  .. 0;
      TIM3RST    at 0 range  1  .. 1;
      TIM4RST    at 0 range  2  .. 2;
      TIM5RST    at 0 range  3  .. 3;
      TIM6RST    at 0 range  4  .. 4;
      TIM7RST    at 0 range  5  .. 5;
      TIM12RST   at 0 range  6  .. 6;
      TIM13RST   at 0 range  7  .. 7;
      TIM14RST   at 0 range  8  .. 8;
      LPTMI1RST  at 0 range  9  .. 9;
      Reserved1  at 0 range 10 .. 10;
      WWDGRST    at 0 range 11 .. 11;
      Reserved2  at 0 range 12 .. 12;
      CAN3RST    at 0 range 13 .. 13;
      SPI2RST    at 0 range 14 .. 14;
      SPI3RST    at 0 range 15 .. 15;
      SPDIFRXRST at 0 range 16 .. 16;
      USART2RST  at 0 range 17 .. 17;
      USART3RST  at 0 range 18 .. 18;
      UART4RST   at 0 range 19 .. 19;
      UART5RST   at 0 range 20 .. 20;
      I2C1RST    at 0 range 21 .. 21;
      I2C2RST    at 0 range 22 .. 22;
      I2C3RST    at 0 range 23 .. 23;
      I2C4RST    at 0 range 24 .. 24;
      CAN1RST    at 0 range 25 .. 25;
      CAN2RST    at 0 range 26 .. 26;
      CECRST     at 0 range 27 .. 27;
      PWRRST     at 0 range 28 .. 28;
      DACRST     at 0 range 29 .. 29;
      UART7RST   at 0 range 30 .. 30;
      UART8RST   at 0 range 31 .. 31;
   end record;

   RCC_APB1RSTR_ADDRESS : constant := 16#4002_3820#;

   RCC_APB1RSTR : aliased RCC_APB1RSTR_Type with
      Address              => To_Address (RCC_APB1RSTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.9 RCC APB2 peripheral reset register (RCC_APB2RSTR)

   type RCC_APB2RSTR_Type is
   record
      TIM1RST   : Boolean; -- TIM1 reset
      TIM8RST   : Boolean; -- TIM8 reset
      Reserved1 : Bits_2;
      USART1RST : Boolean; -- USART1 reset
      USART6RST : Boolean; -- USART6 reset
      Reserved2 : Bits_1;
      SDMMC2RST : Boolean; -- SDMMC2 module reset
      ADC1RST   : Boolean; -- ADC interface reset (common to all ADCs)
      Reserved3 : Bits_2;
      SDMMC1RST : Boolean; -- SDMMC1 reset
      SPI1RST   : Boolean; -- SPI1 reset
      SPI4RST   : Boolean; -- SPI4 reset
      SYSCFGRST : Boolean; -- System configuration controller reset
      Reserved4 : Bits_1;
      TIM9RST   : Boolean; -- TIM9 reset
      TIM10RST  : Boolean; -- TIM10 reset
      TIM11RST  : Boolean; -- TIM11 reset
      Reserved5 : Bits_1;
      SPI5RST   : Boolean; -- SPI5 reset
      SPI6RST   : Boolean; -- SPI6 reset
      SAI1RST   : Boolean; -- SAI1 reset
      SAI2RST   : Boolean; -- SAI2 reset
      Reserved6 : Bits_2;
      LTDCRST   : Boolean; -- LTDC reset
      DSIRST    : Boolean; -- DSIHOST module reset
      Reserved7 : Bits_1;
      DFSDM1RST : Boolean; -- DFSDM1 module reset
      MDIORST   : Boolean; -- MDIO module reset
      Reserved8 : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB2RSTR_Type use
   record
      TIM1RST   at 0 range  0 ..  0;
      TIM8RST   at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      USART1RST at 0 range  4 ..  4;
      USART6RST at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      SDMMC2RST at 0 range  7 ..  7;
      ADC1RST   at 0 range  8 ..  8;
      Reserved3 at 0 range  9 .. 10;
      SDMMC1RST at 0 range 11 .. 11;
      SPI1RST   at 0 range 12 .. 12;
      SPI4RST   at 0 range 13 .. 13;
      SYSCFGRST at 0 range 14 .. 14;
      Reserved4 at 0 range 15 .. 15;
      TIM9RST   at 0 range 16 .. 16;
      TIM10RST  at 0 range 17 .. 17;
      TIM11RST  at 0 range 18 .. 18;
      Reserved5 at 0 range 19 .. 19;
      SPI5RST   at 0 range 20 .. 20;
      SPI6RST   at 0 range 21 .. 21;
      SAI1RST   at 0 range 22 .. 22;
      SAI2RST   at 0 range 23 .. 23;
      Reserved6 at 0 range 24 .. 25;
      LTDCRST   at 0 range 26 .. 26;
      DSIRST    at 0 range 27 .. 27;
      Reserved7 at 0 range 28 .. 28;
      DFSDM1RST at 0 range 29 .. 29;
      MDIORST   at 0 range 30 .. 30;
      Reserved8 at 0 range 31 .. 31;
   end record;

   RCC_APB2RSTR_ADDRESS : constant := 16#4002_3824#;

   RCC_APB2RSTR : aliased RCC_APB2RSTR_Type with
      Address              => To_Address (RCC_APB2RSTR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.10 RCC AHB1 peripheral clock register (RCC_AHB1ENR)

   type RCC_AHB1ENR_Type is
   record
      GPIOAEN     : Boolean; -- IO port A clock enable
      GPIOBEN     : Boolean; -- IO port B clock enable
      GPIOCEN     : Boolean; -- IO port C clock enable
      GPIODEN     : Boolean; -- IO port D clock enable
      GPIOEEN     : Boolean; -- IO port E clock enable
      GPIOFEN     : Boolean; -- IO port F clock enable
      GPIOGEN     : Boolean; -- IO port G clock enable
      GPIOHEN     : Boolean; -- IO port H clock enable
      GPIOIEN     : Boolean; -- IO port I clock enable
      GPIOJEN     : Boolean; -- IO port J clock enable
      GPIOKEN     : Boolean; -- IO port K clock enable
      Reserved1   : Bits_1;
      CRCEN       : Boolean; -- CRC clock enable
      Reserved2   : Bits_5;
      BKPSRAMEN   : Boolean; -- Backup SRAM interface clock enable
      Reserved3   : Bits_1;
      DTCMRAMEN   : Boolean; -- DTCM data RAM clock enable
      DMA1EN      : Boolean; -- DMA1 clock enable
      DMA2EN      : Boolean; -- DMA2 clock enable
      DMA2DEN     : Boolean; -- DMA2D clock enable
      Reserved4   : Bits_1;
      ETHMACEN    : Boolean; -- Ethernet MAC clock enable
      ETHMACTXEN  : Boolean; -- Ethernet Transmission clock enable
      ETHMACRXEN  : Boolean; -- Ethernet Reception clock enable
      ETHMACPTPEN : Boolean; -- Ethernet PTP clock enable
      OTGHSEN     : Boolean; -- USB OTG HS clock enable
      OTGHSULPIEN : Boolean; -- USB OTG HSULPI clock enable
      Reserved5   : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB1ENR_Type use
   record
      GPIOAEN     at 0 range  0 ..  0;
      GPIOBEN     at 0 range  1 ..  1;
      GPIOCEN     at 0 range  2 ..  2;
      GPIODEN     at 0 range  3 ..  3;
      GPIOEEN     at 0 range  4 ..  4;
      GPIOFEN     at 0 range  5 ..  5;
      GPIOGEN     at 0 range  6 ..  6;
      GPIOHEN     at 0 range  7 ..  7;
      GPIOIEN     at 0 range  8 ..  8;
      GPIOJEN     at 0 range  9 ..  9;
      GPIOKEN     at 0 range 10 .. 10;
      Reserved1   at 0 range 11 .. 11;
      CRCEN       at 0 range 12 .. 12;
      Reserved2   at 0 range 13 .. 17;
      BKPSRAMEN   at 0 range 18 .. 18;
      Reserved3   at 0 range 19 .. 19;
      DTCMRAMEN   at 0 range 20 .. 20;
      DMA1EN      at 0 range 21 .. 21;
      DMA2EN      at 0 range 22 .. 22;
      DMA2DEN     at 0 range 23 .. 23;
      Reserved4   at 0 range 24 .. 24;
      ETHMACEN    at 0 range 25 .. 25;
      ETHMACTXEN  at 0 range 26 .. 26;
      ETHMACRXEN  at 0 range 27 .. 27;
      ETHMACPTPEN at 0 range 28 .. 28;
      OTGHSEN     at 0 range 29 .. 29;
      OTGHSULPIEN at 0 range 30 .. 30;
      Reserved5   at 0 range 31 .. 31;
   end record;

   RCC_AHB1ENR_ADDRESS : constant := 16#4002_3830#;

   RCC_AHB1ENR : aliased RCC_AHB1ENR_Type with
      Address              => To_Address (RCC_AHB1ENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.11 RCC AHB2 peripheral clock enable register (RCC_AHB2ENR)

   type RCC_AHB2ENR_Type is
   record
      DCMIEN    : Boolean; -- Camera interface enable
      JPEGEN    : Boolean; -- JPEG module clock enable
      Reserved1 : Bits_2;
      CRYPEN    : Boolean; -- Cryptographic modules clock enable
      HASHEN    : Boolean; -- Hash modules clock enable
      RNGEN     : Boolean; -- Random number generator clock enable
      OTGFSEN   : Boolean; -- USB OTG FS clock enable
      Reserved2 : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB2ENR_Type use
   record
      DCMIEN    at 0 range 0 ..  0;
      JPEGEN    at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPEN    at 0 range 4 ..  4;
      HASHEN    at 0 range 5 ..  5;
      RNGEN     at 0 range 6 ..  6;
      OTGFSEN   at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2ENR_ADDRESS : constant := 16#4002_3834#;

   RCC_AHB2ENR : aliased RCC_AHB2ENR_Type with
      Address              => To_Address (RCC_AHB2ENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.12 RCC AHB3 peripheral clock enable register (RCC_AHB3ENR)

   type RCC_AHB3ENR_Type is
   record
      FMCEN    : Boolean; -- Flexible memory controller clock enable
      QSPIEN   : Boolean; -- Quad SPI memory controller clock enable
      Reserved : Bits_30;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB3ENR_Type use
   record
      FMCEN    at 0 range 0 ..  0;
      QSPIEN   at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3ENR_ADDRESS : constant := 16#4002_3838#;

   RCC_AHB3ENR : aliased RCC_AHB3ENR_Type with
      Address              => To_Address (RCC_AHB3ENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

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
      I2C4EN    : Boolean; -- I2C4 clock enable
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
      I2C4EN    at 0 range 24 .. 24;
      CAN1EN    at 0 range 25 .. 25;
      CAN2EN    at 0 range 26 .. 26;
      CECEN     at 0 range 27 .. 27;
      PWREN     at 0 range 28 .. 28;
      DACEN     at 0 range 29 .. 29;
      UART7EN   at 0 range 30 .. 30;
      UART8EN   at 0 range 31 .. 31;
   end record;

   RCC_APB1ENR_ADDRESS : constant := 16#4002_3840#;

   RCC_APB1ENR : aliased RCC_APB1ENR_Type with
      Address              => To_Address (RCC_APB1ENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

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
      DFSDM1EN  : Boolean; -- DFSDM1 clock enable
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

   RCC_APB2ENR_ADDRESS : constant := 16#4002_3844#;

   RCC_APB2ENR : aliased RCC_APB2ENR_Type with
      Address              => To_Address (RCC_APB2ENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.15 RCC AHB1 peripheral clock enable in low-power mode register (RCC_AHB1LPENR)

   type RCC_AHB1LPENR_Type is
   record
      GPIOALPEN     : Boolean; -- IO port A clock enable during sleep mode
      GPIOBLPEN     : Boolean; -- IO port B clock enable during Sleep mode
      GPIOCLPEN     : Boolean; -- IO port C clock enable during Sleep mode
      GPIODLPEN     : Boolean; -- IO port D clock enable during Sleep mode
      GPIOELPEN     : Boolean; -- IO port E clock enable during Sleep mode
      GPIOFLPEN     : Boolean; -- IO port F clock enable during Sleep mode
      GPIOGLPEN     : Boolean; -- IO port G clock enable during Sleep mode
      GPIOHLPEN     : Boolean; -- IO port H clock enable during Sleep mode
      GPIOILPEN     : Boolean; -- IO port I clock enable during Sleep mode
      GPIOJLPEN     : Boolean; -- IO port J clock enable during Sleep mode
      GPIOKLPEN     : Boolean; -- IO port K clock enable during Sleep mode
      Reserved1     : Bits_1;
      CRCLPEN       : Boolean; -- CRC clock enable during Sleep mode
      AXILPEN       : Boolean; -- AXI to AHB bridge clock enable during Sleep mode
      Reserved2     : Bits_1;
      FLITFLPEN     : Boolean; -- Flash interface clock enable during Sleep mode
      SRAM1LPEN     : Boolean; -- SRAM1 interface clock enable during Sleep mode
      SRAM2LPEN     : Boolean; -- SRAM2 interface clock enable during Sleep mode
      BKPSRAMLPEN   : Boolean; -- Backup SRAM interface clock enable during Sleep mode
      Reserved3     : Bits_1;
      DTCMLPEN      : Boolean; -- DTCM RAM interface clock enable during Sleep mode
      DMA1LPEN      : Boolean; -- DMA1 clock enable during Sleep mode
      DMA2LPEN      : Boolean; -- DMA2 clock enable during Sleep mode
      DMA2DLPEN     : Boolean; -- DMA2D clock enable during Sleep mode
      Reserved4     : Bits_1;
      ETHMACLPEN    : Boolean; -- Ethernet MAC clock enable during Sleep mode
      ETHMACTXLPEN  : Boolean; -- Ethernet transmission clock enable during Sleep mode
      ETHMACRXLPEN  : Boolean; -- Ethernet reception clock enable during Sleep mode
      ETHMACPTPLPEN : Boolean; -- Ethernet PTP clock enable during Sleep mode
      OTGHSLPEN     : Boolean; -- USB OTG HS clock enable during Sleep mode
      OTGHSULPILPEN : Boolean; -- USB OTG HS ULPI clock enable during Sleep mode
      Reserved5     : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB1LPENR_Type use
   record
      GPIOALPEN     at 0 range  0 ..  0;
      GPIOBLPEN     at 0 range  1 ..  1;
      GPIOCLPEN     at 0 range  2 ..  2;
      GPIODLPEN     at 0 range  3 ..  3;
      GPIOELPEN     at 0 range  4 ..  4;
      GPIOFLPEN     at 0 range  5 ..  5;
      GPIOGLPEN     at 0 range  6 ..  6;
      GPIOHLPEN     at 0 range  7 ..  7;
      GPIOILPEN     at 0 range  8 ..  8;
      GPIOJLPEN     at 0 range  9 ..  9;
      GPIOKLPEN     at 0 range 10 .. 10;
      Reserved1     at 0 range 11 .. 11;
      CRCLPEN       at 0 range 12 .. 12;
      AXILPEN       at 0 range 13 .. 13;
      Reserved2     at 0 range 14 .. 14;
      FLITFLPEN     at 0 range 15 .. 15;
      SRAM1LPEN     at 0 range 16 .. 16;
      SRAM2LPEN     at 0 range 17 .. 17;
      BKPSRAMLPEN   at 0 range 18 .. 18;
      Reserved3     at 0 range 19 .. 19;
      DTCMLPEN      at 0 range 20 .. 20;
      DMA1LPEN      at 0 range 21 .. 21;
      DMA2LPEN      at 0 range 22 .. 22;
      DMA2DLPEN     at 0 range 23 .. 23;
      Reserved4     at 0 range 24 .. 24;
      ETHMACLPEN    at 0 range 25 .. 25;
      ETHMACTXLPEN  at 0 range 26 .. 26;
      ETHMACRXLPEN  at 0 range 27 .. 27;
      ETHMACPTPLPEN at 0 range 28 .. 28;
      OTGHSLPEN     at 0 range 29 .. 29;
      OTGHSULPILPEN at 0 range 30 .. 30;
      Reserved5     at 0 range 31 .. 31;
   end record;

   RCC_AHB1LPENR_ADDRESS : constant := 16#4002_3850#;

   RCC_AHB1LPENR : aliased RCC_AHB1LPENR_Type with
      Address              => To_Address (RCC_AHB1LPENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.16 RCC AHB2 peripheral clock enable in low-power mode register (RCC_AHB2LPENR)

   type RCC_AHB2LPENR_Type is
   record
      DCMILPEN  : Boolean; -- Camera interface enable during Sleep mode
      JPEGLPEN  : Boolean; -- JPEG module enabled during Sleep mode
      Reserved1 : Bits_2;
      CRYPLPEN  : Boolean; -- Cryptography modules clock enable during Sleep mode
      HASHLPEN  : Boolean; -- Hash modules clock enable during Sleep mode
      RNGLPEN   : Boolean; -- Random number generator clock enable during Sleep mode
      OTGFSLPEN : Boolean; -- USB OTG FS clock enable during Sleep mode
      Reserved2 : Bits_24;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB2LPENR_Type use
   record
      DCMILPEN  at 0 range 0 ..  0;
      JPEGLPEN  at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      CRYPLPEN  at 0 range 4 ..  4;
      HASHLPEN  at 0 range 5 ..  5;
      RNGLPEN   at 0 range 6 ..  6;
      OTGFSLPEN at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   RCC_AHB2LPENR_ADDRESS : constant := 16#4002_3854#;

   RCC_AHB2LPENR : aliased RCC_AHB2LPENR_Type with
      Address              => To_Address (RCC_AHB2LPENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.17 RCC AHB3 peripheral clock enable in low-power mode register (RCC_AHB3LPENR)

   type RCC_AHB3LPENR_Type is
   record
      FMCLPEN  : Boolean; -- Flexible memory controller module clock enable during Sleep mode
      QSPILPEN : Boolean; -- QUADSPI memory controller clock enable during Sleep mode
      Reserved : Bits_30;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_AHB3LPENR_Type use
   record
      FMCLPEN  at 0 range 0 ..  0;
      QSPILPEN at 0 range 1 ..  1;
      Reserved at 0 range 2 .. 31;
   end record;

   RCC_AHB3LPENR_ADDRESS : constant := 16#4002_3858#;

   RCC_AHB3LPENR : aliased RCC_AHB3LPENR_Type with
      Address              => To_Address (RCC_AHB3LPENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.18 RCC APB1 peripheral clock enable in low-power mode register (RCC_APB1LPENR)

   type RCC_APB1LPENR_Type is
   record
      TIM2LPEN    : Boolean; -- TIM2 clock enable during Sleep mode
      TIM3LPEN    : Boolean; -- TIM3 clock enable during Sleep mode
      TIM4LPEN    : Boolean; -- TIM4 clock enable during Sleep mode
      TIM5LPEN    : Boolean; -- TIM5 clock enable during Sleep mode
      TIM6LPEN    : Boolean; -- TIM6 clock enable during Sleep mode
      TIM7LPEN    : Boolean; -- TIM7 clock enable during Sleep mode
      TIM12LPEN   : Boolean; -- TIM12 clock enable during Sleep mode
      TIM13LPEN   : Boolean; -- Boolean; -- TIM13 clock enable during Sleep mode
      TIM14LPEN   : Boolean; -- TIM14 clock enable during Sleep mode
      LPTIM1LPEN  : Boolean; -- low-power timer 1 clock enable during Sleep mode
      RTCAPBLPEN  : Boolean; -- RTC register interface clock enable during Sleep mode
      WWDGLPEN    : Boolean; -- Window watchdog clock enable during Sleep mode
      Reserved    : Bits_1;
      CAN3LPEN    : Boolean; -- CAN 3 clock enable during Sleep mode
      SPI2LPEN    : Boolean; -- SPI2 clock enable during Sleep mode
      SPI3LPEN    : Boolean; -- SPI3 clock enable during Sleep mode
      SPDIFRXLPEN : Boolean; -- SPDIFRX clock enable during Sleep mode
      USART2LPEN  : Boolean; -- USART2 clock enable during Sleep mode
      USART3LPEN  : Boolean; -- USART3 clock enable during Sleep mode
      UART4LPEN   : Boolean; -- UART4 clock enable during Sleep mode
      UART5LPEN   : Boolean; -- UART5 clock enable during Sleep mode
      I2C1LPEN    : Boolean; -- I2C1 clock enable during Sleep mode
      I2C2LPEN    : Boolean; -- I2C2 clock enable during Sleep mode
      I2C3LPEN    : Boolean; -- I2C3 clock enable during Sleep mode
      I2C4LPEN    : Boolean; -- I2C4 clock enable during Sleep mode
      CAN1LPEN    : Boolean; -- CAN 1 clock enable during Sleep mode
      CAN2LPEN    : Boolean; -- CAN 2 clock enable during Sleep mode
      CECLPEN     : Boolean; -- HDMI-CEC clock enable during Sleep mode
      PWRLPEN     : Boolean; -- Power interface clock enable during Sleep mode
      DACLPEN     : Boolean; -- DAC interface clock enable during Sleep mode
      UART7LPEN   : Boolean; -- UART7 clock enable during Sleep mode
      UART8LPEN   : Boolean; -- UART8 clock enable during Sleep mode
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB1LPENR_Type use
   record
      TIM2LPEN    at 0 range  0 ..  0;
      TIM3LPEN    at 0 range  1 ..  1;
      TIM4LPEN    at 0 range  2 ..  2;
      TIM5LPEN    at 0 range  3 ..  3;
      TIM6LPEN    at 0 range  4 ..  4;
      TIM7LPEN    at 0 range  5 ..  5;
      TIM12LPEN   at 0 range  6 ..  6;
      TIM13LPEN   at 0 range  7 ..  7;
      TIM14LPEN   at 0 range  8 ..  8;
      LPTIM1LPEN  at 0 range  9 ..  9;
      RTCAPBLPEN  at 0 range 10 .. 10;
      WWDGLPEN    at 0 range 11 .. 11;
      Reserved    at 0 range 12 .. 12;
      CAN3LPEN    at 0 range 13 .. 13;
      SPI2LPEN    at 0 range 14 .. 14;
      SPI3LPEN    at 0 range 15 .. 15;
      SPDIFRXLPEN at 0 range 16 .. 16;
      USART2LPEN  at 0 range 17 .. 17;
      USART3LPEN  at 0 range 18 .. 18;
      UART4LPEN   at 0 range 19 .. 19;
      UART5LPEN   at 0 range 20 .. 20;
      I2C1LPEN    at 0 range 21 .. 21;
      I2C2LPEN    at 0 range 22 .. 22;
      I2C3LPEN    at 0 range 23 .. 23;
      I2C4LPEN    at 0 range 24 .. 24;
      CAN1LPEN    at 0 range 25 .. 25;
      CAN2LPEN    at 0 range 26 .. 26;
      CECLPEN     at 0 range 27 .. 27;
      PWRLPEN     at 0 range 28 .. 28;
      DACLPEN     at 0 range 29 .. 29;
      UART7LPEN   at 0 range 30 .. 30;
      UART8LPEN   at 0 range 31 .. 31;
   end record;

   RCC_APB1LPENR_ADDRESS : constant := 16#4002_3860#;

   RCC_APB1LPENR : aliased RCC_APB1LPENR_Type with
      Address              => To_Address (RCC_APB1LPENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.19 RCC APB2 peripheral clock enabled in low-power mode register (RCC_APB2LPENR)

   type RCC_APB2LPENR_Type is
   record
      TIM1LPEN   : Boolean; -- TIM1 clock enable during Sleep mode
      TIM8LPEN   : Boolean; -- TIM8 clock enable during Sleep mode
      Reserved1  : Bits_2;
      USART1LPEN : Boolean; -- USART1 clock enable during Sleep mode
      USART6LPEN : Boolean; -- USART6 clock enable during Sleep mode
      Reserved2  : Bits_1;
      SDMMC2LPEN : Boolean; -- SDMMC2 clock enable during Sleep mode
      ADC1LPEN   : Boolean; -- ADC1 clock enable during Sleep mode
      ADC2LPEN   : Boolean; -- ADC2 clock enable during Sleep mode
      ADC3LPEN   : Boolean; -- ADC 3 clock enable during Sleep mode
      SDMMC1LPEN : Boolean; -- SDMMC1 clock enable during Sleep mode
      SPI1LPEN   : Boolean; -- SPI1 clock enable during Sleep mode
      SPI4LPEN   : Boolean; -- SPI4 clock enable during Sleep mode
      SYSCFGLPEN : Boolean; -- System configuration controller clock enable during Sleep mode
      Reserved3  : Bits_1;
      TIM9LPEN   : Boolean; -- TIM9 clock enable during sleep mode
      TIM10LPEN  : Boolean; -- TIM10 clock enable during Sleep mode
      TIM11LPEN  : Boolean; -- TIM11 clock enable during Sleep mode
      Reserved4  : Bits_1;
      SPI5LPEN   : Boolean; -- SPI5 clock enable during Sleep mode
      SPI6LPEN   : Boolean; -- SPI6 clock enable during Sleep mode
      SAI1LPEN   : Boolean; -- SAI1 clock enable during Sleep mode
      SAI2LPEN   : Boolean; -- SAI2 clock enable during Sleep mode
      Reserved5  : Bits_2;
      LTDCLPEN   : Boolean; -- LTDC clock enable during Sleep mode
      DSILPEN    : Boolean; -- DSIHOST clock enable during Sleep mode
      Reserved6  : Bits_1;
      DFSDM1LPEN : Boolean; -- DFSDM1 clock enable during Sleep mode
      MDIOLPEN   : Boolean; -- MDIO clock enable during Sleep mode
      Reserved7  : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_APB2LPENR_Type use
   record
      TIM1LPEN   at 0 range  0 ..  0;
      TIM8LPEN   at 0 range  1 ..  1;
      Reserved1  at 0 range  2 ..  3;
      USART1LPEN at 0 range  4 ..  4;
      USART6LPEN at 0 range  5 ..  5;
      Reserved2  at 0 range  6 ..  6;
      SDMMC2LPEN at 0 range  7 ..  7;
      ADC1LPEN   at 0 range  8 ..  8;
      ADC2LPEN   at 0 range  9 ..  9;
      ADC3LPEN   at 0 range 10 .. 10;
      SDMMC1LPEN at 0 range 11 .. 11;
      SPI1LPEN   at 0 range 12 .. 12;
      SPI4LPEN   at 0 range 13 .. 13;
      SYSCFGLPEN at 0 range 14 .. 14;
      Reserved3  at 0 range 15 .. 15;
      TIM9LPEN   at 0 range 16 .. 16;
      TIM10LPEN  at 0 range 17 .. 17;
      TIM11LPEN  at 0 range 18 .. 18;
      Reserved4  at 0 range 19 .. 19;
      SPI5LPEN   at 0 range 20 .. 20;
      SPI6LPEN   at 0 range 21 .. 21;
      SAI1LPEN   at 0 range 22 .. 22;
      SAI2LPEN   at 0 range 23 .. 23;
      Reserved5  at 0 range 24 .. 25;
      LTDCLPEN   at 0 range 26 .. 26;
      DSILPEN    at 0 range 27 .. 27;
      Reserved6  at 0 range 28 .. 28;
      DFSDM1LPEN at 0 range 29 .. 29;
      MDIOLPEN   at 0 range 30 .. 30;
      Reserved7  at 0 range 31 .. 31;
   end record;

   RCC_APB2LPENR_ADDRESS : constant := 16#4002_3864#;

   RCC_APB2LPENR : aliased RCC_APB2LPENR_Type with
      Address              => To_Address (RCC_APB2LPENR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.20 RCC backup domain control register (RCC_BDCR)

   LSEDRV_LOW     : constant := 2#00#; -- Low driving capability
   LSEDRV_MEDHIGH : constant := 2#01#; -- Medium high driving capability
   LSEDRV_MEDLOW  : constant := 2#10#; -- Medium low driving capability
   LSEDRV_HIGH    : constant := 2#11#; -- High driving capability

   RTCSEL_NONE : constant := 2#00#; -- No clock
   RTCSEL_LSE  : constant := 2#01#; -- LSE oscillator clock used as the RTC clock
   RTCSEL_LSI  : constant := 2#10#; -- LSI oscillator clock used as the RTC clock
   RTCSEL_HSE  : constant := 2#11#; -- HSE oscillator clock divided by a programmable prescaler ...

   type RCC_BDCR_Type is
   record
      LSEON      : Boolean; -- External low-speed oscillator enable
      LSERDY     : Boolean; -- External low-speed oscillator ready
      LSEBYP     : Boolean; -- External low-speed oscillator bypass
      LSEDRV     : Bits_2;  -- LSE oscillator drive capability
      Reserved1  : Bits_3;
      RTCSEL     : Bits_2;  -- RTC clock source selection
      Reserved2  : Bits_5;
      RTCEN      : Boolean; -- RTC clock enable
      BDRST      : Boolean; -- Backup domain software reset
      Reserved3  : Bits_15;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_BDCR_Type use
   record
      LSEON      at 0 range  0 ..  0;
      LSERDY     at 0 range  1 ..  1;
      LSEBYP     at 0 range  2 ..  2;
      LSEDRV     at 0 range  3 ..  4;
      Reserved1  at 0 range  5 ..  7;
      RTCSEL     at 0 range  8 ..  9;
      Reserved2  at 0 range 10 .. 14;
      RTCEN      at 0 range 15 .. 15;
      BDRST      at 0 range 16 .. 16;
      Reserved3  at 0 range 17 .. 31;
   end record;

   RCC_BDCR_ADDRESS : constant := 16#4002_3870#;

   RCC_BDCR : aliased RCC_BDCR_Type with
      Address              => To_Address (RCC_BDCR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.21 RCC clock control & status register (RCC_CSR)

   type RCC_CSR_Type is
   record
      LSION    : Boolean; -- Internal low-speed oscillator enable
      LSIRDY   : Boolean; -- Internal low-speed oscillator ready
      Reserved : Bits_22;
      RMVF     : Boolean; -- Remove reset flag
      BORRSTF  : Boolean; -- BOR reset flag
      PINRSTF  : Boolean; -- PIN reset flag
      PORRSTF  : Boolean; -- POR/PDR reset flag
      SFTRSTF  : Boolean; -- Software reset flag
      IWDGRSTF : Boolean; -- Independent watchdog reset flag
      WWDGRSTF : Boolean; -- Window watchdog reset flag
      LPWRRSTF : Boolean; -- Low-power reset flag
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_CSR_Type use
   record
      LSION    at 0 range  0 ..  0;
      LSIRDY   at 0 range  1 ..  1;
      Reserved at 0 range  2 .. 23;
      RMVF     at 0 range 24 .. 24;
      BORRSTF  at 0 range 25 .. 25;
      PINRSTF  at 0 range 26 .. 26;
      PORRSTF  at 0 range 27 .. 27;
      SFTRSTF  at 0 range 28 .. 28;
      IWDGRSTF at 0 range 29 .. 29;
      WWDGRSTF at 0 range 30 .. 30;
      LPWRRSTF at 0 range 31 .. 31;
   end record;

   RCC_CSR_ADDRESS : constant := 16#4002_3874#;

   RCC_CSR : aliased RCC_CSR_Type with
      Address              => To_Address (RCC_CSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.22 RCC spread spectrum clock generation register (RCC_SSCGR)

   SPREADSEL_CENTER : constant := 0; -- Center spread
   SPREADSEL_DOWN   : constant := 1; -- Down spread

   type RCC_SSCGR_Type is
   record
      MODPER    : Bits_13; -- Modulation period
      INCSTEP   : Bits_15; -- Incrementation step
      Reserved  : Bits_2;
      SPREADSEL : Bits_1;  -- Spread Select
      SSCGEN    : Boolean; -- Spread spectrum modulation enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_SSCGR_Type use
   record
      MODPER    at 0 range  0 .. 12;
      INCSTEP   at 0 range 13 .. 27;
      Reserved  at 0 range 28 .. 29;
      SPREADSEL at 0 range 30 .. 30;
      SSCGEN    at 0 range 31 .. 31;
   end record;

   RCC_SSCGR_ADDRESS : constant := 16#4002_3880#;

   RCC_SSCGR : aliased RCC_SSCGR_Type with
      Address              => To_Address (RCC_SSCGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.23 RCC PLLI2S configuration register (RCC_PLLI2SCFGR)

   PLLI2SP_DIV2 : constant := 2#00#;
   PLLI2SP_DIV4 : constant := 2#01#;
   PLLI2SP_DIV6 : constant := 2#10#;
   PLLI2SP_DIV8 : constant := 2#11#;

   PLLI2SQ_DIV2  : constant := 2;
   PLLI2SQ_DIV3  : constant := 3;
   PLLI2SQ_DIV4  : constant := 4;
   PLLI2SQ_DIV5  : constant := 5;
   PLLI2SQ_DIV6  : constant := 6;
   PLLI2SQ_DIV7  : constant := 7;
   PLLI2SQ_DIV8  : constant := 8;
   PLLI2SQ_DIV9  : constant := 9;
   PLLI2SQ_DIV10 : constant := 10;
   PLLI2SQ_DIV11 : constant := 11;
   PLLI2SQ_DIV12 : constant := 12;
   PLLI2SQ_DIV13 : constant := 13;
   PLLI2SQ_DIV14 : constant := 14;
   PLLI2SQ_DIV15 : constant := 15;

   PLLI2R_DIV2 : constant := 2;
   PLLI2R_DIV3 : constant := 3;
   PLLI2R_DIV4 : constant := 4;
   PLLI2R_DIV5 : constant := 5;
   PLLI2R_DIV6 : constant := 6;
   PLLI2R_DIV7 : constant := 7;

   type RCC_PLLI2SCFGR_Type is
   record
      Reserved1 : Bits_6;
      PLLI2SN   : Bits_9 range 50 .. 432; -- PLLI2S multiplication factor for VCO
      Reserved2 : Bits_1;
      PLLI2SP   : Bits_2;                 -- PLLI2S division factor for SPDIFRX clock
      Reserved3 : Bits_6;
      PLLI2SQ   : Bits_4 range 2 .. 15;   -- PLLI2S division factor for SAIs clock
      PLLI2SR   : Bits_3 range 2 .. 7;    -- PLLI2S division factor for I2S clocks
      Reserved4 : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_PLLI2SCFGR_Type use
   record
      Reserved1 at 0 range  0 ..  5;
      PLLI2SN   at 0 range  6 .. 14;
      Reserved2 at 0 range 15 .. 15;
      PLLI2SP   at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 23;
      PLLI2SQ   at 0 range 24 .. 27;
      PLLI2SR   at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   RCC_PLLI2SCFGR_ADDRESS : constant := 16#4002_3884#;

   RCC_PLLI2SCFGR : aliased RCC_PLLI2SCFGR_Type with
      Address              => To_Address (RCC_PLLI2SCFGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.24 RCC PLLSAI configuration register (RCC_PLLSAICFGR)

   PLLSAIP_DIV2 : constant := 2#00#;
   PLLSAIP_DIV4 : constant := 2#01#;
   PLLSAIP_DIV6 : constant := 2#10#;
   PLLSAIP_DIV8 : constant := 2#11#;

   PLLSAIQ_DIV2  : constant := 2;
   PLLSAIQ_DIV3  : constant := 3;
   PLLSAIQ_DIV4  : constant := 4;
   PLLSAIQ_DIV5  : constant := 5;
   PLLSAIQ_DIV6  : constant := 6;
   PLLSAIQ_DIV7  : constant := 7;
   PLLSAIQ_DIV8  : constant := 8;
   PLLSAIQ_DIV9  : constant := 9;
   PLLSAIQ_DIV10 : constant := 10;
   PLLSAIQ_DIV11 : constant := 11;
   PLLSAIQ_DIV12 : constant := 12;
   PLLSAIQ_DIV13 : constant := 13;
   PLLSAIQ_DIV14 : constant := 14;
   PLLSAIQ_DIV15 : constant := 15;

   PLLSAIR_DIV2 : constant := 2;
   PLLSAIR_DIV3 : constant := 3;
   PLLSAIR_DIV4 : constant := 4;
   PLLSAIR_DIV5 : constant := 5;
   PLLSAIR_DIV6 : constant := 6;
   PLLSAIR_DIV7 : constant := 7;

   type RCC_PLLSAICFGR_Type is
   record
      Reserved1 : Bits_6;
      PLLSAIN   : Bits_9 range 50 .. 432; -- PLLSAI multiplication factor for VCO
      Reserved2 : Bits_1;
      PLLSAIP   : Bits_2;                 -- PLLSAI division factor for 48MHz clock
      Reserved3 : Bits_6;
      PLLSAIQ   : Bits_4 range 2 .. 15;   -- PLLSAI division factor for SAI clock
      PLLSAIR   : Bits_3 range 2 .. 7;    -- PLLSAI division factor for LCD clock
      Reserved4 : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_PLLSAICFGR_Type use
   record
      Reserved1 at 0 range  0 ..  5;
      PLLSAIN   at 0 range  6 .. 14;
      Reserved2 at 0 range 15 .. 15;
      PLLSAIP   at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 23;
      PLLSAIQ   at 0 range 24 .. 27;
      PLLSAIR   at 0 range 28 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   RCC_PLLSAICFGR_ADDRESS : constant := 16#4002_3888#;

   RCC_PLLSAICFGR : aliased RCC_PLLSAICFGR_Type with
      Address              => To_Address (RCC_PLLSAICFGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.25 RCC dedicated clocks configuration register (RCC_DCKCFGR1)

   PLLI2SorSAIDIVQ_NONE  : constant := 0;  -- PLLI2SorSAIDIVQ = /1
   PLLI2SorSAIDIVQ_DIV2  : constant := 1;  -- PLLI2SorSAIDIVQ = /2
   PLLI2SorSAIDIVQ_DIV3  : constant := 2;  -- PLLI2SorSAIDIVQ = /3
   PLLI2SorSAIDIVQ_DIV4  : constant := 3;  -- PLLI2SorSAIDIVQ = /4
   PLLI2SorSAIDIVQ_DIV5  : constant := 4;  -- PLLI2SorSAIDIVQ = /5
   PLLI2SorSAIDIVQ_DIV6  : constant := 5;  -- ..
   PLLI2SorSAIDIVQ_DIV7  : constant := 6;
   PLLI2SorSAIDIVQ_DIV8  : constant := 7;
   PLLI2SorSAIDIVQ_DIV9  : constant := 8;
   PLLI2SorSAIDIVQ_DIV10 : constant := 9;
   PLLI2SorSAIDIVQ_DIV11 : constant := 10;
   PLLI2SorSAIDIVQ_DIV12 : constant := 11;
   PLLI2SorSAIDIVQ_DIV13 : constant := 12;
   PLLI2SorSAIDIVQ_DIV14 : constant := 13;
   PLLI2SorSAIDIVQ_DIV15 : constant := 14;
   PLLI2SorSAIDIVQ_DIV16 : constant := 15;
   PLLI2SorSAIDIVQ_DIV17 : constant := 16;
   PLLI2SorSAIDIVQ_DIV18 : constant := 17;
   PLLI2SorSAIDIVQ_DIV19 : constant := 18;
   PLLI2SorSAIDIVQ_DIV20 : constant := 19;
   PLLI2SorSAIDIVQ_DIV21 : constant := 20;
   PLLI2SorSAIDIVQ_DIV22 : constant := 21;
   PLLI2SorSAIDIVQ_DIV23 : constant := 22;
   PLLI2SorSAIDIVQ_DIV24 : constant := 23;
   PLLI2SorSAIDIVQ_DIV25 : constant := 24;
   PLLI2SorSAIDIVQ_DIV26 : constant := 25;
   PLLI2SorSAIDIVQ_DIV27 : constant := 26;
   PLLI2SorSAIDIVQ_DIV28 : constant := 27;
   PLLI2SorSAIDIVQ_DIV29 : constant := 28;
   PLLI2SorSAIDIVQ_DIV30 : constant := 29;
   PLLI2SorSAIDIVQ_DIV31 : constant := 30;
   PLLI2SorSAIDIVQ_DIV32 : constant := 31; -- PLLI2SorSAIDIVQ = /32

   PLLSAIDIVR_DIV2  : constant := 2#00#; -- PLLSAIDIVR = /2
   PLLSAIDIVR_DIV4  : constant := 2#01#; -- PLLSAIDIVR = /4
   PLLSAIDIVR_DIV8  : constant := 2#10#; -- PLLSAIDIVR = /8
   PLLSAIDIVR_DIV16 : constant := 2#11#; -- PLLSAIDIVR = /16

   SAIxSEL_SAI    : constant := 2#00#; -- SAIx clock frequency = f(PLLSAI_Q) / PLLSAIDIVQ
   SAIxSEL_I2S    : constant := 2#01#; -- SAIx clock frequency = f(PLLI2S_Q) / PLLI2SDIVQ
   SAIxSEL_ALT    : constant := 2#10#; -- SAIx clock frequency = Alternate function input frequency
   SAIxSEL_HSIHSE : constant := 2#11#; -- SAIx clock frequency = HSI or HSE

   TIMPRE_2xPCLKx : constant := 0; -- If the APB prescaler ... 1, TIMxCLK = PCLKx. Otherwise ... TIMxCLK = 2xPCLKx.
   TIMPRE_4xPCLKx : constant := 1; -- If the APB prescaler ... 1, 2 or 4, TIMxCLK = HCLK. Otherwise ... TIMxCLK = 4xPCLKx.

   DFSDM1SEL_APB2   : constant := 0; -- APB2 clock (PCLK2) selected as DFSDM1 Kernel clock source
   DFSDM1SEL_SYSCLK : constant := 1; -- System clock (SYSCLK) clock selected as DFSDM1 Kernel clock source

   ADFSDM1SEL_SAI1 : constant := 0; -- SAI1 clock selected as DFSDM1 Audio clock source
   ADFSDM1SEL_SAI2 : constant := 1; -- SAI2 clock selected as DFSDM1 Audio clock source

   type RCC_DCKCFGR1_Type is
   record
      PLLI2SDIVQ : Bits_5; -- PLLI2S division factor for SAI1 clock
      Reserved1  : Bits_3;
      PLLSAIDIVQ : Bits_5; -- PLLSAI division factor for SAI1 clock
      Reserved2  : Bits_3;
      PLLSAIDIVR : Bits_2; -- division factor for LCD_CLK
      Reserved3  : Bits_2;
      SAI1SEL    : Bits_2; -- SAI1 clock source selection
      SAI2SEL    : Bits_2; -- SAI2 clock source selection:
      TIMPRE     : Bits_1; -- Timers clocks prescalers selection
      DFSDM1SEL  : Bits_1; -- DFSDM1 clock source selection:
      ADFSDM1SEL : Bits_1; -- DFSDM1 AUDIO clock source selection:
      Reserved4  : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_DCKCFGR1_Type use
   record
      PLLI2SDIVQ at 0 range  0 ..  4;
      Reserved1  at 0 range  5 ..  7;
      PLLSAIDIVQ at 0 range  8 .. 12;
      Reserved2  at 0 range 13 .. 15;
      PLLSAIDIVR at 0 range 16 .. 17;
      Reserved3  at 0 range 18 .. 19;
      SAI1SEL    at 0 range 20 .. 21;
      SAI2SEL    at 0 range 22 .. 23;
      TIMPRE     at 0 range 24 .. 24;
      DFSDM1SEL  at 0 range 25 .. 25;
      ADFSDM1SEL at 0 range 26 .. 26;
      Reserved4  at 0 range 27 .. 31;
   end record;

   RCC_DCKCFGR1_ADDRESS : constant := 16#4002_388C#;

   RCC_DCKCFGR1 : aliased RCC_DCKCFGR1_Type with
      Address              => To_Address (RCC_DCKCFGR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 5.3.26 RCC dedicated clocks configuration register (RCC_DCKCFGR2)

   USART1SEL_APB2 : constant := 2#00#; -- APB2 clock (PCLK2) is selected as USART 1 clock
   USART1SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 1 clock
   USART1SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 1 clock
   USART1SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 1 clock

   USART2SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as USART 2 clock
   USART2SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 2 clock
   USART2SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 2 clock
   USART2SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 2 clock

   USART3SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as USART 3 clock
   USART3SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 3 clock
   USART3SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 3 clock
   USART3SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 3 clock

   UART4SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 4 clock
   UART4SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 4 clock
   UART4SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 4 clock
   UART4SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 4 clock

   UART5SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 5 clock
   UART5SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 5 clock
   UART5SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 5 clock
   UART5SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 5 clock

   USART6SEL_APB2 : constant := 2#00#; -- APB2 clock (PCLK2) is selected as USART 6 clock
   USART6SEL_SYS  : constant := 2#01#; -- System clock is selected as USART 6 clock
   USART6SEL_HSI  : constant := 2#10#; -- HSI clock is selected as USART 6 clock
   USART6SEL_LSE  : constant := 2#11#; -- LSE clock is selected as USART 6 clock

   UART7SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 7 clock
   UART7SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 7 clock
   UART7SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 7 clock
   UART7SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 7 clock

   UART8SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) is selected as UART 8 clock
   UART8SEL_SYS  : constant := 2#01#; -- System clock is selected as UART 8 clock
   UART8SEL_HSI  : constant := 2#10#; -- HSI clock is selected as UART 8 clock
   UART8SEL_LSE  : constant := 2#11#; -- LSE clock is selected as UART 8 clock

   I2CxSEL_APB1 : constant := 2#00#; -- APB clock (PCLK1) is selected as I2Cx clock
   I2CxSEL_SYS  : constant := 2#01#; -- System clock is selected as I2Cx clock
   I2CxSEL_HSI  : constant := 2#10#; -- HSI clock is selected as I2Cx clock

   LPTIM1SEL_APB1 : constant := 2#00#; -- APB1 clock (PCLK1) selected as LPTILM1 clock
   LPTIM1SEL_LSI  : constant := 2#01#; -- LSI clock is selected as LPTILM1 clock
   LPTIM1SEL_HSI  : constant := 2#10#; -- HSI clock is selected as LPTILM1 clock
   LPTIM1SEL_LSE  : constant := 2#11#; -- LSE clock is selected as LPTILM1 clock

   CECSEL_LSE : constant := 0; -- LSE clock is selected as HDMI-CEC clock
   CECSEL_HSI : constant := 1; -- HSI divided by 488 clock is selected as HDMI-CEC clock

   CK48MSEL_PLL    : constant := 0; -- 48MHz clock from PLL is selected
   CK48MSEL_PLLSAI : constant := 1; -- 48MHz clock from PLLSAI is selected.

   SDMMCxSEL_48M : constant := 0; -- 48 MHz clock is selected as SDMMC1 clock
   SDMMCxSEL_SYS : constant := 1; -- System clock is selected as SDMMC1 clock

   DSISEL_DSIPHY : constant := 0; -- DSI-PHY used as DSI byte lane clock source (usual case)
   DSISEL_PLLR   : constant := 1; -- PLLR used as DSI byte lane clock source, used in case DSI PLL and DSI-PHY are off ...

   type RCC_DCKCFGR2_Type is
   record
      USART1SEL : Bits_2; -- USART 1 clock source selection
      USART2SEL : Bits_2; -- USART 2 clock source selection
      USART3SEL : Bits_2; -- USART 3 clock source selection
      UART4SEL  : Bits_2; -- UART 4 clock source selection
      UART5SEL  : Bits_2; -- UART 5 clock source selection
      USART6SEL : Bits_2; -- USART 6 clock source selection
      UART7SEL  : Bits_2; -- UART 7 clock source selection
      UART8SEL  : Bits_2; -- UART 8 clock source selection
      I2C1SEL   : Bits_2; -- I2C1 clock source selection
      I2C2SEL   : Bits_2; -- I2C2 clock source selection
      I2C3SEL   : Bits_2; -- I2C3 clock source selection
      I2C4SEL   : Bits_2; -- I2C4 clock source selection
      LPTIM1SEL : Bits_2; -- Low-power timer 1 clock source selection
      CECSEL    : Bits_1; -- HDMI-CEC clock source selection
      CK48MSEL  : Bits_1; -- 48MHz clock source selection
      SDMMC1SEL : Bits_1; -- SDMMC1 clock source selection
      SDMMC2SEL : Bits_1; -- SDMMC2 clock source selection
      DSISEL    : Bits_1; -- DSI clock source selection
      Reserved  : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for RCC_DCKCFGR2_Type use
   record
      USART1SEL at 0 range  0 ..  1;
      USART2SEL at 0 range  2 ..  3;
      USART3SEL at 0 range  4 ..  5;
      UART4SEL  at 0 range  6 ..  7;
      UART5SEL  at 0 range  8 ..  9;
      USART6SEL at 0 range 10 .. 11;
      UART7SEL  at 0 range 12 .. 13;
      UART8SEL  at 0 range 14 .. 15;
      I2C1SEL   at 0 range 16 .. 17;
      I2C2SEL   at 0 range 18 .. 19;
      I2C3SEL   at 0 range 20 .. 21;
      I2C4SEL   at 0 range 22 .. 23;
      LPTIM1SEL at 0 range 24 .. 25;
      CECSEL    at 0 range 26 .. 26;
      CK48MSEL  at 0 range 27 .. 27;
      SDMMC1SEL at 0 range 28 .. 28;
      SDMMC2SEL at 0 range 29 .. 29;
      DSISEL    at 0 range 30 .. 30;
      Reserved  at 0 range 31 .. 31;
   end record;

   RCC_DCKCFGR2_ADDRESS : constant := 16#4002_3890#;

   RCC_DCKCFGR2 : aliased RCC_DCKCFGR2_Type with
      Address              => To_Address (RCC_DCKCFGR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

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

   -- 7.2.2 SYSCFG peripheral mode configuration register (SYSCFG_PMC)

   MII_RMII_SEL_MII  : constant := 0; -- MII interface is selected
   MII_RMII_SEL_RMII : constant := 1; -- RMII PHY interface is selected

   type SYSCFG_PMC_Type is
   record
      I2C1_FMP     : Boolean; -- I2C1_FMP I2C1 Fast Mode + Enable
      I2C2_FMP     : Boolean; -- I2C2_FMP I2C2 Fast Mode + Enable
      I2C3_FMP     : Boolean; -- I2C3_FMP I2C3 Fast Mode + Enable
      I2C4_FMP     : Boolean; -- I2C4_FMP I2C4 Fast Mode + Enable
      PB6_FMP      : Boolean; -- PB6_FMP Fast Mode + Enable
      PB7_FMP      : Boolean; -- PB7_FMP Fast Mode + Enable
      PB8_FMP      : Boolean; -- PB8_FMP Fast Mode + Enable
      PB9_FMP      : Boolean; -- Fast Mode + Enable
      Reserved1    : Bits_8;
      ADC1DC2      : Boolean; -- ADC accuracy Option 2
      ADC2DC2      : Boolean; -- ADC accuracy Option 2
      ADC3DC2      : Boolean; -- ADC accuracy Option 2
      Reserved2    : Bits_4;
      MII_RMII_SEL : Bits_1;  -- Ethernet PHY interface selection
      Reserved3    : Bits_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_PMC_Type use
   record
      I2C1_FMP     at 0 range  0 ..  0;
      I2C2_FMP     at 0 range  1 ..  1;
      I2C3_FMP     at 0 range  2 ..  2;
      I2C4_FMP     at 0 range  3 ..  3;
      PB6_FMP      at 0 range  4 ..  4;
      PB7_FMP      at 0 range  5 ..  5;
      PB8_FMP      at 0 range  6 ..  6;
      PB9_FMP      at 0 range  7 ..  7;
      Reserved1    at 0 range  8 .. 15;
      ADC1DC2      at 0 range 16 .. 16;
      ADC2DC2      at 0 range 17 .. 17;
      ADC3DC2      at 0 range 18 .. 18;
      Reserved2    at 0 range 19 .. 22;
      MII_RMII_SEL at 0 range 23 .. 23;
      Reserved3    at 0 range 24 .. 31;
   end record;

   SYSCFG_PMC_ADDRESS : constant := 16#4001_3804#;

   SYSCFG_PMC : aliased SYSCFG_MEMRMP_Type with
      Address              => To_Address (SYSCFG_PMC_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 7.2.3 SYSCFG external interrupt configuration register 1 (SYSCFG_EXTICR1)
   -- 7.2.4 SYSCFG external interrupt configuration register 2 (SYSCFG_EXTICR2)
   -- 7.2.5 SYSCFG external interrupt configuration register 3 (SYSCFG_EXTICR3)
   -- 7.2.6 SYSCFG external interrupt configuration register 4 (SYSCFG_EXTICR4)

   EXTI_PA : constant := 2#0000#; -- PA[x] pin
   EXTI_PB : constant := 2#0001#; -- PB[x] pin
   EXTI_PC : constant := 2#0010#; -- PC[x] pin
   EXTI_PD : constant := 2#0011#; -- PD[x] pin
   EXTI_PE : constant := 2#0100#; -- PE[x] pin
   EXTI_PF : constant := 2#0101#; -- PF[x] pin
   EXTI_PG : constant := 2#0110#; -- PG[x] pin
   EXTI_PH : constant := 2#0111#; -- PH[x] pin
   EXTI_PI : constant := 2#1000#; -- PI[x] pin
   EXTI_PJ : constant := 2#1001#; -- PJ[x] pin
   EXTI_PK : constant := 2#1010#; -- PK[x] pin

   type SYSCFG_EXTICR1_Type is
   record
      EXTI0    : Bits_4;  -- EXTI 0 configuration
      EXTI1    : Bits_4;  -- EXTI 1 configuration
      EXTI2    : Bits_4;  -- EXTI 2 configuration
      EXTI3    : Bits_4;  -- EXTI 3 configuration
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_EXTICR1_Type use
   record
      EXTI0    at 0 range  0 ..  3;
      EXTI1    at 0 range  4 ..  7;
      EXTI2    at 0 range  8 .. 11;
      EXTI3    at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR1_ADDRESS : constant := 16#4001_3808#;

   SYSCFG_EXTICR1 : aliased SYSCFG_EXTICR1_Type with
      Address              => To_Address (SYSCFG_EXTICR1_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type SYSCFG_EXTICR2_Type is
   record
      EXTI4    : Bits_4;  -- EXTI 4 configuration
      EXTI5    : Bits_4;  -- EXTI 5 configuration
      EXTI6    : Bits_4;  -- EXTI 6 configuration
      EXTI7    : Bits_4;  -- EXTI 7 configuration
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_EXTICR2_Type use
   record
      EXTI4    at 0 range  0 ..  3;
      EXTI5    at 0 range  4 ..  7;
      EXTI6    at 0 range  8 .. 11;
      EXTI7    at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR2_ADDRESS : constant := 16#4001_380C#;

   SYSCFG_EXTICR2 : aliased SYSCFG_EXTICR2_Type with
      Address              => To_Address (SYSCFG_EXTICR2_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type SYSCFG_EXTICR3_Type is
   record
      EXTI8    : Bits_4;  -- EXTI 8 configuration
      EXTI9    : Bits_4;  -- EXTI 9 configuration
      EXTI10   : Bits_4;  -- EXTI 10 configuration
      EXTI11   : Bits_4;  -- EXTI 11 configuration
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_EXTICR3_Type use
   record
      EXTI8    at 0 range  0 ..  3;
      EXTI9    at 0 range  4 ..  7;
      EXTI10   at 0 range  8 .. 11;
      EXTI11   at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR3_ADDRESS : constant := 16#4001_3810#;

   SYSCFG_EXTICR3 : aliased SYSCFG_EXTICR3_Type with
      Address              => To_Address (SYSCFG_EXTICR3_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   type SYSCFG_EXTICR4_Type is
   record
      EXTI12   : Bits_4;  -- EXTI 12 configuration
      EXTI13   : Bits_4;  -- EXTI 13 configuration
      EXTI14   : Bits_4;  -- EXTI 14 configuration
      EXTI15   : Bits_4;  -- EXTI 15 configuration
      Reserved : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_EXTICR4_Type use
   record
      EXTI12   at 0 range  0 ..  3;
      EXTI13   at 0 range  4 ..  7;
      EXTI14   at 0 range  8 .. 11;
      EXTI15   at 0 range 12 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SYSCFG_EXTICR4_ADDRESS : constant := 16#4001_3814#;

   SYSCFG_EXTICR4 : aliased SYSCFG_EXTICR4_Type with
      Address              => To_Address (SYSCFG_EXTICR4_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 7.2.7 Class B register (SYSCFG_CBR)

   type SYSCFG_CBR_Type is
   record
      CLL       : Boolean; -- Core Lockup Lock
      Reserved1 : Bits_1;
      PVDL      : Boolean; -- PVD Lock
      Reserved2 : Bits_29;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_CBR_Type use
   record
      CLL       at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      PVDL      at 0 range 2 ..  2;
      Reserved2 at 0 range 3 .. 31;
   end record;

   SYSCFG_CBR_ADDRESS : constant := 16#4001_381C#;

   SYSCFG_CBR : aliased SYSCFG_CBR_Type with
      Address              => To_Address (SYSCFG_CBR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- 7.2.8 Compensation cell control register (SYSCFG_CMPCR)

   type SYSCFG_CMPCR_Type is
   record
      CMP_PD    : Boolean; -- Compensation cell power-down
      Reserved1 : Bits_7;
      READY     : Boolean; -- Compensation cell ready flag
      Reserved2 : Bits_23;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SYSCFG_CMPCR_Type use
   record
      CMP_PD    at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  7;
      READY     at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 31;
   end record;

   SYSCFG_CMPCR_ADDRESS : constant := 16#4001_3820#;

   SYSCFG_CMPCR : aliased SYSCFG_CMPCR_Type with
      Address              => To_Address (SYSCFG_CMPCR_ADDRESS),
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
   -- 28 Basic timers (TIM6/TIM7)
   ----------------------------------------------------------------------------

   -- 28.4.1 TIM6/TIM7 control register 1 (TIMx_CR1)

   URS_ANY          : constant := 0; -- Any of the following events generates ...
   URS_COUNTER_OFUF : constant := 1; -- Only counter overflow/underflow generates ..

   type TIMx_CR1_Type is
   record
      CEN       : Boolean; -- Counter enable
      UDIS      : Boolean; -- Update disable
      URS       : Bits_1;  -- Update request source
      OPM       : Boolean; -- One-pulse mode
      Reserved1 : Bits_3;
      ARPE      : Boolean; -- Auto-reload preload enable
      Reserved2 : Bits_3;
      UIFREMAP  : Boolean; -- UIF status bit remapping
      Reserved3 : Bits_4;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TIMx_CR1_Type use
   record
      CEN       at 0 range  0 ..  0;
      UDIS      at 0 range  1 ..  1;
      URS       at 0 range  2 ..  2;
      OPM       at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  6;
      ARPE      at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 10;
      UIFREMAP  at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 15;
   end record;

   -- 28.4.2 TIM6/TIM7 control register 2 (TIMx_CR2)

   MMS_RESET  : constant := 2#000#; -- the UG bit from the TIMx_EGR register is used as a trigger output (TRGO).
   MMS_ENABLE : constant := 2#001#; -- the Counter enable signal, CNT_EN, is used as a trigger output (TRGO).
   MMS_UPDATE : constant := 2#010#; -- The update event is selected as a trigger output (TRGO).

   type TIMx_CR2_Type is
   record
      Reserved1 : Bits_4;
      MMS       : Bits_3; -- Master mode selection
      Reserved2 : Bits_9;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TIMx_CR2_Type use
   record
      Reserved1 at 0 range 0 ..  3;
      MMS       at 0 range 4 ..  6;
      Reserved2 at 0 range 7 .. 15;
   end record;

   -- 28.4.3 TIM6/TIM7 DMA/Interrupt enable register (TIMx_DIER)

   type TIMx_DIER_Type is
   record
      UIE       : Boolean; -- Update interrupt enable
      Reserved1 : Bits_7;
      UDE       : Boolean; -- Update DMA request enable
      Reserved2 : Bits_7;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TIMx_DIER_Type use
   record
      UIE       at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  7;
      UDE       at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 15;
   end record;

   -- 28.4.4 TIM6/TIM7 status register (TIMx_SR)

   type TIMx_SR_Type is
   record
      UIF      : Boolean; -- Update interrupt flag
      Reserved : Bits_15;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TIMx_SR_Type use
   record
      UIF      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   -- 28.4.5 TIM6/TIM7 event generation register (TIMx_EGR)

   type TIMx_EGR_Type is
   record
      UG       : Boolean; -- Update generation
      Reserved : Bits_15;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TIMx_EGR_Type use
   record
      UG       at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 15;
   end record;

   -- 28.4.6 TIM6/TIM7 counter (TIMx_CNT)

   type TIMx_CNT_Type is
   record
      CNT      : Unsigned_16; -- Counter value
      Reserved : Bits_15;
      UIFCPY   : Boolean;     -- UIF Copy
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TIMx_CNT_Type use
   record
      CNT      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 30;
      UIFCPY   at 0 range 31 .. 31;
   end record;

   -- 28.4 TIM6/TIM7 registers

   type Basic_Timers_Type is
   record
      TIMx_CR1  : TIMx_CR1_Type  with Volatile_Full_Access => True;
      TIMx_CR2  : TIMx_CR2_Type  with Volatile_Full_Access => True;
      TIMx_DIER : TIMx_DIER_Type with Volatile_Full_Access => True;
      TIMx_SR   : TIMx_SR_Type   with Volatile_Full_Access => True;
      TIMx_EGR  : TIMx_EGR_Type  with Volatile_Full_Access => True;
      TIMx_CNT  : TIMx_CNT_Type  with Volatile_Full_Access => True;
      TIMx_PSC  : Unsigned_16    with Volatile_Full_Access => True;
      TIMx_ARR  : Unsigned_16    with Volatile_Full_Access => True;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16#30# * 8;
   for Basic_Timers_Type use
   record
      TIMx_CR1  at 16#00# range 0 .. 15;
      TIMx_CR2  at 16#04# range 0 .. 15;
      TIMx_DIER at 16#0C# range 0 .. 15;
      TIMx_SR   at 16#10# range 0 .. 15;
      TIMx_EGR  at 16#14# range 0 .. 15;
      TIMx_CNT  at 16#24# range 0 .. 31;
      TIMx_PSC  at 16#28# range 0 .. 15;
      TIMx_ARR  at 16#2C# range 0 .. 15;
   end record;

   TIM6_BASEADDRESS : constant := 16#4000_1000#;

   TIM6 : aliased Basic_Timers_Type with
      Address    => To_Address (TIM6_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TIM7_BASEADDRESS : constant := 16#4000_1400#;

   TIM7 : aliased Basic_Timers_Type with
      Address    => To_Address (TIM7_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

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

   USART2_BASEADDRESS : constant := 16#4000_4400#;

   USART2 : aliased USART_Type with
      Address    => To_Address (USART2_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   USART3_BASEADDRESS : constant := 16#4000_4800#;

   USART3 : aliased USART_Type with
      Address    => To_Address (USART3_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART4_BASEADDRESS : constant := 16#4000_4C00#;

   UART4 : aliased USART_Type with
      Address    => To_Address (UART4_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART5_BASEADDRESS : constant := 16#4000_5000#;

   UART5 : aliased USART_Type with
      Address    => To_Address (UART5_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   USART6_BASEADDRESS : constant := 16#4001_1400#;

   USART6 : aliased USART_Type with
      Address    => To_Address (USART6_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART7_BASEADDRESS : constant := 16#4000_7800#;

   UART7 : aliased USART_Type with
      Address    => To_Address (UART7_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART8_BASEADDRESS : constant := 16#4000_7C00#;

   UART8 : aliased USART_Type with
      Address    => To_Address (UART8_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32F769I;
