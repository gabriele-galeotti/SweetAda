-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ scc.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Console;

package body SCC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;

   ----------------------------------------------------------------------------
   -- Zilog SCC/ESCC User Manual UM010903-0515
   ----------------------------------------------------------------------------

   type SCCZ8530_Register_Type is (RR0, WR3, WR4, WR5, WR11, RR12, WR12, RR13, WR13, WR14);

   SCCZ8530_Register_ID : constant array (SCCZ8530_Register_Type) of Unsigned_8 :=
      (
       RR0  => 0,  -- STATUS
       WR3  => 3,  -- W_RXCTRL
       WR4  => 4,
       WR5  => 5,  -- W_TXCTRL2
       WR11 => 11,
       RR12 => 12,
       WR12 => 12,
       RR13 => 13,
       WR13 => 13,
       WR14 => 14
      );

   ----------------------------------------------------------------------------
   -- Read Register 0 (Transmit/Receive Buffer Status and External Status)
   ----------------------------------------------------------------------------

   type RR0_Type is
   record
      Unused1 : Bits_2;
      TXBE    : Boolean;
      Unused2 : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RR0_Type use
   record
      Unused1 at 0 range 0 .. 1;
      TXBE    at 0 range 2 .. 2;
      Unused2 at 0 range 3 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Write Register 0 (Command Register)
   ----------------------------------------------------------------------------

   CRC_RESET_NULL : constant := 2#00#;
   CRC_RESET_RX   : constant := 2#01#;
   CRC_RESET_TX   : constant := 2#10#;
   CRC_RESET_EOM  : constant := 2#11#;

   CMD_NULL              : constant := 2#000#;
   CMD_POINT_HIGH        : constant := 2#001#;
   CMD_RESET_EXT         : constant := 2#010#;
   CMD_SEND_ABORT        : constant := 2#011#;
   CMD_ENABLE_INT        : constant := 2#100#;
   CMD_RESET_TX_INT      : constant := 2#101#;
   CMD_ERROR_RESET       : constant := 2#110#;
   CMD_RESET_HIGHEST_IUS : constant := 2#111#;

   type WR0_Type is
   record
      RN        : Bits_3; -- Register Selection Code
      CMD_Code  : Bits_3; -- Command Codes
      CRC_Reset : Bits_2; -- CRC Reset Codes 1 And 0
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for WR0_Type use
   record
      RN        at 0 range 0 .. 2;
      CMD_Code  at 0 range 3 .. 5;
      CRC_Reset at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Write Register 1 (Transmit/Receive Interrupt and Data Transfer Mode Definition)
   ----------------------------------------------------------------------------

   RxINT_DISAB : constant := 2#00#; -- Receive Interrupts Disabled
   RxINT_FCERR : constant := 2#01#; -- Receive Interrupt on First Character or Special Condition
   INT_ALL_Rx  : constant := 2#10#; -- Interrupt on All Receive Characters or Special Condition
   INT_ERR_Rx  : constant := 2#11#; -- Receive Interrupt on Special Condition

   type WR1_Type is
   record
      EXT_INT_ENAB : Boolean; -- External/Status Master Interrupt Enable
      Tx_INT_ENAB  : Boolean; -- Transmitter Interrupt Enable
      PAR_SPEC     : Boolean; -- Parity is special condition
      Rx_INT_Modes : Bits_2;  -- Receive Interrupt Modes
      WT_RDY_RT    : Boolean; -- /WAIT//REQUEST on Transmit or Receive
      WT_FN_RDYFN  : Boolean; -- WAIT/DMA Request Function
      WT_RDY_ENAB  : Boolean; -- WAIT/DMA Request Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for WR1_Type use
   record
      EXT_INT_ENAB at 0 range 0 .. 0;
      Tx_INT_ENAB  at 0 range 1 .. 1;
      PAR_SPEC     at 0 range 2 .. 2;
      Rx_INT_Modes at 0 range 3 .. 4;
      WT_RDY_RT    at 0 range 5 .. 5;
      WT_FN_RDYFN  at 0 range 6 .. 6;
      WT_RDY_ENAB  at 0 range 7 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Write Register 2 (Interrupt Vector)
   ----------------------------------------------------------------------------

   -- register type is Unsigned_8

   ----------------------------------------------------------------------------
   -- Write Register 3 (Receive Parameters and Control)
   ----------------------------------------------------------------------------

   Rx_LENGTH_5 : constant := 2#00#;
   Rx_LENGTH_7 : constant := 2#01#;
   Rx_LENGTH_6 : constant := 2#10#;
   Rx_LENGTH_8 : constant := 2#11#;

   type WR3_Type is
   record
      Rx_Enable     : Boolean; -- Receiver Enable
      SYNC_L_INH    : Boolean; -- SYNC Character Load Inhibit
      ADD_SM        : Boolean; -- Address Search Mode (SDLC)
      Rx_CRC_Enable : Boolean; -- Receiver CRC Enable
      ENT_HM        : Boolean; -- Enter Hunt Mode
      Auto_Enables  : Boolean; -- Auto Enables
      RxN           : Bits_2;  -- Receiver Bits/Character
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for WR3_Type use
   record
      RX_Enable     at 0 range 0 .. 0;
      SYNC_L_INH    at 0 range 1 .. 1;
      ADD_SM        at 0 range 2 .. 2;
      Rx_CRC_Enable at 0 range 3 .. 3;
      ENT_HM        at 0 range 4 .. 4;
      Auto_Enables  at 0 range 5 .. 5;
      RxN           at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Write Register 4 (Transmit/Receive Miscellaneous Parameters and Modes)
   ----------------------------------------------------------------------------

   SYNC_ENAB : constant := 2#00#; -- Sync Modes Enable
   SB1       : constant := 2#01#; -- 1 Stop Bit/Character
   SB15      : constant := 2#10#; -- 1 1/2 Stop Bits/Character
   SB2       : constant := 2#11#; -- 2 Stop Bits/Character

   MONOSYNC : constant := 2#00#; -- 8-Bit Sync Character
   BISYNC   : constant := 2#01#; -- 16-Bit Sync Character
   SDLC     : constant := 2#10#; -- SDLC Mode (01111110 Flag)
   EXTSYNC  : constant := 2#11#; -- External Sync Mode

   X1CLK  : constant := 2#00#; -- X1 Clock Mode
   X16CLK : constant := 2#01#; -- X16 Clock Mode
   X32CLK : constant := 2#10#; -- X32 Clock Mode
   X64CLK : constant := 2#11#; -- X64 Clock Mode

   type WR4_Type is
   record
      PAR_ENAB   : Boolean; -- Parity Enable
      PAR_EVEN   : Boolean; -- Parity Even/Odd
      STOP_BITS  : Bits_2;  -- Stop Bits selection, bits 1 and 0
      SYNC_MODES : Bits_2;  -- SYNC Mode selection bits 1 and 0
      XCLK_RATE  : Bits_2;  -- Clock Rate bits 1 and 0
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for WR4_Type use
   record
      PAR_ENAB   at 0 range 0 .. 0;
      PAR_EVEN   at 0 range 1 .. 1;
      STOP_BITS  at 0 range 2 .. 3;
      SYNC_MODES at 0 range 4 .. 5;
      XCLK_RATE  at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Write Register 5 (Transmit Parameters and Controls)
   ----------------------------------------------------------------------------

   Tx_LENGTH_5 : constant := 2#00#;
   Tx_LENGTH_6 : constant := 2#10#;
   Tx_LENGTH_7 : constant := 2#01#;
   Tx_LENGTH_8 : constant := 2#11#;

   type WR5_Type is
   record
      Tx_CRC_Enable : Boolean;
      RTS           : Boolean;
      nSDLC_CRC16   : Boolean;
      Tx_Enable     : Boolean;
      Send_Break    : Boolean;
      TxN           : Bits_2;
      DTR           : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for WR5_Type use
   record
      Tx_CRC_Enable at 0 range 0 .. 0;
      RTS           at 0 range 1 .. 1;
      nSDLC_CRC16   at 0 range 2 .. 2;
      Tx_Enable     at 0 range 3 .. 3;
      Send_Break    at 0 range 4 .. 4;
      TxN           at 0 range 5 .. 6;
      DTR           at 0 range 7 .. 7;
   end record;

   procedure SCCZ8530_Create_Ports (
                                    Descriptor : in out SCCZ8530_Descriptor_Type;
                                    Channel    : in     SCCZ8530_Channel_Type
                                   );

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Local Subprograms (generic)
   ----------------------------------------------------------------------------

   generic
      Register_Type : in SCCZ8530_Register_Type;
      type Output_Register_Type is private;
   function Typed_Register_Read (
                                 Descriptor : SCCZ8530_Descriptor_Type;
                                 Channel    : SCCZ8530_Channel_Type
                                ) return Output_Register_Type;
   pragma Inline (Typed_Register_Read);
   function Typed_Register_Read (
                                 Descriptor : SCCZ8530_Descriptor_Type;
                                 Channel    : SCCZ8530_Channel_Type
                                ) return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_8, Output_Register_Type);
   begin
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), SCCZ8530_Register_ID (Register_Type));
      return Convert (Descriptor.Read_8 (Descriptor.Control_Port (Channel)));
   end Typed_Register_Read;

   generic
      Register_Type : in SCCZ8530_Register_Type;
      type Input_Register_Type is private;
   procedure Typed_Register_Write (
                                   Descriptor : in SCCZ8530_Descriptor_Type;
                                   Channel    : in SCCZ8530_Channel_Type;
                                   Value      : in Input_Register_Type
                                  );
   pragma Inline (Typed_Register_Write);
   procedure Typed_Register_Write (
                                   Descriptor : in SCCZ8530_Descriptor_Type;
                                   Channel    : in SCCZ8530_Channel_Type;
                                   Value      : in Input_Register_Type
                                  ) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_8);
   begin
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), SCCZ8530_Register_ID (Register_Type));
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), Convert (Value));
   end Typed_Register_Write;

   ----------------------------------------------------------------------------
   -- Instantiation of generics
   ----------------------------------------------------------------------------

   function RR0_Read is new Typed_Register_Read (RR0, RR0_Type);
   pragma Inline (RR0_Read);
   procedure WR3_Write is new Typed_Register_Write (WR3, WR3_Type);
   pragma Inline (WR3_Write);
   procedure WR4_Write is new Typed_Register_Write (WR4, WR4_Type);
   pragma Inline (WR4_Write);
   procedure WR5_Write is new Typed_Register_Write (WR5, WR5_Type);
   pragma Inline (WR5_Write);
   procedure WR11_Write is new Typed_Register_Write (WR11, Unsigned_8);
   pragma Inline (WR11_Write);
   procedure WR12_Write is new Typed_Register_Write (WR12, Unsigned_8);
   pragma Inline (WR12_Write);
   procedure WR13_Write is new Typed_Register_Write (WR13, Unsigned_8);
   pragma Inline (WR13_Write);
   procedure WR14_Write is new Typed_Register_Write (WR14, Unsigned_8);
   pragma Inline (WR14_Write);

   ----------------------------------------------------------------------------
   -- SCCZ8530_Create_Ports
   ----------------------------------------------------------------------------
   -- There exist various hardware decoding styles when using the Z8530, e.g.:
   -- 1) COMPUTER LOGICS PC/XT ISA board
   --   A0 --> A//B
   --   A1 --> D//C
   -- 2) SPARCStation 5
   --   A1 --> D//C
   --   A2 --> A//B
   -- 3) DECstation 5000/133
   --   A2 --> D//C
   --   A3 --> A//B
   ----------------------------------------------------------------------------
   procedure SCCZ8530_Create_Ports (
                                    Descriptor : in out SCCZ8530_Descriptor_Type;
                                    Channel    : in     SCCZ8530_Channel_Type
                                   ) is
      Base_Address : Address := Descriptor.Base_Address;
   begin
      if Descriptor.Flags.DECstation5000133 then
         Base_Address := Base_Address + 1;
      end if;
      if Channel = CHANNELA then
         Base_Address := Base_Address + 2**Descriptor.AB_Address_Bit;
      end if;
      Descriptor.Control_Port (Channel) := Base_Address;
      Descriptor.Data_Port (Channel)    := Base_Address + 2**Descriptor.CD_Address_Bit;
   end SCCZ8530_Create_Ports;

   ----------------------------------------------------------------------------
   -- Set_Baud_Rate
   ----------------------------------------------------------------------------
   -- Initializing the BRG is done in three steps. First, the time constant is
   -- determined and loaded into WR12 and WR13. Next, the processor must
   -- select the clock source for the BRG by setting bit D1 of WR14. Finally,
   -- the BRG is enabled by setting bit D0 of WR14 to 1.
   ----------------------------------------------------------------------------
   procedure Set_Baud_Rate (
                            Descriptor : in SCCZ8530_Descriptor_Type;
                            Channel    : in SCCZ8530_Channel_Type;
                            Baud_Rate  : in Definitions.Baud_Rate_Type
                           ) is
      Unused        : Unsigned_8 with Unreferenced => True;
      BR            : constant Integer := Definitions.Baud_Rate_Type'Enum_Rep (Baud_Rate);
      Time_Constant : Unsigned_16;
   begin
      -- reset register pointer
      Unused := Descriptor.Read_8 (Descriptor.Control_Port (Channel));
      -- compute time constant
      Time_Constant := Unsigned_16 ((Descriptor.Baud_Clock + BR * 16) / (2 * BR * 16) - 2);
      WR12_Write (Descriptor, Channel, LByte (Time_Constant));
      WR13_Write (Descriptor, Channel, HByte (Time_Constant));
      -- enable BRG
      WR14_Write (Descriptor, Channel, Unsigned_8'(2#00000010#));
      WR14_Write (Descriptor, Channel, Unsigned_8'(2#00000010#) or 1);
   end Set_Baud_Rate;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (
                   Descriptor : in out SCCZ8530_Descriptor_Type;
                   Channel    : in     SCCZ8530_Channel_Type
                  ) is
      Unused : Unsigned_8 with Unreferenced => True;
   begin
      SCCZ8530_Create_Ports (Descriptor, Channel);
      -- reset register pointer
      Unused := Descriptor.Read_8 (Descriptor.Control_Port (Channel));
      -- select BR Generator Output source = PCLK
      WR11_Write (Descriptor, Channel, Unsigned_8'(2#01010010#));
      Set_Baud_Rate (Descriptor, Channel, Definitions.BR_9600);
      -- X16 Clock Mode, External Sync Mode, 1 Stop Bit/Character, Parity
      -- EVEN, Parity not Enable
      WR4_Write (Descriptor, Channel, (
                                       PAR_ENAB   => False,
                                       PAR_EVEN   => True,
                                       STOP_BITS  => SB1,
                                       SYNC_MODES => EXTSYNC,
                                       XCLK_RATE  => X16CLK
                                      ));
      -- Rx 8 Bits/Character, Rx Enable
      WR3_Write (Descriptor, Channel, (
                                       Rx_Enable     => True,
                                       SYNC_L_INH    => False,
                                       ADD_SM        => False,
                                       Rx_CRC_Enable => False,
                                       ENT_HM        => False,
                                       Auto_Enables  => False,
                                       RxN           => Rx_LENGTH_8
                                      ));
      -- Tx 8 Bits/Character, Tx Enable
      WR5_Write (Descriptor, Channel, (
                                       Tx_CRC_Enable => False,
                                       RTS           => False,
                                       nSDLC_CRC16   => False,
                                       Tx_Enable     => True,
                                       Send_Break    => False,
                                       TxN           => Tx_LENGTH_8,
                                       DTR           => False
                                      ));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX (
                 Descriptor : in SCCZ8530_Descriptor_Type;
                 Channel    : in SCCZ8530_Channel_Type;
                 Data       : in Unsigned_8
                ) is
   begin
      -- wait for TX Buffer Empty
      loop
         exit when RR0_Read (Descriptor, Channel).TXBE;
      end loop;
      if Descriptor.Flags.MVME162FX_TX_Quirk then
         -- MVME162FX MC2 revision 1 bug
         Descriptor.Write_8 (Descriptor.Control_Port (Channel), 16#08#);
         Descriptor.Write_8 (Descriptor.Control_Port (Channel), Data);
      else
         Descriptor.Write_8 (Descriptor.Data_Port (Channel), Data);
      end if;
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX (
                 Descriptor : in  SCCZ8530_Descriptor_Type;
                 Channel    : in  SCCZ8530_Channel_Type;
                 Data       : out Unsigned_8
                ) is
      pragma Unreferenced (Descriptor);
      pragma Unreferenced (Channel);
   begin
      -- __TBD__
      Data := 0;
   end RX;

end SCC;
