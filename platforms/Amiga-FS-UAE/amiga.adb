-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ amiga.adb                                                                                                 --
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

with Ada.Characters.Latin_1;
with Ada.Unchecked_Conversion;
with Configure;
with Memory_Functions;
with MMIO;

package body Amiga
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   BYTES_PER_RASTER   : constant := 80;
   BYTES_PER_TEXTLINE : constant := BYTES_PER_RASTER * 8;

   procedure OCS_Scroll;
   procedure OCS_Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       C : in Character);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- INTENA subprograms
   ----------------------------------------------------------------------------

   procedure INTENA_ClearAll
      is
   begin
      CUSTOM.INTENA := 16#7FFF#;
   end INTENA_ClearAll;

   procedure INTENA_ClearBitMask
      (Value : in Unsigned_16)
      is
   begin
      CUSTOM.INTENA := Value and 16#7FFF#;
   end INTENA_ClearBitMask;

   procedure INTENA_SetBitMask
      (Value : in Unsigned_16)
      is
   begin
      CUSTOM.INTENA := Value or 16#8000#;
   end INTENA_SetBitMask;

   ----------------------------------------------------------------------------
   -- INTREQ subprograms
   ----------------------------------------------------------------------------

   procedure INTREQ_ClearAll
      is
   begin
      CUSTOM.INTREQ := 16#7FFF#;
   end INTREQ_ClearAll;

   procedure INTREQ_ClearBitMask
      (Value : in Unsigned_16)
      is
   begin
      CUSTOM.INTREQ := Value and 16#7FFF#;
   end INTREQ_ClearBitMask;

   procedure INTREQ_SetBitMask
      (Value : in Unsigned_16)
      is
   begin
      CUSTOM.INTREQ := Value or 16#8000#;
   end INTREQ_SetBitMask;

   ----------------------------------------------------------------------------
   -- OCS_Print (Character)
   ----------------------------------------------------------------------------
   -- Print character C @ X, Y.
   ----------------------------------------------------------------------------
   procedure OCS_Print
      (X : in Video_X_Coordinate_Type;
       Y : in Video_Y_Coordinate_Type;
       C : in Character)
      is
      Framebuffer_Offset : Natural;
      Pattern_Offset     : Natural;
   begin
      Framebuffer_Offset := X + Y * BYTES_PER_TEXTLINE;
      for Index in Storage_Offset range 0 .. Videofont8x8.Font_Height - 1 loop
         Pattern_Offset := BYTES_PER_RASTER * Natural (Index);
         Framebuffer (Framebuffer_Offset + Pattern_Offset) :=
            To_U8 (Videofont8x8.Font (Character'Pos (C)) (Index));
      end loop;
   end OCS_Print;

   ----------------------------------------------------------------------------
   -- OCS_Scroll
   ----------------------------------------------------------------------------
   -- Scroll a line of text.
   ----------------------------------------------------------------------------
   procedure OCS_Scroll
      is
   begin
      Memory_Functions.Movemem (
         Framebuffer'Address + BYTES_PER_TEXTLINE,
         Framebuffer'Address,
         (VIDEO_WIDTH * VIDEO_HEIGHT) / 8 - BYTES_PER_TEXTLINE
         );
      for X in Video_X_Coordinate_Type'Range loop
         OCS_Print (X, Video_Y_Coordinate_Type'Last, ' ');
      end loop;
   end OCS_Scroll;

   ----------------------------------------------------------------------------
   -- OCS_Clear_Screen
   ----------------------------------------------------------------------------
   procedure OCS_Clear_Screen
      is
   begin
      for Y in Video_Y_Coordinate_Type'Range loop
         for X in Video_X_Coordinate_Type'Range loop
            OCS_Print (X, Y, ' ');
         end loop;
      end loop;
      -- initialize the cursor
      Cursor := (0, 0);
   end OCS_Clear_Screen;

   ----------------------------------------------------------------------------
   -- OCS_Print (Character)
   ----------------------------------------------------------------------------
   -- Print character C @ Cursor.
   ----------------------------------------------------------------------------
   procedure OCS_Print
      (C : in Character)
      is
      procedure Y_Increment;
      procedure Y_Increment
         is
      begin
         if Cursor.Y = Video_Y_Coordinate_Type'Last then
            OCS_Scroll;
         else
            Cursor.Y := @ + 1;
         end if;
      end Y_Increment;
   begin
      if C = ISO88591.CR then
         Cursor.X := 0;
         return;
      elsif C = ISO88591.LF then
         Y_Increment;
         return;
      end if;
      OCS_Print (Cursor.X, Cursor.Y, C);
      if Cursor.X = Video_X_Coordinate_Type'Last then
         Cursor.X := 0;
         Y_Increment;
      else
         Cursor.X := @ + 1;
      end if;
   end OCS_Print;

   ----------------------------------------------------------------------------
   -- OCS_Print (String)
   ----------------------------------------------------------------------------
   -- Print string S.
   ----------------------------------------------------------------------------
   procedure OCS_Print
      (S : in String)
      is
   begin
      for Index in S'Range loop
         OCS_Print (S (Index));
      end loop;
   end OCS_Print;

   ----------------------------------------------------------------------------
   -- OCS_Setup
   ----------------------------------------------------------------------------
   procedure OCS_Setup
      is
      function To_U32 is new Ada.Unchecked_Conversion (Address, Unsigned_32);
      Unused : Unsigned_16 with Unreferenced => True;
   begin
      --
      -- Bitplane colors:
      -- 0x000 = black
      -- 0x6FE = sky blue
      -- 0x8E0 = light green
      -- 0xFFF = white
      --
      CUSTOM.COLOR00 := 16#0000#; -- background color
      CUSTOM.COLOR01 := 16#08E0#; -- foreground color 1st bitplane
      CUSTOM.COLOR02 := 16#0FFF#; -- foreground color 2nd bitplane
      --
      -- Basic video hardware setup.
      -- PAL non-interlaced: 640 x 256, 16 KiB video memory.
      --
      CUSTOM.BPLCON0 := HRES or NBITPLANES1; -- two hi-res colors (monochrome), non-interlaced
      CUSTOM.BPLCON1 := 16#0000#;            -- horizontal scroll
      CUSTOM.BPL1MOD := 16#0000#;            -- modulo for odd-bit planes = 0
      CUSTOM.BPL2MOD := 16#0000#;            -- modulo for even-bit planes = 0
      CUSTOM.DIWSTRT := 16#2C81#;            -- START = 0x2C
      CUSTOM.DIWSTOP := 16#F4C1#;            -- STOP = 200 + START = 0xF4
      CUSTOM.DIWSTOP := 16#38C1#;            -- STOP = STOP + 56 (0x38)
      CUSTOM.DDFSTRT := 16#003C#;
      CUSTOM.DDFSTOP := 16#00D4#;
      --
      -- Setup Copper.
      --
      Copperlist := [
                     BPL1PTH,
                     HWord (Unsigned_32'(FRAMEBUFFER_BASEADDRESS)),
                     BPL1PTL,
                     LWord (Unsigned_32'(FRAMEBUFFER_BASEADDRESS)),
                     16#FFFF#,
                     16#FFFE#
                    ];
      --
      -- "... when the end of  vertical blanking  occurs, the Copper is
      -- automatically forced to restart its operations at the address
      -- contained in COP1LC."
      --
      CUSTOM.COP1LCH := To_U32 (Copperlist'Address); -- load COPPER jump register
      Unused := CUSTOM.COPJMP1;                      -- COPPER load pc from COP1LCH
      --
      -- Start Bit plane (raster) DMA and Copper DMA.
      -- Bit plane DMA is necessary to create the video data stream from
      -- memory. Copper DMA is necessary because Copper utilizes DMA to
      -- fetch instructions from memory.
      --
      CUSTOM.DMACON := DMACON_SET  or
                       DMAF_MASTER or
                       DMAF_RASTER or
                       DMAF_COPPER;
      -- initialize the screen
      OCS_Clear_Screen;
   end OCS_Setup;

   ----------------------------------------------------------------------------
   -- CIAA ICR
   ----------------------------------------------------------------------------

   procedure CIAA_ICR_ClearAll
      is
   begin
      CIAA.ICR := 16#7F#;
   end CIAA_ICR_ClearAll;

   procedure CIAA_ICR_ClearBitMask
      (Value : in Unsigned_8)
      is
   begin
      CIAA.ICR := Value and 16#7F#;
   end CIAA_ICR_ClearBitMask;

   procedure CIAA_ICR_SetBitMask
      (Value : in Unsigned_8)
      is
   begin
      CIAA.ICR := Value or 16#80#;
   end CIAA_ICR_SetBitMask;

   ----------------------------------------------------------------------------
   -- Serialport
   ----------------------------------------------------------------------------
   -- SERPER
   -- bit#   description
   -- 15     serial receive as 9 bit word
   -- 14..00 baud rate
   ----------------------------------------------------------------------------

   procedure Serialport_RX
      (C : out Character)
      is
      R : SERDATR_Type;
   begin
      loop
         R := CUSTOM.SERDATR;
         if R.RBF then
            C := To_Ch (R.DB);
            INTREQ_ClearBitMask (16#0800#);
            exit;
         end if;
      end loop;
   end Serialport_RX;

   procedure Serialport_TX
      (C : in Character)
      is
   begin
      loop
         exit when CUSTOM.SERDATR.TBE;
      end loop;
      CUSTOM.SERDAT := (D => To_U8 (C), S => 16#01#);
   end Serialport_TX;

   procedure Serialport_Init
      is
   begin
      -- CUSTOM.SERPER := (RATE => 16#0173#, LONG => False); -- NTSC clock, 9600 bps
      CUSTOM.SERPER := (RATE => 16#005C#, LONG => False); -- NTSC clock, 38400 bps
      -- CUSTOM.SERPER := (RATE => 16#0170#, LONG => False); -- PAL clock, 9600 bps
      -- CUSTOM.SERPER := (RATE => 16#005B#, LONG => False); -- PAL clock, 38400 bps
   end Serialport_Init;

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init
      is
      Tclk_Value : constant :=
         (Configure.TIMER_SYSCLK + (Configure.TICK_FREQUENCY * 10) / 2) /
         (Configure.TICK_FREQUENCY * 10);
   begin
      --
      -- Time = Latch Value / Count Speed
      -- Latch Value is the value written to the low and high timer registers
      -- Count Speed is 7159090 for NTSC, and 7093790 for PAL
      --
      -- A single timer count takes 10 clock cycles, so:
      -- 10 / 7093790 = 1.40968 us for 1 count
      -- for a 1 ms, then, the latch value should be:
      -- 1000 / 1.40968 = 709.38 (0x2C5)
      --
      -- CIAA uses interrupt on Level 2 (PORTS).
      --
      CIAA.CRA  := (
                    START   => False,
                    PBON    => False,
                    OUTMODE => OUTMODE_PULSE,
                    RUNMODE => RUNMODE_RUN,
                    LOAD    => False,
                    INMODE  => INMODE_02,
                    SPMODE  => SPMODE_IN,
                    others  => <>
                   );
      CIAA.TALO := Unsigned_8 (Tclk_Value mod 2**8);
      CIAA.TAHI := Unsigned_8 (Tclk_Value / 2**8);
      CIAA.CRA.START := True;
   end Tclk_Init;

end Amiga;
