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

with CPU;
with S5D9;
with BSP;

package body LCD
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use S5D9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- ILI9341V
   ----------------------------------------------------------------------------
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

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Delay_Count : constant := 10_000_000;
   begin
      SPI (0).SPSR.MODF := False;
      SPI (0).SPCR.SPE := True;
      SPI (0).SPPCR := (others => <>);
      SPI (0).SPBR.SPBR := 16#E0#;
      SPI (0).SPCR := (
         SPMS   => SPMS_SPI4,
         TXMD   => TXMD_FD,
         MSTR   => MSTR_MASTER,
         SPE    => True,
         others => <>
         );
      loop exit when not SPI (0).SPSR.IDLNF; end loop;
      SPI (0).SPSCR.SPSLN := SPSLN0;
      SPI (0).SPDCR := (
         SPFC   => SPFC_1,     -- Number of Frames Specification
         SPRDTD => SPRDTD_RB,  -- SPI Receive/Transmit Data Select
         -- SPRDTD => SPRDTD_TB,  -- SPI Receive/Transmit Data Select
         -- SPLW   => SPLW_HALFW, -- SPI Word Access/Halfword Access Specification
         -- SPBYT  => SPBYT_BYTE, -- SPI Byte Access Specification
         SPLW   => SPLW_FULLW, -- SPI Word Access/Halfword Access Specification
         SPBYT  => SPBYT_WORD, -- SPI Byte Access Specification
         others => <>
         );
      -- SPI (0).SPCR.SPE := True;

      -- MISOA_A
--      PFSR (P100).PMR  := True;
--      PFSR (P100).PSEL := PSEL_SPI;
      PFSR (P100).PMR  := False;
      PORT (1).PDR (0) := False;
      -- MOSIA_A
--      PFSR (P101).PMR  := True;
--      PFSR (P101).PSEL := PSEL_SPI;
      PFSR (P101).PMR  := False;
      PORT (1).PDR (1) := False;
      -- RSPCKA_A LCD SCK
--      PFSR (P102).PMR  := True;
--      PFSR (P102).PSEL := PSEL_SPI;
      PFSR (P102).PMR  := False;
      PORT (1).PDR (2) := False;
      -- RESX LCD /RESET active low
      PFSR (P610).PMR := False;
      PORT (6).PDR (10) := True;
      -- CSX LCD /CS active low
      PFSR (P611).PMR := False;
      PORT (6).PDR (11) := True;
      -- D/CX LCD command/data
      PFSR (P115).PMR := False;
      PORT (1).PDR (15) := False; -- float
      -- low on D/CX = command
      -- PORT (1).PODR (15) := False;
      -- pulse /RESET, then deassert
      PORT (6).PODR (10) := False;
      for Delay_Loop_Count in 1 .. 1_000 loop CPU.NOP; end loop;
      PORT (6).PODR (10) := True;
      for Delay_Loop_Count in 1 .. 1_000 loop CPU.NOP; end loop;
      --
      return;
      -- /CS active
      PORT (6).PODR (11) := False;
      -- SPI programming
      SPI (0).SPCMD (0) := (
         CPHA   => CPHA_TRAIL, -- RSPCK Phase Setting
         CPOL   => CPOL_HIGH,  -- RSPCK Polarity Setting
         BRDV   => BRDV_DIV8,  -- Bit Rate Division Setting
         SPB    => SPB_8,      -- SPI Data Length Setting
         LSBF   => LSBF_MSB,   -- SPI LSB First
         others => <>
         );
      SPI (0).SPSR := (
         OVRF   => False,
         MODF   => False,
         PERF   => False,
         UDRF   => False,
         SPTEF  => True,
         others => <>
         );
      loop
         BSP.Console_Putchar ('X');
         loop exit when SPI (0).SPSR.SPTEF; end loop;
         SPI (0).SPDR.SPDR := 16#AA#;
         for Delay_Loop_Count in 1 .. 100_000 loop CPU.NOP; end loop;
      end loop;

   end Init;

end LCD;
