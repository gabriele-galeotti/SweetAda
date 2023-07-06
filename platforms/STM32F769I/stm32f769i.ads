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
      LPDS      at 0 range 0 .. 0;
      PDDS      at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      CSBF      at 0 range 3 .. 3;
      PVDE      at 0 range 4 .. 4;
      PLS       at 0 range 5 .. 7;
      DBP       at 0 range 8 .. 8;
      FPDS      at 0 range 9 .. 9;
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
      WUIF      at 0 range 0 .. 0;
      SBF       at 0 range 1 .. 1;
      PVDO      at 0 range 2 .. 2;
      BRR       at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 8;
      BRE       at 0 range 9 .. 9;
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
      CWUPF1    at 0 range 0 .. 0;
      CWUPF2    at 0 range 1 .. 1;
      CWUPF3    at 0 range 2 .. 2;
      CWUPF4    at 0 range 3 .. 3;
      CWUPF5    at 0 range 4 .. 4;
      CWUPF6    at 0 range 5 .. 5;
      Reserved1 at 0 range 6 .. 7;
      WUPP1     at 0 range 8 .. 8;
      WUPP2     at 0 range 9 .. 9;
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
      WUPF1     at 0 range 0 .. 0;
      WUPF2     at 0 range 1 .. 1;
      WUPF3     at 0 range 2 .. 2;
      WUPF4     at 0 range 3 .. 3;
      WUPF5     at 0 range 4 .. 4;
      WUPF6     at 0 range 5 .. 5;
      Reserved1 at 0 range 6 .. 7;
      EWUP1     at 0 range 8 .. 8;
      EWUP2     at 0 range 9 .. 9;
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
      HSION     at 0 range 0 .. 0;
      HSIRDY    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      HSITRIM   at 0 range 3 .. 7;
      HSICAL    at 0 range 8 .. 15;
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
      PLLM      at 0 range 0 .. 5;
      PLLN      at 0 range 6 .. 14;
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
      SW        at 0 range 0 .. 1;
      SWS       at 0 range 2 .. 3;
      HPRE      at 0 range 4 .. 7;
      Reserved1 at 0 range 8 .. 9;
      PPRE1     at 0 range 10 .. 12;
      PPRE2     at 0 range 13 .. 15;
      RTCPRE    at 0 range 16 .. 20;
      MCO1      at 0 range 21 .. 22;
      I2SSCR    at 0 range 23 .. 23;
      MCO1PRE   at 0 range 24 .. 26;
      MCO2PRE   at 0 range 27 .. 29;
      MCO2      at 0 range 30 .. 31;
   end record;

   -- 5.3 RCC registers

   type RCC_Type is
   record
      RCC_CR      : RCC_CR_Type      with Volatile_Full_Access => True;
      RCC_PLLCFGR : RCC_PLLCFGR_Type with Volatile_Full_Access => True;
      RCC_CFGR    : RCC_CFGR_Type    with Volatile_Full_Access => True;
   end record with
      Size                    => 3 * 32,
      Suppress_Initialization => True;
   for RCC_Type use
   record
      RCC_CR      at 16#00# range 0 .. 31;
      RCC_PLLCFGR at 16#04# range 0 .. 31;
      RCC_CFGR    at 16#08# range 0 .. 31;
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
      SET at 0 range 0 .. 15;
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
      LCK      at 0 range 0 .. 15;
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
   GPIOJ_BASEADDRESS : constant := 16#4002_2400#;

   GPIOA : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOA_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   GPIOJ : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOJ_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 34 Universal synchronous asynchronous receiver transmitter (USART)
   ----------------------------------------------------------------------------

   -- 34.8.1 Control register 1 (USART_CR1)

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
      UE       at 0 range 0 .. 0;
      UESM     at 0 range 1 .. 1;
      RE       at 0 range 2 .. 2;
      TE       at 0 range 3 .. 3;
      IDLEIE   at 0 range 4 .. 4;
      RXNEIE   at 0 range 5 .. 5;
      TCIE     at 0 range 6 .. 6;
      TXEIE    at 0 range 7 .. 7;
      PEIE     at 0 range 8 .. 8;
      PS       at 0 range 9 .. 9;
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
      PE        at 0 range 0 .. 0;
      FE        at 0 range 1 .. 1;
      NF        at 0 range 2 .. 2;
      ORE       at 0 range 3 .. 3;
      IDLE      at 0 range 4 .. 4;
      RXNE      at 0 range 5 .. 5;
      TC        at 0 range 6 .. 6;
      TXE       at 0 range 7 .. 7;
      LBDF      at 0 range 8 .. 8;
      CTSIF     at 0 range 9 .. 9;
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
      DR       at 0 range 0 .. 7;
      DR8      at 0 range 8 .. 8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 34.8 USART registers

   type USART_Type is
   record
      USART_CR1 : USART_CR1_Type with Volatile_Full_Access => True;
      USART_ISR : USART_ISR_Type with Volatile_Full_Access => True;
      USART_RDR : USART_DR_Type;
      USART_TDR : USART_DR_Type;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16#2C# * 8;
   for USART_Type use
   record
      USART_CR1 at 16#00# range 0 .. 31;
      USART_ISR at 16#1C# range 0 .. 31;
      USART_RDR at 16#24# range 0 .. 31;
      USART_TDR at 16#28# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_1000#;

   USART1 : aliased USART_Type with
      Address    => To_Address (USART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32F769I;
