-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdbstub.adb                                                                                               --
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
with Bits;
with LLutils;
with Gdbstub.CPU;
with Console;

package body Gdbstub is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use LLutils;
   use Gdbstub.CPU;

   type Packet_Source_Type is (HOST, STUB);

   RESPONSE_OK    : constant String := "OK";
   RESPONSE_ERROR : constant String := "E00";

   RX_Character            : Getchar_Ptr;
   TX_Character            : Putchar_Ptr;
   Breakpoint_Startup_Flag : Boolean := False;
   Single_Stepping         : Boolean := False;
   Debug_Mode              : Debug_Mode_Type := DEBUG_NONE;

   procedure Packet_Dump (
                          Packet_Source : in Packet_Source_Type;
                          Packet_String : in String;
                          Packet_Length : in Natural
                         );
   procedure RX_Packet;
   procedure TX_Packet;
   procedure TX_Packet_Copy_Response (Response : in String);
   procedure Read_Next_Character (C : out Character; Success : out Boolean);
   procedure Read_Digit (Result : out Unsigned_8; Success : out Boolean);
   procedure Parse_SimpleValue (Result : out Natural; Success : out Boolean);
   procedure Parse_Byte (Result : out Unsigned_8; Success : out Boolean);
   procedure Parse_IAddress (Result : out Integer_Address; Success : out Boolean);
   procedure Notify_Halt_Reason;
   procedure Handle_Continue (Exit_Flag : in out Boolean);
   procedure Handle_Set_Thread;
   procedure Handle_Kill_Request;
   procedure Handle_General_Registers_Read;
   procedure Handle_General_Registers_Write;
   procedure Handle_Memory_Read;
   procedure Handle_Memory_Write;
   procedure Handle_Register_Read;
   procedure Handle_Register_Write;
   procedure Handle_General_Query;
   procedure Handle_General_Set;
   procedure Handle_Restart (Exit_Flag : in out Boolean);
   procedure Handle_Step (Exit_Flag : in out Boolean);
   procedure Handle_Multi_Letter_Packets;
   procedure Command_Loop;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Byte_Text
   ----------------------------------------------------------------------------
   -- Create a textual, all-lowercase byte value.
   ----------------------------------------------------------------------------
   procedure Byte_Text (Value : in Unsigned_8; Packet : in out Byte_Text_Type) is
   begin
      U8_To_HexDigit (Value => Value, MSD => True, LCase => True, C => Packet (1));
      U8_To_HexDigit (Value => Value, MSD => False, LCase => True, C => Packet (2));
   end Byte_Text;

   ----------------------------------------------------------------------------
   -- Packet_Dump
   ----------------------------------------------------------------------------
   procedure Packet_Dump (
                          Packet_Source : in Packet_Source_Type;
                          Packet_String : in String;
                          Packet_Length : in Natural
                         ) is
      Prefix : String (1 .. 6);
   begin
      case Packet_Source is
         when HOST => Prefix := "HOST: ";
         when STUB => Prefix := "STUB: ";
      end case;
      Console.Print (Prefix);
      if Packet_Length /= 0 then
         declare
            Idx_Start : constant Integer := Packet_String'First;
            Idx_End   : constant Integer := Packet_String'First + Packet_Length - 1;
         begin
            Console.Print (Packet_String (Idx_Start .. Idx_End));
         end;
      end if;
      Console.Print_NewLine;
   end Packet_Dump;

   ----------------------------------------------------------------------------
   -- RX_Packet
   ----------------------------------------------------------------------------
   -- $<data>#<checksum>
   -- NOTE: RX_Packet cannot exit until it has received a well-formed packet,
   --       so RX_Packet_Length cannot be undefined
   ----------------------------------------------------------------------------
   procedure RX_Packet is
      type RX_Status_Type is (WAIT_PACKET_START, RX_CHARACTERS, RX_CHECKSUM1, RX_CHECKSUM2);
      RX_Status            : RX_Status_Type;
      Index                : Positive := 1;
      RX_Packet_Checksum   : Unsigned_8 := 0;
      RX_Computed_Checksum : Unsigned_8 := 0;
      C                    : Character;
      C_Is_HexDigit        : Boolean;
   begin
      RX_Status := WAIT_PACKET_START;
      loop
         RX_Character.all (C);
         case RX_Status is
            -------------------------
            when WAIT_PACKET_START =>
               if C = '$' then
                  RX_Packet_Length := 0;
                  Index := 1;
                  RX_Packet_Checksum := 0;
                  RX_Computed_Checksum := 0;
                  RX_Status := RX_CHARACTERS;
               else
                  null; -- discard RXed character
               end if;
            ---------------------
            when RX_CHARACTERS =>
               if C = '#' then
                  RX_Status := RX_CHECKSUM1;
               elsif C = '$' then
                  RX_Packet_Length := 0;
                  Index := 1;
                  RX_Computed_Checksum := 0;
                  Notify_Packet_Error ("rxed packet out of sync");
               elsif Index > RX_Packet_Buffer'Last then
                  TX_Character.all ('-');
                  Notify_Packet_Error ("rxed packet too long");
                  RX_Status := WAIT_PACKET_START;
               else
                  RX_Packet_Length := RX_Packet_Length + 1;
                  RX_Packet_Buffer (Index) := C;
                  Index := Index + 1;
                  RX_Computed_Checksum := RX_Computed_Checksum + To_U8 (C);
               end if;
            --------------------
            when RX_CHECKSUM1 =>
               HexDigit_To_U8 (C => C, MSD => True, Value => RX_Packet_Checksum, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  RX_Status := RX_CHECKSUM2;
               else
                  TX_Character.all ('-');
                  Notify_Packet_Error ("rxed packet checksum error");
                  RX_Status := WAIT_PACKET_START;
               end if;
            --------------------
            when RX_CHECKSUM2 =>
               HexDigit_To_U8 (C => C, MSD => False, Value => RX_Packet_Checksum, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  if RX_Packet_Checksum = RX_Computed_Checksum then
                     TX_Character.all ('+');
                     exit;
                  end if;
               end if;
               TX_Character.all ('-');
               Notify_Packet_Error ("rxed packet checksum error");
               RX_Status := WAIT_PACKET_START;
         end case;
      end loop;
      if Debug_Mode >= DEBUG_COMMUNICATION then
         Packet_Dump (HOST, RX_Packet_Buffer, RX_Packet_Length);
      end if;
   end RX_Packet;

   ----------------------------------------------------------------------------
   -- TX_Packet
   ----------------------------------------------------------------------------
   procedure TX_Packet is
      TX_Packet_Length   : Natural;
      TX_Packet_Checksum : Unsigned_8;
      Response           : Character;
      C                  : Character;
      Checksum_Text      : Byte_Text_Type;
   begin
      TX_Packet_Length := TX_Packet_Index;
      loop
         TX_Character.all ('$');
         TX_Packet_Checksum := 0;
         for Index in 1 .. TX_Packet_Length loop
            C := TX_Packet_Buffer (Index);
            TX_Character.all (C);
            TX_Packet_Checksum := TX_Packet_Checksum + To_U8 (C);
         end loop;
         TX_Character.all ('#');
         Byte_Text (TX_Packet_Checksum, Checksum_Text);
         TX_Character.all (Checksum_Text (1));
         TX_Character.all (Checksum_Text (2));
         RX_Character.all (Response);
         exit when Response = '+';
      end loop;
      if Debug_Mode >= DEBUG_COMMUNICATION then
         Packet_Dump (STUB, TX_Packet_Buffer, TX_Packet_Length);
      end if;
   end TX_Packet;

   ----------------------------------------------------------------------------
   -- TX_Packet_Copy_Response
   ----------------------------------------------------------------------------
   procedure TX_Packet_Copy_Response (Response : in String) is
      Response_Length : constant Integer := Response'Length;
   begin
      if Response_Length <= TX_Packet_Buffer'Last then
         TX_Packet_Buffer (1 .. Response_Length) := Response (Response'First .. Response'Last);
         TX_Packet_Index := Response_Length;
      else
         Notify_Packet_Error ("tx packet too long");
      end if;
   end TX_Packet_Copy_Response;

   ----------------------------------------------------------------------------
   -- Read_Next_Character
   ----------------------------------------------------------------------------
   -- Return, if success, the character pointed to by Packet_Index.
   -- Packet_Index is incremented and points to the next character.
   ----------------------------------------------------------------------------
   procedure Read_Next_Character (C : out Character; Success : out Boolean) is
   begin
      C := Character'Val (0);
      if RX_Packet_Index <= RX_Packet_Length then
         C := RX_Packet_Buffer (RX_Packet_Index);
         RX_Packet_Index := RX_Packet_Index + 1;
         Success := True;
      else
         Success := False;
      end if;
   end Read_Next_Character;

   ----------------------------------------------------------------------------
   -- Read_Digit
   ----------------------------------------------------------------------------
   -- Read a digit with lookahead
   ----------------------------------------------------------------------------
   procedure Read_Digit (Result : out Unsigned_8; Success : out Boolean) is
      C : Character;
   begin
      Result := 0;
      Read_Next_Character (C, Success);
      if Success then
         HexDigit_To_U8 (C => C, MSD => False, Value => Result, Success => Success);
         if not Success then
            -- rewind by 1 character
            RX_Packet_Index := RX_Packet_Index - 1;
         end if;
      end if;
   end Read_Digit;

   ----------------------------------------------------------------------------
   -- Parse_SimpleValue
   ----------------------------------------------------------------------------
   procedure Parse_SimpleValue (Result : out Natural; Success : out Boolean) is
      MDigits : constant Natural := (Natural'Size + 3) / 4; -- maximum # of digits for a base16 number
      NDigits : Natural;
      Digit   : Unsigned_8;
      C_Is_Ok : Boolean;
   begin
      Result := 0;
      NDigits := 0;
      while NDigits < MDigits loop
         Read_Digit (Digit, C_Is_Ok);
         exit when not C_Is_Ok;
         Result := Result * 2**4 + Natural (Digit);
         NDigits := NDigits + 1;
      end loop;
      if NDigits > 0 then
         Success := True;
      else
         Success := False;
      end if;
   end Parse_SimpleValue;

   ----------------------------------------------------------------------------
   -- Parse_Byte
   ----------------------------------------------------------------------------
   procedure Parse_Byte (Result : out Unsigned_8; Success : out Boolean) is
      NDigits : Natural;
      Digit   : Unsigned_8;
      C_Is_Ok : Boolean;
   begin
      Result := 0;
      NDigits := 0;
      for Index in 1 .. 2 loop
         Read_Digit (Digit, C_Is_Ok);
         exit when not C_Is_Ok;
         Result := Result * 2**4 + Digit;
         NDigits := NDigits + 1;
      end loop;
      if NDigits = 2 then
         Success := True;
      else
         Success := False;
      end if;
   end Parse_Byte;

   ----------------------------------------------------------------------------
   -- Parse_IAddress
   ----------------------------------------------------------------------------
   procedure Parse_IAddress (Result : out Integer_Address; Success : out Boolean) is
      MDigits : constant Natural := (Integer_Address'Size + 3) / 4; -- maximum # of digits for a base16 number
      NDigits : Natural;
      Digit   : Unsigned_8;
      C_Is_Ok : Boolean;
   begin
      Result := 0;
      NDigits := 0;
      while NDigits < MDigits loop
         Read_Digit (Digit, C_Is_Ok);
         exit when not C_Is_Ok;
         Result := Result * 2**4 + Integer_Address (Digit);
         NDigits := NDigits + 1;
      end loop;
      if NDigits > 0 then
         Success := True;
      else
         Success := False;
      end if;
   end Parse_IAddress;

   ----------------------------------------------------------------------------
   -- Notify_Packet_Error
   ----------------------------------------------------------------------------
   procedure Notify_Packet_Error (Error_Message : in String) is
   begin
      Console.Print (Error_Message, NL => True);
   end Notify_Packet_Error;

   ----------------------------------------------------------------------------
   -- Notify_Halt_Reason
   ----------------------------------------------------------------------------
   -- "?"
   -- Indicate the reason why the target halted.
   ----------------------------------------------------------------------------
   procedure Notify_Halt_Reason is
   begin
      -- TX_Packet_Copy_Response ("T__thread:__;");
      -- TX_Packet_Buffer (2 .. 3)   := "05"; -- GDB TRAP signal
      -- TX_Packet_Buffer (11 .. 12) := "01"; -- thread #1 __FIX__ hardwired
      TX_Packet_Copy_Response ("S00");
      TX_Packet;
   end Notify_Halt_Reason;

   ----------------------------------------------------------------------------
   -- Handle_Continue
   ----------------------------------------------------------------------------
   -- "c [addr]"
   -- Continue at addr, which is the address to resume.
   ----------------------------------------------------------------------------
   procedure Handle_Continue (Exit_Flag : in out Boolean) is
   begin
      Exit_Flag := True;
   end Handle_Continue;

   ----------------------------------------------------------------------------
   -- Handle_General_Registers_Read
   ----------------------------------------------------------------------------
   -- "g"
   -- Read general registers.
   ----------------------------------------------------------------------------
   procedure Handle_General_Registers_Read is
   begin
      Registers_Read;
      TX_Packet;
   end Handle_General_Registers_Read;

   ----------------------------------------------------------------------------
   -- Handle_General_Registers_Write
   ----------------------------------------------------------------------------
   -- "G XX..."
   -- Write general registers.
   ----------------------------------------------------------------------------
   procedure Handle_General_Registers_Write is
   begin
      null;
   end Handle_General_Registers_Write;

   ----------------------------------------------------------------------------
   -- Handle_Set_Thread
   ----------------------------------------------------------------------------
   -- "H op thread-id"
   -- Set thread for subsequent operations.
   ----------------------------------------------------------------------------
   procedure Handle_Set_Thread is
      C             : Character;
      Success       : Boolean;
      Thread_Number : Natural;
   begin
      RX_Packet_Index := 2;
      Read_Next_Character (C, Success);
      if Success then
         case C is
            when 'c' | 'g' =>
               Parse_SimpleValue (Thread_Number, Success);
            when others    =>
               Success := False;
         end case;
      end if;
      if Success then
         TX_Packet_Copy_Response (RESPONSE_OK);
      else
         TX_Packet_Copy_Response (RESPONSE_ERROR);
      end if;
      TX_Packet;
   end Handle_Set_Thread;

   ----------------------------------------------------------------------------
   -- Handle_Kill_Request
   ----------------------------------------------------------------------------
   -- "k"
   -- Kill request.
   ----------------------------------------------------------------------------
   procedure Handle_Kill_Request is
   begin
      null; -- system remains in wait-for-packet state
   end Handle_Kill_Request;

   ----------------------------------------------------------------------------
   -- Handle_Memory_Read
   ----------------------------------------------------------------------------
   -- "m addr,length"
   -- Read length addressable memory units starting at address addr.
   -- reply : <memorycontents>/EXX
   ----------------------------------------------------------------------------
   procedure Handle_Memory_Read is
      type HMR_Status_Type is (PARSE_ADDRESS, CHECK_COMMA, PARSE_LENGTH);
      HMR_Status     : HMR_Status_Type;
      Success        : Boolean;
      Memory_Address : Integer_Address;
      C              : Character;
      Memory_Length  : Natural;
   begin
      RX_Packet_Index := 2;
      HMR_Status := PARSE_ADDRESS;
      loop
         case HMR_Status is
            ---------------------
            when PARSE_ADDRESS =>
               Parse_IAddress (Memory_Address, Success);
               exit when not Success;
               HMR_Status := CHECK_COMMA;
            -------------------
            when CHECK_COMMA =>
               Read_Next_Character (C, Success);
               exit when not Success;
               if C /= ',' then
                  Success := False;
                  exit;
               end if;
               HMR_Status := PARSE_LENGTH;
            --------------------
            when PARSE_LENGTH =>
               Parse_SimpleValue (Memory_Length, Success);
               exit;
         end case;
      end loop;
      if Success then
         for Index in 0 .. Storage_Offset (Memory_Length - 1) loop
            declare
               Value      : aliased Unsigned_8 with
                  Address    => To_Address (Memory_Address) + Index,
                  Volatile   => True,
                  Import     => True,
                  Convention => Ada;
               Digit1_Idx : constant Integer := TX_Packet_Index + 1;
               Digit2_Idx : constant Integer := TX_Packet_Index + 2;
            begin
               Byte_Text (Value, TX_Packet_Buffer (Digit1_Idx .. Digit2_Idx));
               TX_Packet_Index := Digit2_Idx;
            end;
         end loop;
         TX_Packet;
      end if;
   end Handle_Memory_Read;

   ----------------------------------------------------------------------------
   -- Handle_Memory_Write
   ----------------------------------------------------------------------------
   -- "M addr,length:XX..."
   -- Write length addressable memory units starting at address addr.
   ----------------------------------------------------------------------------
   procedure Handle_Memory_Write is
      type HMW_Status_Type is (
                               PARSE_ADDRESS,
                               CHECK_COMMA,
                               PARSE_LENGTH,
                               CHECK_COLON,
                               PARSE_MEMORY_BYTES
                              );
      HMW_Status     : HMW_Status_Type;
      Success        : Boolean;
      Memory_Address : Integer_Address := 0;
      C              : Character;
      Memory_Length  : Natural := 0;
      Byte_Value     : Unsigned_8;
   begin
      RX_Packet_Index := 2;
      HMW_Status := PARSE_ADDRESS;
      loop
         case HMW_Status is
            ---------------------
            when PARSE_ADDRESS =>
               Parse_IAddress (Memory_Address, Success);
               exit when not Success;
               HMW_Status := CHECK_COMMA;
            -------------------
            when CHECK_COMMA =>
               Read_Next_Character (C, Success);
               exit when not Success;
               if C /= ',' then
                  Success := False;
                  exit;
               end if;
               HMW_Status := PARSE_LENGTH;
            --------------------
            when PARSE_LENGTH =>
               Parse_SimpleValue (Memory_Length, Success);
               exit when not Success;
               HMW_Status := CHECK_COLON;
            -------------------
            when CHECK_COLON =>
               Read_Next_Character (C, Success);
               exit when not Success;
               if C /= ':' then
                  Success := False;
                  exit;
               end if;
               HMW_Status := PARSE_MEMORY_BYTES;
            --------------------------
            -- __FIX__ properly handling of memory writes
            when PARSE_MEMORY_BYTES =>
               for Index in 0 .. Storage_Offset (Memory_Length - 1) loop
                  declare
                     Value : aliased Unsigned_8 with
                        Address    => To_Address (Memory_Address) + Index,
                        Volatile   => True,
                        Import     => True,
                        Convention => Ada;
                  begin
                     Parse_Byte (Byte_Value, Success);
                     exit when not Success;
                     Value := Byte_Value;
                  end;
               end loop;
               exit;
         end case;
      end loop;
      if Success then
         TX_Packet_Copy_Response (RESPONSE_OK);
      else
         TX_Packet_Copy_Response (RESPONSE_ERROR);
      end if;
      TX_Packet;
   end Handle_Memory_Write;

   ----------------------------------------------------------------------------
   -- Handle_Register_Read
   ----------------------------------------------------------------------------
   -- "p n"
   -- Read the value of register n.
   ----------------------------------------------------------------------------
   procedure Handle_Register_Read is
      Success         : Boolean;
      Register_Number : Natural;
   begin
      RX_Packet_Index := 2;
      Parse_SimpleValue (Register_Number, Success);
      if Success then
         Register_Read (Register_Number);
      else
         TX_Packet_Copy_Response (RESPONSE_ERROR);
      end if;
      TX_Packet;
   end Handle_Register_Read;

   ----------------------------------------------------------------------------
   -- Handle_Register_Write
   ----------------------------------------------------------------------------
   -- "P n...=r..."
   -- Write register n... with value r....
   ----------------------------------------------------------------------------
   procedure Handle_Register_Write is
      type HRW_Status_Type is (PARSE_REGISTER, CHECK_EQUAL, PARSE_HEX_VALUE);
      HRW_Status      : HRW_Status_Type;
      Success         : Boolean;
      Register_Number : Natural := 0;
      Register_Value  : Byte_Array (0 .. 15);
      Byte_Count      : Natural;
      Byte_Value      : Unsigned_8;
      C               : Character;
   begin
      RX_Packet_Index := 2;
      HRW_Status := PARSE_REGISTER;
      loop
         case HRW_Status is
            ----------------------
            when PARSE_REGISTER =>
               Parse_SimpleValue (Register_Number, Success);
               exit when not Success;
               HRW_Status := CHECK_EQUAL;
            -------------------
            when CHECK_EQUAL =>
               Read_Next_Character (C, Success);
               exit when not Success;
               if C /= '=' then
                  Success := False;
                  exit;
               end if;
               HRW_Status := PARSE_HEX_VALUE;
            -----------------------
            when PARSE_HEX_VALUE =>
               for Index in 0 .. 15 loop
                  Byte_Count := Index;
                  Parse_Byte (Byte_Value, Success);
                  exit when not Success;
                  Register_Value (Index) := Byte_Value;
               end loop;
               if Byte_Count /= 0 then
                  Success := True;
               end if;
               exit;
         end case;
      end loop;
      ---------------
      if Success then
         Register_Write (Register_Number, Register_Value, Byte_Count);
         TX_Packet_Copy_Response (RESPONSE_OK);
      else
         TX_Packet_Copy_Response (RESPONSE_ERROR);
      end if;
      TX_Packet;
   end Handle_Register_Write;

   ----------------------------------------------------------------------------
   -- Handle_General_Query
   ----------------------------------------------------------------------------
   -- "q name params..."
   -- General query packets.
   ----------------------------------------------------------------------------
   procedure Handle_General_Query is
      Send_Response : Boolean;
   begin
      Send_Response := True;
      if (RX_Packet_Length >= 10) and then (RX_Packet_Buffer (2 .. 10) = "Supported") then
         -- Tell the remote stub about features supported by gdb, and query the stub for features it supports
         -- reply: <featureslist>
         TX_Packet_Copy_Response (
                                  "swbreak+;"                  &
                                  "hwbreak-;"                  &
                                  "fork-events-;"              &
                                  "vfork-events-;"             &
                                  "multiprocess-;"             &
                                  "EnableDisableTracepoints-;" &
                                  ""
                                 );
      -- elsif (RX_Packet_Length >= 9) and then (RX_Packet_Buffer (2 .. 9) = "Symbol::") then
      --    -- Notify the target that gdb is prepared to serve symbol lookup requests.
      --    -- reply: The target does not need to look up any (more) symbols.
      --    TX_Packet_Copy_Response (RESPONSE_OK);
      elsif (RX_Packet_Length >= 8) and then (RX_Packet_Buffer (2 .. 8) = "TStatus") then
         -- Ask the stub if there is a trace experiment running right now
         -- reply: trace presently not running, no trace has been run yet
         TX_Packet_Copy_Response ("T0:tnotrun:0");
      elsif (RX_Packet_Length >= 4) and then (RX_Packet_Buffer (2 .. 4) = "TfP") then
         -- request data about tracepoints that are being used by the target
         -- reply: none
         null;
      elsif (RX_Packet_Length >= 4) and then (RX_Packet_Buffer (2 .. 4) = "TfV") then
         -- request data about trace state variables that are on the target
         -- reply: none
         null;
      elsif (RX_Packet_Length >= 12) and then (RX_Packet_Buffer (2 .. 12) = "fThreadInfo") then
         -- Obtain a list of all active thread IDs from the target (OS)
         -- reply: kernel single thread-id
         TX_Packet_Copy_Response ("m1");
      elsif (RX_Packet_Length >= 12) and then (RX_Packet_Buffer (2 .. 12) = "sThreadInfo") then
         -- Obtain a list of all active thread IDs from the target (OS)
         -- reply: end of list
         TX_Packet_Copy_Response ("l");
      end if;
      if Send_Response then
         TX_Packet;
      end if;
   end Handle_General_Query;

   ----------------------------------------------------------------------------
   -- Handle_General_Set
   ----------------------------------------------------------------------------
   -- "Q name params..."
   -- General set packets.
   ----------------------------------------------------------------------------
   procedure Handle_General_Set is
   begin
      null;
   end Handle_General_Set;

   ----------------------------------------------------------------------------
   -- Handle_Restart
   ----------------------------------------------------------------------------
   -- "R"
   ----------------------------------------------------------------------------
   procedure Handle_Restart (Exit_Flag : in out Boolean) is
   begin
      Exit_Flag := True;
   end Handle_Restart;

   ----------------------------------------------------------------------------
   -- Handle_Step
   ----------------------------------------------------------------------------
   -- "s"
   ----------------------------------------------------------------------------
   procedure Handle_Step (Exit_Flag : in out Boolean) is
   begin
      if Step_Execute then
         Single_Stepping := True;
         Exit_Flag := True;
      end if;
   end Handle_Step;

   ----------------------------------------------------------------------------
   -- Handle_Multi_Letter_Packets
   ----------------------------------------------------------------------------
   procedure Handle_Multi_Letter_Packets is
      Send_Response : Boolean;
   begin
      Send_Response := True;
      if (RX_Packet_Length >= 6) and then (RX_Packet_Buffer (2 .. 6) = "Cont?") then
         null; -- __FIX__
      end if;
      if Send_Response then
         TX_Packet;
      end if;
   end Handle_Multi_Letter_Packets;

   ----------------------------------------------------------------------------
   -- Command_Loop
   ----------------------------------------------------------------------------
   procedure Command_Loop is
      Exit_Flag : Boolean;
   begin
      Exit_Flag := False;
      loop
         RX_Packet;
         if RX_Packet_Length > 0 then
            -- TX_Packet_Index shall be initialized because called subprograms
            -- could add characters to the buffer sequentially
            TX_Packet_Index := 0;
            case RX_Packet_Buffer (1) is
               when '?'    => Notify_Halt_Reason;
               when 'c'    => Handle_Continue (Exit_Flag);
               when 'g'    => Handle_General_Registers_Read;
               when 'G'    => Handle_General_Registers_Write;
               when 'H'    => Handle_Set_Thread;
               when 'k'    => Handle_Kill_Request;
               when 'm'    => Handle_Memory_Read;
               when 'M'    => Handle_Memory_Write;
               when 'p'    => Handle_Register_Read;
               when 'P'    => Handle_Register_Write;
               when 'q'    => Handle_General_Query;
               when 'Q'    => Handle_General_Set;
               when 'R'    => Handle_Restart (Exit_Flag);
               when 's'    => Handle_Step (Exit_Flag);
               when 'v'    => Handle_Multi_Letter_Packets;
               when others => TX_Packet;
            end case;
            if Exit_Flag then
               exit;
            end if;
         end if;
      end loop;
   end Command_Loop;

   ----------------------------------------------------------------------------
   -- Enter_Stub
   ----------------------------------------------------------------------------
   procedure Enter_Stub (Cause : in Target_State_Type; Thread_ID : in Natural) is
      pragma Unreferenced (Cause);
      pragma Unreferenced (Thread_ID);
   begin
      if Single_Stepping then
         Single_Stepping := False;
         Step_Resume;
      else
         Breakpoint_Adjust_PC;
      end if;
      -- if this is an explicit breakpoint, avoid sending an unsolicited
      -- notification (GDB will explicitly request the target status)
      if Breakpoint_Startup_Flag then
         Breakpoint_Startup_Flag := False;
         Breakpoint_Skip;
         if Debug_Mode >= DEBUG_COMMUNICATION then
            Console.Print ("STUB: Starting GDB stub ...", NL => True);
         end if;
         Notify_Halt_Reason;
      else
         Notify_Halt_Reason;
      end if;
      Command_Loop;
   end Enter_Stub;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- Getchar: procedure pointer to get a character from terminal
   -- Putchar: procedure pointer to put a character to terminal
   ----------------------------------------------------------------------------
   procedure Init (
                   Getchar : in Getchar_Ptr;
                   Putchar : in Putchar_Ptr;
                   Mode    : in Debug_Mode_Type
                  ) is
   begin
      RX_Character := Getchar;
      TX_Character := Putchar;
      Debug_Mode := Mode;
      if Debug_Mode /= DEBUG_BYPASS then
         Single_Stepping := False;
         Breakpoint_Startup_Flag := True;
         Breakpoint_Set;
      end if;
   end Init;

end Gdbstub;
