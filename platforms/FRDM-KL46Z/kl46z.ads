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

   MUX_ALT0 : constant := 2#000#; -- Pin disabled (analog).
   MUX_ALT1 : constant := 2#001#; -- Alternative 1 (GPIO).
   MUX_ALT2 : constant := 2#010#; -- Alternative 2 (chip-specific).
   MUX_ALT3 : constant := 2#011#; -- Alternative 3 (chip-specific).
   MUX_ALT4 : constant := 2#100#; -- Alternative 4 (chip-specific).
   MUX_ALT5 : constant := 2#101#; -- Alternative 5 (chip-specific).
   MUX_ALT6 : constant := 2#110#; -- Alternative 6 (chip-specific).
   MUX_ALT7 : constant := 2#111#; -- Alternative 7 (chip-specific).
   MUX_DISABLED renames MUX_ALT0;
   MUX_GPIO renames MUX_ALT1;

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
      PS        : Bits_1  := PS_PULLDOWN;   -- Pull Select
      PE        : Boolean := False;         -- Pull Enable
      SRE       : Boolean := False;         -- Slew Rate Enable
      Reserved1 : Bits_1  := 0;
      PFE       : Boolean := False;         -- Passive Filter Enable
      Reserved2 : Bits_1  := 0;
      DSE       : Boolean := False;         -- Drive Strength Enable
      Reserved3 : Bits_1  := 0;
      MUX       : Bits_3  := MUX_DISABLED;  -- Pin Mux Control
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
      Reserved1 : Bits_6  := 0;
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
      OUTDIV1   : Bits_4  := OUTDIV1_DIV1; -- Clock 1 Output Divider value
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
      FLASHDIS  : Boolean := False;    -- Flash Disable
      FLASHDOZE : Boolean := False;    -- Flash Doze
      Reserved1 : Bits_22 := 0;
      PFSIZE    : Bits_4  := PFSIZE_8; -- Program Flash Size
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
   -- Chapter 15 Low-Leakage Wakeup Unit (LLWU)
   ----------------------------------------------------------------------------

   -- 15.3.1 LLWU Pin Enable 1 register (LLWU_PE1)
   -- 15.3.2 LLWU Pin Enable 2 register (LLWU_PE2)
   -- 15.3.3 LLWU Pin Enable 3 register (LLWU_PE3)
   -- 15.3.4 LLWU Pin Enable 4 register (LLWU_PE4)

   WUPEx_EXTDISABLE : constant := 2#00#; -- External input pin disabled as wakeup input
   WUPEx_EXTRISE    : constant := 2#01#; -- External input pin enabled with rising edge detection
   WUPEx_EXTFALL    : constant := 2#10#; -- External input pin enabled with falling edge detection
   WUPEx_EXTANYCHG  : constant := 2#11#; -- External input pin enabled with any change detection

   type LLWU_PE1_Type is record
      WUPE0 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P0
      WUPE1 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P0
      WUPE2 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P0
      WUPE3 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P0
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_PE1_Type use record
      WUPE0 at 0 range 0 .. 1;
      WUPE1 at 0 range 2 .. 3;
      WUPE2 at 0 range 4 .. 5;
      WUPE3 at 0 range 6 .. 7;
   end record;

   type LLWU_PE2_Type is record
      WUPE4 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P4
      WUPE5 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P5
      WUPE6 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P6
      WUPE7 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_PE2_Type use record
      WUPE4 at 0 range 0 .. 1;
      WUPE5 at 0 range 2 .. 3;
      WUPE6 at 0 range 4 .. 5;
      WUPE7 at 0 range 6 .. 7;
   end record;

   type LLWU_PE3_Type is record
      WUPE8  : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P8
      WUPE9  : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P9
      WUPE10 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P10
      WUPE11 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P11
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_PE3_Type use record
      WUPE8  at 0 range 0 .. 1;
      WUPE9  at 0 range 2 .. 3;
      WUPE10 at 0 range 4 .. 5;
      WUPE11 at 0 range 6 .. 7;
   end record;

   type LLWU_PE4_Type is record
      WUPE12 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P12
      WUPE13 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P13
      WUPE14 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P14
      WUPE15 : Bits_2 := WUPEx_EXTDISABLE; -- Wakeup Pin Enable For LLWU_P15
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_PE4_Type use record
      WUPE12 at 0 range 0 .. 1;
      WUPE13 at 0 range 2 .. 3;
      WUPE14 at 0 range 4 .. 5;
      WUPE15 at 0 range 6 .. 7;
   end record;

   LLWU_PE1_ADDRESS : constant := 16#4007_C000#;

   LLWU_PE1 : aliased LLWU_PE1_Type
      with Address              => System'To_Address (LLWU_PE1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   LLWU_PE2_ADDRESS : constant := 16#4007_C001#;

   LLWU_PE2 : aliased LLWU_PE2_Type
      with Address              => System'To_Address (LLWU_PE2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   LLWU_PE3_ADDRESS : constant := 16#4007_C002#;

   LLWU_PE3 : aliased LLWU_PE3_Type
      with Address              => System'To_Address (LLWU_PE3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   LLWU_PE4_ADDRESS : constant := 16#4007_C003#;

   LLWU_PE4 : aliased LLWU_PE4_Type
      with Address              => System'To_Address (LLWU_PE4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.5 LLWU Module Enable register (LLWU_ME)

   type LLWU_ME_Type is record
      WUME0 : Boolean := False; -- Wakeup Module Enable For Module 0
      WUME1 : Boolean := False; -- Wakeup Module Enable For Module 1
      WUME2 : Boolean := False; -- Wakeup Module Enable For Module 2
      WUME3 : Boolean := False; -- Wakeup Module Enable For Module 3
      WUME4 : Boolean := False; -- Wakeup Module Enable For Module 4
      WUME5 : Boolean := False; -- Wakeup Module Enable For Module 5
      WUME6 : Boolean := False; -- Wakeup Module Enable For Module 6
      WUME7 : Boolean := False; -- Wakeup Module Enable For Module 7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_ME_Type use record
      WUME0 at 0 range 0 .. 0;
      WUME1 at 0 range 1 .. 1;
      WUME2 at 0 range 2 .. 2;
      WUME3 at 0 range 3 .. 3;
      WUME4 at 0 range 4 .. 4;
      WUME5 at 0 range 5 .. 5;
      WUME6 at 0 range 6 .. 6;
      WUME7 at 0 range 7 .. 7;
   end record;

   LLWU_ME_ADDRESS : constant := 16#4007_C004#;

   LLWU_ME : aliased LLWU_ME_Type
      with Address              => System'To_Address (LLWU_ME_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.6 LLWU Flag 1 register (LLWU_F1)

   type LLWU_F1_Type is record
      WUF0 : Boolean := False; -- Wakeup Flag For LLWU_P0
      WUF1 : Boolean := False; -- Wakeup Flag For LLWU_P1
      WUF2 : Boolean := False; -- Wakeup Flag For LLWU_P2
      WUF3 : Boolean := False; -- Wakeup Flag For LLWU_P3
      WUF4 : Boolean := False; -- Wakeup Flag For LLWU_P4
      WUF5 : Boolean := False; -- Wakeup Flag For LLWU_P5
      WUF6 : Boolean := False; -- Wakeup Flag For LLWU_P6
      WUF7 : Boolean := False; -- Wakeup Flag For LLWU_P7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_F1_Type use record
      WUF0 at 0 range 0 .. 0;
      WUF1 at 0 range 1 .. 1;
      WUF2 at 0 range 2 .. 2;
      WUF3 at 0 range 3 .. 3;
      WUF4 at 0 range 4 .. 4;
      WUF5 at 0 range 5 .. 5;
      WUF6 at 0 range 6 .. 6;
      WUF7 at 0 range 7 .. 7;
   end record;

   LLWU_F1_ADDRESS : constant := 16#4007_C005#;

   LLWU_F1 : aliased LLWU_F1_Type
      with Address              => System'To_Address (LLWU_F1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.7 LLWU Flag 2 register (LLWU_F2)

   type LLWU_F2_Type is record
      WUF8  : Boolean := False; -- Wakeup Flag For LLWU_P8
      WUF9  : Boolean := False; -- Wakeup Flag For LLWU_P9
      WUF10 : Boolean := False; -- Wakeup Flag For LLWU_P10
      WUF11 : Boolean := False; -- Wakeup Flag For LLWU_P11
      WUF12 : Boolean := False; -- Wakeup Flag For LLWU_P12
      WUF13 : Boolean := False; -- Wakeup Flag For LLWU_P13
      WUF14 : Boolean := False; -- Wakeup Flag For LLWU_P14
      WUF15 : Boolean := False; -- Wakeup Flag For LLWU_P15
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_F2_Type use record
      WUF8  at 0 range 0 .. 0;
      WUF9  at 0 range 1 .. 1;
      WUF10 at 0 range 2 .. 2;
      WUF11 at 0 range 3 .. 3;
      WUF12 at 0 range 4 .. 4;
      WUF13 at 0 range 5 .. 5;
      WUF14 at 0 range 6 .. 6;
      WUF15 at 0 range 7 .. 7;
   end record;

   LLWU_F2_ADDRESS : constant := 16#4007_C006#;

   LLWU_F2 : aliased LLWU_F2_Type
      with Address              => System'To_Address (LLWU_F2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.8 LLWU Flag 3 register (LLWU_F3)

   type LLWU_F3_Type is record
      MWUF0 : Boolean := False; -- Wakeup flag For module 0
      MWUF1 : Boolean := False; -- Wakeup flag For module 1
      MWUF2 : Boolean := False; -- Wakeup flag For module 2
      MWUF3 : Boolean := False; -- Wakeup flag For module 3
      MWUF4 : Boolean := False; -- Wakeup flag For module 4
      MWUF5 : Boolean := False; -- Wakeup flag For module 5
      MWUF6 : Boolean := False; -- Wakeup flag For module 6
      MWUF7 : Boolean := False; -- Wakeup flag For module 7
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_F3_Type use record
      MWUF0 at 0 range 0 .. 0;
      MWUF1 at 0 range 1 .. 1;
      MWUF2 at 0 range 2 .. 2;
      MWUF3 at 0 range 3 .. 3;
      MWUF4 at 0 range 4 .. 4;
      MWUF5 at 0 range 5 .. 5;
      MWUF6 at 0 range 6 .. 6;
      MWUF7 at 0 range 7 .. 7;
   end record;

   LLWU_F3_ADDRESS : constant := 16#4007_C007#;

   LLWU_F3 : aliased LLWU_F3_Type
      with Address              => System'To_Address (LLWU_F3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.9 LLWU Pin Filter 1 register (LLWU_FILT1)
   -- 15.3.10 LLWU Pin Filter 2 register (LLWU_FILT2)

   FILTSEL_LLWU_P0  : constant := 2#0000#; -- Select LLWU_P0 for filter
   FILTSEL_LLWU_P1  : constant := 2#0001#; -- Select LLWU_P1 for filter
   FILTSEL_LLWU_P2  : constant := 2#0010#; -- Select LLWU_P2 for filter
   FILTSEL_LLWU_P3  : constant := 2#0011#; -- Select LLWU_P3 for filter
   FILTSEL_LLWU_P4  : constant := 2#0100#; -- Select LLWU_P4 for filter
   FILTSEL_LLWU_P5  : constant := 2#0101#; -- Select LLWU_P5 for filter
   FILTSEL_LLWU_P6  : constant := 2#0110#; -- Select LLWU_P6 for filter
   FILTSEL_LLWU_P7  : constant := 2#0111#; -- Select LLWU_P7 for filter
   FILTSEL_LLWU_P8  : constant := 2#1000#; -- Select LLWU_P8 for filter
   FILTSEL_LLWU_P9  : constant := 2#1001#; -- Select LLWU_P9 for filter
   FILTSEL_LLWU_P10 : constant := 2#1010#; -- Select LLWU_P10 for filter
   FILTSEL_LLWU_P11 : constant := 2#1011#; -- Select LLWU_P11 for filter
   FILTSEL_LLWU_P12 : constant := 2#1100#; -- Select LLWU_P12 for filter
   FILTSEL_LLWU_P13 : constant := 2#1101#; -- Select LLWU_P13 for filter
   FILTSEL_LLWU_P14 : constant := 2#1110#; -- Select LLWU_P14 for filter
   FILTSEL_LLWU_P15 : constant := 2#1111#; -- Select LLWU_P15 for filter

   FILTE_DISABLE : constant := 2#00#; -- Filter disabled
   FILTE_POSEDGE : constant := 2#01#; -- Filter posedge detect enabled
   FILTE_NEGEDGE : constant := 2#10#; -- Filter negedge detect enabled
   FILTE_ANYEDGE : constant := 2#11#; -- Filter any edge detect enabled

   type LLWU_FILT1_Type is record
      FILTSEL  : Bits_4  := FILTSEL_LLWU_P0; -- Filter Pin Select
      Reserved : Bits_1  := 0;
      FILTE    : Bits_2  := FILTE_DISABLE;   -- Digital Filter On External Pin
      FILTF    : Boolean := False;           -- Filter Detect Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_FILT1_Type use record
      FILTSEL  at 0 range 0 .. 3;
      Reserved at 0 range 4 .. 4;
      FILTE    at 0 range 5 .. 6;
      FILTF    at 0 range 7 .. 7;
   end record;

   type LLWU_FILT2_Type is record
      FILTSEL  : Bits_4  := FILTSEL_LLWU_P0; -- Filter Pin Select
      Reserved : Bits_1  := 0;
      FILTE    : Bits_2  := FILTE_DISABLE;   -- Digital Filter On External Pin
      FILTF    : Boolean := False;           -- Filter Detect Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for LLWU_FILT2_Type use record
      FILTSEL  at 0 range 0 .. 3;
      Reserved at 0 range 4 .. 4;
      FILTE    at 0 range 5 .. 6;
      FILTF    at 0 range 7 .. 7;
   end record;

   LLWU_FILT1_ADDRESS : constant := 16#4007_C008#;

   LLWU_FILT1 : aliased LLWU_FILT1_Type
      with Address              => System'To_Address (LLWU_FILT1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   LLWU_FILT2_ADDRESS : constant := 16#4007_C009#;

   LLWU_FILT2 : aliased LLWU_FILT2_Type
      with Address              => System'To_Address (LLWU_FILT2_ADDRESS),
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
   -- Chapter 18 Miscellaneous Control Module (MCM)
   ----------------------------------------------------------------------------

   -- 18.2.1 Crossbar Switch (AXBS) Slave Configuration (MCM_PLASC)

   type MCM_PLASC_Type is record
      ASC      : Bitmap_8; -- Each bit in the ASC field indicates whether there is a corresponding connection to the crossbar switch's slave input port.
      Reserved : Bits_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for MCM_PLASC_Type use record
      ASC      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   MSM_PLASC_ADDRESS : constant := 16#F000_3008#;

   MCM_PLASC : aliased MCM_PLASC_Type
      with Address              => System'To_Address (MSM_PLASC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.2.2 Crossbar Switch (AXBS) Master Configuration (MCM_PLAMC)

   type MCM_PLAMC_Type is record
      AMC      : Bitmap_8; -- Each bit in the AMC field indicates whether there is a corresponding connection to the AXBS master input port.
      Reserved : Bits_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for MCM_PLAMC_Type use record
      AMC      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   MCM_PLAMC_ADDRESS : constant := 16#F000_300A#;

   MCM_PLAMC : aliased MCM_PLAMC_Type
      with Address              => System'To_Address (MCM_PLAMC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.2.3 Platform Control Register (MCM_PLACR)

   ARB_FIXED : constant := 0; -- Fixed-priority arbitration for the crossbar masters
   ARB_RR    : constant := 1; -- Round-robin arbitration for the crossbar masters

   type MCM_PLACR_Type is record
      Reserved1 : Bits_9  := 0;
      ARB       : Bits_1  := ARB_FIXED; -- Arbitration select
      CFCC      : Boolean := False;     -- Clear Flash Controller Cache
      DFCDA     : Boolean := False;     -- Disable Flash Controller Data Caching
      DFCIC     : Boolean := False;     -- Disable Flash Controller Instruction Caching
      DFCC      : Boolean := False;     -- Disable Flash Controller Cache
      EFDS      : Boolean := False;     -- Enable Flash Data Speculation
      DFCS      : Boolean := False;     -- Disable Flash Controller Speculation
      ESFC      : Boolean := False;     -- Enable Stalling Flash Controller
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_PLACR_Type use record
      Reserved1 at 0 range  0 ..  8;
      ARB       at 0 range  9 ..  9;
      CFCC      at 0 range 10 .. 10;
      DFCDA     at 0 range 11 .. 11;
      DFCIC     at 0 range 12 .. 12;
      DFCC      at 0 range 13 .. 13;
      EFDS      at 0 range 14 .. 14;
      DFCS      at 0 range 15 .. 15;
      ESFC      at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   MCM_PLACR_ADDRESS : constant := 16#F000_300C#;

   MCM_PLACR : aliased MCM_PLACR_Type
      with Address              => System'To_Address (MCM_PLACR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 18.2.4 Compute Operation Control Register (MCM_CPO)

   type MCM_CPO_Type is record
      CPOREQ   : Boolean := False; -- Compute Operation request
      CPOACK   : Boolean := False; -- Compute Operation acknowledge
      CPOWOI   : Boolean := False; -- Compute Operation wakeup on interrupt
      Reserved : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MCM_CPO_Type use record
      CPOREQ    at 0 range 0 ..  0;
      CPOACK    at 0 range 1 ..  1;
      CPOWOI    at 0 range 2 ..  2;
      Reserved  at 0 range 3 .. 31;
   end record;

   MCM_CPO_ADDRESS : constant := 16#F000_3040#;

   MCM_CPO : aliased MCM_CPO_Type
      with Address              => System'To_Address (MCM_CPO_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 19 Micro Trace Buffer (MTB)
   ----------------------------------------------------------------------------

   -- 19.31.1 MTB Position Register (MTB_POSITION)
   -- 19.31.2 MTB Master Register (MTB_MASTER)
   -- 19.31.3 MTB Flow Register (MTB_FLOW)
   -- 19.31.4 MTB Base Register (MTB_BASE)
   -- 19.31.5 Integration Mode Control Register (MTB_MODECTRL)
   -- 19.31.6 Claim TAG Set Register (MTB_TAGSET)
   -- 19.31.7 Claim TAG Clear Register (MTB_TAGCLEAR)
   -- 19.31.8 Lock Access Register (MTB_LOCKACCESS)
   -- 19.31.9 Lock Status Register (MTB_LOCKSTAT)
   -- 19.31.10 Authentication Status Register (MTB_AUTHSTAT)
   -- 19.31.11 Device Architecture Register (MTB_DEVICEARCH)
   -- 19.31.12 Device Configuration Register (MTB_DEVICECFG)
   -- 19.31.13 Device Type Identifier Register (MTB_DEVICETYPID)
   -- 19.31.14 Peripheral ID Register (MTB_PERIPHIDn)
   -- 19.31.15 Component ID Register (MTB_COMPIDn)

   -- 19.32.1 MTB DWT Control Register (MTBDWT_CTRL)
   -- 19.32.2 MTB_DWT Comparator Register (MTBDWT_COMPn)
   -- 19.32.3 MTB_DWT Comparator Mask Register (MTBDWT_MASKn)
   -- 19.32.4 MTB_DWT Comparator Function Register 0 (MTBDWT_FCT0)
   -- 19.32.5 MTB_DWT Comparator Function Register 1 (MTBDWT_FCT1)
   -- 19.32.6 MTB_DWT Trace Buffer Control Register (MTBDWT_TBCTRL)
   -- 19.32.7 Device Configuration Register (MTBDWT_DEVICECFG)
   -- 19.32.8 Device Type Identifier Register (MTBDWT_DEVICETYPID)
   -- 19.32.9 Peripheral ID Register (MTBDWT_PERIPHIDn)
   -- 19.32.10 Component ID Register (MTBDWT_COMPIDn)

   -- 19.33.1 Entry (ROM_ENTRYn)
   -- 19.33.2 End of Table Marker Register (ROM_TABLEMARK)
   -- 19.33.3 System Access Register (ROM_SYSACCESS)
   -- 19.33.4 Peripheral ID Register (ROM_PERIPHIDn)
   -- 19.33.5 Component ID Register (ROM_COMPIDn)

   ----------------------------------------------------------------------------
   -- Definitions for DMA
   ----------------------------------------------------------------------------

   -- constants for indexing DMA channels in array objects
   DMA0 : constant := 0;
   DMA1 : constant := 1;
   DMA2 : constant := 2;
   DMA3 : constant := 3;

   ----------------------------------------------------------------------------
   -- Chapter 22 Direct Memory Access Multiplexer (DMAMUX)
   ----------------------------------------------------------------------------

   -- Table 3-20. DMA request sources - MUX 0

   -- Source number                     Source module       Source description      Async DMA capable
   SOURCE_DISABLED : constant := 0;  -- —                   Channel disabled
   SOURCE_RSVD1    : constant := 1;  -- Reserved            Not used
   SOURCE_UART0RX  : constant := 2;  -- UART0               Receive                 Yes
   SOURCE_UART0TX  : constant := 3;  -- UART0               Transmit                Yes
   SOURCE_UART1RX  : constant := 4;  -- UART1               Receive
   SOURCE_UART1TX  : constant := 5;  -- UART1               Transmit
   SOURCE_UART2RX  : constant := 6;  -- UART2               Receive
   SOURCE_UART2TX  : constant := 7;  -- UART2               Transmit
   SOURCE_RSVD2    : constant := 8;  -- Reserved            —
   SOURCE_RSVD3    : constant := 9;  -- Reserved            —
   SOURCE_RSVD4    : constant := 10; -- Reserved            —
   SOURCE_RSVD5    : constant := 11; -- Reserved            —
   SOURCE_RSVD6    : constant := 12; -- Reserved            —
   SOURCE_RSVD7    : constant := 13; -- Reserved            —
   SOURCE_I2S0RX   : constant := 14; -- I2S0                Receive                 Yes
   SOURCE_I2S0TX   : constant := 15; -- I2S0                Transmit                Yes
   SOURCE_SPI0RX   : constant := 16; -- SPI0                Receive
   SOURCE_SPI0TX   : constant := 17; -- SPI0                Transmit
   SOURCE_SPI1RX   : constant := 18; -- SPI1                Receive
   SOURCE_SPI1TX   : constant := 19; -- SPI1                Transmit
   SOURCE_RSVD8    : constant := 20; -- Reserved            —
   SOURCE_RSVD9    : constant := 21; -- Reserved            —
   SOURCE_I2C0     : constant := 22; -- I2C0                —
   SOURCE_I2C1     : constant := 23; -- I2C1                —
   SOURCE_TPM0CH0  : constant := 24; -- TPM0                Channel 0               Yes
   SOURCE_TPM0CH1  : constant := 25; -- TPM0                Channel 1               Yes
   SOURCE_TPM0CH2  : constant := 26; -- TPM0                Channel 2               Yes
   SOURCE_TPM0CH3  : constant := 27; -- TPM0                Channel 3               Yes
   SOURCE_TPM0CH4  : constant := 28; -- TPM0                Channel 4               Yes
   SOURCE_TPM0CH5  : constant := 29; -- TPM0                Channel 5               Yes
   SOURCE_RSVD10   : constant := 30; -- Reserved            —
   SOURCE_RSVD11   : constant := 31; -- Reserved            —
   SOURCE_TPM1CH0  : constant := 32; -- TPM1                Channel 0               Yes
   SOURCE_TPM1CH1  : constant := 33; -- TPM1                Channel 1               Yes
   SOURCE_TPM2CH0  : constant := 34; -- TPM2                Channel 0               Yes
   SOURCE_TPM2CH1  : constant := 35; -- TPM2                Channel 1               Yes
   SOURCE_RSVD12   : constant := 36; -- Reserved            —
   SOURCE_RSVD13   : constant := 37; -- Reserved            —
   SOURCE_RSVD14   : constant := 38; -- Reserved            —
   SOURCE_RSVD15   : constant := 39; -- Reserved            —
   SOURCE_ADC0     : constant := 40; -- ADC0                —                       Yes
   SOURCE_RSVD16   : constant := 41; -- Reserved            —
   SOURCE_CMP0     : constant := 42; -- CMP0                —                       Yes
   SOURCE_RSVD17   : constant := 43; -- Reserved            —
   SOURCE_RSVD18   : constant := 44; -- Reserved            —
   SOURCE_DAC0     : constant := 45; -- DAC0                —
   SOURCE_RSVD19   : constant := 46; -- Reserved            —
   SOURCE_RSVD20   : constant := 47; -- Reserved            —
   SOURCE_RSVD21   : constant := 48; -- Reserved            —
   SOURCE_PCMPORTA : constant := 49; -- Port control module Port A                  Yes
   SOURCE_RSVD22   : constant := 50; -- Reserved            —
   SOURCE_PCMPORTC : constant := 51; -- Port control module Port C                  Yes
   SOURCE_PCMPORTD : constant := 52; -- Port control module Port D                  Yes
   SOURCE_RSVD23   : constant := 53; -- Reserved            —
   SOURCE_TPM0OVF  : constant := 54; -- TPM0                Overflow                Yes
   SOURCE_TPM1OVF  : constant := 55; -- TPM1                Overflow                Yes
   SOURCE_TPM2OVF  : constant := 56; -- TPM2                Overflow                Yes
   SOURCE_TSI      : constant := 57; -- TSI                 —                       Yes
   SOURCE_RSVD24   : constant := 58; -- Reserved            —
   SOURCE_RSVD25   : constant := 59; -- Reserved            —
   SOURCE_ENABLED1 : constant := 60; -- DMA MUX             Always enabled
   SOURCE_ENABLED2 : constant := 61; -- DMA MUX             Always enabled
   SOURCE_ENABLED3 : constant := 62; -- DMA MUX             Always enabled
   SOURCE_ENABLED4 : constant := 63; -- DMA MUX             Always enabled

   -- 22.3.1 Channel Configuration register (DMAMUXx_CHCFGn)

   type DMAMUXx_CHCFGn_Type is record
      ENBL   : Boolean := False;           -- DMA Channel Enable
      TRIG   : Boolean := False;           -- DMA Channel Trigger Enable
      SOURCE : Bits_6  := SOURCE_DISABLED; -- DMA Channel Source (Slot)
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 8,
           Volatile_Full_Access => True;
   for DMAMUXx_CHCFGn_Type use record
      ENBL   at 0 range 0 .. 0;
      TRIG   at 0 range 1 .. 1;
      SOURCE at 0 range 2 .. 7;
   end record;

   -- 22.3 Memory map/register definition

   DMAMUX0_CHCFGn_BASEADDRESS : constant := 16#4002_1000#;

   DMAMUX0_CHCFG : aliased array (DMA0 .. DMA3) of DMAMUXx_CHCFGn_Type
      with Address    => System'To_Address (DMAMUX0_CHCFGn_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 23 DMA Controller Module
   ----------------------------------------------------------------------------

   -- 23.3.1 Source Address Register (DMA_SARn)

   type DMA_SARn_Type is record
      SAR : Unsigned_32; -- Each SAR contains the byte address used by the DMA controller to read data.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_SARn_Type use record
      SAR at 0 range 0 .. 31;
   end record;

   -- 23.3.2 Destination Address Register (DMA_DARn)

   type DMA_DARn_Type is record
      DAR : Unsigned_32; -- Each DAR contains the byte address used by the DMA controller to write data.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_DARn_Type use record
      DAR at 0 range 0 .. 31;
   end record;

   -- 23.3.3 DMA Status Register / Byte Count Register (DMA_DSR_BCRn)

   type DMA_DSR_BCRn_Type is record
      BCR       : Bits_24; -- This field contains the number of bytes yet to be transferred for a given block.
      DONE      : Boolean; -- Transactions done
      BSY       : Boolean; -- Busy
      REQ       : Boolean; -- Request
      Reserved1 : Bits_1;
      BED       : Boolean; -- Bus error on destination
      BES       : Boolean; -- Bus error on source
      CE        : Boolean; -- Configuration error
      Reserved2 : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_DSR_BCRn_Type use record
      BCR       at 0 range  0 .. 23;
      DONE      at 0 range 24 .. 24;
      BSY       at 0 range 25 .. 25;
      REQ       at 0 range 26 .. 26;
      Reserved1 at 0 range 27 .. 27;
      BED       at 0 range 28 .. 28;
      BES       at 0 range 29 .. 29;
      CE        at 0 range 30 .. 30;
      Reserved2 at 0 range 31 .. 31;
   end record;

   -- 23.3.4 DMA Control Register (DMA_DCRn)

   LINKCC_NONE         : constant := 2#00#; -- No channel-to-channel linking
   LINKCC_CYCSTEALBCR0 : constant := 2#01#; -- Perform a link to channel LCH1 after each cycle-steal transfer followed by a link to LCH2 after the BCR decrements to zero
   LINKCC_CYCSTEAL     : constant := 2#10#; -- Perform a link to channel LCH1 after each cycle-steal transfer
   LINKCC_BCR0         : constant := 2#11#; -- Perform a link to channel LCH1 after the BCR decrements to zero

   DMOD_NONE : constant := 2#0000#; -- Buffer disabled
   DMOD_16   : constant := 2#0001#; -- Circular buffer size is 16 bytes
   DMOD_32   : constant := 2#0010#; -- Circular buffer size is 32 bytes
   DMOD_64   : constant := 2#0011#; -- Circular buffer size is 64 bytes
   DMOD_128  : constant := 2#0100#; -- Circular buffer size is 128 bytes
   DMOD_256  : constant := 2#0101#; -- Circular buffer size is 256 bytes
   DMOD_512  : constant := 2#0110#; -- Circular buffer size is 512 bytes
   DMOD_1K   : constant := 2#0111#; -- Circular buffer size is 1 KB
   DMOD_2K   : constant := 2#1000#; -- Circular buffer size is 2 KB
   DMOD_4K   : constant := 2#1001#; -- Circular buffer size is 4 KB
   DMOD_8K   : constant := 2#1010#; -- Circular buffer size is 8 KB
   DMOD_16K  : constant := 2#1011#; -- Circular buffer size is 16 KB
   DMOD_32K  : constant := 2#1100#; -- Circular buffer size is 32 KB
   DMOD_64K  : constant := 2#1101#; -- Circular buffer size is 64 KB
   DMOD_128K : constant := 2#1110#; -- Circular buffer size is 128 KB
   DMOD_256K : constant := 2#1111#; -- Circular buffer size is 256 KB

   SMOD_NONE renames DMOD_NONE;
   SMOD_16   renames DMOD_16;
   SMOD_32   renames DMOD_32;
   SMOD_64   renames DMOD_64;
   SMOD_128  renames DMOD_128;
   SMOD_256  renames DMOD_256;
   SMOD_512  renames DMOD_512;
   SMOD_1K   renames DMOD_1K;
   SMOD_2K   renames DMOD_2K;
   SMOD_4K   renames DMOD_4K;
   SMOD_8K   renames DMOD_8K;
   SMOD_16K  renames DMOD_16K;
   SMOD_32K  renames DMOD_32K;
   SMOD_64K  renames DMOD_64K;
   SMOD_128K renames DMOD_128K;
   SMOD_256K renames DMOD_256K;

   DSIZE_32   : constant := 2#00#; -- 32-bit
   DSIZE_8    : constant := 2#01#; -- 8-bit
   DSIZE_16   : constant := 2#10#; -- 16-bit
   DSIZE_RSVD : constant := 2#11#; -- Reserved (generates a configuration error (DSRn[CE]) if incorrectly specified at time of channel activation)

   SSIZE_32   renames DSIZE_32;
   SSIZE_8    renames DSIZE_8;
   SSIZE_16   renames DSIZE_16;
   SSIZE_RSVD renames DSIZE_RSVD;

   type DMA_DCRn_Type is record
      LCH2      : Bits_2  := DMA0;        -- Link channel 2
      LCH1      : Bits_2  := DMA0;        -- Link channel 1
      LINKCC    : Bits_2  := LINKCC_NONE; -- Link channel control
      Reserved1 : Bits_1  := 0;
      D_REQ     : Boolean := False;       -- Disable request
      DMOD      : Bits_4  := DMOD_NONE;   -- Destination address modulo
      SMOD      : Bits_4  := SMOD_NONE;   -- Source address modulo
      START     : Boolean := False;       -- Start transfer
      DSIZE     : Bits_2  := DSIZE_32;    -- Destination size
      DINC      : Boolean := False;       -- Destination increment
      SSIZE     : Bits_2  := SSIZE_32;    -- Source size
      SINC      : Boolean := False;       -- Source increment
      EADREQ    : Boolean := False;       -- Enable asynchronous DMA requests
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_3  := 0;
      AA        : Boolean := False;       -- Auto-align
      CS        : Boolean := False;       -- Cycle steal
      ERQ       : Boolean := False;       -- Enable peripheral request
      EINT      : Boolean := False;       -- Enable interrupt on completion of transfer
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for DMA_DCRn_Type use record
      LCH2      at 0 range  0 ..  1;
      LCH1      at 0 range  2 ..  3;
      LINKCC    at 0 range  4 ..  5;
      Reserved1 at 0 range  6 ..  6;
      D_REQ     at 0 range  7 ..  7;
      DMOD      at 0 range  8 .. 11;
      SMOD      at 0 range 12 .. 15;
      START     at 0 range 16 .. 16;
      DSIZE     at 0 range 17 .. 18;
      DINC      at 0 range 19 .. 19;
      SSIZE     at 0 range 20 .. 21;
      SINC      at 0 range 22 .. 22;
      EADREQ    at 0 range 23 .. 23;
      Reserved2 at 0 range 24 .. 24;
      Reserved3 at 0 range 25 .. 27;
      AA        at 0 range 28 .. 28;
      CS        at 0 range 29 .. 29;
      ERQ       at 0 range 30 .. 30;
      EINT      at 0 range 31 .. 31;
   end record;

   -- 23.3 Memory Map/Register Definition

   type DMA_Type is record
      SAR     : DMA_SARn_Type     with Volatile_Full_Access => True;
      DAR     : DMA_DARn_Type     with Volatile_Full_Access => True;
      DSR_BCR : DMA_DSR_BCRn_Type with Volatile_Full_Access => True;
      DCR     : DMA_DCRn_Type     with Volatile_Full_Access => True;
   end record
      with Size => 4 * 32;
   for DMA_Type use record
      SAR     at 16#0# range 0 .. 31;
      DAR     at 16#4# range 0 .. 31;
      DSR_BCR at 16#8# range 0 .. 31;
      DCR     at 16#C# range 0 .. 31;
   end record;

   DMA_BASEADDRESS : constant := 16#4000_8100#;

   DMA : aliased array (DMA0 .. DMA3) of DMA_Type
      with Address    => System'To_Address (DMA_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

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

   CLKS_FLLPLLCS : constant := 2#00#; -- Encoding 0 — Output of FLL or PLL is selected (depends on PLLS control bit).
   CLKS_INT      : constant := 2#01#; -- Encoding 1 — Internal reference clock is selected.
   CLKS_EXT      : constant := 2#10#; -- Encoding 2 — External reference clock is selected.
   CLKS_RSVD     : constant := 2#11#; -- Encoding 3 — Reserved.

   type MCG_C1_Type is record
      IREFSTEN : Boolean := False;         -- Internal Reference Stop Enable
      IRCLKEN  : Boolean := False;         -- Internal Reference Clock Enable
      IREFS    : Bits_1  := IREFS_INT;     -- Internal Reference Select
      FRDIV    : Bits_3  := FRDIV_1_32;    -- FLL External Reference Divider
      CLKS     : Bits_2  := CLKS_FLLPLLCS; -- Clock Source Select
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
      SCTRIM : Bits_8 := 0; -- Slow Internal Reference Clock Trim Setting
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
      SCFTRIM  : Boolean := False;      -- Slow Internal Reference Clock Fine Trim
      FCTRIM   : Bits_4  := 0;          -- Fast Internal Reference Clock Trim Setting
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

   PLLS_FLL   : constant := 0; -- FLL is selected.
   PLLS_PLLCS : constant := 1; -- PLL is selected.

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

   PLLST_FLL   : constant := 0; -- Source of PLLS clock is FLL clock.
   PLLST_PLLCS : constant := 1; -- Source of PLLS clock is PLL output clock.

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
   -- Chapter 27 Flash Memory Module (FTFA)
   ----------------------------------------------------------------------------

   -- 27.33.1 Flash Status Register (FTFA_FSTAT)

   type FTFA_FSTAT_Type is record
      MSGSTAT0 : Boolean := False; -- Memory Controller Command Completion Status Flag
      Reserved : Bits_3  := 0;
      FPVIOL   : Boolean := False; -- Flash Protection Violation Flag
      ACCERR   : Boolean := False; -- Flash Access Error Flag
      RDCOLERR : Boolean := False; -- Flash Read Collision Error Flag
      CCIF     : Boolean := False; -- Command Complete Interrupt Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FTFA_FSTAT_Type use record
      MSGSTAT0 at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 3;
      FPVIOL   at 0 range 4 .. 4;
      ACCERR   at 0 range 5 .. 5;
      RDCOLERR at 0 range 6 .. 6;
      CCIF     at 0 range 7 .. 7;
   end record;

   -- 27.33.2 Flash Configuration Register (FTFA_FCNFG)

   type FTFA_FCNFG_Type is record
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_1  := 0;
      Reserved4 : Bits_1  := 0;
      ERSSUSP   : Boolean := False; -- Erase Suspend
      ERSAREQ   : Boolean := False; -- Erase All Request
      RDCOLLIE  : Boolean := False; -- Read Collision Error Interrupt Enable
      CCIE      : Boolean := False; -- Command Complete Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FTFA_FCNFG_Type use record
      Reserved1 at 0 range 0 .. 0;
      Reserved2 at 0 range 1 .. 1;
      Reserved3 at 0 range 2 .. 2;
      Reserved4 at 0 range 3 .. 3;
      ERSSUSP   at 0 range 4 .. 4;
      ERSAREQ   at 0 range 5 .. 5;
      RDCOLLIE  at 0 range 6 .. 6;
      CCIE      at 0 range 7 .. 7;
   end record;

   -- 27.33.3 Flash Security Register (FTFA_FSEC)

   SEC_SECURE   : constant := 2#00#; -- MCU security status is secure
   SEC_SECURE_2 : constant := 2#01#; -- MCU security status is secure
   SEC_UNSECURE : constant := 2#10#; -- MCU security status is unsecure (The standard shipping condition of the flash memory module is unsecure.)
   SEC_SECURE_3 : constant := 2#11#; -- MCU security status is secure

   FSLACC_GRANTED   : constant := 2#00#; -- Freescale factory access granted
   FSLACC_DENIED    : constant := 2#01#; -- Freescale factory access denied
   FSLACC_DENIED_2  : constant := 2#10#; -- Freescale factory access denied
   FSLACC_GRANTED_2 : constant := 2#11#; -- Freescale factory access granted

   MEEN_ENABLED   : constant := 2#00#; -- Mass erase is enabled
   MEEN_ENABLED_2 : constant := 2#01#; -- Mass erase is enabled
   MEEN_DISABLED  : constant := 2#10#; -- Mass erase is disabled
   MEEN_ENABLED_3 : constant := 2#11#; -- Mass erase is enabled

   KEYEN_DISABLED_2 : constant := 2#00#; -- Backdoor key access disabled
   KEYEN_DISABLED   : constant := 2#01#; -- Backdoor key access disabled (preferred KEYEN state to disable backdoor key access)
   KEYEN_ENABLED    : constant := 2#10#; -- Backdoor key access enabled
   KEYEN_DISABLED_3 : constant := 2#11#; -- Backdoor key access disabled

   type FTFA_FSEC_Type is record
      SEC    : Bits_2; -- Flash Security
      FSLACC : Bits_2; -- Freescale Failure Analysis Access Code
      MEEN   : Bits_2; -- Mass Erase Enable Bits
      KEYEN  : Bits_2; -- Backdoor Key Security Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FTFA_FSEC_Type use record
      SEC    at 0 range 0 .. 1;
      FSLACC at 0 range 2 .. 3;
      MEEN   at 0 range 4 .. 5;
      KEYEN  at 0 range 6 .. 7;
   end record;

   -- 27.33.4 Flash Option Register (FTFA_FOPT)

   type FTFA_FOPT_Type is record
      OPT : Bits_8; -- Nonvolatile Option
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FTFA_FOPT_Type use record
      OPT at 0 range 0 .. 7;
   end record;

   -- 27.33.5 Flash Common Command Object Registers (FTFA_FCCOBn)

   type FTFA_FCCOBn_Type is record
      CCOB : Bits_8; -- The FCCOB register provides a command code and relevant parameters to the memory controller.
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 8,
           Volatile_Full_Access => True;
   for FTFA_FCCOBn_Type use record
      CCOB at 0 range 0 .. 7;
   end record;

   type FTFA_FCCOBn_Array_Type is array (Natural range <>) of FTFA_FCCOBn_Type
      with Pack => True;

   -- 27.33.6 Program Flash Protection Registers (FTFA_FPROTn)

   PROT_PROTECTED   : constant := 0; -- Program flash region is protected.
   PROT_UNPROTECTED : constant := 1; -- Program flash region is not protected

   type FTFA_FPROTn_Type is record
      PROT : Bitmap_8; -- Program Flash Region Protect
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FTFA_FPROTn_Type use record
      PROT at 0 range 0 .. 7;
   end record;

   FTFA_FSTAT_ADDRESS : constant := 16#4002_0000#;

   FTFA_FSTAT : aliased FTFA_FSTAT_Type
      with Address              => System'To_Address (FTFA_FSTAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FCNFG_ADDRESS : constant := 16#4002_0001#;

   FTFA_FCNFG : aliased FTFA_FCNFG_Type
      with Address              => System'To_Address (FTFA_FCNFG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FSEC_ADDRESS : constant := 16#4002_0002#;

   FTFA_FSEC : aliased FTFA_FSEC_Type
      with Address              => System'To_Address (FTFA_FSEC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FOPT_ADDRESS : constant := 16#4002_0003#;

   FTFA_FOPT : aliased FTFA_FOPT_Type
      with Address              => System'To_Address (FTFA_FOPT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FCCOB_ADDRESS : constant := 16#4002_0004#;

   FTFA_FCCOB : aliased FTFA_FCCOBn_Array_Type (0 .. 11)
      with Address    => System'To_Address (FTFA_FCCOB_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   FTFA_FPROT0_ADDRESS : constant := 16#4002_0010#;

   FTFA_FPROT0 : aliased FTFA_FPROTn_Type
      with Address              => System'To_Address (FTFA_FPROT0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FPROT1_ADDRESS : constant := 16#4002_0011#;

   FTFA_FPROT1 : aliased FTFA_FPROTn_Type
      with Address              => System'To_Address (FTFA_FPROT1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FPROT2_ADDRESS : constant := 16#4002_0012#;

   FTFA_FPROT2 : aliased FTFA_FPROTn_Type
      with Address              => System'To_Address (FTFA_FPROT2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   FTFA_FPROT3_ADDRESS : constant := 16#4002_0013#;

   FTFA_FPROT3 : aliased FTFA_FPROTn_Type
      with Address              => System'To_Address (FTFA_FPROT3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 28 Analog-to-Digital Converter (ADC)
   ----------------------------------------------------------------------------

   -- 28.3.1 ADC Status and Control Registers 1 (ADCx_SC1n)

   ADCH_0       : constant := 2#00000#; -- When DIFF=0, DADP0 is selected as input; when DIFF=1, DAD0 is selected as input.
   ADCH_1       : constant := 2#00001#; -- When DIFF=0, DADP1 is selected as input; when DIFF=1, DAD1 is selected as input.
   ADCH_2       : constant := 2#00010#; -- When DIFF=0, DADP2 is selected as input; when DIFF=1, DAD2 is selected as input.
   ADCH_3       : constant := 2#00011#; -- When DIFF=0, DADP3 is selected as input; when DIFF=1, DAD3 is selected as input.
   ADCH_4       : constant := 2#00100#; -- When DIFF=0, AD4 is selected as input; when DIFF=1, it is reserved.
   ADCH_5       : constant := 2#00101#; -- When DIFF=0, AD5 is selected as input; when DIFF=1, it is reserved.
   ADCH_6       : constant := 2#00110#; -- When DIFF=0, AD6 is selected as input; when DIFF=1, it is reserved.
   ADCH_7       : constant := 2#00111#; -- When DIFF=0, AD7 is selected as input; when DIFF=1, it is reserved.
   ADCH_8       : constant := 2#01000#; -- When DIFF=0, AD8 is selected as input; when DIFF=1, it is reserved.
   ADCH_9       : constant := 2#01001#; -- When DIFF=0, AD9 is selected as input; when DIFF=1, it is reserved.
   ADCH_10      : constant := 2#01010#; -- When DIFF=0, AD10 is selected as input; when DIFF=1, it is reserved.
   ADCH_11      : constant := 2#01011#; -- When DIFF=0, AD11 is selected as input; when DIFF=1, it is reserved.
   ADCH_12      : constant := 2#01100#; -- When DIFF=0, AD12 is selected as input; when DIFF=1, it is reserved.
   ADCH_13      : constant := 2#01101#; -- When DIFF=0, AD13 is selected as input; when DIFF=1, it is reserved.
   ADCH_14      : constant := 2#01110#; -- When DIFF=0, AD14 is selected as input; when DIFF=1, it is reserved.
   ADCH_15      : constant := 2#01111#; -- When DIFF=0, AD15 is selected as input; when DIFF=1, it is reserved.
   ADCH_16      : constant := 2#10000#; -- When DIFF=0, AD16 is selected as input; when DIFF=1, it is reserved.
   ADCH_17      : constant := 2#10001#; -- When DIFF=0, AD17 is selected as input; when DIFF=1, it is reserved.
   ADCH_18      : constant := 2#10010#; -- When DIFF=0, AD18 is selected as input; when DIFF=1, it is reserved.
   ADCH_19      : constant := 2#10011#; -- When DIFF=0, AD19 is selected as input; when DIFF=1, it is reserved.
   ADCH_20      : constant := 2#10100#; -- When DIFF=0, AD20 is selected as input; when DIFF=1, it is reserved.
   ADCH_21      : constant := 2#10101#; -- When DIFF=0, AD21 is selected as input; when DIFF=1, it is reserved.
   ADCH_22      : constant := 2#10110#; -- When DIFF=0, AD22 is selected as input; when DIFF=1, it is reserved.
   ADCH_23      : constant := 2#10111#; -- When DIFF=0, AD23 is selected as input; when DIFF=1, it is reserved.
   ADCH_RSVD1   : constant := 2#11000#; -- Reserved.
   ADCH_RSVD2   : constant := 2#11001#; -- Reserved.
   ADCH_TMPSENS : constant := 2#11010#; -- When DIFF=0, Temp Sensor (single-ended) is selected as input; when DIFF=1, Temp Sensor (differential) is selected as input.
   ADCH_BANDGAP : constant := 2#11011#; -- When DIFF=0,Bandgap (single-ended) is selected as input; when DIFF=1, Bandgap (differential) is selected as input.
   ADCH_RSVD3   : constant := 2#11100#; -- Reserved.
   ADCH_VREFSH  : constant := 2#11101#; -- When DIFF=0,VREFSH is selected as input; when DIFF=1, -VREFSH (differential) is selected as input.
   ADCH_VREFSL  : constant := 2#11110#; -- When DIFF=0,VREFSL is selected as input; when DIFF=1, it is reserved.
   ADCH_DISABLE : constant := 2#11111#; -- Module is disabled.

   type ADCx_SC1n_Type is record
      ADCH     : Bits_5  := ADCH_DISABLE; -- Input channel select
      DIFF     : Boolean := False;        -- Differential Mode Enable
      AIEN     : Boolean := False;        -- Interrupt Enable
      COCO     : Boolean := False;        -- Conversion Complete Flag
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_SC1n_Type use record
      ADCH     at 0 range 0 ..  4;
      DIFF     at 0 range 5 ..  5;
      AIEN     at 0 range 6 ..  6;
      COCO     at 0 range 7 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   ADC0_SC1A_ADDRESS : constant := 16#4003_B000#;

   ADC0_SC1A : aliased ADCx_SC1n_Type
      with Address              => System'To_Address (ADC0_SC1A_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC0_SC1B_ADDRESS : constant := 16#4003_B004#;

   ADC0_SC1B : aliased ADCx_SC1n_Type
      with Address              => System'To_Address (ADC0_SC1B_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.2 ADC Configuration Register 1 (ADCx_CFG1)

   ADICLK_BUSDIV1 : constant := 2#00#; -- Bus clock
   ADICLK_BUSDIV2 : constant := 2#01#; -- (Bus clock)/2
   ADICLK_ALTCLK  : constant := 2#10#; -- Alternate clock (ALTCLK)
   ADICLK_ADACK   : constant := 2#11#; -- Asynchronous clock (ADACK)

   MODE_S8D9   : constant := 2#00#; -- When DIFF=0:It is single-ended 8-bit conversion; when DIFF=1, it is differential 9-bit conversion with 2's complement output.
   MODE_S12D13 : constant := 2#01#; -- When DIFF=0:It is single-ended 12-bit conversion ; when DIFF=1, it is differential 13-bit conversion with 2's complement output.
   MODE_S10D11 : constant := 2#10#; -- When DIFF=0:It is single-ended 10-bit conversion. ; when DIFF=1, it is differential 11-bit conversion with 2's complement output
   MODE_S16D16 : constant := 2#11#; -- When DIFF=0:It is single-ended 16-bit conversion..; when DIFF=1, it is differential 16-bit conversion with 2's complement output

   ADLSMP_SHORT : constant := 0; -- Short sample time.
   ADLSMP_LONG  : constant := 1; -- Long sample time.

   ADIV_DIV1 : constant := 2#00#; -- The divide ratio is 1 and the clock rate is input clock.
   ADIV_DIV2 : constant := 2#01#; -- The divide ratio is 2 and the clock rate is (input clock)/2.
   ADIV_DIV4 : constant := 2#10#; -- The divide ratio is 4 and the clock rate is (input clock)/4.
   ADIV_DIV8 : constant := 2#11#; -- The divide ratio is 8 and the clock rate is (input clock)/8.

   type ADCx_CFG1_Type is record
      ADICLK   : Bits_2  := ADICLK_BUSDIV1; -- Input Clock Select
      MODE     : Bits_2  := MODE_S8D9;      -- Conversion mode selection
      ADLSMP   : Bits_1  := ADLSMP_SHORT;   -- Sample Time Configuration
      ADIV     : Bits_2  := ADIV_DIV1;      -- Clock Divide Select
      ADLPC    : Boolean := False;          -- Low-Power Configuration
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CFG1_Type use record
      ADICLK   at 0 range 0 ..  1;
      MODE     at 0 range 2 ..  3;
      ADLSMP   at 0 range 4 ..  4;
      ADIV     at 0 range 5 ..  6;
      ADLPC    at 0 range 7 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   ADC0_CFG1_ADDRESS : constant := 16#4003_B008#;

   ADC0_CFG1 : aliased ADCx_CFG1_Type
      with Address              => System'To_Address (ADC0_CFG1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.3 ADC Configuration Register 2 (ADCx_CFG2)

   ADLSTS_24 : constant := 2#00#; -- Default longest sample time; 20 extra ADCK cycles; 24 ADCK cycles total.
   ADLSTS_16 : constant := 2#01#; -- 12 extra ADCK cycles; 16 ADCK cycles total sample time.
   ADLSTS_10 : constant := 2#10#; -- 6 extra ADCK cycles; 10 ADCK cycles total sample time.
   ADLSTS_6  : constant := 2#11#; -- 2 extra ADCK cycles; 6 ADCK cycles total sample time.

   MUXSEL_ADxxa : constant := 0; -- ADxxa channels are selected.
   MUXSEL_ADxxb : constant := 1; -- ADxxb channels are selected.

   type ADCx_CFG2_Type is record
      ADLSTS    : Bits_2  := ADLSTS_24;    -- Long Sample Time Select
      ADHSC     : Boolean := False;        -- High-Speed Configuration
      ADACKEN   : Boolean := False;        -- Asynchronous Clock Output Enable
      MUXSEL    : Bits_1  := MUXSEL_ADxxa; -- ADC Mux Select
      Reserved1 : Bits_3  := 0;
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CFG2_Type use record
      ADLSTS    at 0 range 0 ..  1;
      ADHSC     at 0 range 2 ..  2;
      ADACKEN   at 0 range 3 ..  3;
      MUXSEL    at 0 range 4 ..  4;
      Reserved1 at 0 range 5 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   ADC0_CFG2_ADDRESS : constant := 16#4003_B00C#;

   ADC0_CFG2 : aliased ADCx_CFG2_Type
      with Address              => System'To_Address (ADC0_CFG2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.4 ADC Data Result Register (ADCx_Rn)

   type ADCx_Rn_Type is record
      D        : Bits_16; -- Data result
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_Rn_Type use record
      D        at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   ADC0_RA_ADDRESS : constant := 16#4003_B010#;

   ADC0_RA : aliased ADCx_Rn_Type
      with Address              => System'To_Address (ADC0_RA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC0_RB_ADDRESS : constant := 16#4003_B014#;

   ADC0_RB : aliased ADCx_Rn_Type
      with Address              => System'To_Address (ADC0_RB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.5 Compare Value Registers (ADCx_CVn)

   type ADCx_CVn_Type is record
      CV       : Bits_16; -- Compare Value.
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CVn_Type use record
      CV       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   ADC0_CV1_ADDRESS : constant := 16#4003_B018#;

   ADC0_CV1 : aliased ADCx_CVn_Type
      with Address              => System'To_Address (ADC0_CV1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADC0_CV2_ADDRESS : constant := 16#4003_B01C#;

   ADC0_CV2 : aliased ADCx_CVn_Type
      with Address              => System'To_Address (ADC0_CV2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.6 Status and Control Register 2 (ADCx_SC2)

   REFSEL_REF   : constant := 2#00#; -- Default voltage reference pin pair, that is, external pins VREFH and VREFL
   REFSEL_ALT   : constant := 2#01#; -- Alternate reference pair, that is, VALTH and VALTL .
   REFSEL_RSVD1 : constant := 2#10#; -- Reserved
   REFSEL_RSVD2 : constant := 2#11#; -- Reserved

   ADTRG_SOFT : constant := 0; -- Software trigger selected.
   ADTRG_HARD : constant := 1; -- Hardware trigger selected.

   type ADCx_SC2_Type is record
      REFSEL   : Bits_2  := REFSEL_REF; -- Voltage Reference Selection
      DMAEN    : Boolean := False;      -- DMA Enable
      ACREN    : Boolean := False;      -- Compare Function Range Enable
      ACFGT    : Boolean := False;      -- Compare Function Greater Than Enable
      ACFE     : Boolean := False;      -- Compare Function Enable
      ADTRG    : Bits_1  := ADTRG_SOFT; -- Conversion Trigger Select
      ADACT    : Boolean := False;      -- Conversion Active
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_SC2_Type use record
      REFSEL   at 0 range 0 ..  1;
      DMAEN    at 0 range 2 ..  2;
      ACREN    at 0 range 3 ..  3;
      ACFGT    at 0 range 4 ..  4;
      ACFE     at 0 range 5 ..  5;
      ADTRG    at 0 range 6 ..  6;
      ADACT    at 0 range 7 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   ADC0_SC2_ADDRESS : constant := 16#4003_B020#;

   ADC0_SC2 : aliased ADCx_SC2_Type
      with Address              => System'To_Address (ADC0_SC2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.7 Status and Control Register 3 (ADCx_SC3)

   AVGS_4  : constant := 2#00#; -- 4 samples averaged.
   AVGS_8  : constant := 2#01#; -- 8 samples averaged.
   AVGS_16 : constant := 2#10#; -- 16 samples averaged.
   AVGS_32 : constant := 2#11#; -- 32 samples averaged.

   type ADCx_SC3_Type is record
      AVGS      : Bits_2  := AVGS_4; -- Hardware Average Select
      AVGE      : Boolean := False;  -- Hardware Average Enable
      ADCO      : Boolean := False;  -- Continuous Conversion Enable
      Reserved1 : Bits_2  := 0;
      CALF      : Boolean := False;  -- Calibration Failed Flag
      CAL       : Boolean := False;  -- Calibration
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_SC3_Type use record
      AVGS      at 0 range 0 ..  1;
      AVGE      at 0 range 2 ..  2;
      ADCO      at 0 range 3 ..  3;
      Reserved1 at 0 range 4 ..  5;
      CALF      at 0 range 6 ..  6;
      CAL       at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   ADC0_SC3_ADDRESS : constant := 16#4003_B024#;

   ADC0_SC3 : aliased ADCx_SC3_Type
      with Address              => System'To_Address (ADC0_SC3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.8 ADC Offset Correction Register (ADCx_OFS)

   type ADCx_OFS_Type is record
      OFS      : Integer_16 := 4; -- Offset Error Correction Value
      Reserved : Bits_16    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_OFS_Type use record
      OFS      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   ADC0_OFS_ADDRESS : constant := 16#4003_B028#;

   ADC0_OFS : aliased ADCx_OFS_Type
      with Address              => System'To_Address (ADC0_OFS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.9 ADC Plus-Side Gain Register (ADCx_PG)

   type ADCx_PG_Type is record
      PG       : Bits_16 := 16#8200#; -- Plus-Side Gain
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_PG_Type use record
      PG       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   ADC0_PG_ADDRESS : constant := 16#4003_B02C#;

   ADC0_PG : aliased ADCx_PG_Type
      with Address              => System'To_Address (ADC0_PG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.10 ADC Minus-Side Gain Register (ADCx_MG)

   type ADCx_MG_Type is record
      MG       : Bits_16 := 16#8200#; -- Minus-Side Gain
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_MG_Type use record
      MG       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   ADC0_MG_ADDRESS : constant := 16#4003_B030#;

   ADC0_MG : aliased ADCx_MG_Type
      with Address              => System'To_Address (ADC0_MG_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.11 ADC Plus-Side General Calibration Value Register (ADCx_CLPD)

   type ADCx_CLPD_Type is record
      CLPD     : Bits_6  := 16#0A#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLPD_Type use record
      CLPD     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLPD_ADDRESS : constant := 16#4003_B034#;

   ADC0_CLPD : aliased ADCx_CLPD_Type
      with Address              => System'To_Address (ADC0_CLPD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.12 ADC Plus-Side General Calibration Value Register (ADCx_CLPS)

   type ADCx_CLPS_Type is record
      CLPS     : Bits_6  := 16#20#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLPS_Type use record
      CLPS     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLPS_ADDRESS : constant := 16#4003_B038#;

   ADC0_CLPS : aliased ADCx_CLPS_Type
      with Address              => System'To_Address (ADC0_CLPS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.13 ADC Plus-Side General Calibration Value Register (ADCx_CLP4)

   type ADCx_CLP4_Type is record
      CLP4     : Bits_9  := 16#100#; -- Calibration Value
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLP4_Type use record
      CLP4     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   ADC0_CLP4_ADDRESS : constant := 16#4003_B03C#;

   ADC0_CLP4 : aliased ADCx_CLP4_Type
      with Address              => System'To_Address (ADC0_CLP4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.14 ADC Plus-Side General Calibration Value Register (ADCx_CLP3)

   type ADCx_CLP3_Type is record
      CLP3     : Bits_9  := 16#100#; -- Calibration Value
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLP3_Type use record
      CLP3     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   ADC0_CLP3_ADDRESS : constant := 16#4003_B040#;

   ADC0_CLP3 : aliased ADCx_CLP3_Type
      with Address              => System'To_Address (ADC0_CLP3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.15 ADC Plus-Side General Calibration Value Register (ADCx_CLP2)

   type ADCx_CLP2_Type is record
      CLP2     : Bits_8  := 16#80#; -- Calibration Value
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLP2_Type use record
      CLP2     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   ADC0_CLP2_ADDRESS : constant := 16#4003_B044#;

   ADC0_CLP2 : aliased ADCx_CLP2_Type
      with Address              => System'To_Address (ADC0_CLP2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.16 ADC Plus-Side General Calibration Value Register (ADCx_CLP1)

   type ADCx_CLP1_Type is record
      CLP1     : Bits_7  := 16#40#; -- Calibration Value
      Reserved : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLP1_Type use record
      CLP1     at 0 range 0 ..  6;
      Reserved at 0 range 7 .. 31;
   end record;

   ADC0_CLP1_ADDRESS : constant := 16#4003_B048#;

   ADC0_CLP1 : aliased ADCx_CLP1_Type
      with Address              => System'To_Address (ADC0_CLP1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.17 ADC Plus-Side General Calibration Value Register (ADCx_CLP0)

   type ADCx_CLP0_Type is record
      CLP0     : Bits_6  := 16#20#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLP0_Type use record
      CLP0     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLP0_ADDRESS : constant := 16#4003_B04C#;

   ADC0_CLP0 : aliased ADCx_CLP0_Type
      with Address              => System'To_Address (ADC0_CLP0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.18 ADC Minus-Side General Calibration Value Register (ADCx_CLMD)

   type ADCx_CLMD_Type is record
      CLMD     : Bits_6  := 16#0A#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLMD_Type use record
      CLMD     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLMD_ADDRESS : constant := 16#4003_B054#;

   ADC0_CLMD : aliased ADCx_CLMD_Type
      with Address              => System'To_Address (ADC0_CLMD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.19 ADC Minus-Side General Calibration Value Register (ADCx_CLMS)

   type ADCx_CLMS_Type is record
      CLMS     : Bits_6  := 16#20#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLMS_Type use record
      CLMS     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLMS_ADDRESS : constant := 16#4003_B058#;

   ADC0_CLMS : aliased ADCx_CLMS_Type
      with Address              => System'To_Address (ADC0_CLMS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.20 ADC Minus-Side General Calibration Value Register (ADCx_CLM4)

   type ADCx_CLM4_Type is record
      CLM4     : Bits_10 := 16#200#; -- Calibration Value
      Reserved : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLM4_Type use record
      CLM4     at 0 range  0 ..  9;
      Reserved at 0 range 10 .. 31;
   end record;

   ADC0_CLM4_ADDRESS : constant := 16#4003_B05C#;

   ADC0_CLM4 : aliased ADCx_CLM4_Type
      with Address              => System'To_Address (ADC0_CLM4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.21 ADC Minus-Side General Calibration Value Register (ADCx_CLM3)

   type ADCx_CLM3_Type is record
      CLM3     : Bits_9  := 16#100#; -- Calibration Value
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLM3_Type use record
      CLM3     at 0 range 0 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   ADC0_CLM3_ADDRESS : constant := 16#4003_B060#;

   ADC0_CLM3 : aliased ADCx_CLM3_Type
      with Address              => System'To_Address (ADC0_CLM3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.22 ADC Minus-Side General Calibration Value Register (ADCx_CLM2)

   type ADCx_CLM2_Type is record
      CLM2     : Bits_8  := 16#80#; -- Calibration Value
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLM2_Type use record
      CLM2     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   ADC0_CLM2_ADDRESS : constant := 16#4003_B064#;

   ADC0_CLM2 : aliased ADCx_CLM2_Type
      with Address              => System'To_Address (ADC0_CLM2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.23 ADC Minus-Side General Calibration Value Register (ADCx_CLM1)

   type ADCx_CLM1_Type is record
      CLM1     : Bits_7  := 16#40#; -- Calibration Value
      Reserved : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLM1_Type use record
      CLM1     at 0 range 0 ..  6;
      Reserved at 0 range 7 .. 31;
   end record;

   ADC0_CLM1_ADDRESS : constant := 16#4003_B068#;

   ADC0_CLM1 : aliased ADCx_CLM1_Type
      with Address              => System'To_Address (ADC0_CLM1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 28.3.24 ADC Minus-Side General Calibration Value Register (ADCx_CLM0)

   type ADCx_CLM0_Type is record
      CLM0     : Bits_6  := 16#20#; -- Calibration Value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ADCx_CLM0_Type use record
      CLM0     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   ADC0_CLM0_ADDRESS : constant := 16#4003_B06C#;

   ADC0_CLM0 : aliased ADCx_CLM0_Type
      with Address              => System'To_Address (ADC0_CLM0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 29 Comparator (CMP)
   ----------------------------------------------------------------------------

   -- 29.7.1 CMP Control Register 0 (CMPx_CR0)
   -- 29.7.2 CMP Control Register 1 (CMPx_CR1)
   -- 29.7.3 CMP Filter Period Register (CMPx_FPR)
   -- 29.7.4 CMP Status and Control Register (CMPx_SCR)
   -- 29.7.5 DAC Control Register (CMPx_DACCR)
   -- 29.7.6 MUX Control Register (CMPx_MUXCR)

   ----------------------------------------------------------------------------
   -- Chapter 30 12-bit Digital-to-Analog Converter (DAC)
   ----------------------------------------------------------------------------

   -- 30.4.1 DAC Data Low Register (DACx_DATnL)

   type DACx_DATnL_Type is record
      DATA0 : Unsigned_8; -- When the DAC buffer is not enabled, DATA[11:0] controls the output voltage based on the following formula: V out = V in * (1 + DACDAT0[11:0])/4096 When the DAC buffer is enabled, DATA is mapped to the 16-word buffer.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_DATnL_Type use record
      DATA0 at 0 range 0 .. 7;
   end record;

   -- 30.4.2 DAC Data High Register (DACx_DATnH)

   type DACx_DATnH_Type is record
      DATA1    : Bits_4;      -- When the DAC Buffer is not enabled, DATA[11:0] controls the output voltage based on the following formula. V out = V in * (1 + DACDAT0[11:0])/4096 When the DAC buffer is enabled, DATA[11:0] is mapped to the 16-word buffer.
      Reserved : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_DATnH_Type use record
      DATA1    at 0 range 0 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   -- 30.4.3 DAC Status Register (DACx_SR)

   type DACx_SR_Type is record
      DACBFRPBF : Boolean := True; -- DAC Buffer Read Pointer Bottom Position Flag
      DACBFRPTF : Boolean := True; -- DAC Buffer Read Pointer Top Position Flag
      Reserved  : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_SR_Type use record
      DACBFRPBF at 0 range 0 .. 0;
      DACBFRPTF at 0 range 1 .. 1;
      Reserved  at 0 range 2 .. 7;
   end record;

   -- 30.4.4 DAC Control Register (DACx_C0)

   DACTRGSEL_HW : constant := 0; -- The DAC hardware trigger is selected.
   DACTRGSEL_SW : constant := 1; -- The DAC software trigger is selected.

   DACRFS_DACREF_1 : constant := 0; -- The DAC selects DACREF_1 as the reference voltage.
   DACRFS_DACREF_2 : constant := 1; -- The DAC selects DACREF_2 as the reference voltage.

   type DACx_C0_Type is record
      DACBBIEN  : Boolean := False;           -- DAC Buffer Read Pointer Bottom Flag Interrupt Enable
      DACBTIEN  : Boolean := False;           -- DAC Buffer Read Pointer Top Flag Interrupt Enable
      Reserved  : Bits_1  := 0;
      LPEN      : Boolean := False;           -- DAC Low Power Control
      DACSWTRG  : Boolean := False;           -- DAC Software Trigger
      DACTRGSEL : Bits_1  := DACTRGSEL_HW;    -- DAC Trigger Select
      DACRFS    : Bits_1  := DACRFS_DACREF_1; -- DAC Reference Select
      DACEN     : Boolean := False;           -- DAC Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_C0_Type use record
      DACBBIEN  at 0 range 0 .. 0;
      DACBTIEN  at 0 range 1 .. 1;
      Reserved  at 0 range 2 .. 2;
      LPEN      at 0 range 3 .. 3;
      DACSWTRG  at 0 range 4 .. 4;
      DACTRGSEL at 0 range 5 .. 5;
      DACRFS    at 0 range 6 .. 6;
      DACEN     at 0 range 7 .. 7;
   end record;

   -- 30.4.5 DAC Control Register 1 (DACx_C1)

   DACBFMD_NORMAL : constant := 0; -- Normal mode
   DACBFMD_OTSCAN : constant := 1; -- One-Time Scan mode

   type DACx_C1_Type is record
      DACBFEN   : Boolean := False;          -- DAC Buffer Enable
      Reserved1 : Bits_1  := 0;
      DACBFMD   : Bits_1  := DACBFMD_NORMAL; -- DAC Buffer Work Mode Select
      Reserved2 : Bits_4  := 0;
      DMAEN     : Boolean := False;          -- DMA Enable Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_C1_Type use record
      DACBFEN   at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      DACBFMD   at 0 range 2 .. 2;
      Reserved2 at 0 range 3 .. 6;
      DMAEN     at 0 range 7 .. 7;
   end record;

   -- 30.4.6 DAC Control Register 2 (DACx_C2)

   type DACx_C2_Type is record
      DACBFUP   : Boolean := True;  -- DAC Buffer Upper Limit
      Reserved1 : Bits_3  := 0;
      DACBFRP   : Boolean := False; -- DAC Buffer Read Pointer
      Reserved2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DACx_C2_Type use record
      DACBFUP   at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      DACBFRP   at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
   end record;

   -- 30.4 Memory map/register definition

   DAC0_DAT0L_ADDRESS : constant := 16#4003_F000#;

   DAC0_DAT0L : aliased DACx_DATnL_Type
      with Address              => System'To_Address (DAC0_DAT0L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_DAT0H_ADDRESS : constant := 16#4003_F001#;

   DAC0_DAT0H : aliased DACx_DATnH_Type
      with Address              => System'To_Address (DAC0_DAT0H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_DAT1L_ADDRESS : constant := 16#4003_F002#;

   DAC0_DAT1L : aliased DACx_DATnL_Type
      with Address              => System'To_Address (DAC0_DAT1L_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_DAT1H_ADDRESS : constant := 16#4003_F003#;

   DAC0_DAT1H : aliased DACx_DATnH_Type
      with Address              => System'To_Address (DAC0_DAT1H_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_SR_ADDRESS : constant := 16#4003_F020#;

   DAC0_SR : aliased DACx_SR_Type
      with Address              => System'To_Address (DAC0_SR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_C0_ADDRESS : constant := 16#4003_F021#;

   DAC0_C0 : aliased DACx_C0_Type
      with Address              => System'To_Address (DAC0_C0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_C1_ADDRESS : constant := 16#4003_F022#;

   DAC0_C1 : aliased DACx_C1_Type
      with Address              => System'To_Address (DAC0_C1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   DAC0_C2_ADDRESS : constant := 16#4003_F023#;

   DAC0_C2 : aliased DACx_C2_Type
      with Address              => System'To_Address (DAC0_C2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 31 Timer/PWM Module (TPM)
   ----------------------------------------------------------------------------

   -- 31.3.1 Status and Control (TPMx_SC)

   PS_DIV1   : constant := 2#000#; -- Divide by 1
   PS_DIV2   : constant := 2#001#; -- Divide by 2
   PS_DIV4   : constant := 2#010#; -- Divide by 4
   PS_DIV8   : constant := 2#011#; -- Divide by 8
   PS_DIV16  : constant := 2#100#; -- Divide by 16
   PS_DIV32  : constant := 2#101#; -- Divide by 32
   PS_DIV64  : constant := 2#110#; -- Divide by 64
   PS_DIV128 : constant := 2#111#; -- Divide by 128

   CMOD_NONE : constant := 2#00#; -- TPM counter is disabled
   CMOD_INCR : constant := 2#01#; -- TPM counter increments on every TPM counter clock
   CMOD_DECR : constant := 2#10#; -- TPM counter increments on rising edge of TPM_EXTCLK synchronized to the TPM counter clock
   CMOD_RSVD : constant := 2#11#; -- Reserved

   CPWMS_UP     : constant := 0; -- TPM counter operates in up counting mode.
   CPWMS_UPDOWN : constant := 1; -- TPM counter operates in up-down counting mode.

   type TPMx_SC_Type is record
      PS       : Bits_3  := PS_DIV1;   -- Prescale Factor Selection
      CMOD     : Bits_2  := CMOD_NONE; -- Clock Mode Selection
      CPWMS    : Bits_1  := CPWMS_UP;  -- Center-aligned PWM Select
      TOIE     : Boolean := False;     -- Timer Overflow Interrupt Enable
      TOF      : Boolean := False;     -- Timer Overflow Flag
      DMA      : Boolean := False;     -- DMA Enable
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_SC_Type use record
      PS       at 0 range 0 ..  2;
      CMOD     at 0 range 3 ..  4;
      CPWMS    at 0 range 5 ..  5;
      TOIE     at 0 range 6 ..  6;
      TOF      at 0 range 7 ..  7;
      DMA      at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- 31.3.2 Counter (TPMx_CNT)

   type TPMx_CNT_Type is record
      COUNT    : Unsigned_16 := 0; -- Counter Value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_CNT_Type use record
      COUNT    at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 31.3.3 Modulo (TPMx_MOD)

   type TPMx_MOD_Type is record
      MODulo   : Unsigned_16 := 16#FFFF#; -- Modulo Value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_MOD_Type use record
      MODulo   at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 31.3.4 Channel (n) Status and Control (TPMx_CnSC)

   -- TPMx_SC.CPWMS = x
   --   MSnB:MSnA = 00 (MSAB_NONE)
   ELSAB_NONE           : constant := 2#00#; -- Channel disabled
   --   MSnB:MSnA = 01 (MSAB_SWCMP)
   ELSAB_SWCMP          : constant := 2#00#; -- Pin not used for TPM
   -- TPMx_SC.CPWMS = 0 (CPWMS_UP)
   --   MSnB:MSnA = 00 (MSAB_INPCAP)
   ELSAB_INPCAP_RISEDG  : constant := 2#01#; -- Capture on Rising Edge Only
   ELSAB_INPCAP_FALLEDG : constant := 2#10#; -- Capture on Falling Edge Only
   ELSAB_INPCAP_BOTHEDG : constant := 2#11#; -- Capture on Rising or Falling Edge
   --   MSnB:MSnA = 01 (MSAB_OUTCMP_TCS)
   ELSAB_OUTCMP_OUTTOGL : constant := 2#01#; -- Toggle Output on match
   ELSAB_OUTCMP_OUTCLR  : constant := 2#10#; -- Clear Output on match
   ELSAB_OUTCMP_OUTSET  : constant := 2#11#; -- Set Output on match
   --   MSnB:MSnA = 10 (MSAB_EAPWM)
   ELSAB_EAPWM_HIGH     : constant := 2#10#; -- High-true pulses (clear Output on match, set Output on reload)
   ELSAB_EAPWM_LOW      : constant := 2#01#; -- Low-true pulses (set Output on match, clear Output on reload)
   ELSAB_EAPWM_LOW_2    : constant := 2#11#; -- ''
   --   MSnB:MSnA = 11 (MSAB_OUTCMP_PULSE)
   ELSAB_OUTCMP_PULSELO : constant := 2#10#; -- Pulse Output low on match
   ELSAB_OUTCMP_PULSEHI : constant := 2#01#; -- Pulse Output high on match
   -- TPMx_SC.CPWMS = 1 (CPWMS_UPDOWN)
   --   MSnB:MSnA = 10 (MSAB_CAPWM)
   ELSAB_CAPWM_PULSEHI  : constant := 2#10#; -- High-true pulses (clear Output on match-up, set Output on match-down)
   ELSAB_CAPWM_PULSELO  : constant := 2#01#; -- Low-true pulses (set Output on match-up, clear Output on match-down)

   -- ELSnB:ELSnA = 00 (ELSAB_NONE,ELSAB_SWCMP)
   MSAB_NONE         : constant := 2#00#; -- Channel disabled
   MSAB_SWCMP        : constant := 2#01#; -- Software compare
   -- ELSnB:ELSnA = 01,10,11 TPMx_SC.CPWMS = 0 (CPWMS_UP)
   MSAB_INPCAP       : constant := 2#00#; -- Input capture
   MSAB_OUTCMP_TCS   : constant := 2#01#; -- Output compare
   MSAB_EAPWM        : constant := 2#10#; -- Edge-aligned PWM
   MSAB_OUTCMP_PULSE : constant := 2#11#; -- Output compare
   -- ELSnB:ELSnA = 10,01 TPMx_SC.CPWMS = 1 (CPWMS_UPDOWN)
   MSAB_CAPWM        : constant := 2#10#; -- Center-aligned PWM

   type TPMx_CnSC_Type is record
      DMA       : Boolean := False;      -- DMA Enable
      Reserved1 : Bits_1  := 0;
      ELSAB     : Bits_2  := ELSAB_NONE; -- Edge or Level Select
      MSAB      : Bits_2  := MSAB_NONE;  -- Channel Mode Select
      CHIE      : Boolean := False;      -- Channel Interrupt Enable
      CHF       : Boolean := False;      -- Channel Flag
      Reserved2 : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_CnSC_Type use record
      DMA       at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      ELSAB     at 0 range 2 ..  3;
      MSAB      at 0 range 4 ..  5;
      CHIE      at 0 range 6 ..  6;
      CHF       at 0 range 7 ..  7;
      Reserved2 at 0 range 8 .. 31;
   end record;

   -- 31.3.5 Channel (n) Value (TPMx_CnV)

   type TPMx_CnV_Type is record
      VAL      : Unsigned_16 := 0; -- Channel Value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_CnV_Type use record
      VAL      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 31.3.6 Capture and Compare Status (TPMx_STATUS)

   type TPMx_STATUS_Type is record
      CH0F      : Boolean := False; -- Channel 0 Flag
      CH1F      : Boolean := False; -- Channel 1 Flag
      CH2F      : Boolean := False; -- Channel 2 Flag
      CH3F      : Boolean := False; -- Channel 3 Flag
      CH4F      : Boolean := False; -- Channel 4 Flag
      CH5F      : Boolean := False; -- Channel 5 Flag
      Reserved1 : Bits_2  := 0;
      TOF       : Boolean := False; -- Timer Overflow Flag
      Reserved2 : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_STATUS_Type use record
      CH0F      at 0 range 0 ..  0;
      CH1F      at 0 range 1 ..  1;
      CH2F      at 0 range 2 ..  2;
      CH3F      at 0 range 3 ..  3;
      CH4F      at 0 range 4 ..  4;
      CH5F      at 0 range 5 ..  5;
      Reserved1 at 0 range 6 ..  7;
      TOF       at 0 range 8 ..  8;
      Reserved2 at 0 range 9 .. 31;
   end record;

   -- 31.3.7 Configuration (TPMx_CONF)

   DBGMODE_PAUSED   : constant := 2#00#; -- TPM counter is paused and does not increment during debug mode. Trigger inputs and input capture events are also ignored.
   DBGMODE_CONTINUE : constant := 2#11#; -- TPM counter continues in debug mode.

   -- Table 3-38. TPM trigger options
   TRGSEL_EXTRG_IN  : constant := 2#0000#; -- External trigger pin input (EXTRG_IN)
   TRGSEL_CMP0_OUT  : constant := 2#0001#; -- CMP0 output
   TRGSEL_RSVD1     : constant := 2#0010#; -- Reserved
   TRGSEL_RSVD2     : constant := 2#0011#; -- Reserved
   TRGSEL_PIT_TRG0  : constant := 2#0100#; -- PIT trigger 0
   TRGSEL_PIT_TRG1  : constant := 2#0101#; -- PIT trigger 1
   TRGSEL_RSVD3     : constant := 2#0110#; -- Reserved
   TRGSEL_RSVD4     : constant := 2#0111#; -- Reserved
   TRGSEL_TPM0_OVF  : constant := 2#1000#; -- TPM0 overflow
   TRGSEL_TPM1_OVF  : constant := 2#1001#; -- TPM1 overflow
   TRGSEL_TPM2_OVF  : constant := 2#1010#; -- TPM2 overflow
   TRGSEL_RSVD5     : constant := 2#1011#; -- Reserved
   TRGSEL_RTC_ALARM : constant := 2#1100#; -- RTC alarm
   TRGSEL_RTC_SECS  : constant := 2#1101#; -- RTC seconds
   TRGSEL_LPTMR_TRG : constant := 2#1110#; -- LPTMR trigger
   TRGSEL_RSVD6     : constant := 2#1111#; -- Reserved

   type TPMx_CONF_Type is record
      Reserved1 : Bits_5  := 0;
      DOZEEN    : Boolean := False;           -- Doze Enable
      DBGMODE   : Bits_2  := DBGMODE_PAUSED;  -- Debug Mode
      Reserved2 : Bits_1  := 0;
      GTBEEN    : Boolean := False;           -- Global time base enable
      Reserved3 : Bits_6  := 0;
      CSOT      : Boolean := False;           -- Counter Start on Trigger
      CSOO      : Boolean := False;           -- Counter Stop On Overflow
      CROT      : Boolean := False;           -- Counter Reload On Trigger
      Reserved4 : Bits_5  := 0;
      TRGSEL    : Bits_4  := TRGSEL_EXTRG_IN; -- Trigger Select
      Reserved5 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPMx_CONF_Type use record
      Reserved1 at 0 range  0 ..  4;
      DOZEEN    at 0 range  5 ..  5;
      DBGMODE   at 0 range  6 ..  7;
      Reserved2 at 0 range  8 ..  8;
      GTBEEN    at 0 range  9 ..  9;
      Reserved3 at 0 range 10 .. 15;
      CSOT      at 0 range 16 .. 16;
      CSOO      at 0 range 17 .. 17;
      CROT      at 0 range 18 .. 18;
      Reserved4 at 0 range 19 .. 23;
      TRGSEL    at 0 range 24 .. 27;
      Reserved5 at 0 range 28 .. 31;
   end record;

   -- 31.3 Memory Map and Register Definition

   type TPM_Type is record
      SC     : TPMx_SC_Type     with Volatile_Full_Access => True;
      CNT    : TPMx_CNT_Type    with Volatile_Full_Access => True;
      MODulo : TPMx_MOD_Type    with Volatile_Full_Access => True;
      C0SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C0V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      C1SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C1V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      C2SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C2V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      C3SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C3V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      C4SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C4V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      C5SC   : TPMx_CnSC_Type   with Volatile_Full_Access => True;
      C5V    : TPMx_CnV_Type    with Volatile_Full_Access => True;
      STATUS : TPMx_STATUS_Type with Volatile_Full_Access => True;
      CONF   : TPMx_CONF_Type   with Volatile_Full_Access => True;
   end record
      with Size => 16#88# * 8;
   for TPM_Type use record
      SC     at 16#00# range 0 .. 31;
      CNT    at 16#04# range 0 .. 31;
      MODulo at 16#08# range 0 .. 31;
      C0SC   at 16#0C# range 0 .. 31;
      C0V    at 16#10# range 0 .. 31;
      C1SC   at 16#14# range 0 .. 31;
      C1V    at 16#18# range 0 .. 31;
      C2SC   at 16#1C# range 0 .. 31;
      C2V    at 16#20# range 0 .. 31;
      C3SC   at 16#24# range 0 .. 31;
      C3V    at 16#28# range 0 .. 31;
      C4SC   at 16#2C# range 0 .. 31;
      C4V    at 16#30# range 0 .. 31;
      C5SC   at 16#34# range 0 .. 31;
      C5V    at 16#38# range 0 .. 31;
      STATUS at 16#50# range 0 .. 31;
      CONF   at 16#84# range 0 .. 31;
   end record;

   TPM0 : aliased TPM_Type
      with Address    => System'To_Address (16#4003_8000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   TPM1 : aliased TPM_Type
      with Address    => System'To_Address (16#4003_9000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   TPM2 : aliased TPM_Type
      with Address    => System'To_Address (16#4003_A000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

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
   -- Chapter 33 Low-Power Timer (LPTMR)
   ----------------------------------------------------------------------------

   -- 33.3.1 Low Power Timer Control Status Register (LPTMRx_CSR)

   TMS_TIME  : constant := 0; -- Time Counter mode.
   TMS_PULSE : constant := 1; -- Pulse Counter mode.

   TFC_TCFSET   : constant := 0; -- CNR is reset whenever TCF is set.
   TFC_OVERFLOW : constant := 1; -- CNR is reset on overflow.

   TPP_HIGH : constant := 0; -- Pulse Counter input source is active-high, and the CNR will increment on the rising-edge.
   TPP_LOW  : constant := 1; -- Pulse Counter input source is active-low, and the CNR will increment on the falling-edge.

   TPS_0 : constant := 2#00#; -- Pulse counter input 0 is selected.
   TPS_1 : constant := 2#01#; -- Pulse counter input 1 is selected.
   TPS_2 : constant := 2#10#; -- Pulse counter input 2 is selected.
   TPS_3 : constant := 2#11#; -- Pulse counter input 3 is selected.

   type LPTMRx_CSR_Type is record
      TEN      : Boolean := False;      -- Timer Enable
      TMS      : Bits_1  := TMS_TIME;   -- Timer Mode Select
      TFC      : Bits_1  := TFC_TCFSET; -- Timer Free-Running Counter
      TPP      : Bits_1  := TPP_HIGH;   -- Timer Pin Polarity
      TPS      : Bits_2  := TPS_0;      -- Timer Pin Select
      TIE      : Boolean := False;      -- Timer Interrupt Enable
      TCF      : Boolean := False;      -- Timer Compare Flag
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LPTMRx_CSR_Type use record
      TEN      at 0 range 0 ..  0;
      TMS      at 0 range 1 ..  1;
      TFC      at 0 range 2 ..  2;
      TPP      at 0 range 3 ..  3;
      TPS      at 0 range 4 ..  5;
      TIE      at 0 range 6 ..  6;
      TCF      at 0 range 7 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   LPTMR0_CSR_ADDRESS : constant := 16#4004_0000#;

   LPTMR0_CSR : aliased LPTMRx_CSR_Type
      with Address              => System'To_Address (LPTMR0_CSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 33.3.2 Low Power Timer Prescale Register (LPTMRx_PSR)

   PCS_0 : constant := 2#00#; -- Prescaler/glitch filter clock 0 selected.
   PCS_1 : constant := 2#01#; -- Prescaler/glitch filter clock 1 selected.
   PCS_2 : constant := 2#10#; -- Prescaler/glitch filter clock 2 selected.
   PCS_3 : constant := 2#11#; -- Prescaler/glitch filter clock 3 selected.

   PRESCALE_DIV2   : constant := 2#0000#; -- Prescaler divides the prescaler clock by 2; glitch filter does not support this configuration.
   PRESCALE_DIV4   : constant := 2#0001#; -- Prescaler divides the prescaler clock by 4; glitch filter recognizes change on input pin after 2 rising clock edges.
   PRESCALE_DIV8   : constant := 2#0010#; -- Prescaler divides the prescaler clock by 8; glitch filter recognizes change on input pin after 4 rising clock edges.
   PRESCALE_DIV16  : constant := 2#0011#; -- Prescaler divides the prescaler clock by 16; glitch filter recognizes change on input pin after 8 rising clock edges.
   PRESCALE_DIV32  : constant := 2#0100#; -- Prescaler divides the prescaler clock by 32; glitch filter recognizes change on input pin after 16 rising clock edges.
   PRESCALE_DIV64  : constant := 2#0101#; -- Prescaler divides the prescaler clock by 64; glitch filter recognizes change on input pin after 32 rising clock edges.
   PRESCALE_DIV128 : constant := 2#0110#; -- Prescaler divides the prescaler clock by 128; glitch filter recognizes change on input pin after 64 rising clock edges.
   PRESCALE_DIV256 : constant := 2#0111#; -- Prescaler divides the prescaler clock by 256; glitch filter recognizes change on input pin after 128 rising clock edges.
   PRESCALE_DIV512 : constant := 2#1000#; -- Prescaler divides the prescaler clock by 512; glitch filter recognizes change on input pin after 256 rising clock edges.
   PRESCALE_DIV1k  : constant := 2#1001#; -- Prescaler divides the prescaler clock by 1024; glitch filter recognizes change on input pin after 512 rising clock edges.
   PRESCALE_DIV2k  : constant := 2#1010#; -- Prescaler divides the prescaler clock by 2048; glitch filter recognizes change on input pin after 1024 rising clock edges.
   PRESCALE_DIV4k  : constant := 2#1011#; -- Prescaler divides the prescaler clock by 4096; glitch filter recognizes change on input pin after 2048 rising clock edges.
   PRESCALE_DIV8k  : constant := 2#1100#; -- Prescaler divides the prescaler clock by 8192; glitch filter recognizes change on input pin after 4096 rising clock edges.
   PRESCALE_DIV16k : constant := 2#1101#; -- Prescaler divides the prescaler clock by 16,384; glitch filter recognizes change on input pin after 8192 rising clock edges.
   PRESCALE_DIV32k : constant := 2#1110#; -- Prescaler divides the prescaler clock by 32,768; glitch filter recognizes change on input pin after 16,384 rising clock edges.
   PRESCALE_DIV64k : constant := 2#1111#; -- Prescaler divides the prescaler clock by 65,536; glitch filter recognizes change on input pin after 32,768 rising clock edges.

   type LPTMRx_PSR_Type is record
      PCS      : Bits_2  := PCS_0;         -- Prescaler Clock Select
      PBYP     : Boolean := False;         -- Prescaler Bypass
      PRESCALE : Bits_4  := PRESCALE_DIV2; -- Prescale Value
      Reserved : Bits_25 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LPTMRx_PSR_Type use record
      PCS      at 0 range 0 ..  1;
      PBYP     at 0 range 2 ..  2;
      PRESCALE at 0 range 3 ..  6;
      Reserved at 0 range 7 .. 31;
   end record;

   LPTMR0_PSR_ADDRESS : constant := 16#4004_0004#;

   LPTMR0_PSR : aliased LPTMRx_PSR_Type
      with Address              => System'To_Address (LPTMR0_PSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 33.3.3 Low Power Timer Compare Register (LPTMRx_CMR)

   type LPTMRx_CMR_Type is record
      COMPARE  : Unsigned_16 := 0; -- Compare Value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LPTMRx_CMR_Type use record
      COMPARE  at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   LPTMR0_CMR_ADDRESS : constant := 16#4004_0008#;

   LPTMR0_CMR : aliased LPTMRx_CMR_Type
      with Address              => System'To_Address (LPTMR0_CMR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 33.3.4 Low Power Timer Counter Register (LPTMRx_CNR)

   type LPTMRx_CNR_Type is record
      COUNTER  : Unsigned_16; -- Counter Value
      Reserved : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LPTMRx_CNR_Type use record
      COUNTER  at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   LPTMR0_CNR_ADDRESS : constant := 16#4004_000C#;

   LPTMR0_CNR : aliased LPTMRx_CNR_Type
      with Address              => System'To_Address (LPTMR0_CNR_ADDRESS),
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
      TIF       : Boolean := True;  -- Time Invalid Flag
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
      TIIE      : Boolean := True;  -- Time Invalid Interrupt Enable
      TOIE      : Boolean := True;  -- Time Overflow Interrupt Enable
      TAIE      : Boolean := True;  -- Time Alarm Interrupt Enable
      Reserved1 : Bits_1  := 0;
      TSIE      : Boolean := False; -- Time Seconds Interrupt Enable
      Reserved2 : Bits_2  := 0;
      WPON      : Boolean := False; -- Wakeup Pin On
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
   -- Chapter 35 Universal Serial Bus Full Speed OTG Controller (USBOTG)
   ----------------------------------------------------------------------------

   -- 35.4.1 Peripheral ID register (USBx_PERID)
   -- 35.4.2 Peripheral ID Complement register (USBx_IDCOMP)
   -- 35.4.3 Peripheral Revision register (USBx_REV)
   -- 35.4.4 Peripheral Additional Info register (USBx_ADDINFO)
   -- 35.4.5 OTG Interrupt Status register (USBx_OTGISTAT)
   -- 35.4.6 OTG Interrupt Control register (USBx_OTGICR)
   -- 35.4.7 OTG Status register (USBx_OTGSTAT)
   -- 35.4.8 OTG Control register (USBx_OTGCTL)
   -- 35.4.9 Interrupt Status register (USBx_ISTAT)
   -- 35.4.10 Interrupt Enable register (USBx_INTEN)
   -- 35.4.11 Error Interrupt Status register (USBx_ERRSTAT)
   -- 35.4.12 Error Interrupt Enable register (USBx_ERREN)
   -- 35.4.13 Status register (USBx_STAT)
   -- 35.4.14 Control register (USBx_CTL)
   -- 35.4.15 Address register (USBx_ADDR)
   -- 35.4.16 BDT Page register 1 (USBx_BDTPAGE1)
   -- 35.4.17 Frame Number register Low (USBx_FRMNUML)
   -- 35.4.18 Frame Number register High (USBx_FRMNUMH)
   -- 35.4.19 Token register (USBx_TOKEN)
   -- 35.4.20 SOF Threshold register (USBx_SOFTHLD)
   -- 35.4.21 BDT Page Register 2 (USBx_BDTPAGE2)
   -- 35.4.22 BDT Page Register 3 (USBx_BDTPAGE3)
   -- 35.4.23 Endpoint Control register (USBx_ENDPTn)
   -- 35.4.24 USB Control register (USBx_USBCTRL)
   -- 35.4.25 USB OTG Observe register (USBx_OBSERVE)
   -- 35.4.26 USB OTG Control register (USBx_CONTROL)
   -- 35.4.27 USB Transceiver Control register 0 (USBx_USBTRC0)
   -- 35.4.28 Frame Adjust Register (USBx_USBFRMADJUST)

   ----------------------------------------------------------------------------
   -- Chapter 37 Serial Peripheral Interface (SPI)
   ----------------------------------------------------------------------------

   -- 37.3.1 SPI Status Register (SPIx_S)

   type SPIx_S_Type is record
      RFIFOEF : Boolean; -- SPI read FIFO empty flag
      TXFULLF : Boolean; -- Transmit FIFO full flag
      TNEAREF : Boolean; -- Transmit FIFO nearly empty flag
      RNFULLF : Boolean; -- Receive FIFO nearly full flag
      MODF    : Boolean; -- Master Mode Fault Flag
      SPTEF   : Boolean; -- SPI Transmit Buffer Empty Flag (when FIFO is not supported or not enabled) or SPI transmit FIFO empty flag (when FIFO is supported and enabled)
      SPMF    : Boolean; -- SPI Match Flag
      SPRF    : Boolean; -- SPI Read Buffer Full Flag (when FIFO is not supported or not enabled) or SPI read FIFO FULL flag (when FIFO is supported and enabled)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_S_Type use record
      RFIFOEF at 0 range 0 .. 0;
      TXFULLF at 0 range 1 .. 1;
      TNEAREF at 0 range 2 .. 2;
      RNFULLF at 0 range 3 .. 3;
      MODF    at 0 range 4 .. 4;
      SPTEF   at 0 range 5 .. 5;
      SPMF    at 0 range 6 .. 6;
      SPRF    at 0 range 7 .. 7;
   end record;

   -- 37.3.2 SPI Baud Rate Register (SPIx_BR)

   SPR_DIV2   : constant := 2#0000#; -- Baud rate divisor is 2.
   SPR_DIV4   : constant := 2#0001#; -- Baud rate divisor is 4.
   SPR_DIV8   : constant := 2#0010#; -- Baud rate divisor is 8.
   SPR_DIV16  : constant := 2#0011#; -- Baud rate divisor is 16.
   SPR_DIV32  : constant := 2#0100#; -- Baud rate divisor is 32.
   SPR_DIV64  : constant := 2#0101#; -- Baud rate divisor is 64.
   SPR_DIV128 : constant := 2#0110#; -- Baud rate divisor is 128.
   SPR_DIV256 : constant := 2#0111#; -- Baud rate divisor is 256.
   SPR_DIV512 : constant := 2#1000#; -- Baud rate divisor is 512.

   SPPR_DIV1 : constant := 2#000#; -- Baud rate prescaler divisor is 1.
   SPPR_DIV2 : constant := 2#001#; -- Baud rate prescaler divisor is 2.
   SPPR_DIV3 : constant := 2#010#; -- Baud rate prescaler divisor is 3.
   SPPR_DIV4 : constant := 2#011#; -- Baud rate prescaler divisor is 4.
   SPPR_DIV5 : constant := 2#100#; -- Baud rate prescaler divisor is 5.
   SPPR_DIV6 : constant := 2#101#; -- Baud rate prescaler divisor is 6.
   SPPR_DIV7 : constant := 2#110#; -- Baud rate prescaler divisor is 7.
   SPPR_DIV8 : constant := 2#111#; -- Baud rate prescaler divisor is 8.

   type SPIx_BR_Type is record
      SPR      : Bits_4 := SPR_DIV2;  -- SPI Baud Rate Divisor
      SPPR     : Bits_3 := SPPR_DIV1; -- SPI Baud Rate Prescale Divisor
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_BR_Type use record
      SPR      at 0 range 0 .. 3;
      SPPR     at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   -- 37.3.3 SPI Control Register 2 (SPIx_C2)

   SPC0_NORMAL : constant := 0; -- SPI uses separate pins for data input and data output (pin mode is normal).
   SPC0_BIDIR  : constant := 1; -- SPI configured for single-wire bidirectional operation (pin mode is bidirectional).

   SPIMODE_8  : constant := 0; -- 8-bit SPI shift register, match register, and buffers
   SPIMODE_16 : constant := 1; -- 16-bit SPI shift register, match register, and buffers

   type SPIx_C2_Type is record
      SPC0    : Bits_1  := SPC0_NORMAL; -- SPI Pin Control 0
      SPISWAI : Boolean := False;       -- SPI Stop in Wait Mode
      RXDMAE  : Boolean := False;       -- Receive DMA enable
      BIDIROE : Boolean := False;       -- Bidirectional Mode Output Enable
      MODFEN  : Boolean := False;       -- Master Mode-Fault Function Enable
      TXDMAE  : Boolean := False;       -- Transmit DMA enable
      SPIMODE : Bits_1  := SPIMODE_8;   -- SPI 8-bit or 16-bit mode
      SPMIE   : Boolean := False;       -- SPI Match Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_C2_Type use record
      SPC0    at 0 range 0 .. 0;
      SPISWAI at 0 range 1 .. 1;
      RXDMAE  at 0 range 2 .. 2;
      BIDIROE at 0 range 3 .. 3;
      MODFEN  at 0 range 4 .. 4;
      TXDMAE  at 0 range 5 .. 5;
      SPIMODE at 0 range 6 .. 6;
      SPMIE   at 0 range 7 .. 7;
   end record;

   -- 37.3.4 SPI Control Register 1 (SPIx_C1)

   LSBFE_MSB : constant := 0; -- SPI serial data transfers start with the most significant bit.
   LSBFE_LSB : constant := 1; -- SPI serial data transfers start with the least significant bit.

   -- MODFEN=0
   SSOE_MSTGPIOSLSELIN   : constant := 0; -- When C2[MODFEN] is 0: In master mode, SS pin function is general-purpose I/O (not SPI). In slave mode, SS pin function is slave select input.
   SSOE_MSTGPIOSLSELIN_2 : constant := 1; -- When C2[MODFEN] is 0: In master mode, SS pin function is general-purpose I/O (not SPI). In slave mode, SS pin function is slave select input.
   -- MODFEN=1
   SSOE_MSTFAULTSLSELIN  : constant := 0; -- When C2[MODFEN] is 1: In master mode, SS pin function is SS input for mode fault. In slave mode, SS pin function is slave select input.
   SSOE_MSTSSOUTSLSELIN  : constant := 1; -- When C2[MODFEN] is 1: In master mode, SS pin function is automatic SS output. In slave mode: SS pin function is slave select input.

   CPHA_MIDDLE : constant := 0; -- First edge on SPSCK occurs at the middle of the first cycle of a data transfer.
   CPHA_START  : constant := 1; -- First edge on SPSCK occurs at the start of the first cycle of a data transfer.

   CPOL_HIGH : constant := 0; -- Active-high SPI clock (idles low)
   CPOL_LOW  : constant := 1; -- Active-low SPI clock (idles high)

   MSTR_SLAVE  : constant := 0; -- SPI module configured as a slave SPI device
   MSTR_MASTER : constant := 1; -- SPI module configured as a master SPI device

   type SPIx_C1_Type is record
      LSBFE : Bits_1  := LSBFE_MSB;           -- LSB First (shifter direction)
      SSOE  : Bits_1  := SSOE_MSTGPIOSLSELIN; -- Slave Select Output Enable
      CPHA  : Bits_1  := CPHA_START;          -- Clock Phase
      CPOL  : Bits_1  := CPOL_HIGH;           -- Clock Polarity
      MSTR  : Bits_1  := MSTR_SLAVE;          -- Master/Slave Mode Select
      SPTIE : Boolean := False;               -- SPI Transmit Interrupt Enable
      SPE   : Boolean := False;               -- SPI System Enable
      SPIE  : Boolean := False;               -- SPI Interrupt Enable: for SPRF and MODF (when FIFO is not supported or not enabled) or for read FIFO (when FIFO is supported and enabled)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_C1_Type use record
      LSBFE at 0 range 0 .. 0;
      SSOE  at 0 range 1 .. 1;
      CPHA  at 0 range 2 .. 2;
      CPOL  at 0 range 3 .. 3;
      MSTR  at 0 range 4 .. 4;
      SPTIE at 0 range 5 .. 5;
      SPE   at 0 range 6 .. 6;
      SPIE  at 0 range 7 .. 7;
   end record;

   -- 37.3.5 SPI Match Register low (SPIx_ML)

   type SPIx_ML_Type is record
      ML : Unsigned_8; -- Hardware compare value (low byte)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_ML_Type use record
      ML at 0 range 0 .. 7;
   end record;

   -- 37.3.6 SPI match register high (SPIx_MH)

   type SPIx_MH_Type is record
      MH : Unsigned_8; -- Hardware compare value (high byte)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_MH_Type use record
      MH at 0 range 0 .. 7;
   end record;

   -- 37.3.7 SPI Data Register low (SPIx_DL)

   type SPIx_DL_Type is record
      DL : Unsigned_8; -- Data (low byte)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_DL_Type use record
      DL at 0 range 0 .. 7;
   end record;

   -- 37.3.8 SPI data register high (SPIx_DH)

   type SPIx_DH_Type is record
      DH : Unsigned_8; -- Data (high byte)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_DH_Type use record
      DH at 0 range 0 .. 7;
   end record;

   -- 37.3.9 SPI clear interrupt register (SPIx_CI)

   type SPIx_CI_Type is record
      SPRFCI    : Boolean := False; -- Receive FIFO full flag clear interrupt
      SPTEFCI   : Boolean := False; -- Transmit FIFO empty flag clear interrupt
      RNFULLFCI : Boolean := False; -- Receive FIFO nearly full flag clear interrupt
      TNEAREFCI : Boolean := False; -- Transmit FIFO nearly empty flag clear interrupt
      RXFOF     : Boolean := False; -- Receive FIFO overflow flag
      TXFOF     : Boolean := False; -- Transmit FIFO overflow flag
      RXFERR    : Boolean := False; -- Receive FIFO error flag
      TXFERR    : Boolean := False; -- Transmit FIFO error flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_CI_Type use record
      SPRFCI    at 0 range 0 .. 0;
      SPTEFCI   at 0 range 1 .. 1;
      RNFULLFCI at 0 range 2 .. 2;
      TNEAREFCI at 0 range 3 .. 3;
      RXFOF     at 0 range 4 .. 4;
      TXFOF     at 0 range 5 .. 5;
      RXFERR    at 0 range 6 .. 6;
      TXFERR    at 0 range 7 .. 7;
   end record;

   -- 37.3.10 SPI control register 3 (SPIx_C3)

   INTCLR_FIFO : constant := 0; -- These interrupts are cleared when the corresponding flags are cleared depending on the state of the FIFOs
   INTCLR_CI   : constant := 1; -- These interrupts are cleared by writing the corresponding bits in the CI register

   RNFULLF_MARK_48 : constant := 0; -- RNFULLF is set when the receive FIFO has 48 bits or more
   RNFULLF_MARK_32 : constant := 1; -- RNFULLF is set when the receive FIFO has 32 bits or more

   TNEAREF_MARK_16 : constant := 0; -- TNEAREF is set when the transmit FIFO has 16 bits or less
   TNEAREF_MARK_32 : constant := 1; -- TNEAREF is set when the transmit FIFO has 32 bits or less

   type SPIx_C3_Type is record
      FIFOMODE     : Boolean := False;           -- FIFO mode enable
      RNFULLIEN    : Boolean := False;           -- Receive FIFO nearly full interrupt enable
      TNEARIEN     : Boolean := False;           -- Transmit FIFO nearly empty interrupt enable
      INTCLR       : Bits_1  := INTCLR_FIFO;     -- Interrupt clearing mechanism select
      RNFULLF_MARK : Bits_1  := RNFULLF_MARK_48; -- Receive FIFO nearly full watermark
      TNEAREF_MARK : Bits_1  := TNEAREF_MARK_16; -- Transmit FIFO nearly empty watermark
      Reserved     : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SPIx_C3_Type use record
      FIFOMODE     at 0 range 0 .. 0;
      RNFULLIEN    at 0 range 1 .. 1;
      TNEARIEN     at 0 range 2 .. 2;
      INTCLR       at 0 range 3 .. 3;
      RNFULLF_MARK at 0 range 4 .. 4;
      TNEAREF_MARK at 0 range 5 .. 5;
      Reserved     at 0 range 6 .. 7;
   end record;

   -- 37.3 Memory map/register definition

   type SPI_Type is record
      S  : SPIx_S_Type  with Volatile_Full_Access => True;
      BR : SPIx_BR_Type with Volatile_Full_Access => True;
      C2 : SPIx_C2_Type with Volatile_Full_Access => True;
      C1 : SPIx_C1_Type with Volatile_Full_Access => True;
      ML : SPIx_ML_Type with Volatile_Full_Access => True;
      MH : SPIx_MH_Type with Volatile_Full_Access => True;
      DL : SPIx_DL_Type with Volatile_Full_Access => True;
      DH : SPIx_DH_Type with Volatile_Full_Access => True;
      CI : SPIx_CI_Type with Volatile_Full_Access => True;
      C3 : SPIx_C3_Type with Volatile_Full_Access => True;
   end record
      with Size => 16#C# * 8;
   for SPI_Type use record
      S  at 16#0# range 0 .. 7;
      BR at 16#1# range 0 .. 7;
      C2 at 16#2# range 0 .. 7;
      C1 at 16#3# range 0 .. 7;
      ML at 16#4# range 0 .. 7;
      MH at 16#5# range 0 .. 7;
      DL at 16#6# range 0 .. 7;
      DH at 16#7# range 0 .. 7;
      CI at 16#A# range 0 .. 7;
      C3 at 16#B# range 0 .. 7;
   end record;

   SPI0 : aliased SPI_Type
      with Address    => System'To_Address (16#4007_6000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   SPI1 : aliased SPI_Type
      with Address    => System'To_Address (16#4007_7000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 38 Inter-Integrated Circuit (I2C)
   ----------------------------------------------------------------------------

   -- 38.3.1 I2C Address Register 1 (I2Cx_A1)

   type I2Cx_A1_Type is record
      Reserved : Bits_1 := 0;
      AD       : Bits_7 := 0; -- Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_A1_Type use record
      Reserved at 0 range 0 .. 0;
      AD       at 0 range 1 .. 7;
   end record;

   -- 38.3.2 I2C Frequency Divider register (I2Cx_F)

   MULT_1    : constant := 2#00#; -- mul = 1
   MULT_2    : constant := 2#01#; -- mul = 2
   MULT_4    : constant := 2#10#; -- mul = 4
   MULT_RSVD : constant := 2#11#; -- Reserved

   type I2Cx_F_Type is record
      ICR  : Bits_6 := 0;      -- ClockRate
      MULT : Bits_2 := MULT_1; -- The MULT bits define the multiplier factor mul.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_F_Type use record
      ICR  at 0 range 0 .. 5;
      MULT at 0 range 6 .. 7;
   end record;

   -- 38.3.3 I2C Control Register 1 (I2Cx_C1)

   TXAK_ACK : constant := 0; -- An acknowledge signal is sent to the bus on the following receiving byte (if FACK is cleared) or the current receiving byte (if FACK is set).
   TXAK_NAK : constant := 1; -- No acknowledge signal is sent to the bus on the following receiving data byte (if FACK is cleared) or the current receiving data byte (if FACK is set).

   TX_RX : constant := 0; -- Receive
   TX_TX : constant := 1; -- Transmit

   MST_SLAVE  : constant := 0; -- Slave mode
   MST_MASTER : constant := 1; -- Master mode

   type I2Cx_C1_Type is record
      DMAEN : Boolean := False;     -- DMA Enable
      WUEN  : Boolean := False;     -- Wakeup Enable
      RSTA  : Boolean := False;     -- Repeat START
      TXAK  : Bits_1  := TXAK_ACK;  -- Transmit Acknowledge Enable
      TX    : Bits_1  := TX_RX;     -- Transmit Mode Select
      MST   : Bits_1  := MST_SLAVE; -- Master Mode Select
      IICIE : Boolean := False;     -- I2C Interrupt Enable
      IICEN : Boolean := False;     -- I2C Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_C1_Type use record
      DMAEN at 0 range 0 .. 0;
      WUEN  at 0 range 1 .. 1;
      RSTA  at 0 range 2 .. 2;
      TXAK  at 0 range 3 .. 3;
      TX    at 0 range 4 .. 4;
      MST   at 0 range 5 .. 5;
      IICIE at 0 range 6 .. 6;
      IICEN at 0 range 7 .. 7;
   end record;

   -- 38.3.4 I2C Status register (I2Cx_S)

   RXAK_ACK : constant := 0; -- Acknowledge signal was received after the completion of one byte of data transmission on the bus
   RXAK_NAK : constant := 1; -- No acknowledge signal detected

   SRW_MSTWR_SLVRX : constant := 0; -- Slave receive, master writing to slave
   SRW_MSTRD_SLVTX : constant := 1; -- Slave transmit, master reading from slave

   type I2Cx_S_Type is record
      RXAK  : Bits_1  := RXAK_ACK;        -- Receive Acknowledge
      IICIF : Boolean := False;           -- Interrupt Flag
      SRW   : Bits_1  := SRW_MSTWR_SLVRX; -- Slave Read/Write
      RAM   : Boolean := False;           -- Range Address Match
      ARBL  : Boolean := False;           -- Arbitration Lost
      BUSY  : Boolean := False;           -- Bus Busy
      IAAS  : Boolean := False;           -- Addressed As A Slave
      TCF   : Boolean := True;            -- Transfer Complete Flag
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_S_Type use record
      RXAK  at 0 range 0 .. 0;
      IICIF at 0 range 1 .. 1;
      SRW   at 0 range 2 .. 2;
      RAM   at 0 range 3 .. 3;
      ARBL  at 0 range 4 .. 4;
      BUSY  at 0 range 5 .. 5;
      IAAS  at 0 range 6 .. 6;
      TCF   at 0 range 7 .. 7;
   end record;

   -- 38.3.5 I2C Data I/O register (I2Cx_D)

   -- 38.3.6 I2C Control Register 2 (I2Cx_C2)

   SBRC_FOLLOW : constant := 0; -- The slave baud rate follows the master baud rate and clock stretching may occur
   SBRC_NOTDEP : constant := 1; -- Slave baud rate is independent of the master baud rate

   ADEXT_7  : constant := 0; -- 7-bit address scheme
   ADEXT_10 : constant := 1; -- 10-bit address scheme

   type I2Cx_C2_Type is record
      AD    : Bits_3  := 0;           -- Slave Address
      RMEN  : Boolean := False;       -- Range Address Matching Enable
      SBRC  : Bits_1  := SBRC_FOLLOW; -- Slave Baud Rate Control
      HDRS  : Boolean := False;       -- High Drive Select
      ADEXT : Bits_1  := ADEXT_7;     -- Address Extension
      GCAEN : Boolean := False;       -- General Call Address Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_C2_Type use record
      AD    at 0 range 0 .. 2;
      RMEN  at 0 range 3 .. 3;
      SBRC  at 0 range 4 .. 4;
      HDRS  at 0 range 5 .. 5;
      ADEXT at 0 range 6 .. 6;
      GCAEN at 0 range 7 .. 7;
   end record;

   -- 38.3.7 I2C Programmable Input Glitch Filter Register (I2Cx_FLT)

   FLT_BYPASS : constant := 0; -- No filter/bypass

   type I2Cx_FLT_Type is record
      FLT       : Bits_5  := FLT_BYPASS; -- I2C Programmable Filter Factor
      STOPIE    : Boolean := False;      -- I2C Bus Stop Interrupt Enable
      STOPF     : Boolean := False;      -- I2C Bus Stop Detect Flag
      SHEN      : Boolean := False;      -- Stop Hold Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_FLT_Type use record
      FLT       at 0 range 0 .. 4;
      STOPIE    at 0 range 5 .. 5;
      STOPF     at 0 range 6 .. 6;
      SHEN      at 0 range 7 .. 7;
   end record;

   -- 38.3.8 I2C Range Address register (I2Cx_RA)

   type I2Cx_RA_Type is record
      Reserved : Bits_1 := 0;
      RAD      : Bits_7 := 0; -- Range Slave Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_RA_Type use record
      Reserved at 0 range 0 .. 0;
      RAD      at 0 range 1 .. 7;
   end record;

   -- 38.3.9 I2C SMBus Control and Status register (I2Cx_SMB)

   TCKSEL_DIV64 : constant := 0; -- Timeout counter counts at the frequency of the I2C module clock / 64
   TCKSEL_DIV1  : constant := 1; -- Timeout counter counts at the frequency of the I2C module clock

   type I2Cx_SMB_Type is record
      SHTF2IE : Boolean := False;        -- SHTF2 Interrupt Enable
      SHTF2   : Boolean := False;        -- SCL High Timeout Flag 2
      SHTF1   : Boolean := False;        -- SCL High Timeout Flag 1
      SLTF    : Boolean := False;        -- SCL Low Timeout Flag
      TCKSEL  : Bits_1  := TCKSEL_DIV64; -- Timeout Counter Clock Select
      SIICAEN : Boolean := False;        -- Second I2C Address Enable
      ALERTEN : Boolean := False;        -- SMBus Alert Response Address Enable
      FACK    : Boolean := False;        -- Fast NACK/ACK Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_SMB_Type use record
      SHTF2IE at 0 range 0 .. 0;
      SHTF2   at 0 range 1 .. 1;
      SHTF1   at 0 range 2 .. 2;
      SLTF    at 0 range 3 .. 3;
      TCKSEL  at 0 range 4 .. 4;
      SIICAEN at 0 range 5 .. 5;
      ALERTEN at 0 range 6 .. 6;
      FACK    at 0 range 7 .. 7;
   end record;

   -- 38.3.10 I2C Address Register 2 (I2Cx_A2)

   type I2Cx_A2_Type is record
      Reserved : Bits_1 := 0;
      SAD      : Bits_7 := 2#1100001#; -- SMBus Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for I2Cx_A2_Type use record
      Reserved at 0 range 0 .. 0;
      SAD      at 0 range 1 .. 7;
   end record;

   -- 38.3.11 I2C SCL Low Timeout Register High (I2Cx_SLTH)
   -- 38.3.12 I2C SCL Low Timeout Register Low (I2Cx_SLTL)

   -- 38.3 Memory map/register definition

   type I2C_Type is record
      A1   : I2Cx_A1_Type  with Volatile_Full_Access => True;
      F    : I2Cx_F_Type   with Volatile_Full_Access => True;
      C1   : I2Cx_C1_Type  with Volatile_Full_Access => True;
      S    : I2Cx_S_Type   with Volatile_Full_Access => True;
      D    : Unsigned_8    with Volatile_Full_Access => True;
      C2   : I2Cx_C2_Type  with Volatile_Full_Access => True;
      FLT  : I2Cx_FLT_Type with Volatile_Full_Access => True;
      RA   : I2Cx_RA_Type  with Volatile_Full_Access => True;
      SMB  : I2Cx_SMB_Type with Volatile_Full_Access => True;
      A2   : I2Cx_A2_Type  with Volatile_Full_Access => True;
      SLTH : Unsigned_8    with Volatile_Full_Access => True;
      SLTL : Unsigned_8    with Volatile_Full_Access => True;
   end record
      with Size => 16#C# * 8;
   for I2C_Type use record
      A1   at 16#0# range 0 .. 7;
      F    at 16#1# range 0 .. 7;
      C1   at 16#2# range 0 .. 7;
      S    at 16#3# range 0 .. 7;
      D    at 16#4# range 0 .. 7;
      C2   at 16#5# range 0 .. 7;
      FLT  at 16#6# range 0 .. 7;
      RA   at 16#7# range 0 .. 7;
      SMB  at 16#8# range 0 .. 7;
      A2   at 16#9# range 0 .. 7;
      SLTH at 16#A# range 0 .. 7;
      SLTL at 16#B# range 0 .. 7;
   end record;

   I2C0 : aliased I2C_Type
      with Address    => System'To_Address (16#4006_6000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   I2C1 : aliased I2C_Type
      with Address    => System'To_Address (16#4006_7000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

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
   -- Chapter 41 Integrated Interchip Sound (I2S) / Synchronous Audio Interface (SAI)
   ----------------------------------------------------------------------------

   -- 41.3.1 SAI Transmit Control Register (I2Sx_TCSR)
   -- 41.3.2 SAI Transmit Configuration 2 Register (I2Sx_TCR2)
   -- 41.3.3 SAI Transmit Configuration 3 Register (I2Sx_TCR3)
   -- 41.3.4 SAI Transmit Configuration 4 Register (I2Sx_TCR4)
   -- 41.3.5 SAI Transmit Configuration 5 Register (I2Sx_TCR5)
   -- 41.3.6 SAI Transmit Data Register (I2Sx_TDRn)
   -- 41.3.7 SAI Transmit Mask Register (I2Sx_TMR)
   -- 41.3.8 SAI Receive Control Register (I2Sx_RCSR)
   -- 41.3.9 SAI Receive Configuration 2 Register (I2Sx_RCR2)
   -- 41.3.10 SAI Receive Configuration 3 Register (I2Sx_RCR3)
   -- 41.3.11 SAI Receive Configuration 4 Register (I2Sx_RCR4)
   -- 41.3.12 SAI Receive Configuration 5 Register (I2Sx_RCR5)
   -- 41.3.13 SAI Receive Data Register (I2Sx_RDRn)
   -- 41.3.14 SAI Receive Mask Register (I2Sx_RMR)
   -- 41.3.15 SAI MCLK Control Register (I2Sx_MCR)
   -- 41.3.16 SAI MCLK Divide Register (I2Sx_MDR)

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

   ----------------------------------------------------------------------------
   -- Chapter 43 Touch Sensing Input (TSI)
   ----------------------------------------------------------------------------

   -- 43.3.1 TSI General Control and Status Register (TSIx_GENCS)

   STM_SOFT : constant := 0; -- Software trigger scan.
   STM_HARD : constant := 1; -- Hardware trigger scan.

   NSCN_1  : constant := 2#00000#; -- Once per electrode
   NSCN_2  : constant := 2#00001#; -- Twice per electrode
   NSCN_3  : constant := 2#00010#; -- 3 times per electrode
   NSCN_4  : constant := 2#00011#; -- 4 times per electrode
   NSCN_5  : constant := 2#00100#; -- 5 times per electrode
   NSCN_6  : constant := 2#00101#; -- 6 times per electrode
   NSCN_7  : constant := 2#00110#; -- 7 times per electrode
   NSCN_8  : constant := 2#00111#; -- 8 times per electrode
   NSCN_9  : constant := 2#01000#; -- 9 times per electrode
   NSCN_10 : constant := 2#01001#; -- 10 times per electrode
   NSCN_11 : constant := 2#01010#; -- 11 times per electrode
   NSCN_12 : constant := 2#01011#; -- 12 times per electrode
   NSCN_13 : constant := 2#01100#; -- 13 times per electrode
   NSCN_14 : constant := 2#01101#; -- 14 times per electrode
   NSCN_15 : constant := 2#01110#; -- 15 times per electrode
   NSCN_16 : constant := 2#01111#; -- 16 times per electrode
   NSCN_17 : constant := 2#10000#; -- 17 times per electrode
   NSCN_18 : constant := 2#10001#; -- 18 times per electrode
   NSCN_19 : constant := 2#10010#; -- 19 times per electrode
   NSCN_20 : constant := 2#10011#; -- 20 times per electrode
   NSCN_21 : constant := 2#10100#; -- 21 times per electrode
   NSCN_22 : constant := 2#10101#; -- 22 times per electrode
   NSCN_23 : constant := 2#10110#; -- 23 times per electrode
   NSCN_24 : constant := 2#10111#; -- 24 times per electrode
   NSCN_25 : constant := 2#11000#; -- 25 times per electrode
   NSCN_26 : constant := 2#11001#; -- 26 times per electrode
   NSCN_27 : constant := 2#11010#; -- 27 times per electrode
   NSCN_28 : constant := 2#11011#; -- 28 times per electrode
   NSCN_29 : constant := 2#11100#; -- 29 times per electrode
   NSCN_30 : constant := 2#11101#; -- 30 times per electrode
   NSCN_31 : constant := 2#11110#; -- 31 times per electrode
   NSCN_32 : constant := 2#11111#; -- 32 times per electrode

   -- PS_* already defined at 31.3.1
   -- PS_DIV1   : constant := 2#000#; -- Electrode Oscillator Frequency divided by 1
   -- PS_DIV2   : constant := 2#001#; -- Electrode Oscillator Frequency divided by 2
   -- PS_DIV4   : constant := 2#010#; -- Electrode Oscillator Frequency divided by 4
   -- PS_DIV8   : constant := 2#011#; -- Electrode Oscillator Frequency divided by 8
   -- PS_DIV16  : constant := 2#100#; -- Electrode Oscillator Frequency divided by 16
   -- PS_DIV32  : constant := 2#101#; -- Electrode Oscillator Frequency divided by 32
   -- PS_DIV64  : constant := 2#110#; -- Electrode Oscillator Frequency divided by 64
   -- PS_DIV128 : constant := 2#111#; -- Electrode Oscillator Frequency divided by 128

   EXTCHRG_500nA : constant := 2#000#; -- 500 nA.
   EXTCHRG_1uA   : constant := 2#001#; -- 1 μA.
   EXTCHRG_2uA   : constant := 2#010#; -- 2 μA.
   EXTCHRG_4ua   : constant := 2#011#; -- 4 μA.
   EXTCHRG_8uA   : constant := 2#100#; -- 8 μA.
   EXTCHRG_16uA  : constant := 2#101#; -- 16 μA.
   EXTCHRG_32uA  : constant := 2#110#; -- 32 μA.
   EXTCHRG_64uA  : constant := 2#111#; -- 64 μA.

   DVOLT_1V03 : constant := 2#00#; -- DV = 1.03 V; VP = 1.33 V; Vm = 0.30 V.
   DVOLT_0V73 : constant := 2#01#; -- DV = 0.73 V; VP = 1.18 V; Vm = 0.45 V.
   DVOLT_0V43 : constant := 2#10#; -- DV = 0.43 V; VP = 1.03 V; Vm = 0.60 V.
   DVOLT_0V29 : constant := 2#11#; -- DV = 0.29 V; VP = 0.95 V; Vm = 0.67 V.

   REFCHRG_500nA : constant := 2#000#; -- 500 nA.
   REFCHRG_1uA   : constant := 2#001#; -- 1 μA.
   REFCHRG_2uA   : constant := 2#010#; -- 2 μA.
   REFCHRG_4uA   : constant := 2#011#; -- 4 μA.
   REFCHRG_8uA   : constant := 2#100#; -- 8 μA.
   REFCHRG_16uA  : constant := 2#101#; -- 16 μA.
   REFCHRG_32uA  : constant := 2#110#; -- 32 μA.
   REFCHRG_64uA  : constant := 2#111#; -- 64 μA.

   MODE_CAPSENS : constant := 2#0000#; -- Set TSI in capacitive sensing(non-noise detection) mode.
   MODE_TNDFDIS : constant := 2#0100#; -- Set TSI analog to work in single threshold noise detection mode and the frequency limitation circuit is disabled.
   MODE_TNDFENB : constant := 2#1000#; -- Set TSI analog to work in single threshold noise detection mode and the frequency limitation circuit is enabled to work in higher frequencies operations.
   MODE_AUTO    : constant := 2#1100#; -- Set TSI analog to work in automatic noise detection mode.

   ESOR_OOR : constant := 0; -- Out-of-range interrupt is allowed.
   ESOR_EOS : constant := 1; -- End-of-scan interrupt is allowed.

   type TSIx_GENCS_Type is record
      Reserved1 : Bits_1  := 0;
      CURSW     : Boolean := False;         -- This bit specifies if the current sources of electrode oscillator and reference oscillator are swapped.
      EOSF      : Boolean := False;         -- End of Scan Flag
      SCNIP     : Boolean := False;         -- Scan In Progress Status
      STM       : Bits_1  := STM_SOFT;      -- Scan Trigger Mode
      STPE      : Boolean := False;         -- TSI STOP Enable
      TSIIEN    : Boolean := False;         -- Touch Sensing Input Interrupt Enable
      TSIEN     : Boolean := False;         -- Touch Sensing Input Module Enable
      NSCN      : Bits_5  := NSCN_1;        -- These bits indicate the scan number for each electrode.
      PS        : Bits_3  := PS_DIV1;       -- These bits indicate the prescaler of the output of electrode oscillator.
      EXTCHRG   : Bits_3  := EXTCHRG_500nA; -- These bits indicate the electrode oscillator charge and discharge current value.
      DVOLT     : Bits_2  := DVOLT_1V03;    -- These bits indicate the oscillator's voltage rails as below.
      REFCHRG   : Bits_3  := REFCHRG_500nA; -- These bits indicate the reference oscillator charge and discharge current value.
      MODE      : Bits_4  := MODE_CAPSENS;  -- TSI analog modes setup and status bits.
      ESOR      : Bits_1  := ESOR_OOR;      -- End-of-scan or Out-of-Range Interrupt Selection
      Reserved2 : Bits_2  := 0;
      OUTRGF    : Boolean := False;         -- Out of Range Flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TSIx_GENCS_Type use record
      Reserved1 at 0 range  0 ..  0;
      CURSW     at 0 range  1 ..  1;
      EOSF      at 0 range  2 ..  2;
      SCNIP     at 0 range  3 ..  3;
      STM       at 0 range  4 ..  4;
      STPE      at 0 range  5 ..  5;
      TSIIEN    at 0 range  6 ..  6;
      TSIEN     at 0 range  7 ..  7;
      NSCN      at 0 range  8 .. 12;
      PS        at 0 range 13 .. 15;
      EXTCHRG   at 0 range 16 .. 18;
      DVOLT     at 0 range 19 .. 20;
      REFCHRG   at 0 range 21 .. 23;
      MODE      at 0 range 24 .. 27;
      ESOR      at 0 range 28 .. 28;
      Reserved2 at 0 range 29 .. 30;
      OUTRGF    at 0 range 31 .. 31;
   end record;

   TSIx_GENCS_ADDRESS : constant := 16#4004_5000#;

   TSIx_GENCS : aliased TSIx_GENCS_Type
      with Address              => System'To_Address (TSIx_GENCS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 43.3.2 TSI DATA Register (TSIx_DATA )

   TSICH_0  : constant := 2#0000#; -- Channel 0.
   TSICH_1  : constant := 2#0001#; -- Channel 1.
   TSICH_2  : constant := 2#0010#; -- Channel 2.
   TSICH_3  : constant := 2#0011#; -- Channel 3.
   TSICH_4  : constant := 2#0100#; -- Channel 4.
   TSICH_5  : constant := 2#0101#; -- Channel 5.
   TSICH_6  : constant := 2#0110#; -- Channel 6.
   TSICH_7  : constant := 2#0111#; -- Channel 7.
   TSICH_8  : constant := 2#1000#; -- Channel 8.
   TSICH_9  : constant := 2#1001#; -- Channel 9.
   TSICH_10 : constant := 2#1010#; -- Channel 10.
   TSICH_11 : constant := 2#1011#; -- Channel 11.
   TSICH_12 : constant := 2#1100#; -- Channel 12.
   TSICH_13 : constant := 2#1101#; -- Channel 13.
   TSICH_14 : constant := 2#1110#; -- Channel 14.
   TSICH_15 : constant := 2#1111#; -- Channel 15.

   type TSIx_DATA_Type is record
      TSICNT    : Unsigned_16 := 0;       -- TSI Conversion Counter Value
      Reserved1 : Bits_6      := 0;
      SWTS      : Boolean     := False;   -- Software Trigger Start
      DMAEN     : Boolean     := False;   -- DMA Transfer Enabled
      Reserved2 : Bits_4      := 0;
      TSICH     : Bits_4      := TSICH_0; -- These bits specify current channel to be measured.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TSIx_DATA_Type use record
      TSICNT    at 0 range  0 .. 15;
      Reserved1 at 0 range 16 .. 21;
      SWTS      at 0 range 22 .. 22;
      DMAEN     at 0 range 23 .. 23;
      Reserved2 at 0 range 24 .. 27;
      TSICH     at 0 range 28 .. 31;
   end record;

   TSIx_DATA_ADDRESS : constant := 16#4004_5004#;

   TSIx_DATA : aliased TSIx_DATA_Type
      with Address              => System'To_Address (TSIx_DATA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 43.3.3 TSI Threshold Register (TSIx_TSHD)

   type TSIx_TSHD_Type is record
      THRESL : Unsigned_16 := 0; -- TSI Wakeup Channel Low-threshold
      THRESH : Unsigned_16 := 0; -- TSI Wakeup Channel High-threshold
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TSIx_TSHD_Type use record
      THRESL at 0 range  0 .. 15;
      THRESH at 0 range 16 .. 31;
   end record;

   TSIx_TSHD_ADDRESS : constant := 16#4004_5008#;

   TSIx_TSHD : aliased TSIx_TSHD_Type
      with Address              => System'To_Address (TSIx_TSHD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 44 LCD Controller (SLCD)
   ----------------------------------------------------------------------------

   -- 44.3.1 LCD General Control Register (LCD_GCR)

   DUTY_1BP : constant := 2#000#; -- Use 1 BP (1/1 duty cycle).
   DUTY_2BP : constant := 2#001#; -- Use 2 BP (1/2 duty cycle).
   DUTY_3BP : constant := 2#010#; -- Use 3 BP (1/3 duty cycle).
   DUTY_4BP : constant := 2#011#; -- Use 4 BP (1/4 duty cycle). (Default)
   DUTY_8BP : constant := 2#111#; -- Use 8 BP (1/8 duty cycle).

   LCLK_PS1 : constant := 2#000#; -- 44.4.1.3 SLCD base clock and frame frequency
   LCLK_PS2 : constant := 2#001#; -- ''
   LCLK_PS3 : constant := 2#010#; -- ''
   LCLK_PS4 : constant := 2#011#; -- ''
   LCLK_PS5 : constant := 2#100#; -- ''
   LCLK_PS6 : constant := 2#101#; -- ''
   LCLK_PS7 : constant := 2#110#; -- ''
   LCLK_PS8 : constant := 2#111#; -- ''

   SOURCE_DEFAULT   : constant := 0; -- Selects the default clock as the LCD clock source.
   SOURCE_ALTSOURCE : constant := 1; -- Selects output of the alternate clock source selection (see ALTSOURCE) as the LCD clock source.

   ALTSOURCE_CLKSRC1 : constant := 0; -- Select Alternate Clock Source 1 (default)
   ALTSOURCE_CLKSRC2 : constant := 1; -- Select Alternate Clock Source 2

   ALTDIV_DIV1   : constant := 2#00#; -- Divide factor = 1 (No divide)
   ALTDIV_DIV8   : constant := 2#01#; -- Divide factor = 8
   ALTDIV_DIV64  : constant := 2#10#; -- Divide factor = 64
   ALTDIV_DIV512 : constant := 2#11#; -- Divide factor = 512

   VSUPPLY_INT : constant := 0; -- Drive VLL3 internally from VDD
   VSUPPLY_EXT : constant := 1; -- Drive VLL3 externally from VDD or drive VLL internally from vIREG

   -- For CPSEL = 0
   LADJ_LOWLOAD1  : constant := 2#00#; -- Low Load (LCD glass capacitance 2000 pF or lower). LCD or GPIO functions can be used on V LL1 , V LL2 , V CAP1 and V CAP2 pins.
   LADJ_LOWLOAD2  : constant := 2#01#; -- Low Load (LCD glass capacitance 2000 pF or lower). LCD or GPIO functions can be used on V LL1 , V LL2 , V CAP1 and V CAP2 pins.
   LADJ_HIGHLOAD1 : constant := 2#10#; -- High Load (LCD glass capacitance 8000 pF or lower) LCD or GPIO functions can be used on V CAP1 and V CAP2 pins. .
   LADJ_HIGHLOAD2 : constant := 2#11#; -- High Load (LCD glass capacitance 8000 pF or lower). LCD or GPIO functions can be used on V CAP1 and V CAP2 pins.
   -- For CPSEL = 1
   LADJ_FASTCLK   : constant := 2#00#; -- Fastest clock source for charge pump (LCD glass capacitance 8000 pF or 4000pF or lower if FFR is set ).
   LADJ_INTCLK1   : constant := 2#01#; -- Intermediate clock source for charge pump (LCD glass capacitance 4000 pF or 2000pF or lower if FFR is set ).
   LADJ_INTCLK2   : constant := 2#10#; -- Intermediate clock source for charge pump (LCD glass capacitance 2000 pF or 1000pF or lower if FFR is set ).
   LADJ_SLOWCLK   : constant := 2#11#; -- Slowest clock source for charge pump (LCD glass capacitance 1000 pF or 500pF or lower if FFR is set ).

   CPSEL_DISABLE : constant := 0; -- LCD charge pump is disabled. Resistor network selected. (The internal 1/3-bias is forced.)
   CPSEL_ENABLE  : constant := 1; -- LCD charge pump is selected. Resistor network disabled. (The internal 1/3-bias is forced.)

   type LCD_GCR_Type is record
      DUTY      : Bits_3  := DUTY_4BP;          -- LCD duty select
      LCLK      : Bits_3  := LCLK_PS1;          -- LCD Clock Prescaler
      SOURCE    : Bits_1  := SOURCE_DEFAULT;    -- LCD Clock Source Select
      LCDEN     : Boolean := False;             -- LCD Driver Enable
      LCDSTP    : Boolean := False;             -- LCD Stop
      LCDDOZE   : Boolean := False;             -- LCD Doze enable
      FFR       : Boolean := False;             -- Fast Frame Rate Select
      ALTSOURCE : Bits_1  := ALTSOURCE_CLKSRC1; -- Selects the alternate clock source
      ALTDIV    : Bits_2  := ALTDIV_DIV1;       -- LCD AlternateClock Divider
      FDCIEN    : Boolean := False;             -- LCD Fault Detection Complete Interrupt Enable
      PADSAFE   : Boolean := False;             -- Pad Safe State Enable
      Reserved1 : Bits_1  := 0;
      VSUPPLY   : Bits_1  := VSUPPLY_INT;       -- Voltage Supply Control
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_1  := 0;
      LADJ      : Bits_2  := LADJ_HIGHLOAD2;    -- Load Adjust
      Reserved4 : Bits_1  := 0;
      CPSEL     : Bits_1  := CPSEL_DISABLE;     -- Charge Pump or Resistor Bias Select
      RVTRIM    : Bits_4  := 8;                 -- Regulated Voltage Trim
      Reserved5 : Bits_3  := 0;
      RVEN      : Boolean := False;             -- Regulated Voltage Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_GCR_Type use record
      DUTY      at 0 range  0 ..  2;
      LCLK      at 0 range  3 ..  5;
      SOURCE    at 0 range  6 ..  6;
      LCDEN     at 0 range  7 ..  7;
      LCDSTP    at 0 range  8 ..  8;
      LCDDOZE   at 0 range  9 ..  9;
      FFR       at 0 range 10 .. 10;
      ALTSOURCE at 0 range 11 .. 11;
      ALTDIV    at 0 range 12 .. 13;
      FDCIEN    at 0 range 14 .. 14;
      PADSAFE   at 0 range 15 .. 15;
      Reserved1 at 0 range 16 .. 16;
      VSUPPLY   at 0 range 17 .. 17;
      Reserved2 at 0 range 18 .. 18;
      Reserved3 at 0 range 19 .. 19;
      LADJ      at 0 range 20 .. 21;
      Reserved4 at 0 range 22 .. 22;
      CPSEL     at 0 range 23 .. 23;
      RVTRIM    at 0 range 24 .. 27;
      Reserved5 at 0 range 28 .. 30;
      RVEN      at 0 range 31 .. 31;
   end record;

   LCD_GCR_ADDRESS : constant := 16#4005_3000#;

   LCD_GCR : aliased LCD_GCR_Type
      with Address              => System'To_Address (LCD_GCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 44.3.2 LCD Auxiliary Register (LCD_AR)

   BRATE_1 : constant := 2#000#; -- LCD controller blink rate = LCD clock /2**(12 + 0)
   BRATE_2 : constant := 2#001#; -- LCD controller blink rate = LCD clock /2**(12 + 1)
   BRATE_3 : constant := 2#010#; -- LCD controller blink rate = LCD clock /2**(12 + 2)
   BRATE_4 : constant := 2#011#; -- LCD controller blink rate = LCD clock /2**(12 + 3)
   BRATE_5 : constant := 2#100#; -- LCD controller blink rate = LCD clock /2**(12 + 4)
   BRATE_6 : constant := 2#101#; -- LCD controller blink rate = LCD clock /2**(12 + 5)
   BRATE_7 : constant := 2#110#; -- LCD controller blink rate = LCD clock /2**(12 + 6)
   BRATE_8 : constant := 2#111#; -- LCD controller blink rate = LCD clock /2**(12 + 7)

   BMODE_BLANK   : constant := 0; -- Display blank during the blink period.
   BMODE_ALTDISP : constant := 1; -- Display alternate display during blink period (Ignored if duty is 5 or greater).

   type LCD_AR_Type is record
      BRATE     : Bits_3  := BRATE_1;     -- Blink-rate configuration
      BMODE     : Bits_1  := BMODE_BLANK; -- Blink mode
      Reserved1 : Bits_1  := 0;
      BLANK     : Boolean := False;       -- Blank display mode
      ALT       : Boolean := False;       -- Alternate display mode
      BLINK     : Boolean := False;       -- Blink command
      Reserved2 : Bits_7  := 0;
      Reserved3 : Bits_1  := 0;
      Reserved4 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_AR_Type use record
      BRATE     at 0 range  0 ..  2;
      BMODE     at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  4;
      BLANK     at 0 range  5 ..  5;
      ALT       at 0 range  6 ..  6;
      BLINK     at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 14;
      Reserved3 at 0 range 15 .. 15;
      Reserved4 at 0 range 16 .. 31;
   end record;

   LCD_AR_ADDRESS : constant := 16#4005_3004#;

   LCD_AR : aliased LCD_AR_Type
      with Address              => System'To_Address (LCD_AR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 44.3.3 LCD Fault Detect Control Register (LCD_FDCR)

   FDSWW_4   : constant := 2#000#; -- Sample window width is 4 sample clock cycles.
   FDSWW_8   : constant := 2#001#; -- Sample window width is 8 sample clock cycles.
   FDSWW_16  : constant := 2#010#; -- Sample window width is 16 sample clock cycles.
   FDSWW_32  : constant := 2#011#; -- Sample window width is 32 sample clock cycles.
   FDSWW_64  : constant := 2#100#; -- Sample window width is 64 sample clock cycles.
   FDSWW_128 : constant := 2#101#; -- Sample window width is 128 sample clock cycles.
   FDSWW_256 : constant := 2#110#; -- Sample window width is 256 sample clock cycles.
   FDSWW_512 : constant := 2#111#; -- Sample window width is 512 sample clock cycles.

   FDPRS_DIV1   : constant := 2#000#; -- 1/1 bus clock.
   FDPRS_DIV2   : constant := 2#001#; -- 1/2 bus clock.
   FDPRS_DIV4   : constant := 2#010#; -- 1/4 bus clock.
   FDPRS_DIV8   : constant := 2#011#; -- 1/8 bus clock.
   FDPRS_DIV16  : constant := 2#100#; -- 1/16 bus clock.
   FDPRS_DIV32  : constant := 2#101#; -- 1/32 bus clock.
   FDPRS_DIV64  : constant := 2#110#; -- 1/64 bus clock.
   FDPRS_DIV128 : constant := 2#111#; -- 1/128 bus clock.

   type LCD_FDCR_Type is record
      FDPINID   : Bits_6  := 0;          -- Fault Detect Pin ID
      FDBPEN    : Boolean := False;      -- Fault Detect Back Plane Enable
      FDEN      : Boolean := False;      -- Fault Detect Enable
      Reserved1 : Bits_1  := 0;
      FDSWW     : Bits_3  := FDSWW_4;    -- Fault Detect Sample Window Width
      FDPRS     : Bits_3  := FDPRS_DIV1; -- Fault Detect Clock Prescaler
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_FDCR_Type use record
      FDPINID   at 0 range  0 ..  5;
      FDBPEN    at 0 range  6 ..  6;
      FDEN      at 0 range  7 ..  7;
      Reserved1 at 0 range  8 ..  8;
      FDSWW     at 0 range  9 .. 11;
      FDPRS     at 0 range 12 .. 14;
      Reserved2 at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   LCD_FDCR_ADDRESS : constant := 16#4005_3008#;

   LCD_FDCR : aliased LCD_FDCR_Type
      with Address              => System'To_Address (LCD_FDCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 44.3.4 LCD Fault Detect Status Register (LCD_FDSR)

   type LCD_FDSR_Type is record
      FDCNT     : Unsigned_8 := 0;     -- Fault Detect Counter
      Reserved1 : Bits_7     := 0;
      FDCF      : Boolean    := False; -- Fault Detection Complete Flag
      Reserved2 : Bits_16    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_FDSR_Type use record
      FDCNT     at 0 range  0 ..  7;
      Reserved1 at 0 range  8 .. 14;
      FDCF      at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   LCD_FDSR_ADDRESS : constant := 16#4005_300C#;

   LCD_FDSR : aliased LCD_FDSR_Type
      with Address              => System'To_Address (LCD_FDSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- types for LCD_PENn/LCD_BPENn

   type Bitmap_32L is array (0 .. 31) of Boolean
      with Component_Size => 1,
           Size           => 32;

   type Bitmap_32H is array (32 .. 63) of Boolean
      with Component_Size => 1,
           Size           => 32;

   -- 44.3.5 LCD Pin Enable register (LCD_PENn)

   type LCD_PENL_Type is record
      PEN : Bitmap_32L := [others => False]; -- LCD Pin Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_PENL_Type use record
      PEN at 0 range 0 .. 31;
   end record;

   LCD_PENL_ADDRESS : constant := 16#4005_3010#;

   LCD_PENL : aliased LCD_PENL_Type
      with Address              => System'To_Address (LCD_PENL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type LCD_PENH_Type is record
      PEN : Bitmap_32H := [others => False]; -- LCD Pin Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_PENH_Type use record
      PEN at 0 range 0 .. 31;
   end record;

   LCD_PENH_ADDRESS : constant := 16#4005_3014#;

   LCD_PENH : aliased LCD_PENH_Type
      with Address              => System'To_Address (LCD_PENH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 44.3.6 LCD Back Plane Enable register (LCD_BPENn)

   type LCD_BPENL_Type is record
      BPEN : Bitmap_32L := [others => False]; -- Back Plane Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_BPENL_Type use record
      BPEN at 0 range 0 .. 31;
   end record;

   LCD_BPENL_ADDRESS : constant := 16#4005_3018#;

   LCD_BPENL : aliased LCD_BPENL_Type
      with Address              => System'To_Address (LCD_BPENL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type LCD_BPENH_Type is record
      BPEN : Bitmap_32H := [others => False]; -- Back Plane Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCD_BPENH_Type use record
      BPEN at 0 range 0 .. 31;
   end record;

   LCD_BPENH_ADDRESS : constant := 16#4005_301C#;

   LCD_BPENH : aliased LCD_BPENH_Type
      with Address              => System'To_Address (LCD_BPENH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 44.3.7 LCD Waveform register (LCD_WF3TO0)
   -- 44.3.8 LCD Waveform register (LCD_WF7TO4)
   -- 44.3.9 LCD Waveform register (LCD_WF11TO8)
   -- 44.3.10 LCD Waveform register (LCD_WF15TO12)
   -- 44.3.11 LCD Waveform register (LCD_WF19TO16)
   -- 44.3.12 LCD Waveform register (LCD_WF23TO20)
   -- 44.3.13 LCD Waveform register (LCD_WF27TO24)
   -- 44.3.14 LCD Waveform register (LCD_WF31TO28)
   -- 44.3.15 LCD Waveform register (LCD_WF35TO32)
   -- 44.3.16 LCD Waveform register (LCD_WF39TO36)
   -- 44.3.17 LCD Waveform register (LCD_WF43TO40)
   -- 44.3.18 LCD Waveform register (LCD_WF47TO44)
   -- 44.3.19 LCD Waveform register (LCD_WF51TO48)
   -- 44.3.20 LCD Waveform register (LCD_WF55TO52)
   -- 44.3.21 LCD Waveform register (LCD_WF59TO56)
   -- 44.3.22 LCD Waveform register (LCD_WF63TO60)

   type LCD_Waveform_Type is record
      A : Boolean := False;
      B : Boolean := False;
      C : Boolean := False;
      D : Boolean := False;
      E : Boolean := False;
      F : Boolean := False;
      G : Boolean := False;
      H : Boolean := False;
   end record
      with Pack => True,
           Size => 8;

   type LCD_Waveform_Array_Type is array (0 .. 3) of LCD_Waveform_Type;
   type LCD_Waveform_Register_Type is record
      WF : LCD_Waveform_Array_Type with Volatile_Full_Access => True;
   end record
      with Size => 32;

   -- LCD_WF3TO0   : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3020#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF7TO4   : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3024#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF11TO8  : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3028#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF15TO12 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_302C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF19TO16 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3030#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF23TO20 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3034#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF27TO24 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3038#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF31TO28 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_303C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF35TO32 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3040#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF39TO36 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3044#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF43TO40 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3048#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF47TO44 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_304C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF51TO48 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3050#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF55TO52 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3054#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF59TO56 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_3058#), Volatile_Full_Access => True, Import => True, Convention => Ada;
   -- LCD_WF63TO60 : aliased LCD_Waveform_Array_Type with Address => System'To_Address (16#4005_305C#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   type LCD_Waveform_Register_Array_Type is array (0 .. 15) of LCD_Waveform_Register_Type
      with Pack => True;

   LCD_WF : aliased LCD_Waveform_Register_Array_Type
      with Address    => System'To_Address (16#4005_3020#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end KL46Z;
