-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cfperipherals.ads                                                                                         --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with LLutils;
with MMIO;

package CFPeripherals
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

   -- 11.4.1.1 MODE REGISTER 1 (UMR1)

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

   ERR_CHAR  : constant := 2#0#; -- Error Mode Character
   ERR_BLOCK : constant := 2#1#; -- Error Mode Block

   RxIRQ_RxRDY : constant := 2#0#; -- RxRDY is the source that generates IRQ
   RxIRQ_FFULL : constant := 2#1#; -- FFULL is the source that generates IRQ

   RxRTS_NONE  : constant := 2#0#; -- The receiver has no effect on /RTS
   RxRTS_FFULL : constant := 2#1#; -- On receipt of a valid start bit, RTS is negated if the UART FIFO is full

   type UMR1_Type is record
      BC    : Bits_2; -- Bits per Character
      PTPM  : Bits_3; -- Parity Type and Parity Mode
      ERR   : Bits_1; -- Error Mode
      RxIRQ : Bits_1; -- Receiver Interrupt Select
      RxRTS : Bits_1; -- Receiver Request-to-Send Control
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

   function To_U8 is new Ada.Unchecked_Conversion (UMR1_Type, Unsigned_8);
   function To_UMR1 is new Ada.Unchecked_Conversion (Unsigned_8, UMR1_Type);

   -- 11.4.1.2 MODE REGISTER 2 (UMR2)

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
      SB    : Bits_4;  -- Stop-Bit Length Control
      TxCTS : Boolean; -- Transmitter Clear-to-Send
      TxRTS : Boolean; -- Transmitter Ready-to-Send
      CM    : Bits_2;  -- Channel Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UMR2_Type use record
      SB    at 0 range 0 .. 3;
      TxCTS at 0 range 4 .. 4;
      TxRTS at 0 range 5 .. 5;
      CM    at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UMR2_Type, Unsigned_8);
   function To_UMR2 is new Ada.Unchecked_Conversion (Unsigned_8, UMR2_Type);

   -- 11.4.1.3 STATUS REGISTER (USR)

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

   function To_U8 is new Ada.Unchecked_Conversion (USR_Type, Unsigned_8);
   function To_USR is new Ada.Unchecked_Conversion (Unsigned_8, USR_Type);

   -- 11.4.1.4 CLOCK-SELECT REGISTER (UCSR)

   TCS_TIMER : constant := 2#1101#; -- TIMER
   TCS_EXT16 : constant := 2#1110#; -- Ext. clk. x 16
   TCS_EXT   : constant := 2#1111#; -- Ext. clk. x 1

   RCS_TIMER : constant := 2#1101#; -- TIMER
   RCS_EXT16 : constant := 2#1110#; -- Ext. clk. x 16
   RCS_EXT   : constant := 2#1111#; -- Ext. clk. x 1

   type UCSR_Type is record
      TCS : Bits_4; -- Transmitter Clock Select
      RCS : Bits_4; -- Receiver Clock Select
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UCSR_Type use record
      TCS at 0 range 0 .. 3;
      RCS at 0 range 4 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UCSR_Type, Unsigned_8);
   function To_UCSR is new Ada.Unchecked_Conversion (Unsigned_8, UCSR_Type);

   -- 11.4.1.5 COMMAND REGISTER (UCR)

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
      RC       : Bits_2; -- Receiver Commands
      TC       : Bits_2; -- Transmitter Commands
      MISC     : Bits_3; -- Miscellaneous Commands
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

   function To_U8 is new Ada.Unchecked_Conversion (UCR_Type, Unsigned_8);
   function To_UCR is new Ada.Unchecked_Conversion (Unsigned_8, UCR_Type);

   -- 11.4.1.8 INPUT PORT CHANGE REGISTER (UIPCR)

   type UIPCR_Type is record
      CTS       : Bits_1;           -- Current State
      Reserved1 : Bits_3 := 2#111#;
      COS       : Boolean;          -- Change-of-State
      Reserved2 : Bits_3 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UIPCR_Type use record
      CTS       at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 3;
      COS       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UIPCR_Type, Unsigned_8);
   function To_UIPCR is new Ada.Unchecked_Conversion (Unsigned_8, UIPCR_Type);

   -- 11.4.1.9 AUXILIARY CONTROL REGISTER (UACR)

   type UACR_Type is record
      IEC      : Boolean;     -- Input Enable Control
      Reserved : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UACR_Type use record
      IEC      at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UACR_Type, Unsigned_8);
   function To_UACR is new Ada.Unchecked_Conversion (Unsigned_8, UACR_Type);

   -- 11.4.1.10 INTERRUPT STATUS REGISTER (UISR)

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

   function To_U8 is new Ada.Unchecked_Conversion (UISR_Type, Unsigned_8);
   function To_UISR is new Ada.Unchecked_Conversion (Unsigned_8, UISR_Type);

   -- 11.4.1.11 INTERRUPT MASK REGISTER (UIMR)

   type UIMR_Type is record
      TxRDY    : Boolean;     -- Transmitter Ready
      FFULL    : Boolean;     -- FIFO Full
      DB       : Boolean;     -- Delta Break
      Reserved : Bits_4 := 0;
      COS      : Boolean;     -- Change-of-State
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

   function To_U8 is new Ada.Unchecked_Conversion (UIMR_Type, Unsigned_8);
   function To_UIMR is new Ada.Unchecked_Conversion (Unsigned_8, UIMR_Type);

   -- 11.4.1.14.1 Input Port Register (UIP)

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

   function To_U8 is new Ada.Unchecked_Conversion (UIP_Type, Unsigned_8);
   function To_UIP is new Ada.Unchecked_Conversion (Unsigned_8, UIP_Type);

   -- 11.4.1.14.2 Output Port Data Registers (UOP1, UOP0)

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

   function To_U8 is new Ada.Unchecked_Conversion (UOP_Type, Unsigned_8);
   function To_UOP is new Ada.Unchecked_Conversion (Unsigned_8, UOP_Type);

   ----------------------------------------------------------------------------
   -- SECTION 13 TIMER MODULE
   ----------------------------------------------------------------------------

   -- 13.4.1.1 TIMER MODE REGISTER (TMR)

   OM_PULSE  : constant := 0; -- Active-low pulse for one system clock cycle (30ns at 33 MHz)
   OM_TOGGLE : constant := 1; -- Toggle output

   type TMR_Type is record
      RST : Boolean;    -- Reset Timer
      CLK : Bits_2;     -- Input Clock Source for the Timer
      FRR : Boolean;    -- Free Run/Restart
      ORI : Boolean;    -- Output Reference Interrupt Enable
      OM  : Bits_1;     -- Output Mode
      CE  : Bits_2;     -- Capture Edge and Enable Interrupt
      PS  : Unsigned_8; -- Prescaler Value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TMR_Type use record
      RST at 0 range 0 .. 0;
      CLK at 0 range 1 .. 2;
      FRR at 0 range 3 .. 3;
      ORI at 0 range 4 .. 4;
      OM  at 0 range 5 .. 5;
      CE  at 0 range 6 .. 7;
      PS  at 0 range 8 .. 15;
   end record;

   -- 13.4.1.5 TIMER EVENT REGISTER (TER)

   type TER_Type is record
      CAP      : Boolean;     -- Capture Event
      REF      : Boolean;     -- Output Reference Event
      Reserved : Bits_6 := 0;
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
      TMR : TMR_Type;
      TRR : Unsigned_16;
      TCR : Unsigned_16;
      TCN : Unsigned_16;
      TER : TER_Type;
   end record
      with Size => 16#112# * 8;
   for TIMER_Type use record
      TMR at 16#100# range 0 .. 15;
      TRR at 16#104# range 0 .. 15;
      TCR at 16#108# range 0 .. 15;
      TCN at 16#10C# range 0 .. 15;
      TER at 16#111# range 0 .. 7;
   end record;

end CFPeripherals;
