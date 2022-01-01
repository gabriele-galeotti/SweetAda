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
   use Exceptions;

   function SCIF_SCFDR2_Read return Unsigned_16 with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SCIF_SCFDR2_Read
   ----------------------------------------------------------------------------
   function SCIF_SCFDR2_Read return Unsigned_16 is
   begin
      return MMIO.Read_U16 (SCIF.SCFDR2'Address);
   end SCIF_SCFDR2_Read;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      loop
         exit when SCIF.SCFDR2.T < 16#10#;
      end loop;
      SCIF.SCFTDR2 := To_U8 (C);
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
      -- enable SCIF transmitter ----------------------------------------------
      SCIF.SCSCR2.TE := True;
      UART1_Descriptor.Base_Address  := To_Address (IOEMU.IOEMU_SERIALPORT1_BASEADDRESS);
      UART1_Descriptor.Scale_Address := 2;
      UART1_Descriptor.Irq           := 0; -- enable if /= 0
      UART1_Descriptor.Read          := MMIO.Read'Access;
      UART1_Descriptor.Write         := MMIO.Write'Access;
      UARTIOEMU.Init (UART1_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      if Configure.GXEMUL = "Y" then
         Console.Print ("Dreamcast (GXemul emulator)", NL => True);
      else
         Console.Print ("Dreamcast", NL => True);
      end if;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
