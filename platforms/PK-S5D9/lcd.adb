-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lcd.adb                                                                                                   --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with CPU;
with S5D9;

package body LCD
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;
   use S5D9;

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

   function To_U8 is new Ada.Unchecked_Conversion (MADCTL_Type, Unsigned_8);

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

   function To_U8 is new Ada.Unchecked_Conversion (CTRL_Type, Unsigned_8);

   -- Subprograms

   procedure LCD_Delay
      (Count : in Integer);
   procedure Init_SPI;
   procedure CS_Assert
      with Inline => True;
   procedure CS_Deassert
      with Inline => True;
   procedure Command_Assert
      with Inline => True;
   procedure Data_Assert
      with Inline => True;
   procedure Data_Send
      (Data : in Unsigned_8)
      with Inline => True;
   procedure DataArray_Send
      (Data : in Byte_Array)
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- LCD_Delay
   ----------------------------------------------------------------------------
   procedure LCD_Delay
      (Count : in Integer)
      is
   begin
      for Delay_Loop_Count in 1 .. Count loop CPU.NOP; end loop;
   end LCD_Delay;

   ----------------------------------------------------------------------------
   -- Init_SPI
   ----------------------------------------------------------------------------
   -- ILI9341V
   -- SPI0 on PORT1
   -- IM[3:0] = 1110, 4-wire 8-bit data serial interface II, SDI: In SDO: Out
   -- LCD name     schematic    PMODA   SPI
   -- RESX         RESET        -       -        LCD_RESET --> pin 101 P6_10
   -- CSX          /CS          -       -        LCD_CS    --> pin 102 P6_11
   -- D/CX (SCL)   RS           4       RSPCK    LCD_SCK   --> pin 130 P1_2
   -- SDI/SDA      DIN_SDA      2       MOSIA    LCD_MOSI  --> pin 131 P1_1
   -- SDO          SDO          3       MISOA    LCD_MISO  --> pin 132 P1_0
   -- RDX          /RD          -       -        LCD_RD    --> pin 95  P1_14
   -- WRX (D/CX)   /WR          -       -        LCD_WR    --> pin 96  P1_15 (selector command/parameter)
   ----------------------------------------------------------------------------
   procedure Init_SPI
      is
   begin
      SPI (0).SPCR.SPE := False;
      SPI (0).SPSR := (
         OVRF   => False,
         MODF   => False,
         PERF   => False,
         UDRF   => False,
         SPTEF  => True,
         others => <>
         );
      SPI (0).SPCR := (
         SPMS   => SPMS_SPI4,
         TXMD   => TXMD_FD,
         MSTR   => MSTR_MASTER,
         SPE    => True,
         others => <>
         );
      SPI (0).SPPCR := (others => <>);
      SPI (0).SPBR.SPBR := 16;
      SPI (0).SPSCR.SPSLN := SPSLN_1;
      SPI (0).SPDCR := (
         SPFC   => SPFC_1,     -- Number of Frames Specification
         SPRDTD => SPRDTD_RB,  -- SPI Receive/Transmit Data Select
         -- SPLW   => SPLW_FULLW, -- SPI Word Access/Halfword Access Specification
         -- SPBYT  => SPBYT_WORD, -- SPI Byte Access Specification
         SPLW   => SPLW_HALFW, -- SPI Word Access/Halfword Access Specification
         SPBYT  => SPBYT_BYTE, -- SPI Byte Access Specification
         others => <>
         );
      SPI (0).SPCMD (0) := (
         CPHA   => CPHA_LEAD, -- RSPCK Phase Setting
         CPOL   => CPOL_LOW,  -- RSPCK Polarity Setting
         BRDV   => BRDV_DIV2, -- Bit Rate Division Setting
         SPB    => SPB_8,     -- SPI Data Length Setting
         LSBF   => LSBF_MSB,  -- SPI MSB First
         others => <>
         );
      -- MISOA_A
      PFSR (P100).PMR  := True;
      PFSR (P100).PSEL := PSEL_SPI;
      -- MOSIA_A
      PFSR (P101).PMR  := True;
      PFSR (P101).PSEL := PSEL_SPI;
      -- RSPCKA_A LCD SCK
      PFSR (P102).PMR  := True;
      PFSR (P102).PSEL := PSEL_SPI;
      -- RESX LCD /RESET active low
      PFSR (P610).PMR := False;
      PORT (6).PDR (10) := True;
      -- CSX LCD /CS active low
      PFSR (P611).PMR := False;
      PORT (6).PDR (11) := True;
      -- D/CX LCD command/data
      PFSR (P115).PMR := False;
      PORT (1).PDR (15) := True;
      -- pulse /RESET
      PORT (6).PODR (10) := False;
      LCD_Delay (1_000_000);
      PORT (6).PODR (10) := True;
      LCD_Delay (1_000_000);
   end Init_SPI;

   ----------------------------------------------------------------------------
   -- /CS and D/C line helpers
   ----------------------------------------------------------------------------
   procedure CS_Assert is begin PORT (6).PODR (11) := False; end CS_Assert;
   procedure CS_Deassert is begin PORT (6).PODR (11) := True; end CS_Deassert;
   procedure Command_Assert is begin PORT (1).PODR (15) := False; end Command_Assert;
   procedure Data_Assert is begin PORT (1).PODR (15) := True; end Data_Assert;

   ----------------------------------------------------------------------------
   -- Data_Send
   ----------------------------------------------------------------------------
   procedure Data_Send
      (Data : in Unsigned_8)
      is
      RX_Data : Unsigned_8 with Unreferenced => True;
   begin
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Data;
      loop exit when SPI (0).SPSR.SPRF; end loop;
      RX_Data := SPI (0).SPDR.SPDR8;
   end Data_Send;

   ----------------------------------------------------------------------------
   -- Command_Send
   ----------------------------------------------------------------------------
   procedure Command_Send
      (Command : in Unsigned_8)
      renames Data_Send;

   ----------------------------------------------------------------------------
   -- DataArray_Send
   ----------------------------------------------------------------------------
   procedure DataArray_Send
      (Data : in Byte_Array)
      is
   begin
      for Index in Data'Range loop
         Data_Send (Data (Index));
      end loop;
   end DataArray_Send;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      Init_SPI;
      -- Software Reset
      CS_Assert;
      Command_Assert;
      Command_Send (Software_Reset);
      CS_Deassert;
      -- Sleep Out
      CS_Assert;
      Command_Assert;
      Command_Send (Sleep_Out);
      CS_Deassert;
      -- Display ON
      CS_Assert;
      Command_Assert;
      Command_Send (Display_ON);
      CS_Deassert;
      -- Write CTRL Display
      CS_Assert;
      Command_Assert;
      Command_Send (Write_CTRL_Display);
      Data_Assert;
      DataArray_Send (Byte_Array'([
         To_U8 (CTRL_Type'(BL => True, others => <>))
         ]));
      CS_Deassert;
      -- Memory Access Control
      CS_Assert;
      Command_Assert;
      Command_Send (Memory_Access_Control);
      Data_Assert;
      DataArray_Send (Byte_Array'([
         To_U8 (MADCTL_Type'(
            MH     => MH_L2R,
            BGR    => BGR_RGB,
            ML     => ML_T2B,
            MV     => MV_NORMAL,
            MX     => MX_L2R,
            MY     => MY_T2B,
            others => <>
            ))
         ]));
      CS_Deassert;
      -- Normal Display Mode ON
      CS_Assert;
      Command_Assert;
      Command_Send (Normal_Display_Mode_ON);
      CS_Deassert;
      -- Pixel Format Set
      CS_Assert;
      Command_Assert;
      Command_Send (Pixel_Format_Set);
      Data_Assert;
      DataArray_Send (Byte_Array'([16#66#]));
      CS_Deassert;
      -- Color Set RGB565
      CS_Assert;
      Command_Assert;
      Command_Send (Color_Set);
      Data_Assert;
      for Idx in 0 .. 31 loop Data_Send (Unsigned_8 (Idx)); end loop;
      for Idx in 0 .. 63 loop Data_Send (Unsigned_8 (Idx)); end loop;
      for Idx in 0 .. 31 loop Data_Send (Unsigned_8 (Idx)); end loop;
      CS_Deassert;
      -- Column Address Set
      CS_Assert;
      Command_Assert;
      Command_Send (Column_Address_Set);
      Data_Assert;
      DataArray_Send (Byte_Array'([0, 0, 0, 16#EF#]));
      CS_Deassert;
      -- Page Address Set
      CS_Assert;
      Command_Assert;
      Command_Send (Page_Address_Set);
      Data_Assert;
      DataArray_Send (Byte_Array'([0, 0, 1, 16#3F#]));
      CS_Deassert;
      -- Vertical Scrolling Start Address
      CS_Assert;
      Command_Assert;
      Command_Send (Vertical_Scrolling_Start_Address);
      Data_Assert;
      DataArray_Send (Byte_Array'([0, 0]));
      CS_Deassert;
      -- draw a frame with switching colors
      CS_Assert;
      Command_Assert;
      Command_Send (Memory_Write);
      Data_Assert;
      declare
         Color_R  : Unsigned_8 := 0;
         Color_G  : Unsigned_8 := 0;
         Color_B  : Unsigned_8 := 0;
         Switch_R : Unsigned_8 := 0;
         Switch_G : Unsigned_8 := 0;
         Switch_B : Unsigned_8 := 0;
      begin
         for Y in 0 .. 319 loop
            if    Y < (320 / 3) then
               Switch_R := 16#FF#; Switch_G := 0; Switch_B := 0;
            elsif Y >= (320 / 3) and then Y < (320 * 2 / 3) then
               Switch_R := 0; Switch_G := 16#FF#; Switch_B := 0;
            elsif Y > (320 * 2 / 3) then
               Switch_R := 0; Switch_G := 0; Switch_B := 16#FF#;
            end if;
            for X in 0 .. 239 loop
               Data_Send (Shift_Left (Color_R, 2) and Switch_R);
               Data_Send (Shift_Left (Color_G, 2) and Switch_G);
               Data_Send (Shift_Left (Color_B, 2) and Switch_B);
            end loop;
            Color_R := @ + 1;
            Color_G := @ + 1;
            Color_B := @ + 1;
         end loop;
      end;
      CS_Deassert;
   end Init;

end LCD;
