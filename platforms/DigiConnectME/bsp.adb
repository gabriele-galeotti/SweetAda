-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Configure;
with Definitions;
with Bits;
with NETARM;
with Console;

package body BSP is

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

   procedure Console_Putchar (C : in Character) is
   begin
      -- wait for transmitter available
      loop
         exit when NETARM.SCSR.TXRDY;
      end loop;
      NETARM.SCFIFOR.DATA (0) := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      NETARM.SCSR.RXBC := True;
      -- wait for receiver available
      loop
         exit when NETARM.SCSR.RXRDY;
      end loop;
      Data := NETARM.SCFIFOR.DATA (0);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      --- Serial Channel A ----------------------------------------------------
      -- FXTAL = 18.432 MHz/ 5 = 3.6864 MHz
      -- 16X mode, 9600 8N1
      -- NREG * 16 = FXTAL / [2 * (N + 1)] --> NREG = 11 @ 9600 bps
      NETARM.SCBRGR.CLKMUX := NETARM.BRG_FXTALE;
      NETARM.SCBRGR.TMODE  := NETARM.TMODE_16X;
      NETARM.SCBRGR.NREG   := 11;
      NETARM.SCCRA.ERXDSR  := False;
      NETARM.SCCRA.ERXRI   := False;
      NETARM.SCCRA.ERXDCD  := False;
      NETARM.SCCRA.ERXDMA  := False;
      NETARM.SCCRA.ERXBC   := False;
      NETARM.SCCRA.ERXHALF := False;
      NETARM.SCCRA.ERXDRDY := False;
      NETARM.SCCRA.ERXORUN := False;
      NETARM.SCCRA.ERXPE   := False;
      NETARM.SCCRA.ERXFE   := False;
      NETARM.SCCRA.ERXBRK  := False;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print (Configure.PLATFORM, NL => True);
      Console.Print (NETARM.SSR,          Prefix => "System Status: ", NL => True);
      Console.Print (NETARM.PLL_Settings, Prefix => "PLL Settings:  ", NL => True);
      Console.Print (NETARM.PLL_Control,  Prefix => "PLL Control:   ", NL => True);
      Console.Print (NETARM.MMCR,         Prefix => "MMCR:          ", NL => True);
      Console.Print (NETARM.CSBAR0,       Prefix => "CSBAR0:        ", NL => True);
      Console.Print (NETARM.CSOR0A,       Prefix => "CSOR0A:        ", NL => True);
      Console.Print (NETARM.CSOR0B,       Prefix => "CSOR0B:        ", NL => True);
      Console.Print (NETARM.CSBAR1,       Prefix => "CSBAR1:        ", NL => True);
      Console.Print (NETARM.CSOR1A,       Prefix => "CSOR1A:        ", NL => True);
      Console.Print (NETARM.CSOR1B,       Prefix => "CSOR1B:        ", NL => True);
      -------------------------------------------------------------------------
      Console.Print (NETARM.SCBRGR.EBIT,                 Prefix => "EBIT:   ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.TMODE),  Prefix => "TMODE:  ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.CLKMUX), Prefix => "CLKMUX: ", NL => True);
      Console.Print (Unsigned_16 (NETARM.SCBRGR.NREG),   Prefix => "NREG:   ", NL => True);
      --- RJ45 LED port enable ------------------------------------------------
      declare
         Value : Unsigned_32;
      begin
         Value := NETARM.PORTC;
         Value := Value and 16#BFFF_BFFF#; -- C6 CMODE = 0, C6 CSF = 0
         Value := Value or 16#0040_0000#;  -- C6 CDIR = 1 (OUT)
         NETARM.PORTC := Value;
      end;
      -- unlock Flash memory WP -----------------------------------------------
      NETARM.CSBAR0 := NETARM.CSBAR0 and 16#FFFF_FFFD#;
   end Setup;

end BSP;
