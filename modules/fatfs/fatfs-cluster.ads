-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-cluster.ads                                                                                         --
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

package FATFS.Cluster is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_End (CCB : CCB_Type) return Boolean with
      Inline => True;

   function To_Sector (C : Cluster_Type) return Sector_Type with
      Inline => True;

   function File_EOF return Cluster_Type with
      Inline => True;

   procedure Map (
                  CCB   : out CCB_Type;
                  S     : in  Sector_Type;
                  Count : in  Unsigned_16
                 );

   procedure Open (
                   CCB        : in out CCB_Type;
                   C          : in     Cluster_Type;
                   Keep_First : in     Boolean
                  );

   procedure Advance (
                      CCB     : in out CCB_Type;
                      B       : in out Block_Type;
                      Success : out    Boolean
                     );

   procedure Peek (
                   CCB     : in out CCB_Type;
                   B       : out    Block_Type;
                   Success : out    Boolean
                  );

   procedure Rewind (CCB : in out CCB_Type);

   procedure Prelocate (B : out Block_Type);

   procedure Put_First (DE : in out Directory_Entry_Type; C : in Cluster_Type);

   function Get_First (DE : Directory_Entry_Type) return Cluster_Type;

   procedure Claim (
                    B       : out Block_Type;
                    C       : in  Cluster_Type;
                    Success : out Boolean;
                    Chain   : in  Cluster_Type := File_EOF
                   );

   procedure Read (
                   CCB     : in out CCB_Type;
                   B       : out    Block_Type;
                   Success : out    Boolean
                  );

   procedure Reread (
                     CCB     : in  CCB_Type;
                     B       : out Block_Type;
                     Success : out Boolean
                    );

   procedure Release_Chain (First_Cluster : in Cluster_Type; B : out Block_Type);

   procedure Write (
                    File    : in out WCB_Type;
                    B       : in out Block_Type;
                    Success : out    Boolean
                   );

   procedure Close (CCB : out CCB_Type);

end FATFS.Cluster;
