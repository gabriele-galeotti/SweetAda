-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with System.Storage_Elements;
with Configure;
with Definitions;
with Bits;
with NETARM;
with Console;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use NETARM;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop exit when SCSR.TXRDY; end loop;
      SCFIFOR.DATA (0) := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      SCSR.RXBC := True;
      -- wait for receiver available
      loop exit when SCSR.RXRDY; end loop;
      Data := SCFIFOR.DATA (0);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      --- Serial Channel A ----------------------------------------------------
      -- FXTAL = 18.432 MHz/ 5 = 3.6864 MHz
      -- 16X mode, 9600 8N1
      -- NREG * 16 = FXTAL / [2 * (N + 1)] --> NREG = 11 @ 9600 bps
      SCBRGR.CLKMUX := BRG_FXTALE;
      SCBRGR.TMODE  := TMODE_16X;
      SCBRGR.NREG   := 11;
      SCCRA.ERXDSR  := False;
      SCCRA.ERXRI   := False;
      SCCRA.ERXDCD  := False;
      SCCRA.ERXDMA  := False;
      SCCRA.ERXBC   := False;
      SCCRA.ERXHALF := False;
      SCCRA.ERXDRDY := False;
      SCCRA.ERXORUN := False;
      SCCRA.ERXPE   := False;
      SCCRA.ERXFE   := False;
      SCCRA.ERXBRK  := False;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print (Configure.PLATFORM, NL => True);
      Console.Print (Prefix => "System Status: ", Value => SSR, NL => True);
      Console.Print (Prefix => "PLL Settings:  ", Value => PLL_Settings, NL => True);
      -- Console.Print (Prefix => "PLL Control:   ", Value => PLL_Control, NL => True);
      Console.Print (Prefix => "MMCR:          ", Value => MMCR, NL => True);
      Console.Print (Prefix => "CSBAR0:        ", Value => CSBAR0, NL => True);
      Console.Print (Prefix => "CSOR0A:        ", Value => CSOR0A, NL => True);
      Console.Print (Prefix => "CSOR0B:        ", Value => CSOR0B, NL => True);
      Console.Print (Prefix => "CSBAR1:        ", Value => CSBAR1, NL => True);
      Console.Print (Prefix => "CSOR1A:        ", Value => CSOR1A, NL => True);
      Console.Print (Prefix => "CSOR1B:        ", Value => CSOR1B, NL => True);
      -------------------------------------------------------------------------
      Console.Print (Prefix => "EBIT:   ", Value => SCBRGR.EBIT, NL => True);
      Console.Print (Prefix => "TMODE:  ", Value => Unsigned_16 (SCBRGR.TMODE), NL => True);
      Console.Print (Prefix => "CLKMUX: ", Value => Unsigned_16 (SCBRGR.CLKMUX), NL => True);
      Console.Print (Prefix => "NREG:   ", Value => Unsigned_16 (SCBRGR.NREG), NL => True);
      -- unlock Flash memory WP -----------------------------------------------
      CSBAR0 := @ and 16#FFFF_FFFD#;
   end Setup;

end BSP;
