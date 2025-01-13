-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ vga.adb                                                                                                   --
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
with Memory_Functions;
with CPU.IO;
with Videofont8x16;

package body VGA
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;

   Video_Buffer_BaseAddress : Integer_Address := 16#000A_0000#;
   Text_Buffer_BaseAddress  : Integer_Address := 16#000B_8000#;

   ----------------------------------------------------------------------------
   -- VGA registers
   ----------------------------------------------------------------------------

   ATTRIBUTE_INDEX        : constant := 16#03C0#;
   ATTRIBUTE_DATA_W       : constant := 16#03C0#;
   ATTRIBUTE_DATA_R       : constant := 16#03C1#;
   MISCELLANEOUS_OUTPUT   : constant := 16#03C2#;
   INPUT_STATUS_0         : constant := 16#03C2#;
   VIDEO_SUBSYSTEM_ENABLE : constant := 16#03C3#;
   SEQUENCER_INDEX        : constant := 16#03C4#;
   SEQUENCER_DATA         : constant := 16#03C5#;
   PEL_MASK               : constant := 16#03C6#;
   DAC_STATE              : constant := 16#03C7#;
   PEL_READ_INDEX         : constant := 16#03C7#;
   PEL_WRITE_INDEX        : constant := 16#03C8#;
   PEL_DATA               : constant := 16#03C9#;
   GRAPHICS_INDEX         : constant := 16#03CE#;
   GRAPHICS_DATA          : constant := 16#03CF#;
   CRTC6845_INDEX         : constant := 16#03D4#; -- EGA/VGA rather than MDA (0x3B4)
   CRTC6845_DATA          : constant := 16#03D5#; -- EGA/VGA rather than MDA (0x3B5)
   INPUT_STATUS_1         : constant := 16#03DA#; -- EGA/VGA rather than MDA (0x3BA)
   FEATURE_CONTROL_R      : constant := 16#03CA#;
   FEATURE_CONTROL_W      : constant := 16#03DA#; -- EGA/VGA rather than MDA (0x3BA)

   ----------------------------------------------------------------------------
   -- SEQUENCER
   ----------------------------------------------------------------------------

   type SEQUENCER_Register_Type is range 0 .. 16#04#;

   SEQUENCER_Register_Values_MODE03H : constant array (SEQUENCER_Register_Type range <>) of Unsigned_8 :=
      [
       16#03#, -- 00 Reset:
       16#00#, -- 01 Clocking Mode: bit0 = 0 --> 9 dots, bit0 = 1 --> 8 dots
       16#03#, -- 02 Map Mask:
       16#00#, -- 03 Character Map Select:
       16#02#  -- 04 Sequencer Memory Mode:
      ];

   SEQUENCER_Register_Values_MODE12H : constant array (SEQUENCER_Register_Type range <>) of Unsigned_8 :=
      [
       16#03#, -- 00 Reset:
       16#01#, -- 01 Clocking Mode: bit0 = 0 --> 9 dots, bit0 = 1 --> 8 dots
       16#0F#, -- 02 Map Mask:
       16#00#, -- 03 Character Map Select:
       16#06#  -- 04 Sequencer Memory Mode:
      ];

   -- Clocking Mode register: When set to 1, this bit turns off the display.
   CLKMODE_SCREEN_DISABLE : constant := 16#20#;

   ----------------------------------------------------------------------------
   -- CRTC
   ----------------------------------------------------------------------------

   type CRTC6845_Register_Type is range 0 .. 16#18#;

   CRTC6845_Register_Values_MODE03H : constant array (CRTC6845_Register_Type range <>) of Unsigned_8 :=
      [
       16#5F#, -- 00 Horizontal Total:
       16#4F#, -- 01 End Horizontal Display:
       16#50#, -- 02 Start Horizontal Blanking:
       16#82#, -- 03 End Horizontal Blanking:
       16#55#, -- 04 Start Horizontal Retrace:
       16#81#, -- 05 End Horizontal Retrace:
       16#BF#, -- 06 Vertical Total:
       16#1F#, -- 07 Overflow:
       16#00#, -- 08 Preset Row Scan:
       16#4F#, -- 09 Maximum Scan Line:
       16#2E#, -- 0A Cursor Start: bit5 on --> disable cursor
       16#0F#, -- 0B Cursor End:
       16#00#, -- 0C Start Address High:
       16#00#, -- 0D Start Address Low:
       16#00#, -- 0E Cursor Location High:
       16#00#, -- 0F Cursor Location Low:
       16#9C#, -- 10 Vertical Retrace Start:
       16#AE#, -- 11 Vertical Retrace End: bit 4 on --> clear irq, bit5 on --> disable irq, bit7 on --> protect
       16#8F#, -- 12 Vertical Display End:
       16#28#, -- 13 Offset:
       16#1F#, -- 14 Underline Location:
       16#96#, -- 15 Start Vertical Blanking:
       16#B9#, -- 16 End Vertical Blanking:
       16#A3#, -- 17 CRTC Mode Control:
       16#FF#  -- 18 Line Compare:
      ];

   CRTC6845_Register_Values_MODE12H : constant array (CRTC6845_Register_Type range <>) of Unsigned_8 :=
      [
       16#5F#, -- 00 Horizontal Total:
       16#4F#, -- 01 End Horizontal Display:
       16#50#, -- 02 Start Horizontal Blanking:
       16#82#, -- 03 End Horizontal Blanking:
       16#54#, -- 04 Start Horizontal Retrace:
       16#80#, -- 05 End Horizontal Retrace:
       16#0B#, -- 06 Vertical Total:
       16#3E#, -- 07 Overflow:
       16#00#, -- 08 Preset Row Scan:
       16#40#, -- 09 Maximum Scan Line:
       16#00#, -- 0A Cursor Start: bit5 on --> disable cursor
       16#00#, -- 0B Cursor End:
       16#00#, -- 0C Start Address High:
       16#00#, -- 0D Start Address Low:
       16#00#, -- 0E Cursor Location High:
       16#59#, -- 0F Cursor Location Low:
       16#EA#, -- 10 Vertical Retrace Start:
       16#8C#, -- 11 Vertical Retrace End: bit 4 on --> clear irq, bit5 on --> disable irq, bit7 on --> protect
       16#DF#, -- 12 Vertical Display End:
       16#28#, -- 13 Offset:
       16#00#, -- 14 Underline Location:
       16#E7#, -- 15 Start Vertical Blanking:
       16#04#, -- 16 End Vertical Blanking:
       16#E3#, -- 17 CRTC Mode Control:
       16#FF#  -- 18 Line Compare:
      ];

   -- Vertical Retrace End register: CRTC Registers Protect Enable
   CRTC6845_VRE         : constant := 16#11#;
   CRTC6845_VRE_PROTECT : constant := 16#80#;

   ----------------------------------------------------------------------------
   -- GC
   ----------------------------------------------------------------------------

   type GC_Register_Type is range 0 .. 16#08#;

   GC_Register_Values_MODE03H : constant array (GC_Register_Type range <>) of Unsigned_8 :=
      [
       16#00#, -- 00 Set/Reset:
       16#00#, -- 01 Enable Set/Reset:
       16#00#, -- 02 Color Compare:
       16#00#, -- 03 Data Rotate:
       16#00#, -- 04 Read Map Select:
       16#10#, -- 05 Graphics Mode:
       16#0E#, -- 06 Miscellaneous Graphics:
       16#0F#, -- 07 Color "don't care":
       16#FF#  -- 08 Bit Mask:
      ];

   GC_Register_Values_MODE12H : constant array (GC_Register_Type range <>) of Unsigned_8 :=
      [
       16#00#, -- 00 Set/Reset:
       16#00#, -- 01 Enable Set/Reset:
       16#00#, -- 02 Color Compare:
       16#00#, -- 03 Data Rotate:
       16#00#, -- 04 Read Map Select:
       16#00#, -- 05 Graphics Mode:
       16#05#, -- 06 Miscellaneous Graphics:
       16#0F#, -- 07 Color "don't care":
       16#FF#  -- 08 Bit Mask:
      ];

   ----------------------------------------------------------------------------
   -- ATC
   ----------------------------------------------------------------------------
   -- The ATC has registers in the range 0 .. 0x14, but a writing to 0x20 is
   -- used to lock the palette mapping
   ----------------------------------------------------------------------------

   type ATC_Register_Type is range 0 .. 16#20#;

   ATC_Register_Values_MODE03H : constant array (ATC_Register_Type range 0 .. 16#14#) of Unsigned_8 :=
      [
       -- 16-color palette mapping:
       -- the (input) index of this array is the attribute
       -- the value is the (output) index into DAC array values
       16#00#, -- 00 ATTRIBUTE 00: BLACK
       16#01#, -- 01 ATTRIBUTE 01: BLUE
       16#02#, -- 02 ATTRIBUTE 02: GREEN
       16#03#, -- 03 ATTRIBUTE 03: CYAN
       16#04#, -- 04 ATTRIBUTE 04: RED
       16#05#, -- 05 ATTRIBUTE 05: MAGENTA
       16#14#, -- 06 ATTRIBUTE 06: BROWN
       16#07#, -- 07 ATTRIBUTE 07: GRAY
       16#38#, -- 08 ATTRIBUTE 08: DGRAY
       16#39#, -- 09 ATTRIBUTE 09: BBLUE
       16#3A#, -- 0A ATTRIBUTE 0A: BGREEN
       16#3B#, -- 0B ATTRIBUTE 0B: BCYAN
       16#3C#, -- 0C ATTRIBUTE 0C: BRED
       16#3D#, -- 0D ATTRIBUTE 0D: BMAGENTA
       16#3E#, -- 0E ATTRIBUTE 0E: YELLOW
       16#3F#, -- 0F ATTRIBUTE 0F: WHITE
       16#0C#, -- 10 Mode Control:
       16#00#, -- 11 Overscan Color:
       16#0F#, -- 12 Color Plane Enable:
       16#08#, -- 13 Horizontal PEL Panning:
       16#00#  -- 14 Color Select:
      ];

   ATC_Register_Values_MODE12H : constant array (ATC_Register_Type range 0 .. 16#14#) of Unsigned_8 :=
      [
       -- 16-color palette mapping:
       -- the (input) index of this array is the attribute
       -- the value is the (output) index into DAC array values
       16#00#, -- 00 ATTRIBUTE 00: BLACK
       16#01#, -- 01 ATTRIBUTE 01: BLUE
       16#02#, -- 02 ATTRIBUTE 02: GREEN
       16#03#, -- 03 ATTRIBUTE 03: CYAN
       16#04#, -- 04 ATTRIBUTE 04: RED
       16#05#, -- 05 ATTRIBUTE 05: MAGENTA
       16#14#, -- 06 ATTRIBUTE 06: BROWN
       16#07#, -- 07 ATTRIBUTE 07: GRAY
       16#38#, -- 08 ATTRIBUTE 08: DGRAY
       16#39#, -- 09 ATTRIBUTE 09: BBLUE
       16#3A#, -- 0A ATTRIBUTE 0A: BGREEN
       16#3B#, -- 0B ATTRIBUTE 0B: BCYAN
       16#3C#, -- 0C ATTRIBUTE 0C: BRED
       16#3D#, -- 0D ATTRIBUTE 0D: BMAGENTA
       16#3E#, -- 0E ATTRIBUTE 0E: YELLOW
       16#3F#, -- 0F ATTRIBUTE 0F: WHITE
       16#01#, -- 10 Mode Control:
       16#00#, -- 11 Overscan Color:
       16#0F#, -- 12 Color Plane Enable:
       16#00#, -- 13 Horizontal PEL Panning:
       16#00#  -- 14 Color Select:
      ];

   -- ATC index register
   ATC_INDEX_PAS : constant := 16#20#; -- Palette Address Source

   ----------------------------------------------------------------------------
   -- DAC
   ----------------------------------------------------------------------------

   DAC_Palette : constant array (Natural range <>) of Unsigned_32 :=
      [
       -- ..RRGGBB      ..RRGGBB      ..RRGGBB      ..RRGGBB
       16#00000000#, 16#0000002A#, 16#00002A00#, 16#00002A2A#, -- 0x00 .. 0x03: BLACK, BLUE,     GREEN,  CYAN
       16#002A0000#, 16#002A002A#, 16#002A2A00#, 16#002A2A2A#, -- 0x04 .. 0x07: RED,   MAGENTA,  X,      GRAY
       16#00000015#, 16#0000003F#, 16#00002A15#, 16#00002A3F#, -- 0x08 .. 0x0B: X,     X,        X,      X
       16#002A0015#, 16#002A003F#, 16#002A2A15#, 16#002A2A3F#, -- 0x0C .. 0x0F: X,     X,        X,      X
       16#00001500#, 16#0000152A#, 16#00003F00#, 16#00003F2A#, -- 0x10 .. 0x03: X,     X,        X,      X
       16#002A1500#, 16#002A152A#, 16#002A3F00#, 16#002A3F2A#, -- 0x14 .. 0x17: BROWN, X,        X,      X
       16#00001515#, 16#0000153F#, 16#00003F15#, 16#00003F3F#, -- 0x18 .. 0x1B: X,     X,        X,      X
       16#002A1515#, 16#002A153F#, 16#002A3F15#, 16#002A3F3F#, -- 0x1C .. 0x1F: X,     X,        X,      X
       16#00150000#, 16#0015002A#, 16#00152A00#, 16#00152A2A#, -- 0x20 .. 0x23: X,     X,        X,      X
       16#003F0000#, 16#003F002A#, 16#003F2A00#, 16#003F2A2A#, -- 0x24 .. 0x27: X,     X,        X,      X
       16#00150015#, 16#0015003F#, 16#00152A15#, 16#00152A3F#, -- 0x28 .. 0x2B: X,     X,        X,      X
       16#003F0015#, 16#003F003F#, 16#003F2A15#, 16#003F2A3F#, -- 0x2C .. 0x2F: X,     X,        X,      X
       16#00151500#, 16#0015152A#, 16#00153F00#, 16#00153F2A#, -- 0x30 .. 0x33: X,     X,        X,      X
       16#003F1500#, 16#003F152A#, 16#003F3F00#, 16#003F3F2A#, -- 0x34 .. 0x37: X,     X,        X,      X
       16#00151515#, 16#0015153F#, 16#00153F15#, 16#00153F3F#, -- 0x38 .. 0x3B: DGRAY, BBLUE,    BGREEN, BCYAN
       16#003F1515#, 16#003F153F#, 16#003F3F15#, 16#003F3F3F#  -- 0x3C .. 0x3F: BRED,  BMAGENTA, YELLOW, WHITE
      ];

   ----------------------------------------------------------------------------
   -- Text mode
   ----------------------------------------------------------------------------

   type Foreground_Color_Type is new Bits_4;
   type Background_Color_Type is new Bits_4;

   type Text_Character_Attributes_Type is record
      FG : Foreground_Color_Type;
      BG : Background_Color_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for Text_Character_Attributes_Type use record
      FG at 0 range 0 .. 3;
      BG at 0 range 4 .. 7;
   end record;

   TEXT_CHARACTER_SIZE : constant := 2;
   type Text_Character_Type is record
      C          : Unsigned_8;
      Attributes : Text_Character_Attributes_Type;
   end record
      with Size => TEXT_CHARACTER_SIZE * Storage_Unit;
   for Text_Character_Type use record
      C          at 0 range 0 .. 7;
      Attributes at 1 range 0 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   procedure SEQUENCER_Register_Write
      (R     : in SEQUENCER_Register_Type;
       Value : in Unsigned_8);
   procedure CRTC6845_Register_Read
      (R     : in     CRTC6845_Register_Type;
       Value :    out Unsigned_8);
   procedure CRTC6845_Register_Write
      (R     : in CRTC6845_Register_Type;
       Value : in Unsigned_8);
   procedure CRTC6845_Registers_Lock;
   procedure CRTC6845_Registers_Unlock;
   procedure GC_Register_Write
      (R     : in GC_Register_Type;
       Value : in Unsigned_8);
   procedure ATC_Register_Write
      (R     : in ATC_Register_Type;
       Value : in Unsigned_8);
   procedure DAC_Init;
   procedure Load_Font;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SEQUENCER_Register_Write
   ----------------------------------------------------------------------------
   procedure SEQUENCER_Register_Write
      (R     : in SEQUENCER_Register_Type;
       Value : in Unsigned_8)
      is
   begin
      CPU.IO.PortOut (SEQUENCER_INDEX, Unsigned_8 (R));
      CPU.IO.PortOut (SEQUENCER_DATA, Value);
   end SEQUENCER_Register_Write;

   ----------------------------------------------------------------------------
   -- CRTC6845_Register_Read
   ----------------------------------------------------------------------------
   procedure CRTC6845_Register_Read
      (R     : in     CRTC6845_Register_Type;
       Value :    out Unsigned_8)
      is
   begin
      CPU.IO.PortOut (CRTC6845_INDEX, Unsigned_8 (R));
      Value := CPU.IO.PortIn (CRTC6845_DATA);
   end CRTC6845_Register_Read;

   ----------------------------------------------------------------------------
   -- CRTC6845_Register_Write
   ----------------------------------------------------------------------------
   procedure CRTC6845_Register_Write
      (R     : in CRTC6845_Register_Type;
       Value : in Unsigned_8)
      is
   begin
      CPU.IO.PortOut (CRTC6845_INDEX, Unsigned_8 (R));
      CPU.IO.PortOut (CRTC6845_DATA, Value);
   end CRTC6845_Register_Write;

   ----------------------------------------------------------------------------
   -- CRTC6845_Registers_Lock
   ----------------------------------------------------------------------------
   procedure CRTC6845_Registers_Lock
      is
      Unused : Unsigned_8;
   begin
      -- CRTC registers 0-7 are locked by setting bit 7 of CRTC[0x11]
      CRTC6845_Register_Read (CRTC6845_VRE, Unused);
      CRTC6845_Register_Write (CRTC6845_VRE, Unused or CRTC6845_VRE_PROTECT);
   end CRTC6845_Registers_Lock;

   ----------------------------------------------------------------------------
   -- CRTC6845_Registers_Unlock
   ----------------------------------------------------------------------------
   procedure CRTC6845_Registers_Unlock
      is
      Unused : Unsigned_8;
   begin
      -- CRTC registers 0-7 are unlocked by clearing bit 7 of CRTC[0x11]
      CRTC6845_Register_Read (CRTC6845_VRE, Unused);
      CRTC6845_Register_Write (CRTC6845_VRE, Unused and not CRTC6845_VRE_PROTECT);
   end CRTC6845_Registers_Unlock;

   ----------------------------------------------------------------------------
   -- GC_Register_Write
   ----------------------------------------------------------------------------
   procedure GC_Register_Write
      (R     : in GC_Register_Type;
       Value : in Unsigned_8)
      is
   begin
      CPU.IO.PortOut (GRAPHICS_INDEX, Unsigned_8 (R));
      CPU.IO.PortOut (GRAPHICS_DATA, Value);
   end GC_Register_Write;

   ----------------------------------------------------------------------------
   -- ATC_Register_Write
   ----------------------------------------------------------------------------
   procedure ATC_Register_Write
      (R     : in ATC_Register_Type;
       Value : in Unsigned_8)
      is
      Unused : Unsigned_8;
   begin
      Unused := CPU.IO.PortIn (INPUT_STATUS_1);
      if (Unsigned_8 (R) and ATC_INDEX_PAS) /= 0 then
         CPU.IO.PortOut (ATTRIBUTE_INDEX, Unsigned_8 (R));
         -- avoid unintentionally writing something to a register
         Unused := Value;
      else
         CPU.IO.PortOut (ATTRIBUTE_INDEX, Unsigned_8 (R));
         CPU.IO.PortOut (ATTRIBUTE_DATA_W, Value);
      end if;
   end ATC_Register_Write;

   ----------------------------------------------------------------------------
   -- DAC_Init
   ----------------------------------------------------------------------------
   procedure DAC_Init
      is
   begin
      CPU.IO.PortOut (PEL_MASK, Unsigned_8'(16#FF#));
      -- data
      for Index in DAC_Palette'Range loop
         CPU.IO.PortOut (PEL_WRITE_INDEX, Unsigned_8 (Index));
         CPU.IO.PortOut (PEL_DATA, NByte (DAC_Palette (Index))); -- R
         CPU.IO.PortOut (PEL_DATA, MByte (DAC_Palette (Index))); -- G
         CPU.IO.PortOut (PEL_DATA, LByte (DAC_Palette (Index))); -- B
      end loop;
      -- fill with 0s
      for Index in DAC_Palette'Last + 1 .. 255 loop
         CPU.IO.PortOut (PEL_WRITE_INDEX, Unsigned_8 (Index));
         CPU.IO.PortOut (PEL_DATA, Unsigned_8'(0));
         CPU.IO.PortOut (PEL_DATA, Unsigned_8'(0));
         CPU.IO.PortOut (PEL_DATA, Unsigned_8'(0));
      end loop;
   end DAC_Init;

   ----------------------------------------------------------------------------
   -- Load_Font
   ----------------------------------------------------------------------------
   procedure Load_Font
      is
      -- VGA font types and memory space
      type VGA_Character_Type is new Storage_Array (0 .. 31);
      VGA_Font_Memory : aliased array (0 .. Videofont8x16.Font_NCharacters - 1) of VGA_Character_Type
         with Alignment  => 16,
              Address    => System'To_Address (Video_Buffer_BaseAddress),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
   begin
      for Index in Videofont8x16.Font'Range loop
         declare
            Character_Pattern_Src : Videofont8x16.Font_Character_Type
               with Address    => Videofont8x16.Font (Index)'Address,
                    Import     => True,
                    Convention => Ada;
            Character_Pattern_Dst : Videofont8x16.Font_Character_Type
               with Address    => VGA_Font_Memory (Index)'Address,
                    Volatile   => True,
                    Import     => True,
                    Convention => Ada;
         begin
            Character_Pattern_Dst := Character_Pattern_Src;
         end;
      end loop;
   end Load_Font;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (Video_Memory_BaseAddress : in Integer_Address;
       Text_Memory_BaseAddress  : in Integer_Address)
      is
   begin
      if Video_Memory_BaseAddress /= 0 then
         Video_Buffer_BaseAddress := Video_Memory_BaseAddress;
      end if;
      if Text_Memory_BaseAddress /= 0 then
         Text_Buffer_BaseAddress := Text_Memory_BaseAddress;
      end if;
   end Init;

   ----------------------------------------------------------------------------
   -- Set_Mode
   ----------------------------------------------------------------------------
   procedure Set_Mode
      (Mode : in Mode_Type)
      is
   begin
      -- Video Subsystem Enable -----------------------------------------------
      -- bit0 = 1  --> the I/O and memory address decoding for the video
      --               subsystem are enabled; when set to 0, this bit disables
      --               the video I/O and memory address decoding
      -- bit1..7   --> reserved
      CPU.IO.PortOut (VIDEO_SUBSYSTEM_ENABLE, Unsigned_8'(16#01#));
      -- Miscellaneous Output -------------------------------------------------
      -- bit0 = 1           --> use 0x3D4, 0x3DA
      -- bit1 = 1           --> CPU can access VGA RAM
      -- bit2 = 0, bit3 = 0 --> 25.175 MHz
      -- bit2 = 1, bit3 = 0 --> 28.322 MHz
      -- bit4 = 0           --> reserved
      -- bit5 = 1           --> select bank1 in Even/Odd mode
      -- bit6 = 1           --> HSYNC=negative
      -- bit7 = 1           --> VSYNC=negative
      case Mode is
         when MODE03H => CPU.IO.PortOut (MISCELLANEOUS_OUTPUT, Unsigned_8'(16#67#));
         when MODE12H => CPU.IO.PortOut (MISCELLANEOUS_OUTPUT, Unsigned_8'(16#E3#));
      end case;
      -- Sequencer registers programming --------------------------------------
      for R in SEQUENCER_Register_Type'Range loop
         case Mode is
            when MODE03H => SEQUENCER_Register_Write (R, SEQUENCER_Register_Values_MODE03H (R));
            when MODE12H => SEQUENCER_Register_Write (R, SEQUENCER_Register_Values_MODE12H (R));
         end case;
      end loop;
      -- CRTC registers programming -------------------------------------------
      CRTC6845_Registers_Unlock;
      CRTC6845_Register_Write (16#11#, 0);
      for R in CRTC6845_Register_Type'Range loop
         case Mode is
            when MODE03H => CRTC6845_Register_Write (R, CRTC6845_Register_Values_MODE03H (R));
            when MODE12H => CRTC6845_Register_Write (R, CRTC6845_Register_Values_MODE12H (R));
         end case;
      end loop;
      CRTC6845_Registers_Lock;
      -- Graphic Controller registers programming -----------------------------
      for R in GC_Register_Type'Range loop
         case Mode is
            when MODE03H => GC_Register_Write (R, GC_Register_Values_MODE03H (R));
            when MODE12H => GC_Register_Write (R, GC_Register_Values_MODE12H (R));
         end case;
      end loop;
      -- Attribute Controller registers programming ---------------------------
      for R in ATC_Register_Type range 0 .. 16#14# loop
         case Mode is
            when MODE03H => ATC_Register_Write (R, ATC_Register_Values_MODE03H (R));
            when MODE12H => ATC_Register_Write (R, ATC_Register_Values_MODE12H (R));
         end case;
      end loop;
      ATC_Register_Write (16#20#, 0); -- lock color palette
      -- DAC programming ------------------------------------------------------
      -- disable video (prevents memory access during DAC programming)
      case Mode is
         when MODE03H => SEQUENCER_Register_Write (1, SEQUENCER_Register_Values_MODE03H (1) or CLKMODE_SCREEN_DISABLE);
         when MODE12H => SEQUENCER_Register_Write (1, SEQUENCER_Register_Values_MODE12H (1) or CLKMODE_SCREEN_DISABLE);
      end case;
      -- DAC programming
      DAC_Init;
      -- re-enable video
      case Mode is
         when MODE03H => SEQUENCER_Register_Write (1, SEQUENCER_Register_Values_MODE03H (1));
         when MODE12H => SEQUENCER_Register_Write (1, SEQUENCER_Register_Values_MODE12H (1));
      end case;
      -- text font installation -----------------------------------------------
      if Mode = MODE03H then
         -- switch to graphic mode
         GC_Register_Write (5, 16#00#); -- clear 16/8 bit mode
         GC_Register_Write (6, 16#04#); -- map VGA memory to 0xA0000, 64 kB, enable A/N mode
         SEQUENCER_Register_Write (2, 16#04#); -- set bitplane 2
         SEQUENCER_Register_Write (4, 16#06#); -- character map access, sequential memory
         Load_Font;
         -- restore values and switch back to text mode
         GC_Register_Write (5, GC_Register_Values_MODE03H (16#05#));
         GC_Register_Write (6, GC_Register_Values_MODE03H (16#06#));
         SEQUENCER_Register_Write (2, SEQUENCER_Register_Values_MODE03H (16#02#));
         SEQUENCER_Register_Write (4, SEQUENCER_Register_Values_MODE03H (16#04#));
      end if;
      -------------------------------------------------------------------------
   end Set_Mode;

   ----------------------------------------------------------------------------
   -- Clear_Screen
   ----------------------------------------------------------------------------
   procedure Clear_Screen
      is
   begin
      for Index in Storage_Offset range 0 .. VIDEO_TEXT_WIDTH * VIDEO_TEXT_HEIGHT * 2 - 1 loop
         declare
            Video_Cell : Unsigned_8
               with Address    => System'To_Address (Text_Buffer_BaseAddress) + Index,
                    Import     => True,
                    Convention => Ada;
         begin
            Video_Cell := 16#00#;
         end;
      end loop;
   end Clear_Screen;

   ----------------------------------------------------------------------------
   -- Print (Character)
   ----------------------------------------------------------------------------
   procedure Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       C : in Character)
      is
      type Video_Text_Memory_Type is array (0 .. (VIDEO_TEXT_WIDTH * VIDEO_TEXT_HEIGHT) - 1)
         of aliased Text_Character_Type
         with Pack => True;
      Video_Text_Memory : Video_Text_Memory_Type
         with Address    => System'To_Address (Text_Buffer_BaseAddress),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      Video_Attributes : constant Text_Character_Attributes_Type := (FG => 16#0A#, BG => 16#00#);
   begin
      Video_Text_Memory (X + Y * VIDEO_TEXT_WIDTH) :=
         Text_Character_Type'(C => To_U8 (C), Attributes => Video_Attributes);
   end Print;

   ----------------------------------------------------------------------------
   -- Print (String)
   ----------------------------------------------------------------------------
   procedure Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       S : in String)
      is
      X1 : Video_X_Coordinate_Type;
      Y1 : Video_Y_Coordinate_Type;
      C  : Character;
   begin
      X1 := X;
      Y1 := Y;
      for Index in S'Range loop
         C := S (Index);
         Print (X1, Y1, C);
         if X1 = Video_X_Coordinate_Type'Last then
            X1 := 0;
            if Y1 = Video_Y_Coordinate_Type'Last then
               Y1 := 0;
            else
               Y1 := @ + 1;
            end if;
         else
            X1 := @ + 1;
         end if;
      end loop;
   end Print;

   ----------------------------------------------------------------------------
   -- Scroll_Text
   ----------------------------------------------------------------------------
   procedure Scroll_Text
      is
      BYTES_PER_TEXTLINE : constant := VIDEO_TEXT_WIDTH * TEXT_CHARACTER_SIZE;
   begin
      Memory_Functions.Movemem (
         System'To_Address (Text_Buffer_BaseAddress) + BYTES_PER_TEXTLINE,
         System'To_Address (Text_Buffer_BaseAddress),
         (VIDEO_TEXT_HEIGHT - 1) * BYTES_PER_TEXTLINE
         );
      for X in Video_X_Coordinate_Type'Range loop
         Print (X, Video_Y_Coordinate_Type'Last, ' ');
      end loop;
   end Scroll_Text;

   ----------------------------------------------------------------------------
   -- Draw_Pixel
   ----------------------------------------------------------------------------
   procedure Draw_Pixel
      (X     : in Natural;
       Y     : in Natural;
       Color : in Unsigned_8)
      is
      type Plane_Type is array (0 .. 2**16 - 1) of Unsigned_8
         with Pack => True;
      Plane         : Plane_Type
         with Address    => System'To_Address (Video_Buffer_BaseAddress),
              Volatile   => True,
              Import     => True,
              Convention => Ada;
      Plane_Index   : Natural;
      Bit_Number    : Natural;
      Pixel_Segment : Unsigned_8;
   begin
      Plane_Index := (X / 8) + 80 * Y;
      -- MSB is drawn first
      Bit_Number := 7 - (X mod 8);
      -- select standard write
      GC_Register_Write (16#05#, 16#00#);
      for Idx in 0 .. 3 loop
         -- select plane to read
         GC_Register_Write (16#04#, Unsigned_8 (Idx));
         Pixel_Segment := Plane (Plane_Index);
         -- select plane to write
         SEQUENCER_Register_Write (2, 2**Idx);
         Plane (Plane_Index) := BitN (Pixel_Segment, Bit_Number, (Color and Unsigned_8'(2**Idx)) /= 0);
      end loop;
   end Draw_Pixel;

   ----------------------------------------------------------------------------
   -- Draw_Picture
   ----------------------------------------------------------------------------
   procedure Draw_Picture
      (Picture : in Storage_Array)
      is
      PIXEL_X   : constant := 640;
      PIXEL_Y   : constant := 480;
      Pixel_Idx : Storage_Offset := 0;
   begin
      for Y in 0 .. PIXEL_Y - 1 loop
         for X in 0 .. PIXEL_X - 1 loop
            Draw_Pixel (X, Y, To_U8 (Picture (Pixel_Idx)));
            Pixel_Idx := @ + 1;
         end loop;
      end loop;
   end Draw_Picture;

end VGA;
