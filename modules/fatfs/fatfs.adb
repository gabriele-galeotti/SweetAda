-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs.adb                                                                                                 --
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

with LLutils;
with FATFS.Cluster;
with Console; -- __FIX__ debug

package body FATFS is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;
   use FATFS.Cluster;

   Sector_Start    : Sector_Type;     -- partition start (hidden sectors)
   FAT_Copies      : FAT_Copies_Type; -- # of FATs
   FAT_Modulus     : Unsigned_16;     -- table modulus
   Sectors_Per_FAT : Unsigned_32;     -- sectors per FAT

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   procedure Block_Swap_16 (B : in out Block_Type);

   procedure Block_Swap_32 (B : in out Block_Type);

   function Sector_Offset (S : Sector_Type) return Sector_Type with
      Inline => True;

   function Sector_Offset (C : Cluster_Type) return Sector_Type with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Block_Swap_XX subprograms.
   ----------------------------------------------------------------------------

   procedure Block_Swap_16 (B : in out Block_Type) is
      A : aliased U16_Array (0 .. 255) with
         Address    => B (0)'Address,
         Import     => True,
         Convention => Ada;
   begin
      for Index in A'Range loop
         Byte_Swap_16 (A (Index)'Address);
      end loop;
   end Block_Swap_16;

   procedure Block_Swap_32 (B : in out Block_Type) is
      A : aliased U32_Array (0 .. 127) with
         Address    => B (0)'Address,
         Import     => True,
         Convention => Ada;
   begin
      for Index in A'Range loop
         Byte_Swap_32 (A (Index)'Address);
      end loop;
   end Block_Swap_32;

   ----------------------------------------------------------------------------
   -- Register I/O read/write subprograms.
   ----------------------------------------------------------------------------

   procedure Register_BlockRead_Procedure (Block_Read : in IO_Read_Ptr) is
   begin
      IO_Context.Read := Block_Read;
   end Register_BlockRead_Procedure;

   procedure Register_BlockWrite_Procedure (Block_Write : in IO_Write_Ptr) is
   begin
      IO_Context.Write := Block_Write;
   end Register_BlockWrite_Procedure;

   ----------------------------------------------------------------------------
   -- Physical_Sector
   ----------------------------------------------------------------------------
   -- Compute a physical sector number, starting from a logical one.
   ----------------------------------------------------------------------------
   function Physical_Sector (Sector : Sector_Type) return Sector_Type is
   begin
      return Sector + Sector_Start;
   end Physical_Sector;

   ----------------------------------------------------------------------------
   -- Sector_Offset
   ----------------------------------------------------------------------------
   -- Compute the FAT sector offset from current FAT sector.
   ----------------------------------------------------------------------------
   function Sector_Offset (S : Sector_Type) return Sector_Type is
   begin
      return S - FAT_Start (FAT_Index);
   end Sector_Offset;

   ----------------------------------------------------------------------------
   -- Sector_Offset
   ----------------------------------------------------------------------------
   -- Compute the relative FAT sector for a given cluster #.
   ----------------------------------------------------------------------------
   function Sector_Offset (C : Cluster_Type) return Sector_Type is
   begin
      return Sector_Type (C) / Sector_Type (FAT_Modulus);
   end Sector_Offset;

   ----------------------------------------------------------------------------
   -- FAT_Is_End
   ----------------------------------------------------------------------------
   -- Return True if sector points past end of current FAT.
   ----------------------------------------------------------------------------
   function FAT_Is_End (S : Sector_Type) return Boolean is
   begin
      return S >= FAT_Start (FAT_Index) + Sector_Type (Sectors_Per_FAT);
   end FAT_Is_End;

   ----------------------------------------------------------------------------
   -- FAT_Sector
   ----------------------------------------------------------------------------
   -- Return the sector # of active FAT based upon cluster #.
   ----------------------------------------------------------------------------
   function FAT_Sector (C : Cluster_Type) return Sector_Type is
   begin
      return FAT_Start (FAT_Index) + Sector_Offset (C);
   end FAT_Sector;

   ----------------------------------------------------------------------------
   -- FAT_Entry_Index
   ----------------------------------------------------------------------------
   -- Return FAT entry index within a FAT sector.
   ----------------------------------------------------------------------------
   function FAT_Entry_Index (C : Cluster_Type) return Natural is
   begin
      return Natural (C mod Cluster_Type (FAT_Modulus));
   end FAT_Entry_Index;

   ----------------------------------------------------------------------------
   -- FAT_Entry
   ----------------------------------------------------------------------------
   -- Return a FAT entry based upon cluster #.
   ----------------------------------------------------------------------------
   function FAT_Entry (B : Block_Type; C : Cluster_Type) return Cluster_Type is
   begin
      case FAT_Style is
         when FAT16 =>
            declare
               FAT16_Table : aliased U16_Array (0 .. 255) with
                  Address    => B (0)'Address,
                  Import     => True,
                  Convention => Ada;
            begin
               return Cluster_Type (LE_To_CPUE (FAT16_Table (FAT_Entry_Index (C))));
            end;
         when FAT32 =>
            declare
               FAT32_Table : aliased U32_Array (0 .. 127) with
                  Address    => B (0)'Address,
                  Import     => True,
                  Convention => Ada;
            begin
               return Cluster_Type (LE_To_CPUE (FAT32_Table (FAT_Entry_Index (C))));
            end;
         when others =>
            return 0; -- unsupported
      end case;
   end FAT_Entry;

   ----------------------------------------------------------------------------
   -- FAT_Put_Entry
   ----------------------------------------------------------------------------
   -- Update a FAT entry based upon cluster #.
   ----------------------------------------------------------------------------
   procedure FAT_Put_Entry (
                            B     : in out Block_Type;
                            Index : in     Cluster_Type;
                            C     : in     Cluster_Type
                           ) is
   begin
      case FAT_Style is
         when FAT16 =>
            declare
               FAT16_Table : aliased U16_Array (0 .. 255) with
                  Address    => B (0)'Address,
                  Import     => True,
                  Convention => Ada;
            begin
               FAT16_Table (FAT_Entry_Index (Index)) := Unsigned_16 (C);
            end;
         when FAT32 =>
            declare
               FAT32_Table : aliased U32_Array (0 .. 127) with
                  Address    => B (0)'Address,
                  Import     => True,
                  Convention => Ada;
            begin
               FAT32_Table (FAT_Entry_Index (Index)) := Unsigned_32 (C);
            end;
         when others =>
            null;
      end case;
   end FAT_Put_Entry;

   ----------------------------------------------------------------------------
   -- FAT_Update
   ----------------------------------------------------------------------------
   -- Update a sector in all FAT copies.
   ----------------------------------------------------------------------------
   procedure FAT_Update (
                         S       : in  Sector_Type;
                         B       : in  Block_Type;
                         Success : out Boolean
                        ) is
      Offset : constant Sector_Type := Sector_Offset (S);
   begin
      for Index in FAT_Start'Range loop
         if FAT_Start (Index) /= 0 then
            IO_Context.Write (Physical_Sector (FAT_Start (Index)) + Offset, B, Success);
            exit when not Success;
         end if;
      end loop;
   end FAT_Update;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open FAT filesystem.
   ----------------------------------------------------------------------------
   procedure Open (Success : out Boolean; Partition_Start : in Sector_Type) is
      Bootrecord             : Bootrecord_Type;
      Tmp_Sector_Size        : Unsigned_16;
      Tmp_FAT_Copies         : FAT_Copies_Type;
      Tmp_Number_Of_Clusters : Unsigned_32;
      Sector                 : Sector_Type;
      FAT32_Flag             : Boolean;
      -----------------------------------------------
      procedure Swap_Data (B : in out Block_Type);
      procedure Swap_Data (B : in out Block_Type) is
         Values : Byte_Array (0 .. 511) with
            Address    => B'Address,
            Volatile   => True,
            Convention => Ada;
      begin
         Byte_Swap_16 (Values (Bootrecord.Bytes_Per_Sector'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Reserved_Sectors'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Root_Directory_Entries'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Total_Sectors_in_FS'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Sectors_Per_FAT'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Sectors_Per_Track'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.No_Of_Heads'Position)'Address);
         Byte_Swap_32 (Values (Bootrecord.Hidden_Sectors_32'Position)'Address);
         Byte_Swap_32 (Values (Bootrecord.Total_Sectors_32'Position)'Address);
         Byte_Swap_32 (Values (Bootrecord.Sectors_Per_FAT_32'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Mirror_Flags'Position)'Address);
         Byte_Swap_32 (Values (Bootrecord.Root_Directory_First_Cluster'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.FS_Info_Sector'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Backup_Boot_Sector'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Signature'Position)'Address);
      end Swap_Data;
      ------------------------------------
      function BR_Is_FAT32 return Boolean;
      function BR_Is_FAT32 return Boolean is
      begin
         return Bootrecord.Sectors_Per_FAT = 0;
      end BR_Is_FAT32;
      -----------------------------------------------
      function BR_Sectors_Per_FAT return Unsigned_32;
      function BR_Sectors_Per_FAT return Unsigned_32 is
      begin
         if not BR_Is_FAT32 then
            return Unsigned_32 (Bootrecord.Sectors_Per_FAT);
         else
            return Bootrecord.Sectors_Per_FAT_32;
         end if;
      end BR_Sectors_Per_FAT;
      ---------------------------------------------
      function BR_Total_Sectors return Unsigned_32;
      function BR_Total_Sectors return Unsigned_32 is
      begin
         if not BR_Is_FAT32 then
            return Unsigned_32 (Bootrecord.Total_Sectors_in_FS);
         else
            return Bootrecord.Total_Sectors_32;
         end if;
      end BR_Total_Sectors;
      ----------------------------------------------
      function BR_Total_Clusters return Unsigned_32;
      function BR_Total_Clusters return Unsigned_32 is
      begin
         return (
                 BR_Total_Sectors -
                 BR_Sectors_Per_FAT * Unsigned_32 (Bootrecord.FAT_Copies) -
                 Unsigned_32 (Bootrecord.Reserved_Sectors)
                ) / Unsigned_32 (Bootrecord.Sectors_Per_Cluster);
      end BR_Total_Clusters;
      ----------------------
   begin
      -------------------------------------------------------------------------
      -- Read FAT bootrecord.
      -------------------------------------------------------------------------
      declare
         B : aliased Block_Type (0 .. 511) with
            Address    => Bootrecord'Address,
            Import     => True,
            Convention => Ada;
      begin
         IO_Context.Read (Partition_Start, B, Success); -- logical sector #0 in FAT partition
         if BigEndian then
            Swap_Data (B);
         end if;
         -- Console.Print_Memory (B'Address, 512);
      end;
      if not Success then
         Console.Print ("Filesystem_Open: unable to read bootrecord.", NL => True);
         return;
      end if;
      -------------------------------------------------------------------------
      -- Perform basic checks.
      -------------------------------------------------------------------------
      -- check: Sector_Size = 512
      Tmp_Sector_Size := Bootrecord.Bytes_Per_Sector;
      if Tmp_Sector_Size /= 512 then
         Success := False;
         Console.Print ("Filesystem_Open: sector size is not 512.", NL => True);
         return;
      end if;
      -- check: 0 < FAT_Copies <= FAT_Start'Length
      Tmp_FAT_Copies := FAT_Copies_Type (Bootrecord.FAT_Copies);
      if Tmp_FAT_Copies < 1 or else Tmp_FAT_Copies > FAT_Start'Length then
         Success := False;
         Console.Print ("Filesystem_Open: wrong # of FATs.", NL => True);
         return;
      end if;
      -- check: FAT32
      FAT32_Flag := BR_Is_FAT32;
      Tmp_Number_Of_Clusters := BR_Total_Clusters;
      if not FAT32_Flag then
         FAT_Style := FAT16;
         FAT_Modulus := 256;
         Console.Print ("Filesystem_Open: FAT16 detected.", NL => True);
      elsif Tmp_Number_Of_Clusters < 268_435_457 then
         FAT_Style := FAT32;
         FAT_Modulus := 128;
         Console.Print ("Filesystem_Open: FAT32 detected.", NL => True);
      else
         Success := False;
         Console.Print ("Filesystem_Open: FAT unknown.", NL => True);
         return;
      end if;
      -- filesystem looks correct, validate definitions
      Sector_Size := Tmp_Sector_Size;
      FAT_Copies := Tmp_FAT_Copies;
      -- Number_Of_Clusters := Tmp_Number_Of_Clusters;
      -------------------------------------------------------------------------
      -- Compute vital informations about filesystem layout.
      -- NOTE: this sequence of code should not be altered because of sector
      -- back-to-back arithmetic.
      -------------------------------------------------------------------------
      Sectors_Per_Cluster := Unsigned_16 (Bootrecord.Sectors_Per_Cluster);
      Sectors_Per_FAT := BR_Sectors_Per_FAT;

      -- compute the start of each FAT table
      Sector := Sector_Type (Bootrecord.Reserved_Sectors);
      for Index in FAT_Start'Range loop
         if Index <= FAT_Copies then
            FAT_Start (Index) := Sector;
            Sector := Sector + Sector_Type (Sectors_Per_FAT);
         else
            FAT_Start (Index) := 0; -- invalid
         end if;
      end loop;

      -- now we know how many FATs there are, and where root directory is located
      FAT_Index := FAT_Start'First; -- 1st FAT
      if FAT32_Flag then
         Cluster_Start := Sector;
         -- FAT32: root directory is in a data cluster
         Root_Directory_Cluster := Cluster_Type (Bootrecord.Root_Directory_First_Cluster);
         Root_Directory_Start := To_Sector (Root_Directory_Cluster);
      else
         -- FAT16: root directory is after FATs
         Root_Directory_Cluster := 0;
         Root_Directory_Start := Sector;
         Root_Directory_Entries := Bootrecord.Root_Directory_Entries;
         -- compute the start of the data clusters
         Sector := Sector + Sector_Type (((Root_Directory_Entries * 32) + (Sector_Size - 1)) / Sector_Size);
         Cluster_Start := Sector;
      end if;

      -- other parameters
      Next_Writable_Cluster := 0;
      Search_Cluster := 0;
      -- initialize filesystem date/time
      if FS_Time.Year = 0 then
         FS_Time.Year   := Year_Type (2010 - 1980);
         FS_Time.Month  := 9;
         FS_Time.Day    := 3;
         FS_Time.Hour   := 11;
         FS_Time.Minute := 21;
         FS_Time.Second := 0;
      end if;
      Sector_Start := Partition_Start;
      FAT_Is_Open := True;
      -- DEBUG
      if True then
         Console.Print (Integer (Bootrecord.Reserved_Sectors),  Prefix => "Reserved_Sectors:    ", NL => True);
         Console.Print (Integer (Bootrecord.Hidden_Sectors_32), Prefix => "Hidden_Sectors_32:   ", NL => True);
         Console.Print (Integer (Sector_Size),                  Prefix => "Sector_Size:         ", NL => True);
         Console.Print (Integer (Sectors_Per_Cluster),          Prefix => "Sectors_Per_Cluster: ", NL => True);
         Console.Print (Integer (Sectors_Per_FAT),              Prefix => "Sectors_Per_FAT:     ", NL => True);
      end if;
      -------------------------------------------------------------------------
   end Open;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close FAT filesystem.
   ----------------------------------------------------------------------------
   procedure Close is
   begin
      FAT_Style := FATNONE;
      FAT_Is_Open := False;
   end Close;

end FATFS;
