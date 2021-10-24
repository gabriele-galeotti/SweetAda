-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ amiga.adb                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Unchecked_Conversion;
with Configure;
with MMIO;

package body Amiga is

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

   procedure INTENA_ClearAll is
   begin
      CUSTOM.INTENA := 16#7FFF#;
   end INTENA_ClearAll;

   procedure INTENA_ClearBitMask (Value : in Unsigned_16) is
   begin
      CUSTOM.INTENA := Value and 16#7FFF#;
   end INTENA_ClearBitMask;

   procedure INTENA_SetBitMask (Value : in Unsigned_16) is
   begin
      CUSTOM.INTENA := Value or 16#8000#;
   end INTENA_SetBitMask;

   ----------------------------------------------------------------------------
   -- INTREQ subprograms
   ----------------------------------------------------------------------------

   procedure INTREQ_ClearAll is
   begin
      CUSTOM.INTREQ := 16#7FFF#;
   end INTREQ_ClearAll;

   procedure INTREQ_ClearBitMask (Value : in Unsigned_16) is
   begin
      CUSTOM.INTREQ := Value and 16#7FFF#;
   end INTREQ_ClearBitMask;

   procedure INTREQ_SetBitMask (Value : in Unsigned_16) is
   begin
      CUSTOM.INTREQ := Value or 16#8000#;
   end INTREQ_SetBitMask;

   ----------------------------------------------------------------------------
   -- OCS_Setup
   ----------------------------------------------------------------------------
   procedure OCS_Setup is
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
      -- __REF__ http://palbo.dk/dataskolen/maskinsprog/english/letter_04.pdf
      -- __REF__ http://cyberpingui.free.fr/tuto_graphics.htm
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
      Copperlist := (
                     BPL1PTH,
                     HWord (Unsigned_32'(FRAMEBUFFER_BASEADDRESS)),
                     BPL1PTL,
                     LWord (Unsigned_32'(FRAMEBUFFER_BASEADDRESS)),
                     16#FFFF#,
                     16#FFFE#
                    );
      --
      -- __REF__ acroread /a "page=29" "platforms/M68k-UAE/doc/AmigaHardRefManual.pdf"
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
   end OCS_Setup;

   ----------------------------------------------------------------------------
   -- OCS_Print (Character)
   ----------------------------------------------------------------------------
   -- Print character C @ X, Y.
   ----------------------------------------------------------------------------
   procedure OCS_Print (
                        X : in Video_X_Coordinate_Type;
                        Y : in Video_Y_Coordinate_Type;
                        C : in Character
                       ) is
      BYTESPERRASTER     : constant := 80;
      Framebuffer_Offset : Natural;
      Pattern_Offset     : Natural;
   begin
      Framebuffer_Offset := X + Y * 8 * BYTESPERRASTER;
      for Index in Storage_Offset range 0 .. Videofont8x8.Font_Height - 1 loop
         Pattern_Offset := BYTESPERRASTER * Natural (Index);
         Framebuffer (Framebuffer_Offset + Pattern_Offset) := To_U8 (Videofont8x8.Font (Character'Pos (C)) (Index));
      end loop;
   end OCS_Print;

   ----------------------------------------------------------------------------
   -- OCS_Clear_Screen
   ----------------------------------------------------------------------------
   procedure OCS_Clear_Screen is
   begin
      for Y in Video_Y_Coordinate_Type'Range loop
         for X in Video_X_Coordinate_Type'Range loop
            OCS_Print (X, Y, ' ');
         end loop;
      end loop;
   end OCS_Clear_Screen;

   ----------------------------------------------------------------------------
   -- OCS_Print (String)
   ----------------------------------------------------------------------------
   -- Print string S @ X, Y.
   ----------------------------------------------------------------------------
   procedure OCS_Print (
                        X : in Video_X_Coordinate_Type;
                        Y : in Video_Y_Coordinate_Type;
                        S : in String
                       ) is
      X1 : Video_X_Coordinate_Type;
      Y1 : Video_Y_Coordinate_Type;
      C  : Character;
   begin
      X1 := X;
      Y1 := Y;
      for Index in S'Range loop
         C := S (Index);
         OCS_Print (X1, Y1, C);
         if X1 = Video_X_Coordinate_Type'Last then
            X1 := 0;
            if Y1 = Video_Y_Coordinate_Type'Last then
               Y1 := 0;
            else
               Y1 := Y1 + 1;
            end if;
         else
            X1 := X1 + 1;
         end if;
      end loop;
   end OCS_Print;

   ----------------------------------------------------------------------------
   -- CIAA ICR
   ----------------------------------------------------------------------------

   procedure CIAA_ICR_ClearAll is
   begin
      CIAA.ICR := 16#7F#;
   end CIAA_ICR_ClearAll;

   procedure CIAA_ICR_ClearBitMask (Value : in Unsigned_8) is
   begin
      CIAA.ICR := Value and 16#7F#;
   end CIAA_ICR_ClearBitMask;

   procedure CIAA_ICR_SetBitMask (Value : in Unsigned_8) is
   begin
      CIAA.ICR := Value or 16#80#;
   end CIAA_ICR_SetBitMask;

   ----------------------------------------------------------------------------
   -- Serialport
   ----------------------------------------------------------------------------
   -- SERPER
   -- bit    description
   -- 15     serial receive as 9 bit word
   -- 14..00 baud rate
   ----------------------------------------------------------------------------

   procedure Serialport_Init is
   begin
      -- CUSTOM.SERPER := (RATE => 16#0173#, LONG => False); -- NTSC 9600 bps
      CUSTOM.SERPER := (RATE => 16#005C#, LONG => False); -- NTSC 38400 bps
      -- CUSTOM.SERPER := (RATE => 16#0170#, LONG => False); -- PAL 9600 bps
      -- CUSTOM.SERPER := (RATE => 16#005B#, LONG => False); -- PAL 38400 bps
   end Serialport_Init;

   procedure Serialport_RX (C : out Character) is
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

   procedure Serialport_TX (C : in Character) is
   begin
      loop
         exit when CUSTOM.SERDATR.TBE;
      end loop;
      CUSTOM.SERDAT := (D => To_U8 (C), S => 16#01#);
   end Serialport_TX;

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
      Tclk_Value : constant := (Configure.TIMER_SYSCLK + (Configure.TICK_FREQUENCY * 10) / 2) /
                               (Configure.TICK_FREQUENCY * 10);
   begin
      --
      -- __REF__ kate -l 147 "cia.txt"
      --
      -- Time = Latch Value / Count Speed
      -- Where Latch Value is the value written to the low and high timer
      -- registers, and Count Speed is 7159090 for NTSC, and 7093790 for PAL.
      --
      -- A single timer count takes 10 clock cycles, so:
      -- 10 / 7093790 = 1.40968 us for 1 count
      -- for a 1 ms, then, the latch value should be:
      -- 1000 / 1.40968 = 709.38 (0x2C5)
      --
      -- CIAA uses interrupt on Level 2 (PORTS).
      --
      CIAA.TALO := Unsigned_8 (Tclk_Value mod 2**8);
      CIAA.TAHI := Unsigned_8 (Tclk_Value / 2**8);
      CIAA.CRA  := CIAA.CRA or 1; -- start Timer A
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- ZorroII_Signature_Read
   ----------------------------------------------------------------------------
   -- __REF__ http://wiki.amigaos.net/wiki/Expansion_Library
   -- __REF__ http://amigadev.elowar.com/read/ADCD_2.1/Hardware_Manual_guide/node02C8.html
   -- __REF__ http://www.theflatnet.de/pub/cbm/amiga/AmigaDevDocs/hard_k.html
   ----------------------------------------------------------------------------
   function ZorroII_Signature_Read (Offset : Storage_Offset) return Unsigned_8 is
   begin
      return (MMIO.Read (ZorroII_Cfg_Space'Address + Offset)          and 16#F0#) or
             (MMIO.Read (ZorroII_Cfg_Space'Address + Offset + 16#02#) and 16#F0#) / 2**4;
   end ZorroII_Signature_Read;

end Amiga;
