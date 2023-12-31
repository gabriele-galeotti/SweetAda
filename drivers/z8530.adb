-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ z8530.adb                                                                                                 --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;

package body Z8530
   is

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

   type Register_Type is
      (
       WR0, WR1, WR2, WR3, WR4, WR5, WR6, WR7, WR8, WR9, WR10, WR11, WR12, WR13, WR14, WR15,
       RR0, RR1, RR2, RR3, RR4, RR5, RR6, RR7, RR8, RR9, RR10, RR11, RR12, RR13, RR14, RR15
      );

   Register_ID : constant array (Register_Type) of Unsigned_8 :=
      [
       WR0  => 0,  RR0  => 0,
       WR1  => 1,  RR1  => 1,
       WR2  => 2,  RR2  => 2,
       WR3  => 3,  RR3  => 3,
       WR4  => 4,  RR4  => 4,
       WR5  => 5,  RR5  => 5,
       WR6  => 6,  RR6  => 6,
       WR7  => 7,  RR7  => 7,
       WR8  => 8,  RR8  => 8,
       WR9  => 9,  RR9  => 9,
       WR10 => 10, RR10 => 10,
       WR11 => 11, RR11 => 11,
       WR12 => 12, RR12 => 12,
       WR13 => 13, RR13 => 13,
       WR14 => 14, RR14 => 14,
       WR15 => 15, RR15 => 15
      ];

   ----------------------------------------------------------------------------
   -- 5.2.1 Write Register 0 (Command Register)
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

   type WR0_Type is record
      RN        : Bits_3; -- Register Selection Code
      CMD_Code  : Bits_3; -- Command Codes
      CRC_Reset : Bits_2; -- CRC Reset Codes 1 And 0
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR0_Type use record
      RN        at 0 range 0 .. 2;
      CMD_Code  at 0 range 3 .. 5;
      CRC_Reset at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR0_Type, Unsigned_8);
   function To_WR0 is new Ada.Unchecked_Conversion (Unsigned_8, WR0_Type);

   ----------------------------------------------------------------------------
   -- 5.2.2 Write Register 1 (Transmit/Receive Interrupt and Data Transfer Mode Definition)
   ----------------------------------------------------------------------------

   RxINT_DISAB : constant := 2#00#; -- Receive Interrupts Disabled
   RxINT_FCERR : constant := 2#01#; -- Receive Interrupt on First Character or Special Condition
   INT_ALL_Rx  : constant := 2#10#; -- Interrupt on All Receive Characters or Special Condition
   INT_ERR_Rx  : constant := 2#11#; -- Receive Interrupt on Special Condition

   type WR1_Type is record
      EXT_INT_ENAB : Boolean; -- External/Status Master Interrupt Enable
      Tx_INT_ENAB  : Boolean; -- Transmitter Interrupt Enable
      PAR_SPEC     : Boolean; -- Parity is special condition
      Rx_INT_Modes : Bits_2;  -- Receive Interrupt Modes
      WT_RDY_RT    : Boolean; -- /WAIT//REQUEST on Transmit or Receive
      WT_FN_RDYFN  : Boolean; -- WAIT/DMA Request Function
      WT_RDY_ENAB  : Boolean; -- WAIT/DMA Request Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR1_Type use record
      EXT_INT_ENAB at 0 range 0 .. 0;
      Tx_INT_ENAB  at 0 range 1 .. 1;
      PAR_SPEC     at 0 range 2 .. 2;
      Rx_INT_Modes at 0 range 3 .. 4;
      WT_RDY_RT    at 0 range 5 .. 5;
      WT_FN_RDYFN  at 0 range 6 .. 6;
      WT_RDY_ENAB  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR1_Type, Unsigned_8);
   function To_WR1 is new Ada.Unchecked_Conversion (Unsigned_8, WR1_Type);

   ----------------------------------------------------------------------------
   -- 5.2.3 Write Register 2 (Interrupt Vector)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.4 Write Register 3 (Receive Parameters and Control)
   ----------------------------------------------------------------------------

   Rx_LENGTH_5 : constant := 2#00#;
   Rx_LENGTH_7 : constant := 2#01#;
   Rx_LENGTH_6 : constant := 2#10#;
   Rx_LENGTH_8 : constant := 2#11#;

   type WR3_Type is record
      Rx_Enable     : Boolean; -- Receiver Enable
      SYNC_L_INH    : Boolean; -- SYNC Character Load Inhibit
      ADD_SM        : Boolean; -- Address Search Mode (SDLC)
      Rx_CRC_Enable : Boolean; -- Receiver CRC Enable
      ENT_HM        : Boolean; -- Enter Hunt Mode
      Auto_Enables  : Boolean; -- Auto Enables
      RxN           : Bits_2;  -- Receiver Bits/Character
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR3_Type use record
      Rx_Enable     at 0 range 0 .. 0;
      SYNC_L_INH    at 0 range 1 .. 1;
      ADD_SM        at 0 range 2 .. 2;
      Rx_CRC_Enable at 0 range 3 .. 3;
      ENT_HM        at 0 range 4 .. 4;
      Auto_Enables  at 0 range 5 .. 5;
      RxN           at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR3_Type, Unsigned_8);
   function To_WR3 is new Ada.Unchecked_Conversion (Unsigned_8, WR3_Type);

   ----------------------------------------------------------------------------
   -- 5.2.5 Write Register 4 (Transmit/Receive Miscellaneous Parameters and Modes)
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

   type WR4_Type is record
      PAR_ENAB   : Boolean; -- Parity Enable
      PAR_EVEN   : Boolean; -- Parity Even/Odd
      STOP_BITS  : Bits_2;  -- Stop Bits selection, bits 1 and 0
      SYNC_MODES : Bits_2;  -- SYNC Mode selection bits 1 and 0
      XCLK_RATE  : Bits_2;  -- Clock Rate bits 1 and 0
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR4_Type use record
      PAR_ENAB   at 0 range 0 .. 0;
      PAR_EVEN   at 0 range 1 .. 1;
      STOP_BITS  at 0 range 2 .. 3;
      SYNC_MODES at 0 range 4 .. 5;
      XCLK_RATE  at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR4_Type, Unsigned_8);
   function To_WR4 is new Ada.Unchecked_Conversion (Unsigned_8, WR4_Type);

   ----------------------------------------------------------------------------
   -- 5.2.6 Write Register 5 (Transmit Parameters and Controls)
   ----------------------------------------------------------------------------

   Tx_LENGTH_5 : constant := 2#00#;
   Tx_LENGTH_6 : constant := 2#10#;
   Tx_LENGTH_7 : constant := 2#01#;
   Tx_LENGTH_8 : constant := 2#11#;

   type WR5_Type is record
      Tx_CRC_Enable : Boolean; -- Transmit CRC Enable
      RTS           : Boolean; -- Request To Send control bit
      nSDLC_CRC16   : Boolean; -- /SDLC/CRC-16
      Tx_Enable     : Boolean; -- Transmit Enable
      Send_Break    : Boolean; -- Send Break control bit
      TxN           : Bits_2;  -- Transmit Bits/Character select bits 1 and 0
      DTR           : Boolean; -- Data Terminal Ready control bit
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR5_Type use record
      Tx_CRC_Enable at 0 range 0 .. 0;
      RTS           at 0 range 1 .. 1;
      nSDLC_CRC16   at 0 range 2 .. 2;
      Tx_Enable     at 0 range 3 .. 3;
      Send_Break    at 0 range 4 .. 4;
      TxN           at 0 range 5 .. 6;
      DTR           at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR5_Type, Unsigned_8);
   function To_WR5 is new Ada.Unchecked_Conversion (Unsigned_8, WR5_Type);

   ----------------------------------------------------------------------------
   -- 5.2.7 Write Register 6 (Sync Characters or SDLC Address Field)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.8 Write Register 7 (Sync Character or SDLC Flag)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.9 Write Register 7 Prime (ESCC only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.10 Write Register 7 Prime (85C30 only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.11 Write Register 8 (Transmit Buffer)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.12 Write Register 9 (Master Interrupt Control)
   ----------------------------------------------------------------------------

   RESCMD_NONE : constant := 2#00#; -- No Reset
   RESCMD_CHB  : constant := 2#01#; -- Channel Reset B
   RESCMD_CHA  : constant := 2#10#; -- Channel Reset A
   RESCMD_RES  : constant := 2#11#; -- Force Hardware Reset

   type WR9_Type is record
      VIS    : Boolean; -- Vector Includes Status control bit
      NV     : Boolean; -- No Vector select bit
      DLC    : Boolean; -- Disable Lower Chain control bit
      MIE    : Boolean; -- Master Interrupt Enable
      SHnSL  : Boolean; -- Status High//Status Low control bit
      INTACK : Boolean; -- Software Interrupt Acknowledge control bit
      RESCMD : Bits_2;  -- Reset Command Bits
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR9_Type use record
      VIS    at 0 range 0 .. 0;
      NV     at 0 range 1 .. 1;
      DLC    at 0 range 2 .. 2;
      MIE    at 0 range 3 .. 3;
      SHnSL  at 0 range 4 .. 4;
      INTACK at 0 range 5 .. 5;
      RESCMD at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR9_Type, Unsigned_8);
   function To_WR9 is new Ada.Unchecked_Conversion (Unsigned_8, WR9_Type);

   ----------------------------------------------------------------------------
   -- 5.2.13 Write Register 10 (Miscellaneous Transmitter/Receiver Control Bits)
   ----------------------------------------------------------------------------

   DataEncoding_NRZ  : constant := 2#00#; -- NRZ
   DataEncoding_NRZI : constant := 2#01#; -- NRZI
   DataEncoding_FM1  : constant := 2#10#; -- FM1 (transition = 1)
   DataEncoding_FM0  : constant := 2#11#; -- FM0 (transition = 0)

   type WR10_Type is record
      SYNC6OR8           : Boolean; -- 6-Bit/8-Bit SYNC select bit
      Loop_Mode          : Boolean; -- Loop Mode control bit
      AbortFlag_Underrun : Boolean; -- Abort//Flag On Underrun select bit
      MarkFlag_Idle      : Boolean; -- Mark//Flag Idle line control bit
      GoActiveOnPoll     : Boolean; -- Go-Active-On-Poll control bit
      DataEncoding       : Bits_2;  -- Data Encoding select bits.
      CRCPreset          : Boolean; -- CRC Presets I/O select bit
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR10_Type use record
      SYNC6OR8           at 0 range 0 .. 0;
      Loop_Mode          at 0 range 1 .. 1;
      AbortFlag_Underrun at 0 range 2 .. 2;
      MarkFlag_Idle      at 0 range 3 .. 3;
      GoActiveOnPoll     at 0 range 4 .. 4;
      DataEncoding       at 0 range 5 .. 6;
      CRCPreset          at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR10_Type, Unsigned_8);
   function To_WR10 is new Ada.Unchecked_Conversion (Unsigned_8, WR10_Type);

   ----------------------------------------------------------------------------
   -- 5.2.14 Write Register 11 (Clock Mode Control)
   ----------------------------------------------------------------------------

   nTRxC_XTAL : constant := 2#00#; -- XTAL Oscillator Output
   nTRxC_Tx   : constant := 2#01#; -- Transmit Clock
   nTRxC_BR   : constant := 2#10#; -- BR Output
   nTRxC_DPLL : constant := 2#11#; -- DPLL Output (receive)

   TRxC_IO_IN  : constant := 0; -- /TRxC pin is also an input if this bit is set to 0.
   TRxC_IO_OUT : constant := 1; -- /TRxC pin is an output and carries the signal selected by D1 and D0 of this register.

   TxCLK_nRTxC : constant := 2#00#; -- /RTxC Pin
   TxCLK_nTRxC : constant := 2#01#; -- /TRxC Pin
   TxCLK_BR    : constant := 2#10#; -- BR Output
   TxCLK_DPLL  : constant := 2#11#; -- DPLL Output

   RxCLK_nRTxC : constant := 2#00#; -- /RTxC Pin
   RxCLK_nTRxC : constant := 2#01#; -- /TRxC Pin
   RxCLK_BR    : constant := 2#10#; -- BR Output
   RxCLK_DPLL  : constant := 2#11#; -- DPLL Output

   RTxC_XTAL_TTL  : constant := 0; -- SCC expects a TTL-compatible signal as an input to this pin.
   RTxC_XTAL_XTAL : constant := 1; -- SCC connects a HGA between the /RTxC and /SYNC pins in expectation of a XTAL.

   type WR11_Type is record
      nTRxC     : Bits_2; -- /TRxC Output Source select bits 1 and 0
      TRxC_IO   : Bits_1; -- TRxC Pin I/O control bit
      TxCLK     : Bits_2; -- Transmit Clock select bits 1 and 0.
      RxCLK     : Bits_2; -- Receiver Clock select bits 1 and 0
      RTxC_XTAL : Bits_1; -- RTxC-XTAL//NO XTAL select bit
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR11_Type use record
      nTRxC     at 0 range 0 .. 1;
      TRxC_IO   at 0 range 2 .. 2;
      TxCLK     at 0 range 3 .. 4;
      RxCLK     at 0 range 5 .. 6;
      RTxC_XTAL at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR11_Type, Unsigned_8);
   function To_WR11 is new Ada.Unchecked_Conversion (Unsigned_8, WR11_Type);

   ----------------------------------------------------------------------------
   -- 5.2.15 Write Register 12 (Lower Byte of Baud Rate Generator Time Constant)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.16 Write Register 13 (Upper Byte of Baud Rate Generator Time Constant)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.2.17 Write Register 14 (Miscellaneous Control Bits)
   ----------------------------------------------------------------------------

   BRSOURCE_nRTxC_XTAL : constant := 0; -- The BRG clock comes from either the /RTxC pin or the XTAL oscillator. *(XTAL//no XTAL)
   BRSOURCE_PCLK       : constant := 1; -- The clock for the BRG is the SCC’s PCLK input.

   DPLL_CMD_NULL    : constant := 2#000#; -- Null Command
   DPLL_CMD_SEARCH  : constant := 2#001#; -- Enter Search Mode
   DPLL_CMD_RMC     : constant := 2#010#; -- Reset Missing Clock
   DPLL_CMD_DISABLE : constant := 2#011#; -- Disable DPLL
   DPLL_CMD_BR      : constant := 2#100#; -- Set Source = BR Generator
   DPLL_CMD_nRTxC   : constant := 2#101#; -- Set Source = /RTxC
   DPLL_CMD_FM      : constant := 2#110#; -- Set FM Mode
   DPLL_CMD_NRZI    : constant := 2#111#; -- Set NRZI Mode

   type WR14_Type is record
      BREN         : Boolean; -- Baud Rate Generator Enable
      BRSOURCE     : Bits_1;  -- Baud Rate Generator Source select bit
      DTR_Function : Boolean; -- DTR/Request Function select bit
      AUTOECHO     : Boolean; -- Auto Echo select bit
      Loc_LOOPBACK : Boolean; -- Local Loopback select bit
      DPLL_CMD     : Bits_3;  -- Digital Phase-Locked Loop Command Bits.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR14_Type use record
      BREN         at 0 range 0 .. 0;
      BRSOURCE     at 0 range 1 .. 1;
      DTR_Function at 0 range 2 .. 2;
      AUTOECHO     at 0 range 3 .. 3;
      Loc_LOOPBACK at 0 range 4 .. 4;
      DPLL_CMD     at 0 range 5 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR14_Type, Unsigned_8);
   function To_WR14 is new Ada.Unchecked_Conversion (Unsigned_8, WR14_Type);

   ----------------------------------------------------------------------------
   -- 5.2.18 Write Register 15 (External/Status Interrupt Control)
   ----------------------------------------------------------------------------

   type WR15_Type is record
      SDLCFeatureEnable : Boolean := False; -- Point to Write Register WR7 Prime (ESCC and 85C30 only)
      ZeroCountIE       : Boolean := False; -- Zero Count Interrupt Enable
      SDLCFIFOEnable    : Boolean := False; -- Status FIFO Enable control bit (CMOS/ESCC)
      DCDIE             : Boolean := False; -- DCD Interrupt Enable
      SyncHuntIE        : Boolean := False; -- SYNC/Hunt Interrupt Enable
      CTSIE             : Boolean := False; -- CTS Interrupt Enable
      TxUnderrunEOMIE   : Boolean := False; -- Transmit Underrun/EOM Interrupt Enable
      BreakAbortIE      : Boolean := False; -- Break/Abort Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WR15_Type use record
      SDLCFeatureEnable at 0 range 0 .. 0;
      ZeroCountIE       at 0 range 1 .. 1;
      SDLCFIFOEnable    at 0 range 2 .. 2;
      DCDIE             at 0 range 3 .. 3;
      SyncHuntIE        at 0 range 4 .. 4;
      CTSIE             at 0 range 5 .. 5;
      TxUnderrunEOMIE   at 0 range 6 .. 6;
      BreakAbortIE      at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (WR15_Type, Unsigned_8);
   function To_WR15 is new Ada.Unchecked_Conversion (Unsigned_8, WR15_Type);

   ----------------------------------------------------------------------------
   -- 5.3.1 Read Register 0 (Transmit/Receive Buffer Status and External Status)
   ----------------------------------------------------------------------------

   type RR0_Type is record
      RXCA       : Boolean; -- Receive Character Available
      Zero_Count : Boolean; -- Zero Count status
      TXBE       : Boolean; -- TX Buffer Empty status
      DCD        : Boolean; -- Data Carrier Detect status
      SyncHunt   : Boolean; -- Sync/Hunt status
      CTS        : Boolean; -- Clear to Send pin status
      TXUR_EOM   : Boolean; -- Transmit Underrun/EOM status
      BreakAbort : Boolean; -- Break/Abort status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR0_Type use record
      RXCA       at 0 range 0 .. 0;
      Zero_Count at 0 range 1 .. 1;
      TXBE       at 0 range 2 .. 2;
      DCD        at 0 range 3 .. 3;
      SyncHunt   at 0 range 4 .. 4;
      CTS        at 0 range 5 .. 5;
      TXUR_EOM   at 0 range 6 .. 6;
      BreakAbort at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR0_Type, Unsigned_8);
   function To_RR0 is new Ada.Unchecked_Conversion (Unsigned_8, RR0_Type);

   ----------------------------------------------------------------------------
   -- 5.3.2 Read Register 1
   ----------------------------------------------------------------------------

   ResidueCode_28 : constant := 2#000#; -- I-Field Bits in Last Byte = 2, I-Field Bits in Previous Byte = 8
   ResidueCode_06 : constant := 2#001#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 6
   ResidueCode_04 : constant := 2#010#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 4
   ResidueCode_08 : constant := 2#011#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 8
   ResidueCode_03 : constant := 2#100#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 3
   ResidueCode_07 : constant := 2#101#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 7
   ResidueCode_05 : constant := 2#110#; -- I-Field Bits in Last Byte = 0, I-Field Bits in Previous Byte = 5
   ResidueCode_18 : constant := 2#111#; -- I-Field Bits in Last Byte = 1, I-Field Bits in Previous Byte = 8

   type RR1_Type is record
      AllSent         : Boolean; -- Bit 0: All Sent status
      ResidueCode     : Bits_3;  -- Residue Codes, bits 2, 1, and 0
      ParityError     : Boolean; -- Parity Error status.
      RxOverrunError  : Boolean; -- Receiver Overrun Error status
      CRCFramingError : Boolean; -- CRC/Framing Error status
      SDLCEndOfFrame  : Boolean; -- End of Frame (SDLC) status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR1_Type use record
      AllSent         at 0 range 0 .. 0;
      ResidueCode     at 0 range 1 .. 3;
      ParityError     at 0 range 4 .. 4;
      RxOverrunError  at 0 range 5 .. 5;
      CRCFramingError at 0 range 6 .. 6;
      SDLCEndOfFrame  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR1_Type, Unsigned_8);
   function To_RR1 is new Ada.Unchecked_Conversion (Unsigned_8, RR1_Type);

   ----------------------------------------------------------------------------
   -- 5.3.3 Read Register 2
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.4 Read Register 3
   ----------------------------------------------------------------------------

   type RR3_Type is record
      Unused        : Bits_2;
      CHA_RX        : Boolean; -- Channel A Rx IP
      CHA_TX        : Boolean; -- Channel A Tx IP
      CHA_ExtStatus : Boolean; -- Channel A Ext/Status IP
      CHB_RX        : Boolean; -- Channel B Rx IP
      CHB_TX        : Boolean; -- Channel B Tx IP
      CHB_ExtStatus : Boolean; -- Channel B Ext/Status IP
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR3_Type use record
      Unused        at 0 range 0 .. 1;
      CHA_RX        at 0 range 2 .. 2;
      CHA_TX        at 0 range 3 .. 3;
      CHA_ExtStatus at 0 range 4 .. 4;
      CHB_RX        at 0 range 5 .. 5;
      CHB_TX        at 0 range 6 .. 6;
      CHB_ExtStatus at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR3_Type, Unsigned_8);
   function To_RR3 is new Ada.Unchecked_Conversion (Unsigned_8, RR3_Type);

   ----------------------------------------------------------------------------
   -- 5.3.5 Read Register 4 (ESCC and 85C30 Only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.6 Read Register 5 (ESCC and 85C30 Only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.7 Read Register 6 (Not on NMOS)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.8 Read Register 7 (Not on NMOS)
   ----------------------------------------------------------------------------

   type RR7_Type is record
      BC06 : Bits_6;  -- most significant six bits of the frame byte count that is currently at the top of the Status FIFO
      FDA  : Boolean; -- FIFO Data Available
      FOS  : Boolean; -- FIFO Overflow Status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR7_Type use record
      BC06 at 0 range 0 .. 5;
      FDA  at 0 range 6 .. 6;
      FOS  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR7_Type, Unsigned_8);
   function To_RR7 is new Ada.Unchecked_Conversion (Unsigned_8, RR7_Type);

   ----------------------------------------------------------------------------
   -- 5.3.9 Read Register 8
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.10 Read Register 9 (ESCC and 85C30 Only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.11 Read Register 10
   ----------------------------------------------------------------------------

   type RR10_Type is record
      Unused1         : Bits_1;
      OnLoop          : Boolean; -- On Loop status
      Unused2         : Bits_2;
      LoopSending     : Boolean; -- Loop Sending status
      Unused3         : Bits_1;
      TwoClockMissing : Boolean; -- Two Clocks Missing status
      OneClockMissing : Boolean; -- One Clock Missing status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR10_Type use record
      Unused1         at 0 range 0 .. 0;
      OnLoop          at 0 range 1 .. 1;
      Unused2         at 0 range 2 .. 3;
      LoopSending     at 0 range 4 .. 4;
      Unused3         at 0 range 5 .. 5;
      TwoClockMissing at 0 range 6 .. 6;
      OneClockMissing at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR10_Type, Unsigned_8);
   function To_RR10 is new Ada.Unchecked_Conversion (Unsigned_8, RR10_Type);

   ----------------------------------------------------------------------------
   -- 5.3.12 Read Register 11 (ESCC and 85C30 Only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.13 Read Register 12
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.14 Read Register 13
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.15 Read Register 14 (ESCC and 85C30 Only)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 5.3.16 Read Register 15
   ----------------------------------------------------------------------------

   type RR15_Type is record
      Unused1         : Bits_1;
      ZeroCountIE     : Boolean; -- Zero Count Interrupt Enable
      Unused2         : Bits_1;
      DCDIE           : Boolean; -- DCD Interrupt Enable
      SyncHuntIE      : Boolean; -- SYNC/Hunt Interrupt Enable
      CTSIE           : Boolean; -- CTS Interrupt Enable
      TxUnderrunEOMIE : Boolean; -- Transmit Underrun/EOM Interrupt Enable
      BreakAbortIE    : Boolean; -- Break/Abort Interrupt Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for RR15_Type use record
      Unused1         at 0 range 0 .. 0;
      ZeroCountIE     at 0 range 1 .. 1;
      Unused2         at 0 range 2 .. 2;
      DCDIE           at 0 range 3 .. 3;
      SyncHuntIE      at 0 range 4 .. 4;
      CTSIE           at 0 range 5 .. 5;
      TxUnderrunEOMIE at 0 range 6 .. 6;
      BreakAbortIE    at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (RR15_Type, Unsigned_8);
   function To_RR15 is new Ada.Unchecked_Conversion (Unsigned_8, RR15_Type);

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   procedure Create_Ports
      (Descriptor : in out Descriptor_Type;
       Channel    : in     Channel_Type);

   function Register_Read
      (Descriptor : Descriptor_Type;
       Channel    : Channel_Type;
       Register   : Register_Type)
      return Unsigned_8
      with Inline => True;

   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Channel    : in Channel_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_8)
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Create_Ports
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
   procedure Create_Ports
      (Descriptor : in out Descriptor_Type;
       Channel    : in     Channel_Type)
      is
      Base_Address : Address := Descriptor.Base_Address;
   begin
      if Descriptor.Flags.DECstation5000133 then
         Base_Address := @ + 1;
      end if;
      if Channel = CHANNELA then
         Base_Address := @ + 2**Descriptor.AB_Address_Bit;
      end if;
      Descriptor.Control_Port (Channel) := Base_Address;
      Descriptor.Data_Port (Channel)    := Base_Address + 2**Descriptor.CD_Address_Bit;
   end Create_Ports;

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read
      (Descriptor : Descriptor_Type;
       Channel    : Channel_Type;
       Register   : Register_Type)
      return Unsigned_8
      is
   begin
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), Register_ID (Register));
      return Descriptor.Read_8 (Descriptor.Control_Port (Channel));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Channel    : in Channel_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_8)
      is
   begin
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), Register_ID (Register));
      Descriptor.Write_8 (Descriptor.Control_Port (Channel), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Baud_Rate_Set
   ----------------------------------------------------------------------------
   -- Initializing the BRG is done in three steps. First, the time constant is
   -- determined and loaded into WR12 and WR13. Next, the processor must
   -- select the clock source for the BRG by setting bit D1 of WR14. Finally,
   -- the BRG is enabled by setting bit D0 of WR14 to 1.
   ----------------------------------------------------------------------------
   procedure Baud_Rate_Set
      (Descriptor : in Descriptor_Type;
       Channel    : in Channel_Type;
       Baud_Rate  : in Definitions.Baud_Rate_Type)
      is
      Unused        : Unsigned_8 with Unreferenced => True;
      BR            : constant Integer := Definitions.Baud_Rate_Type'Enum_Rep (Baud_Rate);
      Time_Constant : Unsigned_16;
      R             : WR14_Type;
   begin
      -- reset register pointer
      Unused := Descriptor.Read_8 (Descriptor.Control_Port (Channel));
      -- compute time constant
      Time_Constant := Unsigned_16 ((Descriptor.Baud_Clock + BR * 16) / (2 * BR * 16) - 2);
      Register_Write (Descriptor, Channel, WR12, LByte (Time_Constant));
      Register_Write (Descriptor, Channel, WR13, HByte (Time_Constant));
      -- initialize WR14
      R := (
         BREN         => False,
         BRSOURCE     => BRSOURCE_PCLK,
         DTR_Function => False,
         AUTOECHO     => False,
         Loc_LOOPBACK => False,
         DPLL_CMD     => DPLL_CMD_NULL
         );
      Register_Write (Descriptor, Channel, WR14, To_U8 (R));
      -- enable BRG
      R.BREN := True;
      Register_Write (Descriptor, Channel, WR14, To_U8 (R));
   end Baud_Rate_Set;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (Descriptor : in out Descriptor_Type;
       Channel    : in     Channel_Type)
      is
      Unused : Unsigned_8 with Unreferenced => True;
   begin
      Create_Ports (Descriptor, Channel);
      -- reset register pointer
      Unused := Descriptor.Read_8 (Descriptor.Control_Port (Channel));
      -- Master Interrupt Enable
      Register_Write (Descriptor, Channel, WR9, To_U8 (WR9_Type'(
         VIS    => False,
         NV     => True,
         DLC    => False,
         MIE    => True,
         SHnSL  => False,
         INTACK => False,
         RESCMD => RESCMD_NONE
         )));
      -- select BR Generator Output source = PCLK
      Register_Write (Descriptor, Channel, WR11, To_U8 (WR11_Type'(
         nTRxC     => nTRxC_BR,
         TRxC_IO   => TRxC_IO_IN,
         TxCLK     => TxCLK_BR,
         RxCLK     => RxCLK_BR,
         RTxC_XTAL => RTxC_XTAL_TTL
         )));
      Baud_Rate_Set (Descriptor, Channel, Definitions.BR_9600);
      -- X16 Clock Mode, Monosync Mode, 1 Stop Bit/Character, Parity
      -- EVEN, Parity not Enable
      Register_Write (Descriptor, Channel, WR4, To_U8 (WR4_Type'(
         PAR_ENAB   => False,
         PAR_EVEN   => True,
         STOP_BITS  => SB1,
         SYNC_MODES => MONOSYNC,
         XCLK_RATE  => X16CLK
         )));
      -- Rx 8 Bits/Character, Rx Enable
      Register_Write (Descriptor, Channel, WR3, To_U8 (WR3_Type'(
         Rx_Enable     => True,
         SYNC_L_INH    => False,
         ADD_SM        => False,
         Rx_CRC_Enable => False,
         ENT_HM        => False,
         Auto_Enables  => False,
         RxN           => Rx_LENGTH_8
         )));
      -- Tx 8 Bits/Character, Tx Enable
      Register_Write (Descriptor, Channel, WR5, To_U8 (WR5_Type'(
         Tx_CRC_Enable => False,
         RTS           => False,
         nSDLC_CRC16   => False,
         Tx_Enable     => True,
         Send_Break    => False,
         TxN           => Tx_LENGTH_8,
         DTR           => False
         )));
      -- disable RX interrupt
      Register_Write (Descriptor, Channel, WR1, To_U8 (WR1_Type'(
         EXT_INT_ENAB => True,
         Tx_INT_ENAB  => False,
         PAR_SPEC     => False,
         Rx_INT_Modes => RxINT_DISAB,
         WT_RDY_RT    => False,
         WT_FN_RDYFN  => False,
         WT_RDY_ENAB  => False
         )));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX
      (Descriptor : in Descriptor_Type;
       Channel    : in Channel_Type;
       Data       : in Unsigned_8)
      is
   begin
      -- wait for transmitter available
      loop
         exit when To_RR0 (Register_Read (Descriptor, Channel, RR0)).TXBE;
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
   procedure RX
      (Descriptor : in  Descriptor_Type;
       Channel    : in  Channel_Type;
       Data       : out Unsigned_8)
      is
   begin
      -- wait for receiver available
      loop
         exit when To_RR0 (Register_Read (Descriptor, Channel, RR0)).RXCA;
      end loop;
      Data := Descriptor.Read_8 (Descriptor.Data_Port (Channel));
   end RX;

end Z8530;
