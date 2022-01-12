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
with MMIO;
with SPARC;
with Sun4m;
with Exceptions;
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
   use Sun4m;

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
      SCC.TX (SCC_Descriptor, SCC.CHANNELA, To_U8 (C)); -- serial port "A"
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
      -------------------------------------------------------------------------
      -- Exceptions.Init;
      -- TBR_Set (To_Address (0));
      SCC_Descriptor.Base_Address   := To_Address (SCC_BASEADDRESS);
      SCC_Descriptor.AB_Address_Bit := 2;
      SCC_Descriptor.CD_Address_Bit := 1;
      SCC_Descriptor.Baud_Clock     := 4_915_200;
      SCC_Descriptor.Read_8         := MMIO.Read'Access;
      SCC_Descriptor.Write_8        := MMIO.Write'Access;
      SCC.Init (SCC_Descriptor, SCC.CHANNELA);
      SCC.Init (SCC_Descriptor, SCC.CHANNELB);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("SPARCstation 5", NL => True);
      Console.Print (Natural (Nwindows), Prefix => "Nwindows: ", NL => True);
      Console.Print (QEMU, Prefix => "QEMU: ", NL => True);
      -------------------------------------------------------------------------
      Tclk_Init;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
