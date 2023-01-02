-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-rawfile.adb                                                                                         --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with FATFS.Cluster;
with FATFS.Directory;

package body FATFS.Rawfile is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_Valid (FCB : FCB_Type) return Boolean with
      Inline => True;

   procedure Finalize_IO (File : in FCB_Type; Count : out Unsigned_16);

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
   -- Return True if FCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid (FCB : FCB_Type) return Boolean is
   begin
      return FCB.Magic = MAGIC_FCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if WCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid (WCB : WCB_Type) return Boolean is
   begin
      return WCB.Magic = MAGIC_WCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Finalize_IO
   ----------------------------------------------------------------------------
   -- Finalize a file I/O operation.
   ----------------------------------------------------------------------------
   procedure Finalize_IO (File : in FCB_Type; Count : out Unsigned_16) is
   begin
      if File.CCB.IO_Bytes >= File.Size then
         Count := Unsigned_16 (File.Size - (File.CCB.IO_Bytes - Unsigned_32 (Sector_Size)));
      else
         Count := Sector_Size;
      end if;
   end Finalize_IO;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a file for I/O.
   ----------------------------------------------------------------------------
   procedure Open (
                   File    : out FCB_Type;
                   DE      : in  Directory_Entry_Type;
                   Success : out Boolean
                  ) is
   begin
      if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
         Success := False;
         return;
      end if;
      Cluster.Open (File.CCB, Cluster.Get_First (DE), Keep_First => False);
      File.Size  := DE.Size;
      File.Magic := MAGIC_FCB;
      Success := True;
   end Open;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a file by name.
   ----------------------------------------------------------------------------
   procedure Open (
                   File      : out    FCB_Type;
                   Dir       : in out DCB_Type;
                   File_Name : in     String;
                   Success   : out    Boolean
                  ) is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (Dir, DE, File_Name, Success);
      if Success then
         Open (File, DE, Success);
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a file.
   ----------------------------------------------------------------------------
   procedure Rewind (File : in out FCB_Type) is
   begin
      if Is_Valid (File) then
         Cluster.Rewind (File.CCB);
      end if;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read one sector of a file.
   ----------------------------------------------------------------------------
   procedure Read (
                   File    : in out FCB_Type;
                   B       : out    Block_Type;
                   Count   : out    Unsigned_16;
                   Success : out    Boolean
                  ) is
   begin
      Count := 0;
      if not Is_Valid (File) or else File.CCB.IO_Bytes >= File.Size then
         Success := False;
         return;
      end if;
      Cluster.Read (File.CCB, B, Success);
      if Success then
         Finalize_IO (File, Count);
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Reread
   ----------------------------------------------------------------------------
   -- Reread the last read sector.
   ----------------------------------------------------------------------------
   procedure Reread (
                     File    : in out FCB_Type;
                     B       : out    Block_Type;
                     Count   : out    Unsigned_16;
                     Success : out    Boolean
                    ) is
   begin
      Count := 0;
      if not Is_Valid (File) then
         Success := False;
         return;
      end if;
      Cluster.Reread (File.CCB, B, Success);
      if Success then
         Finalize_IO (File, Count);
      end if;
   end Reread;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a file.
   ----------------------------------------------------------------------------
   procedure Close (File : in out FCB_Type) is
   begin
      if Is_Valid (File) then
         Cluster.Close (File.CCB);
         File.Magic := 0;
      end if;
   end Close;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a file by name.
   ----------------------------------------------------------------------------
   procedure Open (
                   File      : out    WCB_Type;
                   DCB       : in out DCB_Type;
                   File_Name : in     String;
                   Success   : out    Boolean
                  ) is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (DCB, DE, File_Name, Success);
      if Success then
         if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
            Success := False;
            return;
         end if;
         declare
            B : Block_Type (0 .. 511);
         begin
            Cluster.Release_Chain (Cluster.Get_First (DE), B);
            Cluster.Prelocate (B); -- keep one free cluster at hand
         end;
         Cluster.Put_First (DE, Cluster.File_EOF);
         Cluster.Open (File.CCB, Cluster.Get_First (DE), Keep_First => False);
         File.Directory_Index  := DCB.Current_Index;      -- remember which directory entry this is
         File.Directory_Sector := DCB.CCB.Current_Sector; -- remember where directory entry is
         File.Magic            := MAGIC_WCB;
         File.Last_Sector      := 0;
         Success := True;
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Create
   ----------------------------------------------------------------------------
   -- Create a new file.
   ----------------------------------------------------------------------------
   procedure Create (
                     File      : out    WCB_Type;
                     DCB       : in out DCB_Type;
                     File_Name : in     String;
                     Success   : out    Boolean
                    ) is
      DE : Directory_Entry_Type;
   begin
      Directory.Create_Entry (DCB, DE, File_Name, Success); -- allocate and create a new directory entry
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511) with Unreferenced => True;
      begin
         Directory.Update_Entry (
                                 DCB.CCB.Current_Sector,
                                 DE,
                                 DCB.Current_Index,
                                 Success
                                );
         Cluster.Prelocate (B); -- keep next free cluster
      end;
      if Success then
         Cluster.Open (File.CCB, Cluster.Get_First (DE), Keep_First => False);
         File.Directory_Index  := DCB.Current_Index;      -- remember which directory entry this is
         File.Directory_Sector := DCB.CCB.Current_Sector; -- remember where directory entry is
         File.Magic            := MAGIC_WCB;
         File.Last_Sector      := 0;
         Success := True;
      end if;
   end Create;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   -- Write to the open file.
   ----------------------------------------------------------------------------
   procedure Write (
                    File    : in out WCB_Type;
                    B       : in out Block_Type;
                    Count   : in     Unsigned_16;
                    Success : out    Boolean
                   ) is
   begin
      if not Is_Valid (File) or else Count > B'Length or else Count = 0 then
         Success := False;
         return;
      end if;
      -- clear excess portion of block, if any
      if Count < B'Length then
         B (Natural (Count) .. B'Last) := [others => 0];
      end if;
      Cluster.Write (File, B, Success);
      if Success then
         File.Last_Sector := Count;
      end if;
   end Write;

   ----------------------------------------------------------------------------
   -- Rewrite
   ----------------------------------------------------------------------------
   -- Rewrite the last written block.
   ----------------------------------------------------------------------------
   procedure Rewrite (
                      File    : in out WCB_Type;
                      B       : in     Block_Type;
                      Count   : in     Unsigned_16;
                      Success : out    Boolean
                     ) is
   begin
      if not Is_Valid (File) or else File.CCB.Previous_Sector = 0 then
         Success := False;
         return;
      end if;
      IO_Context.Write (Physical_Sector (File.CCB.Previous_Sector), B, Success);
      if Success then
         File.Last_Sector := Count;
      end if;
   end Rewrite;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a file opened for write.
   ----------------------------------------------------------------------------
   procedure Close (File : in out WCB_Type; Success : out Boolean) is
   begin
      Sync (File, Success);
      if Success then
         Cluster.Close (File.CCB);
      end if;
      File.Magic := 0;
   end Close;

   ----------------------------------------------------------------------------
   -- Sync
   ----------------------------------------------------------------------------
   -- Flush all data and close the file.
   ----------------------------------------------------------------------------
   procedure Sync (File : in out WCB_Type; Success : out Boolean) is
      B : aliased Block_Type (0 .. 511);
      D : aliased Directory_Entry_Array (0 .. 15) with
         Address    => B'Address,
         Import     => True,
         Convention => Ada;
      Index : Unsigned_16;
   begin
      if not Is_Valid (File) then
         Success := False;
         return;
      end if;
      -- update file size in directory entry
      IO_Context.Read (Physical_Sector (File.Directory_Sector), B, Success);
      if Success then
         Index := File.Directory_Index mod 16;
         D (Index).YMD.Year                := FS_Time.Year;
         D (Index).YMD.Month               := FS_Time.Month;
         D (Index).YMD.Day                 := FS_Time.Day;
         D (Index).HMS.Hour                := FS_Time.Hour;
         D (Index).HMS.Minute              := FS_Time.Minute;
         D (Index).HMS.Second              := FS_Time.Second;
         D (Index).File_Attributes.Archive := True;
         if File.Last_Sector > 0 and then File.Last_Sector /= Sector_Size then
            D (Index).Size := File.CCB.IO_Bytes -
                              Unsigned_32 (Sector_Size) +
                              Unsigned_32 (File.Last_Sector);
         else
            D (Index).Size := File.CCB.IO_Bytes;
         end if;
         IO_Context.Write (Physical_Sector (File.Directory_Sector), B, Success);
      end if;
   end Sync;

   ----------------------------------------------------------------------------
   -- Delete
   ----------------------------------------------------------------------------
   -- Delete a file by name.
   ----------------------------------------------------------------------------
   procedure Delete (
                     DCB       : in out DCB_Type;
                     File_Name : in     String;
                     Success   : out    Boolean
                    ) is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (DCB, DE, File_Name, Success);
      if not Success then
         return;
      end if;
      if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
         Success := False;
         return;
      end if;
      declare
         B : Block_Type (0 .. 511);
         C : constant Cluster_Type := Cluster.Get_First (DE);
      begin
         DE.Filename (1) := Character'Val (16#E5#);
         DE.Size         := 0;
         Cluster.Put_First (DE, Cluster.File_EOF);
         Directory.Update_Entry (
                                 DCB.CCB.Current_Sector,
                                 DE,
                                 DCB.Current_Index,
                                 Success
                                );
         if Success then
            Cluster.Release_Chain (C, B);
         end if;
      end;
   end Delete;

end FATFS.Rawfile;
