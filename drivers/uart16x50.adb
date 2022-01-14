-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ uart16x50.adb                                                                                             --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Definitions;
with LLutils;

package body UART16x50 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use LLutils;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type Uart16x50_Register_Type is (RBR, IER, IIR, LCR, MCR, LSR, MSR, SCR, THR, DLL, DLM);
   for Uart16x50_Register_Type use (
                                    16#00#, -- RBR
                                    16#01#, -- IER
                                    16#02#, -- IIR
                                    16#03#, -- LCR
                                    16#04#, -- MCR
                                    16#05#, -- LSR
                                    16#06#, -- MSR
                                    16#07#, -- SCR
                                    16#10#, -- THR
                                    16#20#, -- DLL
                                    16#21#  -- DLM
                                   );

   -- 8.1 Line Control Register

   type Word_Length_Select_Type is new Bits_2;
   WORD_LENGTH_5 : constant Word_Length_Select_Type := 2#00#;
   WORD_LENGTH_6 : constant Word_Length_Select_Type := 2#01#;
   WORD_LENGTH_7 : constant Word_Length_Select_Type := 2#10#;
   WORD_LENGTH_8 : constant Word_Length_Select_Type := 2#11#;

   type Number_Of_Stop_Bits_Type is new Bits_1;
   STOP_BITS_1 : constant Number_Of_Stop_Bits_Type := 0;
   STOP_BITS_2 : constant Number_Of_Stop_Bits_Type := 1;

   type LCR_Type is
   record
      WLS  : Word_Length_Select_Type;
      STB  : Number_Of_Stop_Bits_Type;
      PEN  : Boolean;                  -- Parity Enable
      EPS  : Boolean;                  -- Even Parity Select
      SP   : Boolean;                  -- Stick Parity
      SB   : Boolean;                  -- Set Break
      DLAB : Boolean;                  -- Divisor Latch Access Bit
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for LCR_Type use
   record
      WLS  at 0 range 0 .. 1;
      STB  at 0 range 2 .. 2;
      PEN  at 0 range 3 .. 3;
      EPS  at 0 range 4 .. 4;
      SP   at 0 range 5 .. 5;
      SB   at 0 range 6 .. 6;
      DLAB at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (LCR_Type, Unsigned_8);
   function To_LCR is new Ada.Unchecked_Conversion (Unsigned_8, LCR_Type);

   -- 8.4 Line Status Register

   -- THR = Transmit Holding Register
   -- TSR = Transmit Shift Register
   -- THRE: When set it is possible to write another byte into the THR. The
   --       bit is set when the byte is transferred from the THR to the TSR.
   --       The bit is reset when the processor starts loading a byte into
   --       the THR.
   -- TSRE: When set indicates that the TSR is empty. It is reset when a word
   --       is loaded into it from the THR.
   type LSR_Type is
   record
      DR     : Boolean; -- Data Ready
      OE     : Boolean; -- Overrun Error
      PE     : Boolean; -- Parity Error
      FE     : Boolean; -- Framing Error
      BI     : Boolean; -- Break Interrupt
      THRE   : Boolean; -- Transmitter Holding Register Empty
      TEMT   : Boolean; -- Transmitter (Shift Register) Empty
      Unused : Bits_1_Zeroes := Bits_1_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for LSR_Type use
   record
      DR     at 0 range 0 .. 0;
      OE     at 0 range 1 .. 1;
      PE     at 0 range 2 .. 2;
      FE     at 0 range 3 .. 3;
      BI     at 0 range 4 .. 4;
      THRE   at 0 range 5 .. 5;
      TEMT   at 0 range 6 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (LSR_Type, Unsigned_8);
   function To_LSR is new Ada.Unchecked_Conversion (Unsigned_8, LSR_Type);

   -- 8.5 Interrupt Identification Register

   type Interrupt_Priority_Type is new Bits_2;

   IPL0 : constant Interrupt_Priority_Type := 2#00#; -- 4th:     MODEM Status
   IPL1 : constant Interrupt_Priority_Type := 2#01#; -- 3rd:     Transmitter Holding Register Empty
   IPL2 : constant Interrupt_Priority_Type := 2#10#; -- 2nd:     Received Data Available
   IPL3 : constant Interrupt_Priority_Type := 2#11#; -- highest: Receiver Line Status

   type IIR_Type is
   record
      IPn    : Boolean;                   -- negated: 0 if Interrupt Pending
      IPL    : Interrupt_Priority_Type;
      Unused : Bits_5_Zeroes := Bits_5_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for IIR_Type use
   record
      IPn    at 0 range 0 .. 0;
      IPL    at 0 range 1 .. 2;
      Unused at 0 range 3 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (IIR_Type, Unsigned_8);
   function To_IIR is new Ada.Unchecked_Conversion (Unsigned_8, IIR_Type);

   -- 8.6 Interrupt Enable Register

   type IER_Type is
   record
      RDA    : Boolean;                   -- Received Data Available
      THRE   : Boolean;                   -- Transmitter Holding Register Empty
      RLS    : Boolean;                   -- Receiver Line Status
      MS     : Boolean;                   -- MODEM Status
      Unused : Bits_4_Zeroes := Bits_4_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for IER_Type use
   record
      RDA    at 0 range 0 .. 0;
      THRE   at 0 range 1 .. 1;
      RLS    at 0 range 2 .. 2;
      MS     at 0 range 3 .. 3;
      Unused at 0 range 4 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (IER_Type, Unsigned_8);
   function To_IER is new Ada.Unchecked_Conversion (Unsigned_8, IER_Type);

   -- 8.7 Modem Control Register

   type MCR_Type is
   record
      DTR      : Boolean;                   -- Data Terminal Ready
      RTS      : Boolean;                   -- Request To Send
      OUT1     : Boolean;
      OUT2     : Boolean;
      LOOPBACK : Boolean;
      Unused   : Bits_3_Zeroes := Bits_3_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MCR_Type use
   record
      DTR      at 0 range 0 .. 0;
      RTS      at 0 range 1 .. 1;
      OUT1     at 0 range 2 .. 2;
      OUT2     at 0 range 3 .. 3;
      LOOPBACK at 0 range 4 .. 4;
      Unused   at 0 range 5 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (MCR_Type, Unsigned_8);
   function To_MCR is new Ada.Unchecked_Conversion (Unsigned_8, MCR_Type);

   -- 8.8 Modem Status Register

   type MSR_Type is
   record
      DCTS : Boolean; -- Delta CTS
      DDSR : Boolean; -- Delta DSR
      TERI : Boolean; -- Trailing Edge Ring Indicator
      DDCD : Boolean; -- Delta DCD
      CTS  : Boolean; -- CTS
      DSR  : Boolean; -- DSR
      RI   : Boolean; -- RI
      DCD  : Boolean; -- DCD
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for MSR_Type use
   record
      DCTS at 0 range 0 .. 0;
      DDSR at 0 range 1 .. 1;
      TERI at 0 range 2 .. 2;
      DDCD at 0 range 3 .. 3;
      CTS  at 0 range 4 .. 4;
      DSR  at 0 range 5 .. 5;
      RI   at 0 range 6 .. 6;
      DCD  at 0 range 7 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (MSR_Type, Unsigned_8);
   function To_MSR is new Ada.Unchecked_Conversion (Unsigned_8, MSR_Type);

   -- Local subprograms

   type Storage_Offset_Mod is mod 2**(Storage_Offset'Size - 1) with
      Size => Storage_Offset'Size;

   function To_SO is new Ada.Unchecked_Conversion (Storage_Offset_Mod, Storage_Offset);

   function Register_Read (
                           Descriptor : Uart16x50_Descriptor_Type;
                           Register   : Uart16x50_Register_Type
                          ) return Unsigned_8 with
      Inline => True;

   procedure Register_Write (
                             Descriptor : in Uart16x50_Descriptor_Type;
                             Register   : in Uart16x50_Register_Type;
                             Value      : in Unsigned_8
                            ) with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : Uart16x50_Descriptor_Type;
                           Register   : Uart16x50_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read_8 (Build_Address (
                                               Descriptor.Base_Address,
                                               To_SO (Uart16x50_Register_Type'Enum_Rep (Register) and 16#0F#),
                                               Descriptor.Scale_Address
                                              ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in Uart16x50_Descriptor_Type;
                             Register   : in Uart16x50_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write_8 (Build_Address (
                                         Descriptor.Base_Address,
                                         To_SO (Uart16x50_Register_Type'Enum_Rep (Register) and 16#0F#),
                                         Descriptor.Scale_Address
                                        ), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Set_Baud_Rate
   ----------------------------------------------------------------------------
   procedure Set_Baud_Rate (Descriptor : in Uart16x50_Descriptor_Type);
   procedure Set_Baud_Rate (Descriptor : in Uart16x50_Descriptor_Type) is
   begin
      null; -- __TBD__
   end Set_Baud_Rate;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (Descriptor : in out Uart16x50_Descriptor_Type) is
      -- __FIX__ stuck @ 9600
      BAUD_RATE : constant := Definitions.Baud_Rate_Type'Enum_Rep (Definitions.BR_9600);
      -- BAUD_RATE : constant := Definitions.Baud_Rate_Type'Enum_Rep (Definitions.BR_115200);
   begin
      -- __FIX__
      -- a lock should be used here, because, once DLAB is set, no other
      -- threads should interfere with this statement sequence
      Register_Write (Descriptor, LCR, To_U8 (LCR_Type'(
                              WLS  => 0,
                              STB  => 0,
                              PEN  => False,
                              EPS  => False,
                              SP   => False,
                              SB   => False,
                              DLAB => True
                             )));
      Register_Write (Descriptor, DLL, Unsigned_8 ((Descriptor.Baud_Clock / (BAUD_RATE * 16)) mod 2**8));
      Register_Write (Descriptor, DLM, Unsigned_8 ((Descriptor.Baud_Clock / (BAUD_RATE * 16)) / 2**8));
      Register_Write (Descriptor, LCR, To_U8 (LCR_Type'(
                              WLS  => WORD_LENGTH_8,
                              STB  => STOP_BITS_1,
                              PEN  => False,
                              EPS  => False,
                              SP   => False,
                              SB   => False,
                              DLAB => False
                             )));
      Register_Write (Descriptor, IER, To_U8 (IER_Type'(
                              RDA    => True,
                              THRE   => False,
                              RLS    => False,
                              MS     => False,
                              Unused => 0
                             )));
      Register_Write (Descriptor, MCR, To_U8 (MCR_Type'(
                              DTR      => True,
                              RTS      => True,
                              OUT1     => False,
                              OUT2     => True,
                              LOOPBACK => False,
                              Unused   => 0
                             )));
   end Init;

   ----------------------------------------------------------------------------
   -- Input_Poll
   ----------------------------------------------------------------------------
   procedure Input_Poll (
                         Descriptor : in  Uart16x50_Descriptor_Type;
                         Result     : out Unsigned_8;
                         Success    : out Boolean
                        );
   procedure Input_Poll (
                         Descriptor : in  Uart16x50_Descriptor_Type;
                         Result     : out Unsigned_8;
                         Success    : out Boolean
                        ) is
   begin
      Success := False;
      if To_LSR (Register_Read (Descriptor, LSR)).DR then
         Result := Register_Read (Descriptor, RBR);
         Success := True;
      end if;
   end Input_Poll;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX (Descriptor : in out Uart16x50_Descriptor_Type; Data : in Unsigned_8) is
   begin
      -- wait for transmitter buffer empty
      loop
         exit when To_LSR (Register_Read (Descriptor, LSR)).TEMT;
      end loop;
      Register_Write (Descriptor, THR, Data);
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX (Descriptor : in out Uart16x50_Descriptor_Type; Data : out Unsigned_8) is
      Success : Boolean with Unreferenced => True;
   begin
      -- wait for data available
      loop
         exit when To_LSR (Register_Read (Descriptor, LSR)).DR;
      end loop;
      Data := Register_Read (Descriptor, RBR);
      FIFO.Put (Descriptor.Data_Queue'Access, Data, Success);
   end RX;

   ----------------------------------------------------------------------------
   -- Receive
   ----------------------------------------------------------------------------
   procedure Receive (Descriptor_Address : in System.Address) is
      Descriptor : Uart16x50_Descriptor_Type with
         Address    => Descriptor_Address,
         Import     => True,
         Convention => Ada;
      Data       : Unsigned_8;
      Success    : Boolean with Unreferenced => True;
   begin
      -- wait for data available
      loop
         exit when To_LSR (Register_Read (Descriptor, LSR)).DR;
      end loop;
      Data := Register_Read (Descriptor, RBR);
      FIFO.Put (Descriptor.Data_Queue'Access, Data, Success);
   end Receive;

end UART16x50;
