-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-textfile.ads                                                                                        --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
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

   procedure Open (
                   File    : out TFCB_Type;
                   DE      : in  Directory_Entry_Type;
                   Success : out Boolean
                  );

   procedure Open (
                   File      : out    TFCB_Type;
                   DCB       : in out DCB_Type;
                   File_Name : in     String;
                   Success   : out    Boolean
                  );

   procedure Rewind (File : in out TFCB_Type);

   procedure Read_Char (
                        File    : in out TFCB_Type;
                        C       : out    Character;
                        Success : out    Boolean
                       );

   procedure Read_Line (
                        File    : in out TFCB_Type;
                        Line    : out    String;
                        Last    : out    Natural;
                        Success : out    Boolean
                       );

   procedure Read (
                   File    : in out TFCB_Type;
                   Buffer  : out    Byte_Array;
                   Count   : out    Unsigned_16;
                   Success : out    Boolean
                  );

   procedure Read (
                   File    : in out TFCB_Type;
                   Data    : out    Unsigned_8;
                   Success : out    Boolean
                  );

   procedure Read (
                   File    : in out TFCB_Type;
                   Data    : out    Unsigned_16;
                   Success : out    Boolean
                  );

   procedure Read (
                   File    : in out TFCB_Type;
                   Data    : out    Unsigned_32;
                   Success : out    Boolean
                  );

   procedure Close (File : in out TFCB_Type);

   -- WRITE

   procedure Open (
                   File      : out    TWCB_Type;
                   DCB       : in out DCB_Type;
                   File_Name : in     String;
                   Success   : out    Boolean
                  );

   procedure Create (
                     File      : out    TWCB_Type;
                     DCB       : in out DCB_Type;
                     File_Name : in     String;
                     Success   : out    Boolean
                    );

   procedure Put (
                  File    : in out TWCB_Type;
                  C       : in     Character;
                  Success : out    Boolean
                 );

   procedure Put (
                  File    : in out TWCB_Type;
                  Text    : in     String;
                  Success : out    Boolean
                 );

   procedure Put_Line (
                       File    : in out TWCB_Type;
                       Text    : in     String;
                       Success : out    Boolean
                      );

   procedure Put_NewLine (File : in out TWCB_Type; Success : out Boolean);

   procedure Write (
                    File    : in out TWCB_Type;
                    Buffer  : in     Byte_Array;
                    Success : out    Boolean
                   );

   procedure Write (
                    File    : in out TWCB_Type;
                    Data    : in     Unsigned_8;
                    Success : out    Boolean
                   );

   procedure Write (
                    File    : in out TWCB_Type;
                    Data    : in     Unsigned_16;
                    Success : out    Boolean
                   );

   procedure Write (
                    File    : in out TWCB_Type;
                    Data    : in     Unsigned_32;
                    Success : out    Boolean
                   );

   procedure Sync (File : in out TWCB_Type; Success : out Boolean);

   procedure Close (File : in out TWCB_Type; Success : out Boolean);

end FATFS.Textfile;
