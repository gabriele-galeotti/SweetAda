-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ srecord.adb                                                                                               --
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
with Interfaces;
with Ada.Characters.Latin_1;
with Bits;
with LLutils;
with Memory_Functions;
with CPU;

package body Srecord is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Ada.Characters.Latin_1;
   use Bits;
   use LLutils;

   type Srecord_Type is (NONE, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);

   type RX_Status_Type is (
                           WAIT_S,
                           WAIT_TYPE,
                           WAIT_BYTECOUNT1,
                           WAIT_BYTECOUNT2,
                           WAIT_COUNT,
                           WAIT_ADDRESS,
                           WAIT_DATA,
                           WAIT_CHECKSUM1,
                           WAIT_CHECKSUM2,
                           WAIT_EOL
                          );

   RX_Character  : Getchar_Ptr;
   TX_Character  : Putchar_Ptr;
   Srec          : Srecord_Type;
   Data          : Byte_Array (0 .. 255);
   Echo          : Boolean := False;
   Start_Address : Integer_Address := 0;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Receive
   ----------------------------------------------------------------------------
   -- S/Type/ByteCount/Address/Data/Checksum
   ----------------------------------------------------------------------------
   procedure Receive is
      RX_Status         : RX_Status_Type;
      C                 : Character;
      C_Is_HexDigit     : Boolean;
      Hex8              : Unsigned_8 := 0;
      Bytecount         : Natural := 0;
      Addressvalue      : Integer_Address := 0;
      Addressdigits     : Natural := 0;
      Datadigits        : Natural := 0;
      Idx               : Natural := 0;
      MSdigit           : Boolean;
      Checksum_Received : Unsigned_8 := 0;
      Checksum_Computed : Unsigned_8 := 0;
   begin
      Srec := NONE;
      RX_Status := WAIT_S;
      loop
         RX_Character.all (C);
         if Echo then
            TX_Character.all (C);
         end if;
         case RX_Status is
            --------------
            when WAIT_S =>
               if C = 'S' then
                  RX_Status := WAIT_TYPE;
               elsif C /= LF and then C /= CR then
                  RX_Status := WAIT_EOL;
               end if;
            -----------------
            when WAIT_TYPE =>
               case C is
                  when '0'    => Srec := S0; Addressdigits := 4;
                  when '1'    => Srec := S1; Addressdigits := 4;
                  when '2'    => Srec := S2; Addressdigits := 6;
                  when '3'    => Srec := S3; Addressdigits := 8;
                  when '4'    => Srec := S4; Addressdigits := 0;
                  when '5'    => Srec := S5; Addressdigits := 4;
                  when '6'    => Srec := S6; Addressdigits := 6;
                  when '7'    => Srec := S7; Addressdigits := 8;
                  when '8'    => Srec := S8; Addressdigits := 6;
                  when '9'    => Srec := S9; Addressdigits := 4;
                  when others => Srec := NONE;
               end case;
               case Srec is
                  when S0 .. S9 => RX_Status := WAIT_BYTECOUNT1; Checksum_Computed := 0;
                  when NONE     => RX_Status := WAIT_EOL;
               end case;
            -----------------------
            when WAIT_BYTECOUNT1 =>
               HexDigit_To_U8 (C => C, MSD => True, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  RX_Status := WAIT_BYTECOUNT2;
               else
                  RX_Status := WAIT_EOL;
               end if;
            -----------------------
            when WAIT_BYTECOUNT2 =>
               HexDigit_To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  Checksum_Computed := Checksum_Computed + Hex8;
                  Bytecount := Natural (Hex8);
                  Datadigits := Bytecount * 2;
                  Addressvalue := 0;
                  RX_Status := WAIT_ADDRESS;
               else
                  RX_Status := WAIT_EOL;
               end if;
            ------------------
            when WAIT_COUNT =>
               null;
            --------------------
            when WAIT_ADDRESS =>
               if (Addressdigits mod 2) = 0 then
                  MSdigit := True;
               else
                  MSdigit := False;
               end if;
               Hex8 := 0;
               HexDigit_To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  if MSdigit then
                     Checksum_Computed := Checksum_Computed + Hex8 * 2**4;
                  else
                     Checksum_Computed := Checksum_Computed + Hex8;
                  end if;
                  Datadigits := Datadigits - 1;
                  Addressvalue := Addressvalue * 2**4 + Integer_Address (Hex8);
                  Addressdigits := Addressdigits - 1;
                  if Addressdigits = 0 then
                     case Srec is
                        when S0       => RX_Status := WAIT_DATA;
                        when S1 .. S3 => RX_Status := WAIT_DATA; Idx := 0;
                        when others   => RX_Status := WAIT_CHECKSUM1;
                     end case;
                  end if;
               else
                  RX_Status := WAIT_EOL;
               end if;
            -----------------
            when WAIT_DATA =>
               if (Datadigits mod 2) = 0 then
                  MSdigit := True;
               else
                  MSdigit := False;
               end if;
               HexDigit_To_U8 (C => C, MSD => MSdigit, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  if not MSdigit then
                     if Srec /= S0 then
                        Data (Idx) := Hex8;
                        Idx := Idx + 1;
                     end if;
                     Checksum_Computed := Checksum_Computed + Hex8;
                  end if;
                  Datadigits := Datadigits - 1;
                  if Datadigits = 2 then
                     RX_Status := WAIT_CHECKSUM1;
                  end if;
               else
                  RX_Status := WAIT_EOL;
               end if;
            ----------------------
            when WAIT_CHECKSUM1 =>
               HexDigit_To_U8 (C => C, MSD => True, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  RX_Status := WAIT_CHECKSUM2;
               else
                  RX_Status := WAIT_EOL;
               end if;
            ----------------------
            when WAIT_CHECKSUM2 =>
               HexDigit_To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  Checksum_Received := Hex8;
                  Checksum_Computed := not Checksum_Computed;
                  if Checksum_Computed = Checksum_Received then
                     TX_Character.all ('.');
                     case Srec is
                        when S1 .. S3 =>
                           -- commit data to memory
                           Memory_Functions.Cpymem (
                                                    Data'Address,
                                                    To_Address (Addressvalue),
                                                    Bytesize (Bytecount)
                                                   );
                        when S7 .. S9 =>
                           -- start address
                           Start_Address := Addressvalue;
                           CPU.Asm_Call (To_Address (Start_Address));
                        when others   =>
                           null;
                     end case;
                     RX_Status := WAIT_CHECKSUM1;
                  end if;
               end if;
               RX_Status := WAIT_EOL;
            ----------------
            when WAIT_EOL =>
               if C = LF or else C = CR then
                  RX_Status := WAIT_S;
               end if;
         end case;
      end loop;
   end Receive;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- Getchar: procedure pointer to get a character from terminal
   -- Putchar: procedure pointer to put a character to terminal
   ----------------------------------------------------------------------------
   procedure Init (Getchar : in Getchar_Ptr; Putchar : in Putchar_Ptr) is
   begin
      RX_Character := Getchar;
      TX_Character := Putchar;
   end Init;

end Srecord;
