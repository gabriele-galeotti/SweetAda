-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ili9341v.ads                                                                                              --
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
with Bits;

package ILI9341V
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;

   -- 8.1. Command List (Regulative Command Set)

   No_Operation                     : constant := 16#00#;
   Software_Reset                   : constant := 16#01#;
   Sleep_Out                        : constant := 16#11#;
   Normal_Display_Mode_ON           : constant := 16#13#;
   Display_OFF                      : constant := 16#28#;
   Display_ON                       : constant := 16#29#;
   Column_Address_Set               : constant := 16#2A#;
   Page_Address_Set                 : constant := 16#2B#;
   Memory_Write                     : constant := 16#2C#;
   Color_Set                        : constant := 16#2D#;
   Partial_Area                     : constant := 16#30#;
   Memory_Access_Control            : constant := 16#36#;
   Vertical_Scrolling_Start_Address : constant := 16#37#;
   Pixel_Format_Set                 : constant := 16#3A#;
   Write_Memory_Continue            : constant := 16#3C#;
   Write_CTRL_Display               : constant := 16#53#;

   -- 8.2.29. Memory Access Control (36h)

   MH_L2R : constant := 0; -- Refresh X1 -> X240
   MH_R2L : constant := 1; -- Refresh X240 -> X1

   BGR_RGB : constant := 0; -- R-G-B
   BGR_BGR : constant := 1; -- B-G-R

   ML_T2B : constant := 0; -- Refresh Y1 -> Y320
   ML_B2T : constant := 1; -- Refresh Y320 -> Y1

   MV_NORMAL  : constant := 0; -- Normal mode
   MV_REVERSE : constant := 1; -- Reverse mode

   MX_L2R : constant := 0; -- X1 -> X240
   MX_R2L : constant := 1; -- X240 -> X1

   MY_T2B : constant := 0; -- Y1 -> Y320
   MY_B2T : constant := 1; -- Y320 -> Y1

   type MADCTL_Type is record
      Unused : Bits_2 := 0;
      MH     : Bits_1 := MH_L2R;    -- Horizontal Refresh ORDER
      BGR    : Bits_1 := BGR_RGB;   -- RGB-BGR Order
      ML     : Bits_1 := ML_T2B;    -- Vertical Refresh Order
      MV     : Bits_1 := MV_NORMAL; -- Row / Column Exchange
      MX     : Bits_1 := MX_L2R;    -- Column Address Order
      MY     : Bits_1 := MY_T2B;    -- Row Address Order
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MADCTL_Type use record
      Unused at 0 range 0 .. 1;
      MH     at 0 range 2 .. 2;
      BGR    at 0 range 3 .. 3;
      ML     at 0 range 4 .. 4;
      MV     at 0 range 5 .. 5;
      MX     at 0 range 6 .. 6;
      MY     at 0 range 7 .. 7;
   end record;

   -- 8.2.40. Write CTRL Display (53h)

   type CTRL_Type is record
      Unused1 : Bits_2  := 0;
      BL      : Boolean := False; -- Backlight Control On/Off
      DD      : Boolean := False; -- Display Dimming, only for manual brightness setting
      Unused2 : Bits_1  := 0;
      BCTRL   : Boolean := False; -- Brightness Control Block On/Off, This bit is always used to switch brightness for display.
      Unused3 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_Type use record
      Unused1 at 0 range 0 .. 1;
      BL      at 0 range 2 .. 2;
      DD      at 0 range 3 .. 3;
      Unused2 at 0 range 4 .. 4;
      BCTRL   at 0 range 5 .. 5;
      Unused3 at 0 range 6 .. 7;
   end record;

end ILI9341V;
