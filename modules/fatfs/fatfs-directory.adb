-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-directory.adb                                                                                       --
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

with FATFS.Cluster;
with FATFS.Filename;

package body FATFS.Directory is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_Valid (DCB : DCB_Type) return Boolean with
      Inline => True;

   function Is_Deleted (DE : Directory_Entry_Type) return Boolean with
      Inline => True;

   function Is_End (DCB : DCB_Type) return Boolean;

   function Is_End (DE : Directory_Entry_Type) return Boolean;

   procedure Init_Entry (DE : out Directory_Entry_Type; Last : in Boolean);

   procedure Init_Cluster (
                           B       : out Block_Type;
                           C       : in  Cluster_Type;
                           Success : out Boolean
                          );

   procedure Allocate_Entry (
                             DCB     : in out DCB_Type;
                             B       : in out Block_Type;
                             DE      : out    Directory_Entry_Type;
                             Success : out    Boolean
                            );

   procedure Rewind (DCB : in out DCB_Type);

   procedure Get_Entry_Raw (
                            DCB     : in out DCB_Type;
                            DE      : out    Directory_Entry_Type;
                            Success : out    Boolean
                           );

   procedure Next_Entry_Raw (
                             DCB     : in out DCB_Type;
                             DE      : out    Directory_Entry_Type;
                             Success : out    Boolean
                            );

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
   -- Return True if DCB is valid (and open it).
   ----------------------------------------------------------------------------
   function Is_Valid (DCB : DCB_Type) return Boolean is
   begin
      if FAT_Is_Open and then Root_Directory_Start >= 0 then
         return DCB.Magic = MAGIC_DIR;
      else
         return False;
      end if;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Deleted
   ----------------------------------------------------------------------------
   -- Return true if directory entry has been deleted.
   ----------------------------------------------------------------------------
   function Is_Deleted (DE : Directory_Entry_Type) return Boolean is
   begin
      return Character'Pos (DE.Filename (DE.Filename'First)) = 16#E5#;
   end Is_Deleted;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   -- Check for directory EOF.
   ----------------------------------------------------------------------------
   function Is_End (DCB : DCB_Type) return Boolean is
   begin
      if not Is_Valid (DCB) then
         return False; -- bad directory entry
      elsif DCB.CCB.First_Cluster < 2 then
         return DCB.Current_Index >= DCB.Directory_Entries;
      else
         return Cluster.Is_End (DCB.CCB);
      end if;
   end Is_End;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   -- Return True if directory entry is EOF.
   ----------------------------------------------------------------------------
   function Is_End (DE : Directory_Entry_Type) return Boolean is
   begin
      return Character'Pos (DE.Filename (DE.Filename'First)) = 0;
   end Is_End;

   ----------------------------------------------------------------------------
   -- Get_Entry_Raw
   ----------------------------------------------------------------------------
   -- Return the current directory entry.
   ----------------------------------------------------------------------------
   procedure Get_Entry_Raw (
                            DCB     : in out DCB_Type;
                            DE      : out    Directory_Entry_Type;
                            Success : out    Boolean
                           ) is
         B : aliased Block_Type (0 .. 511);
   begin
      if Is_End (DCB) then
         Cluster.Advance (DCB.CCB, B, Success);
         if not Success then
            DE.Filename (1) := Character'Val (1); -- non-end directory character
            return;
         end if;
      end if;
      Cluster.Peek (DCB.CCB, B, Success);
      if not Success then
         DE.Filename (1) := Character'Val (1); -- non-end directory character
         return;
      end if;
      declare
         D     : aliased Directory_Entry_Array (0 .. Sector_Size / 32 - 1) with
            Alignment  => BLOCK_ALIGNMENT,
            Address    => B'Address,
            Import     => True,
            Convention => Ada;
         Index : constant Unsigned_16 := DCB.Current_Index mod (Sector_Size / 32);
      begin
         -- __PTC__ endian
         D (Index).Cluster_High  := LE_To_CPUE (D (Index).Cluster_High);
         D (Index).First_Cluster := LE_To_CPUE (D (Index).First_Cluster);
         D (Index).Size          := LE_To_CPUE (D (Index).Size);
         -- __PTC__ endian
         DE := D (Index);
      end;
      if Is_End (DE) then
         Success := False; -- end of directory
      else
         Success := True;
      end if;
   end Get_Entry_Raw;

   ----------------------------------------------------------------------------
   -- Next_Entry_Raw
   ----------------------------------------------------------------------------
   -- Return the next directory entry.
   ----------------------------------------------------------------------------
   procedure Next_Entry_Raw (
                             DCB     : in out DCB_Type;
                             DE      : out    Directory_Entry_Type;
                             Success : out    Boolean
                            ) is
      B : Block_Type (0 .. 511);
   begin
      if Is_End (DCB) then
         Cluster.Advance (DCB.CCB, B, Success);
         if not Success then
            DE.Filename (1) := Character'Val (1); -- non-end directory character
            return;
         end if;
      end if;
      DCB.Current_Index := DCB.Current_Index + 1;
      if DCB.Current_Index mod (Sector_Size / 32) = 0 then
         Cluster.Advance (DCB.CCB, B, Success);
      else
         Success := True;
      end if;
      if Success then
         Get_Entry_Raw (DCB, DE, Success);
      end if;
   end Next_Entry_Raw;

   ----------------------------------------------------------------------------
   -- Open_Root
   ----------------------------------------------------------------------------
   -- Open the root directory.
   ----------------------------------------------------------------------------
   procedure Open_Root (DCB : out DCB_Type; Success : out Boolean) is
   begin
      Success := False;
      if not FAT_Is_Open then
         DCB.Magic := 0;
         return;
      end if;
      if Root_Directory_Cluster = 0 then
         Cluster.Map (DCB.CCB, Root_Directory_Start, Root_Directory_Entries * 32 / Sector_Size);
         DCB.Directory_Entries := Root_Directory_Entries;
      else
         Cluster.Open (DCB.CCB, Root_Directory_Cluster, Keep_First => False);
         DCB.Directory_Entries := Sectors_Per_Cluster * Sector_Size / 32;
      end if;
      DCB.Current_Index := 0;
      DCB.Magic         := MAGIC_DIR;
      Success := True;
   end Open_Root;

   ----------------------------------------------------------------------------
   -- Get_Entry
   ----------------------------------------------------------------------------
   -- Return the current directory entry (application).
   ----------------------------------------------------------------------------
   procedure Get_Entry (
                        DCB     : in out DCB_Type;
                        DE      : out    Directory_Entry_Type;
                        Success : out    Boolean
                       ) is
   begin
      Get_Entry_Raw (DCB, DE, Success);
      loop
         exit when not Success;
         exit when not Is_Deleted (DE) and then not DE.File_Attributes.Volume_Name;
         Next_Entry_Raw (DCB, DE, Success);
      end loop;
   end Get_Entry;

   ----------------------------------------------------------------------------
   -- Next_Entry
   ----------------------------------------------------------------------------
   -- Return the next directory entry (application).
   ----------------------------------------------------------------------------
   procedure Next_Entry (
                         DCB     : in out DCB_Type;
                         DE      : out    Directory_Entry_Type;
                         Success : out    Boolean
                        ) is
   begin
      loop
         Next_Entry_Raw (DCB, DE, Success);
         exit when not Success;
         exit when not Is_Deleted (DE) and then not DE.File_Attributes.Volume_Name;
      end loop;
   end Next_Entry;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a directory.
   ----------------------------------------------------------------------------
   procedure Rewind (DCB : in out DCB_Type) is
   begin
      if Is_Valid (DCB) then
         Cluster.Rewind (DCB.CCB);
         DCB.Current_Index := 0;
      end if;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Search
   ----------------------------------------------------------------------------
   -- Search a directory for a file name or subdirectory name.
   ----------------------------------------------------------------------------
   procedure Search (
                     DCB            : in out DCB_Type;
                     DE             : out    Directory_Entry_Type;
                     Directory_Name : in     String;
                     Success        : out    Boolean
                    ) is
   begin
      if not Is_Valid (DCB) then
         Success := False;
         return;
      end if;
      Rewind (DCB);
      Get_Entry (DCB, DE, Success);
      loop
         exit when not Success;
         declare
            Entry_Name : String (1 .. 12);
         begin
            Filename.Get_Name (DE, Entry_Name);
            -- __FIX__ ???
            -- Charutils.UcaseString (Entry_Name);
            -- if String_Equal_Nocase (Entry_Name, Directory_Name) then
            if Entry_Name = Directory_Name then
               return;
            end if;
         end;
         Next_Entry (DCB, DE, Success);
      end loop;
      Success := False; -- not found
   end Search;

   ----------------------------------------------------------------------------
   -- Init_Entry
   ----------------------------------------------------------------------------
   -- Initialize a new directory entry.
   ----------------------------------------------------------------------------
   procedure Init_Entry (DE : out Directory_Entry_Type; Last : in Boolean) is
   begin
      DE.Filename        := (others => ' ');
      DE.Extension       := (others => ' ');
      DE.File_Attributes := (others => False);
      DE.Reserved        := (others => 0);
      DE.HMS.Hour        := FS_Time.Hour;
      DE.HMS.Minute      := FS_Time.Minute;
      DE.HMS.Second      := FS_Time.Second;
      DE.YMD.Year        := FS_Time.Year;
      DE.YMD.Month       := FS_Time.Month;
      DE.YMD.Day         := FS_Time.Day;
      DE.Size            := 0;
      Cluster.Put_First (DE, Cluster.File_EOF);
      if Last then
         DE.Filename (1) := Character'Val (0); -- end of directory marker
      end if;
   end Init_Entry;

   ----------------------------------------------------------------------------
   -- Init_Cluster
   ----------------------------------------------------------------------------
   -- Initialize a directory block to be full of end entries.
   ----------------------------------------------------------------------------
   procedure Init_Cluster (
                                 B       : out Block_Type;
                                 C       : in  Cluster_Type;
                                 Success : out Boolean
                                ) is
      S :          Sector_Type := Cluster.To_Sector (C);
      E : constant Sector_Type := S + Sector_Type (Sectors_Per_Cluster) - 1;
   begin
      B := (others => 0);
      Success := True;
      loop
         exit when S > E;
         IO_Context.Write (Physical_Sector (S), B, Success);
         exit when not Success;
         S := S + 1;
      end loop;
   end Init_Cluster;

   ----------------------------------------------------------------------------
   -- Allocate_Entry
   ----------------------------------------------------------------------------
   -- Locate a deleted directory or allocate a new one.
   ----------------------------------------------------------------------------
   procedure Allocate_Entry (
                             DCB     : in out DCB_Type;
                             B       : in out Block_Type;
                             DE      : out    Directory_Entry_Type;
                             Success : out    Boolean
                            ) is
      New_Cluster : Cluster_Type := 0;
   begin
      -- locate a deleted entry, if any
      Rewind (DCB);
      Get_Entry_Raw (DCB, DE, Success);
      loop
         exit when not Success;
         exit when Is_Deleted (DE);
         Next_Entry_Raw (DCB, DE, Success);
      end loop;
      if Success then
         -- reuse a deleted entry
         Init_Entry (DE, False);
         Update_Entry (
                       DCB.CCB.Current_Sector,
                       DE,
                       DCB.Current_Index,
                       Success
                      );
         return;
      end if;
      -- must allocate a new directory entry
      Init_Entry (DE, True);
      if not Is_End (DCB) and then Is_End (DE) then
         Success := True;
         return; -- use end marker entry
      end if;
      -- see if there is a next cluster, or extend if necessary
      if DCB.CCB.First_Cluster >= 2 then
         New_Cluster := Next_Writable_Cluster;       -- claim reserved cluster
         if New_Cluster >= 2 then
            Cluster.Claim (B, New_Cluster, Success); -- put EOF marker in FAT to claim it
         else
            Success := False;                        -- no space left
         end if;
         if not Success then
            return;
         end if;
         Init_Cluster (B, New_Cluster, Success); -- init as new directory cluster
         if Success then
            Cluster.Claim (B, DCB.CCB.Cluster, Success, New_Cluster); -- link current cluster to next
         end if;
         if not Success then
            return;
         end if;
         Cluster.Open (DCB.CCB, New_Cluster, Keep_First => True);
         Next_Writable_Cluster := 0;
      else
         Cluster.Advance (DCB.CCB, B, Success); -- fixed size directory
         if not Success then
            return; -- no space or I/O error
         end if;
      end if;
      Update_Entry (
                    DCB.CCB.Current_Sector,
                    DE,
                    DCB.Current_Index + 0,
                    Success -- new entry for now ...
                   );
   end Allocate_Entry;

   ----------------------------------------------------------------------------
   -- Create_Entry
   ----------------------------------------------------------------------------
   -- Create a new directory entry by name.
   ----------------------------------------------------------------------------
   procedure Create_Entry (
                           DCB            : in out DCB_Type;
                           DE             : out    Directory_Entry_Type;
                           Directory_Name : in     String;
                           Success        : out    Boolean
                          ) is
      Base : String (1 .. 8);
      Ext  : String (1 .. 3);
   begin
      Search (DCB, DE, Directory_Name, Success);
      if Success then
         Success := False; -- file already exists
         return;
      end if;
      Filename.Parse (Base, Ext, Directory_Name, Success); -- parse file name into directory format
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511);
      begin
         Cluster.Prelocate (B);
         Allocate_Entry (DCB, B, DE, Success); -- locate deleted entry or make new entry
         if not Success then
            return; -- no space left
         end if;
      end;
      DE.Filename                := Base;
      DE.Extension               := Ext;
      DE.File_Attributes.Archive := True;
   end Create_Entry;

   ----------------------------------------------------------------------------
   -- Update_Entry
   ----------------------------------------------------------------------------
   -- Perform a directory sector update.
   ----------------------------------------------------------------------------
   procedure Update_Entry (
                           Sector  : in  Sector_Type;
                           DE      : in  Directory_Entry_Type;
                           Index   : in  Unsigned_16;
                           Success : out Boolean
                          ) is
      B           : aliased Block_Type (0 .. 511);
      Dir_Entries : aliased Directory_Entry_Array (0 .. 15) with
         Address    => B'Address,
         Import     => True,
         Convention => Ada;
   begin
      IO_Context.Read (Physical_Sector (Sector), B, Success);
      if Success then
         Dir_Entries (Index mod 16) := DE;
         IO_Context.Write (Physical_Sector (Sector), B, Success);
      end if;
   end Update_Entry;

   ----------------------------------------------------------------------------
   -- Create_Subdirectory
   ----------------------------------------------------------------------------
   -- Create a subdirectory.
   ----------------------------------------------------------------------------
   procedure Create_Subdirectory (
                                  DCB            : in out DCB_Type;
                                  Directory_Name : in     String;
                                  Success        : out    Boolean
                                 ) is
      DE          : Directory_Entry_Type;
      New_Cluster : Cluster_Type := 0;
   begin
      Create_Entry (DCB, DE, Directory_Name, Success);
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511) with Unreferenced => True;
      begin
         Cluster.Prelocate (B);                            -- get a free cluster for subdirectory
         if Next_Writable_Cluster = 0 then
            Success := False;                              -- no space
            return;
         end if;
         New_Cluster := Next_Writable_Cluster;
         Cluster.Put_First (DE, Next_Writable_Cluster);    -- assign cluster to subdirectory entry
         Cluster.Claim (B, New_Cluster, Success);          -- mark it as in use with fff8 entry
         if Success then
            Cluster.Prelocate (B);                         -- replace free cluster, that we used
            Init_Cluster (B, New_Cluster, Success);        -- initialize with "end dir" entries
            if Success then
               DE.File_Attributes.Subdirectory := True;
               Update_Entry (
                             DCB.CCB.Current_Sector,
                             DE,
                             DCB.Current_Index,
                             Success
                            );
            end if;
         end if;
      end;
   end Create_Subdirectory;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a directory.
   ----------------------------------------------------------------------------
   procedure Close (DCB : in out DCB_Type) is
   begin
      Cluster.Close (DCB.CCB);
      DCB.Magic := 0;
   end Close;

end FATFS.Directory;
