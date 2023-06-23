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

   -- 5.3 RCC registers

   type RCC_Type is
   record
      RCC_CR : RCC_CR_Type with Volatile_Full_Access => True;
   end record with
      Size                    => 32,
      Suppress_Initialization => True;
   for RCC_Type use
   record
      RCC_CR at 16#00# range 0 .. 31;
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
