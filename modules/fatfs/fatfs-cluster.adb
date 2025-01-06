-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-cluster.adb                                                                                         --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package body FATFS.Cluster
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
   -- Return True if CCB is valid.
   ----------------------------------------------------------------------------
   function Is_Valid
      (CCB : in CCB_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   -- Return True if cluster points to a data cluster.
   ----------------------------------------------------------------------------
   function Is_Valid
      (C : in Cluster_Type;
       F : in FAT_Type)
      return Boolean
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Get_Next
   ----------------------------------------------------------------------------
   -- Open next cluster, if any.
   ----------------------------------------------------------------------------
   procedure Get_Next
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Internal_Locate
   ----------------------------------------------------------------------------
   -- Search a free cluster.
   ----------------------------------------------------------------------------
   procedure Internal_Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Locate
   ----------------------------------------------------------------------------
   -- Search for free cluster.
   ----------------------------------------------------------------------------
   procedure Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
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
      (CCB : in CCB_Type)
      return Boolean
      is
   begin
      return CCB.Start_Sector > 0 and then CCB.Sector_Count > 0;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Is_Valid
   ----------------------------------------------------------------------------
   function Is_Valid
      (C : in Cluster_Type;
       F : in FAT_Type)
      return Boolean
      is
   begin
      case F is
         when FAT16  => return C >= 2 and then C < 16#FFF0#;
         when FAT32  => return C >= 2 and then C < 16#FFFF_FFF0#;
         when others => return False;
      end case;
   end Is_Valid;

   ----------------------------------------------------------------------------
   -- Get_Next
   ----------------------------------------------------------------------------
   procedure Get_Next
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
      Sector : Sector_Type := D.FAT_Start (D.FAT_Index); -- start of FAT
      C      : Cluster_Type := CCB.Cluster;              -- current, then next cluster #
   begin
      if not Is_Valid (CCB) or else C < 2 or else CCB.First_Cluster < 2 then
         -- invalid CCB or end of cluster chain
         Success := False;
         return;
      end if;
      -- locate FAT sector for this cluster number
      Sector := To_Table_Sector (D, C);
      IDE.Read (D.Device.all, Physical_Sector (D, Sector), B, Success);
      if not Success then
         return;
      end if;
      -- retrieve next cluster #
      C := Entry_Get (D, B, C);
      if not Is_Valid (C, D.FAT_Style) then
         -- no next cluster, error
         Success := False;
      else
         Open (D, CCB, C, Keep_First => True);
      end if;
   end Get_Next;

   ----------------------------------------------------------------------------
   -- Internal_Locate
   ----------------------------------------------------------------------------
   procedure Internal_Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
      Sector : Sector_Type;
      First  : Boolean := True;
   begin
      Success := False;
      if D.Search_Cluster < 2 then
         -- search from start of FAT
         D.Search_Cluster := 2;
      end if;
      loop
         Sector := To_Table_Sector (D, D.Search_Cluster);
         exit when Is_End (D, Sector);
         if D.Search_Cluster /= D.Next_Writable_Cluster then
            -- reserve one cluster for writes
            if Entry_Index (D.FAT_Style, D.Search_Cluster) = 0 or else
               D.Search_Cluster = 2                            or else
               First
            then
               First := False;
               -- read in FAT sector
               IDE.Read (D.Device.all, Physical_Sector (D, Sector), B, Success);
               exit when not Success;
            end if;
            if Entry_Get (D, B, D.Search_Cluster) = 0 then
               -- free cluster located
               return;
            end if;
         end if;
         D.Search_Cluster := @ + 1;
      end loop;
      -- no space or I/O error
      D.Search_Cluster := 0;
   end Internal_Locate;

   ----------------------------------------------------------------------------
   -- Locate
   ----------------------------------------------------------------------------
   procedure Locate
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
      Retry : constant Boolean := D.Search_Cluster > 2;
   begin
      Internal_Locate (D, B, Success);
      if (not Success or else D.Search_Cluster = 0) and then Retry then
         Internal_Locate (D, B, Success);
      end if;
      if Success then
         D.Next_Writable_Cluster := D.Search_Cluster;
      else
         D.Next_Writable_Cluster := 0;
      end if;
   end Locate;

   ----------------------------------------------------------------------------
   -- Is_End
   ----------------------------------------------------------------------------
   function Is_End
      (CCB : in CCB_Type)
      return Boolean
      is
   begin
      return Unsigned_16 (CCB.Current_Sector - CCB.Start_Sector) >= CCB.Sector_Count;
   end Is_End;

   ----------------------------------------------------------------------------
   -- To_Sector
   ----------------------------------------------------------------------------
   function To_Sector
      (D : in Descriptor_Type;
       C : in Cluster_Type)
      return Sector_Type
      is
   begin
      return D.Cluster_Start + Sector_Type (C - 2) * Sector_Type (D.Sectors_Per_Cluster);
   end To_Sector;

   ----------------------------------------------------------------------------
   -- File_EOF
   ----------------------------------------------------------------------------
   function File_EOF
      (F : in FAT_Type)
      return Cluster_Type
      is
   begin
      case F is
         when FAT16  => return 16#FFF8#;
         when FAT32  => return 16#FFFF_FFF8#;
         when others => return 1;
      end case;
   end File_EOF;

   ----------------------------------------------------------------------------
   -- Map
   ----------------------------------------------------------------------------
   procedure Map
      (CCB   :    out CCB_Type;
       S     : in     Sector_Type;
       Count : in     Unsigned_16)
      is
   begin
      CCB.Start_Sector    := S;
      CCB.Previous_Sector := 0;
      CCB.Current_Sector  := S;
      CCB.Sector_Count    := Count;
      CCB.Cluster         := 0;     -- this is not actually a cluster
      CCB.First_Cluster   := 0;     -- there is no first cluster
      CCB.IO_Bytes        := 0;
   end Map;

   ----------------------------------------------------------------------------
   -- Open
   ----------------------------------------------------------------------------
   procedure Open
      (D          : in     Descriptor_Type;
       CCB        : in out CCB_Type;
       C          : in     Cluster_Type;
       Keep_First : in     Boolean)
      is
      IO_Bytes      : constant Unsigned_32 := CCB.IO_Bytes;
      The_Cluster   : Cluster_Type := C;
      First_Cluster : Cluster_Type := CCB.First_Cluster;
   begin
      if Is_Valid (The_Cluster, D.FAT_Style) then
         Map (CCB, To_Sector (D, The_Cluster), D.Sectors_Per_Cluster);
         -- save cluster number
         CCB.Cluster := The_Cluster;
      else
         -- no clusters
         The_Cluster := 0;
         First_Cluster := 0;
         Map (CCB, 0, D.Sectors_Per_Cluster);
      end if;
      if Keep_First then
         CCB.First_Cluster := First_Cluster;
         CCB.IO_Bytes      := IO_Bytes;
      else
         CCB.First_Cluster := The_Cluster;
      end if;
   end Open;

   ----------------------------------------------------------------------------
   -- Advance
   ----------------------------------------------------------------------------
   procedure Advance
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (CCB) then
         Success := False;
         return;
      end if;
      if Is_End (CCB) then
         Get_Next (D, CCB, B, Success);
      else
         CCB.Current_Sector := @ + 1;
         Success := True;
      end if;
   end Advance;

   ----------------------------------------------------------------------------
   -- Peek
   ----------------------------------------------------------------------------
   procedure Peek
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      if not Is_Valid (CCB) then
         Success := False;
         return;
      end if;
      if Is_End (CCB) then
         Get_Next (D, CCB, B, Success);
      else
         Success := True;
      end if;
      if Success then
         IDE.Read (D.Device.all, Physical_Sector (D, CCB.Current_Sector), B, Success);
      end if;
   end Peek;

   ----------------------------------------------------------------------------
   -- Rewind
   ----------------------------------------------------------------------------
   procedure Rewind
      (D   : in     Descriptor_Type;
       CCB : in out CCB_Type)
      is
   begin
      if CCB.First_Cluster >= 2 then
         Open (D, CCB, CCB.First_Cluster, Keep_First => True);
      else
         CCB.Current_Sector := CCB.Start_Sector;
      end if;
      CCB.Previous_Sector := 0;
      CCB.IO_Bytes        := 0;
   end Rewind;

   ----------------------------------------------------------------------------
   -- Prelocate
   ----------------------------------------------------------------------------
   procedure Prelocate
      (D : in out Descriptor_Type;
       B :    out Block_Type)
      is
      Success : Boolean;
   begin
      if D.Next_Writable_Cluster < 2 then
         Locate (D, B, Success);
      end if;
   end Prelocate;

   ----------------------------------------------------------------------------
   -- Get_First
   ----------------------------------------------------------------------------
   function Get_First
      (D  : in     Descriptor_Type;
       DE : in Directory_Entry_Type)
      return Cluster_Type
      is
   begin
      case D.FAT_Style is
         when FAT16 => return Cluster_Type (DE.Cluster_1st);
         when FAT32 => return Cluster_Type (
                                 Shift_Left (Unsigned_32 (DE.Cluster_H), 16) or
                                 Unsigned_32 (DE.Cluster_1st)
                                 );
         when others => return 0;
      end case;
   end Get_First;

   ----------------------------------------------------------------------------
   -- Put_First
   ----------------------------------------------------------------------------
   procedure Put_First
      (D  : in     Descriptor_Type;
       DE : in out Directory_Entry_Type;
       C  : in     Cluster_Type)
      is
   begin
      DE.Cluster_1st := Unsigned_16 (Unsigned_32 (C) and 16#0000_FFFF#);
      if D.FAT_Style = FAT32 then
         DE.Cluster_H := Unsigned_16 (Shift_Right (Unsigned_32 (C), 16));
      end if;
   end Put_First;

   ----------------------------------------------------------------------------
   -- Claim
   ----------------------------------------------------------------------------
   procedure Claim
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;      -- I/O buffer to use
       C       : in     Cluster_Type;    -- cluster to mark
       Chain   : in     Cluster_Type;    -- cluster or File_EOF (end of chain)
       Success :    out Boolean)
      is
      Sector : constant Sector_Type := To_Table_Sector (D, C);
   begin
      if C = D.Next_Writable_Cluster then
         -- mark this as in use
         D.Next_Writable_Cluster := 0;
      end if;
      -- read in the FAT cluster
      IDE.Read (D.Device.all, Physical_Sector (D, Sector), B, Success);
      if Success then
         -- mark as in use (as EOF)
         Entry_Update (D, B, C, Chain);
         -- update all tables
         Update (D, Sector, B, Success);
      end if;
   end Claim;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   procedure Read
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      Peek (D, CCB, B, Success);
      if Success then
         CCB.Previous_Sector := CCB.Current_Sector;
         CCB.Current_Sector  := @ + 1;
         CCB.IO_Bytes        := @ + Unsigned_32 (D.Sector_Size);
      end if;
   end Read;

   ----------------------------------------------------------------------------
   -- Reread
   ----------------------------------------------------------------------------
   procedure Reread
      (D       : in     Descriptor_Type;
       CCB     : in     CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean)
      is
   begin
      if CCB.Previous_Sector = 0 then
         Success := False;
         return;
      end if;
      IDE.Read (D.Device.all, Physical_Sector (D, CCB.Previous_Sector), B, Success);
   end Reread;

   ----------------------------------------------------------------------------
   -- Release_Chain
   ----------------------------------------------------------------------------
   procedure Release_Chain
      (D             : in     Descriptor_Type;
       First_Cluster : in     Cluster_Type;
       B             :    out Block_Type)
      is
      C       : Cluster_Type; -- current cluster in chain
      C_Next  : Cluster_Type; -- next cluster in chain
      Sector  : Sector_Type;  -- FAT sector for cluster
      Success : Boolean;
   begin
      C := First_Cluster;
      loop
         exit when not Is_Valid (C, D.FAT_Style);
         -- read FAT Sector for current cluster
         Sector := To_Table_Sector (D, C);
         IDE.Read (D.Device.all, Physical_Sector (D, Sector), B, Success);
         exit when not Success;
         -- update the FAT Sector entry
         C_Next := Entry_Get (D, B, C);
         Entry_Update (D, B, C, 0);
         -- update all tables
         Update (D, Sector, B, Success);
         exit when not Success;
         C := C_Next;
      end loop;
   end Release_Chain;

   ----------------------------------------------------------------------------
   -- Write
   ----------------------------------------------------------------------------
   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out WCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean)
      is
      New_Cluster : Cluster_Type := 0;
      DI          : Unsigned_16;
   begin
      if File.CCB.Current_Sector = 0 then
         -- empty new file to write
         null;
      elsif not Is_Valid (File.CCB) then
         Success := False;
         return;
      end if;
      if Unsigned_16 (File.CCB.Current_Sector - File.CCB.Start_Sector) >= File.CCB.Sector_Count or else
         File.CCB.Current_Sector = 0
      then
         -- add first cluster or add a new cluster
         if D.Next_Writable_Cluster < 2 then
            Success := False;
            -- no more space or I/O error(s)
            return;
         end if;
         -- save write data to the new cluster
         New_Cluster := D.Next_Writable_Cluster;
         IDE.Write (D.Device.all, Physical_Sector (D, To_Sector (D, New_Cluster)), B, Success);
         if not Success then
            -- I/O error
            return;
         end if;
         -- client has claimed this cluster
         Claim (D, B, New_Cluster, File_EOF (D.FAT_Style), Success);
         if not Success then
            return;
         end if;
         -- when adding the first cluster, the file directory must be updated
         -- entry with the cluster #
         if File.CCB.Current_Sector = 0 then
            declare
               Dir : aliased Directory_Entry_Array (0 .. 15)
                  with Address    => B (0)'Address,
                       Import     => True,
                       Convention => Ada;
            begin
               IDE.Read (D.Device.all, Physical_Sector (D, File.Directory_Sector), B, Success);
               if Success then
                  DI := File.Directory_Index mod 16;
                  Put_First (D, Dir (DI), New_Cluster);
                  IDE.Write (D.Device.all, Physical_Sector (D, File.Directory_Sector), B, Success);
               end if;
            end;
            if Success then
               Open (D, File.CCB, New_Cluster, Keep_First => False);
            else
               -- I/O error
               return;
            end if;
         else
            -- otherwise add a cluster to this chain
            -- link current cluster to next
            Claim (D, B, File.CCB.Cluster, New_Cluster, Success);
            if Success then
               Open (D, File.CCB, New_Cluster, Keep_First => True);
            else
               return;
            end if;
         end if;
         File.CCB.IO_Bytes := File.CCB.IO_Bytes + Unsigned_32 (D.Sector_Size);
         -- get next free cluster
         Prelocate (D, B);
         -- restore buffer
         IDE.Read (D.Device.all, Physical_Sector (D, File.CCB.Current_Sector), B, Success);
      else
         -- plain write
         IDE.Write (D.Device.all, Physical_Sector (D, File.CCB.Current_Sector), B, Success);
         if Success then
            File.CCB.IO_Bytes := File.CCB.IO_Bytes + Unsigned_32 (D.Sector_Size);
         end if;
      end if;
      -- the sector just written
      File.CCB.Previous_Sector := File.CCB.Current_Sector;
      -- the next write happens here
      File.CCB.Current_Sector  := @ + 1;
   end Write;

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   procedure Close
      (CCB : out CCB_Type)
      is
   begin
      CCB.Start_Sector := 0;
      CCB.Sector_Count := 0;
   end Close;

end FATFS.Cluster;
