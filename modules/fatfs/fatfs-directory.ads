-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-directory.ads                                                                                       --
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

package FATFS.Directory
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Open_Root
      (D       : in     Descriptor_Type;
       DCB     :    out DCB_Type;
       Success :    out Boolean);

   procedure Get_Entry
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   procedure Next_Entry
      (D       : in     Descriptor_Type;
       DCB     : in out DCB_Type;
       DE      :    out Directory_Entry_Type;
       Success :    out Boolean);

   procedure Search
      (D              : in     Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   procedure Create_Entry
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       DE             :    out Directory_Entry_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   procedure Update_Entry
      (D       : in     Descriptor_Type;
       Sector  : in     Sector_Type;
       DE      : in     Directory_Entry_Type;
       Index   : in     Unsigned_16;
       Success :    out Boolean);

   procedure Create_Subdirectory
      (D              : in out Descriptor_Type;
       DCB            : in out DCB_Type;
       Directory_Name : in     String;
       Success        :    out Boolean);

   procedure Close
      (DCB : in out DCB_Type);

end FATFS.Directory;
