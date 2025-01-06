-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kl46z.ads                                                                                                 --
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

with System;
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
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- KL46P121M48SF4RM
   -- Rev. 3, July 2013
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 11 Port Control and Interrupts (PORT)
   ----------------------------------------------------------------------------

   PORT_MUXCTRL_BASEADDRESS : constant := 16#4004_9000#;

   -- 11.5.1 Pin Control Register n (PORTx_PCRn)

   -- base address + 0h offset + (4d x i), i = 0 .. 31

   PS_PULLDOWN : constant := 0; -- Internal pulldown resistor is enabled on the corresponding pin, if the corresponding Port Pull Enable field is set.
   PS_PULLUP   : constant := 1; -- Internal pullup resistor is enabled on the corresponding pin, if the corresponding Port Pull Enable field is set.

   MUX_DISABLED  : constant := 2#000#; -- Pin disabled (analog).
   MUX_ALT1_GPIO : constant := 2#001#; -- Alternative 1 (GPIO).
   MUX_ALT2      : constant := 2#010#; -- Alternative 2 (chip-specific).
   MUX_ALT3      : constant := 2#011#; -- Alternative 3 (chip-specific).
   MUX_ALT4      : constant := 2#100#; -- Alternative 4 (chip-specific).
   MUX_ALT5      : constant := 2#101#; -- Alternative 5 (chip-specific).
   MUX_ALT6      : constant := 2#110#; -- Alternative 6 (chip-specific).
   MUX_ALT7      : constant := 2#111#; -- Alternative 7 (chip-specific).

   IRQC_DISABLED   : constant := 2#0000#; -- Interrupt/DMA request disabled.
   IRQC_DMARISING  : constant := 2#0001#; -- DMA request on rising edge.
   IRQC_DMAFALLING : constant := 2#0010#; -- DMA request on falling edge.
   IRQC_DMAEITHER  : constant := 2#0011#; -- DMA request on either edge.
   IRQC_RSVD1      : constant := 2#0100#; -- Reserved.
   IRQC_RSVD2      : constant := 2#0101#; -- Reserved.
   IRQC_RSVD3      : constant := 2#0110#; -- Reserved.
   IRQC_RSVD4      : constant := 2#0111#; -- Reserved.
   IRQC_IRQZERO    : constant := 2#1000#; -- Interrupt when logic zero.
   IRQC_IRQRISING  : constant := 2#1001#; -- Interrupt on rising edge.
   IRQC_IRQFALLING : constant := 2#1010#; -- Interrupt on falling edge.
   IRQC_IRQEITHER  : constant := 2#1011#; -- Interrupt on either edge.
   IRQC_IRQONE     : constant := 2#1100#; -- Interrupt when logic one.
   IRQC_RSVD5      : constant := 2#1101#; -- Reserved.
   IRQC_RSVD6      : constant := 2#1110#; -- Reserved.
   IRQC_RSVD7      : constant := 2#1111#; -- Reserved.

   type PORTx_PCRn_Type is record
      PS        : Bits_1;                   -- Pull Select
      PE        : Boolean;                  -- Pull Enable
      SRE       : Boolean;                  -- Slew Rate Enable
      Reserved1 : Bits_1  := 0;
      PFE       : Boolean;                  -- Passive Filter Enable
      Reserved2 : Bits_1  := 0;
      DSE       : Boolean;                  -- Drive Strength Enable
      Reserved3 : Bits_1  := 0;
      MUX       : Bits_3;                   -- Pin Mux Control
      Reserved4 : Bits_5  := 0;
      IRQC      : Bits_4  := IRQC_DISABLED; -- Interrupt Configuration
      Reserved5 : Bits_4  := 0;
      ISF       : Boolean := False;         -- Interrupt Status Flag
      Reserved6 : Bits_7  := 0;
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

   type PORTx_PCR_Type is array (0 .. 31) of PORTx_PCRn_Type
      with Pack => True;

   -- 11.5.2 Global Pin Control Low Register (PORTx_GPCLR)

   type Bitmap_16L is array (0 .. 15) of Boolean
      with Component_Size => 1,
           Size           => 16;

   type PORTx_GPCLR_Type is record
      GPWD : Bits_16    := 0;                 -- Global Pin Write Data
      GPWE : Bitmap_16L := [others => False]; -- Global Pin Write Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_GPCLR_Type use record
      GPWD at 0 range  0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   -- 11.5.3 Global Pin Control High Register (PORTx_GPCHR)

   type Bitmap_16H is array (16 .. 31) of Boolean
      with Component_Size => 1,
           Size           => 16;

   type PORTx_GPCHR_Type is record
      GPWD : Bits_16    := 0;                 -- Global Pin Write Data
      GPWE : Bitmap_16H := [others => False]; -- Global Pin Write Enable
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_GPCHR_Type use record
      GPWD at 0 range  0 .. 15;
      GPWE at 0 range 16 .. 31;
   end record;

   -- 11.5.4 Interrupt Status Flag Register (PORTx_ISFR)

   type PORTx_ISFR_Type is record
      ISF : Bitmap_32 := [others => False]; -- Interrupt Status Flag
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for PORTx_ISFR_Type use record
      ISF at 0 range 0 .. 31;
   end record;

   -- 11.5 Memory map and register definition

   type PORT_MUXCTRL_Type is record
      PCR   : PORTx_PCR_Type;
      GPCLR : PORTx_GPCLR_Type;
      GPCHR : PORTx_GPCHR_Type;
      ISFR  : PORTx_ISFR_Type;
   end record
      with Size => 16#A4# * 8;
   for PORT_MUXCTRL_Type use record
      PCR   at 16#00# range 0 .. 32 * 32 - 1;
      GPCLR at 16#80# range 0 .. 31;
      GPCHR at 16#84# range 0 .. 31;
      ISFR  at 16#A0# range 0 .. 31;
   end record;

   PORTA_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#0000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTB_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#1000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTC_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#2000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTD_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#3000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   PORTE_MUXCTRL : aliased PORT_MUXCTRL_Type
      with Address    => System'To_Address (PORT_MUXCTRL_BASEADDRESS + 16#4000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 12 System Integration Module (SIM)
   ----------------------------------------------------------------------------

   SIM_BASEADDRESS : constant := 16#4004_7000#;
   -- SIM_BASEADDRESS : constant := 16#4004_8000#;

   -- 12.2.1 System Options Register 1 (SIM_SOPT1)

   OSC32KSEL_SYS  : constant := 2#00#; -- System oscillator (OSC32KCLK)
   OSC32KSEL_RSVD : constant := 2#01#; -- Reserved
   OSC32KSEL_RTC  : constant := 2#10#; -- RTC_CLKIN
   OSC32KSEL_LPO  : constant := 2#11#; -- LPO 1kHz

   type SIM_SOPT1_Type is record
      Reserved1 : Bits_6;
      Reserved2 : Bits_12 := 0;
      OSC32KSEL : Bits_2  := OSC32KSEL_SYS; -- 32K oscillator clock select
      Reserved3 : Bits_9  := 0;
      USBVSTBY  : Boolean := False;         -- USB voltage regulator in standby mode during VLPR and VLPW modes
      USBSSTBY  : Boolean := False;         -- USB voltage regulator in standby mode during Stop, VLPS, LLS and VLLS modes.
      USBREGEN  : Boolean := True;          -- USB voltage regulator enable
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

   SIM_SOPT1 : aliased SIM_SOPT1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.2 SOPT1 Configuration Register (SIM_SOPT1CFG)

   type SIM_SOPT1CFG_Type is record
      Reserved1 : Bits_24 := 0;
      URWE      : Boolean := False; -- USB voltage regulator enable write enable
      UVSWE     : Boolean := False; -- USB voltage regulator VLP standby write enable
      USSWE     : Boolean := False; -- USB voltage regulator stop standby write enable
      Reserved2 : Bits_5  := 0;
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

   SIM_SOPT1CFG : aliased SIM_SOPT1CFG_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.3 System Options Register 2 (SIM_SOPT2)

   RTCCLKOUTSEL_RTC      : constant := 0; -- RTC 1 Hz clock is output on the RTC_CLKOUT pin.
   RTCCLKOUTSEL_OSCERCLK : constant := 1; -- OSCERCLK clock is output on the RTC_CLKOUT pin.

   CLKOUTSEL_RSVD1    : constant := 2#000#; -- Reserved
   CLKOUTSEL_RSVD2    : constant := 2#001#; -- Reserved
   CLKOUTSEL_BUSCLOCK : constant := 2#010#; -- Bus clock
   CLKOUTSEL_LPO      : constant := 2#011#; -- LPO clock (1 kHz)
   CLKOUTSEL_MCGIRCLK : constant := 2#100#; -- MCGIRCLK
   CLKOUTSEL_RSVD3    : constant := 2#101#; -- Reserved
   CLKOUTSEL_OSCERCLK : constant := 2#110#; -- OSCERCLK
   CLKOUTSEL_RSVD4    : constant := 2#111#; -- Reserved

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
      RTCCLKOUTSEL : Bits_1 := RTCCLKOUTSEL_RTC;    -- RTC clock out select
      CLKOUTSEL    : Bits_3 := CLKOUTSEL_RSVD1;     -- CLKOUT select
      Reserved2    : Bits_8 := 0;
      PLLFLLSEL    : Bits_1 := PLLFLLSEL_MCGFLLCLK; -- PLL/FLL clock select
      Reserved3    : Bits_1 := 0;
      USBSRC       : Bits_1 := USBSRC_EXT;          -- USB clock source select
      Reserved4    : Bits_5 := 0;
      TPMSRC       : Bits_2 := TPMSRC_DISABLED;     -- TPM Clock Source Select
      UART0SRC     : Bits_2 := UART0SRC_DISABLED;   -- UART0 Clock Source Select
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

   SIM_SOPT2 : aliased SIM_SOPT2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1004#),
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
      TPM1CH0SRC : Bits_2  := TPM1CH0SRC_TPM1_CH0;   -- TPM1 channel 0 input capture source select
      TPM2CH0SRC : Bits_1  := TPM2CH0SRC_TPM2_CH0;   -- TPM2 channel 0 input capture source select
      Reserved2  : Bits_3  := 0;
      TPM0CLKSEL : Bits_1  := TPM0CLKSEL_TPM_CLKIN0; -- TPM0 External Clock Pin Select
      TPM1CLKSEL : Bits_1  := TPM1CLKSEL_TPM_CLKIN0; -- TPM1 External Clock Pin Select
      TPM2CLKSEL : Bits_1  := TPM2CLKSEL_TPM_CLKIN0; -- TPM2 External Clock Pin Select
      Reserved3  : Bits_5  := 0;
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
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#100C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.5 System Options Register 5 (SIM_SOPT5)

   UARTxTXSRC_TXPIN      : constant := 2#00#; -- UART?_TX pin
   UARTxTXSRC_TXMODTPM10 : constant := 2#01#; -- UART?_TX pin modulated with TPM1 channel 0 output
   UARTxTXSRC_TXMODTPM20 : constant := 2#10#; -- UART?_TX pin modulated with TPM2 channel 0 output
   UARTxTXSRC_RSVD       : constant := 2#11#; -- Reserved

   UARTxRXSRC_RXPIN : constant := 0; -- UART?_RX pin
   UARTxRXSRC_CMP0  : constant := 1; -- CMP0 output

   type SIM_SOPT5_Type is record
      UART0TXSRC : Bits_2  := UARTxTXSRC_TXPIN; -- UART0 Transmit Data Source Select
      UART0RXSRC : Bits_1  := UARTxRXSRC_RXPIN; -- UART0 Receive Data Source Select
      Reserved1  : Bits_1  := 0;
      UART1TXSRC : Bits_2  := UARTxTXSRC_TXPIN; -- UART1 Transmit Data Source Select
      UART1RXSRC : Bits_1  := UARTxRXSRC_RXPIN; -- UART1 Receive Data Source Select
      Reserved2  : Bits_9  := 0;
      UART0ODE   : Boolean := False;            -- UART0 Open Drain Enable
      UART1ODE   : Boolean := False;            -- UART1 Open Drain Enable
      UART2ODE   : Boolean := False;            -- UART2 Open Drain Enable
      Reserved3  : Bits_1  := 0;
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

   SIM_SOPT5 : aliased SIM_SOPT5_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1010#),
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
   ADC0TRGSEL_RTCALRM   : constant := 2#1100#; -- RTC alarm
   ADC0TRGSEL_RTCSEC    : constant := 2#1101#; -- RTC seconds
   ADC0TRGSEL_LPTMR0TRG : constant := 2#1110#; -- LPTMR0 trigger
   ADC0TRGSEL_RSVD6     : constant := 2#1111#; -- Reserved

   ADC0PRETRGSEL_PRETRGA : constant := 0; -- Pre-trigger A
   ADC0PRETRGSEL_PRETRGB : constant := 1; -- Pre-trigger B

   type SIM_SOPT7_Type is record
      ADC0TRGSEL    : Bits_4  := ADC0TRGSEL_EXTRG;      -- ADC0 trigger select
      ADC0PRETRGSEL : Bits_1  := ADC0PRETRGSEL_PRETRGA; -- ADC0 Pretrigger Select
      Reserved1     : Bits_2  := 0;
      ADC0ALTTRGEN  : Boolean := False;                 -- ADC0 Alternate Trigger Enable
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

   SIM_SOPT7 : aliased SIM_SOPT7_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1018#),
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
      PINID    : Bits_4; -- Pincount Identification
      Reserved : Bits_3;
      DIEID    : Bits_5; -- Device Die Number
      REVID    : Bits_4; -- Device Revision Number
      SRAMSIZE : Bits_4; -- System SRAM Size
      SERIESID : Bits_4; -- Kinetis Series ID
      SUBFAMID : Bits_4; -- Kinetis Sub-Family ID
      FAMID    : Bits_4; -- Kinetis family ID
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

   SIM_SDID : aliased SIM_SDID_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.8 System Clock Gating Control Register 4 (SIM_SCGC4)

   type SIM_SCGC4_Type is record
      Reserved1 : Bits_4  := 0;
      Reserved2 : Bits_2  := 2#11#;
      I2C0      : Boolean := False;   -- I2C0 Clock Gate Control
      I2C1      : Boolean := False;   -- I2C1 Clock Gate Control
      Reserved3 : Bits_2  := 0;
      UART0     : Boolean := False;   -- UART0 Clock Gate Control
      UART1     : Boolean := False;   -- UART1 Clock Gate Control
      UART2     : Boolean := False;   -- UART2 Clock Gate Control
      Reserved4 : Bits_1  := 0;
      Reserved5 : Bits_4  := 0;
      USBOTG    : Boolean := False;   -- USB Clock Gate Control
      CMP       : Boolean := False;   -- Comparator Clock Gate Control
      Reserved6 : Bits_2  := 0;
      SPI0      : Boolean := False;   -- SPI0 Clock Gate Control
      SPI1      : Boolean := False;   -- SPI1 Clock Gate Control
      Reserved7 : Bits_4  := 0;
      Reserved8 : Bits_4  := 2#1111#;
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

   SIM_SCGC4 : aliased SIM_SCGC4_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1034#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.9 System Clock Gating Control Register 5 (SIM_SCGC5)

   type SIM_SCGC5_Type is record
      LPTMR     : Boolean := False; -- Low Power Timer Access Control
      Reserved1 : Bits_1  := 1;
      Reserved2 : Bits_3  := 0;
      TSI       : Boolean := False; -- TSI Access Control
      Reserved3 : Bits_1  := 0;
      Reserved4 : Bits_2  := 2#11#;
      PORTA     : Boolean := False; -- PORTA Clock Gate Control
      PORTB     : Boolean := False; -- PORTB Clock Gate Control
      PORTC     : Boolean := False; -- PORTC Clock Gate Control
      PORTD     : Boolean := False; -- PORTD Clock Gate Control
      PORTE     : Boolean := False; -- PORTE Clock Gate Control
      Reserved5 : Bits_5  := 0;
      SLCD      : Boolean := False; -- Segment LCD Clock Gate Control
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

   SIM_SCGC5 : aliased SIM_SCGC5_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.10 System Clock Gating Control Register 6 (SIM_SCGC6)

   type SIM_SCGC6_Type is record
      FTF       : Boolean := True;  -- Flash Memory Clock Gate Control
      DMAMUX    : Boolean := False; -- DMA Mux Clock Gate Control
      Reserved1 : Bits_13 := 0;
      I2S       : Boolean := False; -- I2S Clock Gate Control
      Reserved2 : Bits_7  := 0;
      PIT       : Boolean := False; -- PIT Clock Gate Control
      TPM0      : Boolean := False; -- TPM0 Clock Gate Control
      TPM1      : Boolean := False; -- TPM1 Clock Gate Control
      TPM2      : Boolean := False; -- TPM2 Clock Gate Control
      ADC0      : Boolean := False; -- ADC0 Clock Gate Control
      Reserved3 : Bits_1  := 0;
      RTC       : Boolean := False; -- RTC Access Control
      Reserved4 : Bits_1  := 0;
      DAC0      : Boolean := False; -- DAC0 Clock Gate Control
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC6_Type use record
      FTF       at 0 range  0 ..  0;
      DMAMUX    at 0 range  1 ..  1;
      Reserved1 at 0 range  2 .. 14;
      I2S       at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 22;
      PIT       at 0 range 23 .. 23;
      TPM0      at 0 range 24 .. 24;
      TPM1      at 0 range 25 .. 25;
      TPM2      at 0 range 26 .. 26;
      ADC0      at 0 range 27 .. 27;
      Reserved3 at 0 range 28 .. 28;
      RTC       at 0 range 29 .. 29;
      Reserved4 at 0 range 30 .. 30;
      DAC0      at 0 range 31 .. 31;
   end record;

   SIM_SCGC6 : aliased SIM_SCGC6_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#103C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.11 System Clock Gating Control Register 7 (SIM_SCGC7)

   type SIM_SCGC7_Type is record
      Reserved1 : Bits_8  := 0;
      DMA       : Boolean := True; -- DMA Clock Gate Control
      Reserved2 : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SCGC7_Type use record
      Reserved1 at 0 range 0 ..  7;
      DMA       at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 31;
   end record;

   SIM_SCGC7 : aliased SIM_SCGC7_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1040#),
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
      OUTDIV4   : Bits_3  := OUTDIV4_DIV2; -- Clock 4 Output Divider value
      Reserved2 : Bits_9  := 0;
      OUTDIV1   : Bits_4;                  -- Clock 1 Output Divider value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_CLKDIV1_Type use record
      Reserved1 at 0 range  0 .. 15;
      OUTDIV4   at 0 range 16 .. 18;
      Reserved2 at 0 range 19 .. 27;
      OUTDIV1   at 0 range 28 .. 31;
   end record;

   SIM_CLKDIV1 : aliased SIM_CLKDIV1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1044#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.13 Flash Configuration Register 1 (SIM_FCFG1)

   PFSIZE_8     : constant := 2#0000#; -- 8 KB of program flash memory, 0.25 KB protection region
   PFSIZE_16    : constant := 2#0001#; -- 16 KB of program flash memory, 0.5 KB protection region
   PFSIZE_32    : constant := 2#0011#; -- 32 KB of program flash memory, 1 KB protection region
   PFSIZE_64    : constant := 2#0101#; -- 64 KB of program flash memory, 2 KB protection region
   PFSIZE_128   : constant := 2#0111#; -- 128 KB of program flash memory, 4 KB protection region
   PFSIZE_256   : constant := 2#1001#; -- 256 KB of program flash memory, 8 KB protection region
   PFSIZE_256_2 : constant := 2#1111#; -- 256 KB of program flash memory, 8 KB protection region

   type SIM_FCFG1_Type is record
      FLASHDIS  : Boolean := False; -- Flash Disable
      FLASHDOZE : Boolean := False; -- Flash Doze
      Reserved1 : Bits_22 := 0;
      PFSIZE    : Bits_4;           -- Program Flash Size
      Reserved2 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_FCFG1_Type use record
      FLASHDIS  at 0 range  0 ..  0;
      FLASHDOZE at 0 range  1 ..  1;
      Reserved1 at 0 range  2 .. 23;
      PFSIZE    at 0 range 24 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   SIM_FCFG1 : aliased SIM_FCFG1_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#104C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.14 Flash Configuration Register 2 (SIM_FCFG2)

   type SIM_FCFG2_Type is record
      Reserved1 : Bits_16;
      MAXADDR1  : Bits_7;  -- This field concatenated with leading zeros plus the value of the MAXADDR1 field indicates the first invalid address of the second program flash block (flash block 1).
      Reserved2 : Bits_1;
      MAXADDR0  : Bits_7;  -- Max address block
      Reserved3 : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_FCFG2_Type use record
      Reserved1 at 0 range  0 .. 15;
      MAXADDR1  at 0 range 16 .. 22;
      Reserved2 at 0 range 23 .. 23;
      MAXADDR0  at 0 range 24 .. 30;
      Reserved3 at 0 range 31 .. 31;
   end record;

   SIM_FCFG2 : aliased SIM_FCFG2_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1050#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.15 Unique Identification Register Mid-High (SIM_UIDMH)

   type SIM_UIDMH_Type is record
      UID      : Bits_16; -- Unique Identification
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_UIDMH_Type use record
      UID      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   SIM_UIDMH : aliased SIM_UIDMH_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1058#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.16 Unique Identification Register Mid Low (SIM_UIDML)

   type SIM_UIDML_Type is record
      UID : Bits_32; -- Unique Identification
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_UIDML_Type use record
      UID at 0 range 0 .. 31;
   end record;

   SIM_UIDML : aliased SIM_UIDML_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#105C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.17 Unique Identification Register Low (SIM_UIDL)

   type SIM_UIDL_Type is record
      UID : Bits_32; -- Unique Identification
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_UIDL_Type use record
      UID at 0 range 0 .. 31;
   end record;

   SIM_UIDL : aliased SIM_UIDL_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1060#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.18 COP Control Register (SIM_COPC)

   COPT_NONE : constant := 2#00#; -- COP disabled
   COPT_5    : constant := 2#01#; -- COP timeout after 2^5 LPO cycles or 2^13 bus clock cycles
   COPT_8    : constant := 2#10#; -- COP timeout after 2^8 LPO cycles or 2^16 bus clock cycles
   COPT_10   : constant := 2#11#; -- COP timeout after 2^10 LPO cycles or 2^18 bus clock cycles

   type SIM_COPC_Type is record
      COPW     : Boolean := False;   -- COP Windowed Mode
      COPCLKS  : Boolean := False;   -- COP Clock Select
      COPT     : Bits_2  := COPT_10; -- COP Watchdog Timeout
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_COPC_Type use record
      COPW     at 0 range 0 ..  0;
      COPCLKS  at 0 range 1 ..  1;
      COPT     at 0 range 2 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   SIM_COPC : aliased SIM_COPC_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1100#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.2.19 Service COP Register (SIM_SRVCOP)

   SRVCOP_VALUE1 : constant := 16#55#;
   SRVCOP_VALUE2 : constant := 16#AA#;

   type SIM_SRVCOP_Type is record
      SRVCOP   : Bits_8  := 0; -- Service COP Register
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SIM_SRVCOP_Type use record
      SRVCOP   at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   SIM_SRVCOP : aliased SIM_SRVCOP_Type
      with Address              => System'To_Address (SIM_BASEADDRESS + 16#1104#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 13 System Mode Controller (SMC)
   ----------------------------------------------------------------------------

   -- 13.3.1 Power Mode Protection register (SMC_PMPROT)

   type SMC_PMPROT_Type is record
      Reserved1 : Bits_1  := 0;
      AVLLS     : Boolean := False; -- Allow Very-Low-Leakage Stop Mode
      Reserved2 : Bits_1  := 0;
      ALLS      : Boolean := False; -- Allow Low-Leakage Stop Mode
      Reserved3 : Bits_1  := 0;
      AVLP      : Boolean := False; -- Allow Very-Low-Power Modes
      Reserved4 : Bits_1  := 0;
      Reserved5 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMC_PMPROT_Type use record
      Reserved1 at 0 range 0 .. 0;
      AVLLS     at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 2;
      ALLS      at 0 range 3 .. 3;
      Reserved3 at 0 range 4 .. 4;
      AVLP      at 0 range 5 .. 5;
      Reserved4 at 0 range 6 .. 6;
      Reserved5 at 0 range 7 .. 7;
   end record;

   SMC_PMPROT_ADDRESS : constant := 16#4007_E000#;

   SMC_PMPROT : aliased SMC_PMPROT_Type
      with Address              => System'To_Address (SMC_PMPROT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.2 Power Mode Control register (SMC_PMCTRL)

   STOPM_STOP  : constant := 2#000#; -- Normal Stop (STOP)
   STOPM_RSVD1 : constant := 2#001#; -- Reserved
   STOPM_VLPS  : constant := 2#010#; -- Very-Low-Power Stop (VLPS)
   STOPM_LLS   : constant := 2#011#; -- Low-Leakage Stop (LLS)
   STOPM_VLLSx : constant := 2#100#; -- Very-Low-Leakage Stop (VLLSx)
   STOPM_RSVD2 : constant := 2#101#; -- Reserved
   STOPM_RSVD3 : constant := 2#110#; -- Reserved
   STOPM_RSVD4 : constant := 2#111#; -- Reserved

   RUNM_RUN   : constant := 2#00#; -- Normal Run mode (RUN)
   RUNM_RSVD1 : constant := 2#01#; -- Reserved
   RUNM_VLPR  : constant := 2#10#; -- Very-Low-Power Run mode (VLPR)
   RUNM_RSVD2 : constant := 2#11#; -- Reserved

   type SMC_PMCTRL_Type is record
      STOPM     : Bits_3  := STOPM_STOP; -- Stop Mode Control
      STOPA     : Boolean := False;
      Reserved1 : Bits_1  := 0;
      RUNM      : Bits_2  := RUNM_RUN;   -- Run Mode Control
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMC_PMCTRL_Type use record
      STOPM     at 0 range 0 .. 2;
      STOPA     at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      RUNM      at 0 range 5 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   SMC_PMCTRL_ADDRESS : constant := 16#4007_E001#;

   SMC_PMCTRL : aliased SMC_PMCTRL_Type
      with Address              => System'To_Address (SMC_PMCTRL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.3 Stop Control Register (SMC_STOPCTRL)

   VLLSM_VLLS0 : constant := 2#000#; -- VLLS0
   VLLSM_VLLS1 : constant := 2#001#; -- VLLS1
   VLLSM_RSVD1 : constant := 2#010#; -- Reserved
   VLLSM_VLLS3 : constant := 2#011#; -- VLLS3
   VLLSM_RSVD2 : constant := 2#100#; -- Reserved
   VLLSM_RSVD3 : constant := 2#101#; -- Reserved
   VLLSM_RSVD4 : constant := 2#110#; -- Reserved
   VLLSM_RSVD5 : constant := 2#111#; -- Reserved

   PSTOPO_STOP   : constant := 2#00#; -- STOP - Normal Stop mode
   PSTOPO_PSTOP1 : constant := 2#01#; -- PSTOP1 - Partial Stop with both system and bus clocks disabled
   PSTOPO_PSTOP2 : constant := 2#10#; -- PSTOP2 - Partial Stop with system clock disabled and bus clock enabled
   PSTOPO_RSVD   : constant := 2#11#; -- Reserved

   type SMC_STOPCTRL_Type is record
      VLLSM     : Bits_3  := VLLSM_VLLS3; -- VLLS Mode Control
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_1  := 0;
      PORPO     : Boolean := False;       -- POR Power Option
      PSTOPO    : Bits_2  := PSTOPO_STOP; -- Partial Stop Option
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMC_STOPCTRL_Type use record
      VLLSM     at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      PORPO     at 0 range 5 .. 5;
      PSTOPO    at 0 range 6 .. 7;
   end record;

   SMC_STOPCTRL_ADDRESS : constant := 16#4007_E002#;

   SMC_STOPCTRL : aliased SMC_STOPCTRL_Type
      with Address              => System'To_Address (SMC_STOPCTRL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.4 Power Mode Status register (SMC_PMSTAT)

   PMSTAT_RUN  : constant := 2#000_0001#; -- Current power mode is RUN
   PMSTAT_STOP : constant := 2#000_0010#; -- Current power mode is STOP
   PMSTAT_VLPR : constant := 2#000_0100#; -- Current power mode is VLPR
   PMSTAT_VLPW : constant := 2#000_1000#; -- Current power mode is VLPW
   PMSTAT_VLPS : constant := 2#001_0000#; -- Current power mode is VLPS
   PMSTAT_LLS  : constant := 2#010_0000#; -- Current power mode is LLS
   PMSTAT_VLLS : constant := 2#100_0000#; -- Current power mode is VLLS

   type SMC_PMSTAT_Type is record
      PMSTAT   : Bits_7; -- Current power mode
      Reserved : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMC_PMSTAT_Type use record
      PMSTAT   at 0 range 0 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   SMC_PMSTAT_ADDRESS : constant := 16#4007_E003#;

   SMC_PMSTAT : aliased SMC_PMSTAT_Type
      with Address              => System'To_Address (SMC_PMSTAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 14 Power Management Controller (PMC)
   ----------------------------------------------------------------------------

   -- 14.5.1 Low Voltage Detect Status And Control 1 register (PMC_LVDSC1)

   LVDV_LOW   : constant := 2#00#; -- Low trip point selected (V LVD = V LVDL )
   LVDV_HIGH  : constant := 2#01#; -- High trip point selected (V LVD = V LVDH )
   LVDV_RSVD1 : constant := 2#10#; -- Reserved
   LVDV_RSVD2 : constant := 2#11#; -- Reserved

   type PMC_LVDSC1_Type is record
      LVDV     : Bits_2  := LVDV_LOW; -- Low-Voltage Detect Voltage Select
      Reserved : Bits_2  := 0;
      LVDRE    : Boolean := True;     -- Low-Voltage Detect Reset Enable
      LVDIE    : Boolean := False;    -- Low-Voltage Detect Interrupt Enable
      LVDACK   : Boolean := False;    -- Low-Voltage Detect Acknowledge
      LVDF     : Boolean := False;    -- Low-Voltage Detect Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PMC_LVDSC1_Type use record
      LVDV     at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 3;
      LVDRE    at 0 range 4 .. 4;
      LVDIE    at 0 range 5 .. 5;
      LVDACK   at 0 range 6 .. 6;
      LVDF     at 0 range 7 .. 7;
   end record;

   PMC_LVDSC1_ADDRESS : constant := 16#4007_D000#;

   PMC_LVDSC1 : aliased PMC_LVDSC1_Type
      with Address              => System'To_Address (PMC_LVDSC1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.2 Low Voltage Detect Status And Control 2 register (PMC_LVDSC2)

   LVWV_LOW  : constant := 2#00#; -- Low trip point selected (VLVW = VLVW1)
   LVWV_MID1 : constant := 2#01#; -- Mid 1 trip point selected (VLVW = VLVW2)
   LVWV_MID2 : constant := 2#10#; -- Mid 2 trip point selected (VLVW = VLVW3)
   LVWV_HIGH : constant := 2#11#; -- High trip point selected (VLVW = VLVW4)

   type PMC_LVDSC2_Type is record
      LVWV     : Bits_2  := LVWV_LOW; -- Low-Voltage Warning Voltage Select
      Reserved : Bits_3  := 0;
      LVWIE    : Boolean := False;    -- Low-Voltage Warning Interrupt Enable
      LVWACK   : Boolean := False;    -- Low-Voltage Warning Acknowledge
      LVWF     : Boolean := False;    -- Low-Voltage Warning Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PMC_LVDSC2_Type use record
      LVWV     at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 4;
      LVWIE    at 0 range 5 .. 5;
      LVWACK   at 0 range 6 .. 6;
      LVWF     at 0 range 7 .. 7;
   end record;

   PMC_LVDSC2_ADDRESS : constant := 16#4007_D001#;

   PMC_LVDSC2 : aliased PMC_LVDSC2_Type
      with Address              => System'To_Address (PMC_LVDSC2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.5.3 Regulator Status And Control register (PMC_REGSC)

   type PMC_REGSC_Type is record
      BGBE      : Boolean := False; -- Bandgap Buffer Enable
      Reserved1 : Bits_1  := 0;
      REGONS    : Boolean := True;  -- Regulator In Run Regulation Status
      ACKISO    : Boolean := False; -- Acknowledge Isolation
      BGEN      : Boolean := False; -- Bandgap Enable In VLPx Operation
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PMC_REGSC_Type use record
      BGBE      at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      REGONS    at 0 range 2 .. 2;
      ACKISO    at 0 range 3 .. 3;
      BGEN      at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 7;
   end record;

   PMC_REGSC_ADDRESS : constant := 16#4007_D002#;

   PMC_REGSC : aliased PMC_REGSC_Type
      with Address              => System'To_Address (PMC_REGSC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 16 Reset Control Module (RCM)
   ----------------------------------------------------------------------------

   -- 16.2.1 System Reset Status Register 0 (RCM_SRS0)

   type RCM_SRS0_Type is record
      WAKEUP   : Boolean; -- Low Leakage Wakeup Reset
      LVD      : Boolean; -- Low-Voltage Detect Reset
      LOC      : Boolean; -- Loss-of-Clock Reset
      LOL      : Boolean; -- Loss-of-Lock Reset
      Reserved : Bits_1;
      WDOG     : Boolean; -- Watchdog
      PIN      : Boolean; -- External Reset Pin
      POR      : Boolean; -- Power-On Reset
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RCM_SRS0_Type use record
      WAKEUP   at 0 range 0 .. 0;
      LVD      at 0 range 1 .. 1;
      LOC      at 0 range 2 .. 2;
      LOL      at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 4;
      WDOG     at 0 range 5 .. 5;
      PIN      at 0 range 6 .. 6;
      POR      at 0 range 7 .. 7;
   end record;

   RCM_SRS0_ADDRESS : constant := 16#4007_F000#;

   RCM_SRS0 : aliased RCM_SRS0_Type
      with Address              => System'To_Address (RCM_SRS0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 16.2.2 System Reset Status Register 1 (RCM_SRS1)

   type RCM_SRS1_Type is record
      Reserved1 : Bits_1;
      LOCKUP    : Boolean; -- Core Lockup
      SW        : Boolean; -- Software
      MDM_AP    : Boolean; -- MDM-AP System Reset Request
      Reserved2 : Bits_1;
      SACKERR   : Boolean; -- Stop Mode Acknowledge Error Reset
      Reserved3 : Bits_1;
      Reserved4 : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RCM_SRS1_Type use record
      Reserved1 at 0 range 0 .. 0;
      LOCKUP    at 0 range 1 .. 1;
      SW        at 0 range 2 .. 2;
      MDM_AP    at 0 range 3 .. 3;
      Reserved2 at 0 range 4 .. 4;
      SACKERR   at 0 range 5 .. 5;
      Reserved3 at 0 range 6 .. 6;
      Reserved4 at 0 range 7 .. 7;
   end record;

   RCM_SRS1_ADDRESS : constant := 16#4007_F001#;

   RCM_SRS1 : aliased RCM_SRS1_Type
      with Address              => System'To_Address (RCM_SRS1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 16.2.3 Reset Pin Filter Control register (RCM_RPFC)

   RSTFLTSRW_DIS  : constant := 2#00#; -- All filtering disabled
   RSTFLTSRW_BUS  : constant := 2#01#; -- Bus clock filter enabled for normal operation
   RSTFLTSRW_LPO  : constant := 2#11#; -- LPO clock filter enabled for normal operation
   RSTFLTSRW_RSVD : constant := 2#11#; -- Reserved

   RSTFLTSS_DIS : constant := 0; -- All filtering disabled
   RSTFLTSS_LPO : constant := 1; -- LPO clock filter enabled

   type RCM_RPFC_Type is record
      RSTFLTSRW : Bits_2 := RSTFLTSRW_DIS; -- Reset Pin Filter Select in Run and Wait Modes
      RSTFLTSS  : Bits_1 := RSTFLTSS_DIS;  -- Reset Pin Filter Select in Stop Mode
      Reserved  : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RCM_RPFC_Type use record
      RSTFLTSRW at 0 range 0 .. 1;
      RSTFLTSS  at 0 range 2 .. 2;
      Reserved  at 0 range 3 .. 7;
   end record;

   RCM_RPFC_ADDRESS : constant := 16#4007_F004#;

   RCM_RPFC : aliased RCM_RPFC_Type
      with Address              => System'To_Address (RCM_RPFC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 16.2.4 Reset Pin Filter Width register (RCM_RPFW)

   RSTFLTSEL_CNT1  : constant := 2#00000#; -- Bus clock filter count is 1
   RSTFLTSEL_CNT2  : constant := 2#00001#; -- Bus clock filter count is 2
   RSTFLTSEL_CNT3  : constant := 2#00010#; -- Bus clock filter count is 3
   RSTFLTSEL_CNT4  : constant := 2#00011#; -- Bus clock filter count is 4
   RSTFLTSEL_CNT5  : constant := 2#00100#; -- Bus clock filter count is 5
   RSTFLTSEL_CNT6  : constant := 2#00101#; -- Bus clock filter count is 6
   RSTFLTSEL_CNT7  : constant := 2#00110#; -- Bus clock filter count is 7
   RSTFLTSEL_CNT8  : constant := 2#00111#; -- Bus clock filter count is 8
   RSTFLTSEL_CNT9  : constant := 2#01000#; -- Bus clock filter count is 9
   RSTFLTSEL_CNT10 : constant := 2#01001#; -- Bus clock filter count is 10
   RSTFLTSEL_CNT11 : constant := 2#01010#; -- Bus clock filter count is 11
   RSTFLTSEL_CNT12 : constant := 2#01011#; -- Bus clock filter count is 12
   RSTFLTSEL_CNT13 : constant := 2#01100#; -- Bus clock filter count is 13
   RSTFLTSEL_CNT14 : constant := 2#01101#; -- Bus clock filter count is 14
   RSTFLTSEL_CNT15 : constant := 2#01110#; -- Bus clock filter count is 15
   RSTFLTSEL_CNT16 : constant := 2#01111#; -- Bus clock filter count is 16
   RSTFLTSEL_CNT17 : constant := 2#10000#; -- Bus clock filter count is 17
   RSTFLTSEL_CNT18 : constant := 2#10001#; -- Bus clock filter count is 18
   RSTFLTSEL_CNT19 : constant := 2#10010#; -- Bus clock filter count is 19
   RSTFLTSEL_CNT20 : constant := 2#10011#; -- Bus clock filter count is 20
   RSTFLTSEL_CNT21 : constant := 2#10100#; -- Bus clock filter count is 21
   RSTFLTSEL_CNT22 : constant := 2#10101#; -- Bus clock filter count is 22
   RSTFLTSEL_CNT23 : constant := 2#10110#; -- Bus clock filter count is 23
   RSTFLTSEL_CNT24 : constant := 2#10111#; -- Bus clock filter count is 24
   RSTFLTSEL_CNT25 : constant := 2#11000#; -- Bus clock filter count is 25
   RSTFLTSEL_CNT26 : constant := 2#11001#; -- Bus clock filter count is 26
   RSTFLTSEL_CNT27 : constant := 2#11010#; -- Bus clock filter count is 27
   RSTFLTSEL_CNT28 : constant := 2#11011#; -- Bus clock filter count is 28
   RSTFLTSEL_CNT29 : constant := 2#11100#; -- Bus clock filter count is 29
   RSTFLTSEL_CNT30 : constant := 2#11101#; -- Bus clock filter count is 30
   RSTFLTSEL_CNT31 : constant := 2#11110#; -- Bus clock filter count is 31
   RSTFLTSEL_CNT32 : constant := 2#11111#; -- Bus clock filter count is 32

   type RCM_RPFW_Type is record
      RSTFLTSEL : Bits_5 := RSTFLTSEL_CNT1; -- Reset Pin Filter Bus Clock Select
      Reserved  : Bits_3 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RCM_RPFW_Type use record
      RSTFLTSEL at 0 range 0 .. 4;
      Reserved  at 0 range 5 .. 7;
   end record;

   RCM_RPFW_ADDRESS : constant := 16#4007_F005#;

   RCM_RPFW : aliased RCM_RPFW_Type
      with Address              => System'To_Address (RCM_RPFW_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 24 Multipurpose Clock Generator (MCG)
   ----------------------------------------------------------------------------

   MCG_BASEADDRESS : constant := 16#4006_4000#;

   -- 24.3.1 MCG Control 1 Register (MCG_C1)

   IREFS_EXT : constant := 0; -- External reference clock is selected.
   IREFS_INT : constant := 1; -- The slow internal reference clock is selected.

   FRDIV_1_32     : constant := 2#000#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 1; for all other RANGE 0 values, Divide Factor is 32.
   FRDIV_2_64     : constant := 2#001#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 2; for all other RANGE 0 values, Divide Factor is 64.
   FRDIV_4_128    : constant := 2#010#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 4; for all other RANGE 0 values, Divide Factor is 128.
   FRDIV_8_256    : constant := 2#011#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 8; for all other RANGE 0 values, Divide Factor is 256.
   FRDIV_16_512   : constant := 2#100#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 16; for all other RANGE 0 values, Divide Factor is 512.
   FRDIV_32_1024  : constant := 2#101#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 32; for all other RANGE 0 values, Divide Factor is 1024.
   FRDIV_64_1280  : constant := 2#110#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 64; for all other RANGE 0 values, Divide Factor is 1280 .
   FRDIV_128_1536 : constant := 2#111#; -- If RANGE 0 = 0 or OSCSEL=1 , Divide Factor is 128; for all other RANGE 0 values, Divide Factor is 1536 .

   CLKS_FLLPLL : constant := 2#00#; -- Encoding 0 — Output of FLL or PLL is selected (depends on PLLS control bit).
   CLKS_INT    : constant := 2#01#; -- Encoding 1 — Internal reference clock is selected.
   CLKS_EXT    : constant := 2#10#; -- Encoding 2 — External reference clock is selected.
   CLKS_RSVD   : constant := 2#11#; -- Encoding 3 — Reserved.

   type MCG_C1_Type is record
      IREFSTEN : Boolean := False;       -- Internal Reference Stop Enable
      IRCLKEN  : Boolean := False;       -- Internal Reference Clock Enable
      IREFS    : Bits_1  := IREFS_INT;   -- Internal Reference Select
      FRDIV    : Bits_3  := FRDIV_1_32;  -- FLL External Reference Divider
      CLKS     : Bits_2  := CLKS_FLLPLL; -- Clock Source Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C1_Type use record
      IREFSTEN at 0 range 0 .. 0;
      IRCLKEN  at 0 range 1 .. 1;
      IREFS    at 0 range 2 .. 2;
      FRDIV    at 0 range 3 .. 5;
      CLKS     at 0 range 6 .. 7;
   end record;

   MCG_C1 : aliased MCG_C1_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#0#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.2 MCG Control 2 Register (MCG_C2)

   IRCS_SLOW : constant := 0; -- Slow internal reference clock selected.
   IRCS_FAST : constant := 1; -- Fast internal reference clock selected.

   EREFS0_EXT : constant := 0; -- External reference clock requested.
   EREFS0_OSC : constant := 1; -- Oscillator requested.

   RANGE0_LO   : constant := 2#00#; -- Encoding 0 — Low frequency range selected for the crystal oscillator .
   RANGE0_HI   : constant := 2#01#; -- Encoding 1 — High frequency range selected for the crystal oscillator .
   RANGE0_VHI1 : constant := 2#10#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .
   RANGE0_VHI2 : constant := 2#11#; -- Encoding 2 — Very high frequency range selected for the crystal oscillator .

   LOCRE0_IRQ : constant := 0; -- Interrupt request is generated on a loss of OSC0 external reference clock.
   LOCRE0_RES : constant := 1; -- Generate a reset request on a loss of OSC0 external reference clock.

   type MCG_C2_Type is record
      IRCS    : Bits_1  := IRCS_SLOW;  -- Internal Reference Clock Select
      LP      : Boolean := False;      -- Low Power Select
      EREFS0  : Bits_1  := EREFS0_EXT; -- External Reference Select
      HGO0    : Boolean := False;      -- High Gain Oscillator Select
      RANGE0  : Bits_2  := RANGE0_LO;  -- Frequency Range Select
      FCFTRIM : Boolean := True;       -- Fast Internal Reference Clock Fine Trim
      LOCRE0  : Bits_1  := LOCRE0_RES; -- Loss of Clock Reset Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C2_Type use record
      IRCS    at 0 range 0 .. 0;
      LP      at 0 range 1 .. 1;
      EREFS0  at 0 range 2 .. 2;
      HGO0    at 0 range 3 .. 3;
      RANGE0  at 0 range 4 .. 5;
      FCFTRIM at 0 range 6 .. 6;
      LOCRE0  at 0 range 7 .. 7;
   end record;

   MCG_C2 : aliased MCG_C2_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#1#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.3 MCG Control 3 Register (MCG_C3)

   type MCG_C3_Type is record
      SCTRIM : Bits_8; -- Slow Internal Reference Clock Trim Setting
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C3_Type use record
      SCTRIM at 0 range 0 .. 7;
   end record;

   MCG_C3 : aliased MCG_C3_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#2#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.4 MCG Control 4 Register (MCG_C4)

                                   -- DMX32  Reference Range    FLL Factor  DCO Range
   DRST_DRS_1 : constant := 2#00#; -- 0      31.25–39.0625 kHz  640         20–25 MHz
                                   -- 1      32.768 kHz         732         24 MHz
   DRST_DRS_2 : constant := 2#01#; -- 0      31.25–39.0625 kHz  1280        40–50 MHz
                                   -- 1      32.768 kHz         1464        48 MHz
   DRST_DRS_3 : constant := 2#10#; -- 0      31.25–39.0625 kHz  1920        60–75 MHz
                                   -- 1      32.768 kHz         2197        72 MHz
   DRST_DRS_4 : constant := 2#11#; -- 0      31.25–39.0625 kHz  2560        80–100 MHz
                                   -- 1      32.768 kHz         2929        96 MHz

   type MCG_C4_Type is record
      SCFTRIM  : Boolean;               -- Slow Internal Reference Clock Fine Trim
      FCTRIM   : Bits_4;                -- Fast Internal Reference Clock Trim Setting
      DRST_DRS : Bits_2  := DRST_DRS_1; -- DCO Range Select
      DMX32    : Boolean := False;      -- DCO Maximum Frequency with 32.768 kHz Reference
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C4_Type use record
      SCFTRIM  at 0 range 0 .. 0;
      FCTRIM   at 0 range 1 .. 4;
      DRST_DRS at 0 range 5 .. 6;
      DMX32    at 0 range 7 .. 7;
   end record;

   MCG_C4 : aliased MCG_C4_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#3#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.5 MCG Control 5 Register (MCG_C5)

   PRDIV0_DIV1  : constant := 2#00000#; -- Divide Factor 1
   PRDIV0_DIV2  : constant := 2#00001#; -- Divide Factor 2
   PRDIV0_DIV3  : constant := 2#00010#; -- Divide Factor 3
   PRDIV0_DIV4  : constant := 2#00011#; -- Divide Factor 4
   PRDIV0_DIV5  : constant := 2#00100#; -- Divide Factor 5
   PRDIV0_DIV6  : constant := 2#00101#; -- Divide Factor 6
   PRDIV0_DIV7  : constant := 2#00110#; -- Divide Factor 7
   PRDIV0_DIV8  : constant := 2#00111#; -- Divide Factor 8
   PRDIV0_DIV9  : constant := 2#01000#; -- Divide Factor 9
   PRDIV0_DIV10 : constant := 2#01001#; -- Divide Factor 10
   PRDIV0_DIV11 : constant := 2#01010#; -- Divide Factor 11
   PRDIV0_DIV12 : constant := 2#01011#; -- Divide Factor 12
   PRDIV0_DIV13 : constant := 2#01100#; -- Divide Factor 13
   PRDIV0_DIV14 : constant := 2#01101#; -- Divide Factor 14
   PRDIV0_DIV15 : constant := 2#01110#; -- Divide Factor 15
   PRDIV0_DIV16 : constant := 2#01111#; -- Divide Factor 16
   PRDIV0_DIV17 : constant := 2#10000#; -- Divide Factor 17
   PRDIV0_DIV18 : constant := 2#10001#; -- Divide Factor 18
   PRDIV0_DIV19 : constant := 2#10010#; -- Divide Factor 19
   PRDIV0_DIV20 : constant := 2#10011#; -- Divide Factor 20
   PRDIV0_DIV21 : constant := 2#10100#; -- Divide Factor 21
   PRDIV0_DIV22 : constant := 2#10101#; -- Divide Factor 22
   PRDIV0_DIV23 : constant := 2#10110#; -- Divide Factor 23
   PRDIV0_DIV24 : constant := 2#10111#; -- Divide Factor 24
   PRDIV0_DIV25 : constant := 2#11000#; -- Divide Factor 25

   type MCG_C5_Type is record
      PRDIV0    : Bits_5  := PRDIV0_DIV1; -- PLL External Reference Divider
      PLLSTEN0  : Boolean := False;       -- PLL Stop Enable
      PLLCLKEN0 : Boolean := False;       -- PLL Clock Enable
      Reserved  : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C5_Type use record
      PRDIV0    at 0 range 0 .. 4;
      PLLSTEN0  at 0 range 5 .. 5;
      PLLCLKEN0 at 0 range 6 .. 6;
      Reserved  at 0 range 7 .. 7;
   end record;

   MCG_C5 : aliased MCG_C5_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#4#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.6 MCG Control 6 Register (MCG_C6)

   VDIV0_x24 : constant := 2#00000#; -- Multiply Factor 24
   VDIV0_x25 : constant := 2#00001#; -- Multiply Factor 25
   VDIV0_x26 : constant := 2#00010#; -- Multiply Factor 26
   VDIV0_x27 : constant := 2#00011#; -- Multiply Factor 27
   VDIV0_x28 : constant := 2#00100#; -- Multiply Factor 28
   VDIV0_x29 : constant := 2#00101#; -- Multiply Factor 29
   VDIV0_x30 : constant := 2#00110#; -- Multiply Factor 30
   VDIV0_x31 : constant := 2#00111#; -- Multiply Factor 31
   VDIV0_x32 : constant := 2#01000#; -- Multiply Factor 32
   VDIV0_x33 : constant := 2#01001#; -- Multiply Factor 33
   VDIV0_x34 : constant := 2#01010#; -- Multiply Factor 34
   VDIV0_x35 : constant := 2#01011#; -- Multiply Factor 35
   VDIV0_x36 : constant := 2#01100#; -- Multiply Factor 36
   VDIV0_x37 : constant := 2#01101#; -- Multiply Factor 37
   VDIV0_x38 : constant := 2#01110#; -- Multiply Factor 38
   VDIV0_x39 : constant := 2#01111#; -- Multiply Factor 39
   VDIV0_x40 : constant := 2#10000#; -- Multiply Factor 40
   VDIV0_x41 : constant := 2#10001#; -- Multiply Factor 41
   VDIV0_x42 : constant := 2#10010#; -- Multiply Factor 42
   VDIV0_x43 : constant := 2#10011#; -- Multiply Factor 43
   VDIV0_x44 : constant := 2#10100#; -- Multiply Factor 44
   VDIV0_x45 : constant := 2#10101#; -- Multiply Factor 45
   VDIV0_x46 : constant := 2#10110#; -- Multiply Factor 46
   VDIV0_x47 : constant := 2#10111#; -- Multiply Factor 47
   VDIV0_x48 : constant := 2#11000#; -- Multiply Factor 48
   VDIV0_x49 : constant := 2#11001#; -- Multiply Factor 49
   VDIV0_x50 : constant := 2#11010#; -- Multiply Factor 50
   VDIV0_x51 : constant := 2#11011#; -- Multiply Factor 51
   VDIV0_x52 : constant := 2#11100#; -- Multiply Factor 52
   VDIV0_x53 : constant := 2#11101#; -- Multiply Factor 53
   VDIV0_x54 : constant := 2#11110#; -- Multiply Factor 54
   VDIV0_x55 : constant := 2#11111#; -- Multiply Factor 55

   PLLS_FLL : constant := 0; -- FLL is selected.
   PLLS_PLL : constant := 1; -- PLL is selected.

   type MCG_C6_Type is record
      VDIV0  : Bits_5  := VDIV0_x24; -- VCO 0 Divider
      CME0   : Boolean := False;     -- Clock Monitor Enable
      PLLS   : Bits_1  := PLLS_FLL;  -- PLL Select
      LOLIE0 : Boolean := False;     -- Loss of Lock Interrrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C6_Type use record
      VDIV0  at 0 range 0 .. 4;
      CME0   at 0 range 5 .. 5;
      PLLS   at 0 range 6 .. 6;
      LOLIE0 at 0 range 7 .. 7;
   end record;

   MCG_C6 : aliased MCG_C6_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#5#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.7 MCG Status Register (MCG_S)

   IRCST_SLOW : constant := 0; -- Source of internal reference clock is the slow clock (32 kHz IRC).
   IRCST_FAST : constant := 1; -- Source of internal reference clock is the fast clock (4 MHz IRC).

   CLKST_FLL : constant := 2#00#; -- Encoding 0 — Output of the FLL is selected (reset default).
   CLKST_INT : constant := 2#01#; -- Encoding 1 — Internal reference clock is selected.
   CLKST_EXT : constant := 2#10#; -- Encoding 2 — External reference clock is selected.
   CLKST_PLL : constant := 2#11#; -- Encoding 3 — Output of the PLL is selected.

   IREFST_EXT : constant := 0; -- Source of FLL reference clock is the external reference clock.
   IREFST_INT : constant := 1; -- Source of FLL reference clock is the internal reference clock.

   PLLST_FLL : constant := 0; -- Source of PLLS clock is FLL clock.
   PLLST_PLL : constant := 1; -- Source of PLLS clock is PLL output clock.

   type MCG_S_Type is record
      IRCST    : Bits_1;  -- Internal Reference Clock Status
      OSCINIT0 : Boolean; -- OSC Initialization
      CLKST    : Bits_2;  -- Clock Mode Status
      IREFST   : Bits_1;  -- Internal Reference Status
      PLLST    : Bits_1;  -- PLL Select Status
      LOCK0    : Boolean; -- Lock Status
      LOLS0    : Boolean; -- Loss of Lock Status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_S_Type use record
      IRCST    at 0 range 0 .. 0;
      OSCINIT0 at 0 range 1 .. 1;
      CLKST    at 0 range 2 .. 3;
      IREFST   at 0 range 4 .. 4;
      PLLST    at 0 range 5 .. 5;
      LOCK0    at 0 range 6 .. 6;
      LOLS0    at 0 range 7 .. 7;
   end record;

   MCG_S : aliased MCG_S_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#6#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.8 MCG Status and Control Register (MCG_SC)

   FCRDIV_DIV1   : constant := 2#000#; -- Divide Factor is 1
   FCRDIV_DIV2   : constant := 2#001#; -- Divide Factor is 2.
   FCRDIV_DIV4   : constant := 2#010#; -- Divide Factor is 4.
   FCRDIV_DIV8   : constant := 2#011#; -- Divide Factor is 8.
   FCRDIV_DIV16  : constant := 2#100#; -- Divide Factor is 16
   FCRDIV_DIV32  : constant := 2#101#; -- Divide Factor is 32
   FCRDIV_DIV64  : constant := 2#110#; -- Divide Factor is 64
   FCRDIV_DIV128 : constant := 2#111#; -- Divide Factor is 128.

   ATMS_32k : constant := 0; -- 32 kHz Internal Reference Clock selected.
   ATMS_4M  : constant := 1; -- 4 MHz Internal Reference Clock selected.

   type MCG_SC_Type is record
      LOCS0    : Boolean := False;       -- OSC0 Loss of Clock Status
      FCRDIV   : Bits_3  := FCRDIV_DIV2; -- Fast Clock Internal Reference Divider
      FLTPRSRV : Boolean := False;       -- FLL Filter Preserve Enable
      ATMF     : Boolean := False;       -- Automatic Trim Machine Fail Flag
      ATMS     : Bits_1  := ATMS_32k;    -- Automatic Trim Machine Select
      ATME     : Boolean := False;       -- Automatic Trim Machine Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_SC_Type use record
      LOCS0    at 0 range 0 .. 0;
      FCRDIV   at 0 range 1 .. 3;
      FLTPRSRV at 0 range 4 .. 4;
      ATMF     at 0 range 5 .. 5;
      ATMS     at 0 range 6 .. 6;
      ATME     at 0 range 7 .. 7;
   end record;

   MCG_SC : aliased MCG_SC_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.9 MCG Auto Trim Compare Value High Register (MCG_ATCVH)

   MCG_ATCVH : aliased Unsigned_8
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.10 MCG Auto Trim Compare Value Low Register (MCG_ATCVL)

   MCG_ATCVL : aliased Unsigned_8
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.11 MCG Control 7 Register (MCG_C7)

   OSCSEL_OSC : constant := 0; -- Selects Oscillator (OSCCLK).
   OSCSEL_RTC : constant := 1; -- Selects 32 kHz RTC Oscillator.

   type MCG_C7_Type is record
      OSCSEL    : Bits_1 := OSCSEL_OSC; -- MCG OSC Clock Select
      Reserved1 : Bits_5 := 0;
      Reserved2 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C7_Type use record
      OSCSEL    at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 5;
      Reserved2 at 0 range 6 .. 7;
   end record;

   MCG_C7 : aliased MCG_C7_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.12 MCG Control 8 Register (MCG_C8)

   type MCG_C8_Type is record
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_4  := 0;
      Reserved3 : Bits_1  := 0;
      LOLRE     : Boolean := False; -- PLL Loss of Lock Reset Enable
      Reserved4 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C8_Type use record
      Reserved1 at 0 range 0 .. 0;
      Reserved2 at 0 range 1 .. 4;
      Reserved3 at 0 range 5 .. 5;
      LOLRE     at 0 range 6 .. 6;
      Reserved4 at 0 range 7 .. 7;
   end record;

   MCG_C8 : aliased MCG_C8_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#D#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.13 MCG Control 9 Register (MCG_C9)

   type MCG_C9_Type is record
      Reserved1 : Bits_1 := 0;
      Reserved2 : Bits_3 := 0;
      Reserved3 : Bits_2 := 0;
      Reserved4 : Bits_2 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C9_Type use record
      Reserved1 at 0 range 0 .. 0;
      Reserved2 at 0 range 1 .. 3;
      Reserved3 at 0 range 4 .. 5;
      Reserved4 at 0 range 6 .. 7;
   end record;

   MCG_C9 : aliased MCG_C9_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 24.3.14 MCG Control 10 Register (MCG_C10)

   type MCG_C10_Type is record
      Reserved1 : Bits_4 := 0;
      Reserved2 : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MCG_C10_Type use record
      Reserved1 at 0 range 0 .. 3;
      Reserved2 at 0 range 4 .. 7;
   end record;

   MCG_C10 : aliased MCG_C10_Type
      with Address              => System'To_Address (MCG_BASEADDRESS + 16#F#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 25 Oscillator (OSC)
   ----------------------------------------------------------------------------

   -- 25.71.1 OSC Control Register (OSCx_CR)

   type OSCx_CR_Type is record
      SC16P     : Boolean := False; -- Oscillator 16 pF Capacitor Load Configure
      SC8P      : Boolean := False; -- Oscillator 8 pF Capacitor Load Configure
      SC4P      : Boolean := False; -- Oscillator 4 pF Capacitor Load Configure
      SC2P      : Boolean := False; -- Oscillator 2 pF Capacitor Load Configure
      Reserved1 : Bits_1  := 0;
      EREFSTEN  : Boolean := False; -- External Reference Stop Enable
      Reserved2 : Bits_1  := 0;
      ERCLKEN   : Boolean := False; -- External Reference Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OSCx_CR_Type use record
      SC16P     at 0 range 0 .. 0;
      SC8P      at 0 range 1 .. 1;
      SC4P      at 0 range 2 .. 2;
      SC2P      at 0 range 3 .. 3;
      Reserved1 at 0 range 4 .. 4;
      EREFSTEN  at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      ERCLKEN   at 0 range 7 .. 7;
   end record;

   OSC0_CR_ADDRESS : constant := 16#4006_5000#;

   OSC0_CR : aliased OSCx_CR_Type
      with Address              => System'To_Address (OSC0_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 32 Periodic Interrupt Timer (PIT)
   ----------------------------------------------------------------------------

   -- 32.3.1 PIT Module Control Register (PIT_MCR)

   type PIT_MCR_Type is record
      FRZ       : Boolean := False; -- Freeze
      MDIS      : Boolean := True;  -- Module Disable - (PIT section)
      Reserved1 : Bits_1  := 1;
      Reserved2 : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_MCR_Type use record
      FRZ       at 0 range 0 ..  0;
      MDIS      at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  2;
      Reserved2 at 0 range 3 .. 31;
   end record;

   PIT_MCR_ADDRESS : constant := 16#4003_7000#;

   PIT_MCR : aliased PIT_MCR_Type
      with Address              => System'To_Address (PIT_MCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.2 PIT Upper Lifetime Timer Register (PIT_LTMR64H)

   PIT_LTMR64H_ADDRESS : constant := 16#4003_70E0#;

   PIT_LTMR64H : aliased Unsigned_32
      with Address              => System'To_Address (PIT_LTMR64H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.3 PIT Lower Lifetime Timer Register (PIT_LTMR64L)

   PIT_LTMR64L_ADDRESS : constant := 16#4003_70E4#;

   PIT_LTMR64L : aliased Unsigned_32
      with Address              => System'To_Address (PIT_LTMR64L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.4 Timer Load Value Register (PIT_LDVALn)

   PIT_LDVAL0_ADDRESS : constant := 16#4003_7100#;

   PIT_LDVAL0 : aliased Unsigned_32
      with Address              => System'To_Address (PIT_LDVAL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PIT_LDVAL1_ADDRESS : constant := 16#4003_7110#;

   PIT_LDVAL1 : aliased Unsigned_32
      with Address              => System'To_Address (PIT_LDVAL1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.5 Current Timer Value Register (PIT_CVALn)

   PIT_CVAL0_ADDRESS : constant := 16#4003_7104#;

   PIT_CVAL0 : aliased Unsigned_32
      with Address              => System'To_Address (PIT_CVAL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PIT_CVAL1_ADDRESS : constant := 16#4003_7114#;

   PIT_CVAL1 : aliased Unsigned_32
      with Address              => System'To_Address (PIT_CVAL1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.6 Timer Control Register (PIT_TCTRLn)

   type PIT_TCTRLn_Type is record
      TEN      : Boolean := False; -- Timer Enable
      TIE      : Boolean := False; -- Timer Interrupt Enable
      CHN      : Boolean := False; -- Chain Mode
      Reserved : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_TCTRLn_Type use record
      TEN      at 0 range 0 ..  0;
      TIE      at 0 range 1 ..  1;
      CHN      at 0 range 2 ..  2;
      Reserved at 0 range 3 .. 31;
   end record;

   PIT_TCTRL0_ADDRESS : constant := 16#4003_7108#;

   PIT_TCTRL0 : aliased PIT_TCTRLn_Type
      with Address              => System'To_Address (PIT_TCTRL0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PIT_TCTRL1_ADDRESS : constant := 16#4003_7118#;

   PIT_TCTRL1 : aliased PIT_TCTRLn_Type
      with Address              => System'To_Address (PIT_TCTRL1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 32.3.7 Timer Flag Register (PIT_TFLGn)

   type PIT_TFLGn_Type is record
      TIF      : Boolean := False; -- Timer Interrupt Flag
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PIT_TFLGn_Type use record
      TIF      at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   PIT_TFLG0_ADDRESS : constant := 16#4003_710C#;

   PIT_TFLG0 : aliased PIT_TFLGn_Type
      with Address              => System'To_Address (PIT_TFLG0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PIT_TFLG1_ADDRESS : constant := 16#4003_711C#;

   PIT_TFLG1 : aliased PIT_TFLGn_Type
      with Address              => System'To_Address (PIT_TFLG1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 34 Real Time Clock (RTC)
   ----------------------------------------------------------------------------

   -- 34.2.1 RTC Time Seconds Register (RTC_TSR)

   RTC_TSR_ADDRESS : constant := 16#4003_D000#;

   RTC_TSR : aliased Unsigned_32
      with Address              => System'To_Address (RTC_TSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.2 RTC Time Prescaler Register (RTC_TPR)

   type RTC_TPR_Type is record
      TPR      : Unsigned_16 := 0; -- Time Prescaler Register
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TPR_Type use record
      TPR      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   RTC_TPR_ADDRESS : constant := 16#4003_D004#;

   RTC_TPR : aliased RTC_TPR_Type
      with Address              => System'To_Address (RTC_TPR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.3 RTC Time Alarm Register (RTC_TAR)

   RTC_TAR_ADDRESS : constant := 16#4003_D008#;

   RTC_TAR : aliased Unsigned_32
      with Address              => System'To_Address (RTC_TAR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.4 RTC Time Compensation Register (RTC_TCR)

   type RTC_TCR_Type is record
      TCR : Unsigned_8 := 0; -- Time Compensation Register
      CIR : Unsigned_8 := 0; -- Compensation Interval Register
      TCV : Unsigned_8 := 0; -- Time Compensation Value
      CIC : Unsigned_8 := 0; -- Compensation Interval Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_TCR_Type use record
      TCR at 0 range  0 ..  7;
      CIR at 0 range  8 .. 15;
      TCV at 0 range 16 .. 23;
      CIC at 0 range 24 .. 31;
   end record;

   RTC_TCR_ADDRESS : constant := 16#4003_D00C#;

   RTC_TCR : aliased RTC_TCR_Type
      with Address              => System'To_Address (RTC_TCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.5 RTC Control Register (RTC_CR)

   type RTC_CR_Type is record
      SWR       : Boolean := False; -- Software Reset
      WPE       : Boolean := False; -- Wakeup Pin Enable
      SUP       : Boolean := False; -- Supervisor Access
      UM        : Boolean := False; -- Update Mode
      WPS       : Boolean := False; -- Wakeup Pin Select
      Reserved1 : Bits_3  := 0;
      OSCE      : Boolean := False; -- Oscillator Enable
      CLKO      : Boolean := False; -- Clock Output
      SC16P     : Boolean := False; -- Oscillator 16pF Load Configure
      SC8P      : Boolean := False; -- Oscillator 8pF Load Configure
      SC4P      : Boolean := False; -- Oscillator 4pF Load Configure
      SC2P      : Boolean := False; -- Oscillator 2pF Load Configure
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_17 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_CR_Type use record
      SWR       at 0 range  0 ..  0;
      WPE       at 0 range  1 ..  1;
      SUP       at 0 range  2 ..  2;
      UM        at 0 range  3 ..  3;
      WPS       at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  7;
      OSCE      at 0 range  8 ..  8;
      CLKO      at 0 range  9 ..  9;
      SC16P     at 0 range 10 .. 10;
      SC8P      at 0 range 11 .. 11;
      SC4P      at 0 range 12 .. 12;
      SC2P      at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 14;
      Reserved3 at 0 range 15 .. 31;
   end record;

   RTC_CR_ADDRESS : constant := 16#4003_D010#;

   RTC_CR : aliased RTC_CR_Type
      with Address              => System'To_Address (RTC_CR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.6 RTC Status Register (RTC_SR)

   type RTC_SR_Type is record
      TIF       : Boolean := False; -- Time Invalid Flag
      TOF       : Boolean := False; -- Time Overflow Flag
      TAF       : Boolean := False; -- Time Alarm Flag
      Reserved1 : Bits_1  := 0;
      TCE       : Boolean := False; -- Time Counter Enable
      Reserved2 : Bits_27 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_SR_Type use record
      TIF       at 0 range 0 ..  0;
      TOF       at 0 range 1 ..  1;
      TAF       at 0 range 2 ..  2;
      Reserved1 at 0 range 3 ..  3;
      TCE       at 0 range 4 ..  4;
      Reserved2 at 0 range 5 .. 31;
   end record;

   RTC_SR_ADDRESS : constant := 16#4003_D014#;

   RTC_SR : aliased RTC_SR_Type
      with Address              => System'To_Address (RTC_SR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.7 RTC Lock Register (RTC_LR)

   type RTC_LR_Type is record
      Reserved1 : Bits_3  := 2#111#;
      TCL       : Boolean := True;   -- Time Compensation Lock
      CRL       : Boolean := True;   -- Control Register Lock
      SRL       : Boolean := True;   -- Status Register Lock
      LRL       : Boolean := True;   -- Lock Register Lock
      Reserved2 : Bits_1  := 1;
      Reserved3 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_LR_Type use record
      Reserved1 at 0 range 0 ..  2;
      TCL       at 0 range 3 ..  3;
      CRL       at 0 range 4 ..  4;
      SRL       at 0 range 5 ..  5;
      LRL       at 0 range 6 ..  6;
      Reserved2 at 0 range 7 ..  7;
      Reserved3 at 0 range 8 .. 31;
   end record;

   RTC_LR_ADDRESS : constant := 16#4003_D018#;

   RTC_LR : aliased RTC_LR_Type
      with Address              => System'To_Address (RTC_LR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 34.2.8 RTC Interrupt Enable Register (RTC_IER)

   type RTC_IER_Type is record
      TIIE      : Boolean := True; -- Time Invalid Interrupt Enable
      TOIE      : Boolean := True; -- Time Overflow Interrupt Enable
      TAIE      : Boolean := True; -- Time Alarm Interrupt Enable
      Reserved1 : Bits_1  := 0;
      TSIE      : Boolean;         -- Time Seconds Interrupt Enable
      Reserved2 : Bits_2  := 0;
      WPON      : Boolean;         -- Wakeup Pin On
      Reserved3 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTC_IER_Type use record
      TIIE      at 0 range 0 ..  0;
      TOIE      at 0 range 1 ..  1;
      TAIE      at 0 range 2 ..  2;
      Reserved1 at 0 range 3 ..  3;
      TSIE      at 0 range 4 ..  4;
      Reserved2 at 0 range 5 ..  6;
      WPON      at 0 range 7 ..  7;
      Reserved3 at 0 range 8 .. 31;
   end record;

   RTC_IER_ADDRESS : constant := 16#4003_D01C#;

   RTC_IER : aliased RTC_IER_Type
      with Address              => System'To_Address (RTC_IER_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 39 Universal Asynchronous Receiver/Transmitter (UART0)
   ----------------------------------------------------------------------------

   -- 39.2.1 UART Baud Rate Register High (UARTx_BDH)

   SBNS_1 : constant := 0; -- One stop bit.
   SBNS_2 : constant := 1; -- Two stop bit.

   type UARTx_BDH_Type is record
      SBR     : Bits_5  := 0;      -- Baud Rate Modulo Divisor.
      SBNS    : Bits_1  := SBNS_1; -- Stop Bit Number Select
      RXEDGIE : Boolean := False;  -- RX Input Active Edge Interrupt Enable (for RXEDGIF)
      LBKDIE  : Boolean := False;  -- LIN Break Detect Interrupt Enable (for LBKDIF)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_BDH_Type use record
      SBR     at 0 range 0 .. 4;
      SBNS    at 0 range 5 .. 5;
      RXEDGIE at 0 range 6 .. 6;
      LBKDIE  at 0 range 7 .. 7;
   end record;

   -- 39.2.2 UART Baud Rate Register Low (UARTx_BDL)

   type UARTx_BDL_Type is record
      SBR : Bits_8 := 4; -- Baud Rate Modulo Divisor.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_BDL_Type use record
      SBR at 0 range 0 .. 7;
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

   RSRC_LOOPBACK  : constant := 0; -- Provided LOOPS is set, RSRC is cleared, selects internal loop back mode and the UART does not use the UART_RX pins.
   RSRC_UART1WIRE : constant := 1; -- Single-wire UART mode where the UART_TX pin is connected to the transmitter output and receiver input.

   LOOPS_NORMAL        : constant := 0; -- Normal operation - UART_RX and UART_TX use separate pins.
   LOOPS_LOOPUART1WIRE : constant := 1; -- Loop mode or single-wire mode where transmitter outputs are internally connected to receiver input. (See RSRC bit.) UART_RX pin is not used by UART.

   type UARTx_C1_Type is record
      PT     : Bits_1  := PT_EVEN;       -- Parity Type
      PE     : Boolean := False;         -- Parity Enable
      ILT    : Bits_1  := ILT_START;     -- Idle Line Type Select
      WAKE   : Bits_1  := WAKE_IDLELINE; -- Receiver Wakeup Method Select
      M      : Bits_1  := M_8;           -- 9-Bit or 8-Bit Mode Select
      RSRC   : Bits_1  := RSRC_LOOPBACK; -- Receiver Source Select
      DOZEEN : Boolean := False;         -- Doze Enable
      LOOPS  : Bits_1  := LOOPS_NORMAL;  -- Loop Mode Select
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
      SBK  : Boolean := False; -- Send Break
      RWU  : Boolean := False; -- Receiver Wakeup Control
      RE   : Boolean := False; -- Receiver Enable
      TE   : Boolean := False; -- Transmitter Enable
      ILIE : Boolean := False; -- Idle Line Interrupt Enable for IDLE
      RIE  : Boolean := False; -- Receiver Interrupt Enable for RDRF
      TCIE : Boolean := False; -- Transmission Complete Interrupt Enable for TC
      TIE  : Boolean := False; -- Transmit Interrupt Enable for TDRE
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
      RAF     : Boolean := False; -- Receiver Active Flag
      LBKDE   : Boolean := False; -- LIN Break Detection Enable
      BRK13   : Boolean := False; -- Break Character Generation Length
      RWUID   : Boolean := False; -- Receive Wake Up Idle Detect
      RXINV   : Boolean := False; -- Receive Data Inversion
      MSBF    : Boolean := False; -- MSB First
      RXEDGIF : Boolean := False; -- UART_RX Pin Active Edge Interrupt Flag
      LBKDIF  : Boolean := False; -- LIN Break Detect Interrupt Flag
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
      PEIE  : Boolean := False; -- Parity Error Interrupt Enable
      FEIE  : Boolean := False; -- Framing Error Interrupt Enable
      NEIE  : Boolean := False; -- Noise Error Interrupt Enable
      ORIE  : Boolean := False; -- Overrun Interrupt Enable
      TXINV : Boolean := False; -- Transmit Data Inversion
      TXDIR : Boolean := False; -- UART_TX Pin Direction in Single-Wire Mode
      R9T8  : Boolean := False; -- Receive Bit 9 / Transmit Bit 8
      R8T9  : Boolean := False; -- Receive Bit 8 / Transmit Bit 9
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

   -- 39.2.8 UART Data Register (UARTx_D)

   type UARTx_D_Type is record
      RT : Unsigned_8; -- Read receive data buffer ? or write transmit data buffer ?.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_D_Type use record
      RT at 0 range 0 .. 7;
   end record;

   -- 39.2.9 UART Match Address Registers 1 (UARTx_MA1)

   type UARTx_MA1_Type is record
      MA : Unsigned_8 := 0; -- Match Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_MA1_Type use record
      MA at 0 range 0 .. 7;
   end record;

   -- 39.2.10 UART Match Address Registers 2 (UARTx_MA2)

   type UARTx_MA2_Type is record
      MA : Unsigned_8 := 0; -- Match Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UARTx_MA2_Type use record
      MA at 0 range 0 .. 7;
   end record;

   -- 39.2.11 UART Control Register 4 (UARTx_C4)

   OSR_4x  : constant := 2#00011#; -- oversampling ratio for the receiver = 4x
   OSR_8x  : constant := 2#00111#; -- oversampling ratio for the receiver = 8x
   OSR_16x : constant := 2#01111#; -- oversampling ratio for the receiver = 16x
   OSR_32x : constant := 2#11111#; -- oversampling ratio for the receiver = 32x

   type UART0_C4_Type is record
      OSR   : Bits_5  := OSR_16x; -- Over Sampling Ratio
      M10   : Boolean := False;   -- 10-bit Mode select
      MAEN2 : Boolean := False;   -- Match Address Mode Enable 2
      MAEN1 : Boolean := False;   -- Match Address Mode Enable 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UART0_C4_Type use record
      OSR   at 0 range 0 .. 4;
      M10   at 0 range 5 .. 5;
      MAEN2 at 0 range 6 .. 6;
      MAEN1 at 0 range 7 .. 7;
   end record;

   -- 39.2.12 UART Control Register 5 (UARTx_C5)

   type UART0_C5_Type is record
      RESYNCDIS : Boolean := False; -- Resynchronization Disable
      BOTHEDGE  : Boolean := False; -- Both Edge Sampling
      Reserved1 : Bits_3  := 0;
      RDMAE     : Boolean := False; -- Receiver Full DMA Enable
      Reserved2 : Bits_1  := 0;
      TDMAE     : Boolean := False; -- Transmitter DMA Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UART0_C5_Type use record
      RESYNCDIS at 0 range 0 .. 0;
      BOTHEDGE  at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      RDMAE     at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      TDMAE     at 0 range 7 .. 7;
   end record;

   -- 39.2 Register definition

   type UART_0_Type is record
      BDH : UARTx_BDH_Type with Volatile_Full_Access => True;
      BDL : UARTx_BDL_Type with Volatile_Full_Access => True;
      C1  : UARTx_C1_Type  with Volatile_Full_Access => True;
      C2  : UARTx_C2_Type  with Volatile_Full_Access => True;
      S1  : UARTx_S1_Type  with Volatile_Full_Access => True;
      S2  : UARTx_S2_Type  with Volatile_Full_Access => True;
      C3  : UARTx_C3_Type  with Volatile_Full_Access => True;
      D   : UARTx_D_Type   with Volatile_Full_Access => True;
      MA1 : UARTx_MA1_Type with Volatile_Full_Access => True;
      MA2 : UARTx_MA2_Type with Volatile_Full_Access => True;
      C4  : UART0_C4_Type  with Volatile_Full_Access => True;
      C5  : UART0_C5_Type  with Volatile_Full_Access => True;
   end record
      with Size => 16#C# * 8;
   for UART_0_Type use record
      BDH at 16#0# range 0 .. 7;
      BDL at 16#1# range 0 .. 7;
      C1  at 16#2# range 0 .. 7;
      C2  at 16#3# range 0 .. 7;
      S1  at 16#4# range 0 .. 7;
      S2  at 16#5# range 0 .. 7;
      C3  at 16#6# range 0 .. 7;
      D   at 16#7# range 0 .. 7;
      MA1 at 16#8# range 0 .. 7;
      MA2 at 16#9# range 0 .. 7;
      C4  at 16#A# range 0 .. 7;
      C5  at 16#B# range 0 .. 7;
   end record;

   UART0 : aliased UART_0_Type
      with Address    => System'To_Address (16#4006_A000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 40 Universal Asynchronous Receiver/Transmitter (UART1 and UART2)
   ----------------------------------------------------------------------------

   -- 40.2.9 UART Control Register 4 (UARTx_C4)

   type UART12_C4_Type is record
      Reserved1 : Bits_3  := 0;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_1  := 0;
      RDMAS     : Boolean := False; -- Receiver Full DMA Select
      Reserved4 : Bits_1  := 0;
      TDMAS     : Boolean := False; -- Transmitter DMA Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UART12_C4_Type use record
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
      BDL : UARTx_BDL_Type with Volatile_Full_Access => True;
      C1  : UARTx_C1_Type  with Volatile_Full_Access => True;
      C2  : UARTx_C2_Type  with Volatile_Full_Access => True;
      S1  : UARTx_S1_Type  with Volatile_Full_Access => True;
      S2  : UARTx_S2_Type  with Volatile_Full_Access => True;
      C3  : UARTx_C3_Type  with Volatile_Full_Access => True;
      D   : UARTx_D_Type   with Volatile_Full_Access => True;
      C4  : UART12_C4_Type with Volatile_Full_Access => True;
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

   UART1 : aliased UART_12_Type
      with Address    => System'To_Address (16#4006_B000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   UART2 : aliased UART_12_Type
      with Address    => System'To_Address (16#4006_C000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 42 General-Purpose Input/Output (GPIO)
   ----------------------------------------------------------------------------

   GPIO_BASEADDRESS : constant := 16#400F_F000#;

   -- 42.2.1 Port Data Output Register (GPIOx_PDOR)
   -- 42.2.2 Port Set Output Register (GPIOx_PSOR)
   -- 42.2.3 Port Clear Output Register (GPIOx_PCOR)
   -- 42.2.4 Port Toggle Output Register (GPIOx_PTOR)
   -- 42.2.5 Port Data Input Register (GPIOx_PDIR)
   -- 42.2.6 Port Data Direction Register (GPIOx_PDDR)

   type GPIO_PORT_Type is record
      PDOR : Bitmap_32 with Volatile_Full_Access => True;
      PSOR : Bitmap_32 with Volatile_Full_Access => True;
      PCOR : Bitmap_32 with Volatile_Full_Access => True;
      PTOR : Bitmap_32 with Volatile_Full_Access => True;
      PDIR : Bitmap_32 with Volatile_Full_Access => True;
      PDDR : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 16#18# * 8;
   for GPIO_PORT_Type use record
      PDOR at 16#00# range 0 .. 31;
      PSOR at 16#04# range 0 .. 31;
      PCOR at 16#08# range 0 .. 31;
      PTOR at 16#0C# range 0 .. 31;
      PDIR at 16#10# range 0 .. 31;
      PDDR at 16#14# range 0 .. 31;
   end record;

   -- 42.2 Memory map and register definition

   GPIOA : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOB : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#040#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOC : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#080#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOD : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#0C0#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   GPIOE : aliased GPIO_PORT_Type
      with Address    => System'To_Address (GPIO_BASEADDRESS + 16#100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end KL46Z;
