-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl110.adb                                                                                                 --
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

package body PL110 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- RGB565 encoding
   ----------------------------------------------------------------------------

   subtype R_Type is Natural range 0 .. 2**5 - 1;
   subtype G_Type is Natural range 0 .. 2**6 - 1;
   subtype B_Type is Natural range 0 .. 2**5 - 1;

   function RGB565 (R : R_Type; G : G_Type; B : B_Type) return Unsigned_16;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- RGB565
   ----------------------------------------------------------------------------
   function RGB565 (R : R_Type; G : G_Type; B : B_Type) return Unsigned_16 is
   begin
      return Shift_Left (Unsigned_16 (R), 11) or
             Shift_Left (Unsigned_16 (G), 5)  or
                         Unsigned_16 (B);
   end RGB565;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (Descriptor : in Descriptor_Type) is
      PL110_Device : aliased PL110_Type with
         Address    => Descriptor.Base_Address,
         Volatile   => True,
         Import     => True,
         Convention => Ada;
   begin
      -- WxH = 640x480, 16 bpp RGB565
      PL110_Device.LCDTiming0 := (
                                  Reserved => 0,
                                  PPL      => 640 / 16 - 1,
                                  HSW      => 64 - 1,
                                  HFP      => 32 - 1,
                                  HBP      => 64 - 1
                                 );
      PL110_Device.LCDTiming1 := (
                                  LPP => 480 - 1,
                                  VSW => 19 - 1,
                                  VFP => 11,
                                  VBP => 8
                                 );
      PL110_Device.LCDUPBASE := FRAMEBUFFER_BASEADDRESS;
      PL110_Device.LCDControl := (
                                  LcdEn       => 1,
                                  LcdBpp      => BPP16,
                                  LcdBW       => 0,
                                  LcdTFT      => 1,
                                  LcdMono8    => 0,
                                  LcdDual     => 0,
                                  BGR         => 0,
                                  BEBO        => 0,
                                  BEPO        => 0,
                                  LcdPwr      => 1,
                                  LcdVComp    => VCOMPBP,
                                  Reserved1   => 0,
                                  LDmaFIFOTME => 0,
                                  WATERMARK   => 0,
                                  Reserved2   => 0
                                 );
      -- clear screen
      declare
         BG_Color : constant Unsigned_16 := RGB565 (16#1F#, 16#0F#, 16#00#);
      begin
         for Index in Framebuffer'Range loop
            Framebuffer (Index) := BG_Color;
         end loop;
      end;
   end Init;

   ----------------------------------------------------------------------------
   -- Print (Character)
   ----------------------------------------------------------------------------
   -- Print character C @ X, Y.
   ----------------------------------------------------------------------------
   procedure Print (
                    X : in Video_X_Coordinate_Type;
                    Y : in Video_Y_Coordinate_Type;
                    C : in Character
                   ) is
      Framebuffer_Offset : Natural;
      Pattern            : Unsigned_8;
   begin
      Framebuffer_Offset := X * 8 + Y * 16 * VIDEO_WIDTH;
      for Index in Storage_Offset range 0 .. Videofont8x16.Font_Height - 1 loop
         Pattern := Unsigned_8 (Videofont8x16.Font (Character'Pos (C)) (Index));
         for B in 0 .. 7 loop
            if (Shift_Right (Pattern, B) and 1) /= 0 then
               Framebuffer (Framebuffer_Offset + (7 - B)) := 16#FFFF#;
            end if;
         end loop;
         Framebuffer_Offset := Framebuffer_Offset + VIDEO_WIDTH;
      end loop;
   end Print;

   ----------------------------------------------------------------------------
   -- Print (String)
   ----------------------------------------------------------------------------
   -- Print string S @ X, Y.
   ----------------------------------------------------------------------------
   procedure Print (
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
         Print (X1, Y1, C);
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
   end Print;

end PL110;
