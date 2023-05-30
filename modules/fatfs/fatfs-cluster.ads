-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-cluster.ads                                                                                         --
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

package FATFS.Cluster is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_End
      (CCB : in CCB_Type)
      return Boolean with
      Inline => True;

   function To_Sector
      (D : in Descriptor_Type;
       C : in Cluster_Type)
      return Sector_Type with
      Inline => True;

   function File_EOF
      (F : in FAT_Type)
      return Cluster_Type with
      Inline => True;

   procedure Map
      (CCB   :    out CCB_Type;
       S     : in     Sector_Type;
       Count : in     Unsigned_16);

   procedure Open
      (D          : in     Descriptor_Type;
       CCB        : in out CCB_Type;
       C          : in     Cluster_Type;
       Keep_First : in     Boolean);

   procedure Advance
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean);

   procedure Peek
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   procedure Rewind
      (D   : in     Descriptor_Type;
       CCB : in out CCB_Type);

   procedure Prelocate
      (D : in out Descriptor_Type;
       B :    out Block_Type);

   procedure Put_First
      (D  : in     Descriptor_Type;
       DE : in out Directory_Entry_Type;
       C  : in     Cluster_Type);

   function Get_First
      (D  : in Descriptor_Type;
       DE : in Directory_Entry_Type)
      return Cluster_Type;

   procedure Claim
      (D       : in out Descriptor_Type;
       B       :    out Block_Type;
       C       : in     Cluster_Type;
       Chain   : in     Cluster_Type;
       Success :    out Boolean);

   procedure Read
      (D       : in     Descriptor_Type;
       CCB     : in out CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   procedure Reread
      (D       : in     Descriptor_Type;
       CCB     : in     CCB_Type;
       B       :    out Block_Type;
       Success :    out Boolean);

   procedure Release_Chain
      (D             : in     Descriptor_Type;
       First_Cluster : in     Cluster_Type;
       B             :    out Block_Type);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out WCB_Type;
       B       : in out Block_Type;
       Success :    out Boolean);

   procedure Close
      (CCB : out CCB_Type);

end FATFS.Cluster;
