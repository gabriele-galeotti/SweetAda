-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-textfile.adb                                                                                        --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Definitions;
with FATFS.Rawfile;

package body FATFS.Textfile
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Get
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean);

   procedure Get
      (D       : in     Descriptor_Type;
       File    : in     TWCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean);

   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       B       : in out Block_Type;
       Count   : in     Unsigned_16;
       Success : out    Boolean);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a text file by directory entry.
   ----------------------------------------------------------------------------
   procedure Open
      (D       : in     Descriptor_Type;
       File    :    out TFCB_Type;
       DE      : in     Directory_Entry_Type;
       Success :    out Boolean)
      is
   begin
      File.Byte_Offset := 0;
      Rawfile.Open (D, File.FCB, DE, Success);
   end Open;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a text file by name.
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in     Descriptor_Type;
       File      :    out TFCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
   begin
      File.Byte_Offset := 0;
      Rawfile.Open (D, File.FCB, DCB, File_Name, Success);
   end Open;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a text file.
   ----------------------------------------------------------------------------
   procedure Rewind
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type)
      is
   begin
      Rawfile.Rewind (D, File.FCB);
      File.Byte_Offset := 0;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Get
   ----------------------------------------------------------------------------
   -- Fetch a block to read from.
   ----------------------------------------------------------------------------
   procedure Get
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean)
      is
   begin
      if File.Byte_Offset = 0 then
         Rawfile.Read (D, File.FCB, B, Count, Success);
      else
         Rawfile.Reread (D, File.FCB, B, Count, Success);
      end if;
   end Get;

   ----------------------------------------------------------------------------
   -- Read_Char
   ----------------------------------------------------------------------------
   -- Read the next character from the text file.
   ----------------------------------------------------------------------------
   procedure Read_Char
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       C       :    out Character;
       Success :    out Boolean)
      is
      B     : Block_Type (0 .. 511);
      Count : Unsigned_16;
   begin
      Get (D, File, B, Count, Success);
      C := Character'Val (0);
      if Success then
         if File.Byte_Offset < Count then
            C := Character'Val (B (Natural (File.Byte_Offset)));
            File.Byte_Offset := (File.Byte_Offset + 1) mod D.Sector_Size;
         else
            Success := False; -- end of file
         end if;
      end if;
   end Read_Char;

   ----------------------------------------------------------------------------
   -- Read_Line
   ----------------------------------------------------------------------------
   -- Read the next text line from the text file.
   ----------------------------------------------------------------------------
   procedure Read_Line
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Line    :    out String;
       Last    :    out Natural;
       Success :    out Boolean)
      is
      B        : Block_Type (0 .. 511);
      Count    : Unsigned_16;
      Byte     : Unsigned_8;
      -- End_Flag : Boolean := False;
   begin
      Last := Line'First - 1;
      if Line'Length < 1 then
         Success := True;
         return;
      end if;
      Get (D, File, B, Count, Success);
      if Success then
         if File.Byte_Offset >= Count then
            Success := False;
            return;
         end if;
         for Index in Line'Range loop
            exit when File.Byte_Offset >= Count; -- end file test
            Byte := B (Natural (File.Byte_Offset));
            exit when Byte = 16#0D# or else Byte = 16#0A#;
            File.Byte_Offset := (File.Byte_Offset + 1) mod D.Sector_Size;
            Line (Index) := Character'Val (Byte);
            Last := Index;
            if File.Byte_Offset = 0 then
               Get (D, File, B, Count, Success);
               exit when not Success;
            end if;
         end loop;
         loop
            exit when File.Byte_Offset >= Count; -- end file test
            Byte := B (Natural (File.Byte_Offset));
            if Byte = 16#0D# then
               File.Byte_Offset := (File.Byte_Offset + 1) mod D.Sector_Size;
               -- End_Flag := True;
            elsif Byte = 16#0A# then
               File.Byte_Offset := (File.Byte_Offset + 1) mod D.Sector_Size;
               exit;
            else
               exit; -- read line was truncated in user''s buffer
            end if;
            if File.Byte_Offset = 0 then
               Get (D, File, B, Count, Success);
               exit when not Success;
            end if;
         end loop;
      end if;
   end Read_Line;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read a binary record.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Buffer  :    out Byte_Array;
       Count   :    out Unsigned_16;
       Success :    out Boolean)
      is
      B          : Block_Type (0 .. 511);
      Read_Count : Unsigned_16;
   begin
      Count := 0;
      if Buffer'Length < 1 then
         Success := True;
         return;
      end if;
      Get (D, File, B, Read_Count, Success);
      for Index in Buffer'Range loop
         exit when not Success;
         exit when File.Byte_Offset >= Read_Count; -- end file test
         Buffer (Index) := B (Natural (File.Byte_Offset));
         Count := Count + 1;
         File.Byte_Offset := (File.Byte_Offset + 1) mod D.Sector_Size;
         if File.Byte_Offset = 0 and then Index < Buffer'Last then
            Get (D, File, B, Read_Count, Success);
         end if;
      end loop;
      if Count < 1 then
         Success := False;
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_8.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_8;
       Success :    out Boolean)
      is
      Buffer : Byte_Array (1 .. 1);
      Count  : Unsigned_16 with Unreferenced => True;
   begin
      Read (D, File, Buffer, Count, Success);
      if Success then
         Data := Buffer (Buffer'First);
      else
         Data := 0;
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_16.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_16;
       Success :    out Boolean)
      is
      Buffer : Byte_Array (1 .. 2);
      Count  : Unsigned_16;
   begin
      Read (D, File, Buffer, Count, Success);
      if Success and then Count = Buffer'Length then
         -- __FIX__ use Bits
         Data := Unsigned_16 (Buffer (Buffer'First)) or Shift_Left (Unsigned_16 (Buffer (Buffer'Last)), 8);
      else
         Data := 0;
         Success := False;
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read an Unsigned_32.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_32;
       Success :    out Boolean)
      is
      Buffer : Byte_Array (1 .. 4);
      Count  : Unsigned_16;
   begin
      Data := 0;
      Read (D, File, Buffer, Count, Success);
      if Success and then Count = Buffer'Length then
         for Index in reverse Buffer'Range loop
            -- __FIX__ use Bits
            Data := Shift_Left (Data, 8) or Unsigned_32 (Buffer (Index));
         end loop;
      else
         Success := False;
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a text file.
   ----------------------------------------------------------------------------
   procedure Close
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type)
      is
   begin
      Rawfile.Close (D, File.FCB);
   end Close;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open an existing file for text writing.
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
   begin
      File.Byte_Offset := 0;
      Rawfile.Open (D, File.WCB, DCB, File_Name, Success);
   end Open;

   ----------------------------------------------------------------------------
   -- Create
   ----------------------------------------------------------------------------
   -- Create a file.
   ----------------------------------------------------------------------------
   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
   begin
      File.Byte_Offset := 0;
      Rawfile.Create (D, File.WCB, DCB, File_Name, Success);
   end Create;

   ----------------------------------------------------------------------------
   -- Get
   ----------------------------------------------------------------------------
   -- Get partial buffer before appending text.
   ----------------------------------------------------------------------------
   procedure Get
      (D       : in     Descriptor_Type;
       File    : in     TWCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
   begin
      Success := Rawfile.Is_Valid (File.WCB);
      if Success then
         if File.Byte_Offset > 0 then
            IDE.Read (D.Device.all, Physical_Sector (D, File.WCB.CCB.Previous_Sector), B, Success);
         else
            B := [others => 0];
         end if;
      end if;
   end Get;

   ----------------------------------------------------------------------------
   -- Put
   ----------------------------------------------------------------------------
   -- Put a block of text in a file.
   ----------------------------------------------------------------------------
   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       B       : in out Block_Type;
       Count   : in     Unsigned_16;
       Success : out    Boolean)
      is
   begin
      if File.Byte_Offset = 0 then
         Rawfile.Write (D, File.WCB, B, Count, Success); -- start a new sector of text
      else
         Rawfile.Rewrite (D, File.WCB, B, Count, Success); -- update last sector of text
      end if;
      -- pragma Assert (Count <= Sector_Size); -- __FIX__
      if Count >= D.Sector_Size then
         File.Byte_Offset := 0;
      else
         File.Byte_Offset := Count;
      end if;
   end Put;

   ----------------------------------------------------------------------------
   -- Put
   ----------------------------------------------------------------------------
   -- Put a text character in a file.
   ----------------------------------------------------------------------------
   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       C       : in     Character;
       Success :    out Boolean)
      is
      B     : Block_Type (0 .. 511);
      Count : Unsigned_16;
   begin
      Count := File.Byte_Offset + 1;
      Get (D, File, B, Success);
      if Success then
         B (Natural (File.Byte_Offset)) := Bits.To_U8 (C);
         Put (D, File, B, Count, Success);
      end if;
   end Put;

   ----------------------------------------------------------------------------
   -- Put
   ----------------------------------------------------------------------------
   -- Put a string of text in a file.
   ----------------------------------------------------------------------------
   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean)
      is
      B     : Block_Type (0 .. 511);
      Count : Unsigned_16 := File.Byte_Offset;
   begin
      if Text'Length < 1 then
         Success := True;
         return;
      end if;
      Get (D, File, B, Success);
      for Index in Text'Range loop
         exit when not Success;
         B (Natural (Count)) := Bits.To_U8 (Text (Index));
         Count := Count + 1;
         if Count >= D.Sector_Size then
            Put (D, File, B, Count, Success);
            Count := 0;
         end if;
      end loop;
      if Success and then Count > 0 then
         Put (D, File, B, Count, Success);
      end if;
   end Put;

   ----------------------------------------------------------------------------
   -- Put_NewLine
   ----------------------------------------------------------------------------
   -- Put a line terminator in a file.
   ----------------------------------------------------------------------------
   procedure Put_NewLine
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean)
      is
   begin
      Put (D, File, Definitions.CRLF, Success);
   end Put_NewLine;

   ----------------------------------------------------------------------------
   -- Put_Line
   ----------------------------------------------------------------------------
   -- Put one line of text in a file (plus a terminating newline).
   ----------------------------------------------------------------------------
   procedure Put_Line
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean)
      is
   begin
      Put (D, File, Text, Success);
      if Success then
         Put_NewLine (D, File, Success);
      end if;
   end Put_Line;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an array of values to a file.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Buffer  : in     Byte_Array;
       Success :    out Boolean)
      is
      Text : aliased String (1 .. Buffer'Length) with
         Address    => Buffer (0)'Address,
         Import     => True,
         Convention => Ada;
   begin
      Put (D, File, Text, Success);
   end Write;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_8 to a file.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_8;
       Success :    out Boolean)
      is
      Buffer : Byte_Array (1 .. 1);
   begin
      Buffer (Buffer'First) := Data;
      Write (D, File, Buffer, Success);
   end Write;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_16 to a file.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_16;
       Success : out    Boolean)
      is
      Buffer : Byte_Array (1 .. 2);
   begin
      -- LE layout __FIX__ use Bits
      Buffer (Buffer'First + 0) := LByte (Data);
      Buffer (Buffer'First + 1) := HByte (Data);
      Write (D, File, Buffer, Success);
   end Write;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write an Unsigned_32 to a file.
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_32;
       Success :    out Boolean)
      is
      Buffer : Byte_Array (1 .. 4);
   begin
      -- LE layout __FIX__ use Bits
      Buffer (Buffer'First + 0) := LByte (Data);
      Buffer (Buffer'First + 1) := MByte (Data);
      Buffer (Buffer'First + 2) := NByte (Data);
      Buffer (Buffer'First + 3) := HByte (Data);
      Write (D, File, Buffer, Success);
   end Write;

   ----------------------------------------------------------------------------
   -- File_Sync
   ----------------------------------------------------------------------------
   -- Force update of file size in directory entry.
   ----------------------------------------------------------------------------
   procedure Sync
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean)
      is
   begin
      Rawfile.Sync (D, File.WCB, Success);
   end Sync;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a text file.
   ----------------------------------------------------------------------------
   procedure Close
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean)
      is
   begin
      Rawfile.Close (D, File.WCB, Success);
   end Close;

end FATFS.Textfile;
