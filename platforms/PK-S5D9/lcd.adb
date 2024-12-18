-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lcd.adb                                                                                                   --
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
   -- MCU name     schematic    PMODA   NAME
   -- RESX         RESET        -       -        LCD_RESET --> pin 101 P6_10
   -- CSX          /CS          -       -        LCD_CS    --> pin 102 P6_11
   -- D/CX (SCL)   RS           4       RSPCK    LCD_SCK   --> pin 130 P1_2
   -- WRX (D/CX)   /WR          -       -        LCD_WR    --> pin 96  P1_15 (selector command/parameter)
   -- SDI/SDA      DIN_SDA      2       MOSIA    LCD_MOSI  --> pin 131 P1_1
   -- SDO          SDO          3       MISOA    LCD_MISO  --> pin 132 P1_0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Delay_Count : constant := 10_000_000;
   begin
      SPI (0).SPCR := (
         SPMS  => SPMS_SPI4,
         TXMD  => TXMD_FD,
         MSTR  => MSTR_MASTER,
         SPE   => False,
         others => <>
         );
      SPI (0).SPCR.SPE := True;
      -- MISOA_A
      PFSR (P100).PMR  := True;
      PFSR (P100).PSEL := PSEL_SPI;
      -- MOSIA_A
      PFSR (P101).PMR  := True;
      PFSR (P101).PSEL := PSEL_SPI;
      -- RSPCKA_A
      PFSR (P102).PMR  := True;
      PFSR (P102).PSEL := PSEL_SPI;
      -- GPIO on port 1: D/CX
      -- PFSR (P115).PMR  := False;
      -- LCD_RESET active low
      PFSR (P610).PMR := False;
      PORT (6).PDR (10) := True;
      PORT (6).PODR (10) := False;
      -- LCD_CS active low
      PFSR (P611).PMR := False;
      PORT (6).PDR (11) := True;
      PORT (6).PODR (11) := False;
      -- reset
      for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
      PORT (6).PODR (10) := True;
   end Init;

end LCD;
