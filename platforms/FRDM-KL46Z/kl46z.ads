-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kl46z.ads                                                                                                 --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package KL46Z
   with Preelaborate => True
   is

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
   -- 4 Memory Map
   ----------------------------------------------------------------------------

   -- 4.6.2 Peripheral bridge (AIPS-lite) memory map

   SIM_BASEADDRESS       : constant := 16#4004_7000#;
   -- SIM_BASEADDRESS       : constant := 16#4004_8000#;
   PORTx_MUX_BASEADDRESS : constant := 16#4004_9000#;
   GPIO_BASEADDRESS      : constant := 16#400F_F000#;

   ----------------------------------------------------------------------------
   -- 11 Port Control and Interrupts (PORT)
   ----------------------------------------------------------------------------

   -- 11.5.1 Pin Control Register n
   -- base address + 0h offset + (4d x i), i = 0 .. 31

   MUX_Disabled  : constant := 2#000#;
   MUX_ALT1_GPIO : constant := 2#001#;
   MUX_ALT2      : constant := 2#010#;
   MUX_ALT3      : constant := 2#011#;
   MUX_ALT4      : constant := 2#100#;
   MUX_ALT5      : constant := 2#101#;
   MUX_ALT6      : constant := 2#110#;
   MUX_ALT7      : constant := 2#111#;

   IRQC_Disabled    : constant := 2#0000#;
   IRQC_DMA_Rising  : constant := 2#0001#;
   IRQC_DMA_Falling : constant := 2#0010#;
   IRQC_DMA_Either  : constant := 2#0011#;
   IRQC_IRQ_Zero    : constant := 2#1000#;
   IRQC_IRQ_Rising  : constant := 2#1001#;
   IRQC_IRQ_Falling : constant := 2#1010#;
   IRQC_IRQ_Either  : constant := 2#1011#;
   IRQC_IRQ_One     : constant := 2#1100#;

   type PORTx_PCRn_Type is record
      PS        : Boolean;     -- Pull Select
      PE        : Boolean;     -- Pull Enable
      SRE       : Boolean;     -- Slew Rate Enable
      Reserved1 : Bits_1 := 0;
      PFE       : Boolean;     -- Passive Filter Enable
      Reserved2 : Bits_1 := 0;
      DSE       : Boolean;     -- Drive Strength Enable
      Reserved3 : Bits_1 := 0;
      MUX       : Bits_3;      -- Pin Mux Control
      Reserved4 : Bits_5 := 0;
      IRQC      : Bits_4;      -- Interrupt Configuration
      Reserved5 : Bits_4 := 0;
      ISF       : Boolean;     -- Interrupt Status Flag
      Reserved6 : Bits_7 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_PCRn_Type use record
      PS        at 0 range  0 ..  0;
      PE        at 0 range  1 ..  1;
      SRE       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  3;
      PFE       at 0 range  4 ..  4;
      Reserved2 at 0 range  5 ..  5;
      DSE       at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  7;
      MUX       at 0 range  8 .. 10;
      Reserved4 at 0 range 11 .. 15;
      IRQC      at 0 range 16 .. 19;
      Reserved5 at 0 range 20 .. 23;
      ISF       at 0 range 24 .. 24;
      Reserved6 at 0 range 25 .. 31;
   end record;

   PORTA_PCR_BASEADDRESS : constant := PORTx_MUX_BASEADDRESS + 16#0000#;

   PORTA_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTA_PCR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTB_PCR_BASEADDRESS : constant := PORTx_MUX_BASEADDRESS + 16#1000#;

   PORTB_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTB_PCR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTC_PCR_BASEADDRESS : constant := PORTx_MUX_BASEADDRESS + 16#2000#;

   PORTC_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTC_PCR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTD_PCR_BASEADDRESS : constant := PORTx_MUX_BASEADDRESS + 16#3000#;

   PORTD_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTD_PCR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   PORTE_PCR_BASEADDRESS : constant := PORTx_MUX_BASEADDRESS + 16#4000#;

   PORTE_PCR : aliased array (0 .. 31) of PORTx_PCRn_Type
      with Address    => To_Address (PORTE_PCR_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 12 System Integration Module (SIM)
   ----------------------------------------------------------------------------

   -- 12.2.1 System Options Register 1 (SIM_SOPT1)

   OSC32KSEL_SYS  : constant := 2#00#; -- System oscillator (OSC32KCLK)
   OSC32KSEL_RSVD : constant := 2#01#; -- Reserved
   OSC32KSEL_RTC  : constant := 2#10#; -- RTC_CLKIN
   OSC32KSEL_LPO  : constant := 2#11#; -- LPO 1kHz

   type SIM_SOPT1_Type is record
      Reserved1 : Bits_6;
      Reserved2 : Bits_12 := 0;
      OSC32KSEL : Bits_2;       -- 32K oscillator clock select
      Reserved3 : Bits_9 := 0;
      USBVSTBY  : Boolean;      -- USB voltage regulator in standby mode during VLPR and VLPW modes
      USBSSTBY  : Boolean;      -- USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS modes.
      USBREGEN  : Boolean;      -- USB voltage regulator enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT1_Type use record
      Reserved1 at 0 range  0 ..  5;
      Reserved2 at 0 range  6 .. 17;
      OSC32KSEL at 0 range 18 .. 19;
      Reserved3 at 0 range 20 .. 28;
      USBVSTBY  at 0 range 29 .. 29;
      USBSSTBY  at 0 range 30 .. 30;
      USBREGEN  at 0 range 31 .. 31;
   end record;

   SIM_SOPT1_ADDRESS : constant := 16#4004_7000#;

   SIM_SOPT1 : aliased SIM_SOPT1_Type
      with Address              => To_Address (SIM_SOPT1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.2 SOPT1 Configuration Register (SIM_SOPT1CFG)

   type SIM_SOPT1CFG_Type is record
      Reserved1 : Bits_24 := 0;
      URWE      : Boolean;      -- USB voltage regulator enable write enable
      UVSWE     : Boolean;      -- USB voltage regulator VLP standby write enable
      USSWE     : Boolean;      -- USB voltage regulator stop standby write enable
      Reserved2 : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT1CFG_Type use record
      Reserved1 at 0 range  0 .. 23;
      URWE      at 0 range 24 .. 24;
      UVSWE     at 0 range 25 .. 25;
      USSWE     at 0 range 26 .. 26;
      Reserved2 at 0 range 27 .. 31;
   end record;

   SIM_SOPT1CFG_ADDRESS : constant := 16#4004_7004#;

   SIM_SOPT1CFG : aliased SIM_SOPT1CFG_Type
      with Address              => To_Address (SIM_SOPT1CFG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.3 System Options Register 2 (SIM_SOPT2)

   RTCCLKOUTSEL_RTC      : constant := 0; -- RTC 1 Hz clock is output on the RTC_CLKOUT pin.
   RTCCLKOUTSEL_OSCERCLK : constant := 1; -- OSCERCLK clock is output on the RTC_CLKOUT pin.

   CLKOUTSEL_Reserved1 : constant := 2#000#; -- Reserved
   CLKOUTSEL_Reserved2 : constant := 2#001#; -- Reserved
   CLKOUTSEL_BUSCLOCK  : constant := 2#010#; -- Bus clock
   CLKOUTSEL_LPO       : constant := 2#011#; -- LPO clock (1 kHz)
   CLKOUTSEL_MCGIRCLK  : constant := 2#100#; -- MCGIRCLK
   CLKOUTSEL_Reserved3 : constant := 2#101#; -- Reserved
   CLKOUTSEL_OSCERCLK  : constant := 2#110#; -- OSCERCLK
   CLKOUTSEL_Reserved4 : constant := 2#111#; -- Reserved

   PLLFLLSEL_MCGFLLCLK     : constant := 0; -- MCGFLLCLK clock
   PLLFLLSEL_MCGFLLCLKDIV2 : constant := 1; -- MCGPLLCLK clock with fixed divide by two

   USBSRC_EXT    : constant := 0; -- External bypass clock (USB_CLKIN).
   USBSRC_MCGxLL : constant := 1; -- MCGPLLCLK/2 or MCGFLLCLK clock

   TPMSRC_DISABLED  : constant := 2#00#; -- Clock disabled
   TPMSRC_MCGxLLCLK : constant := 2#01#; -- MCGFLLCLK clock or MCGPLLCLK/2
   TPMSRC_OSCERCLK  : constant := 2#10#; -- OSCERCLK clock
   TPMSRC_MCGIRCLK  : constant := 2#11#; -- MCGIRCLK clock

   UART0SRC_DISABLED  : constant := 2#00#; -- Clock disabled
   UART0SRC_MCGxLLCLK : constant := 2#01#; -- MCGFLLCLK clock or MCGPLLCLK/2
   UART0SRC_OSCERCLK  : constant := 2#10#; -- OSCERCLK clock
   UART0SRC_MCGIRCLK  : constant := 2#11#; -- MCGIRCLK clock

   type SIM_SOPT2_Type is record
      Reserved1    : Bits_4 := 0;
      RTCCLKOUTSEL : Bits_1;      -- RTC clock out select
      CLKOUTSEL    : Bits_3;      -- CLKOUT select
      Reserved2    : Bits_8 := 0;
      PLLFLLSEL    : Bits_1;      -- PLL/FLL clock select
      Reserved3    : Bits_1 := 0;
      USBSRC       : Bits_1;      -- USB clock source select
      Reserved4    : Bits_5 := 0;
      TPMSRC       : Bits_2;      -- TPM Clock Source Select
      UART0SRC     : Bits_2;      -- UART0 Clock Source Select
      Reserved5    : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT2_Type use record
      Reserved1    at 0 range  0 ..  3;
      RTCCLKOUTSEL at 0 range  4 ..  4;
      CLKOUTSEL    at 0 range  5 ..  7;
      Reserved2    at 0 range  8 .. 15;
      PLLFLLSEL    at 0 range 16 .. 16;
      Reserved3    at 0 range 17 .. 17;
      USBSRC       at 0 range 18 .. 18;
      Reserved4    at 0 range 19 .. 23;
      TPMSRC       at 0 range 24 .. 25;
      UART0SRC     at 0 range 26 .. 27;
      Reserved5    at 0 range 28 .. 31;
   end record;

   SIM_SOPT2_ADDRESS : constant := 16#4004_8004#;

   SIM_SOPT2 : aliased SIM_SOPT2_Type
      with Address              => To_Address (SIM_SOPT2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.4 System Options Register 4 (SIM_SOPT4)

   TPM1CH0SRC_TPM1_CH0 : constant := 2#00#; -- TPM1_CH0 signal
   TPM1CH0SRC_CMP0     : constant := 2#01#; -- CMP0 output
   TPM1CH0SRC_RSVD     : constant := 2#10#; -- Reserved
   TPM1CH0SRC_USB_SFRM : constant := 2#11#; -- USB start of frame pulse

   TPM2CH0SRC_TPM2_CH0 : constant := 0; -- TPM2_CH0 signal
   TPM2CH0SRC_CMP0     : constant := 1; -- CMP0 output

   TPM0CLKSEL_TPM_CLKIN0 : constant := 0; -- TPM0 external clock driven by TPM_CLKIN0 pin.
   TPM0CLKSEL_TPM_CLKIN1 : constant := 1; -- TPM0 external clock driven by TPM_CLKIN1 pin.

   TPM1CLKSEL_TPM_CLKIN0 : constant := 0; -- TPM1 external clock driven by TPM_CLKIN0 pin.
   TPM1CLKSEL_TPM_CLKIN1 : constant := 1; -- TPM1 external clock driven by TPM_CLKIN1 pin.

   TPM2CLKSEL_TPM_CLKIN0 : constant := 0; -- TPM2 external clock driven by TPM_CLKIN0 pin.
   TPM2CLKSEL_TPM_CLKIN1 : constant := 1; -- TPM2 external clock driven by TPM_CLKIN1 pin.

   type SIM_SOPT4_Type is record
      Reserved1  : Bits_18 := 0;
      TPM1CH0SRC : Bits_2;       -- TPM1 channel 0 input capture source select
      TPM2CH0SRC : Bits_1;       -- TPM2 channel 0 input capture source select
      Reserved2  : Bits_3 := 0;
      TPM0CLKSEL : Bits_1;       -- TPM0 External Clock Pin Select
      TPM1CLKSEL : Bits_1;       -- TPM1 External Clock Pin Select
      TPM2CLKSEL : Bits_1;       -- TPM2 External Clock Pin Select
      Reserved3  : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT4_Type use record
      Reserved1  at 0 range  0 .. 17;
      TPM1CH0SRC at 0 range 18 .. 19;
      TPM2CH0SRC at 0 range 20 .. 20;
      Reserved2  at 0 range 21 .. 23;
      TPM0CLKSEL at 0 range 24 .. 24;
      TPM1CLKSEL at 0 range 25 .. 25;
      TPM2CLKSEL at 0 range 26 .. 26;
      Reserved3  at 0 range 27 .. 31;
   end record;

   SIM_SOPT4_ADDRESS : constant := 16#4004_800C#;

   SIM_SOPT4 : aliased SIM_SOPT4_Type
      with Address              => To_Address (SIM_SOPT4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.5 System Options Register 5 (SIM_SOPT5)

   UARTnTXSRC_TX         : constant := 2#00#; -- UARTn_TX pin
   UARTnTXSRC_TXMODTPM10 : constant := 2#01#; -- UARTn_TX pin modulated with TPM1 channel 0 output
   UARTnTXSRC_TXMODTPM20 : constant := 2#10#; -- UARTn_TX pin modulated with TPM2 channel 0 output
   UARTnTXSRC_RSVD       : constant := 2#11#; -- Reserved

   UARTnRXSRC_RX   : constant := 0; -- UARTn_RX pin
   UARTnRXSRC_CMP0 : constant := 1; -- CMP0 output

   type SIM_SOPT5_Type is record
      UART0TXSRC : Bits_2;       -- UART0 Transmit Data Source Select
      UART0RXSRC : Bits_1;       -- UART0 Receive Data Source Select
      Reserved1  : Bits_1 := 0;
      UART1TXSRC : Bits_2;       -- UART1 Transmit Data Source Select
      UART1RXSRC : Bits_1;       -- UART1 Receive Data Source Select
      Reserved2  : Bits_9 := 0;
      UART0ODE   : Boolean;      -- UART0 Open Drain Enable
      UART1ODE   : Boolean;      -- UART1 Open Drain Enable
      UART2ODE   : Boolean;      -- UART2 Open Drain Enable
      Reserved3  : Bits_1 := 0;
      Reserved4  : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT5_Type use record
      UART0TXSRC at 0 range  0 ..  1;
      UART0RXSRC at 0 range  2 ..  2;
      Reserved1  at 0 range  3 ..  3;
      UART1TXSRC at 0 range  4 ..  5;
      UART1RXSRC at 0 range  6 ..  6;
      Reserved2  at 0 range  7 .. 15;
      UART0ODE   at 0 range 16 .. 16;
      UART1ODE   at 0 range 17 .. 17;
      UART2ODE   at 0 range 18 .. 18;
      Reserved3  at 0 range 19 .. 19;
      Reserved4  at 0 range 20 .. 31;
   end record;

   SIM_SOPT5_ADDRESS : constant := 16#4004_8010#;

   SIM_SOPT5 : aliased SIM_SOPT5_Type
      with Address              => To_Address (SIM_SOPT5_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.6 System Options Register 7 (SIM_SOPT7)

   ADC0TRGSEL_EXTRG     : constant := 2#0000#; -- External trigger pin input (EXTRG_IN)
   ADC0TRGSEL_CMP0      : constant := 2#0001#; -- CMP0 output
   ADC0TRGSEL_RSVD1     : constant := 2#0010#; -- Reserved
   ADC0TRGSEL_RSVD2     : constant := 2#0011#; -- Reserved
   ADC0TRGSEL_PITTRG0   : constant := 2#0100#; -- PIT trigger 0
   ADC0TRGSEL_PITTRG1   : constant := 2#0101#; -- PIT trigger 1
   ADC0TRGSEL_RSVD3     : constant := 2#0110#; -- Reserved
   ADC0TRGSEL_RSVD4     : constant := 2#0111#; -- Reserved
   ADC0TRGSEL_TPM0OVF   : constant := 2#1000#; -- TPM0 overflow
   ADC0TRGSEL_TPM1OVF   : constant := 2#1001#; -- TPM1 overflow
   ADC0TRGSEL_TPM2OVF   : constant := 2#1010#; -- TPM2 overflow
   ADC0TRGSEL_RSVD5     : constant := 2#1011#; -- Reserved
   ADC0TRGSEL_RTCALM    : constant := 2#1100#; -- RTC alarm
   ADC0TRGSEL_RTCSEC    : constant := 2#1101#; -- RTC seconds
   ADC0TRGSEL_LPTMR0TRG : constant := 2#1110#; -- LPTMR0 trigger
   ADC0TRGSEL_RSVD6     : constant := 2#1111#; -- Reserved

   ADC0PRETRGSEL_A : constant := 0; -- Pre-trigger A
   ADC0PRETRGSEL_B : constant := 1; -- Pre-trigger B

   type SIM_SOPT7_Type is record
      ADC0TRGSEL    : Bits_4;       -- ADC0 trigger select
      ADC0PRETRGSEL : Bits_1;       -- ADC0 Pretrigger Select
      Reserved1     : Bits_2 := 0;
      ADC0ALTTRGEN  : Boolean;      -- ADC0 Alternate Trigger Enable
      Reserved2     : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SOPT7_Type use record
      ADC0TRGSEL    at 0 range 0 ..  3;
      ADC0PRETRGSEL at 0 range 4 ..  4;
      Reserved1     at 0 range 5 ..  6;
      ADC0ALTTRGEN  at 0 range 7 ..  7;
      Reserved2     at 0 range 8 .. 31;
   end record;

   SIM_SOPT7_ADDRESS : constant := 16#4004_8018#;

   SIM_SOPT7 : aliased SIM_SOPT7_Type
      with Address              => To_Address (SIM_SOPT7_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.7 System Device Identification Register (SIM_SDID)

   PINID_16    : constant := 2#0000#; -- 16-pin
   PINID_24    : constant := 2#0001#; -- 24-pin
   PINID_32    : constant := 2#0010#; -- 32-pin
   PINID_36    : constant := 2#0011#; -- 36-pin
   PINID_48    : constant := 2#0100#; -- 48-pin
   PINID_64    : constant := 2#0101#; -- 64-pin
   PINID_80    : constant := 2#0110#; -- 80-pin
   PINID_RSVD1 : constant := 2#0111#; -- Reserved
   PINID_100   : constant := 2#1000#; -- 100-pin
   PINID_RSVD2 : constant := 2#1001#; -- Reserved
   PINID_RSVD3 : constant := 2#1010#; -- Reserved
   PINID_WLCSP : constant := 2#1011#; -- Custom pinout (WLCSP)
   PINID_RSVD4 : constant := 2#1100#; -- Reserved
   PINID_RSVD5 : constant := 2#1101#; -- Reserved
   PINID_RSVD6 : constant := 2#1110#; -- Reserved
   PINID_RSVD7 : constant := 2#1111#; -- Reserved

   SRAMSIZE_0K5 : constant := 2#0000#; -- 0.5 KB
   SRAMSIZE_1K  : constant := 2#0001#; -- 1 KB
   SRAMSIZE_2K  : constant := 2#0010#; -- 2 KB
   SRAMSIZE_4K  : constant := 2#0011#; -- 4 KB
   SRAMSIZE_8K  : constant := 2#0100#; -- 8 KB
   SRAMSIZE_16K : constant := 2#0101#; -- 16 KB
   SRAMSIZE_32K : constant := 2#0110#; -- 32 KB
   SRAMSIZE_64K : constant := 2#0111#; -- 64 KB

   SERIESID_KL : constant := 2#0001#; -- KL family

   SUBFAMID_KLx2 : constant := 2#0010#; -- KLx2 Subfamily (low end)
   SUBFAMID_KLx4 : constant := 2#0100#; -- KLx4 Subfamily (basic analog)
   SUBFAMID_KLx5 : constant := 2#0101#; -- KLx5 Subfamily (advanced analog)
   SUBFAMID_KLx6 : constant := 2#0110#; -- KLx6 Subfamily (advanced analog with I2S)
   SUBFAMID_KLx7 : constant := 2#0111#; -- KLx7 Subfamily (advanced analog with I2S and extended RAM)

   FAMID_KL0x : constant := 2#0000#; -- KL0x Family (low end)
   FAMID_KL1x : constant := 2#0001#; -- KL1x Family (basic)
   FAMID_KL2x : constant := 2#0010#; -- KL2x Family (USB)
   FAMID_KL3x : constant := 2#0011#; -- KL3x Family (Segment LCD)
   FAMID_KL4x : constant := 2#0100#; -- KL4x Family (USB and Segment LCD)

   type SIM_SDID_Type is record
      PINID    : Bits_4;      -- Pincount Identification
      Reserved : Bits_3 := 0;
      DIEID    : Bits_5;      -- Device Die Number
      REVID    : Bits_4;      -- Device Revision Number
      SRAMSIZE : Bits_4;      -- System SRAM Size
      SERIESID : Bits_4;      -- Kinetis Series ID
      SUBFAMID : Bits_4;      -- Kinetis Sub-Family ID
      FAMID    : Bits_4;      -- Kinetis family ID
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SDID_Type use record
      PINID    at 0 range  0 ..  3;
      Reserved at 0 range  4 ..  6;
      DIEID    at 0 range  7 .. 11;
      REVID    at 0 range 12 .. 15;
      SRAMSIZE at 0 range 16 .. 19;
      SERIESID at 0 range 20 .. 23;
      SUBFAMID at 0 range 24 .. 27;
      FAMID    at 0 range 28 .. 31;
   end record;

   SIM_SDID_ADDRESS : constant := 16#4004_8024#;

   SIM_SDID : aliased SIM_SDID_Type
      with Address              => To_Address (SIM_SDID_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.8 System Clock Gating Control Register 4 (SIM_SCGC4)

   type SIM_SCGC4_Type is record
      Reserved1 : Bits_4 := 0;
      Reserved2 : Bits_2 := 2#11#;
      I2C0      : Boolean;           -- I2C0 Clock Gate Control
      I2C1      : Boolean;           -- I2C1 Clock Gate Control
      Reserved3 : Bits_2 := 0;
      UART0     : Boolean;           -- UART0 Clock Gate Control
      UART1     : Boolean;           -- UART1 Clock Gate Control
      UART2     : Boolean;           -- UART2 Clock Gate Control
      Reserved4 : Bits_1 := 0;
      Reserved5 : Bits_4 := 0;
      USBOTG    : Boolean;           -- USB Clock Gate Control
      CMP       : Boolean;           -- Comparator Clock Gate Control
      Reserved6 : Bits_2 := 0;
      SPI0      : Boolean;           -- SPI0 Clock Gate Control
      SPI1      : Boolean;           -- SPI1 Clock Gate Control
      Reserved7 : Bits_4 := 0;
      Reserved8 : Bits_4 := 2#1111#;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC4_Type use record
      Reserved1 at 0 range  0 ..  3;
      Reserved2 at 0 range  4 ..  5;
      I2C0      at 0 range  6 ..  6;
      I2C1      at 0 range  7 ..  7;
      Reserved3 at 0 range  8 ..  9;
      UART0     at 0 range 10 .. 10;
      UART1     at 0 range 11 .. 11;
      UART2     at 0 range 12 .. 12;
      Reserved4 at 0 range 13 .. 13;
      Reserved5 at 0 range 14 .. 17;
      USBOTG    at 0 range 18 .. 18;
      CMP       at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 21;
      SPI0      at 0 range 22 .. 22;
      SPI1      at 0 range 23 .. 23;
      Reserved7 at 0 range 24 .. 27;
      Reserved8 at 0 range 28 .. 31;
   end record;

   SIM_SCGC4_ADDRESS : constant := SIM_BASEADDRESS + 16#1034#;

   SIM_SCGC4 : aliased SIM_SCGC4_Type
      with Address              => To_Address (SIM_SCGC4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.9 System Clock Gating Control Register 5 (SIM_SCGC5)

   type SIM_SCGC5_Type is record
      LPTMR     : Boolean;         -- Low Power Timer Access Control
      Reserved1 : Bits_1 := 1;
      Reserved2 : Bits_3 := 0;
      TSI       : Boolean;         -- TSI Access Control
      Reserved3 : Bits_1 := 0;
      Reserved4 : Bits_2 := 2#11#;
      PORTA     : Boolean;         -- PORTA Clock Gate Control
      PORTB     : Boolean;         -- PORTB Clock Gate Control
      PORTC     : Boolean;         -- PORTC Clock Gate Control
      PORTD     : Boolean;         -- PORTD Clock Gate Control
      PORTE     : Boolean;         -- PORTE Clock Gate Control
      Reserved5 : Bits_5 := 0;
      SLCD      : Boolean;         -- Segment LCD Clock Gate Control
      Reserved6 : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC5_Type use record
      LPTMR     at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      Reserved2 at 0 range  2 ..  4;
      TSI       at 0 range  5 ..  5;
      Reserved3 at 0 range  6 ..  6;
      Reserved4 at 0 range  7 ..  8;
      PORTA     at 0 range  9 ..  9;
      PORTB     at 0 range 10 .. 10;
      PORTC     at 0 range 11 .. 11;
      PORTD     at 0 range 12 .. 12;
      PORTE     at 0 range 13 .. 13;
      Reserved5 at 0 range 14 .. 18;
      SLCD      at 0 range 19 .. 19;
      Reserved6 at 0 range 20 .. 31;
   end record;

   SIM_SCGC5_ADDRESS : constant := SIM_BASEADDRESS + 16#1038#;

   SIM_SCGC5 : aliased SIM_SCGC5_Type
      with Address              => To_Address (SIM_SCGC5_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.12 System Clock Divider Register 1 (SIM_CLKDIV1)

   OUTDIV4_DIV1 : constant := 2#000#; -- Divide-by-1.
   OUTDIV4_DIV2 : constant := 2#001#; -- Divide-by-2.
   OUTDIV4_DIV3 : constant := 2#010#; -- Divide-by-3.
   OUTDIV4_DIV4 : constant := 2#011#; -- Divide-by-4.
   OUTDIV4_DIV5 : constant := 2#100#; -- Divide-by-5.
   OUTDIV4_DIV6 : constant := 2#101#; -- Divide-by-6.
   OUTDIV4_DIV7 : constant := 2#110#; -- Divide-by-7.
   OUTDIV4_DIV8 : constant := 2#111#; -- Divide-by-8.

   OUTDIV1_DIV1  : constant := 2#0000#; -- Divide-by-1.
   OUTDIV1_DIV2  : constant := 2#0001#; -- Divide-by-2.
   OUTDIV1_DIV3  : constant := 2#0010#; -- Divide-by-3.
   OUTDIV1_DIV4  : constant := 2#0011#; -- Divide-by-4.
   OUTDIV1_DIV5  : constant := 2#0100#; -- Divide-by-5.
   OUTDIV1_DIV6  : constant := 2#0101#; -- Divide-by-6.
   OUTDIV1_DIV7  : constant := 2#0110#; -- Divide-by-7.
   OUTDIV1_DIV8  : constant := 2#0111#; -- Divide-by-8.
   OUTDIV1_DIV9  : constant := 2#1000#; -- Divide-by-9.
   OUTDIV1_DIV10 : constant := 2#1001#; -- Divide-by-10.
   OUTDIV1_DIV11 : constant := 2#1010#; -- Divide-by-11.
   OUTDIV1_DIV12 : constant := 2#1011#; -- Divide-by-12.
   OUTDIV1_DIV13 : constant := 2#1100#; -- Divide-by-13.
   OUTDIV1_DIV14 : constant := 2#1101#; -- Divide-by-14.
   OUTDIV1_DIV15 : constant := 2#1110#; -- Divide-by-15.
   OUTDIV1_DIV16 : constant := 2#1111#; -- Divide-by-16.

   type SIM_CLKDIV1_Type is record
      Reserved1 : Bits_16 := 0;
      OUTDIV4   : Bits_3;       -- Clock 4 Output Divider value
      Reserved2 : Bits_9 := 0;
      OUTDIV1   : Bits_4;       -- Clock 1 Output Divider value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_CLKDIV1_Type use record
      Reserved1 at 0 range  0 .. 15;
      OUTDIV4   at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 27;
      OUTDIV1   at 0 range 28 .. 31;
   end record;

   SIM_CLKDIV1_ADDRESS : constant := 16#4004_8044#;

   SIM_CLKDIV1 : aliased SIM_CLKDIV1_Type
      with Address              => To_Address (SIM_CLKDIV1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 39 Universal Asynchronous Receiver/Transmitter (UART0)
   ----------------------------------------------------------------------------

   -- 39.2.1 UART Baud Rate Register High (UARTx_BDH)

   SBNS_1 : constant := 0; -- One stop bit.
   SBNS_2 : constant := 1; -- Two stop bit.

   type UARTx_BDH_Type is record
      SBR     : Bits_5;  -- Baud Rate Modulo Divisor.
      SBNS    : Bits_1;  -- Stop Bit Number Select
      RXEDGIE : Boolean; -- RX Input Active Edge Interrupt Enable (for RXEDGIF)
      LBKDIE  : Boolean; -- LIN Break Detect Interrupt Enable (for LBKDIF)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_BDH_Type use record
      SBR     at 0 range 0 .. 4;
      SBNS    at 0 range 5 .. 5;
      RXEDGIE at 0 range 6 .. 6;
      LBKDIE  at 0 range 7 .. 7;
   end record;

   -- 39.2.3 UART Control Register 1 (UARTx_C1)

   PT_EVEN : constant := 0; -- Even parity.
   PT_ODD  : constant := 1; -- Odd parity.

   ILT_START : constant := 0; -- Idle character bit count starts after start bit.
   ILT_STOP  : constant := 1; -- Idle character bit count starts after stop bit.

   WAKE_IDLELINE : constant := 0; -- Idle-line wakeup.
   WAKE_ADDRMARK : constant := 1; -- Address-mark wakeup.

   M_8 : constant := 0; -- Receiver and transmitter use 8-bit data characters.
   M_9 : constant := 1; -- Receiver and transmitter use 9-bit data characters.

   RSRC_LOOPBACK  : constant := 0; -- Provided LOOPS is set, RSRC is cleared, selects internal loop back mode and the UART ...
   RSRC_UART1WIRE : constant := 1; -- Single-wire UART mode where the UART_TX pin is connected to the transmitter output and ...

   LOOPS_NORMAL        : constant := 0; -- Normal operation - UART_RX and UART_TX use separate pins.
   LOOPS_LOOPUART1WIRE : constant := 1; -- Loop mode or single-wire mode where transmitter outputs are internally connected ...

   type UARTx_C1_Type is record
      PT     : Bits_1;  -- Parity Type
      PE     : Boolean; -- Parity Enable
      ILT    : Bits_1;  -- Idle Line Type Select
      WAKE   : Bits_1;  -- Receiver Wakeup Method Select
      M      : Bits_1;  -- 9-Bit or 8-Bit Mode Select
      RSRC   : Bits_1;  -- Receiver Source Select
      DOZEEN : Boolean; -- Doze Enable
      LOOPS  : Bits_1;  -- Loop Mode Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C1_Type use record
      PT     at 0 range 0 .. 0;
      PE     at 0 range 1 .. 1;
      ILT    at 0 range 2 .. 2;
      WAKE   at 0 range 3 .. 3;
      M      at 0 range 4 .. 4;
      RSRC   at 0 range 5 .. 5;
      DOZEEN at 0 range 6 .. 6;
      LOOPS  at 0 range 7 .. 7;
   end record;

   -- 39.2.4 UART Control Register 2 (UARTx_C2)

   type UARTx_C2_Type is record
      SBK  : Boolean; -- Send Break
      RWU  : Boolean; -- Receiver Wakeup Control
      RE   : Boolean; -- Receiver Enable
      TE   : Boolean; -- Transmitter Enable
      ILIE : Boolean; -- Idle Line Interrupt Enable for IDLE
      RIE  : Boolean; -- Receiver Interrupt Enable for RDRF
      TCIE : Boolean; -- Transmission Complete Interrupt Enable for TC
      TIE  : Boolean; -- Transmit Interrupt Enable for TDRE
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C2_Type use record
      SBK  at 0 range 0 .. 0;
      RWU  at 0 range 1 .. 1;
      RE   at 0 range 2 .. 2;
      TE   at 0 range 3 .. 3;
      ILIE at 0 range 4 .. 4;
      RIE  at 0 range 5 .. 5;
      TCIE at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 39.2.5 UART Status Register 1 (UARTx_S1)

   type UARTx_S1_Type is record
      PF   : Boolean := False; -- Parity Error Flag
      FE   : Boolean := False; -- Framing Error Flag
      NF   : Boolean := False; -- Noise Flag
      OVR  : Boolean := False; -- Receiver Overrun Flag
      IDLE : Boolean := False; -- Idle Line Flag
      RDRF : Boolean := False; -- Receive Data Register Full Flag
      TC   : Boolean := True;  -- Transmission Complete Flag
      TDRE : Boolean := True;  -- Transmit Data Register Empty Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_S1_Type use record
      PF   at 0 range 0 .. 0;
      FE   at 0 range 1 .. 1;
      NF   at 0 range 2 .. 2;
      OVR  at 0 range 3 .. 3;
      IDLE at 0 range 4 .. 4;
      RDRF at 0 range 5 .. 5;
      TC   at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   -- 39.2.6 UART Status Register 2 (UARTx_S2)

   type UARTx_S2_Type is record
      RAF     : Boolean; -- Receiver Active Flag
      LBKDE   : Boolean; -- LIN Break Detection Enable
      BRK13   : Boolean; -- Break Character Generation Length
      RWUID   : Boolean; -- Receive Wake Up Idle Detect
      RXINV   : Boolean; -- Receive Data Inversion
      MSBF    : Boolean; -- MSB First
      RXEDGIF : Boolean; -- UART_RX Pin Active Edge Interrupt Flag
      LBKDIF  : Boolean; -- LIN Break Detect Interrupt Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_S2_Type use record
      RAF     at 0 range 0 .. 0;
      LBKDE   at 0 range 1 .. 1;
      BRK13   at 0 range 2 .. 2;
      RWUID   at 0 range 3 .. 3;
      RXINV   at 0 range 4 .. 4;
      MSBF    at 0 range 5 .. 5;
      RXEDGIF at 0 range 6 .. 6;
      LBKDIF  at 0 range 7 .. 7;
   end record;

   -- 39.2.7 UART Control Register 3 (UARTx_C3)

   type UARTx_C3_Type is record
      PEIE  : Boolean; -- Parity Error Interrupt Enable
      FEIE  : Boolean; -- Framing Error Interrupt Enable
      NEIE  : Boolean; -- Noise Error Interrupt Enable
      ORIE  : Boolean; -- Overrun Interrupt Enable
      TXINV : Boolean; -- Transmit Data Inversion
      TXDIR : Boolean; -- UART_TX Pin Direction in Single-Wire Mode
      R9T8  : Boolean; -- Receive Bit 9 / Transmit Bit 8
      R8T9  : Boolean; -- Receive Bit 8 / Transmit Bit 9
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C3_Type use record
      PEIE  at 0 range 0 .. 0;
      FEIE  at 0 range 1 .. 1;
      NEIE  at 0 range 2 .. 2;
      ORIE  at 0 range 3 .. 3;
      TXINV at 0 range 4 .. 4;
      TXDIR at 0 range 5 .. 5;
      R9T8  at 0 range 6 .. 6;
      R8T9  at 0 range 7 .. 7;
   end record;

   -- 39.2.9 UART Match Address Registers 1 (UARTx_MA1)
   -- 39.2.10 UART Match Address Registers 2 (UARTx_MA2)
   -- 39.2.11 UART Control Register 4 (UARTx_C4)
   -- 39.2.12 UART Control Register 5 (UARTx_C5)

   -- 39.2 Register definition

   type UART_0_Type is record
        BDH : UARTx_BDH_Type with Volatile_Full_Access => True;
        BDL : Unsigned_8     with Volatile_Full_Access => True;
        C1  : UARTx_C1_Type  with Volatile_Full_Access => True;
        C2  : UARTx_C2_Type  with Volatile_Full_Access => True;
        S1  : UARTx_C1_Type  with Volatile_Full_Access => True;
        S2  : UARTx_C2_Type  with Volatile_Full_Access => True;
        C3  : UARTx_C3_Type  with Volatile_Full_Access => True;
        D   : Unsigned_8     with Volatile_Full_Access => True;
   end record
      with Size => 8 * 8;
   for UART_0_Type use record
        BDH at 0 range 0 .. 7;
        BDL at 1 range 0 .. 7;
        C1  at 2 range 0 .. 7;
        C2  at 3 range 0 .. 7;
        S1  at 4 range 0 .. 7;
        S2  at 5 range 0 .. 7;
        C3  at 6 range 0 .. 7;
        D   at 7 range 0 .. 7;
   end record;

   UART0_BASEADDRESS : constant := 16#4006_A000#;

   UART0 : aliased UART_0_Type
      with Address    => To_Address (UART0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 40 Universal Asynchronous Receiver/Transmitter (UART1 and UART2)
   ----------------------------------------------------------------------------

   -- 40.2.9 UART Control Register 4 (UARTx_C4)

   type UARTx_C4_Type is record
      Reserved1 : Bits_3 := 0;
      Reserved2 : Bits_1 := 0;
      Reserved3 : Bits_1 := 0;
      RDMAS     : Boolean;     -- Receiver Full DMA Select
      Reserved4 : Bits_1 := 0;
      TDMAS     : Boolean;     -- Transmitter DMA Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_C4_Type use record
      Reserved1 at 0 range 0 .. 2;
      Reserved2 at 0 range 3 .. 3;
      Reserved3 at 0 range 4 .. 4;
      RDMAS     at 0 range 5 .. 5;
      Reserved4 at 0 range 6 .. 6;
      TDMAS     at 0 range 7 .. 7;
   end record;

   -- 40.2 Register definition

   type UART_12_Type is record
        BDH : UARTx_BDH_Type with Volatile_Full_Access => True;
        BDL : Unsigned_8     with Volatile_Full_Access => True;
        C1  : UARTx_C1_Type  with Volatile_Full_Access => True;
        C2  : UARTx_C2_Type  with Volatile_Full_Access => True;
        S1  : UARTx_C1_Type  with Volatile_Full_Access => True;
        S2  : UARTx_C2_Type  with Volatile_Full_Access => True;
        C3  : UARTx_C3_Type  with Volatile_Full_Access => True;
        D   : Unsigned_8     with Volatile_Full_Access => True;
        C4  : UARTx_C4_Type  with Volatile_Full_Access => True;
   end record
      with Size => 9 * 8;
   for UART_12_Type use record
        BDH at 0 range 0 .. 7;
        BDL at 1 range 0 .. 7;
        C1  at 2 range 0 .. 7;
        C2  at 3 range 0 .. 7;
        S1  at 4 range 0 .. 7;
        S2  at 5 range 0 .. 7;
        C3  at 6 range 0 .. 7;
        D   at 7 range 0 .. 7;
        C4  at 8 range 0 .. 7;
   end record;

   UART1_BASEADDRESS : constant := 16#4006_B000#;

   UART1 : aliased UART_12_Type
      with Address    => To_Address (UART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART2_BASEADDRESS : constant := 16#4006_C000#;

   UART2 : aliased UART_12_Type
      with Address    => To_Address (UART2_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 42 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   -- 42.2.1 Port Data Output Register

   type GPIOx_PDOR_Type is new Bitmap_32;

   -- 42.2.2 Port Set Output Register

   type GPIOx_PSOR_Type is new Bitmap_32;

   -- 42.2.3 Port Clear Output Register

   type GPIOx_PCOR_Type is new Bitmap_32;

   -- 42.2.4 Port Toggle Output Register

   type GPIOx_PTOR_Type is new Bitmap_32;

   -- 42.2.5 Port Data Input Register

   type GPIOx_PDIR_Type is new Bitmap_32;

   -- 42.2.6 Port Data Direction Register

   type GPIOx_PDDR_Type is new Bitmap_32;

   -- Port A

   GPIOA_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#00#;
   GPIOA_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#04#;
   GPIOA_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#08#;
   GPIOA_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#0C#;
   GPIOA_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#10#;
   GPIOA_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#14#;

   GPIOA_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOA_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOA_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOA_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOA_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOA_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOA_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- Port B

   GPIOB_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#40#;
   GPIOB_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#44#;
   GPIOB_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#48#;
   GPIOB_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#4C#;
   GPIOB_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#50#;
   GPIOB_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#54#;

   GPIOB_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOB_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOB_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOB_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOB_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOB_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- Port C

   GPIOC_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#80#;
   GPIOC_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#84#;
   GPIOC_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#88#;
   GPIOC_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#8C#;
   GPIOC_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#90#;
   GPIOC_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#94#;

   GPIOC_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOC_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOC_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOC_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOC_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOC_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOC_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- Port D

   GPIOD_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C0#;
   GPIOD_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C4#;
   GPIOD_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#C8#;
   GPIOD_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#CC#;
   GPIOD_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#D0#;
   GPIOD_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#D4#;

   GPIOD_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOD_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOD_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOD_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOD_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOD_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOD_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- Port E

   GPIOE_PDOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#100#;
   GPIOE_PSOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#104#;
   GPIOE_PCOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#108#;
   GPIOE_PTOR_ADDRESS : constant := GPIO_BASEADDRESS + 16#10C#;
   GPIOE_PDIR_ADDRESS : constant := GPIO_BASEADDRESS + 16#110#;
   GPIOE_PDDR_ADDRESS : constant := GPIO_BASEADDRESS + 16#114#;

   GPIOE_PDOR : aliased GPIOx_PDOR_Type
      with Address    => To_Address (GPIOE_PDOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PSOR : aliased GPIOx_PSOR_Type
      with Address    => To_Address (GPIOE_PSOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PCOR : aliased GPIOx_PCOR_Type
      with Address    => To_Address (GPIOE_PCOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PTOR : aliased GPIOx_PTOR_Type
      with Address    => To_Address (GPIOE_PTOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PDIR : aliased GPIOx_PDIR_Type
      with Address    => To_Address (GPIOE_PDIR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE_PDDR : aliased GPIOx_PDDR_Type
      with Address    => To_Address (GPIOE_PDDR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end KL46Z;
