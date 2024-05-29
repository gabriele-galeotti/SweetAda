-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl110.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with Videofont8x16;

package PL110
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- PL110 Registers
   ----------------------------------------------------------------------------

   -- Horizontal Axis Panel Control Register, LCDTiming0

   type LCDTiming0_Type is record
      Reserved : Bits_2 := 0;
      PPL      : Natural range 0 .. 2**6 - 1; -- Pixels-per-line. Actual pixels-per-line = 16 * (PPL + 1).
      HSW      : Natural range 0 .. 2**8 - 1; -- Horizontal synchronization pulse width, ...
      HFP      : Natural range 0 .. 2**8 - 1; -- Horizontal front porch, ...
      HBP      : Natural range 0 .. 2**8 - 1; -- Horizontal back porch,
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCDTiming0_Type use record
      Reserved at 0 range  0 ..  1;
      PPL      at 0 range  2 ..  7;
      HSW      at 0 range  8 .. 15;
      HFP      at 0 range 16 .. 23;
      HBP      at 0 range 24 .. 31;
   end record;

   -- Vertical Axis Panel Control Register, LCDTiming1

   type LCDTiming1_Type is record
      LPP : Natural range 0 .. 2**10 - 1; -- Lines per panel is the number of active lines per screen.
      VSW : Natural range 0 .. 2**6 - 1;  -- Vertical synchronization pulse width is the number of horizontal synchronization lines.
      VFP : Natural range 0 .. 2**8 - 1;  -- Vertical front porch is the number of inactive lines at the end of frame, ...
      VBP : Natural range 0 .. 2**8 - 1;  -- Vertical back porch is the number of inactive lines at the start of a frame, ...
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCDTiming1_Type use record
      LPP at 0 range  0 ..  9;
      VSW at 0 range 10 .. 15;
      VFP at 0 range 16 .. 23;
      VBP at 0 range 24 .. 31;
   end record;

   -- Control Register, LCDControl

   subtype LcdBpp_Type is Bits_3;
   BPP1  : constant LcdBpp_Type := 2#000#;
   BPP2  : constant LcdBpp_Type := 2#001#;
   BPP4  : constant LcdBpp_Type := 2#010#;
   BPP8  : constant LcdBpp_Type := 2#011#;
   BPP16 : constant LcdBpp_Type := 2#100#;
   BPP24 : constant LcdBpp_Type := 2#101#;

   subtype BGR_Type is Bits_1;
   BGR_RGB : constant BGR_Type := 0; -- RGB normal output
   BGR_BGR : constant BGR_Type := 1; -- red and blue swapped.

   -- Generate interrupt at ...
   subtype LcdVComp_Type is Bits_2;
   VCOMPVS : constant LcdVComp_Type := 2#00#; -- start of vertical synchronization
   VCOMPBP : constant LcdVComp_Type := 2#01#; -- start of back porch
   VCOMPAV : constant LcdVComp_Type := 2#10#; -- start of active video
   VCOMPFP : constant LcdVComp_Type := 2#11#; -- start of front porch

   subtype WATERMARK_Type is Bits_1;
   WATERMARK_4 : constant WATERMARK_Type := 0; -- HBUSREQM ... when either of the two DMA FIFOs have four or more empty locations
   WATERMARK_8 : constant WATERMARK_Type := 1; -- HBUSREQM ... when either of the DMA FIFOs have eight or more empty locations.

   type LCDControl_Type is record
      LcdEn       : Boolean;        -- LCD controller enable:
      LcdBpp      : LcdBpp_Type;    -- LCD bits per pixel:
      LcdBW       : Boolean;        -- STN LCD is monochrome (black and white):
      LcdTFT      : Boolean;        -- LCD is TFT:
      LcdMono8    : Boolean;        -- Monochrome LCD has an 8-bit interface.
      LcdDual     : Boolean;        -- LCD interface is dual panel STN:
      BGR         : BGR_Type;       -- RGB of BGR format selection:
      BEBO        : Boolean;        -- Big-endian byte order:
      BEPO        : Boolean;        -- Big-endian pixel ordering within a byte:
      LcdPwr      : Boolean;        -- LCD power enable:
      LcdVComp    : LcdVComp_Type;  -- Generate interrupt at:
      Reserved1   : Bits_2;
      WATERMARK   : WATERMARK_Type; -- LCD DMA FIFO Watermark level:
      Reserved2   : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LCDControl_Type use record
      LcdEn       at 0 range  0 ..  0;
      LcdBpp      at 0 range  1 ..  3;
      LcdBW       at 0 range  4 ..  4;
      LcdTFT      at 0 range  5 ..  5;
      LcdMono8    at 0 range  6 ..  6;
      LcdDual     at 0 range  7 ..  7;
      BGR         at 0 range  8 ..  8;
      BEBO        at 0 range  9 ..  9;
      BEPO        at 0 range 10 .. 10;
      LcdPwr      at 0 range 11 .. 11;
      LcdVComp    at 0 range 12 .. 13;
      Reserved1   at 0 range 14 .. 15;
      WATERMARK   at 0 range 16 .. 16;
      Reserved2   at 0 range 17 .. 31;
   end record;

   type PL110_Type is record
      LCDTiming0    : LCDTiming0_Type with Volatile_Full_Access => True;
      LCDTiming1    : LCDTiming1_Type with Volatile_Full_Access => True;
      LCDTiming2    : Unsigned_32     with Volatile_Full_Access => True;
      LCDTiming3    : Unsigned_32     with Volatile_Full_Access => True;
      LCDUPBASE     : Unsigned_32     with Volatile_Full_Access => True;
      LCDLPBASE     : Unsigned_32     with Volatile_Full_Access => True;
      LCDINTRENABLE : Unsigned_32     with Volatile_Full_Access => True;
      LCDControl    : LCDControl_Type with Volatile_Full_Access => True;
      LCDStatus     : Unsigned_32     with Volatile_Full_Access => True;
      LCDInterrupt  : Unsigned_32     with Volatile_Full_Access => True;
   end record
      with Size => 16#28# * 8;
   for PL110_Type use record
      LCDTiming0    at 16#00# range 0 .. 31;
      LCDTiming1    at 16#04# range 0 .. 31;
      LCDTiming2    at 16#08# range 0 .. 31;
      LCDTiming3    at 16#0C# range 0 .. 31;
      LCDUPBASE     at 16#10# range 0 .. 31;
      LCDLPBASE     at 16#14# range 0 .. 31;
      LCDINTRENABLE at 16#18# range 0 .. 31;
      LCDControl    at 16#1C# range 0 .. 31;
      LCDStatus     at 16#20# range 0 .. 31;
      LCDInterrupt  at 16#24# range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Framebuffer & video parameters
   ----------------------------------------------------------------------------

   VIDEO_WIDTH  : constant := 640;
   VIDEO_HEIGHT : constant := 480;

   FRAMEBUFFER_BASEADDRESS : constant := 16#0020_0000#;

   Framebuffer : aliased U16_Array (0 .. VIDEO_WIDTH * VIDEO_HEIGHT - 1)
      with Address    => System'To_Address (FRAMEBUFFER_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Interface
   ----------------------------------------------------------------------------

   subtype Video_X_Coordinate_Type is Natural range 0 .. VIDEO_WIDTH / Videofont8x16.Font_Width - 1;
   subtype Video_Y_Coordinate_Type is Natural range 0 .. VIDEO_HEIGHT / Videofont8x16.Font_Height - 1;

   type Descriptor_Type is record
      Base_Address : Address;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Base_Address => Null_Address
      );

   ----------------------------------------------------------------------------
   -- Initialization procedure.
   ----------------------------------------------------------------------------
   procedure Init
      (Descriptor : in Descriptor_Type);

   ----------------------------------------------------------------------------
   -- Print character C @ X, Y.
   ----------------------------------------------------------------------------
   procedure Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       C : in Character);

   ----------------------------------------------------------------------------
   -- Print string S @ X, Y.
   ----------------------------------------------------------------------------
   procedure Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       S : in String);

end PL110;
