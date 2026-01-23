-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-directory.ads                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package FATFS.Directory
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Open_Root
   ----------------------------------------------------------------------------
   -- Open the root directory.
   ----------------------------------------------------------------------------
   procedure Open_Root
      (D       : in     Descriptor_Type;
       DCB     :    out DCB_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Get
   ----------------------------------------------------------------------------
   -- Return the current directory entry.
   ----------------------------------------------------------------------------
   procedure Entry_Get
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Next
   ----------------------------------------------------------------------------
   -- Return the next directory entry.
   ----------------------------------------------------------------------------
   procedure Entry_Next
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Search
   ----------------------------------------------------------------------------
   -- Search a directory for a file name or subdirectory name.
   ----------------------------------------------------------------------------
   procedure Search
      (D              : in     Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Create
   ----------------------------------------------------------------------------
   -- Create a new directory entry by name.
   ----------------------------------------------------------------------------
   procedure Entry_Create
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   ----------------------------------------------------------------------------
   -- Entry_Update
   ----------------------------------------------------------------------------
   -- Perform a directory sector update.
   ----------------------------------------------------------------------------
   procedure Entry_Update
      (D       : in     Descriptor_Type;
       Sector  : in     Sector_Type;
       DE      : in     Directory_Entry_Type;
       Index   : in     Unsigned_16;
       Success :    out Boolean);

   ----------------------------------------------------------------------------
   -- Subdirectory_Create
   ----------------------------------------------------------------------------
   -- Create a subdirectory.
   ----------------------------------------------------------------------------
   procedure Subdirectory_Create
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   ----------------------------------------------------------------------------
   -- Close
   ----------------------------------------------------------------------------
   -- Close a directory.
   ----------------------------------------------------------------------------
   procedure Close
      (DCB : in out DCB_Type);

end FATFS.Directory;
