-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32f769i.ads                                                                                            --
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

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- RCC
   ----------------------------------------------------------------------------

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

   RCC_BASEADDRESS : constant := 16#4002_3800#;

   RCC_CIR : constant := RCC_BASEADDRESS + 16#0C#;

   ----------------------------------------------------------------------------
   -- GPIO
   ----------------------------------------------------------------------------

   GPIO_IN  : constant := 2#00#; -- Input mode (reset state)
   GPIO_OUT : constant := 2#01#; -- General purpose output mode
   GPIO_ALT : constant := 2#10#; -- Alternate function mode
   GPIO_ANL : constant := 2#11#; -- Analog mode

   type GPIOx_MODER_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

   GPIO_PP : constant := 0; -- Output push-pull (reset state)
   GPIO_OD : constant := 1; -- Output open-drain

pragma Warnings (Off, "bits of * unused");
   type GPIOx_OTYPER_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;
pragma Warnings (On, "bits of * unused");

   GPIO_LO : constant := 2#00#; -- Low speed
   GPIO_MS : constant := 2#01#; -- Medium speed
   GPIO_HI : constant := 2#10#; -- High speed
   GPIO_VH : constant := 2#11#; -- Very high speed

   type GPIOx_OSPEEDR_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

   GPIO_NOPUPD : constant := 2#00#; -- No pull-up, pull-down
   GPIO_PU     : constant := 2#01#; -- Pull-up
   GPIO_PD     : constant := 2#10#; -- Pull-down

   type GPIOx_PUPDR_Type is array (0 .. 15) of Bits_2 with
      Size => 32,
      Pack => True;

pragma Warnings (Off, "bits of * unused");
   type GPIOx_IDR_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;
pragma Warnings (On, "bits of * unused");

pragma Warnings (Off, "bits of * unused");
   type GPIOx_ODR_Type is array (0 .. 15) of Bits_1 with
      Size => 32,
      Pack => True;
pragma Warnings (On, "bits of * unused");

   type BSRR_SET_Type is array (0 .. 15) of Boolean with Pack => True;
   type BSRR_RST_Type is array (0 .. 15) of Boolean with Pack => True;

   type GPIOx_BSRR_Type is
   record
      SET : BSRR_SET_Type;
      RST : BSRR_RST_Type;
   end record with
      Size => 32;
   for GPIOx_BSRR_Type use
   record
      SET at 0 range 0 .. 15;
      RST at 0 range 16 .. 31;
   end record;

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
      -- LCKR configuration lock register
      -- AFRL alternate function low register
      -- AFRH alternate function high register
      -- BRR  bit reset register
   end record with
      Size => 16#1C# * 8;
   for GPIO_PORT_Type use
   record
      MODER   at 16#00# range 0 .. 31;
      OTYPER  at 16#04# range 0 .. 31;
      OSPEEDR at 16#08# range 0 .. 31;
      PUPDR   at 16#0C# range 0 .. 31;
      IDR     at 16#10# range 0 .. 31;
      ODR     at 16#14# range 0 .. 31;
      BSRR    at 16#18# range 0 .. 31;
   end record;

   GPIOJ_BASEADDRESS : constant := 16#4002_2400#;

   GPIOJ : aliased GPIO_PORT_Type with
      Address    => To_Address (GPIOJ_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32F769I;
