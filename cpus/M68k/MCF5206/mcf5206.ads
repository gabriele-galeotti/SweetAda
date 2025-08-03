-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf5206.ads                                                                                               --
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
with System.Storage_Elements;
with Interfaces;
with Configure;
with Bits;

package MCF5206
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MCF5206 ColdFire Integrated Microprocessor User’s Manual
   -- MCF5206 USER’S MANUAL Rev 1.0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- SECTION 7 SYSTEM INTEGRATION MODULE
   ----------------------------------------------------------------------------

   -- 7.3.2.3 INTERRUPT CONTROL REGISTER (ICR).

   type ICR_Type is record
      IP     : Bits_2;      -- Interrupt Priority
      IL     : Bits_3;      -- Interrupt Level
      Unused : Bits_2 := 0;
      AVEC   : Boolean;     -- Autovector Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ICR_Type use record
      IP     at 0 range 0 .. 1;
      IL     at 0 range 2 .. 4;
      Unused at 0 range 5 .. 6;
      AVEC   at 0 range 7 .. 7;
   end record;

   -- 7.3.2.4 INTERRUPT MASK REGISTER (IMR).

   type IMR_Type is record
      Unused1 : Bits_1  := 0;
      EINT1   : Boolean := True; -- External Interrupt Request 1 External Interrupt Priority Level 1
      EINT2   : Boolean := True; -- External Interrupt Priority Level 2
      EINT3   : Boolean := True; -- External Interrupt Priority Level 3
      EINT4   : Boolean := True; -- External Interrupt Request 4 External Interrupt Priority Level 4
      EINT5   : Boolean := True; -- External Interrupt Priority Level 5
      EINT6   : Boolean := True; -- External Interrupt Priority Level 6
      EINT7   : Boolean := True; -- External Interrupt Request 7 External Interrupt Priority Level 7
      SWT     : Boolean := True; -- Software Watchdog Timer
      TIMER1  : Boolean := True; -- Timer 1
      TIMER2  : Boolean := True; -- Timer 2
      MBUS    : Boolean := True; -- MBUS (I2C)
      UART1   : Boolean := True; -- UART 1
      UART2   : Boolean := True; -- UART 2
      Unused2 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for IMR_Type use record
      Unused1 at 0 range  0 ..  0;
      EINT1   at 0 range  1 ..  1;
      EINT2   at 0 range  2 ..  2;
      EINT3   at 0 range  3 ..  3;
      EINT4   at 0 range  4 ..  4;
      EINT5   at 0 range  5 ..  5;
      EINT6   at 0 range  6 ..  6;
      EINT7   at 0 range  7 ..  7;
      SWT     at 0 range  8 ..  8;
      TIMER1  at 0 range  9 ..  9;
      TIMER2  at 0 range 10 .. 10;
      MBUS    at 0 range 11 .. 11;
      UART1   at 0 range 12 .. 12;
      UART2   at 0 range 13 .. 13;
      Unused2 at 0 range 14 .. 15;
   end record;

   -- 7.3.2.5 INTERRUPT-PENDING REGISTER (IPR).

   type IPR_Type is record
      Unused1 : Bits_1  := 0;
      EINT1   : Boolean := False; -- External Interrupt Request 1 External Interrupt Priority Level 1
      EINT2   : Boolean := False; -- External Interrupt Priority Level 2
      EINT3   : Boolean := False; -- External Interrupt Priority Level 3
      EINT4   : Boolean := False; -- External Interrupt Request 4 External Interrupt Priority Level 4
      EINT5   : Boolean := False; -- External Interrupt Priority Level 5
      EINT6   : Boolean := False; -- External Interrupt Priority Level 6
      EINT7   : Boolean := False; -- External Interrupt Request 7 External Interrupt Priority Level 7
      SWT     : Boolean := False; -- Software Watchdog Timer
      TIMER1  : Boolean := False; -- Timer 1
      TIMER2  : Boolean := False; -- Timer 2
      MBUS    : Boolean := False; -- MBUS (I2C)
      UART1   : Boolean := False; -- UART 1
      UART2   : Boolean := False; -- UART 2
      Unused2 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for IPR_Type use record
      Unused1 at 0 range  0 ..  0;
      EINT1   at 0 range  1 ..  1;
      EINT2   at 0 range  2 ..  2;
      EINT3   at 0 range  3 ..  3;
      EINT4   at 0 range  4 ..  4;
      EINT5   at 0 range  5 ..  5;
      EINT6   at 0 range  6 ..  6;
      EINT7   at 0 range  7 ..  7;
      SWT     at 0 range  8 ..  8;
      TIMER1  at 0 range  9 ..  9;
      TIMER2  at 0 range 10 .. 10;
      MBUS    at 0 range 11 .. 11;
      UART1   at 0 range 12 .. 12;
      UART2   at 0 range 13 .. 13;
      Unused2 at 0 range 14 .. 15;
   end record;

   -- 7.3.1 SIM Registers Memory Map

   -- Interrupt Control Register 1 - External IRQ1/IPL1
   ICR1 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 2 - External IPL2
   ICR2 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#15#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 3 - External IPL3
   ICR3 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#16#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 4 - External IRQ4/IPL4
   ICR4 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#17#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 5 - External IPL5
   ICR5 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 6 - External IPL6
   ICR6 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#19#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 7 - External IRQ7/IPL7
   ICR7 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 8 - SWT
   ICR8 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 9 - Timer 1 Interrupt
   ICR9 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 10 - Timer 2 Interrupt 
   ICR10 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1D#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 11 - MBUS Interrupt
   ICR11 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1E#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 12 - UART 1 Interrupt
   ICR12 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#1F#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;
   -- Interrupt Control Register 13 - UART2 Interrupt
   ICR13 : aliased ICR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#20#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IMR : aliased IMR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#36#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   IPR : aliased IPR_Type
      with Address              => System'To_Address (Configure.MBAR_VALUE + 16#3A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- SECTION 11 UART MODULES
   ----------------------------------------------------------------------------

   type UART_Register_Type is
      (
       UMR1,
       UMR2,
       USR,
       UCSR,
       UCR,
       URB,
       UTB,
       UIPCR,
       UACR,
       UISR,
       UIMR,
       UBG1,
       UBG2,
       UIVR,
       UIP,
       UOP1,
       UOP0
      );

   UART_Register_Offset : constant array (UART_Register_Type) of Storage_Offset :=
      [
       UMR1  => 16#0140#,
       UMR2  => 16#0140#,
       USR   => 16#0144#,
       UCSR  => 16#0144#,
       UCR   => 16#0148#,
       URB   => 16#014C#,
       UTB   => 16#014C#,
       UIPCR => 16#0150#,
       UACR  => 16#0150#,
       UISR  => 16#0154#,
       UIMR  => 16#0154#,
       UBG1  => 16#0158#,
       UBG2  => 16#015C#,
       UIVR  => 16#0170#,
       UIP   => 16#0174#,
       UOP1  => 16#0178#,
       UOP0  => 16#017C#
      ];

   -- 11.4.1.1 MODE REGISTER 1 (UMR1).

   BC_5Bit : constant := 2#00#; -- 5 Bits
   BC_6Bit : constant := 2#01#; -- 6 Bits
   BC_7Bit : constant := 2#10#; -- 7 Bits
   BC_8Bit : constant := 2#11#; -- 8 Bits

   PTPM_PEVEN     : constant := 2#000#; -- With Parity, Even Parity
   PTPM_PODD      : constant := 2#001#; -- With Parity, Odd Parity
   PTPM_FLOW      : constant := 2#010#; -- Force Parity, Low Parity
   PTPM_FHIGH     : constant := 2#011#; -- Force Parity, High Parity
   PTPM_NOP       : constant := 2#100#; -- No Parity
   PTPM_NOP2      : constant := 2#101#; -- No Parity
   PTPM_MDROPDATA : constant := 2#110#; -- Multidrop Mode, Data Character
   PTPM_MDROPADDR : constant := 2#111#; -- Multidrop Mode, Address Character

   ERR_CHAR  : constant := 0; -- Error Mode Character
   ERR_BLOCK : constant := 1; -- Error Mode Block

   RxIRQ_RxRDY : constant := 0; -- RxRDY is the source that generates IRQ
   RxIRQ_FFULL : constant := 1; -- FFULL is the source that generates IRQ

   RxRTS_NONE  : constant := 0; -- The receiver has no effect on /RTS
   RxRTS_FFULL : constant := 1; -- On receipt of a valid start bit, RTS is negated if the UART FIFO is full

   type UMR1_Type is record
      BC    : Bits_2 := BC_5Bit;     -- Bits per Character
      PTPM  : Bits_3 := PTPM_PEVEN;  -- Parity Type and Parity Mode
      ERR   : Bits_1 := ERR_CHAR;    -- Error Mode
      RxIRQ : Bits_1 := RxIRQ_RxRDY; -- Receiver Interrupt Select
      RxRTS : Bits_1 := RxRTS_NONE;  -- Receiver Request-to-Send Control
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UMR1_Type use record
      BC    at 0 range 0 .. 1;
      PTPM  at 0 range 2 .. 4;
      ERR   at 0 range 5 .. 5;
      RxIRQ at 0 range 6 .. 6;
      RxRTS at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : UMR1_Type)
      return Unsigned_8
      with Inline => True;
   function To_UMR1
      (Value : Unsigned_8)
      return UMR1_Type
      with Inline => True;

   -- 11.4.1.2 MODE REGISTER 2 (UMR2).

   --                              6-8   5     LENGTH BITS
   SB_0  : constant := 2#0000#; -- 0.563 1.063
   SB_1  : constant := 2#0001#; -- 0.625 1.125
   SB_2  : constant := 2#0010#; -- 0.688 1.188
   SB_3  : constant := 2#0011#; -- 0.750 1.250
   SB_4  : constant := 2#0100#; -- 0.813 1.313
   SB_5  : constant := 2#0101#; -- 0.875 1.375
   SB_6  : constant := 2#0110#; -- 0.938 1.438
   SB_7  : constant := 2#0111#; -- 1.000 1.500
   SB_8  : constant := 2#1000#; -- 1.563 1.563
   SB_9  : constant := 2#1001#; -- 1.625 1.625
   SB_10 : constant := 2#1010#; -- 1.688 1.688
   SB_11 : constant := 2#1011#; -- 1.750 1.750
   SB_12 : constant := 2#1100#; -- 1.813 1.813
   SB_13 : constant := 2#1101#; -- 1.875 1.875
   SB_14 : constant := 2#1110#; -- 1.938 1.938
   SB_15 : constant := 2#1111#; -- 2.000 2.000

   CM_NORMAL   : constant := 2#00#; -- Normal
   CM_AUTOECHO : constant := 2#01#; -- Automatic Echo
   CM_LOCLBACK : constant := 2#10#; -- Local Loopback
   CM_REMLBACK : constant := 2#11#; -- Remote Loopback

   type UMR2_Type is record
      SB    : Bits_4  := SB_0;      -- Stop-Bit Length Control
      TxCTS : Boolean := False;     -- Transmitter Clear-to-Send
      TxRTS : Boolean := False;     -- Transmitter Ready-to-Send
      CM    : Bits_2  := CM_NORMAL; -- Channel Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UMR2_Type use record
      SB    at 0 range 0 .. 3;
      TxCTS at 0 range 4 .. 4;
      TxRTS at 0 range 5 .. 5;
      CM    at 0 range 6 .. 7;
   end record;

   function To_U8
      (Value : UMR2_Type)
      return Unsigned_8
      with Inline => True;
   function To_UMR2
      (Value : Unsigned_8)
      return UMR2_Type
      with Inline => True;

   -- 11.4.1.3 STATUS REGISTER (USR).

   type USR_Type is record
      RxRDY : Boolean; -- Receiver Ready
      FFULL : Boolean; -- FIFO Full
      TxRDY : Boolean; -- Transmitter Ready
      TxEMP : Boolean; -- Transmitter Empty
      OE    : Boolean; -- Overrun Error
      PE    : Boolean; -- Parity Error
      FE    : Boolean; -- Framing Error
      RB    : Boolean; -- Received Break
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for USR_Type use record
      RxRDY at 0 range 0 .. 0;
      FFULL at 0 range 1 .. 1;
      TxRDY at 0 range 2 .. 2;
      TxEMP at 0 range 3 .. 3;
      OE    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      FE    at 0 range 6 .. 6;
      RB    at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : USR_Type)
      return Unsigned_8
      with Inline => True;
   function To_USR
      (Value : Unsigned_8)
      return USR_Type
      with Inline => True;

   -- 11.4.1.4 CLOCK-SELECT REGISTER (UCSR).

   TCS_TIMER : constant := 2#1101#; -- TIMER
   TCS_EXT16 : constant := 2#1110#; -- Ext. clk. x 16
   TCS_EXT   : constant := 2#1111#; -- Ext. clk. x 1

   RCS_TIMER : constant := 2#1101#; -- TIMER
   RCS_EXT16 : constant := 2#1110#; -- Ext. clk. x 16
   RCS_EXT   : constant := 2#1111#; -- Ext. clk. x 1

   type UCSR_Type is record
      TCS : Bits_4 := TCS_TIMER; -- Transmitter Clock Select
      RCS : Bits_4 := RCS_TIMER; -- Receiver Clock Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCSR_Type use record
      TCS at 0 range 0 .. 3;
      RCS at 0 range 4 .. 7;
   end record;

   function To_U8
      (Value : UCSR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UCSR
      (Value : Unsigned_8)
      return UCSR_Type
      with Inline => True;

   -- 11.4.1.5 COMMAND REGISTER (UCR).

   RC_NONE    : constant := 2#00#; -- No Action Taken
   RC_ENABLE  : constant := 2#01#; -- Receiver Enable
   RC_DISABLE : constant := 2#10#; -- Receiver Disable

   TC_NONE    : constant := 2#00#; -- No Action Taken
   TC_ENABLE  : constant := 2#01#; -- Transmitter Enable
   TC_DISABLE : constant := 2#10#; -- Transmitter Disable

   MISC_NONE     : constant := 2#000#; -- No Command
   MISC_RESET    : constant := 2#001#; -- Reset Mode Register Pointer
   MISC_RxRESET  : constant := 2#010#; -- Reset Receiver
   MISC_TxRESET  : constant := 2#011#; -- Reset Transmitter
   MISC_ERRRESET : constant := 2#100#; -- Reset Error Status
   MISC_BRKRESET : constant := 2#101#; -- Reset Break-Change Interrupt
   MISC_BRKSTART : constant := 2#110#; -- Start Break
   MISC_BRKSTOP  : constant := 2#111#; -- Stop Break

   type UCR_Type is record
      RC       : Bits_2 := RC_NONE;   -- Receiver Commands
      TC       : Bits_2 := TC_NONE;   -- Transmitter Commands
      MISC     : Bits_3 := MISC_NONE; -- Miscellaneous Commands
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCR_Type use record
      RC       at 0 range 0 .. 1;
      TC       at 0 range 2 .. 3;
      MISC     at 0 range 4 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : UCR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UCR
      (Value : Unsigned_8)
      return UCR_Type
      with Inline => True;

   -- 11.4.1.8 INPUT PORT CHANGE REGISTER (UIPCR).

   CTS_ONE  : constant := 1; -- The current state of the /CTS input is logic one.
   CTS_ZERO : constant := 0; -- The current state of the /CTS input is logic zero.

   type UIPCR_Type is record
      CTS       : Bits_1;  -- Current State
      Reserved1 : Bits_3;
      COS       : Boolean; -- Change-of-State
      Reserved2 : Bits_3;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UIPCR_Type use record
      CTS       at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      COS       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
   end record;

   function To_U8
      (Value : UIPCR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UIPCR
      (Value : Unsigned_8)
      return UIPCR_Type
      with Inline => True;

   -- 11.4.1.9 AUXILIARY CONTROL REGISTER (UACR).

   type UACR_Type is record
      IEC      : Boolean := False; -- Input Enable Control
      Reserved : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UACR_Type use record
      IEC      at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   function To_U8
      (Value : UACR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UACR
      (Value : Unsigned_8)
      return UACR_Type
      with Inline => True;

   -- 11.4.1.10 INTERRUPT STATUS REGISTER (UISR).

   type UISR_Type is record
      TxRDY    : Boolean; -- Transmitter Ready
      RxRDY    : Boolean; -- Receiver Ready or FIFO Full
      DB       : Boolean; -- Delta Break
      Reserved : Bits_4;
      COS      : Boolean; -- Change-of-State
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UISR_Type use record
      TxRDY    at 0 range 0 .. 0;
      RxRDY    at 0 range 1 .. 1;
      DB       at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 6;
      COS      at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : UISR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UISR
      (Value : Unsigned_8)
      return UISR_Type
      with Inline => True;

   -- 11.4.1.11 INTERRUPT MASK REGISTER (UIMR).

   type UIMR_Type is record
      TxRDY    : Boolean := False; -- Transmitter Ready
      FFULL    : Boolean := False; -- FIFO Full
      DB       : Boolean := False; -- Delta Break
      Reserved : Bits_4  := 0;
      COS      : Boolean := False; -- Change-of-State
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UIMR_Type use record
      TxRDY    at 0 range 0 .. 0;
      FFULL    at 0 range 1 .. 1;
      DB       at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 6;
      COS      at 0 range 7 .. 7;
   end record;

   function To_U8
      (Value : UIMR_Type)
      return Unsigned_8
      with Inline => True;
   function To_UIMR
      (Value : Unsigned_8)
      return UIMR_Type
      with Inline => True;

   -- 11.4.1.14.1 Input Port Register (UIP).

   type UIP_Type is record
      nCTS     : Boolean; -- Current State
      Reserved : Bits_7;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UIP_Type use record
      nCTS     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   function To_U8
      (Value : UIP_Type)
      return Unsigned_8
      with Inline => True;
   function To_UIP
      (Value : Unsigned_8)
      return UIP_Type
      with Inline => True;

   -- 11.4.1.14.2 Output Port Data Registers (UOP1, UOP0).

   type UOP_Type is record
      nRTS     : Boolean; -- Output Port Parallel Output
      Reserved : Bits_7;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UOP_Type use record
      nRTS     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   function To_U8
      (Value : UOP_Type)
      return Unsigned_8
      with Inline => True;
   function To_UOP
      (Value : Unsigned_8)
      return UOP_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- SECTION 13 TIMER MODULE
   ----------------------------------------------------------------------------

   -- 13.4.1.1 TIMER MODE REGISTER (TMR)

   CLK_TIN         : constant := 2#11#; -- TIN pin (falling edge)
   CLK_MSTCLKDIV16 : constant := 2#10#; -- Master system clock divided by 16.
   CLK_MSTCLK      : constant := 2#01#; -- Master system clock
   CLK_STOP        : constant := 2#00#; -- Stops counter.

   FRR_RESTART : constant := 1; -- Restart: Timer count is reset immediately after reaching the reference value
   FRR_FREERUN : constant := 0; -- Free run: Timer count continues to increment after reaching the reference value

   OM_PULSE  : constant := 0; -- Active-low pulse for one system clock cycle (30ns at 33 MHz)
   OM_TOGGLE : constant := 1; -- Toggle output

   CE_ANYEDGE : constant := 2#11#; -- Capture on any edge and enable interrupt on capture event
   CE_FALLING : constant := 2#10#; -- Capture on falling edge only and enable interrupt on capture event
   CE_RISING  : constant := 2#01#; -- Capture on rising edge only and enable interrupt on capture event
   CE_DISABLE : constant := 2#00#; -- Disable interrupt on capture event

   type TMR_Type is record
      RST : Boolean    := False;       -- Reset Timer
      CLK : Bits_2     := CLK_STOP;    -- Input Clock Source for the Timer
      FRR : Bits_1     := FRR_FREERUN; -- Free Run/Restart
      ORI : Boolean    := False;       -- Output Reference Interrupt Enable
      OM  : Bits_1     := OM_PULSE;    -- Output Mode
      CE  : Bits_2     := CE_DISABLE;  -- Capture Edge and Enable Interrupt
      PS  : Unsigned_8 := 0;           -- Prescaler Value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TMR_Type use record
      RST at 0 range 0 ..  0;
      CLK at 0 range 1 ..  2;
      FRR at 0 range 3 ..  3;
      ORI at 0 range 4 ..  4;
      OM  at 0 range 5 ..  5;
      CE  at 0 range 6 ..  7;
      PS  at 0 range 8 .. 15;
   end record;

   -- 13.4.1.5 TIMER EVENT REGISTER (TER)

   type TER_Type is record
      CAP      : Boolean := False; -- Capture Event
      REF      : Boolean := False; -- Output Reference Event
      Reserved : Bits_6  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TER_Type use record
      CAP      at 0 range 0 .. 0;
      REF      at 0 range 1 .. 1;
      Reserved at 0 range 2 .. 7;
   end record;

   -- 13.4.1 Understanding the General-Purpose Timer Registers

   type TIMER_Type is record
      TMR : TMR_Type    with Volatile_Full_Access => True;
      TRR : Unsigned_16 with Volatile_Full_Access => True;
      TCR : Unsigned_16 with Volatile_Full_Access => True;
      TCN : Unsigned_16 with Volatile_Full_Access => True;
      TER : TER_Type    with Volatile_Full_Access => True;
   end record
      with Size => 16#12# * 8;
   for TIMER_Type use record
      TMR at 16#00# range 0 .. 15;
      TRR at 16#04# range 0 .. 15;
      TCR at 16#08# range 0 .. 15;
      TCN at 16#0C# range 0 .. 15;
      TER at 16#11# range 0 ..  7;
   end record;

   TIMER1 : aliased TIMER_Type
      with Address    => System'To_Address (Configure.MBAR_VALUE + 16#100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   TIMER2 : aliased TIMER_Type
      with Address    => System'To_Address (Configure.MBAR_VALUE + 16#120#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

end MCF5206;
