-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-directory.adb                                                                                       --
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
with FATFS.Filename;

package body FATFS.Directory
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if DCB is valid (and open it).
   ----------------------------------------------------------------------------
   function Is_Valid
      (D   : in Descriptor_Type;
       DCB : in DCB_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Is_Deleted
   ----------------------------------------------------------------------------
   -- Return true if directory entry has been deleted.
   ----------------------------------------------------------------------------
   function Is_Deleted
      (DE : in Directory_Entry_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   -- Check for directory EOF.
   ----------------------------------------------------------------------------
   function Is_End
      (D   : in Descriptor_Type;
       DCB : in DCB_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   -- Return True if directory entry is EOF.
   ----------------------------------------------------------------------------
   function Is_End
      (DE : in Directory_Entry_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a directory.
   ----------------------------------------------------------------------------
   procedure Rewind
      (D   : in     Descriptor_Type;
       DCB : in out DCB_Type);

   ----------------------------------------------------------------------------
   -- Cluster_Init
   ----------------------------------------------------------------------------
   -- Initialize a directory block to be full of end entries.
   ----------------------------------------------------------------------------
   procedure Cluster_Init
      (D       : in     Descriptor_Type;
       B       :    out Block_Type;
       C       : in     Cluster_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Init
   ----------------------------------------------------------------------------
   -- Initialize a new directory entry.
   ----------------------------------------------------------------------------
   procedure Entry_Init
      (D    : in     Descriptor_Type;
       DE   :    out Directory_Entry_Type;
       Last : in     Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Get_Raw
   ----------------------------------------------------------------------------
   -- Return the current directory entry.
   ----------------------------------------------------------------------------
   procedure Entry_Get_Raw
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Next_Raw
   ----------------------------------------------------------------------------
   -- Return the next directory entry.
   ----------------------------------------------------------------------------
   procedure Entry_Next_Raw
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Allocate
   ----------------------------------------------------------------------------
   procedure Entry_Allocate
      (D       : in out Descriptor_Type;
       DCB     : in out DCB_Type;
       B       : in out Block_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   function Is_Valid
      (D   : in Descriptor_Type;
       DCB : in DCB_Type)
      return Boolean
      is
   begin
      if D.FAT_Is_Open and then D.Root_Directory_Start >= 0 then
         return DCB.Magic = MAGIC_DIR;
      else
         return False;
      end if;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Deleted
   ----------------------------------------------------------------------------
   function Is_Deleted
      (DE : in Directory_Entry_Type)
      return Boolean
      is
   begin
      return Character'Pos (DE.File_Name (DE.File_Name'First)) = 16#E5#;
   end Is_Deleted;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   function Is_End
      (D   : in Descriptor_Type;
       DCB : in DCB_Type)
      return Boolean
      is
   begin
      if not Is_Valid (D, DCB) then
         return False;
      elsif DCB.CCB.First_Cluster < 2 then
         return DCB.Current_Index >= DCB.Directory_Entries;
      else
         return Cluster.Is_End (DCB.CCB);
      end if;
   end Is_End;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   function Is_End
      (DE : in Directory_Entry_Type)
      return Boolean
      is
   begin
      return Character'Pos (DE.File_Name (DE.File_Name'First)) = 0;
   end Is_End;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   procedure Rewind
      (D   : in     Descriptor_Type;
       DCB : in out DCB_Type)
      is
   begin
      if Is_Valid (D, DCB) then
         Cluster.Rewind (D, DCB.CCB);
         DCB.Current_Index := 0;
      end if;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Cluster_Init
   ----------------------------------------------------------------------------
   procedure Cluster_Init
      (D       : in     Descriptor_Type;
       B       :    out Block_Type;
       C       : in     Cluster_Type;
       Success :    out Boolean)
      is
      S :          Sector_Type := Cluster.To_Sector (D, C);
      E : constant Sector_Type := S + Sector_Type (D.Sectors_Per_Cluster) - 1;
   begin
      B := [others => 0];
      Success := True;
      loop
         exit when S > E;
         IDE.Write (D.Device.all, Physical_Sector (D, S), B, Success);
         exit when not Success;
         S := @ + 1;
      end loop;
   end Cluster_Init;

   ----------------------------------------------------------------------------
   -- Entry_Init
   ----------------------------------------------------------------------------
   procedure Entry_Init
      (D    : in     Descriptor_Type;
       DE   :    out Directory_Entry_Type;
       Last : in     Boolean)
      is
   begin
      DE.File_Name        := [others => ' '];
      DE.Extension        := [others => ' '];
      DE.File_Attributes  := (others => False);
      DE.Reserved         := 0;
      DE.Ctime_HMS.Hour   := D.FS_Time.Hour;
      DE.Ctime_HMS.Minute := D.FS_Time.Minute;
      DE.Ctime_HMS.Second := D.FS_Time.Second;
      DE.Ctime_YMD.Year   := D.FS_Time.Year;
      DE.Ctime_YMD.Month  := D.FS_Time.Month;
      DE.Ctime_YMD.Day    := D.FS_Time.Day;
      DE.Size             := 0;
      Cluster.Put_First (D, DE, Cluster.File_EOF (D.FAT_Style));
      if Last then
         -- end of directory marker
         DE.File_Name (1) := Character'Val (0);
      end if;
   end Entry_Init;

   ----------------------------------------------------------------------------
   -- Entry_Get_Raw
   ----------------------------------------------------------------------------
   procedure Entry_Get_Raw
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean)
      is
      B : aliased Block_Type (0 .. 511);
   begin
      if Is_End (D, DCB) then
         Cluster.Advance (D, DCB.CCB, B, Success);
         if not Success then
            -- non-end directory character
            DE.File_Name (1) := Character'Val (1);
            return;
         end if;
      end if;
      Cluster.Peek (D, DCB.CCB, B, Success);
      if not Success then
         -- non-end directory character
         DE.File_Name (1) := Character'Val (1);
         return;
      end if;
      declare
         DEA   : aliased Directory_Entry_Array (0 .. D.Sector_Size / DIRECTORY_ENTRY_SIZE - 1)
            with Alignment  => BLOCK_ALIGNMENT,
                 Address    => B'Address,
                 Import     => True,
                 Convention => Ada;
         Index : constant Unsigned_16 := DCB.Current_Index mod (D.Sector_Size / DIRECTORY_ENTRY_SIZE);
      begin
         if BigEndian then
            Byte_Swap_16 (DEA (Index).File_Attributes'Address);
            Byte_Swap_16 (DEA (Index).Ctime_HMS'Address);
            Byte_Swap_16 (DEA (Index).Ctime_YMD'Address);
            Byte_Swap_16 (DEA (Index).Atime_YMD'Address);
            Byte_Swap_16 (DEA (Index).Cluster_H'Address);
            Byte_Swap_16 (DEA (Index).Wtime_HMS'Address);
            Byte_Swap_16 (DEA (Index).Wtime_YMD'Address);
            Byte_Swap_16 (DEA (Index).Cluster_1st'Address);
            Byte_Swap_32 (DEA (Index).Size'Address);
         end if;
         DE := DEA (Index);
      end;
      if Is_End (DE) then
         Success := False;
      else
         Success := True;
      end if;
   end Entry_Get_Raw;

   ----------------------------------------------------------------------------
   -- Entry_Next_Raw
   ----------------------------------------------------------------------------
   procedure Entry_Next_Raw
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean)
      is
      B : Block_Type (0 .. 511);
   begin
      if Is_End (D, DCB) then
         Cluster.Advance (D, DCB.CCB, B, Success);
         if not Success then
            -- non-end directory character
            DE.File_Name (1) := Character'Val (1);
            return;
         end if;
      end if;
      DCB.Current_Index := @ + 1;
      if DCB.Current_Index mod (D.Sector_Size / DIRECTORY_ENTRY_SIZE) = 0 then
         Cluster.Advance (D, DCB.CCB, B, Success);
      else
         Success := True;
      end if;
      if Success then
         Entry_Get_Raw (D, DCB, DE, Success);
      end if;
   end Entry_Next_Raw;

   ----------------------------------------------------------------------------
   -- Entry_Allocate
   ----------------------------------------------------------------------------
   procedure Entry_Allocate
      (D       : in out Descriptor_Type;
       DCB     : in out DCB_Type;
       B       : in out Block_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean)
      is
      New_Cluster : Cluster_Type := 0;
   begin
      -- locate a deleted entry, if any
      Rewind (D, DCB);
      Entry_Get_Raw (D, DCB, DE, Success);
      loop
         exit when not Success;
         exit when Is_Deleted (DE);
         Entry_Next_Raw (D, DCB, DE, Success);
      end loop;
      if Success then
         -- reuse a deleted entry
         Entry_Init (D, DE, False);
         Entry_Update
            (D,
             DCB.CCB.Current_Sector,
             DE,
             DCB.Current_Index,
             Success);
         return;
      end if;
      -- allocate a new directory entry
      Entry_Init (D, DE, True);
      if not Is_End (D, DCB) and then Is_End (DE) then
         Success := True;
         -- use end marker entry
         return;
      end if;
      -- see if there is a next cluster, or extend if necessary
      if DCB.CCB.First_Cluster >= 2 then
         -- claim reserved cluster
         New_Cluster := D.Next_Writable_Cluster;
         if New_Cluster >= 2 then
            -- put EOF marker in FAT to claim it
            Cluster.Claim (D, B, New_Cluster, Cluster.File_EOF (D.FAT_Style), Success);
         else
            -- no space left
            Success := False;
         end if;
         if not Success then
            return;
         end if;
         -- init as new directory cluster
         Cluster_Init (D, B, New_Cluster, Success);
         if Success then
            -- link current cluster to next
            Cluster.Claim (D, B, DCB.CCB.Cluster, New_Cluster, Success);
         end if;
         if not Success then
            return;
         end if;
         Cluster.Open (D, DCB.CCB, New_Cluster, Keep_First => True);
         D.Next_Writable_Cluster := 0;
      else
         -- fixed size directory
         Cluster.Advance (D, DCB.CCB, B, Success);
         if not Success then
            -- no space or I/O error
            return;
         end if;
      end if;
      Entry_Update
         (D,
          DCB.CCB.Current_Sector,
          DE,
          DCB.Current_Index + 0,
          Success);
   end Entry_Allocate;

   ----------------------------------------------------------------------------
   -- Open_Root
   ----------------------------------------------------------------------------
   procedure Open_Root
      (D       : in     Descriptor_Type;
       DCB     :    out DCB_Type;
       Success :    out Boolean)
      is
   begin
      Success := False;
      if not D.FAT_Is_Open then
         DCB.Magic := 0;
         return;
      end if;
      if D.Root_Directory_Cluster = 0 then
         Cluster.Map (
            DCB.CCB,
            D.Root_Directory_Start,
            D.Root_Directory_Entries * DIRECTORY_ENTRY_SIZE / D.Sector_Size
            );
         DCB.Directory_Entries := D.Root_Directory_Entries;
      else
         Cluster.Open (D, DCB.CCB, D.Root_Directory_Cluster, Keep_First => False);
         DCB.Directory_Entries := D.Sectors_Per_Cluster * D.Sector_Size / DIRECTORY_ENTRY_SIZE;
      end if;
      DCB.Current_Index := 0;
      DCB.Magic         := MAGIC_DIR;
      Success := True;
   end Open_Root;

   ----------------------------------------------------------------------------
   -- Entry_Get
   ----------------------------------------------------------------------------
   procedure Entry_Get
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean)
      is
   begin
      Entry_Get_Raw (D, DCB, DE, Success);
      loop
         exit when not Success
                   or else
                   (not Is_Deleted (DE) and then
                    not DE.File_Attributes.Volume_Name);
         Entry_Next_Raw (D, DCB, DE, Success);
      end loop;
   end Entry_Get;

   ----------------------------------------------------------------------------
   -- Entry_Next
   ----------------------------------------------------------------------------
   procedure Entry_Next
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean)
      is
   begin
      loop
         Entry_Next_Raw (D, DCB, DE, Success);
         exit when not Success
                   or else
                   (not Is_Deleted (DE) and then
                    not DE.File_Attributes.Volume_Name);
      end loop;
   end Entry_Next;

   ----------------------------------------------------------------------------
   -- Search
   ----------------------------------------------------------------------------
   procedure Search
      (D              : in     Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean)
      is
   begin
      if not Is_Valid (D, DCB) then
         Success := False;
         return;
      end if;
      Rewind (D, DCB);
      Entry_Get (D, DCB, DE, Success);
      loop
         exit when not Success;
         declare
            Entry_Name : String (1 .. 12);
         begin
            Filename.Get (DE, Entry_Name);
            -- __FIX__ ???
            -- Charutils.UcaseString (Entry_Name);
            -- if String_Equal_Nocase (Entry_Name, Directory_Name) then
            if Entry_Name = Directory_Name then
               return;
            end if;
         end;
         Entry_Next (D, DCB, DE, Success);
      end loop;
      Success := False;
   end Search;

   ----------------------------------------------------------------------------
   -- Entry_Create
   ----------------------------------------------------------------------------
   procedure Entry_Create
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean)
      is
      Base : String (1 .. 8);
      Ext  : String (1 .. 3);
   begin
      Search (D, DCB, DE, Directory_Name, Success);
      if Success then
         -- file already exists
         Success := False;
         return;
      end if;
      -- parse file name into directory format
      Filename.Parse (Base, Ext, Directory_Name, Success);
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511);
      begin
         Cluster.Prelocate (D, B);
         -- locate a deleted entry or make a new entry
         Entry_Allocate (D, DCB, B, DE, Success);
         if not Success then
            -- no space left
            return;
         end if;
      end;
      DE.File_Name               := Base;
      DE.Extension               := Ext;
      DE.File_Attributes.Archive := True;
   end Entry_Create;

   ----------------------------------------------------------------------------
   -- Entry_Update
   ----------------------------------------------------------------------------
   procedure Entry_Update
      (D       : in     Descriptor_Type;
       Sector  : in     Sector_Type;
       DE      : in     Directory_Entry_Type;
       Index   : in     Unsigned_16;
       Success :    out Boolean)
      is
      B           : aliased Block_Type (0 .. 511);
      Dir_Entries : aliased Directory_Entry_Array (0 .. 15)
         with Address    => B'Address,
              Import     => True,
              Convention => Ada;
   begin
      IDE.Read (D.Device.all, Physical_Sector (D, Sector), B, Success);
      if Success then
         Dir_Entries (Index mod 16) := DE;
         IDE.Write (D.Device.all, Physical_Sector (D, Sector), B, Success);
      end if;
   end Entry_Update;

   ----------------------------------------------------------------------------
   -- Subdirectory_Create
   ----------------------------------------------------------------------------
   procedure Subdirectory_Create
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       Directory_Name : in     String;
       Success        :    out Boolean)
      is
      DE          : Directory_Entry_Type;
      New_Cluster : Cluster_Type := 0;
   begin
      Entry_Create (D, DCB, DE, Directory_Name, Success);
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511) with Unreferenced => True;
      begin
         -- get a free cluster for subdirectory
         Cluster.Prelocate (D, B);
         if D.Next_Writable_Cluster = 0 then
            -- no space
            Success := False;
            return;
         end if;
         New_Cluster := D.Next_Writable_Cluster;
         -- assign cluster to subdirectory entry
         Cluster.Put_First (D, DE, D.Next_Writable_Cluster);
         -- mark it as in use
         Cluster.Claim (D, B, New_Cluster, Cluster.File_EOF (D.FAT_Style), Success);
         if Success then
            -- replace free cluster, that we used
            Cluster.Prelocate (D, B);
            -- initialize with end directory entries
            Cluster_Init (D, B, New_Cluster, Success);
            if Success then
               DE.File_Attributes.Subdirectory := True;
               Entry_Update
                  (D,
                   DCB.CCB.Current_Sector,
                   DE,
                   DCB.Current_Index,
                   Success);
            end if;
         end if;
      end;
   end Subdirectory_Create;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   procedure Close
      (DCB : in out DCB_Type)
      is
   begin
      Cluster.Close (DCB.CCB);
      DCB.Magic := 0;
   end Close;

end FATFS.Directory;
