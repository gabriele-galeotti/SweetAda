-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Configure;
with Bits;
with SH7750;
with MMIO;
with Dreamcast;
with Exceptions;
with IOEMU;
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
   use Bits;
   use SH7750;

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
         exit when SCIF.SCFDR2.T < 16#10#;
      end loop;
      SCIF.SCFTDR2 := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when SCIF.SCFDR2.R > 0;
      end loop;
      Data := SCIF.SCFRDR2;
      SCIF.SCFSR2.RDF := False;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- enable SCIF RX/TX ----------------------------------------------------
      SCIF.SCSCR2 := (
                      CKE1   => CKE1_Internal,
                      REIE   => False,
                      RE     => True,
                      TE     => True,
                      RIE    => False,
                      TIE    => False,
                      others => <>
                     );
      SCIF.SCFCR2 := (
                      LOOPBACK => False,
                      RFRST    => False,
                      TFRST    => False,
                      MCE      => False,
                      TTRG     => TTRG_1,
                      RTRG     => RTRG_1,
                      RSTRG    => 0,
                      others   => 0
                     );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      if Configure.GXEMUL = "Y" then
         Console.Print ("Dreamcast (GXemul emulator)", NL => True);
      else
         Console.Print ("Dreamcast", NL => True);
      end if;
      Console.Print (Dreamcast.Video_Font, Prefix => "ROM font @ ", NL => True);
      -------------------------------------------------------------------------
      if True then
         declare
            Cable       : constant Dreamcast.Video_Cable_Type := Dreamcast.Video_Cable;
            S_VGA       : aliased constant String := "VGA";
            S_NONE      : aliased constant String := "NONE";
            S_RGB       : aliased constant String := "RGB";
            S_COMPOSITE : aliased constant String := "COMPOSITE";
            S           : access constant String;
         begin
            case Cable is
               when Dreamcast.CABLE_VGA       => S := S_VGA'Access;
               when Dreamcast.CABLE_NONE      => S := S_NONE'Access;
               when Dreamcast.CABLE_RGB       => S := S_RGB'Access;
               when Dreamcast.CABLE_COMPOSITE => S := S_COMPOSITE'Access;
            end case;
            Console.Print ("Video cable: ", NL => False);
            Console.Print (S.all, NL => True);
         end;
      end if;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
