-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ dreamcast.ads                                                                                             --
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

with System;
with System.Storage_Elements;
with Bits;

package Dreamcast is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;

   VIDEO_BASEADDRESS : constant := 16#A500_0000#;

   VIDEO_FRAME_BYTESIZE : constant := 640 * 480 * 2; -- VGA 640x480

   VIDEO_FRAME : Bits.U8_Array (0 .. VIDEO_FRAME_BYTESIZE - 1) with
      Alignment  => 4,
      Address    => To_Address (VIDEO_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   type Video_Cable_Type is (CABLE_VGA, CABLE_NONE, CABLE_RGB, CABLE_COMPOSITE);

   function Video_Cable return Video_Cable_Type;
   function Video_Font return Address;

end Dreamcast;
