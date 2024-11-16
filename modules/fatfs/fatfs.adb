-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs.adb                                                                                                 --
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

with LLutils;
with FATFS.Cluster;
with Console; -- __FIX__ debug

package body FATFS
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;
   use FATFS.Cluster;

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   procedure Block_Swap_16
      (B : in out Block_Type);

   procedure Block_Swap_32
      (B : in out Block_Type);

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

   procedure Block_Swap_16
      (B : in out Block_Type)
      is
      A : aliased U16_Array (0 .. 255)
         with Address    => B (0)'Address,
              Import     => True,
              Convention => Ada;
   begin
      for Index in A'Range loop
         Byte_Swap_16 (A (Index)'Address);
      end loop;
   end Block_Swap_16;

   procedure Block_Swap_32
      (B : in out Block_Type)
      is
      A : aliased U32_Array (0 .. 127)
         with Address    => B (0)'Address,
              Import     => True,
              Convention => Ada;
   begin
      for Index in A'Range loop
         Byte_Swap_32 (A (Index)'Address);
      end loop;
   end Block_Swap_32;

   ----------------------------------------------------------------------------
   -- Is_Separator
   ----------------------------------------------------------------------------
   function Is_Separator
      (C : in Character)
      return Boolean
      is
   begin
      return C = '/' or else C = '\';
   end Is_Separator;

   ----------------------------------------------------------------------------
   -- Time_Get
   ----------------------------------------------------------------------------
   procedure Time_Get
      (D : in     Descriptor_Type;
       T :    out Time_Type)
      is
   begin
      T := D.FS_Time;
   end Time_Get;

   ----------------------------------------------------------------------------
   -- Time_Set
   ----------------------------------------------------------------------------
   procedure Time_Set
      (D : in out Descriptor_Type;
       T : in     Time_Type)
      is
   begin
      D.FS_Time := T;
   end Time_Set;

   ----------------------------------------------------------------------------
   -- Physical_Sector
   ----------------------------------------------------------------------------
   function Physical_Sector
      (D      : in Descriptor_Type;
       Sector : in Sector_Type)
      return Sector_Type
      is
   begin
      return Sector + D.Sector_Start;
   end Physical_Sector;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   function Is_End
      (D : in Descriptor_Type;
       S : in Sector_Type)
      return Boolean
      is
   begin
      return S >= D.FAT_Start (D.FAT_Index) + Sector_Type (D.Sectors_Per_FAT);
   end Is_End;

   ----------------------------------------------------------------------------
   -- To_Table_Sector
   ----------------------------------------------------------------------------
   function To_Table_Sector
      (D : in Descriptor_Type;
       C : in Cluster_Type)
      return Sector_Type
      is
      FAT_Modulus_Order : Natural;
   begin
      case D.FAT_Style is
         when FAT16  => FAT_Modulus_Order := 8;
         when FAT32  => FAT_Modulus_Order := 7;
         when others => FAT_Modulus_Order := 0;
      end case;
      return D.FAT_Start (D.FAT_Index) + Sector_Type (C / 2**FAT_Modulus_Order);
   end To_Table_Sector;

   ----------------------------------------------------------------------------
   -- Entry_Index
   ----------------------------------------------------------------------------
   function Entry_Index
      (F : in FAT_Type;
       C : in Cluster_Type)
      return Natural
      is
      FAT_Modulus_Order : Natural;
   begin
      case F is
         when FAT16  => FAT_Modulus_Order := 8;
         when FAT32  => FAT_Modulus_Order := 7;
         when others => FAT_Modulus_Order := 0;
      end case;
      return Natural (C mod 2**FAT_Modulus_Order);
   end Entry_Index;

   ----------------------------------------------------------------------------
   -- Entry_Get
   ----------------------------------------------------------------------------
   function Entry_Get
      (D : in Descriptor_Type;
       B : in Block_Type;
       C : in Cluster_Type)
      return Cluster_Type
      is
   begin
      case D.FAT_Style is
         when FAT16 =>
            declare
               FAT16_Table : aliased U16_Array (0 .. 255)
                  with Address    => B (0)'Address,
                       Import     => True,
                       Convention => Ada;
            begin
               return Cluster_Type (LE_To_CPUE (FAT16_Table (Entry_Index (D.FAT_Style, C))));
            end;
         when FAT32 =>
            declare
               FAT32_Table : aliased U32_Array (0 .. 127)
                  with Address    => B (0)'Address,
                       Import     => True,
                       Convention => Ada;
            begin
               return Cluster_Type (LE_To_CPUE (FAT32_Table (Entry_Index (D.FAT_Style, C))));
            end;
         when others =>
            return 0; -- unsupported
      end case;
   end Entry_Get;

   ----------------------------------------------------------------------------
   -- Entry_Update
   ----------------------------------------------------------------------------
   procedure Entry_Update
      (D     : in     Descriptor_Type;
       B     : in out Block_Type;
       Index : in     Cluster_Type;
       C     : in     Cluster_Type)
      is
   begin
      case D.FAT_Style is
         when FAT16 =>
            declare
               FAT16_Table : aliased U16_Array (0 .. 255)
                  with Address    => B (0)'Address,
                       Import     => True,
                       Convention => Ada;
            begin
               FAT16_Table (Entry_Index (D.FAT_Style, Index)) := Unsigned_16 (C);
            end;
         when FAT32 =>
            declare
               FAT32_Table : aliased U32_Array (0 .. 127)
                  with Address    => B (0)'Address,
                       Import     => True,
                       Convention => Ada;
            begin
               FAT32_Table (Entry_Index (D.FAT_Style, Index)) := Unsigned_32 (C);
            end;
         when others =>
            null;
      end case;
   end Entry_Update;

   ----------------------------------------------------------------------------
   -- Update
   ----------------------------------------------------------------------------
   procedure Update
      (D       : in     Descriptor_Type;
       S       : in     Sector_Type;
       B       : in     Block_Type;
       Success :    out Boolean)
      is
      -- compute the FAT sector offset from current FAT sector
      function Sector_Offset (S : Sector_Type) return Sector_Type;
      function Sector_Offset (S : Sector_Type) return Sector_Type is
      begin
         return S - D.FAT_Start (D.FAT_Index);
      end Sector_Offset;
      Offset : constant Sector_Type := Sector_Offset (S);
   begin
      Success := False;
      for Index in D.FAT_Start'Range loop
         if D.FAT_Start (Index) /= 0 then
            IDE.Write (D.Device.all, Physical_Sector (D, D.FAT_Start (Index)) + Offset, B, Success);
            exit when not Success;
         end if;
      end loop;
   end Update;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   procedure Open
      (D               : in out Descriptor_Type;
       Partition_Start : in     Sector_Type;
       Success         :    out Boolean)
      is
      Bootrecord             : Bootrecord_Type;
      Tmp_Sector_Size        : Unsigned_16;
      Tmp_NFATs              : NFATs_Type;
      Tmp_Number_Of_Clusters : Unsigned_32;
      Sector                 : Sector_Type;
      FAT32_Flag             : Boolean;
      procedure Swap_Data
         (B : in out Block_Type);
      function BR_Is_FAT32
         return Boolean;
      function BR_Sectors_Per_FAT
         return Unsigned_32;
      function BR_Total_Sectors
         return Unsigned_32;
      function BR_Total_Clusters
         return Unsigned_32;
      --------------------------------------------
      procedure Swap_Data
         (B : in out Block_Type)
         is
         Values : Byte_Array (0 .. 511)
            with Address    => B'Address,
                 Volatile   => True,
                 Convention => Ada;
      begin
         Byte_Swap_16 (Values (Bootrecord.Bytes_Per_Sector'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Reserved_Sectors'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Root_Directory_Entries'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Total_Sectors_in_FS'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Sectors_Per_FAT'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Sectors_Per_Track'Position)'Address);
         Byte_Swap_16 (Values (Bootrecord.Disk_Heads'Position)'Address);
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
      function BR_Is_FAT32
         return Boolean
         is
      begin
         return Bootrecord.Sectors_Per_FAT = 0;
      end BR_Is_FAT32;
      -----------------------------------------------
      function BR_Sectors_Per_FAT
         return Unsigned_32
         is
      begin
         if not BR_Is_FAT32 then
            return Unsigned_32 (Bootrecord.Sectors_Per_FAT);
         else
            return Bootrecord.Sectors_Per_FAT_32;
         end if;
      end BR_Sectors_Per_FAT;
      ---------------------------------------------
      function BR_Total_Sectors
         return Unsigned_32
         is
      begin
         if not BR_Is_FAT32 then
            return Unsigned_32 (Bootrecord.Total_Sectors_in_FS);
         else
            return Bootrecord.Total_Sectors_32;
         end if;
      end BR_Total_Sectors;
      ----------------------------------------------
      function BR_Total_Clusters
         return Unsigned_32
         is
      begin
         return (
                 BR_Total_Sectors -
                 BR_Sectors_Per_FAT * Unsigned_32 (Bootrecord.NFATs) -
                 Unsigned_32 (Bootrecord.Reserved_Sectors)
                ) / Unsigned_32 (Bootrecord.Sectors_Per_Cluster);
      end BR_Total_Clusters;
      ----------------------
   begin
      -------------------------------------------------------------------------
      -- Read FAT bootrecord.
      -------------------------------------------------------------------------
      declare
         B : aliased Block_Type (0 .. 511)
            with Address    => Bootrecord'Address,
                 Import     => True,
                 Convention => Ada;
      begin
         IDE.Read (D.Device.all, Partition_Start, B, Success); -- logical sector #0 in FAT partition
         if BigEndian then
            Swap_Data (B);
         end if;
      end;
      if not Success then
         Console.Print ("Open: unable to read bootrecord.", NL => True);
         return;
      end if;
      ------------------------
      -- Perform basic checks.
      ------------------------
      -- check: Sector_Size = 512
      Tmp_Sector_Size := Bootrecord.Bytes_Per_Sector;
      if Tmp_Sector_Size /= 512 then
         Success := False;
         Console.Print ("Open: sector size is not 512.", NL => True);
         return;
      end if;
      -- check: 0 < NFATs <= FAT_Start'Length
      Tmp_NFATs := NFATs_Type (Bootrecord.NFATs);
      if Tmp_NFATs < 1 or else Tmp_NFATs > D.FAT_Start'Length then
         Success := False;
         Console.Print ("Open: wrong # of FATs.", NL => True);
         return;
      end if;
      -- check: FAT32
      FAT32_Flag := BR_Is_FAT32;
      Tmp_Number_Of_Clusters := BR_Total_Clusters;
      if not FAT32_Flag then
         D.FAT_Style := FAT16;
         Console.Print ("Filesystem_Open: FAT16 detected.", NL => True);
      elsif Tmp_Number_Of_Clusters < 268_435_457 then
         D.FAT_Style := FAT32;
         Console.Print ("Open: FAT32 detected.", NL => True);
      else
         Success := False;
         Console.Print ("Open: FAT unknown.", NL => True);
         return;
      end if;
      -- filesystem looks correct, validate definitions
      D.Sector_Size := Tmp_Sector_Size;
      D.NFATs := Tmp_NFATs;
      -- Number_Of_Clusters := Tmp_Number_Of_Clusters;
      ----------------------------------------------------------------------
      -- Compute vital informations about filesystem layout.
      -- NOTE: this sequence of code should not be altered because of sector
      -- back-to-back arithmetic.
      ----------------------------------------------------------------------
      D.Sectors_Per_Cluster := Unsigned_16 (Bootrecord.Sectors_Per_Cluster);
      D.Sectors_Per_FAT := BR_Sectors_Per_FAT;
      -- compute the start of each FAT table
      Sector := Sector_Type (Bootrecord.Reserved_Sectors);
      for Index in D.FAT_Start'Range loop
         if Index <= D.NFATs then
            D.FAT_Start (Index) := Sector;
            Sector := @ + Sector_Type (D.Sectors_Per_FAT);
         else
            D.FAT_Start (Index) := 0; -- invalid
         end if;
      end loop;
      -- now we know how many FATs are present, and where the root directory is
      -- located
      D.FAT_Index := D.FAT_Start'First; -- 1st FAT
      if FAT32_Flag then
         D.Cluster_Start := Sector;
         -- FAT32: root directory is in a data cluster
         D.Root_Directory_Cluster := Cluster_Type (Bootrecord.Root_Directory_First_Cluster);
         D.Root_Directory_Start := To_Sector (D, D.Root_Directory_Cluster);
      else
         -- FAT16: root directory is after FATs
         D.Root_Directory_Cluster := 0;
         D.Root_Directory_Start := Sector;
         D.Root_Directory_Entries := Bootrecord.Root_Directory_Entries;
         -- compute the start of the data clusters
         Sector := @ + Sector_Type (((D.Root_Directory_Entries * 32) + (D.Sector_Size - 1)) / D.Sector_Size);
         D.Cluster_Start := Sector;
      end if;
      -- other parameters
      D.Next_Writable_Cluster := 0;
      D.Search_Cluster := 0;
      -- initialize filesystem date/time
      if D.FS_Time.Year = 0 then
         D.FS_Time.Year   := Year_Type (2010 - 1980);
         D.FS_Time.Month  := 9;
         D.FS_Time.Day    := 3;
         D.FS_Time.Hour   := 11;
         D.FS_Time.Minute := 21;
         D.FS_Time.Second := 0;
      end if;
      D.Sector_Start := Partition_Start;
      D.FAT_Is_Open := True;
      -- debug
      if True then
         Console.Print (Integer (Bootrecord.Reserved_Sectors),  Prefix => "Reserved_Sectors:    ", NL => True);
         Console.Print (Integer (Bootrecord.Hidden_Sectors_32), Prefix => "Hidden_Sectors_32:   ", NL => True);
         Console.Print (Integer (D.Sector_Size),                Prefix => "Sector_Size:         ", NL => True);
         Console.Print (Integer (D.Sectors_Per_Cluster),        Prefix => "Sectors_Per_Cluster: ", NL => True);
         Console.Print (Integer (D.Sectors_Per_FAT),            Prefix => "Sectors_Per_FAT:     ", NL => True);
      end if;
      -------
   end Open;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   procedure Close
      (D : in out Descriptor_Type)
      is
   begin
      D.FAT_Style := FATNONE;
      D.FAT_Is_Open := False;
   end Close;

end FATFS;
