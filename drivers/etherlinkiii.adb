-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ etherlinkiii.adb                                                                                          --
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
with CPU;
with CPU.IO;
with PC;
with Console;

package body EtherLinkIII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;
   use CPU;
   use CPU.IO;
   use PC;

   ID_PORT : constant := 16#0100#;

   type NWindow_Type is new Natural range 0 .. 7;
   WINDOW0 : constant NWindow_Type := 0;
   WINDOW1 : constant NWindow_Type := 1;
   WINDOW2 : constant NWindow_Type := 2;
   WINDOW3 : constant NWindow_Type := 3;
   WINDOW4 : constant NWindow_Type := 4;
   WINDOW5 : constant NWindow_Type := 5;
   WINDOW6 : constant NWindow_Type := 6;
   WINDOW7 : constant NWindow_Type := 7;

   -- DATA_REGISTER   : constant := 16#00#;
   CMD_REGISTER    : constant := 16#0E#;
   STATUS_REGISTER : constant := 16#0E#;
   EEPROM_READ     : constant := 16#80#;

   RX_ENABLE : constant := 16#2000#;

   EtherLinkIII_Card : EtherLinkIII_Card_Type;

   procedure Select_Window (N : in NWindow_Type) with
      Inline => True;
   function Status_Read return Unsigned_16 with
      Inline => True;
   function EEPROM_ID_Read (Data_Index : Natural) return Unsigned_16;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Select_Window
   ----------------------------------------------------------------------------
   procedure Select_Window (N : in NWindow_Type) is
   begin
      IO_Write (
                EtherLinkIII_Card.Base_Address + CMD_REGISTER,
                16#0800# + Unsigned_16 (N)
               );
   end Select_Window;

   ----------------------------------------------------------------------------
   -- Status_Read
   ----------------------------------------------------------------------------
   function Status_Read return Unsigned_16 is
   begin
      return Unsigned_16'(IO_Read (EtherLinkIII_Card.Base_Address + 16#0E#));
   end Status_Read;

   ----------------------------------------------------------------------------
   -- EEPROM_Read
   ----------------------------------------------------------------------------
   function EEPROM_ID_Read (Data_Index : Natural) return Unsigned_16 is
      Result : Unsigned_16;
   begin
      PortOut (ID_PORT, EEPROM_READ or Unsigned_8 (Data_Index));
      PIT_Counter1_Delay (2); -- 200 us
      Result := 0;
      for Index in 1 .. Result'Size loop
         Result := Shift_Left (Result, 1);
         Result := Result or Bit0 (Unsigned_8'(PortIn (ID_PORT)));
      end loop;
      return Result;
   end EEPROM_ID_Read;

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   -- __REF__ 7-2 Adapter Configuration and Enable
   ----------------------------------------------------------------------------
   procedure Probe is
   begin
      -- ID sequence
      -- IDS is in ID_WAIT state, and it monitors write accesses to 01x0h
      declare
         Data     : Unsigned_8;
         High_Bit : Boolean;
      begin
         -- ID_PORT = 0x100
         PortOut (ID_PORT, Unsigned_8'(0));
         Data := 16#FF#;
         for Index in 1 .. 255 loop
            PortOut (ID_PORT, Data);
            High_Bit := MSBitOn (Data);
            Data := Shift_Left (Data, 1);
            if High_Bit then
               Data := Data xor 16#CF#;
            end if;
         end loop;
      end;
      -- IDS is now in the ID_CMD state
      -- set adapter tag register to 0
      PortOut (ID_PORT, Unsigned_8'(16#D0#));
      if EEPROM_ID_Read (7) = 16#6D50# then
         Console.Print ("3C509B adapter found", NL => True);
      else
         Console.Print ("3C509B: no adapters found", NL => True);
         return;
      end if;
      -- MAC address
      -- __FIX__ should use Print (Byte_Array)
      declare
         Data : Unsigned_16;
      begin
         Console.Print ("MAC");
         for Index in 0 .. 2 loop
            Data := EEPROM_ID_Read (Index);
            EtherLinkIII_Card.MAC (Index * 2)     := HByte (Data);
            EtherLinkIII_Card.MAC (Index * 2 + 1) := LByte (Data);
            Console.Print (Character'(':'));
            Console.Print (HByte (Data));
            Console.Print (Character'(':'));
            Console.Print (LByte (Data));
         end loop;
         Console.Print_NewLine;
      end;
      -- read IO base address and IRQ
      declare
         Data      : Unsigned_16;
         IO_Offset : Storage_Offset;
      begin
         Data := EEPROM_ID_Read (8);
         IO_Offset := Storage_Offset (Shift_Left (Data and 16#001F#, 4));
         EtherLinkIII_Card.Base_Address := To_Address (16#0200#) + IO_Offset;
         EtherLinkIII_Card.IF_Port := Shift_Right (Data, 14);
         Data := EEPROM_ID_Read (9);
         EtherLinkIII_Card.IRQ := Natural (Shift_Right (Data, 12));
         Console.Print (EtherLinkIII_Card.Base_Address, Prefix => "IO address: ", NL => True);
         Console.Print (EtherLinkIII_Card.IRQ, Prefix => "IRQ: ", NL => True);
      end;
      -- set adapter tag register
      PortOut (ID_PORT, Unsigned_8'(16#D0# + 1));
      -- activate adapter
      PortOut (ID_PORT, Unsigned_8'(16#FF#));
      -- select window 0
      Select_Window (WINDOW0);
      if Unsigned_16'(IO_Read (EtherLinkIII_Card.Base_Address)) /= 16#6D50# then
         Console.Print ("3C509B: no adapters found", NL => True);
         return;
      end if;
   end Probe;

end EtherLinkIII;
