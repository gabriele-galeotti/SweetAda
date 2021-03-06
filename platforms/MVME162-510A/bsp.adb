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
with Interfaces;
with Bits;
with MMIO;
with MVME162FX;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;
   use MVME162FX;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      SCC.TX (SCC_Descriptor, SCC.CHANNELA, To_U8 (C));
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
      -- SCC ------------------------------------------------------------------
      SCC_Descriptor.Base_Address             := To_Address (SCC_BASEADDRESS);
      SCC_Descriptor.AB_Address_Bit           := 2;                            -- address bit2 --> A//B channel selector
      SCC_Descriptor.CD_Address_Bit           := 1;                            -- address bit1 --> D//C data/command selector
      SCC_Descriptor.Baud_Clock               := 10_000_000; -- __FIX__
      SCC_Descriptor.Flags.MVME162FX_TX_Quirk := True;
      SCC_Descriptor.Read_8                   := MMIO.Read'Access;
      SCC_Descriptor.Write_8                  := MMIO.Write'Access;
      SCC.Init (SCC_Descriptor, SCC.CHANNELA);
      SCC.Init (SCC_Descriptor, SCC.CHANNELB);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("MVME162-510A", NL => True);
      Console.Print (MMIO.Read_U8 (MC2.ID'Address), Prefix => "MC2 ID      : ", NL => True);
      Console.Print (MMIO.Read_U8 (MC2.Revision'Address), Prefix => "MC2 Revision: ", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;
