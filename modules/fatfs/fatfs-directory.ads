-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-directory.ads                                                                                       --
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

package FATFS.Directory is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Open_Root (DCB : out DCB_Type; Success : out Boolean);

   procedure Get_Entry (
                        DCB     : in out DCB_Type;
                        DE      : out    Directory_Entry_Type;
                        Success : out    Boolean
                       );

   procedure Next_Entry (
                         DCB     : in out DCB_Type;
                         DE      : out    Directory_Entry_Type;
                         Success : out    Boolean
                        );

   procedure Search (
                     DCB            : in out DCB_Type;
                     DE             : out    Directory_Entry_Type;
                     Directory_Name : in     String;
                     Success        : out    Boolean
                    );

   procedure Create_Entry (
                           DCB            : in out DCB_Type;
                           DE             : out    Directory_Entry_Type;
                           Directory_Name : in     String;
                           Success        : out    Boolean
                          );

   procedure Update_Entry (
                           Sector  : in  Sector_Type;
                           DE      : in  Directory_Entry_Type;
                           Index   : in  Unsigned_16;
                           Success : out Boolean
                          );

   procedure Create_Subdirectory (
                                  DCB            : in out DCB_Type;
                                  Directory_Name : in     String;
                                  Success        : out    Boolean
                                 );

   procedure Close (DCB : in out DCB_Type);

end FATFS.Directory;
