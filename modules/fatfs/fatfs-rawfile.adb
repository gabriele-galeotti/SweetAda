-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-rawfile.adb                                                                                         --
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

with FATFS.Cluster;
with FATFS.Directory;

package body FATFS.Rawfile
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_Valid
      (FCB : in FCB_Type)
      return Boolean
      with Inline => True;

   procedure Finalize_IO
      (File        : in     FCB_Type;
       Sector_Size : in     Unsigned_16;
       Count       :    out Unsigned_16);

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
   function Is_Valid
      (FCB : in FCB_Type)
      return Boolean
      is
   begin
      return FCB.Magic = MAGIC_FCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if WCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid
      (WCB : in WCB_Type)
      return Boolean
      is
   begin
      return WCB.Magic = MAGIC_WCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Finalize_IO
   ----------------------------------------------------------------------------
   -- Finalize a file I/O operation.
   ----------------------------------------------------------------------------
   procedure Finalize_IO
      (File        : in     FCB_Type;
       Sector_Size : in     Unsigned_16;
       Count       :    out Unsigned_16)
      is
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
   procedure Open
      (D       : in     Descriptor_Type;
       File    :    out FCB_Type;
       DE      : in     Directory_Entry_Type;
       Success :    out Boolean)
      is
   begin
      if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
         Success := False;
         return;
      end if;
      Cluster.Open (D, File.CCB, Cluster.Get_First (D, DE), Keep_First => False);
      File.Size  := DE.Size;
      File.Magic := MAGIC_FCB;
      Success := True;
   end Open;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   -- Open a file by name.
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in     Descriptor_Type;
       File      :    out FCB_Type;
       Dir       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (D, Dir, DE, File_Name, Success);
      if Success then
         Open (D, File, DE, Success);
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   -- Rewind a file.
   ----------------------------------------------------------------------------
   procedure Rewind
      (D    : in     Descriptor_Type;
       File : in out FCB_Type)
      is
   begin
      if Is_Valid (File) then
         Cluster.Rewind (D, File.CCB);
      end if;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   -- Read one sector of a file.
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out FCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean)
      is
   begin
      Count := 0;
      if not Is_Valid (File) or else File.CCB.IO_Bytes >= File.Size then
         Success := False;
         return;
      end if;
      Cluster.Read (D, File.CCB, B, Success);
      if Success then
         Finalize_IO (File, D.Sector_Size, Count);
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Reread
   ----------------------------------------------------------------------------
   -- Reread the last read sector.
   ----------------------------------------------------------------------------
   procedure Reread
      (D       : in     Descriptor_Type;
       File    : in out FCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean)
      is
   begin
      Count := 0;
      if not Is_Valid (File) then
         Success := False;
         return;
      end if;
      Cluster.Reread (D, File.CCB, B, Success);
      if Success then
         Finalize_IO (File, D.Sector_Size, Count);
      end if;
   end Reread;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a file.
   ----------------------------------------------------------------------------
   procedure Close
      (D    : in     Descriptor_Type;
       File : in out FCB_Type)
      is
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
   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (D, DCB, DE, File_Name, Success);
      if Success then
         if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
            Success := False;
            return;
         end if;
         declare
            B : Block_Type (0 .. 511);
         begin
            Cluster.Release_Chain (D, Cluster.Get_First (D, DE), B);
            Cluster.Prelocate (D, B); -- keep one free cluster at hand
         end;
         Cluster.Put_First (D, DE, Cluster.File_EOF (D.FAT_Style));
         Cluster.Open (D, File.CCB, Cluster.Get_First (D, DE), Keep_First => False);
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
   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Create_Entry (D, DCB, DE, File_Name, Success); -- allocate and create a new directory entry
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511) with Unreferenced => True;
      begin
         Directory.Update_Entry
            (D,
             DCB.CCB.Current_Sector,
             DE,
             DCB.Current_Index,
             Success);
         Cluster.Prelocate (D, B); -- keep next free cluster
      end;
      if Success then
         Cluster.Open (D, File.CCB, Cluster.Get_First (D, DE), Keep_First => False);
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
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out WCB_Type;
       B       : in out Block_Type;
       Count   : in     Unsigned_16;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (File) or else Count > B'Length or else Count = 0 then
         Success := False;
         return;
      end if;
      -- clear excess portion of block, if any
      if Count < B'Length then
         B (Natural (Count) .. B'Last) := [others => 0];
      end if;
      Cluster.Write (D, File, B, Success);
      if Success then
         File.Last_Sector := Count;
      end if;
   end Write;

   ----------------------------------------------------------------------------
   -- Rewrite
   ----------------------------------------------------------------------------
   -- Rewrite the last written block.
   ----------------------------------------------------------------------------
   procedure Rewrite
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       B       : in     Block_Type;
       Count   : in     Unsigned_16;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (File) or else File.CCB.Previous_Sector = 0 then
         Success := False;
         return;
      end if;
      IDE.Write (D.Device.all, Physical_Sector (D, File.CCB.Previous_Sector), B, Success);
      if Success then
         File.Last_Sector := Count;
      end if;
   end Rewrite;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a file opened for write.
   ----------------------------------------------------------------------------
   procedure Close
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       Success :    out Boolean)
      is
   begin
      Sync (D, File, Success);
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
   procedure Sync
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       Success :    out Boolean)
      is
      B     : aliased Block_Type (0 .. 511);
      DE    : aliased Directory_Entry_Array (0 .. 15)
         with Address    => B'Address,
              Import     => True,
              Convention => Ada;
      Index : Unsigned_16;
   begin
      if not Is_Valid (File) then
         Success := False;
         return;
      end if;
      -- update file size in directory entry
      IDE.Read (D.Device.all, Physical_Sector (D, File.Directory_Sector), B, Success);
      if Success then
         Index := File.Directory_Index mod 16;
         DE (Index).YMD.Year                := D.FS_Time.Year;
         DE (Index).YMD.Month               := D.FS_Time.Month;
         DE (Index).YMD.Day                 := D.FS_Time.Day;
         DE (Index).HMS.Hour                := D.FS_Time.Hour;
         DE (Index).HMS.Minute              := D.FS_Time.Minute;
         DE (Index).HMS.Second              := D.FS_Time.Second;
         DE (Index).File_Attributes.Archive := True;
         if File.Last_Sector > 0 and then File.Last_Sector /= D.Sector_Size then
            DE (Index).Size := File.CCB.IO_Bytes -
                               Unsigned_32 (D.Sector_Size) +
                               Unsigned_32 (File.Last_Sector);
         else
            DE (Index).Size := File.CCB.IO_Bytes;
         end if;
         IDE.Write (D.Device.all, Physical_Sector (D, File.Directory_Sector), B, Success);
      end if;
   end Sync;

   ----------------------------------------------------------------------------
   -- Delete
   ----------------------------------------------------------------------------
   -- Delete a file by name.
   ----------------------------------------------------------------------------
   procedure Delete
      (D         : in     Descriptor_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (D, DCB, DE, File_Name, Success);
      if not Success then
         return;
      end if;
      if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
         Success := False;
         return;
      end if;
      declare
         B : Block_Type (0 .. 511);
         C : constant Cluster_Type := Cluster.Get_First (D, DE);
      begin
         DE.Filename (1) := Character'Val (16#E5#);
         DE.Size         := 0;
         Cluster.Put_First (D, DE, Cluster.File_EOF (D.FAT_Style));
         Directory.Update_Entry
            (D,
             DCB.CCB.Current_Sector,
             DE,
             DCB.Current_Index,
             Success);
         if Success then
            Cluster.Release_Chain (D, C, B);
         end if;
      end;
   end Delete;

end FATFS.Rawfile;
