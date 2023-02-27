-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ vga.ads                                                                                                   --
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

with System.Storage_Elements;

package VGA is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;

   type Mode_Type is
      (
       MODE03H, -- TEXT 80x25
       MODE12H  -- GRAPHIC 640x480x4
      );

   VIDEO_TEXT_WIDTH  : constant := 80;
   VIDEO_TEXT_HEIGHT : constant := 25;

   subtype Video_X_Coordinate_Type is Natural range 0 .. VIDEO_TEXT_WIDTH - 1;
   subtype Video_Y_Coordinate_Type is Natural range 0 .. VIDEO_TEXT_HEIGHT - 1;

   procedure Init (Video_Memory_BaseAddress : in Integer_Address; Text_Memory_BaseAddress : in Integer_Address);
   procedure Set_Mode (Mode : in Mode_Type);
   procedure Clear_Screen;
   procedure Print (
                    X : in Video_X_Coordinate_Type;
                    Y : in Video_Y_Coordinate_Type;
                    C : in Character
                   );
   procedure Print (
                    X : in Video_X_Coordinate_Type;
                    Y : in Video_Y_Coordinate_Type;
                    S : in String
                   );
   procedure Draw_Picture (Picture : in Storage_Array);

end VGA;
