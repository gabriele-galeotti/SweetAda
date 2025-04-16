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

with Interfaces;
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

   use Interfaces;
   use S5D9;

   -- Level 1 Command
   Software_Reset        : constant := 16#01#;
   Sleep_Out             : constant := 16#11#;
   Display_OFF           : constant := 16#28#;
   Display_ON            : constant := 16#29#;
   Color_Set             : constant := 16#2D#;
   Write_Memory_Continue : constant := 16#3C#;
   Write_CTRL_Display    : constant := 16#53#;

   procedure Init_SPI;
   procedure LCD_Delay
      (Count : in Integer);
   procedure CS_Assert
      with Inline => True;
   procedure CS_Deassert
      with Inline => True;
   procedure Command_Assert
      with Inline => True;
   procedure Data_Assert
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --
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
   --

   ----------------------------------------------------------------------------
   -- Init_SPI
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
      SPI (0).SPSCR.SPSLN := SPSLN0;
      loop exit when not SPI (0).SPSR.IDLNF; end loop;
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
      LCD_Delay (1_000);
      PORT (6).PODR (10) := True;
      LCD_Delay (1_000_000);
   end Init_SPI;

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
   -- helpers
   ----------------------------------------------------------------------------
   procedure CS_Assert is begin PORT (6).PODR (11) := False; end CS_Assert;
   procedure CS_Deassert is begin PORT (6).PODR (11) := True; end CS_Deassert;
   procedure Command_Assert is begin PORT (1).PODR (15) := False; end Command_Assert;
   procedure Data_Assert is begin PORT (1).PODR (15) := True; end Data_Assert;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      Init_SPI;
      -- LCD startup
      CS_Assert;
      Command_Assert;
      -- Software Reset
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Software_Reset;
      LCD_Delay (1_000_000);
      -- Sleep Out
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Sleep_Out;
      LCD_Delay (1_000_000);
      -- Display OFF
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Display_OFF;
      LCD_Delay (1_000_000);
      -- Display ON
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Display_ON;
      LCD_Delay (1_000_000);
      CS_Deassert;
      -- Write CTRL Display
      CS_Assert;
      Command_Assert;
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Write_CTRL_Display;
      Data_Assert;
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := 16#04#;
      CS_Deassert;
      -- Color Set
      CS_Assert;
      Command_Assert;
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Color_Set;
      Data_Assert;
      -- R 5-bit
      for Idx in 0 .. 31 loop
         loop exit when SPI (0).SPSR.SPTEF; end loop;
         SPI (0).SPDR.SPDR8 := Unsigned_8 (Idx);
      end loop;
      -- G 6-bit
      for Idx in 0 .. 63 loop
         loop exit when SPI (0).SPSR.SPTEF; end loop;
         SPI (0).SPDR.SPDR8 := Unsigned_8 (Idx);
      end loop;
      -- B 5-bit
      for Idx in 0 .. 31 loop
         loop exit when SPI (0).SPSR.SPTEF; end loop;
         SPI (0).SPDR.SPDR8 := Unsigned_8 (Idx);
      end loop;
      CS_Deassert;
      -- draw a frame
      CS_Assert;
      Command_Assert;
      loop exit when SPI (0).SPSR.SPTEF; end loop;
      SPI (0).SPDR.SPDR8 := Write_Memory_Continue;
      LCD_Delay (20_000);
      Data_Assert;
      declare
         Color : Unsigned_8;
      begin
         for Y in 0 .. 319 loop
            Color := 0;
            for X in 0 .. 239 loop
               loop exit when SPI (0).SPSR.SPTEF; end loop;
               SPI (0).SPDR.SPDR8 := Shift_Left (Color, 2);
               loop exit when SPI (0).SPSR.SPTEF; end loop;
               SPI (0).SPDR.SPDR8 := Shift_Left (Color, 4);
               loop exit when SPI (0).SPSR.SPTEF; end loop;
               SPI (0).SPDR.SPDR8 := Shift_Left (Color, 6);
               Color := @ + 1;
            end loop;
         end loop;
      end;
   end Init;

end LCD;
