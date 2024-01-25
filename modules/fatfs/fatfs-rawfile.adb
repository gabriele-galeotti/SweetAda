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

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if FCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid
      (FCB : in FCB_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Finalize_IO
   ----------------------------------------------------------------------------
   -- Finalize a file I/O operation.
   ----------------------------------------------------------------------------
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
   function Is_Valid
      (FCB : in FCB_Type)
      return Boolean
      is
   begin
      return FCB.Magic = MAGIC_FCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Finalize_IO
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
   -- Is_Valid
   ----------------------------------------------------------------------------
   function Is_Valid
      (WCB : in WCB_Type)
      return Boolean
      is
   begin
      return WCB.Magic = MAGIC_WCB;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Open
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
   -- Open (READ)
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
   -- Close (READ)
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
   -- Open (WRITE)
   ----------------------------------------------------------------------------
   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       Dir       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Search (D, Dir, DE, File_Name, Success);
      if Success then
         if DE.File_Attributes.Volume_Name or else DE.File_Attributes.Subdirectory then
            Success := False;
            return;
         end if;
         declare
            B : Block_Type (0 .. 511);
         begin
            Cluster.Release_Chain (D, Cluster.Get_First (D, DE), B);
            -- keep one available free cluster
            Cluster.Prelocate (D, B);
         end;
         Cluster.Put_First (D, DE, Cluster.File_EOF (D.FAT_Style));
         Cluster.Open (D, File.CCB, Cluster.Get_First (D, DE), Keep_First => False);
         -- remember directory entry
         File.Directory_Index  := Dir.Current_Index;
         File.Directory_Sector := Dir.CCB.Current_Sector;
         File.Magic            := MAGIC_WCB;
         File.Last_Sector      := 0;
         Success := True;
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Create
   ----------------------------------------------------------------------------
   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       Dir       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      DE : Directory_Entry_Type;
   begin
      Directory.Entry_Create (D, Dir, DE, File_Name, Success);
      if not Success then
         return;
      end if;
      declare
         B : Block_Type (0 .. 511) with Unreferenced => True;
      begin
         Directory.Entry_Update
            (D,
             Dir.CCB.Current_Sector,
             DE,
             Dir.Current_Index,
             Success);
         -- keep next free cluster
         Cluster.Prelocate (D, B);
      end;
      if Success then
         Cluster.Open (D, File.CCB, Cluster.Get_First (D, DE), Keep_First => False);
         -- remember directory entry
         File.Directory_Index  := Dir.Current_Index;
         File.Directory_Sector := Dir.CCB.Current_Sector;
         File.Magic            := MAGIC_WCB;
         File.Last_Sector      := 0;
         Success := True;
      end if;
   end Create;

   ----------------------------------------------------------------------------
   -- Write
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
   -- Close (WRITE)
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
         -- __FIX__ endian
         DE (Index).Wtime_YMD.Year          := D.FS_Time.Year;
         DE (Index).Wtime_YMD.Month         := D.FS_Time.Month;
         DE (Index).Wtime_YMD.Day           := D.FS_Time.Day;
         DE (Index).Wtime_HMS.Hour          := D.FS_Time.Hour;
         DE (Index).Wtime_HMS.Minute        := D.FS_Time.Minute;
         DE (Index).Wtime_HMS.Second        := D.FS_Time.Second;
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
         DE.File_Name (1) := Character'Val (16#E5#);
         DE.Size          := 0;
         Cluster.Put_First (D, DE, Cluster.File_EOF (D.FAT_Style));
         Directory.Entry_Update
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
