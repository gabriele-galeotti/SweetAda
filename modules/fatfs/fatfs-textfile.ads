-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-textfile.ads                                                                                        --
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

package FATFS.Textfile is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- READ

   procedure Open
      (D       : in     Descriptor_Type;
       File    :    out TFCB_Type;
       DE      : in     Directory_Entry_Type;
       Success :    out Boolean);

   procedure Open
      (D         : in     Descriptor_Type;
       File      :    out TFCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Rewind
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type);

   procedure Read_Char
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       C       :    out Character;
       Success :    out Boolean);

   procedure Read_Line
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Line    :    out String;
       Last    :    out Natural;
       Success :    out Boolean);

   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Buffer  :    out Byte_Array;
       Count   :    out Unsigned_16;
       Success :    out Boolean);

   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_8;
       Success :    out Boolean);

   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_16;
       Success :    out Boolean);

   procedure Read
      (D       : in     Descriptor_Type;
       File    : in out TFCB_Type;
       Data    :    out Unsigned_32;
       Success :    out Boolean);

   procedure Close
      (D    : in     Descriptor_Type;
       File : in out TFCB_Type);

   -- WRITE

   procedure Open
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Create
      (D         : in out Descriptor_Type;
       File      :    out TWCB_Type;
       DCB       : in out DCB_Type;
       File_Name : in     String;
       Success   :    out Boolean);

   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       C       : in     Character;
       Success :    out Boolean);

   procedure Put
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean);

   procedure Put_Line
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Text    : in     String;
       Success :    out Boolean);

   procedure Put_NewLine
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Buffer  : in     Byte_Array;
       Success :    out Boolean);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_8;
       Success :    out Boolean);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_16;
       Success : out    Boolean);

   procedure Write
      (D       : in out Descriptor_Type;
       File    : in out TWCB_Type;
       Data    : in     Unsigned_32;
       Success :    out Boolean);

   procedure Sync
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

   procedure Close
      (D       : in     Descriptor_Type;
       File    : in out TWCB_Type;
       Success :    out Boolean);

end FATFS.Textfile;
