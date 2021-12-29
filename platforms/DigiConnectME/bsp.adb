-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Configure;
with Bits;
with MMIO;
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
      Delay_Count : constant := 30_000;
   begin
      MMIO.Write_U8 (To_Address (NETARM.SERTX), Bits.To_U8 (C));
      for Delay_Loop_Count in 1 .. Delay_Count loop null; end loop;
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      --- Serial Channel A ----------------------------------------------------
      -- FXTAL = 18.432 MHz/ 5 = 3.6864 MHz
      -- 16X mode, 9600 8N1
      -- NREG * 16 = FXTAL / [2 * (N + 1)] --> NREG = 11 @ 9600 bps
      NETARM.SCBRGR.CLKMUX := NETARM.BRG_FXTALE;
      NETARM.SCBRGR.TMODE  := NETARM.TMODE_16X;
      NETARM.SCBRGR.NREG   := 11;
      --- RJ45 LED port enable ------------------------------------------------
      declare
         Value : Unsigned_32;
      begin
         Value := NETARM.PORTC;
         Value := Value and 16#BFFF_BFFF#; -- C6 CMODE = 0, C6 CSF = 0
         Value := Value or 16#0040_0000#;  -- C6 CDIR = 1 (OUT)
         NETARM.PORTC := Value;
      end;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
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
      declare
         Data32 : Unsigned_32 with Unreferenced => True;
         Data8  : Unsigned_8 with Unreferenced => True;
      begin
         -- unlock Flash memory WP
         NETARM.CSBAR0 := NETARM.CSBAR0 and 16#FFFF_FFFD#;
      end;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
