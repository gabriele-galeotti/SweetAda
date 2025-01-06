-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ dreamcast.ads                                                                                             --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package Dreamcast
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

   RTC_TIMESTAMPH_ADDRESS : constant := 16#A071_0000#;
   RTC_TIMESTAMPL_ADDRESS : constant := 16#A071_0004#;
   VIDEO_BASEADDRESS      : constant := 16#A500_0000#;

   type Video_Cable_Type is (CABLE_VGA, CABLE_NONE, CABLE_RGB, CABLE_COMPOSITE);

   VIDEO_FRAME_BYTESIZE : constant := 640 * 480 * 2; -- VGA 640x480

   VIDEO_FRAME : aliased U8_Array (0 .. VIDEO_FRAME_BYTESIZE - 1)
      with Alignment  => 4,
           Address    => System'To_Address (VIDEO_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   function Video_Cable
      return Video_Cable_Type;
   function Video_Font
      return Address;
   function RTC_Read
      return Unsigned_32;

end Dreamcast;
