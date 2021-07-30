-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lcd.adb                                                                                                   --
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

with Bits;
with S5D9;

package body LCD is

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
   -- connected to SCI, simple SPI, at PORT 1 (SCI0)
   -- IM[3:0] = 1110, 4-wire 8-bit data serial interface II, SDI: In SDO: Out
   -- MCU name     schematic
   -- RESX         RESET   LCD_RESET --> pin 101 P6_10
   -- CSX          /CS     LCD_CS    --> pin 102 P6_11
   -- D/CX (SCL)   RS      LCD_SCK   --> pin 130 P1_2
   -- WRX (D/CX)   /WR     LCD_WR    --> pin 96  P1_15 (selector command/parameter)
   -- SDI/SDA      DIN_SDA LCD_MOSI  --> pin 131 P1_1
   -- SDO          SDO     LCD_MISO  --> pin 132 P1_0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      Delay_Count : constant := 10_000_000;
   begin
      -- configure simple SPI on SCI0
      -- 34.8 Operation in Simple SPI Mode
      -- Figure 34.32 Example flow of SCI initialization in clock synchronous mode with non-FIFO selected
      SCI (0).SCR := (CKE10 => CKE_Sync_Int_CLK, others => False); -- disable TE/RE
      SCI (0).FCR.FM := False;
      SCI (0).SMR.NORMAL := (
                             CKS10 => SMR_CKS_PCLKA4, -- n=1 -> CKS = 1
                             MP    => False,
                             STOP  => SMR_STOP_1,
                             PM    => SMR_PM_EVEN,
                             PE    => False,
                             CHR   => CHR_8.CHR,
                             CM    => SMR_CM_SYNC
                            );
      SCI (0).SCMR := (
                       SMIF      => False,
                       Reserved1 => Bits.Bits_1_1,
                       SINV      => SCMR_SINV_NO,
                       SDIR      => SCMR_SDIR_LSB,
                       CHR1      => CHR_8.CHR1,
                       Reserved2 => Bits.Bits_2_1,
                       BCP2      => 1
                      );
      -- simple SPI on port 1: SCI0: MISO0, MOSI0, SCK0
      PFSR (P100).PMR  := True;
      PFSR (P100).PSEL := PSEL_SCI1;
      PFSR (P101).PMR  := True;
      PFSR (P101).PSEL := PSEL_SCI1;
      PFSR (P102).PMR  := True;
      PFSR (P102).PSEL := PSEL_SCI1;
      -- GPIO on port 1: D/CX
      PFSR (P115).PMR  := False;
      -- LCD_RESET active low
      PFSR (P610).PMR := False;
      PORT (6).PDR.PDR10 := True;
      PORT (6).PODR.PODR10 := True;
      -- LCD_CS active low
      PFSR (P611).PMR := False;
      PORT (6).PODR.PODR11 := False;
      -- reset
      PORT (6).PODR.PODR10 := False;
      for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
      PORT (6).PODR.PODR10 := True;
   end Init;

end LCD;
