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

package CFPeripherals is

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
   -- UART
   ----------------------------------------------------------------------------

   type UART_Register_Type is (
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
      (
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
      );

   type UART_Type is (UART1, UART2);
   for UART_Type use (
                      0,
                      16#40#
                     );

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

   type UMR1_Type is
   record
      BC    : Bits_2; -- Bits per Character
      PTPM  : Bits_3; -- Parity Type and Parity Mode
      ERR   : Bits_1; -- Error Mode
      RxIRQ : Bits_1; -- Receiver Interrupt Select
      RxRTS : Bits_1; -- Receiver Request-to-Send Control
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for UMR1_Type use
   record
      BC    at 0 range 0 .. 1;
      PTPM  at 0 range 2 .. 4;
      ERR   at 0 range 5 .. 5;
      RxIRQ at 0 range 6 .. 6;
      RxRTS at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UMR1_Type, Unsigned_8);
   function To_UMR1 is new Ada.Unchecked_Conversion (Unsigned_8, UMR1_Type);

   -- 11.4.1.2 MODE REGISTER 2 (UMR2)

   -- 11.4.1.3 STATUS REGISTER (USR)

   type USR_Type is
   record
      RxRDY : Boolean; -- Receiver Ready
      FFULL : Boolean; -- FIFO Full
      TxRDY : Boolean; -- Transmitter Ready
      TxEMP : Boolean; -- Transmitter Empty
      OE    : Boolean; -- Overrun Error
      PE    : Boolean; -- Parity Error
      FE    : Boolean; -- Framing Error
      RB    : Boolean; -- Received Break
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for USR_Type use
   record
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

   type UCR_Type is
   record
      RC     : Bits_2; -- Receiver Commands
      TC     : Bits_2; -- Transmitter Commands
      MISC   : Bits_3; -- Miscellaneous Commands
      Unused : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for UCR_Type use
   record
      RC     at 0 range 0 .. 1;
      TC     at 0 range 2 .. 3;
      MISC   at 0 range 4 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (UCR_Type, Unsigned_8);
   function To_UCR is new Ada.Unchecked_Conversion (Unsigned_8, UCR_Type);

   -- 11.4.1.8 INPUT PORT CHANGE REGISTER (UIPCR)

   -- 11.4.1.9 AUXILIARY CONTROL REGISTER (UACR)

   -- 11.4.1.10 INTERRUPT STATUS REGISTER (UISR)

   -- 11.4.1.11 INTERRUPT MASK REGISTER (UIMR)

   -- 11.4.1.12 TIMER UPPER PRELOAD REGISTER 1 (UBG1)

   -- 11.4.1.13 TIMER UPPER PRELOAD REGISTER 2 (UBG2)

   -- 11.4.1.14 INTERRUPT VECTOR REGISTER (UIVR)

   -- 11.4.1.14.1 Input Port Register (UIP)

   -- 11.4.1.14.2 Output Port Data Registers (UOP1, UOP0)

end CFPeripherals;
