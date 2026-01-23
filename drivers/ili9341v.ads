-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ili9341v.ads                                                                                              --
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ILI9341V
   -- Version: V100
   -- Document No.: ILI9341V_DTS_V100_20130423
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 8.1. Command List (Regulative Command Set)
   ----------------------------------------------------------------------------

   NOP       : constant := 16#00#; -- No Operation
   SWRESET   : constant := 16#01#; -- Software Reset
   RDDIDIF   : constant := 16#04#; -- Read Display Identification Information
   RDDST     : constant := 16#09#; -- Read Display Status
   RDDPM     : constant := 16#0A#; -- Read Display Power Mode
   RDDMADCTL : constant := 16#0B#; -- Read Display MADCTL
   RDDCOLMOD : constant := 16#0C#; -- Read Display Pixel Format
   RDDIM     : constant := 16#0D#; -- Read Display Image Mode
   RDDSM     : constant := 16#0E#; -- Read Display Signal Mode
   RDDSDR    : constant := 16#0F#; -- Read Display Self-Diagnostic Result
   SPLIN     : constant := 16#10#; -- Enter Sleep Mode
   SLPOUT    : constant := 16#11#; -- Sleep Out
   PTLON     : constant := 16#12#; -- Partial Mode On
   NORON     : constant := 16#13#; -- Normal Display Mode On
   DINVOFF   : constant := 16#20#; -- Display Inversion OFF
   DINVON    : constant := 16#21#; -- Display Inversion ON
   GAMSET    : constant := 16#26#; -- Gamma Set
   DISPOFF   : constant := 16#28#; -- Display OFF
   DISPON    : constant := 16#29#; -- Display ON
   CASET     : constant := 16#2A#; -- Column Address Set
   PASET     : constant := 16#2B#; -- Page Address Set
   RAMWR     : constant := 16#2C#; -- Memory Write
   RGBSET    : constant := 16#2D#; -- Color Set
   RAMRD     : constant := 16#2E#; -- Memory Read
   PLTAR     : constant := 16#30#; -- Partial Area
   VSCRDEF   : constant := 16#33#; -- Vertical Scrolling Definition
   TEOFF     : constant := 16#34#; -- Tearing Effect Line OFF
   TEON      : constant := 16#35#; -- Tearing Effect Line ON
   MADCTL    : constant := 16#36#; -- Memory Access Control
   VSCRSADD  : constant := 16#37#; -- Vertical Scrolling Start Address
   IDMOFF    : constant := 16#38#; -- Idle Mode OFF
   IDMON     : constant := 16#39#; -- Idle Mode ON
   PIXSET    : constant := 16#3A#; -- Pixel Format Set
   RAMWRC    : constant := 16#3C#; -- Write_Memory_Continue
   RAMRDC    : constant := 16#3E#; -- Read_Memory_Continue
   SETTSL    : constant := 16#44#; -- Set_Tear_Scanline
   GETSL     : constant := 16#45#; -- Get_Scanline
   WRDISBV   : constant := 16#51#; -- Write Display Brightness
   RDDISBV   : constant := 16#52#; -- Read Display Brightness Value
   WRCTRLD   : constant := 16#53#; -- Write Control Display
   RDCTRLD   : constant := 16#54#; -- Read Control Display
   WRCABC    : constant := 16#55#; -- Write Content Adaptive Brightness Control
   RDCABC    : constant := 16#56#; -- Read Content Adaptive Brightness Control
   WRCABCMB  : constant := 16#5E#; -- Backlight Control 1 Write CABC Minimum Brightness
   RDCABCMB  : constant := 16#5F#; -- Backlight_Control_1 Read CABC Minimum Brightness
   RDID1     : constant := 16#DA#; -- Read ID1
   RDID2     : constant := 16#DB#; -- Read ID2
   RDID3     : constant := 16#DC#; -- Read ID3

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

   -- 8.2.42. Write Content Adaptive Brightness Control (55h)
   -- 8.2.43. Read Content Adaptive Brightness Control (56h)

   CABC_OFF    : constant := 2#00#; -- Off
   CABC_USER   : constant := 2#01#; -- User Interface Image
   CABC_STILL  : constant := 2#10#; -- Still Picture
   CABC_MOVING : constant := 2#11#; -- Moving Image

   ----------------------------------------------------------------------------
   -- 8.3. Description of Level 2 Command
   ----------------------------------------------------------------------------

   IFMODE   : constant := 16#B0#; -- Interface Mode Control
   FRMCTR1  : constant := 16#B1#; -- Frame Rate Control (In Normal Mode / Full colors)
   FRMCTR2  : constant := 16#B2#; -- Frame Rate Control (In Idle Mode / 8l colors)
   FRMCTR3  : constant := 16#B3#; -- Frame Rate Control (In Partial Mode / Full colors)
   INVTR    : constant := 16#B4#; -- Display Inversion Control
   PRCTR    : constant := 16#B5#; -- Blanking Porch
   DISCTRL  : constant := 16#B6#; -- Display Function Control
   ETMOD    : constant := 16#B7#; -- Entry Mode Set
   BLCTRL1  : constant := 16#B8#; -- Backlight Control 1
   BLCTRL2  : constant := 16#B9#; -- Backlight Control 2
   BLCTRL3  : constant := 16#BA#; -- Backlight Control 3
   BLCTRL4  : constant := 16#BB#; -- Backlight Control 4
   BLCTRL5  : constant := 16#BC#; -- Backlight Control 5
   BLCTRL7  : constant := 16#BE#; -- Backlight Control 7
   BLCTRL8  : constant := 16#BF#; -- Backlight Control 8
   PWCTRL1  : constant := 16#C0#; -- Power Control 1
   PWCTRL2  : constant := 16#C1#; -- Power Control 2
   VMCTRL1  : constant := 16#C5#; -- VCOM Control 1
   VMCTRL2  : constant := 16#C7#; -- VCOM Control 2
   NVMWR    : constant := 16#D0#; -- NV Memory Write
   NVMPKEY  : constant := 16#D1#; -- NV Memory Protection Key
   RDNVM    : constant := 16#D2#; -- NV Memory Status Read
   RDID4    : constant := 16#D3#; -- Read ID4
   PGAMCTRL : constant := 16#E0#; -- Positive Gamma Control
   NGAMCTRL : constant := 16#E1#; -- Negative Gamma Correction
   DGAMCTR1 : constant := 16#E2#; -- Digital Gamma Control 1
   DGAMCTR2 : constant := 16#E3#; -- Digital Gamma Control 2
   IFCTL    : constant := 16#F6#; -- 16bits Data Format Selection

   ----------------------------------------------------------------------------
   -- 8.4 Description of Extend register command
   ----------------------------------------------------------------------------

   PWCTRLA  : constant := 16#CB#; -- Power control A
   PWCTRLB  : constant := 16#CF#; -- Power control B
   DTCTRLA  : constant := 16#E8#; -- Driver timing control A
   DTCTRLB  : constant := 16#E9#; -- Driver timing control B
   DTCTRLC  : constant := 16#EA#; -- Driver timing control C
   PWONSC   : constant := 16#ED#; -- Power on sequence control
   ENABLE3G : constant := 16#F2#; -- Enable_3G
   PRCTRL   : constant := 16#F7#; -- Pump ratio control

pragma Style_Checks (On);

end ILI9341V;
