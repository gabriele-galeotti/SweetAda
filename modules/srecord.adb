-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ srecord.adb                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Characters.Latin_1;
with Interfaces;
with Bits;
with LLutils;
with Memory_Functions;

package body Srecord
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Ada.Characters.Latin_1;
   use Interfaces;
   use Bits;
   use LLutils;

   type Srecord_Type is (NONE, S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);

   type RX_Status_Type is
      (WAIT_S,
       WAIT_TYPE,
       WAIT_BYTECOUNT1,
       WAIT_BYTECOUNT2,
       WAIT_ADDRESS,
       WAIT_COUNT,
       WAIT_DATA,
       WAIT_CHECKSUM1,
       WAIT_CHECKSUM2,
       WAIT_EOL);

   RX_Character : Getchar_Ptr;
   TX_Character : Putchar_Ptr;
   Echo         : Boolean := False;
   Srec         : Srecord_Type;
   Data         : Byte_Array (0 .. 255);
   Prompt       : constant String := CR & LF & "S-record" & CR & LF;

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
   -- A quick exit from the loop could be obtained by typing "S70400000000FB".
   ----------------------------------------------------------------------------
   procedure Receive
      is
      RX_Status         : RX_Status_Type;
      C                 : Character;
      C_Is_HexDigit     : Boolean;
      Hex8              : Unsigned_8 := 0;
      Bytecount         : Natural := 0;
      Addressvalue      : Integer_Address := 0;
      Addressdigits     : Natural := 0;
      Datadigits        : Natural := 0;
      Data_Idx          : Natural := 0;
      MSdigit           : Boolean;
      Checksum_Received : Unsigned_8 := 0;
      Checksum_Computed : Unsigned_8 := 0;
   begin
      for Idx in Prompt'Range loop
         TX_Character.all (Prompt (Idx));
      end loop;
      Start_Address := 0;
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
               if Srec = NONE then
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               else
                  RX_Status := WAIT_BYTECOUNT1;
                  Checksum_Computed := 0;
               end if;
            -----------------------
            when WAIT_BYTECOUNT1 =>
               To_U8 (C => C, MSD => True, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  RX_Status := WAIT_BYTECOUNT2;
               else
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               end if;
            -----------------------
            when WAIT_BYTECOUNT2 =>
               To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  Checksum_Computed := @ + Hex8;
                  Bytecount := Natural (Hex8);
                  Datadigits := Bytecount * 2;
                  Addressvalue := 0;
                  RX_Status := WAIT_ADDRESS;
               else
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               end if;
            --------------------
            when WAIT_ADDRESS =>
               if (Addressdigits mod 2) = 0 then
                  MSdigit := True;
               else
                  MSdigit := False;
               end if;
               Hex8 := 0;
               To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  if MSdigit then
                     Checksum_Computed := @ + Hex8 * 2**4;
                  else
                     Checksum_Computed := @ + Hex8;
                  end if;
                  Datadigits := @ - 1;
                  Addressvalue := @ * 2**4 + Integer_Address (Hex8);
                  Addressdigits := @ - 1;
                  if Addressdigits = 0 then
                     case Srec is
                        when S0       => RX_Status := WAIT_DATA;
                        when S1 .. S3 => RX_Status := WAIT_DATA; Data_Idx := 0;
                        when others   => RX_Status := WAIT_CHECKSUM1;
                     end case;
                  end if;
               else
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               end if;
            ------------------
            when WAIT_COUNT =>
               -- not implemented
               null;
            -----------------
            when WAIT_DATA =>
               if (Datadigits mod 2) = 0 then
                  MSdigit := True;
               else
                  MSdigit := False;
               end if;
               To_U8 (C => C, MSD => MSdigit, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  if not MSdigit then
                     if Srec /= S0 then
                        Data (Data_Idx) := Hex8;
                        Data_Idx := @ + 1;
                     end if;
                     Checksum_Computed := @ + Hex8;
                  end if;
                  Datadigits := @ - 1;
                  if Datadigits = 2 then
                     RX_Status := WAIT_CHECKSUM1;
                  end if;
               else
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               end if;
            ----------------------
            when WAIT_CHECKSUM1 =>
               To_U8 (C => C, MSD => True, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  RX_Status := WAIT_CHECKSUM2;
               else
                  TX_Character.all ('X');
                  RX_Status := WAIT_EOL;
               end if;
            ----------------------
            when WAIT_CHECKSUM2 =>
               To_U8 (C => C, MSD => False, Value => Hex8, Success => C_Is_HexDigit);
               if C_Is_HexDigit then
                  Checksum_Received := Hex8;
                  Checksum_Computed := not @;
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
                           TX_Character.all ('R');
                           Start_Address := Addressvalue;
                        when S4       =>
                           -- this record is reserved
                           null;
                        when others   =>
                           null;
                     end case;
                  else
                     -- checksum error
                     TX_Character.all ('C');
                  end if;
               else
                  TX_Character.all ('X');
               end if;
               RX_Status := WAIT_EOL;
            ----------------
            when WAIT_EOL =>
               if C = LF or else C = CR then
                  if Srec in S7 .. S9 then
                     exit;
                  else
                     RX_Status := WAIT_S;
                  end if;
               end if;
         end case;
      end loop;
      TX_Character.all (CR);
      TX_Character.all (LF);
   end Receive;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- Getchar: procedure pointer to get a character from terminal
   -- Putchar: procedure pointer to put a character to terminal
   ----------------------------------------------------------------------------
   procedure Init
      (Getchar     : in Getchar_Ptr;
       Putchar     : in Putchar_Ptr;
       Echo_Enable : in Boolean)
      is
   begin
      RX_Character := Getchar;
      TX_Character := Putchar;
      Echo := Echo_Enable;
   end Init;

end Srecord;
