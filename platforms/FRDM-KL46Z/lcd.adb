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

with Definitions;
with Bits;
with CPU;
with KL46Z;
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

   use Definitions;
   use Bits;
   use KL46Z;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- safe state
      LCD_GCR.LCDEN   := False;
      LCD_GCR.PADSAFE := True;
      -- port multiplexing control
      PORTB_MUXCTRL.PCR (7).MUX  := MUX_ALT0; -- PTB7  = LCD_P7
      PORTB_MUXCTRL.PCR (8).MUX  := MUX_ALT0; -- PTB8  = LCD_P8
      PORTB_MUXCTRL.PCR (10).MUX := MUX_ALT0; -- PTB10 = LCD_P10
      PORTB_MUXCTRL.PCR (11).MUX := MUX_ALT0; -- PTB11 = LCD_P11
      PORTB_MUXCTRL.PCR (21).MUX := MUX_ALT0; -- PTB21 = LCD_P17
      PORTB_MUXCTRL.PCR (22).MUX := MUX_ALT0; -- PTB22 = LCD_P18
      PORTB_MUXCTRL.PCR (23).MUX := MUX_ALT0; -- PTB23 = LCD_P19
      PORTC_MUXCTRL.PCR (17).MUX := MUX_ALT0; -- PTC17 = LCD_P37
      PORTC_MUXCTRL.PCR (18).MUX := MUX_ALT0; -- PTC18 = LCD_P38
      PORTD_MUXCTRL.PCR (0).MUX  := MUX_ALT0; -- PTD0  = LCD_P40
      PORTE_MUXCTRL.PCR (4).MUX  := MUX_ALT0; -- PTE4  = LCD_P52
      PORTE_MUXCTRL.PCR (5).MUX  := MUX_ALT0; -- PTE5  = LCD_P53
      -- setup controller
      LCD_GCR := (
         DUTY      => DUTY_4BP,          -- 4 backplane pins, 1/4 duty cycle
         LCLK      => LCLK_PS8,
         SOURCE    => SOURCE_ALTSOURCE,  -- select MCGIRCLK
         LCDEN     => False,
         LCDSTP    => False,
         LCDDOZE   => False,
         FFR       => True,
         ALTSOURCE => ALTSOURCE_CLKSRC1,
         ALTDIV    => ALTDIV_DIV1,       -- assume 32.768 kHz
         FDCIEN    => False,
         PADSAFE   => True,
         VSUPPLY   => VSUPPLY_INT,       -- drive VLL3 externally
         LADJ      => LADJ_SLOWCLK,
         CPSEL     => CPSEL_ENABLE,      -- use capacitor charge pump
         RVTRIM    => 0,
         RVEN      => False,             -- disable voltage regulator
         others    => <>
         );
      -- setup display modes
      LCD_AR := (
         BRATE  => BRATE_1,
         BMODE  => BMODE_BLANK,
         BLANK  => False,
         ALT    => False,
         BLINK  => False,
         others => <>
         );
      -- frontplane and backplane enables
      LCD_PENL.PEN := [
         7      => True, -- P7
         8      => True, -- P8
         10     => True, -- P10
         11     => True, -- P11
         17     => True, -- P17
         18     => True, -- P18
         19     => True, -- P19
         others => False
         ];
      LCD_PENH.PEN := [
         37     => True, -- P37
         38     => True, -- P38
         40     => True, -- P40
         52     => True, -- P52
         53     => True, -- P53
         others => False
         ];
      LCD_BPENL.BPEN := [
         18     => True, -- P18 COM3
         19     => True, -- P19 COM2
         others => False
         ];
      LCD_BPENH.BPEN := [
         40     => True, -- P40 COM0
         52     => True, -- P52 COM1
         others => False
         ];
      -- setup LCD pins
      for Idx1 in 0 .. 15 loop
         for Idx2 in 0 .. 3 loop
            LCD_WF (Idx1).WF (Idx2) := (others => False);
         end loop;
      end loop;
      LCD_WF (10).WF (0) := (A | E => True, others => False); -- PIN40 (COM0) phases A, E
      LCD_WF (13).WF (0) := (B | F => True, others => False); -- PIN52 (COM1) phases B, F
      LCD_WF (4).WF (3) := (C | G => True, others => False); -- PIN19 (COM2) phases C, G
      LCD_WF (4).WF (2) := (D | H => True, others => False); -- PIN18 (COM3) phases D, H
      -- enable
      LCD_GCR.PADSAFE := False;
      LCD_GCR.LCDEN := True;
   end Init;

end LCD;
