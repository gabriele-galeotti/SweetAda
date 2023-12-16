-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-rawfile.ads                                                                                         --
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

package FATFS.Rawfile
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Is_Valid
      (WCB : in WCB_Type)
      return Boolean
      with Inline => True;

   -- READ

   procedure Open
      (D       : in     Descriptor_Type;
       File    :    out FCB_Type;
       DE      : in     Directory_Entry_Type;
       Success :    out Boolean);

   procedure Open
      (D         : in     Descriptor_Type;
       File      :    out FCB_Type;
       Dir       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Rewind
      (D    : in     Descriptor_Type;
       File : in out FCB_Type);

   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out FCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean);

   procedure Reread
      (D       : in     Descriptor_Type;
       File    : in out FCB_Type;
       B       :    out Block_Type;
       Count   :    out Unsigned_16;
       Success :    out Boolean);

   procedure Close
      (D    : in     Descriptor_Type;
       File : in out FCB_Type);

   -- WRITE

   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out WCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out WCB_Type;
       B       : in out Block_Type;
       Count   : in     Unsigned_16;
       Success :    out Boolean);

   procedure Rewrite
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       B       : in     Block_Type;
       Count   : in     Unsigned_16;
       Success :    out Boolean);

   procedure Sync
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       Success :    out Boolean);

   procedure Close
      (D       : in     Descriptor_Type;
       File    : in out WCB_Type;
       Success :    out Boolean);

   procedure Delete
      (D         : in     Descriptor_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

end FATFS.Rawfile;
